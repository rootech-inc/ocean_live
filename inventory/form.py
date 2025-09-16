from django import forms

from inventory.models import AssetGroup, Assets, WorkStation, Evidence, VehicleAsset


class NewAssetGroup(forms.ModelForm):
    class Meta:
        model = AssetGroup
        exclude = ['created_on']


class NewAsset(forms.ModelForm):
    class Meta:
        model = Assets
        exclude = ['created_on']

class NewWorkstation(forms.ModelForm):
    class Meta:
        model = WorkStation
        exclude = ['created_date','created_time','status']

class EvidenceForm(forms.ModelForm):
    class Meta:
        model = Evidence
        exclude = ['created_date','created_time','updated_date','updated_time']

class VehicleAssetForm(forms.ModelForm):

    class Meta:
        model = VehicleAsset
        fields = "__all__"