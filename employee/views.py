from django.shortcuts import render

# Create your views here.
def index(request):
    context = {
        'nav': True,
        'page': {
            'title': "Employee",
            'nav':True
        }
    }

    return render(request,'employee/landing.html',context=context)