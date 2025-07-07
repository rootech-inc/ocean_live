from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from admin_panel.models import UserAddOns

@login_required()
def index(request):
    context = {
        'nav': True,
        'page': {
            'title': "Employee",
            'nav':True
        }
    }

    return render(request,'employee/landing.html',context=context)

@login_required()
def area(request):
    context = {
        'nav': True,
        'page': {
            'title': "Area",
            'nav':True
        }
    }

    return render(request,'employee/area.html',context=context)

@login_required()
def departments(request):
    context = {
        'nav': True,
        'page': {
            'title': "Departments",
            'nav':True
        }
    }

    return render(request,'employee/dept.html',context=context)

@login_required()
def employees(request):
    context = {
        'nav': True,
        'page': {
            'title': "Attendance",
            'nav':True
        }
    }

    return render(request,'employee/staff.html',context=context)

@login_required()
def attendance(request):
    context = {
        'nav': True,
        'page': {
            'title': "Employee",
            'nav': True
        }
    }

    return render(request, 'employee/attendance.html', context=context)


@login_required()
def leave(request):
    context = {
        'nav': True,
        'page': {
            'title': "Leave",
            'nav': True
        },
        'my_adon':UserAddOns.objects.get(user=request.user)
    }

    return render(request, 'employee/leave.html', context=context)


def master_leave(request):
    context = {
        'nav': True,
        'page': {
            'title': "Leave",
            'nav': True
        }
    }

    return render(request,'employee/leaves.html',context=context)

@login_required()
def monthly_attendance(request):
    context = {
        'nav': True,
        'page': {
            'title': "Monthly Attendance",
            'nav': True
        }
    }

    return render(request, 'employee/monthly-attendance.html', context=context)