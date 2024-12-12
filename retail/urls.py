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
from . import views, retail_api

urlpatterns = [
    path('', views.base, name='retail'),
    path('api/', retail_api.interface, name='retail_api'),
    path('clerks/', views.clerks, name='clerks'),
    path('save_clerk/', views.save_clerk, name='save_clerk'),
    path('sync_clerks/<fr>/', views.sync_clerks, name='sync_clerks'),
    path('bolt/products/', views.bolt_products, name='bolt_products'),
    path('bolt/products/pending/', views.bolt_products_pending, name='bolt_products_pending'),
    path('bolt/categories/', views.bolt_groups, name='bolt_groups'),
    path('bolt/category/<pk>/', views.bolt_category, name='bolt_category'),
    path('bolt/upload_image/',views.bolt_upload_image,name='bolt_upload_image'),
    path('products/<int:page>/', views.products, name='products'),
    path('products/card/', views.product_card, name='retail_product_card'),
    path('recipe/', views.recipe, name='recipe'),
    path('recipe/group/<int:group_id>/', views.recipe_group, name='recipe_group'),
    path('recipe/upload_item_image/',views.upload_item_image,name='upload_item_image'),
    path('recipe/card/',views.recipe_card,name='recipe_card'),
    path('stock/', views.stock, name='retail_stock'),
    path('stock/monitoring/',views.stock_monitor,name='stock_monitor'),
    path('retail_butch_moni/',views.retail_butch_moni,name='retail_butch_moni'),
    path('stock-to-send/',views.stock_to_send,name='stock_to_send'),
    path('price-change/',views.retail_price_change,name='retail_price_change'),
    path('samples',views.samples,name='samples')

]

# handler404 = 'blog.views.handler404'
