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
from . import views,employee_api

urlpatterns = [
    path('', views.index, name='company'),
    path('area/', views.area, name='area'),
    path('departments/', views.departments, name='departments'),
    path('employees/', views.employees, name='staffs'),
    path('api/', employee_api.interface, name='reports_api'),
    path('master/attendance/',views.attendance,name='staff_attendance'),
    path('self-service/leave/', views.leave, name='staff_leave'),
]
