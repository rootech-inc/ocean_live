from django.shortcuts import redirect, render
from django.contrib.auth.decorators import login_required

from ssml.models import Contractor, Grn, GrnTransaction, InventoryMaterial, Issue, IssueTransaction, Plot, Supplier
# Create your views here.
@login_required
def index(request):
    page = {
        'title': 'SSML',
        'page': 'ssml',
        'page_title': 'SSML',
        'page_description': 'SSML',
        'page_icon': 'bi bi-app',
        'page_url': 'ssml',
        'page_url_name': 'SSML',
        'nav':True
    }

    context = {
        'page': page
    }
    return render(request, 'ssml/index.html', context)

@login_required
def materials(request):
    page = {
        'title': 'Materials',
        'page': 'materials',
        'page_title': 'Materials',
        'page_description': 'Materials',
        'nav':True
    }
    context = {
        'page': page
    }
    return render(request, 'ssml/materials.html', context)

@login_required
def grn(request):
    if Grn.objects.count() == 0:
        return redirect('grn_add')
    else:
        last_grn = Grn.objects.last()
        last_grn_no = last_grn.grn_no
        last_grn_date = last_grn.grn_date
        last_grn_remarks = last_grn.remarks
        last_grn_created_by = last_grn.created_by
        last_grn_total_amount = last_grn.total_amount
        last_grn_total_qty = last_grn.total_qty
    page = {
        'title': 'GRN',
        'page': 'grn',
        'page_title': 'GRN',
        'page_description': 'GRN',
        'nav':True
    }
    context = {
        'page': page,
        'last_grn': last_grn,
        'last_grn_no': last_grn_no,
        'last_grn_date': last_grn_date,
        'last_grn_remarks': last_grn_remarks,
        'last_grn_created_by': last_grn_created_by,
        'last_grn_total_amount': last_grn_total_amount,
        'last_grn_total_qty': last_grn_total_qty,
        'last_grn_transactions': GrnTransaction.objects.filter(grn_id=last_grn.pk),
        'last_grn_next_row': last_grn.next_row(),
        'last_grn_prev_row': last_grn.prev_row(),
        'last_grn_status': last_grn.status()
    }
    return render(request, 'ssml/grn.html', context)

@login_required
def issue(request):
    if Issue.objects.count() == 0:
        return redirect('issue_add')
    else:
        last_issue = Issue.objects.last()
        last_issue_no = last_issue.issue_no
        last_issue_date = last_issue.issue_date
        last_issue_remarks = last_issue.remarks
    page = {
        'title': 'Issue',
        'page': 'issue',
        'page_title': 'Issue',
        'page_description': 'Issue',
        'nav':True
    }
    context = {
        'page': page,
        'last_issue': last_issue,
        'last_issue_no': last_issue_no,
        'last_issue_date': last_issue_date,
        'last_issue_remarks': last_issue_remarks,
        'last_issue_transactions': IssueTransaction.objects.filter(issue_id=last_issue.pk),
        'last_issue_next_row': last_issue.next_row(),
        'last_issue_prev_row': last_issue.prev_row(),
        'last_issue_status': last_issue.status()
    }
    return render(request, 'ssml/issue.html', context)

@login_required
def issue_add(request):
    page = {
        'title': 'Add Issue',
        'page': 'issue_add',
        'page_title': 'Add Issue',
        'page_description': 'Add Issue',
        'nav':True
    }
    context = {
        'page': page,
        'issue_types': Issue.issue_type_choices
    }
    return render(request, 'ssml/issue_add.html', context)

@login_required
def grn_add(request):
    page = {
        'title': 'Add GRN',
        'page': 'grn_add',
        'page_title': 'Add GRN',
        'page_description': 'Add GRN',
        'nav':True
    }
    context = {
        'page': page,
        
    }   
    return render(request, 'ssml/grn_add.html', context)

@login_required
def grn_edit(request, id):
    page = {
        'title': 'Edit GRN',
        'page': 'grn_edit',
        'page_title': 'Edit GRN',
        'page_description': 'Edit GRN',
        'nav':True
    }
    context = {
        'page': page,
        'grn': Grn.objects.get(id=id),
        'grn_transactions': GrnTransaction.objects.filter(grn_id=id),
        'nav':True,
        'suppliers': Supplier.objects.all(),
        'grn_date_to_html': Grn.objects.get(id=id).grn_date.strftime('%Y-%m-%d')
    }
    return render(request, 'ssml/grn_edit.html', context)

@login_required
def upload_image(request):
    if request.method == 'POST':
        id = request.POST.get('id')
        image = request.FILES.get('image')
        material = InventoryMaterial.objects.get(id=id)
        material.image = image
        material.save()
        return redirect('materials')
    return redirect('materials')

@login_required
def issue_edit(request, id):
    page = {
        'title': 'Edit Issue',
        'page': 'issue_edit',
        'page_title': 'Edit Issue',
        'page_description': 'Edit Issue',
        'nav':True
    }
    context = {
        'page': page,
        'issue': Issue.objects.get(id=id),
        'issue_transactions': IssueTransaction.objects.filter(issue_id=id),
        'contractors': Contractor.objects.all(),
        'issue_date_to_html': Issue.objects.get(id=id).issue_date.strftime('%Y-%m-%d'),
        'issue_types': Issue.issue_type_choices
    }
    return render(request, 'ssml/issue_edit.html', context)

@login_required
def plots(request):
    page = {
        'title': 'Plots',
        'page': 'plots',
        'page_title': 'Plots',
        'page_description': 'Plots',
        'nav':True
    }
    context = {
        'page': page
    }
    return render(request, 'ssml/plots.html', context)


@login_required
def service_orders(request):
    page = {
        'title': 'Service Order',
        'page': 'service_order',
        'page_title': 'Service Order',
        'page_description': 'Service Order',
        'nav':True
    }
    context = {
        'page': page,
        'contractors': Contractor.objects.all(),
        'plots': Plot.objects.all(),
        'service_types': {
            'water': 'Water',
            'electricity': 'Electricity',
            'sewerage': 'Sewerage',
            'gas': 'Gas',
            'telecom': 'Telecom'
        }
    }
    return render(request, 'ssml/service_order.html', context)


@login_required
def services(request):
    page = {
        'title': 'Services',
        'page': 'services',
        'page_title': 'Services',
        'page_description': 'Services',
        'nav':True
    }
    context = {
        'page': page
    }
    return render(request, 'ssml/services.html', context)

@login_required
def contractors(request):
    page = {
        'title': 'Contractors',
        'page': 'contractors',
        'page_title': 'Contractors',
        'page_description': 'Contractors',
        'nav':True
    }
    context = {
        'page': page,
        'contractors': Contractor.objects.all()
    }
    return render(request, 'ssml/contractors.html', context)

