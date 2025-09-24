import csv
import json
import traceback
from datetime import date
from django.db import IntegrityError
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.http import HttpResponse, JsonResponse
from django.shortcuts import redirect, render, get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from fpdf import FPDF

from admin_panel.models import SmsApi, Sms
from cmms.forms import NewSalesCustomer, NewSaleTransactions
from inventory.models import Assets
from maintenance.models import WorkOrder
from ocean.settings import DB_SERVER, DB_NAME, DB_USER, DB_PORT, DB_PASSWORD
from django.contrib.auth import get_user_model
import pyodbc
from cmms.models import *
from decimal import Decimal
from django.contrib import messages

from cmms.extra import db



# Create your views here.
def base(request):
    return HttpResponse("Module Discontinued.......")
    page = {
        'nav': True,
        'title': "CMMS"
    }

    context = {
        'page': page,
        'nav': True,
        'searchButton': ''
    }
    return render(request, 'cmms/cmms-landing.html', context=context)


@login_required(login_url='/login/')
def carjobs(request):
    # return HttpResponse("Module Discontinued..")
    page = {
        'nav': True,
        'title': "Car Jobs"
    }

    context = {
        'page': page,
        'nav': True,
        'searchButton': 'carJob'
    }
    # messages.info(request, "You can now view all data but limited to 100 records")
    return render(request, 'cmms/car-jobs.html', context=context)


@login_required()
def tools(request):
    context = {
        'nav': True
    }
    return render(request, 'cmms/tools.html', context=context)


@login_required()
def stock(request):
    opened = False
    if StockCountHD.objects.filter(status=1).count() == 1:
        opened = True
    return render(request, 'cmms/stock.html',
                  context={'nav': True, 'stocks': StockCountHD.objects.all(), 'open': opened})


@login_required()
def new_frozen(request):
    context = {'nav': True}
    return render(request, 'cmms/new_stock.html', context=context)


def new_count(request, frozen):
    context = {'nav': True}
    return render(request, 'cmms/count.html', context=context)


@login_required()
def forezen(request):
    froze = StockFreezeHd.objects.all()
    if froze.count() < 1:
        messages.warning(request, "PLEASE FREEZE NEW STOCK")
        return redirect('/cmms/stock/frozen/new/')
    else:
        f_pk = froze.last().pk
    context = {'nav': True, 'f_pk': f_pk}
    return render(request, 'cmms/frozen.html', context=context)


@login_required()
def new_stock_count(request):
    # if StockCountHD.objects.filter(status=1).count() != 1:
    #     messages.error(request, 'NO OPEN STOCK COUNT.')
    #     return redirect('/cmms/stock/')
    context = {
        'nav': True,
        'page': {
            'title': "STOCK COUNT"
        }
    }
    return render(request, 'cmms/count.html', context=context)


@login_required()
def view_stock_count(request):
    if StockCountHD.objects.filter(status=1).count() < 1:
        messages.error(request, 'NO OPEN STOCK COUNT.')
        return redirect('/cmms/stock/new/')
    context = {
        'nav': True,
        'page': {
            'title': "STOCK COUNT VIEW"
        },
        'c_pk': StockCountHD.objects.filter(status=1).last().pk
    }
    return render(request, 'cmms/count_view.html', context=context)


@login_required()
def edit_stock_count(request, pk):
    if StockCountHD.objects.filter(pk=pk).count() < 1:
        messages.error(request, 'NO OPEN STOCK COUNT.')
        return redirect('/cmms/stock/new/')
    context = {
        'nav': True,
        'page': {
            'title': "STOCK COUNT VIEW"
        },
        'c_pk': pk
    }
    return render(request, 'cmms/count_edit.html', context=context)


@login_required()
def compare(request, pk, as_of, group):
    # get counts
    hd = StockCountHD.objects.get(pk=pk)
    wrong_entries = StockCountTrans.objects.filter(stock_count_hd=hd, issue__in='wr_entry').count()
    sys_error = StockCountTrans.objects.filter(stock_count_hd=hd, issue__in='sys_error').count()
    lost = StockCountTrans.objects.filter(stock_count_hd=hd, issue__in='lost').count()
    unknown = StockCountTrans.objects.filter(stock_count_hd=hd, issue__in='unknown').count()
    return render(request, 'cmms/compare.html', context={
        'nav': True,
        'as_of': as_of,
        'pk': pk,
        'group': group,
        'wrong_entries': wrong_entries,
        'sys_error': sys_error,
        'lost': lost,
        'unknown': unknown,

    })


@login_required()
def customer_sales(request):
    context = {
        'nav': True,
        'page': {
            'title': "SALES CUSTOMERS"
        },
        'customers': SalesCustomers.objects.all().order_by('-pk')
    }
    return render(request, 'cmms/sales-customer.html', context=context)


@login_required()
def new_sales_customer(request):
    context = {
        'nav': True,
        'page': {
            'title': "NEW SALES CUSTOMER"
        }
    }
    return render(request, 'cmms/new-sales-customer.html', context=context)


@login_required()
def save_sales_customer(request):
    if request.method == 'POST':
        try:
            form = NewSalesCustomer(request.POST)
            mobile = request.POST['mobile']
            email = request.POST['email']
            company = request.POST['company']
            if SalesCustomers.objects.filter(mobile=mobile).exists():
                messages.error(request, f"Customer exist with number {mobile}")
            elif SalesCustomers.objects.filter(email=email).exists():
                messages.error(request, f"Customer exist with number {mobile}")
            elif SalesCustomers.objects.filter(company=company).exists():
                messages.error(request, f"Customer from company {company}")
            elif form.is_valid():
                try:
                    form.save()
                    messages.success(request, "CUSTOMER ADDED")
                except IntegrityError:
                    messages.error(request, "CUSTOMER ALREADY EXISTS")
                except Exception as e:
                    messages.error(request, str(e))
            else:
                messages.error(request, "FORM IS INVALID")
        except Exception as e:
            messages.error(request, e)
    else:
        messages.error(request, "WRONG REQUEST METHOD")

    return redirect('customer_sales')


# def sales_customer_transactions(request, customer):
#     context = {
#         'page': {
#             'title': ""
#         },
#         'cust': SalesCustomers.objects.get(pk=customer)
#     }
#     return render(request, 'cmms/sales_transactions.html', context=context)

@login_required()
def save_sales_transaction(request):
    if request.method == 'POST':
        form = NewSaleTransactions(request.POST)
        if form.is_valid():
            try:
                form.save()
                messages.error(request, "TRANSACTION SAVED")

            except Exception as e:
                messages.error(request, str(e))
            # To return to the previous page
            previous_page = request.META.get('HTTP_REFERER')
            return redirect(previous_page)
        else:
            messages.error(request, "FORM IS INVALID")
    else:
        messages.error(request, "WRONG REQUEST METHOD")

    return redirect('customer_sales')


@login_required()
def service_customers(request):
    context = {
        'nav': True,
        'page': {

            'title': "SERVICE CUSTOMERS"
        }
    }
    return render(request, 'cmms/service/customers.html', context=context)

@login_required()
def servicing(request):
    
    context = {
        'nav': True,
        'page': {

            'title': "CMMS SERVICING"
        },
        'jobs':JobCard.objects.filter(is_ended=False).order_by('-pk')
    }
    return render(request, 'cmms/service/index.html', context=context)


@login_required()
def sales_deal(request, customer):
    # validate customer
    if SalesCustomers.objects.filter(url=customer).count() == 1:
        cust = SalesCustomers.objects.get(url=customer)
        context = {
            'nav': True,
            'page': {
                'title': f"{cust.company} {cust.pk} / DEALS"
            },
            'customer': cust,
            'models':CarModel.objects.all().order_by('model_name')
        }

        return render(request, 'cmms/sales-cust.html', context=context)
    else:
        messages.error(request, f"NO CUSTOMER WITH URL {customer}")
        return redirect('customer_sales')


@login_required()
def service_customer(request, customer_code):
    context = {
        'nav': True,
        'page': {

            'title': "SERVICE CUSTOMER"
        },
        'customer': customer_code
    }
    return render(request, 'cmms/service/customer.html', context=context)


@login_required()
def sales(request):

    context = {
        'nav': True,
        'page': {

            'title': "Sales / Proforma"
        },
        'proformas': ProformaInvoice.objects.all()
    }
    return render(request, 'cmms/service/sales.html', context=context)


@login_required()
def proforma_approval_requests(request):
    context = {
        'nav': True,
        'page': {

            'title': "Sales / Proforma / Approval"
        },
        'proformas': ProformaInvoice.objects.filter(approval_request=True,is_approved=False)
    }
    return render(request, 'cmms/service/pending_proforma.html', context=context)


@login_required()
def sales_assets(request):
    if Car.objects.filter(pk__gt=0).exists():
        last_pk = Car.objects.all().last().pk
        context = {
            'nav': True,
            'page': {
                'title': "Sales / Assets"
            },
            'last_pk': last_pk
        }
        return render(request, 'cmms/sales/assets.html', context=context)
    else:
        return redirect('new_sales_assets')


@login_required()
def new_sales_asset(request):
    context = {
        'nav': True,
        'page': {

            'title': "Sales / Assets/ New"
        },
        'suppliers':CarSupplier.objects.all().order_by('name'),
        'origins':CarOrigin.objects.all().order_by('country'),
        'mans':CarManufacturer.objects.all().order_by('name')
    }
    return render(request, 'cmms/sales/new_asset.html', context=context)


@login_required()
def sales_tools(request):
    context = {
        'nav': True,
        'page': {

            'title': "Sales / Tools"
        }
    }
    return render(request, 'cmms/sales/tools.html', context=context)

@login_required()
def model_spec(request, model_pk):
    if CarModel.objects.filter(pk=model_pk).count() == 1:
        mod = CarModel.objects.get(pk=model_pk)
        context = {
            'nav': True,
            'page': {

                'title': f"Sales / {mod.model_name} / Specs",

            },
            'model': mod
        }

        return render(request, 'cmms/sales/model_spec.html', context=context)
    else:
        return HttpResponse("Invalid Model")
@login_required()
def approve_po(request,po_pk):
    if ProformaInvoice.objects.filter(pk=po_pk).count()==1:
        entry = ProformaInvoice.objects.get(pk=po_pk)
        context = {
            'nav': True,
            'page': {

                    'title': f"Sales / PO / Approve",
                },
            'document':po_pk,
            'entry':entry
        }

        return render(request,'cmms/sales/approve-po.html',context=context)
    else:
        return redirect('prod_appr_req')

@login_required()
def cars(request):
    context = {
        'nav': True,
        'page': {

            'title': "CMMS SERVICE CARS"
        }
    }
    return render(request, 'cmms/service/cars.html', context=context)

@login_required()
def invoices(request):
    context = {
        'nav': True,
        'page': {

            'title': "CMMS SERVICE INVOICES"
        }
    }
    return render(request, 'cmms/service/invoices.html', context=context)


def newjob(request):

    context = {
        'nav': False,
        'page': {

            'title': ""
        }
    }
    return render(request, 'cmms/service/new.html', context=context)

@login_required()
def save_serv_job_images(request):
    service_pk = request.POST.get('job_id')
    files = request.FILES.getlist('file[]')

    for file in files:
        JobCardImages.objects.create(
            jobcard_id=service_pk,
            image=file
        )

    return redirect('cmms_servicing')

@login_required()
def view_service_card(request,pk):
    if JobCard.objects.filter(pk=pk).exists():
        context = {
            'nav': True,
            'page': {

                'title': "CMMS SERVICE / VIEW"
            },
            'card':JobCard.objects.get(pk=pk)
        }
        return render(request, 'cmms/service/view.html', context=context)

@login_required()
def servicing_mr(request):
    context = {
        'nav': True,
        'page': {

            'title': "CMMS SERVICE / CLOSE SERVICE REQUEST"
        },
        'reqs':JobMaterials.objects.filter(is_issued=False)

    }
    return render(request, 'cmms/service/mr.html', context=context)

@login_required()
def view_service_close(request,pk):

    context = {
        'nav': True,
        'page': {

            'title': "CMMS SERVICE / CLOSE SERVICE"
        },
        'job':JobCard.objects.get(pk=pk)

    }
    return render(request, 'cmms/service/close.html', context=context)

@login_required()
def cmms_servicing_feedback(request):
    # JobCardFeedback.objects.all().delete()
    # JobCard.objects.all().update(is_feedback=False)

    context = {
        'nav': True,
        'page': {

            'title': "CMMS SERVICE / Feedbacks"
        },
        'jobs': JobCard.objects.filter(is_feedback=False, is_ended=True,
                                       end_date__lte=date.today() - timedelta(days=3)).order_by('-pk')[:50],
        'feeds':JobCardFeedback.objects.all().order_by('-created_date')[:50]

    }
    return render(request, 'cmms/service/service_feedback.html', context=context)


def service_request(request):
    context = {
        'nav': True,
        'page': {
            'nav':True,
            'title': "CMMS SERVICE / Requests"
        },
        'reqs':JobRequest.objects.filter(is_started=False)


    }
    return render(request, 'cmms/service/service_requests.html', context=context)

@login_required()
@csrf_exempt
def start_job(request):
    if request.method == 'POST':
        form = request.POST
        job_id = form.get('job_id')
        job_request = JobRequest.objects.get(pk=job_id)

        # create work order
        work_order = JobCard.objects.create(
            company=job_request.company_name,
            driver=job_request.driver_name,
            contact=job_request.driver_phone,
            brand = job_request.car_brand,
            model = job_request.car_model,
            carno=job_request.car_no,
            owner=request.user,
            mechanic="auto",
            report=job_request.problem,


        )

        # make images
        JobCardImages(
            jobcard_id=work_order.pk,
            image=request.FILES.get('interior'),
            part='interior'
        ).save()

        JobCardImages(
            jobcard_id=work_order.pk,
            image=request.FILES.get('exterior'),
            part='exterior'
        ).save()

        JobCardImages(
            jobcard_id=work_order.pk,
            image=request.FILES.get('toolbox'),
            part='toolbox'
        ).save()

        JobCardImages(
            jobcard_id=work_order.pk,
            image=request.FILES.get('fire_extinguisher'),
            part='fire_extinguisher'
        ).save()

        JobCardImages(
            jobcard_id=work_order.pk,
            image=request.FILES.get('mileage'),
            part='mileage'
        ).save()

        JobCardImages(
            jobcard_id=work_order.pk,
            image=request.FILES.get('triangle'),
            part='triangle'
        ).save()

        sms_message = f"Job for car with registeration {job_request.car_no} started, teack with link below. \n\nhttps://titmouse-in-perch.ngrok-free.app/cmms/servcing/track/{job_request.entry_no}/"
        sms_to = job_request.driver_phone

        job_request.is_started = True
        job_request.jobcard = work_order
        job_request.save()
        Sms(
            api=SmsApi.objects.get(is_default=True),
            to=sms_to,
            message=sms_message
        ).save()

        JobCardTransactions(
            jobcard=work_order,
            title="JOB STARTED",
            details=f"Job started with internal work order number {form.get('wr_no')}",
            owner=request.user,
        ).save()
        messages.success(request, "JOB STARTED")
        previous_page = request.META.get('HTTP_REFERER')
        return redirect(previous_page)
    else:
        return HttpResponse("ERROR")


def delete_job_request(request):
    pk = request.GET.get('id')
    JobRequest.objects.get(pk=pk).delete()
    previous_page = request.META.get('HTTP_REFERER')
    return redirect(previous_page)


def track_job(request,req_id):
    job = None
    try:
        req = JobRequest.objects.get(entry_no=req_id)
        job = req.jobcard
    except Exception as e:
        messages.error(request, f"NO JOB FOR {req_id}")
    return render(request,'cmms/service/track_job.html',context={

        'page':{
            'title':"CMMS SERVICE / Track Job"
        },
        'job':job
    })


def cmms_service_due(request):
    context = {
        'nav': True,
        'page': {

            'title': "CMMS SERVICE / Service Due"
        },
        'jobs': JobCard.objects.filter(is_feedback=False, is_ended=True).order_by('-pk')[:50],
        'feeds': JobCardFeedback.objects.all()

    }
    return render(request, 'cmms/service/servcice_due.html', context=context)