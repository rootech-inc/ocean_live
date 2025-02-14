import datetime

from django.contrib.auth.models import User
from django.db import models
from django.utils import timezone

from admin_panel.anton import make_md5_hash
from admin_panel.models import GeoCity, GeoCitySub


def get_username_on_delete(user):
    return user.username if user else None


class Sector(models.Model):
    name = models.CharField(max_length=255, unique=True)
    owner = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    is_active = models.BooleanField(default=True)

    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def ob(self):
        return {
            'pk': self.pk,
            'name': self.name,
            'owner': self.owner.get_full_name(),
            'is_active': self.is_active,
            'created_on': self.created_on
        }


class Positions(models.Model):
    name = models.CharField(max_length=255, unique=True)
    owner = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    is_active = models.BooleanField(default=True)

    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def ob(self):
        return {
            'pk': self.pk,
            'name': self.name,
            'owner': self.owner.get_full_name(),
            'is_active': self.is_active,
            'created_on': self.created_on
        }


# Create your models here.
class Logs(models.Model):
    customer = models.TextField(null=False, blank=False)
    success = models.BooleanField(default=True)
    phone = models.CharField(max_length=10)
    subject = models.TextField()
    description = models.TextField()
    owner = models.ForeignKey(User, blank=True, null=True, on_delete=get_username_on_delete)
    created_date = models.DateField()
    entry_date = models.DateField(auto_now_add=True)
    created_time = models.TimeField(auto_now_add=True)
    company = models.TextField(blank=True)
    position = models.ForeignKey(Positions, on_delete=models.SET_NULL, null=True)
    email = models.TextField(blank=True)
    sector = models.ForeignKey(Sector, on_delete=models.SET_NULL, null=True, blank=True)

    city = models.ForeignKey(GeoCity, on_delete=models.SET_NULL, null=True, blank=True)
    suburb = models.ForeignKey(GeoCitySub,on_delete=models.SET_NULL, null=True, blank=True)
    address = models.TextField(blank=True)
    google_sync = models.BooleanField(default=False)

    validity = models.IntegerField(default=99) # 0 = invalid, 1 = valid, 99 = pending

    def status(self):
        if self.validity == 99:
            return {
                'message':"pending validation",
                'class':'bg-secondary'
            }
        elif self.validity == 1:
            return {
                'message': "valid",
                'class': 'bg-success'
            }
        elif self.validity == 0:
            return {
                'message': "invalid",
                'class': 'bg-danger'
            }
        else:
            return {
                'message': f"Unknown {self.validity}",
                'class': 'bg-warning'
            }

    def geo(self):
        ct = "Unknown"
        if self.city:
            ct = self.city.name

        sb = "Unknown"
        if self.suburb:
            sb = self.suburb.name

        return {
            'city':ct,
            'suburb':sb
        }

    def followup_date(self):
        f_date = None
        if FollowUp.objects.filter(log=self).exists():
            fl = FollowUp.objects.get(log=self)
            f_date = str(fl.follow_date)

        return f_date

    def validations(self):
        arr = []
        logs = LogValidity.objects.filter(log=self)
        for log in logs:
            arr.append({
                'part':log.part,
                'is_valid':log.is_valid,
            })

    def contact(self):
        return {
            'name':self.customer,
            'email':make_md5_hash(self.email.strip()),
            'phone':make_md5_hash(self.phone.strip()),
            'address':self.address,
            'company':self.company
        }

    def obj(self):
        return {
            'pk':self.pk,
            'customer':self.customer,
            'success':self.success,
            'phone':self.phone,
            'subject':self.subject,
            'description':self.description,
            'owner':self.owner.get_full_name(),
            'created_date':self.created_date,
            'entry_date':self.entry_date,
            'created_time':self.created_time,
            'company':self.company,
            'position':self.position.name,
            'email':self.email,
            'sector':{
                'pk':self.sector.pk,
                'name':self.sector.name
            },
            'city':{
                'pk':self.city.pk,
                'name':self.city.name
            },
            'suburb':{
                'pk':self.suburb.pk,
                'name':self.suburb.name
            },
            'address':self.address,
            'position':{
                'pk':self.position.pk,
                'name':self.position.name
            },
            'google_sync':self.google_sync,
            'validity':self.validity,
        }

class LogValidity(models.Model):
    log = models.ForeignKey(Logs, on_delete=models.SET_NULL, null=True)
    part = models.CharField(max_length=255,null=False)
    is_valid = models.BooleanField(default=False)

class FollowUp(models.Model):
    log = models.OneToOneField(Logs, on_delete=models.CASCADE, null=False, blank=False)
    owner = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=False, related_name='follow_up_user')
    follow_date = models.DateField(null=False, blank=False)

    is_open = models.BooleanField(default=True)

    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    reason = models.TextField()

    def daypass(self):
        if self.follow_date <= datetime.date.today():
            return True
        else:
            return False


class CrmUsers(models.Model):
    user = models.ForeignKey(User, blank=True, null=True, on_delete=get_username_on_delete)

    def last_logged(self):
        cts = self.logscount()
        if cts > 0:
            last_log = Logs.objects.filter(owner=self.user).last()
            return last_log.created_date
        else:
            return "NO"

    def logscount(self):
        return Logs.objects.filter(owner=self.user).count()

    def todaylogs(self):
        return Logs.objects.filter(owner=self.user,created_date=timezone.now()).count()


class Campaigns(models.Model):
    uni = models.CharField(unique=True, max_length=65)
    title = models.TextField()
    type = models.TextField()
    subject = models.TextField()
    description = models.TextField()
    sender = models.IntegerField(null=False, blank=False)
    message_template = models.TextField()
    created_on = models.DateTimeField(auto_now_add=True)
    is_approved = models.BooleanField(default=False)
    is_scheduled = models.BooleanField(default=False)
    schedule_date = models.DateTimeField(null=True, blank=True)
    is_sent = models.BooleanField(default=False)

    def obj(self):
        return {
            'uni': self.uni,
            'pk': self.pk,
            'title': self.title,
            'type': self.type,
            'description': self.description,
            'message': self.message_template,
            'date':self.created_on,
            'heat':CampaignSense.objects.filter(campaign=self).count(),
            'is_scheduled':self.is_scheduled,
            'shc':self.schedule_date,
        }

    def pending(self):
        return CampaignTargets.objects.filter(campaign=self,is_sent=False)



class CampaignTargets(models.Model):
    campaign = models.ForeignKey(Campaigns, on_delete=models.CASCADE)
    contact = models.CharField(max_length=65)
    name = models.TextField()
    is_sent = models.BooleanField(default=False)
    tried_response = models.TextField(default="Que")
    last_tried = models.DateTimeField(auto_now_add=True)
    created_on = models.DateTimeField(auto_now_add=True)


    class Meta:
        unique_together = (('campaign', 'contact'),)


class CampaignSense(models.Model):
    campaign = models.ForeignKey(Campaigns,on_delete=models.CASCADE)
    source = models.TextField()
    tail = models.TextField(blank=True)
    created_on = models.DateTimeField(auto_now_add=True)

