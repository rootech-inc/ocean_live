
from django.db import models
from django.contrib.auth.models import User


class Vehicle(models.Model):
    plate_number = models.CharField(max_length=20, unique=True)
    description = models.TextField(blank=True, null=True)
    capacity = models.DecimalField(max_digits=10, decimal_places=2, blank=False, null=False,default=0.00)
    status = models.CharField(max_length=20, choices=[
        ('available', 'Available'),
        ('in_use', 'In Use'),
        ('maintenance', 'Under Maintenance'),
        ('inactive', 'Inactive')
    ], default='available')
    last_service_date = models.DateField(blank=True, null=True)
    next_service_due = models.DateField(blank=True, null=True)
    image = models.ImageField(upload_to='static/general/uploads/vehicle_images/',blank=True,null=True)
    owner = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)

    def dp(self):
        return self.image.url if self.image else f'https://placehold.co/100?text={self.description.split()[0][0]}{self.description.split()[-1][0]}'

    def obj(self):
        return {
            "plate_number": self.plate_number,
            "description": self.description,
            'capacity': self.capacity,
            "status": self.status,
            'last_service_date': self.last_service_date,
            'next_service_date': self.next_service_due,
            'deliveries': self.deliveries(),
            'pk':self.pk,
            'img':self.dp()
        }

    def deliveries(self,status='*'):
        return [de.obj() for de in DeliveryRequest.objects.filter(vehicle=self)] if status == '*' else [de.obj() for de in DeliveryRequest.objects.filter(vehicle=self,status=status)]

    def __str__(self):
        return f"{self.plate_number} - {self.description}"




class Driver(models.Model):
    name = models.CharField(max_length=100,unique=True)
    phone_number = models.CharField(max_length=20,unique=True)
    license_number = models.CharField(max_length=50,unique=True)
    status = models.CharField(max_length=20, choices=[
        ('available', 'Available'),
        ('on_trip', 'On Trip'),
        ('inactive', 'Inactive')
    ], default='available')
    email = models.EmailField(blank=False, null=False)
    image = models.ImageField(upload_to='static/general/uploads/driver_images/',blank=True,null=True)
    user = models.OneToOneField(User, on_delete=models.SET_NULL, null=True, blank=True)
    license = models.ImageField(upload_to='static/general/uploads/driver_images/',blank=True,null=True)



    def deliveries(self):
        return DeliveryRequest.objects.filter(driver=self)
    def dp(self):
        return self.image.url if self.image else f'https://placehold.co/100?text={self.name.split()[0][0]}{self.name.split()[-1][0]}'

    def obj(self):
        return {
            "name": self.name,
            "phone_number": self.phone_number,
            "license_number": self.license_number,
            "status": self.status,
            "email": self.email,
            "pk":self.pk,
            "deliveries":self.deliveries().count(),
            "is_engaged":True if DeliveryRequest.objects.filter(driver=self,status='in_transit').exists() else False,
            'db':self.dp()
        }
    def __str__(self):
        return self.name


class DeliveryRequest(models.Model):
    enc = models.CharField(max_length=255,blank=True, null=True)
    requested_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    source = models.CharField(max_length=255)
    destination = models.CharField(max_length=255)
    description = models.TextField()
    request_date = models.DateTimeField(auto_now_add=True)
    scheduled_date = models.DateTimeField(blank=True, null=True)

    type_choices = [
        ('transfer', 'Store Transfer'),
        ('official', 'Official'),

    ]

    delivery_type = models.CharField(max_length=20, choices=type_choices, default='transfer')

    status_choices = [
        ('pending', 'Pending'),
        ('schedule', 'Scheduled'),
        ('in_transit', 'In Transit'),
        ('delivered', 'Delivered'),
        ('cancelled', 'Cancelled')
    ]
    status = models.CharField(max_length=20, choices=status_choices, default='pending')
    vehicle = models.ForeignKey(Vehicle, on_delete=models.SET_NULL, null=True)
    driver = models.ForeignKey(Driver, on_delete=models.SET_NULL, null=True)
    departure_time = models.DateTimeField(blank=True, null=True)
    arrival_time = models.DateTimeField(blank=True, null=True)
    updated_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True,related_name='updated_by')


    def obj(self):
        return {
            "pk":self.pk,
            "enc":self.enc,
            "requested_by":{
                "username":self.requested_by.username,
                'name':self.requested_by.get_full_name(),
                'email':self.requested_by.email,
            },
            "destination":self.destination,
            'source':self.source,
            "description":self.description,
            "request_date":self.request_date,
            "scheduled_date":self.scheduled_date,
            "delivery_type":self.delivery_type,
            "status":self.status,
            "vehicle":{
                "valid":True if self.vehicle else False,
                "plate_number":self.vehicle.plate_number if self.vehicle else "Not Assigned",
                "description":self.vehicle.description if self.vehicle else "Not Assigned",
            },
            "driver":{
                "valid":True if self.driver else False,
                "name":self.driver.name if self.driver else "Not Assigned",
            },
            "departure_time":self.departure_time,
            "arrival_time":self.arrival_time,
            "duration":0,
            "logs":self.logs()
        }

    def logs(self):
        return [log.obj() for log in DeliveryLog.objects.filter(delivery=self)]

    def __str__(self):
        return f"→ {self.destination} ({self.status})"


class DeliveryLog(models.Model):
    delivery = models.ForeignKey(DeliveryRequest, on_delete=models.CASCADE)
    title = models.CharField(max_length=255,null=False,blank=False)
    details = models.TextField(blank=False, null=False)
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Log for {self.delivery}"


    def obj(self):
        return {
            "pk":self.pk,
            'title':self.title,
            'details':self.details,
            'user':{
                "username":self.user.username,
                'name':self.user.get_full_name(),
            },
            'time':self.timestamp.strftime("%d %b %Y, %I:%M%p").lower(),
        }
