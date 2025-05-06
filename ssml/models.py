
from datetime import datetime
from django.db import models
from django.contrib.auth.models import User
from django.db.models import Sum, F


# locations class
class Location(models.Model):
    loc_id = models.CharField(max_length=255,unique=True,blank=False,null=False)
    loc_name = models.CharField(max_length=255,unique=True,blank=False,null=False)
    loc_desc = models.CharField(max_length=255,unique=True,blank=False,null=False)
    country = models.CharField(max_length=255)
    city = models.CharField(max_length=255)
    street = models.CharField(max_length=255)
    address = models.CharField(max_length=255)
    phone = models.CharField(max_length=255)
    email = models.CharField(max_length=255)

    date_created = models.DateField(auto_now_add=True)
    time_created = models.TimeField(auto_now_add=True)

    is_active = models.BooleanField(default=True)
    created_by = models.ForeignKey(User,on_delete=models.SET_NULL,null=True)

    def obj(self):
        return {
            'pk':self.id,
            'name':self.loc_name,
            'loc_id':self.loc_id,
            'country':self.country,
            'city':self.city,
            'street':self.street,
            'address':self.address,
            'phone':self.phone,
            'email':self.email
        }


# Create your models here.
class InventoryGroup(models.Model):
    name = models.CharField(max_length=255, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name
    
    def obj(self):
        return {
            'id':self.id,
            'name':self.name,
            'created_at':self.created_at,
            'updated_at':self.updated_at
        }
    
class InventoryMaterial(models.Model):
    barcode = models.CharField(max_length=255, unique=True)
    name = models.CharField(max_length=255, unique=True)
    group = models.ForeignKey(InventoryGroup, on_delete=models.CASCADE)
    reorder_qty = models.IntegerField(default=0)
    status_choices = [
        ('stock', 'Stock'),
        ('low', 'Low'),
        ('out', 'Out'),
    ]
    status = models.CharField(max_length=255, choices=status_choices, default='stock')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)
    image = models.ImageField(upload_to='static/uploads/materials/', null=True, blank=True,default='static/uploads/materials/default.png')
    value = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    is_return = models.BooleanField(default=False)
    is_issue = models.BooleanField(default=False)
    issue_qty = models.DecimalField(max_digits=10,default=0.00, decimal_places=2)
    auto_issue = models.BooleanField(default=False)
    
    def __str__(self):
        return self.name
    
    def obj(self):
        return {
            'id':self.id,
            'barcode':self.barcode,
            'name':self.name,
            'group':self.group.obj(),
            'reorder_qty':self.reorder_qty,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'is_active':self.is_active,
            'status':self.stock_level(),
            'stock':self.stock(),
            'low':self.low(),
            'out':self.out(),
            'image':self.image.url if self.image else None,
            'value':self.value,
            'issue_qty':self.issue_qty,
            'is_issue':self.is_issue,
            'is_return':self.is_return,
            'stock_in':self.stock_in(),
            'stock_out':self.stock_out(),
            'next':InventoryMaterial.objects.filter(id__gt=self.id).first().id if InventoryMaterial.objects.filter(id__gt=self.id).count() > 0 else 0,
            'prev':InventoryMaterial.objects.filter(id__lt=self.id).last().id if InventoryMaterial.objects.filter(id__lt=self.id).count() > 0 else 0,
            'auto_issue':self.auto_issue,
            'service_rates':self.service_rates(),
            'loc_stock':self.loc_stock()
        }
    
    def service_rates(self):
        return [rt.obj() for rt in ServiceMaterialRates.objects.filter(material=self)]
    def stock(self):
        return Cardex.objects.filter(material=self).aggregate(total_qty=models.Sum('qty'))['total_qty'] or 0

    def loc_stock(self,loc_id='*'):
        locations = Location.objects.all() if loc_id == '*' else Location.objects.filter(loc_id=loc_id)
        arr = []
        for loc in locations:
            arr.append({
                'location':loc.loc_name,
                'stock': Cardex.objects.filter(material=self,location=loc).aggregate(total_qty=models.Sum('qty'))['total_qty'] or 0
            })
        return arr

    def low(self):
        return Cardex.objects.filter(material=self).aggregate(total_qty=models.Sum('qty'))['total_qty'] or 0
    def out(self):
        return Cardex.objects.filter(material=self).aggregate(total_qty=models.Sum('qty'))['total_qty'] or 0
    def cardex(self):
        obj = []
        cardex = Cardex.objects.filter(material=self)
        for item in cardex:
            obj.append(item.obj())
        return obj

    def stock_in(self):
        grn = Cardex.objects.filter(material=self,doc_type='GR').aggregate(total_qty=models.Sum('qty'))['total_qty'] or 0
        #returns = Cardex.objects.filter(material=self,doc_type='RET').aggregate(total_qty=models.Sum('qty'))['total_qty']  or 0
        #xr = returns * -1
        #return grn + xr
        
        return grn
    def stock_out(self):
        issue = Cardex.objects.filter(material=self,doc_type='ISS').aggregate(total_qty=models.Sum('qty'))['total_qty'] or 0
        return issue
    
    def stock_level(self):
        stock = self.stock()
        if self.reorder_qty >= stock:
            return "out"
        elif self.reorder_qty <= stock:
            return "stock"
        else:
            return "low"
    
class Contractor(models.Model):
    company = models.CharField(max_length=255, unique=True)
    owner = models.CharField(max_length=255)
    phone = models.CharField(max_length=255, unique=True)
    email = models.EmailField(max_length=255, unique=True)
    country = models.CharField(max_length=255)
    city = models.CharField(max_length=255)
    postal_code = models.CharField(max_length=255)
    gh_post_code = models.CharField(max_length=255)
    gh_card_no = models.CharField(max_length=255, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    link = models.CharField(max_length=255)
    recievable = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    payable = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    paid = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    balance = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    code = models.CharField(max_length=255, unique=False, null=True, blank=True)

    def __str__(self):
        return self.company

    def error_limit(self):
        return {
            'week': 3,
            'month': 10,
            'year': 20,
        }

    # def materials(self):
        
    #     obj = []
    #     total = 0
    #     barcodes = IssueTransaction.objects.filter(issue__contractor=self).values_list('barcode', flat=True).distinct()

    #     for barcode in barcodes:
    #         material = InventoryMaterial.objects.get(barcode=barcode)
    #         this_obj = material.obj()
    #         this_obj['issued'] = IssueTransaction.objects.filter(material=material,issue__contractor=self).aggregate(total_qty=models.Sum('total_qty'))['total_qty'] or 0
    #         this_obj['consumed'] = MaterialOrderItem.objects.filter(material=material,service_order__contractor=self,material_type='is').aggregate(total_qty=models.Sum('quantity'))['total_qty'] or 0
    #         this_obj['balance'] = this_obj['issued'] - this_obj['consumed']
    #         negative_balance = this_obj['balance'] * -1
    #         this_obj['value'] = negative_balance * material.value
    #         this_obj['rate'] = material.value
    #         obj.append(this_obj)
    #         total += this_obj['value']
    #     return obj
    
    # def returns(self):
    #     obj = []
    #     returns = ServiceOrderReturns.objects.filter(service_order__contractor=self)
    #     for rt in returns:
    #         this_obj = rt.material.obj()
    #         this_obj['expected'] = rt.quantity
    #         this_obj['returned'] = IssueTransaction.objects.filter(material=rt.material,issue__contractor=self,issue__issue_type='RET').aggregate(total_qty=models.Sum('total_qty'))['total_qty'] or 0
    #         this_obj['balance'] = this_obj['expected'] - this_obj['returned']
    #         this_obj['total_value'] = this_obj['balance'] * rt.material.value
    #         this_obj['rate'] = rt.material.value
    #         obj.append(this_obj)
    #     return obj
    
    # def jobs(self):
    #     obj = []
    #     jobs = ServiceOrder.objects.filter(contractor=self)
    #     for job in jobs:
    #         obj.append(job.obj())
    #     return obj
    
    # def issued_recievable_balance(self):
    #     obj = []
    #     total = 0
    #     transactions = IssueTransaction.objects.filter(issue__contractor=self,issue__issue_type='ISS')
    #     for transaction in transactions:
    #         material = transaction.material.obj()
    #         total_qty = transaction.total_qty
    #         total_value = total_qty * material.value

    #         total_used = ServiceOrderItem.objects.filter(service_order__contractor=self,material=transaction.material).aggregate(total_qty=models.Sum('quantity'))['total_qty'] or 0    
    #         total_used_value = total_used * material.value

    #         total_diff = total_value - total_used_value
    #         total += total_diff
    #         obj.append({
    #             'material':material,
    #             'total_qty':total_qty,
    #             'total_value':total_value,
    #             'total_used':total_used,
    #             'total_used_value':total_used_value,
    #             'total_diff':total_diff
    #         })

    #     return {
    #         'transactions':obj,
    #         'total':total
    #     }
    
    # def recievable(self):
    #     total_returns = 0
    #     total_usage = 0
    #     total_balance = 0
    #     obj = []

    #     for material in InventoryMaterial.objects.all():
    #         # returns
    #         stated_returns = ServiceOrderReturns.objects.filter(material=material,service_order__contractor=self).aggregate(total_qty=models.Sum('quantity'))['total_qty'] or 0
    #         actual_returns = IssueTransaction.objects.filter(material=material,issue__contractor=self,issue__issue_type='RET').aggregate(total_qty=models.Sum('total_qty'))['total_qty'] or 0
    #         returns_diff = actual_returns - stated_returns 
    #         returns_balance = returns_diff * material.value

    #         # usage in service orders
    #         stated_usage = MaterialOrderItem.objects.filter(material=material,material_type='is').aggregate(total_qty=models.Sum('quantity'))['total_qty'] or 0
    #         issued_for_service_orders = IssueTransaction.objects.filter(material=material,issue__contractor=self,issue__issue_type='ISS').aggregate(total_qty=models.Sum('total_qty'))['total_qty'] or 0
    #         usage_diff = stated_usage - issued_for_service_orders
    #         usage_balance = usage_diff * material.value

    #         # balance
    #         balance = returns_balance + usage_balance
    #         total_returns += returns_balance
    #         total_usage += usage_balance
    #         total_balance += balance

    #         this_obj = {
    #             'material':material.obj(),
    #             'returns_balance':returns_balance,
    #             'usage_balance':usage_balance,
    #             'balance':balance
    #         }
    #         obj.append(this_obj)

    #     return {
    #         'total_returns':total_returns,
    #         'total_usage':total_usage,
    #         'total_balance':total_balance,
    #         'transactions':obj
    #     }
    
    # def payable(self):
    #     return ServiceOrderItem.objects.filter(service_order__contractor=self).aggregate(total_amount=models.Sum('amount'))['total_amount'] or 0
    
    # def matched(self):
    #     return self.payable() + self.recievable()['total_balance'] or 0
    
    # def paid(self):
    #     return 0
    
    
    # def balance(self):
    #     return self.matched() - self.paid()
    
    def next_row(self):
        return Contractor.objects.filter(id__gt=self.id).first().id if Contractor.objects.filter(id__gt=self.id).count() > 0 else 0
    def prev_row(self):
        return Contractor.objects.filter(id__lt=self.id).last().id if Contractor.objects.filter(id__lt=self.id).count() > 0 else 0
    
    def ledger_sum(self):
        from ssml.helper import returns,lederhd
        return lederhd(self.id)
    
        ledger = Ledger.objects.filter(contractor=self,transaction_type='credit')
        total_credit = ledger.aggregate(total_credit=Sum('amount'))['total_credit'] or 0
        total_debit = returns(self.id)['total']
        total_balance = total_credit + total_debit
        return {
                    'total_credit':total_credit,
                    'total_debit':total_debit,
                    'total_balance':total_balance
            }


    def issued(self):
        iss = Issue.objects.filter(contractor=self)
        return [x.obj() for x in iss]

    def obj(self):
        return {
            'id':self.id,
            'company':self.company,
            'owner':self.owner,
            'phone':self.phone,
            'email':self.email,
            'country':self.country,
            'city':self.city,
            'postal_code':self.postal_code,
            'gh_post_code':self.gh_post_code,
            'gh_card_no':self.gh_card_no,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'created_by':self.created_by.username,
            'link':self.link,
            'next_row':self.next_row(),
            'prev_row':self.prev_row(),
            # 'materials':self.materials(),
            # 'returns':self.returns(),
            'recievable':self.recievable,
            'payable':self.payable,
            'paid':self.paid,
            'balance':self.balance,
            # 'matched':self.matched(),
            'ledger':self.ledger_sum(),
            'code':self.code,
            
        }

class Supplier(models.Model):
    supplier_name = models.CharField(max_length=255, unique=True)
    contact_person = models.CharField(max_length=255)
    supplier_address = models.TextField()
    supplier_phone = models.CharField(max_length=255)
    supplier_email = models.EmailField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.supplier_name
    
    
    
    def obj(self):
        return {
            'id':self.id,
            'supplier_name':self.supplier_name,
            'contact_person':self.contact_person,
            'supplier_address':self.supplier_address,
            'supplier_phone':self.supplier_phone,
            'supplier_email':self.supplier_email,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
        }

class Grn(models.Model):
    type_choices = [
        ('purchase', 'Purchase'),
        ('return', 'Return'),
        ('sample', 'Sample'),
    ]
    grn_no = models.CharField(max_length=255, unique=True)
    type = models.CharField(max_length=255, choices=type_choices)
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE)
    grn_date = models.DateField()
    remarks = models.TextField()
    grn_type = models.CharField(max_length=255)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    total_qty = models.DecimalField(max_digits=10, decimal_places=2)
    is_posted = models.BooleanField(default=False)
    posted_by = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='posted_grns')
    location = models.ForeignKey(Location,on_delete=models.CASCADE,null=False)
    

    def __str__(self):
        return self.grn_date
    
    def obj(self):
        return {
            'id':self.id,
            'supplier':self.supplier.obj(),
            'grn_date':self.grn_date,
            'remarks':self.remarks,
            'grn_type':self.grn_type,
            'created_by':self.created_by.username,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'total_amount':self.total_amount,
            'total_qty':GrnTransaction.objects.filter(grn=self).aggregate(total_qty=models.Sum('total_qty'))['total_qty'] or 0,
            'transactions':self.transactions(),
            'next_row':self.next_row(),
            'prev_row':self.prev_row(),
            'status':self.status(),
            'grn_no':self.grn_no,
            'is_posted':self.is_posted,
            'posted_by':self.posted_by.get_full_name() if self.posted_by else "",
            'location':self.location.loc_name if self.location else 'NOT SET'
        }
    def status(self):
        if self.is_posted:
            return 'Posted'
        else:
            return 'Not Posted'
    def save(self, *args, **kwargs):
        if not self.grn_no:
            self.grn_no = f"GRN-{self.id}"
        super().save(*args, **kwargs)

    def transactions(self):
        obj = []
        transactions = GrnTransaction.objects.filter(grn=self)
        for transaction in transactions:
            obj.append(transaction.obj())
        return obj
    def next_row(self):
        return Grn.objects.filter(id__gt=self.id).first().id if Grn.objects.filter(id__gt=self.id).count() > 0 else 0
    def prev_row(self):
        return Grn.objects.filter(id__lt=self.id).last().id if Grn.objects.filter(id__lt=self.id).count() > 0 else 0 
    
class GrnTransaction(models.Model):
    grn = models.ForeignKey(Grn, on_delete=models.CASCADE)
    material = models.ForeignKey(InventoryMaterial, on_delete=models.CASCADE)
    barcode = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    qty = models.DecimalField(max_digits=10, decimal_places=2)
    rate = models.DecimalField(max_digits=10, decimal_places=2)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    uom = models.CharField(max_length=255)
    pack_qty = models.DecimalField(max_digits=10, decimal_places=2)
    total_qty = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.grn.barcode
    
    def obj(self):
        return {
            'id':self.id,
            'material':self.material.obj(),
            'barcode':self.barcode,
            'name':self.name,
            'qty':self.qty,
            'rate':self.rate,
            'amount':self.amount,
            'uom':self.uom,
            'pack_qty':self.pack_qty,
            'created_at':self.created_at,
            'total_qty':self.total_qty,
            'updated_at':self.updated_at
        }
    # def save(self, *args, **kwargs):
    #     # Calculate this transaction's contribution
    #     self.amount = self.rate * self.qty  # Calculate amount if not set
    #     self.total_qty = self.qty * self.pack_qty  # Calculate total_qty
        
    #     super().save(*args, **kwargs)  # Save first to ensure we have an ID
        
    #     # Recalculate GRN totals from all transactions
    #     grn_transactions = GrnTransaction.objects.filter(grn=self.grn)
    #     total_amount = sum(t.amount for t in grn_transactions)
    #     total_qty = sum(t.total_qty for t in grn_transactions)
        
    #     # Update the related GRN with new totals
    #     self.grn.total_amount = total_amount 
    #     self.grn.total_qty = total_qty
    #     self.grn.save()
        

class Cardex(models.Model):
    doc_type_choices = [
        ('GR', 'GRN'),
        ('ISS', 'ISSUE'),
        ('CIS', 'Contractor Issue Return'),
        ('RET', 'RETURN'),
    ]
    doc_type = models.CharField(max_length=3, choices=doc_type_choices)
    doc_no = models.CharField(max_length=255)
    ref_no = models.CharField(max_length=255)
    material = models.ForeignKey(InventoryMaterial, on_delete=models.CASCADE)
    qty = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    location = models.ForeignKey(Location,on_delete=models.CASCADE,null=False)
    
    def obj(self):
        return {
            'id':self.id,
            'doc_type':self.doc_type,
            'doc_no':self.doc_no,
            'ref_no':self.ref_no,
            'material':self.material.obj(),
            'qty':self.qty,
            'created_at':self.created_at,
            'updated_at':self.updated_at
        }
    



class Issue(models.Model):
    issue_no = models.CharField(max_length=255, unique=True)
    issue_date = models.DateField()
    remarks = models.TextField()
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    modified_by = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='modified_issues')
    car_no = models.CharField(max_length=255, null=True, blank=True)
    location = models.ForeignKey(Location,on_delete=models.CASCADE,null=False)
    
    issue_type_choices = [
        ('ADJ', 'Adjustment'),
        ('ISS', 'Issue'),
        ('RET', 'Return'),
        ('SMP', 'Sample'),
        ('TRN', 'Transfer'),
        ('CIS', 'Contractor Issue Return'),
    ]
    issue_type = models.CharField(max_length=255, choices=issue_type_choices)
    contractor = models.ForeignKey(Contractor, on_delete=models.CASCADE)
    is_posted = models.BooleanField(default=False)
    posted_by = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='posted_issues')
    is_deleted = models.BooleanField(default=False)

    def status(self):
        if self.is_posted:
            return 'Posted'
        else:
            return 'Not Posted'

    def obj(self):
        return {
            'id':self.id,
            'issue_no':self.issue_no,
            'issue_date':self.issue_date,
            'remarks':self.remarks,
            'created_by':self.created_by.username,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'issue_type':self.issue_type,
            'contractor':self.contractor.obj(),
            'transactions':self.transactions(),
            'next_row':self.next_row(),
            'prev_row':self.prev_row(),
            'is_posted':self.is_posted,
            'posted_by':self.posted_by.get_full_name() if self.posted_by else "",
            'status':self.status(),
            'total_amount':IssueTransaction.objects.filter(issue=self).aggregate(total_amount=models.Sum('amount'))['total_amount'] or 0,
            'total_qty':IssueTransaction.objects.filter(issue=self).aggregate(total_qty=models.Sum('total_qty'))['total_qty'] or 0,
            'modified_by':self.modified_by.get_full_name() if self.modified_by else "",
            'location':self.location.loc_name
        }
    def transactions(self):
        obj = []
        transactions = IssueTransaction.objects.filter(issue=self)
        for transaction in transactions:
            obj.append(transaction.obj())
        return obj
    def next_row(self):
        return Issue.objects.filter(id__gt=self.id).first().id if Issue.objects.filter(id__gt=self.id).count() > 0 else 0
    def prev_row(self):
        return Issue.objects.filter(id__lt=self.id).last().id if Issue.objects.filter(id__lt=self.id).count() > 0 else 0

    def total_qty(self):
        return IssueTransaction.objects.filter(issue=self).aggregate(total_qty=models.Sum('total_qty'))['total_qty'] or 0
    
class IssueTransaction(models.Model):
    issue = models.ForeignKey(Issue, on_delete=models.CASCADE)
    material = models.ForeignKey(InventoryMaterial, on_delete=models.CASCADE)
    barcode = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    qty = models.DecimalField(max_digits=10, decimal_places=2)
    rate = models.DecimalField(max_digits=10, decimal_places=2)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    uom = models.CharField(max_length=255)
    pack_qty = models.DecimalField(max_digits=10, decimal_places=2)
    total_qty = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def obj(self):
        return {
            'id':self.id,
            'material':self.material.obj(),
            'barcode':self.barcode,
            'name':self.name,
            'qty':self.qty,
            'rate':self.rate,
            'amount':self.amount,
            'uom':self.uom,
            'pack_qty':self.pack_qty,
            'total_qty':self.total_qty,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'issue_no':self.issue.issue_no,
            'issue_date':self.issue.issue_date,
            'remarks':self.issue.remarks,
            'contractor':self.issue.contractor.company,
            'issue_type':self.issue.issue_type,
            'car_no':self.issue.car_no,
            'is_posted':self.issue.is_posted,
            'posted_by':self.issue.posted_by.get_full_name() if self.issue.posted_by else "",
            

        }



class Plot(models.Model):
    plot_no = models.CharField(max_length=255, unique=True)
    contractor = models.ForeignKey(Contractor, on_delete=models.CASCADE)
    plot_size = models.DecimalField(max_digits=10, decimal_places=2)
    plot_image = models.ImageField(upload_to='static/uploads/plots/', null=True, blank=True,default='static/uploads/plots/default.png')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.plot_no
    
    def obj(self):
        return {
            'id':self.id,
            'plot_no':self.plot_no,
            'contractor':self.contractor.obj(),
            'plot_size':self.plot_size,
            'plot_image':self.plot_image.url if self.plot_image else None,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'created_by':self.created_by.username
        }
    


class ServiceType(models.Model):
    name = models.CharField(max_length=255,unique=True)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.name

    def total_installations(self):
        return ServiceOrder.objects.filter(service_type=self).count()
    

    def today_jobs(self):
        return ServiceOrder.objects.filter(service_type=self,service_date=datetime.now().date()).count()
    
    def obj(self):
        return {
            'id':self.id,
            'name':self.name,
            'description':self.description,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'total_installations':self.total_installations(),
            'today_jobs':self.today_jobs()
        }
    

class Service(models.Model):
    code = models.CharField(max_length=255,unique=True)
    name = models.CharField(max_length=255,unique=True)
    description = models.TextField()
    uom = models.CharField(max_length=255)
    rate = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.name
    
    def obj(self):
        return {
            'id':self.id,
            'code':self.code,
            'name':self.name,
            'description':self.description,
            'uom':self.uom,
            'rate':self.rate,
            'created_at':self.created_at,
            'updated_at':self.updated_at
        }
    
class ServiceTypeServices(models.Model):
    service_type = models.ForeignKey(ServiceType,on_delete=models.CASCADE,null=False,blank=False)
    service = models.ForeignKey(Service,on_delete=models.CASCADE,null=False,blank=False)

    class Meta:
        unique_together = (('service_type','service'),)


class ServiceMaterialRates(models.Model):
    service = models.ForeignKey(Service,on_delete=models.CASCADE,null=False,blank=False,related_name='material_service')
    material = models.ForeignKey(InventoryMaterial,on_delete=models.CASCADE,null=False,blank=False,related_name='rate_material',verbose_name='rate_material')
    break_point = models.DecimalField(decimal_places=2,default=0.00,max_digits=10)

    class Meta:
        unique_together = (('service','material'),)

    def obj(self):
        return {
            'id':self.id,
            'service':self.service.name,
            'rate':self.service.rate,
            'description':self.service.description,
            'break_point':self.break_point

        }

class ServiceOrder(models.Model):
    service_type = models.ForeignKey(ServiceType, on_delete=models.CASCADE)
    service_date = models.DateField()
    contractor = models.ForeignKey(Contractor, on_delete=models.CASCADE)
    plot = models.CharField(max_length=255,default="NOT SET")
    geo_code = models.CharField(max_length=255,default="NOT SET")
    customer = models.CharField(max_length=255)
    customer_no = models.CharField(max_length=255)
    old_meter_no = models.CharField(max_length=255,unique=True)
    new_meter = models.CharField(unique=True,null=False,max_length=20)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    status_choices = [
        ('pending', 'Pending'),
        ('completed', 'Completed'),
        ('disapproved', 'Disapproved'),
        ('in_progress', 'In Progress'),
        ('on_hold', 'On Hold'),
        ('rejected', 'Rejected'),
        ('invoiced',"Invoiced"),
        ('paid', 'Paid'),
    ]
    status = models.CharField(max_length=255, choices=status_choices, default='pending')
    old_meter_no_reading = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    new_meter_no_reading = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    closed_by = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='closed_service_orders')
    total_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    location = models.ForeignKey(Location,on_delete=models.CASCADE,null=False)

    def __str__(self):
        return self.service_date
    

    def items(self):
        obj = []
        items = ServiceOrderItem.objects.filter(service_order=self)
        for item in items:
            obj.append(item.obj())
        return obj

    def total_amount(self):
        return ServiceOrderItem.objects.filter(service_order=self).aggregate(total_amount=models.Sum('amount'))['total_amount'] or 0

    def materials(self):
        obj = []
        materials = MaterialOrderItem.objects.filter(service_order=self,material_type='is')
        for material in materials:
            obj.append(material.obj())
        return obj
    
    def returns(self):
        obj = []
        returns = ServiceOrderReturns.objects.filter(service_order=self)
        for rt in returns:
            obj.append(rt.obj())
        return obj
    
    def installed_meter(self):
        return {}
    
    def obj(self):
        return {
            'id':self.id,
            'service_type':self.service_type.obj(),
            'service_date':self.service_date,
            'contractor':self.contractor.obj(),
            'plot':self.plot,
            'geo_code':self.geo_code,
            'customer':self.customer,
            'customer_no':self.customer_no,
            'old_meter_no':self.old_meter_no,
            'new_meter_no':self.new_meter,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'created_by':self.created_by.username,
            'status':self.status,
            'service_items':self.items(),
            'total_amount':self.total_amount(),
            'materials':self.materials(),
            'returns':self.returns(),
            'old_meter_reading':self.old_meter_no_reading,
            'new_meter_reading':self.new_meter_no_reading,
            'next_row':self.next_row(),
            'prev_row':self.prev_row(),
        }
    def next_row(self):
        return ServiceOrder.objects.filter(id__gt=self.id).first().id if ServiceOrder.objects.filter(id__gt=self.id).count() > 0 else 0
    def prev_row(self):
        return ServiceOrder.objects.filter(id__lt=self.id).last().id if ServiceOrder.objects.filter(id__lt=self.id).count() > 0 else 0
    


class Meter(models.Model):
    issue = models.ForeignKey(Issue, on_delete=models.SET_NULL,null=True)
    meter_no = models.CharField(max_length=255,unique=True)
    contractor = models.ForeignKey(Contractor, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    is_issued = models.BooleanField(default=False)
    service_order = models.ForeignKey(ServiceOrder, on_delete=models.SET_NULL, null=True, blank=True)
    meter_type_choices = [
        ('SIN', 'Single Phase'),
        ('TRIN', 'Three Phase'),
    ]
    meter_type = models.CharField(max_length=255, choices=meter_type_choices, default='SIN')
    location = models.ForeignKey(Location,on_delete=models.CASCADE,null=False)

    def __str__(self):
        return self.meter_no
    
    def meter_type_display(self):
        return self.meter_type
    
    def obj(self):
        return {
            'id':self.id,
            'meter_no':self.meter_no,
            'contractor':self.contractor.obj(),
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'is_issued':self.is_issued,
            'service_order':self.service_order.obj() if self.service_order else None,
            'service':ServiceOrder.objects.get(new_meter=self.meter_no).id if ServiceOrder.objects.filter(new_meter=self.meter_no).exists() else None
        }
    


class ServiceOrderItem(models.Model):
    service_order = models.ForeignKey(ServiceOrder, on_delete=models.CASCADE)
    service = models.ForeignKey(Service, on_delete=models.CASCADE)
    quantity = models.DecimalField(max_digits=10, decimal_places=2)
    rate = models.DecimalField(max_digits=10, decimal_places=2)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    modified_by = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='modified_service_order_items')
    class Meta:
        unique_together = ('service_order', 'service')
    
    def obj(self):
        return {
            'id':self.id,
            'quantity':self.quantity,
            'rate':self.rate,
            'amount':self.amount,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'service':self.service.obj()
        }
    
    



class MaterialOrderItem(models.Model):
    service_order = models.ForeignKey(ServiceOrder, on_delete=models.CASCADE)
    material = models.ForeignKey(InventoryMaterial, on_delete=models.CASCADE)
    quantity = models.DecimalField(max_digits=10, decimal_places=2)
    rate = models.DecimalField(max_digits=10, decimal_places=2)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    modified_by = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='modified_material_order_items')
    material_type_choices = [
        ('rt', 'Return'),
        ('is', 'Issue'),
    ]
    material_type = models.CharField(max_length=255, choices=material_type_choices, default='is',null=False,blank=False)
    class Meta:
        unique_together = ('service_order', 'material','material_type')

    def obj(self):
        return {
            'id':self.id,
            'material':self.material.obj(),
            'quantity':self.quantity,
            'rate':self.rate,
            'amount':self.amount,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'material_type':self.material_type
        }
    
class ServiceOrderReturns(models.Model):
    service_order = models.ForeignKey(ServiceOrder, on_delete=models.CASCADE)
    material = models.ForeignKey(InventoryMaterial, on_delete=models.CASCADE)
    quantity = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    modified_by = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='modified_service_order_returns')
    
    class Meta:
        unique_together = ('service_order', 'material')

    def obj(self):
        return {
            'id':self.id,
            'material':self.material.obj(),
            'quantity':self.quantity,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'created_by':self.created_by.username if self.created_by else None,
            'modified_by':self.modified_by.username if self.modified_by else None,
            'rate':self.material.value,
            'amount':self.quantity * self.material.value
        }
    

class Ledger(models.Model):
    contractor = models.ForeignKey(Contractor, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    reference_no = models.CharField(max_length=255,unique=True,null=False,blank=False)
    transaction_types = [
        ('credit', 'Credit'),
        ('debit', 'Debit'),
    ]
    transaction_type = models.CharField(max_length=255, choices=transaction_types)
    remarks = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    
    def obj(self):
        return {
            'id':self.id,
            'amount':self.amount,
            'transaction_type':self.transaction_type,
            'remarks':self.remarks,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'created_by':self.created_by.username,
            'contractor':self.contractor.obj()
        }
    

class Reedem(models.Model):
    entry_no = models.CharField(max_length=10,unique=True,null=False,blank=False)
    contractor = models.ForeignKey(Contractor, on_delete=models.CASCADE)
    entry_date =  models.DateField()
    remarks = models.TextField()
    type_choices = [
        ('RET',"Return"),
        ("ISS","Issue")
    ]
    transaction_type = models.CharField(max_length=255, choices=type_choices)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    is_valid = models.BooleanField(default=True)
    location = models.ForeignKey(Location,on_delete=models.CASCADE,null=False)

    def next_row(self):
        return Reedem.objects.filter(id__gt=self.id).first().id if Reedem.objects.filter(id__gt=self.id).count() > 0 else 0
    def prev_row(self):
        return Reedem.objects.filter(id__lt=self.id).last().id if Reedem.objects.filter(id__lt=self.id).count() > 0 else 0

    def transactions(self):
        trans = RedeemTransactions.objects.filter(redeem=self)
        return [redeem.obj() for redeem in trans]


    def obj(self):
        return {
            'id':self.id,
            'entry_no':self.entry_no,
            'contractor':{
                'company':self.contractor.company,
                'id':self.contractor.id
            },
            'entry_date':self.entry_date,
            'type':self.transaction_type,
            'date_created':self.created_at,
            'created_by':self.created_by.username,
            'remarks':self.remarks,
            'transactions':self.transactions(),
            'next_row':self.next_row(),
            'prev_row':self.prev_row(),
            'is_valid':self.is_valid
        }


class RedeemTransactions(models.Model):
    redeem =  models.ForeignKey(Reedem, on_delete=models.CASCADE)
    material = models.ForeignKey(InventoryMaterial, on_delete=models.CASCADE)
    pack_um = models.CharField(max_length=5)
    balance = models.DecimalField(max_digits=10, decimal_places=2)
    qty = models.DecimalField(max_digits=10, decimal_places=2)
    reason = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)


    def obj(self):
        return {
            'material':self.material.obj(),
            'pack_um':self.pack_um,
            'balance':self.balance,
            'qty':self.qty,
            'reason':self.reason
        }



class ContractorError(models.Model):
    contractor = models.ForeignKey(Contractor, on_delete=models.CASCADE)
    error_date = models.DateField()
    error_type_choices = [
        ('CBL', 'Cabling'),
        ('INS', 'Installation'),
        ('MT',"Materials"),
        ('OT',"Other")
    ]   
    error_type = models.CharField(max_length=255, choices=error_type_choices)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    meter = models.ForeignKey(Meter, on_delete=models.CASCADE,to_field='meter_no')
    is_cleared = models.BooleanField(default=False)
    cleared_at = models.DateTimeField(null=True, blank=True)
    cleared_by = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    cleared_remarks = models.TextField(null=True, blank=True)

    def obj(self):
        return {
            'id':self.id,
            'error_type':self.error_type,
            'description':self.description,
            'meter':self.meter.obj(),
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'is_cleared':self.is_cleared,
            'cleared_at':self.cleared_at,
            'cleared_by':self.cleared_by.username if self.cleared_by else None,
            'cleared_remarks':self.cleared_remarks
        }
    

class Expense(models.Model):
    direction_choices = [
        ('in', 'In'),
        ('out', 'Out'),
    ]
    direction = models.CharField(max_length=255, choices=direction_choices)
    date = models.DateField()
    category_choices = [
        ('home', 'Home Expense'),
        ('staff', 'Staff Expense'),
        ('transport', 'Transport Expense'),
        ('marketing', 'Marketing Expense'),
        ('other', 'Other'),
    ]
    category = models.CharField(max_length=255, choices=category_choices)
    transaction_type_choices = [
        ('cash', 'Cash'),
        ('momo', 'MoMo'),
    ]
    transaction_type = models.CharField(max_length=255, choices=transaction_type_choices)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    reference = models.CharField(max_length=255)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)

    def obj(self):
        return {
            'id':self.id,
            'direction':self.direction,
            'date':self.date,
            'category':self.category,
            'transaction_type':self.transaction_type,
            'amount':self.amount,
            'reference':self.reference,
            'description':self.description,
            'created_at':self.created_at,
            'updated_at':self.updated_at,
            'created_by':self.created_by.get_full_name()
        }
    
    
class InvoiceHD(models.Model):
    entry_no = models.CharField(max_length=255,null=False, blank=False,unique=True)
    entry_date = models.DateField(null=False)
    contractor = models.ForeignKey(Contractor,on_delete=models.SET_NULL,null=True)
    remarks = models.TextField()
    total_amount = models.DecimalField(max_digits=10,max_length=10,decimal_places=2,default=0.00)

    created_by = models.ForeignKey(User,on_delete=models.SET_NULL,null=True)
    date_created = models.DateField(auto_now_add=True)
    time_created = models.TimeField(auto_now_add=True)

    is_approved = models.BooleanField(default=False)
    is_posted = models.BooleanField(default=False)

    approved_by = models.ForeignKey(User,on_delete=models.SET_NULL,null=True,related_name='invapproved_by')
    posted_by = models.ForeignKey(User,on_delete=models.SET_NULL,null=True,related_name='invposted_by')

    class Meta:
        unique_together = (('entry_date','contractor'),)

    def status(self):
        if not self.is_approved:
            return 'pending approval'
        elif not self.is_posted:
            return 'pending posting'
        elif self.is_approved and self.is_posted:
            return 'posted'
        else:
            return 'unknwn'
        
    def stage(self):
        if not self.is_approved:
            return 1 # pending approve
        elif not self.is_posted:
            return 2 # pending posting
        elif self.is_approved and self.is_posted:
            return 3 # posted
        else:
            return 0 # unknown
        
    def transactions(self):
        return [tran.obj(detailed=False) for tran in InvoiceTransactions.objects.filter(entry=self)]
    
    def next_row(self):
        return InvoiceHD.objects.filter(id__gt=self.id).first().id if InvoiceHD.objects.filter(id__gt=self.id).count() > 0 else 0
    def prev_row(self):
        return InvoiceHD.objects.filter(id__lt=self.id).last().id if InvoiceHD.objects.filter(id__lt=self.id).count() > 0 else 0

    def obj(self):
        return{
            'contractor':{
                "name":self.contractor.company,
            },
            'id':self.id,
            'entry_no':self.entry_no,
            'entry_date':self.entry_date,
            'remarks':self.remarks,
            'total_amount':self.total_amount,
            'created_by':self.created_by.get_full_name(),
            'date_created':self.date_created,
            'time_created':self.time_created,
            'is_approved':self.is_approved,
            'is_posted':self.is_posted,
            'status':self.status(),
            'transactions':self.transactions(),
            'next':self.next_row(),
            'previous':self.prev_row(),
            'stage':self.stage()
        }
    

class InvoiceTransactions(models.Model):
    entry = models.ForeignKey(InvoiceHD,on_delete=models.CASCADE)
    service_date = models.DateField(null=False)
    asset = models.CharField(max_length=255,null=False, blank=False)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    remarks = models.CharField(max_length=255,null=False, blank=False)

    class Meta:
        unique_together = (('entry','asset'),)

    def obj(self,detailed=False):
        if detailed:
            return {}
        else:
            return {

                "service_date":self.service_date,
                'asset':self.asset,
                'amount':self.amount,
                'remarks':self.remarks
            }
        
class PaySlipHD(models.Model):
    entry_no = models.CharField(max_length=255,null=False, blank=False,unique=True)
    entry_date = models.DateField(null=False)
    contractor = models.ForeignKey(Contractor,on_delete=models.SET_NULL,null=True)
    remarks = models.TextField()
    total_amount = models.DecimalField(max_digits=10,max_length=10,decimal_places=2,default=0.00)
    due_date = models.DateField(null=False)

    created_by = models.ForeignKey(User,on_delete=models.SET_NULL,null=True)
    date_created = models.DateField(auto_now_add=True)
    time_created = models.TimeField(auto_now_add=True)

class PaySlipTransactions(models.Model):
    entry = models.ForeignKey(PaySlipHD,on_delete=models.CASCADE)
    