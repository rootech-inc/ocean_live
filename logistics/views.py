from django.contrib.auth.decorators import login_required
from django.http import HttpResponse
from django.shortcuts import render

from logistics.models import DeliveryRequest


@login_required
def home(request):
    context = {
        'nav':True,
        "page":{
            "title":"Logistics",
        }
    }
    return render(request,'logistics/index.html',context=context)


def newdelivery(request):

    context = {
        'nav':True,
        "page":{
            "title":"Delivery Request",
        }
    }

    context['type_choices'] = DeliveryRequest.type_choices

    return render(request,'logistics/delivery_request.html',context=context)


def delivery_details(request,enc):
    context = {
        'nav':True,
        "page":{
            "title":"Delivery Details",
        }
    }
    context['enc'] = enc
    return render(request,'logistics/delivery_details.html',context=context)