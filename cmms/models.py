from datetime import datetime, timedelta

from django.conf import settings
from django.contrib.auth.models import User
from django.db import models
from django.db.models import Sum
from django.utils import timezone

from admin_panel.models import GeoCity, GeoCitySub


# follow-ups
class FollowUp(models.Model):
    carno = models.CharField(max_length=10)
    title = models.TextField()
    message = models.TextField()

    created_date = models.DateField(auto_now_add=True)
    created_time = models.TimeField(auto_now=True)
    status = models.IntegerField(default=1)
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)


# stock hd
class StockCountHD(models.Model):
    frozen = models.OneToOneField('StockFreezeHd', on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    comment = models.TextField()
    status = models.IntegerField(default=1)  # 1, active, #2 closed

    approve = models.IntegerField(default=0)

    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    def trans(self):
        return {
            'count': StockCountTrans.objects.filter(stock_count_hd=self.pk).count(),
            'trans': StockCountTrans.objects.filter(stock_count_hd=self.pk),
            'summary': {
                'total_frozen':
                    StockCountTrans.objects.filter(stock_count_hd=self.pk).aggregate(total_amount=Sum('froze_qty'))[
                        'total_amount'],
                'total_counted':
                    StockCountTrans.objects.filter(stock_count_hd=self.pk).aggregate(total_amount=Sum('counted_qty'))[
                        'total_amount'],
                'qty_difference':
                    StockCountTrans.objects.filter(stock_count_hd=self.pk).aggregate(total_amount=Sum('diff_qty'))[
                        'total_amount'],
                'value_frozen':
                    StockCountTrans.objects.filter(stock_count_hd=self.pk).aggregate(total_amount=Sum('froze_val'))[
                        'total_amount'],
                'value_counted':
                    StockCountTrans.objects.filter(stock_count_hd=self.pk).aggregate(total_amount=Sum('counted_val'))[
                        'total_amount'],
                'value_difference':
                    StockCountTrans.objects.filter(stock_count_hd=self.pk).aggregate(total_amount=Sum('diff_val'))[
                        'total_amount']
            }
        }

    def entry_no(self):
        return f"STK{self.pk}{self.frozen.loc_id}"

    def op(self):
        if self.status == 1:
            return {
                'class': 'bg-success', 'text': 'OPEN'
            }
        else:
            return {
                'class': 'bg-secondary', 'text': 'CLOSED'
            }

    def qty(self):
        return StockCountTrans.objects.filter(stock_count_hd=self).aggregate(total=Sum('quantity'))['total']

    def value(self):
        return StockCountTrans.objects.filter(stock_count_hd=self).aggregate(total=Sum('value'))['total']

    def next(self):
        if StockCountHD.objects.filter(pk__gt=self.pk).count() > 0:
            pk = StockCountHD.objects.filter(pk__gt=self.pk).first().pk
            valid = 'Y'
        else:
            valid = 'N'
            pk = False
        return {
            'valid': valid, 'pk': pk, 'counted': StockCountHD.objects.filter(pk__gt=self.pk).count()
        }

    def prev(self):
        if StockCountHD.objects.filter(pk__lt=self.pk).count() > 0:
            pk = StockCountHD.objects.filter(pk__lt=self.pk).last().pk
            valid = 'Y'
        else:
            valid = 'N'
            pk = False
        return {
            'valid': valid, 'pk': pk, 'counted': StockCountHD.objects.filter(pk__lt=self.pk).count()
        }


class StockCountTrans(models.Model):
    stock_count_hd = models.ForeignKey(StockCountHD, on_delete=models.CASCADE)
    item_ref = models.CharField(max_length=100)
    barcode = models.CharField(max_length=100)
    name = models.TextField()

    froze_qty = models.DecimalField(max_digits=10, decimal_places=3, default=0.00)
    counted_qty = models.DecimalField(max_digits=10, decimal_places=3, default=0.00)
    diff_qty = models.DecimalField(max_digits=10, decimal_places=3, default=0.00)

    froze_val = models.DecimalField(max_digits=10, decimal_places=3, default=0.00)
    counted_val = models.DecimalField(max_digits=10, decimal_places=3, default=0.00)
    diff_val = models.DecimalField(max_digits=10, decimal_places=3, default=0.00)

    quantity = models.DecimalField(max_digits=10, decimal_places=3, default=0.00)
    sell_price = models.DecimalField(max_digits=10, decimal_places=3, default=0.00)
    value = models.DecimalField(max_digits=10, decimal_places=3, default=0.00)
    comment = models.TextField(default='null')
    issue = models.TextField(default='null')

    owner = models.TextField(default='Anonymous')


class StockFreezeHd(models.Model):
    loc_id = models.CharField(max_length=3, blank=False, null=False)
    ref = models.TextField(blank=False, null=False)
    remarks = models.TextField(blank=False, null=False)

    created_date = models.DateField(auto_now_add=True)
    created_time = models.TimeField(auto_now=True)
    status = models.IntegerField(default=1)  # { 1: Pending, 2: Counted, 0: Deleted }
    approve = models.IntegerField(default=0)

    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    def posted(self):
        ret = 0
        if StockCountHD.objects.filter(frozen=self).count() == 1:
            ret = 1

        return ret

    def trans(self):
        return {
            'count': StockFreezeTrans.objects.filter(entry_id=self.pk).count(),
            'trans': StockFreezeTrans.objects.filter(entry_id=self.pk)
        }

    def trans_only(self):
        return StockFreezeTrans.objects.filter(entry_id=self.pk)

    def next(self):
        if StockFreezeHd.objects.filter(pk__gt=self.pk).count() > 0:
            pk = StockFreezeHd.objects.filter(pk__gt=self.pk).first().pk
            valid = 'Y'
        else:
            valid = 'N'
            pk = False
        return {
            'valid': valid, 'pk': pk, 'counted': StockFreezeHd.objects.filter(pk__gt=self.pk).count()
        }

    def prev(self):
        if StockFreezeHd.objects.filter(pk__lt=self.pk).count() > 0:
            pk = StockFreezeHd.objects.filter(pk__lt=self.pk).last().pk
            valid = 'Y'
        else:
            valid = 'N'
            pk = False
        return {
            'valid': valid, 'pk': pk, 'counted': StockFreezeHd.objects.filter(pk__lt=self.pk).count()
        }

    def ent(self):
        return f"FR{self.loc_id}{self.pk}"


class StockFreezeTrans(models.Model):
    entry = models.ForeignKey('StockFreezeHd', on_delete=models.CASCADE)
    item_ref = models.CharField(max_length=100, blank=False, null=False)
    barcode = models.CharField(max_length=100, blank=False, null=False)
    name = models.TextField(blank=False, null=False)
    qty = models.DecimalField(max_digits=10, decimal_places=3)
    price = models.DecimalField(max_digits=10, decimal_places=3, default=0.0)


class SalesCustomers(models.Model):
    sector_of_company = models.TextField(blank=True)
    type_of_client = models.TextField()
    company = models.CharField(max_length=225, unique=True)
    region = models.ForeignKey(GeoCity, on_delete=models.SET_NULL, null=True, blank=True)
    city = models.ForeignKey(GeoCitySub, on_delete=models.SET_NULL, null=True, blank=True)
    mobile = models.CharField(max_length=225, unique=True)
    email = models.CharField(max_length=225, unique=True)
    fax = models.TextField(blank=True)
    address = models.TextField()

    first_name = models.TextField(blank=True)
    last_name = models.TextField(blank=True)
    position = models.TextField(default='none')
    note = models.TextField(null=True, blank=True)
    name = models.TextField()

    url = models.CharField(max_length=225, unique=True)

    created_date = models.DateField(auto_now_add=True)
    created_time = models.TimeField(auto_now_add=True)
    updated_date = models.DateField(auto_now=True)
    updated_time = models.TimeField(auto_now=True)

    status = models.IntegerField(default=0)
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)


    def proformas(self):
        return ProformaInvoice.objects.filter(sales_customer=self)
    
    def obj(self):
        return {
            'type':self.type_of_client
        }

    def trans(self):
        return SalesCustomerTransactions.objects.filter(customer=self.pk).order_by('-pk')

    def uni(self):
        return self.company.replace(' ', '-').lower()

    def deals(self):
        return SalesDeals.objects.filter(customer=self.pk).order_by('-pk')

    def delete(self, *args, **kwargs):
        related_objects = self.salescustomertransactions_set.all()  # replace 'yourmodel' with the lowercased model name that has the 'customer' field
        for obj in related_objects:
            obj.customer = self.name
            obj.save()
        super().delete(*args, **kwargs)


class SalesCustomerTransactions(models.Model):
    customer = models.ForeignKey(SalesCustomers, on_delete=models.SET_NULL, null=True, blank=True)
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    title = models.TextField()
    details = models.TextField()

    created_date = models.DateField(auto_now_add=True)
    created_time = models.TimeField(auto_now_add=True)
    updated_date = models.DateField(auto_now=True)
    updated_time = models.TimeField(auto_now=True)

    def date(self):
        return f"{self.created_date} {self.created_time}"


class SalesDeals(models.Model):
    customer = models.ForeignKey(SalesCustomers, on_delete=models.CASCADE)
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    pur_rep_name = models.TextField()
    pur_rep_email = models.TextField()
    pur_rep_phone = models.TextField()

    asset = models.ForeignKey('CarModel',on_delete=models.CASCADE)

    requirement = models.TextField()

    created_date = models.DateField(auto_now_add=True)
    created_time = models.TimeField(auto_now_add=True)
    updated_date = models.DateField(auto_now=True)
    updated_time = models.TimeField(auto_now=True)

    status = models.IntegerField(default=0)  # 0 open, 1 closed, 3 invalid

    finale = models.IntegerField(default=0)  # 0 failed, 1 success

    def myself(self):
        return {
            'customer': self.pur_rep_name,
            'company':self.customer.company,
            'owner': self.owner.get_full_name(),
            'email':self.pur_rep_email,
            'phone':self.pur_rep_phone,
            'asset':self.asset,
            'model':self.model,
            'stock_type':self.stock_type,
            'requirement':self.requirement,
            'created_date':self.created_date,
            'created_time':self.created_time,
            'pk':self.pk
        }

    def transactions(self):
        return DealTransactions.objects.filter(deal=self.pk).order_by('-pk')


class DealTransactions(models.Model):
    deal = models.ForeignKey(SalesDeals, on_delete=models.CASCADE)
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    title = models.TextField()
    details = models.TextField()

    created_date = models.DateField(auto_now_add=True)
    created_time = models.TimeField(auto_now_add=True)
    updated_date = models.DateField(auto_now=True)
    updated_time = models.TimeField(auto_now=True)


class SalesAssetsGroup(models.Model):
    name = models.CharField(unique=True, max_length=50)
    origin = models.CharField(null=False, max_length=200)
    supplier = models.CharField(null=False, max_length=200)

    created_date = models.DateField(auto_now_add=True)
    created_time = models.TimeField(auto_now_add=True)
    updated_date = models.DateField(auto_now=True)
    updated_time = models.TimeField(auto_now=True)
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    def obj(self):
        return {
            'name': self.name,
            'created_date': self.created_date,
            'created_time': self.created_time,
            'updated_date': self.created_date,
            'owner': "None",
            'supplier': self.supplier,
            'origin': self.origin

        }


# car sales models

class CarOrigin(models.Model):
    country = models.CharField(max_length=100, unique=True)

    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.country}"


class CarManufacturer(models.Model):
    name = models.CharField(max_length=100, unique=True)
    origin = models.ForeignKey(CarOrigin, on_delete=models.CASCADE)

    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name


class CarSupplier(models.Model):
    name = models.CharField(max_length=100, unique=True)
    origin = models.ForeignKey(CarOrigin, on_delete=models.CASCADE)
    email = models.CharField(null=False, max_length=200, unique=True)
    phone = models.CharField(null=False, max_length=200, unique=True)
    website = models.TextField()

    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name


class Car(models.Model):
    name = models.CharField(max_length=100)
    manufacturer = models.ForeignKey(CarManufacturer, on_delete=models.CASCADE)
    supplier = models.ForeignKey(CarSupplier, on_delete=models.CASCADE)

    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name

    def myself(self):
        next_car = 0
        if Car.objects.filter(pk__gt=self.pk).exists():
            next_car = Car.objects.filter(pk__gt=self.pk).first().pk

        previous_car = 0
        if Car.objects.filter(pk__lt=self.pk).exists():
            previous_car = Car.objects.filter(pk__lt=self.pk).last().pk
        return {
            'name': self.name,
            'created_date': self.created_on,
            'is_active': self.is_active,
            'created_by': self.created_by.get_full_name(),
            'supplier': self.supplier.name,
            'manufacturer': self.manufacturer.name,
            'next_car': next_car,
            'previous': previous_car,
            'pk': self.pk,
            'sup_origin': self.supplier.origin.country,
            'man_origin': self.manufacturer.origin.country
        }


class CarModel(models.Model):
    car = models.ForeignKey(Car, on_delete=models.CASCADE, null=True, blank=True)
    model_name = models.CharField(max_length=100)
    year = models.PositiveIntegerField()
    price = models.DecimalField(max_digits=10, decimal_places=3, default=0.0)

    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.model_name} ({self.year})"

    def myself(self):
        return {
            'car': self.car.myself(),
            'model_name': self.model_name,
            'year': self.year,
            'created_date': self.created_on,
            'is_active': self.is_active,
            'created_by': self.created_by.get_full_name(),
            'price': self.price,
            'pk': self.pk,
            'docs': self.docount()
        }

    def docount(self):
        ct = 0
        ct += ProformaInvoice.objects.filter(car_model=self).count()
        return ct


class CarSpecification(models.Model):
    car_model = models.ForeignKey(CarModel, on_delete=models.CASCADE)
    specification_name = models.CharField(max_length=100)
    specification_value = models.CharField(max_length=100)
    part = models.CharField(max_length=5, null=True, blank=True)

    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def obj(self):
        return {
            'pk': self.pk,
            "key": self.specification_name,
            "value": self.specification_value,
            'created_date': self.created_on,
            'is_active': self.is_active,
            'created_by': self.created_by.get_full_name(),
            'part': self.part

        }

    def __str__(self):
        return f"{self.specification_name}: {self.specification_value}"


# end of car sales models


# proforma
class ProformaInvoice(models.Model):
    uni = models.CharField(max_length=100, unique=True, null=False, blank=False)
    car_model = models.ForeignKey(CarModel, on_delete=models.CASCADE, null=False, blank=False)
    customer = models.ForeignKey(SalesCustomers, on_delete=models.SET_NULL, null=True)

    currency = models.CharField(max_length=3)
    chassis = models.TextField(default='none')

    price = models.DecimalField(max_digits=10, decimal_places=3, default=0.0)
    exchange_rate = models.DecimalField(max_digits=10, decimal_places=3, default=0.0)
    quantity = models.DecimalField(max_digits=10, decimal_places=3, default=0.0)
    taxable = models.BooleanField(default=True)
    taxable_amount = models.DecimalField(max_digits=10, decimal_places=3, default=0.0)
    tax_amount = models.DecimalField(max_digits=10, decimal_places=3, default=0.0)
    net_amount = models.DecimalField(max_digits=10, decimal_places=3, default=0.0)

    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)

    is_active = models.BooleanField(default=True)
    is_sent = models.BooleanField(default=False)
    is_approved = models.BooleanField(default=False)
    approval_request = models.BooleanField(default=False)
    is_sold = models.BooleanField(default=False)

    approved_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='approved_by')
    sent_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='sent_by')
    closed_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='closed_by')

    prospective_name = models.TextField(default='same')
    prospective_email = models.TextField(default='same')
    prospective_phone = models.TextField(default='same')

    def my_ass(self):
        return f"{self.car_model.model_name}"
    def days_2_expire(self):
        # date_str = datetime(self.created_on)
        # current_date =datetime(datetime.now())
        # print("Date", date_str)
        # print("Curr Date", current_date)
        # difference = current_date - date_str
        # print("Diff", difference)
        # return difference
        # Convert the date fields to datetime
        date_created = datetime.combine(self.created_on, datetime.min.time())
        current_date = datetime.now()

        print("Date Created:", date_created)
        print("Current Date:", current_date)

        # Calculate the difference
        difference = current_date - date_created
        print("Difference:", difference)

        # Return the difference in days
        return difference.days


    def status(self):
        st = 1
        # 1 = created
        # 2 requested approval
        # 3 = approval granted
        # 4 = approval rejected
        # 5 = Sent to customer
        # 6 = Sold
        # 7 = Ended

        if self.approval_request:
            st = 2
        if self.is_approved:
            st = 3
        if self.is_sent:
            st = 5
        if not self.is_active:
            st = 7
        if self.is_sold:
            st = 6
        return st

    def approver(self):
        if self.is_approved:
            return self.approved_by.get_full_name() or 'Unknown'
        else:
            return "Not Approved"


    def obj(self):
        st = [
            'created','pending approval','approval rejected','sent to customer','sold','ended'
        ]
        return {
            "uni":self.uni,
            "car_model":self.car_model.myself(),
            "customer":self.customer.obj(),
            "prospectives":{
              "name":self.prospective_name if self.prospective_name != 'same' else self.customer.name,
                "email": self.prospective_email if self.prospective_email != 'same' else self.customer.email,
                "phone": self.prospective_phone if self.prospective_phone != 'same' else self.customer.mobile
            },
            "currency":self.currency,
            "chassis":self.chassis,
            "price":self.price,
            "exchange_rate":self.exchange_rate,
            "quantity":self.quantity,
            "taxable":self.taxable,
            "taxable_amount":self.taxable_amount,
            "tax_amount":self.tax_amount,
            "net_amount":self.net_amount,
            "meta":{
                "created_by":self.created_by.get_full_name() if self.created_by is not None else 'Unknown',
                "created_on":self.created_on,
                "is_active":self.is_active,
                "is_sent":self.is_sent,
                "is_approved":self.is_approved,
                "approval_request":self.approval_request,
                "is_sold":self.is_sold,
                "approved_by":self.approved_by.get_full_name() if self.approved_by is not None else 'Unknown',
                "sent_by":self.sent_by.get_full_name() if self.sent_by is not None else 'Unknown',
                "closed_by": 'Unknown' if self.closed_by is None else self.closed_by.get_full_name() ,
                "days_2_expire":self.days_2_expire(),
                # "status":st[self.status()]
            }
        }

class ProformaTransactions(models.Model):
    proforma = models.ForeignKey(ProformaInvoice, on_delete=models.CASCADE)
    task = models.CharField(max_length=200)

    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)


class ProformaInvoiceSpec(models.Model):
    proforma = models.ForeignKey(ProformaInvoice, on_delete=models.CASCADE)
    part = models.CharField(max_length=5, null=True, blank=True)
    specification_name = models.CharField(max_length=100)
    specification_value = models.CharField(max_length=100)

    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

class JobCard(models.Model):
    company =models.CharField(max_length=200)
    driver = models.CharField(max_length=200)
    contact = models.CharField(max_length=200)
    brand = models.CharField(max_length=200)
    model = models.CharField(max_length=200)
    carno = models.CharField(max_length=200)
    report = models.TextField()
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(default=timezone.now)
    is_started = models.BooleanField(default=False)
    is_ended  = models.BooleanField(default=False)
    wr_no = models.CharField(max_length=20, blank=True, null=True)
    mechanic = models.CharField(max_length=64, blank=True, null=True)
    close_remark = models.TextField()
    next_service_date = models.DateField(null=True, blank=True)

    def materials(self):
        return JobMaterials.objects.filter(jobcard=self)

    def status_html(self):
        st = "<span class='badge bg-dark'>unknown</span>"
        if self.is_started:
            st = "<span class='badge bg-primary'>started</span>"

        if not self.is_started:
            st = "<span class='badge bg-warning'>pending</span>"

        if self.is_ended:
            st = "<span class='badge bg-success'>ended</span>"
        return st

    def images(self):
        return JobCardImages.objects.filter(jobcard=self)

    def transactions(self):
        return JobCardTransactions.objects.filter(jobcard=self)

class JobCardTransactions(models.Model):
    jobcard = models.ForeignKey(JobCard, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    details = models.TextField()
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    created_on = models.DateField(auto_now_add=True)

class JobMaterials(models.Model):
    jobcard = models.ForeignKey(JobCard, on_delete=models.CASCADE)
    part = models.CharField(max_length=255, null=False, blank=False)
    reason = models.TextField(null=False, blank=False, max_length=25000)
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    requested_on = models.DateField(auto_now_add=True)
    is_issued = models.BooleanField(default=False)
    issued_on = models.DateField(auto_now_add=True)
    issued_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True,related_name='issued_by')
    quantity = models.DecimalField(max_digits=10,decimal_places=2,default=0.00)
    barcode = models.CharField(max_length=255, null=True, blank=True)

    def st(self):
        if self.is_issued:
            return '<span class="badge bg-success">issued</span>'
        else:
            return '<span class="badge bg-warning">pending</span>'

    def by(self):
        if self.issued_by:
            return self.issued_by.get_full_name()
        else:
            return 'UNK'


class JobCardImages(models.Model):
    jobcard = models.ForeignKey(JobCard, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='static/uploads/dolphine/servicing//%Y/%m/%d/')
    part = models.CharField(max_length=65, null=True, blank=True)