"""ocean URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from . import views
from . import ssml_api  
from .api import contractor_api

urlpatterns = [
    path('', views.index, name='ssml'),
    path('inventory/materials/', views.materials, name='materials'),
    # path('ssml/',include('ssml.urls')),
    path('inventory/grn/', views.grn, name='grn'),
    path('inventory/grn/add/', views.grn_add, name='grn_add'),
    path('inventory/grn/edit/<int:id>/', views.grn_edit, name='grn_edit'),
    path('inventory/issue/', views.issue, name='issue'),
    path('inventory/issue/add/', views.issue_add, name='issue_add'),
    path('inventory/issue/edit/<int:id>/', views.issue_edit, name='issue_edit'),
    path('api/', ssml_api.interface, name='api'),
    path('upload_image/', views.upload_image, name='upload_image'),
    path('work-order/plots/', views.plots, name='plots'),
    path('work-order/services/', views.services, name='services'),
    path('work-order/service-orders/', views.service_orders, name='service_orders'),
    path('master/contractors/', views.contractors, name='contractors'),
    path('api/contractor/', contractor_api.contractor_api, name='contractors_api'),
    path('service-order/new/', views.service_order_new, name='service_order_new'),
]
