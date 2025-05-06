from django import forms
from .models import ContractorError

class ContractorErrorForm(forms.ModelForm):
    class Meta:
        model = ContractorError
        fields = ['contractor', 'meter', 'error_type', 'description','error_date']
        widgets = {
            'contractor': forms.Select(attrs={'class': 'form-control'}),
            'meter': forms.TextInput(attrs={'class': 'form-control'}),
            'error_type': forms.Select(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control'}),
            'error_date': forms.DateInput(attrs={'class': 'form-control'}),
        }
