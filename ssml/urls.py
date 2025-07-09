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
    path('master/meters/',views.meters,name='meters'),
    path('accounts/finlog/',views.accounts,name='accounts'),
    path('accounts/invoice/',views.invoice,name='cont-invoice'),
    path('account/new-cont-inv/',views.invoice_new,name='new-cont-inv'),


    path('inventory/grn/', views.grn, name='grn'),
    path('inventory/grn/add/', views.grn_add, name='grn_add'),
    path('inventory/grn/edit/<int:id>/', views.grn_edit, name='grn_edit'),
    path('inventory/issue/', views.issue, name='issue'),
    path('inventory/issue/add/', views.issue_add, name='issue_add'),
    path('inventory/issue/edit/<int:id>/', views.issue_edit, name='issue_edit'),
    path('inventory/redeem/',views.redeem,name='redeem'),
    path('inventory/redeem/new/',views.new_redemption,name='new_redemption'),
    path('api/', ssml_api.interface, name='api'),
    path('upload_image/', views.upload_image, name='upload_image'),
    path('work-order/plots/', views.plots, name='plots'),
    path('work-order/services/', views.services, name='services'),
    path('work-order/service-orders/', views.service_orders, name='service_orders'),
    path('master/contractors/', views.contractors, name='contractors'),
    path('api/contractor/', contractor_api.contractor_api, name='contractors_api'),
    path('service-order/new/', views.service_order_new, name='service_order_new'),
    path('contractor-errors/', views.contractor_errors, name='contractor_errors'),
    path('contractor-errors/add/', views.save_contractor_error, name='save_contractor_error'),
    path('service-order/upload/',views.upload_service_order,name='upload_service_order'),
    path('service-type/view/<id>/',views.servive_type,name='service_type'),
    path('service-type/add-rate-to-type/',views.add_service_to_type,name='add_service_to_type'),
    path('material/add-rate/',views.add_material_rate,name='add_material_rate'),
    path('delete-service-rate/<id>/',views.delete_service_rate,name='delete-service-rate'),
    path('delete-service-type-rate/<id>/',views.delete_type_service_rate,name='delete_type_service_rate'),
    path('master/location_master/',views.location_master,name='ssml_location_master'),
    path('inventory/trenasfer/',views.transfer,name='ssml_transfer'),
    path('inventory/transfer/add/',views.add_transfer,name='ssml_add_transfer'),

]
