from django.contrib.auth.decorators import login_required
from django.http import HttpResponse
from django.shortcuts import render
from django.utils import timezone

from admin_panel.models import SmsApi, MailSenders
from crm.models import Logs, CrmUsers, FollowUp


# Create your views here.
@login_required()
def base(request):
    # if request.user.is_superuser:
    #     logs = Logs.objects.filter(created_date=timezone.now().date()).order_by('-pk')
    # else:
    #     logs = Logs.objects.filter(owner=request.user, created_date=timezone.now().date()).order_by('-pk')
    logs = Logs.objects.filter(owner=request.user, created_date=timezone.now().date()).order_by('-pk')
    context = {
        'nav': True,
        'page': {
            'title': "CRM",
        },
        'logs': logs,
        'followup':FollowUp.objects.filter(owner=request.user, is_open=True,follow_date__lt=timezone.now().date()).count(),
    }

    return render(request, 'crm/index.html', context=context)

@login_required()
def crm_logs(request):
    pend_val = Logs.objects.filter(created_date=timezone.now().date(), validity=99)
    val_val = Logs.objects.filter(created_date=timezone.now().date(), validity=1)
    not_val = Logs.objects.filter(created_date=timezone.now().date(), validity=0)

    if request.user.is_superuser:
        logs = Logs.objects.filter(created_date=timezone.now().date()).order_by('-pk')
    else:
        logs = Logs.objects.filter(owner=request.user, created_date=timezone.now().date()).order_by('-pk')
        pend_val.filter(owner=request.user)
        val_val.filter(owner=request.user)
        not_val.filter(owner=request.user)



    context = {
        'nav': True,
        'page': {
            'title': "CRM",
        },
        'logs': logs,
        'followup': FollowUp.objects.filter(owner=request.user, is_open=True,
                                            follow_date__lt=timezone.now().date()).count(),
        'val':{
            'pend':pend_val.count(),
            'val':val_val.count(),
            'nott':not_val.count(),
        }

    }

    return render(request, 'crm/logs.html', context=context)

@login_required()
def follows(request):
    if request.user.is_superuser:
        logs = FollowUp.objects.filter(is_open=True).order_by('-pk')
    else:
        logs = FollowUp.objects.filter(owner=request.user, is_open=True).order_by('-pk')
    context = {
        'nav': True,
        'page': {
            'title': "CRM Follow Up",
        },
        'logs': logs
    }

    return render(request, 'crm/follow.html', context=context)

@login_required()
def crm_users(request):
    context = {
        'nav': True,
        'page': {
            'title': "CRM USERS",
        },
        'users': CrmUsers.objects.all().order_by('-pk')
    }

    return render(request, 'crm/crm-users.html', context=context)

@login_required()
def crm_tools(request):
    context = {
        'nav': True,
        'page': {
            'title': "CRM TOOLS",
        },
        'users': CrmUsers.objects.all().order_by('-pk')
    }

    return render(request, 'crm/crm-tools.html', context=context)

@login_required()
def contacts(request):
    return render(request, 'crm/contacts.html', context={
        'nav': True,
        'page': {'title': "CRM Contacts"}
    })

@login_required()
def campaigns(request):
    return render(request, 'crm/campaigns.html', context={
        'nav': True,
        'page': {'title': "Campaigns"}
    })

@login_required()
def new_campaign(request):
    return render(request, 'crm/campaigns-new.html', context={
        'nav': True,
        'page': {'title': "New Campaigns"},
        'smsapis': SmsApi.objects.all(),
        'mss':MailSenders.objects.all()
    })
