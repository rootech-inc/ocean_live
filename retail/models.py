import os


from django.contrib.auth.models import User
from django.db import models
from django.db.models import ForeignKey, Sum
from django.utils import timezone

from admin_panel.models import Locations
from blog.anton import make_md5

from ocean import settings


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

    def items(self):
        return BoltItems.objects.filter(group=self)


class BoltItems(models.Model):
    product = models.OneToOneField('Products', on_delete=models.CASCADE,null=True)
    price = models.DecimalField(max_digits=10, decimal_places=3,default=0.000)

    stock_nia = models.IntegerField(null=False, blank=False)
    stock_spintex = models.IntegerField(null=False, blank=False)
    stock_osu = models.IntegerField(null=False, blank=False)

    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)


class ProductSupplier(models.Model):
    code = models.CharField(unique=True, max_length=60)
    name = models.CharField(unique=True, max_length=60)
    person = models.TextField()
    phone = models.TextField()
    email = models.TextField()
    city = models.TextField()
    country = models.TextField()
    created_on = models.DateTimeField(auto_now_add=True)


class ProductGroup(models.Model):
    code = models.CharField(unique=True, max_length=10, null=False, blank=False)
    name = models.CharField(unique=True, max_length=60)
    created_on = models.DateTimeField(auto_now_add=True)
    edited_on = models.DateTimeField(auto_now=True)

    def subgroups(self):
        return ProductSubGroup.objects.filter(group=self)


class ProductSubGroup(models.Model):
    group = models.ForeignKey(ProductGroup, on_delete=models.CASCADE)
    code = models.CharField(unique=False, max_length=10)
    name = models.CharField(unique=False, max_length=60)
    created_on = models.DateTimeField(auto_now_add=True)

    def products(self):
        return Products.objects.filter(subgroup=self)

    class Meta:
        unique_together = (('group', 'code'),)


class Products(models.Model):
    subgroup = models.ForeignKey(ProductSubGroup, on_delete=models.CASCADE)
    code = models.CharField(unique=True, max_length=60)
    barcode = models.CharField(unique=True, max_length=100, null=False, blank=False)
    name = models.CharField(unique=False, max_length=100)
    price = models.DecimalField(decimal_places=3, max_digits=60)
    stock_monitor = models.BooleanField(default=False)


    def is_on_bolt(self):
        barcode = self.barcode.strip()
        if BoltItems.objects.filter(barcode=barcode).exists():
            return True
        else:
            return False

    def stock(self):
        arr = []
        for location in Locations.objects.all():
            code = location.code
            loc_stock = Stock.objects.filter(product=self, location=location.code).aggregate(sum=Sum('quantity'))[
                'sum'] if Stock.objects.filter(product=self, location=location.code).exists() else 0
            arr.append({'loc_code': code, 'loc_name': location.descr, 'barcode': self.barcode, 'item_name': self.name,
                        'stock': loc_stock})
        return arr


class RawStock(models.Model):
    loc_id = models.CharField(max_length=3, unique=False, null=False, blank=False)
    prod_id = models.CharField(max_length=20)
    qty = models.DecimalField(decimal_places=3, max_digits=60)

    created_on = models.DateTimeField(auto_now_add=True)

    # class Meta:
    #     unique_together = (('loc_id', 'prod_id'),)


class Stock(models.Model):
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
