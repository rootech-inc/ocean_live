from django.urls import path

from ssml import views, ssml_api

urlpatterns = [
    path('', views.index, name='ssml'),
    path('api/',ssml_api.interface,name='ssml_api')
]