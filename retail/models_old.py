import os


from django.contrib.auth.models import User
from django.db import models
from django.db.models import ForeignKey, Sum
from django.utils import timezone
from sympy.logic.inference import valid

import admin_panel.models
from admin_panel.models import Locations
from blog.anton import make_md5

from ocean import settings
from ocean.settings import DEBUG



# CLERKS
class Clerk(models.Model):
    location = models.ForeignKey('admin_panel.Locations', on_delete=models.CASCADE)
    first_name = models.TextField()
    last_name = models.TextField()
    phone = models.CharField(max_length=10, unique=True, null=False)
    code = models.CharField(max_length=4, unique=True, null=False)
    pword = models.TextField()
    img = models.ImageField(upload_to='static/uploads/clerks/', default='static/general/img/users/default.png')

    flag_dwn = models.IntegerField(default=1)
    flag_disable = models.IntegerField(default=0)

    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)

    def name(self):
        return f"{self.first_name} {self.last_name}"


class BoltGroups(models.Model):
    name = models.CharField(unique=True, max_length=266)

    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)

    entity = models.ForeignKey(admin_panel.models.BusinessEntityTypes, on_delete=models.CASCADE, null=False, blank=False,related_name='bolt_groups')


    def items(self):
        return BoltItems.objects.filter(group=self)



class BoltSubGroups(models.Model):
    name = models.CharField(unique=False, max_length=266)
    group = models.ForeignKey(BoltGroups, on_delete=models.CASCADE)

    entity = models.ForeignKey(admin_panel.models.BusinessEntityTypes, on_delete=models.CASCADE, null=False, blank=False)

    class Meta:
        unique_together = ('group', 'name','entity')


class BoltItems(models.Model):
    menu = models.ForeignKey(admin_panel.models.BusinessEntityTypes,on_delete=models.SET_NULL,null=True,blank=True)
    product = models.OneToOneField('Products', on_delete=models.CASCADE,null=True)
    price = models.DecimalField(max_digits=10, decimal_places=3,default=0.000)

    group = models.ForeignKey(BoltGroups, on_delete=models.CASCADE)
    subgroup = models.ForeignKey(BoltSubGroups, on_delete=models.CASCADE)

    stock_nia = models.IntegerField(null=False, blank=False)
    stock_spintex = models.IntegerField(null=False, blank=False)
    stock_osu = models.IntegerField(null=False, blank=False)

    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)

    is_sync = models.BooleanField(default=False)
    group_changed = models.BooleanField(default=False)

    exp_date = models.DateField(null=True, blank=True,default=timezone.now().date())
    is_expired = models.BooleanField(default=False)
    exp_flag = models.BooleanField(default=False)

    hide_reasons = [
        ('N',"NOT HIDDEN"),
        ('OUT',"STOCK OUT"),
        ('EXP',"EXPIRED")
    ]
    is_hidden = models.BooleanField(default=False)
    hide_reason = models.CharField(max_length=3, choices=hide_reasons,default="N")
    chng = models.BooleanField(default=False)
    exp_last_check = models.DateTimeField(null=True,blank=True)
    stock_last_check = models.DateTimeField(null=True,blank=True)

    image = models.ImageField(upload_to='static/uploads/dolphine/bolt/', null=True,default='static/uploads/dolphine/bolt/default.png')
    description = models.TextField(null=True,blank=True)



    def hdst(self):
        if self.is_hidden is False:
            return "Active"
        else:
            return "Hidden"


    def obj(self):
        return {
            "product":self.product.obj(),
            'group':self.group.name,
            'subgroup':self.subgroup.name,
            'is_expired':self.is_expired,
            'exp_date':self.exp_date,
        }

    def last_check(self):
        if self.hide_reason == "EXP":
            return self.exp_last_check
        if self.hide_reason == 'OUT':
            return self.hide_reason
        else: 
            return ""
    def img_url(self):
        if self.image and hasattr(self.image, 'url'):
            evidence_url = self.image.url
        else:
            evidence_url = '/static/uploads/dolphine/bolt/default.png'


    def stock(self):
        obj = {}
        # from retail.db import get_stock
        # stk = get_stock(self.product.code)
        # obj['nia'] = stk['nia']
        # obj['spintex'] = stk['spintex']
        # obj['osu'] = stk['osu']
        
        return obj





class ProductSupplier(models.Model):
    code = models.CharField(unique=True, max_length=60)
    name = models.CharField(unique=True, max_length=60)
    person = models.TextField()
    phone = models.TextField()
    email = models.TextField()
    city = models.TextField()
    country = models.TextField()
    created_on = models.DateTimeField(auto_now_add=True)
    entity = models.ForeignKey(admin_panel.models.BusinessEntityTypes,on_delete=models.SET_NULL,null=True,blank=True )

    class Meta:
        unique_together = (('code','entity'),)

    def obj(self):
        return {
            'code':self.code,
            'name':self.name
        }

class ProductGroup(models.Model):
    code = models.CharField(unique=False, max_length=10, null=False, blank=False)
    name = models.CharField(unique=False, max_length=60)
    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)

    entity = models.ForeignKey(admin_panel.models.BusinessEntityTypes, on_delete=models.SET_NULL, null=True, blank=True)

    class Meta:
        unique_together = (('code','entity'),('name','entity'),)

    def subgroups(self):
        return ProductSubGroup.objects.filter(group=self)


class ProductSubGroup(models.Model):
    group = models.ForeignKey(ProductGroup, on_delete=models.CASCADE)
    code = models.CharField(unique=False, max_length=10)
    name = models.CharField(unique=False, max_length=60)
    created_on = models.DateTimeField(auto_now_add=True)
    entity = models.ForeignKey(admin_panel.models.BusinessEntityTypes, on_delete=models.SET_NULL, null=True, blank=True)

    def products(self):
        return Products.objects.filter(subgroup=self)

    class Meta:
        unique_together = (('group', 'code','entity'),)


class Products(models.Model):
    subgroup = models.ForeignKey(ProductSubGroup, on_delete=models.CASCADE)
    code = models.CharField(unique=False, max_length=60)
    barcode = models.CharField(unique=False, max_length=100, null=False, blank=False)
    name = models.CharField(unique=False, max_length=100)
    price = models.DecimalField(decimal_places=3, max_digits=60)
    stock_monitor = models.BooleanField(default=False)
    image = models.ImageField(upload_to='static/uploads/dolphine/bolt/', null=True,
                              default='static/uploads/dolphine/bolt/default.png')
    allowed_on_bolt = models.BooleanField(default=True)
    shelf = models.IntegerField(default=0)
    entity = models.ForeignKey(admin_panel.models.BusinessEntityTypes, on_delete=models.SET_NULL, null=True, blank=True)

    is_butch = models.BooleanField(default=False)
    barcodes = models.TextField(null=True, blank=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        unique_together = (('subgroup', 'code','entity'),)

    def cardex(self):
        arr = []
        for move in ProductMoves.objects.filter(product_id=self.pk):
            arr.append(move.obj())

        print(arr)
        return arr

    def obj(self,date=timezone.now().date()):
        from retail.db import stock_by_moved
        image_url = "none"
        if BoltItems.objects.filter(product=self).exists():
            image_url = BoltItems.objects.filter(product=self).first().image.url if BoltItems.objects.filter(product=self).first().image else 'static/uploads/dolphine/bolt/default.png'
        else:
            image_url = self.image.url if self.image else 'static/uploads/dolphine/bolt/default.png'
        return {
            'pk':self.pk,
            'name':self.name,
            'barcode':self.barcode,
            'price':self.price,
            'stock_monitor':self.stock_monitor,
            'image':image_url,
            'next':Products.objects.filter(pk__gt=self.pk,entity=self.entity).first().pk if Products.objects.filter(pk__gt=self.pk,entity=self.entity).exists() else 0,
            'previous': Products.objects.filter(pk__lt=self.pk,entity=self.entity).last().pk if Products.objects.filter(pk__lt=self.pk,entity=self.entity).exists() else 0,
            'stock':stock_by_moved(self.pk,'*'),
            'shelf':self.shelf,
            'moves':self.moves(date),
            'cardex':[],
            'group':self.subgroup.group.name,
            'subgroup':self.subgroup.name,
            'is_on_bolt':self.is_on_bolt(),
            'sold':0,
            'status': "Active" if self.is_active else "Inactive",
        }

    def is_on_bolt(self):

        if BoltItems.objects.filter(product=self).exists():
            return True
        else:
            return False

    def live_stock(self):
        from retail.db import get_stock
        return get_stock(self.code) if DEBUG is False else {}

    def moves(self,date=timezone.now().date()):
        obj = {}
        # for choice in ProductMoves.move_type_choices:
        #     choice_type = choice[0]
        #     if ProductMoves.objects.filter(product=self, date=date,move_type=choice_type).exists():
        #         val = ProductMoves.objects.filter(move_type=choice_type, date=date, product_id=self.pk).aggregate(
        #             sum=Sum('quantity'))['sum'] if ProductMoves.objects.filter(move_type=choice_type,
        #                                                                        date=date).exists() else 0
        #         if val == 'null':
        #             val = 0
        #
        #
        #         obj[choice_type] = f"{val:.2f}"
        #
        #     else:
        #         choice_type = choice[0]
        #
        #         try:
        #             val = 0
        #             obj[choice_type] = f"{val:.2f}"
        #         except Exception as e:
        #             pass

        return obj

    def stock(self):
        arr = []
        for location in Locations.objects.all():
            code = location.code
            loc_stock = Stock.objects.filter(product=self, location=location.code).aggregate(sum=Sum('quantity'))[
                'sum'] if Stock.objects.filter(product=self, location=location.code).exists() else 0
            arr.append({'loc_code': code, 'loc_name': location.descr, 'barcode': self.barcode, 'item_name': self.name,
                        'stock': loc_stock})
        return arr


class Barcode(models.Model):
    product = models.ForeignKey(Products, on_delete=models.CASCADE,related_name='barcode_of_barcodes')
    barcode = models.CharField(max_length=100, unique=True,verbose_name='Barcodefsome_codes')

class Stock(models.Model):
    product = models.ForeignKey(Products, on_delete=models.CASCADE)
    location = models.ForeignKey(Locations, on_delete=models.CASCADE)
    quantity = models.DecimalField(decimal_places=2, max_digits=10, default=0.00)

class RawStock(models.Model):
    loc_id = models.CharField(max_length=3, unique=False, null=False, blank=False)
    prod_id = models.CharField(max_length=20)
    qty = models.DecimalField(decimal_places=3, max_digits=60)

    created_on = models.DateTimeField(auto_now_add=True)

    # class Meta:
    #     unique_together = (('loc_id', 'prod_id'),)



class ProductMoves(models.Model):
    line_no = models.IntegerField()
    location = models.ForeignKey(Locations, on_delete=models.CASCADE, null=False, blank=False)
    product = models.ForeignKey(Products, on_delete=models.CASCADE)
    ref = models.CharField(max_length=100, null=False, blank=False)
    move_type_choices = [
        ('OB','Opening Balance'),
        ('GR','Goods Received'),
        ('TR','Transfer'),
        ('AD','Adjusted'),
        ('CL','Closing Balance'),
        ('PR','Purchase Receipt'),
        ('SIP','Sales Invoice'),
        ('SO','Sales Order'),
        ('CR','Credit Note'),
        ('DB','Debit Note'),
        ('CB','Closing Balance'),
        ("SR","STOCK RESET"),
        ("SRT","SALES RETURN"),
        ("PRT", "PURCHASE RETURN"),
        ("PI", "POS SALES"),
        ("IN", "INVOICE"),
    ]
    move_type = models.CharField(max_length=3, choices=move_type_choices,null=False,blank=False)
    quantity = models.DecimalField(decimal_places=3, max_digits=60)
    date = models.DateField(null=False, blank=False,default=timezone.now().date())
    time = models.TimeField(null=False, blank=False,auto_now=True)
    remark = models.TextField(null=True, blank=True)

    class Meta:
        unique_together = (('product', 'location','line_no','quantity','ref'),)

    def obj(self):
        return {
            "location":{
                "code":self.location.code,
                "name":self.location.descr,
            },
            "ref":self.ref,
            "qty":self.quantity,
            "date":self.date,
            "time":self.time,
            "remark":self.remark,
            "move_type":self.move_type
        }

    def day_data(self,target_date=timezone.now().date()):
        # loop through choices
        arr = {}

        for choice in self.move_type_choices:
            # get choice type

            choice_type = choice[0]
            # get sum of quantity base on dat and update arr
            arr[choice_type] = ProductMoves.objects.filter(move_type=choice_type,date=target_date,product=self.product).aggregate(sum=Sum('quantity'))['sum'] if ProductMoves.objects.filter(move_type=choice_type,date=target_date).exists() else 0
        return arr

class MoveStock(models.Model):
    product = models.ForeignKey(Products, on_delete=models.CASCADE)
    location = models.CharField(max_length=100, null=False, blank=False)
    quantity = models.DecimalField(decimal_places=2, max_digits=10, default=0.00)

    class Meta:
        unique_together = (('product', 'location'),)


class StockMonitor(models.Model):
    product = models.ForeignKey(Products, on_delete=models.CASCADE)
    location = models.CharField(max_length=3, null=False, blank=False)
    stock_qty = models.DecimalField(decimal_places=2, max_digits=10, default=0.00)

    valid = models.BooleanField(default=False)

    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = (('product', 'location'),)

    def obj(self):
        return {
            'name': self.product.name.strip(),
            'barcode': self.product.barcode.strip(),
            'location': self.location,
            'stock': self.product.stock(),
            'valid': self.valid
        }


class RecipeGroup(models.Model):
    name = models.CharField(null=False, blank=False, unique=True, max_length=100)
    is_open = models.BooleanField(default=True)

    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    def products(self):
        return RecipeProduct.objects.filter(group=self)

    class Meta:
        unique_together = (('name', 'owner'),)


class RecipeProduct(models.Model):
    group = ForeignKey(RecipeGroup, on_delete=models.CASCADE)
    name = models.CharField(null=False, blank=False, max_length=60)
    barcode = models.TextField(null=False, blank=False)
    si_unit = models.TextField(null=False, blank=False)

    is_open = models.BooleanField(default=True)

    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    image = models.ImageField(upload_to='static/uploads/retail/products/', default='static/recipe_card/recipe.png')

    class Meta:
        unique_together = (('name', 'owner', 'group'),)

    def recipe_items(self):
        return Recipe.objects.filter(product=self).count()

    def recipe(self):
        return Recipe.objects.filter(product=self)

    def img_url(self):
        if self.image and hasattr(self.image, 'url'):
            evidence_url = self.image.url

            # Check if the file actually exists
            if os.path.exists(self.image.path):
                return evidence_url
            else:
                # Return a default URL if the file doesn't exist
                return '/static/recipe_card/recipe.png'
        else:
            # Return a default URL if no evidence is provided
            return '/static/recipe_card/recipe.png'

    def next(self):
        val = 0
        if RecipeProduct.objects.filter(pk__gt=self.pk).exists():
            val = RecipeProduct.objects.filter(pk__gt=self.pk).first().pk

        return val

    def prev(self):
        val = 0
        if RecipeProduct.objects.filter(pk__lt=self.pk).exists():
            val = RecipeProduct.objects.filter(pk__lt=self.pk).last().pk

        return val


class Recipe(models.Model):
    product = models.ForeignKey(RecipeProduct, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    quantity = models.TextField(default=0.00)
    si_unit = models.TextField(null=False, blank=False)

    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)

    class Meta:
        unique_together = (('name', 'owner', 'product'),)


class StockHd(models.Model):
    loc = models.ForeignKey(Locations, on_delete=models.CASCADE)
    ref_no = models.CharField(max_length=10, unique=True, null=False, blank=False)
    date_kept = models.CharField(max_length=100, null=False, blank=False)
    remarks = models.TextField()
    is_group = models.BooleanField(default=False)
    st_grp = models.IntegerField()
    end_grp = models.IntegerField()

    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)



class ButchSales(models.Model):
    location = models.ForeignKey(Locations, on_delete=models.CASCADE)
    barcode = models.CharField(max_length=20)
    quantity = models.DecimalField(decimal_places=3, max_digits=10, default=0.00)
    is_checked = models.BooleanField(default=False)

    date_added = models.DateTimeField(auto_now_add=True)

    def obj(self):
        return {
            'location':self.location.descr,
            'barcode':self.barcode,
            'quantity':self.quantity,
            'date_added':self.date_added,
        }

class ButcheryLiveTransactions(models.Model):
    butch_log = models.ForeignKey(ButchSales, on_delete=models.SET_NULL, null=True)
    bill_no = models.IntegerField()
    bill_ref = models.CharField(max_length=200)
    barcode = models.CharField(max_length=20)
    name = models.CharField(max_length=100)
    quantity = models.DecimalField(decimal_places=3, max_digits=10, default=0.00)
    time = models.TimeField()

    class Meta:
        unique_together = (('bill_ref','barcode','quantity'),)



class StockToSend(models.Model):
    location = models.ForeignKey(Locations,on_delete=models.CASCADE)
    item_code = models.CharField(max_length=255)
    barcode = models.CharField(max_length=255)
    name = models.CharField(max_length=255)

    last_transfer_entry = models.CharField(max_length=20)
    last_transfer_date = models.CharField(max_length=20)
    last_transfer_quantity = models.DecimalField(decimal_places=3,default=0.00,max_digits=10)

    sold_quantity = models.DecimalField(decimal_places=3,default=0.00,max_digits=10)
    cust_sold = models.DecimalField(decimal_places=3,default=0.00,max_digits=10)
    percentage_sold = models.DecimalField(decimal_places=3,default=0.00,max_digits=10)
    healthy = models.BooleanField(default=False)

    # def sold_2_weeks(self):
    #     today = timezone.now().date()
    #     two_weeks_ago = today - timezone.timedelta(days=7)
    #     print(two_weeks_ago,"TO",today)
    #
    #     return RetailSales.objects.filter(item_code=self.item_code,bill_date__range=(two_weeks_ago,today)).aggregate(Sum('tran_qty'))['tran_qty__sum']

    def obj(self):
        return {
            'location':self.location.descr,
            'itemcode':self.item_code,
            'barcode':self.barcode,
            'name':self.name,
            'last_transfer':self.last_transfer_entry,
            'last_transfer_date':self.last_transfer_date,
            'last_transfer_quantity':self.last_transfer_quantity,
            'sold_qty':self.sold_quantity,
            'percentage_sold':self.percentage_sold,
            'health':self.healthy
        }

    def html(self,line=1):
        text = ""

        return f"""
                    <tr class="${text}">
                            <td>{line}<input type="hidden" id="sold_{line}" value="{self.sold_quantity}"> </td>
                            <td><input type="checkbox" id="sel_{line}"></td>
                            <td>${self.location.descr}</td>
                            <td id="itemcode_{line}">{self.item_code}</td>
                            <td id="barcode_{line}">{self.barcode}</td>
                            <td>{self.name}</td>
                            <td>{self.last_transfer_entry} ({self.last_transfer_date})</td>
                            <td>{self.last_transfer_entry}</td>
                            <td>{self.sold_quantity} ({self.percentage_sold})</td>
                            <td>{self.healthy}</td>
                        </tr>
        """

    class Meta:
        unique_together = (('location','item_code'),)


class TranHd(models.Model):
    entry_no = models.CharField(max_length=10,unique=True)
    loc_fr = models.ForeignKey(Locations, on_delete=models.CASCADE,null=False,blank=False,related_name='loc_fr')
    loc_to = models.ForeignKey(Locations, on_delete=models.CASCADE, null=False, blank=False, related_name='loc_to')
    entry_date = models.DateTimeField()
    remark = models.TextField(null=True,blank=True)
    tot_amt = models.DecimalField(decimal_places=3, max_digits=10, default=0.000)
    tot_retail = models.DecimalField(decimal_places=3, max_digits=10, default=0.000)
    user_id = models.TextField()

class TranTr(models.Model):
    transfer = models.ForeignKey(TranHd, on_delete=models.CASCADE)
    line_no = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    barcode = models.CharField(max_length=20)
    item_code = models.CharField(max_length=20)
    item_descr = models.CharField(max_length=100)
    quantity = models.DecimalField(decimal_places=3, max_digits=10, default=0.000)
    packing = models.CharField(max_length=20)
    pack_qty = models.DecimalField(decimal_places=3, max_digits=10, default=0.000)
    total_qty = models.DecimalField(decimal_places=3, max_digits=10, default=0.000)

    class Meta:
        unique_together = (('transfer','line_no'),)



class RetailSales(models.Model):
    location = models.ForeignKey(Locations,models.CASCADE)
    bill_date = models.DateField()
    tran_time = models.TimeField()
    line_no = models.DecimalField(max_digits=10,decimal_places=3,default=0.000)
    bill_ref = models.CharField(max_length=200)
    barcode = models.CharField(max_length=20)
    item_code = models.CharField(max_length=20)
    name = models.CharField(max_length=255)
    tran_qty = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    unit_price = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    tran_amt = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)

    class Meta:
        unique_together = (('location','bill_date','tran_time','bill_ref','item_code','tran_qty'),)

    def obj(self):
        return {
            'loc_id':self.location.code,
            'loc_name':self.location.descr,
            'date':self.bill_date,
            'time':self.tran_time,
            'bill_ref':self.bill_ref,
            'item_code':self.item_code,
            'name':self.name,
            'tran_qty':self.tran_qty,
            'unit_price':self.unit_price,
            'tran_amt':self.tran_amt,
            'barcode':self.barcode

        }


class SampleHd(models.Model):
    location = models.ForeignKey(Locations,on_delete=models.CASCADE)
    bill_ref = models.CharField(max_length=30,unique=True,null=False,blank=False)
    owner = models.ForeignKey(User,on_delete=models.CASCADE)
    added_on = models.DateTimeField(auto_now_add=True)
    is_open = models.BooleanField(default=False)
    is_sync = models.BooleanField(default=False)
    ad = models.CharField(max_length=20,unique=True,null=True,blank=True)
    ad_sync = models.BooleanField(default=False)
    bill_refund_ref = models.CharField(max_length=30,unique=True,null=True,blank=True)


    def obj(self):
        bill_no = 0
        mech_no = 0
        if self.tran().count() > 0:
            bill_no = self.tran().last().bill_no
            mech_no = self.tran().last().mech_no
        return {
            'location':{
                'code':self.location.code,
                'name':self.location.descr
            },
            'bill_ref':self.bill_ref,
            'owner':self.owner.get_full_name(),
            'is_open':self.is_open,
            'is_sync':self.is_sync,
            'ad':self.ad,
            'mech_no':mech_no,
            'bill_no':bill_no,
            'date':self.added_on,
            'value':self.value(),
            'ref':self.bill_ref,
            'bill_refund_ref':self.bill_refund_ref,
            'bill_refund_no':0,
            'pk':self.pk
        }

    def tran(self):
        return SampleTran.objects.filter(sample=self)

    def value(self):
        return SampleTran.objects.filter(sample=self).aggregate(Sum('tran_amt'))['tran_amt__sum']

class SampleTran(models.Model):
    sample =models.ForeignKey(SampleHd,on_delete=models.CASCADE)
    barcode = models.CharField(max_length=20)
    item_name = models.CharField(max_length=20)
    mech_no = models.CharField(max_length=20)
    bill_no = models.CharField(max_length=20)
    tran_qty = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    unit_price = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    tran_amt = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)

    sync_on = models.DateTimeField(auto_now=True)


class BillHeader(models.Model):
    loc = models.ForeignKey(Locations,on_delete=models.CASCADE)
    bill_no = models.IntegerField()
    bill_ref = models.CharField(max_length=20,unique=True,null=False,blank=False)
    pay_mode = models.CharField(max_length=20)
    bill_date = models.DateField()
    bill_time = models.TimeField()
    bill_amt = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    class Meta:
        unique_together = (('loc','bill_ref'),)

    def transactions(self):
        pass 


class BillTrans(models.Model):
    bill = models.ForeignKey(BillHeader,on_delete=models.CASCADE)
    time = models.TimeField()
    product = models.ForeignKey(Products,on_delete=models.CASCADE)
    quantity = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    price = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)

    added_on = models.DateTimeField(auto_now=True)


    def obj(self):
        return {
            'pk':self.pk,
            'name':self.product.name,
            'barcode':self.product.barcode,
            'quantity':self.quantity,
            'price':self.price,
            'total':self.quantity * self.price,
            'time':self.time,
            'bill_no':self.bill.bill_no,
            'bill_ref':self.bill.bill_ref,
            'location':self.bill.loc.descr,
        }

    def transactions(self):
        pass


class StockFreezeHd(models.Model):
    loc = models.ForeignKey(Locations,on_delete=models.CASCADE)
    entry_no = models.CharField(max_length=20,unique=True,null=False,blank=False)
    remarks = models.TextField()
    frozen_date = models.DateTimeField()

    def obj(self):
        return {
            'pk':self.pk,
            'entry_no':self.entry_no,
            'remarks':self.remarks,
            'frozen_date':self.frozen_date,
            'loc':self.loc.descr,
            'counted':StockFreezeTrans.objects.filter(ref=self,is_counted=True).count(),
            'not_counted':StockFreezeTrans.objects.filter(ref=self,is_counted=False).count(),
        }

class StockFreezeTrans(models.Model):
    ref = models.ForeignKey(StockFreezeHd,on_delete=models.CASCADE)
    barcode = models.CharField(max_length=30)
    name = models.CharField(max_length=255)
    qty = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    retail = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    cost = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    counted = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    is_counted = models.BooleanField(default=False)

class StockFreezeCount(models.Model):
    ref = models.ForeignKey(StockFreezeHd,on_delete=models.CASCADE)
    barcode = models.CharField(max_length=30)
    quantity = models.DecimalField(decimal_places=3,max_digits=10,default=0.000)
    image = models.ImageField(upload_to='static/uploads/dolphine/stock_take/')
    counted_by = models.ForeignKey(User,on_delete=models.CASCADE)

    def img_url(self):
        if self.image and self.image.storage.exists(self.image.name):
            return self.image.url
        return None

    def obj(self):
        return {
            'pk':self.pk,
            'barcode':self.barcode,
            'quantity':self.quantity,
            'counted_by':self.counted_by.get_full_name(),
            'image':self.img_url(),
        }


