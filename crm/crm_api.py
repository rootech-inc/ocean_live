import json
import sys
from logging import exception
from venv import create

from django.contrib.auth.models import User
from django.db.models import Q
from django.http import JsonResponse
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt


from admin_panel.anton import make_md5_hash, is_valid_email, is_valid_phone_number, md5only, get_client_ip
from admin_panel.models import Emails, MailQueues, MailSenders, MailAttachments, Reminder, Sms, SmsApi
from cmms.models import CarModel, SalesDeals, SalesCustomers
from crm.models import Logs, CrmUsers, Sector, Positions, FollowUp, Campaigns, LogValidity, CampaignTargets, \
    CampaignSense


@csrf_exempt
def api_interface(request):
    response = {
        'status_code': 0,
        'message': ""
    }

    success_response = {
        'status_code': 200,
        'message': "Procedure Completed Successfully"
    }

    # get method
    method = request.method

    try:
        body = json.loads(request.body)
        module = body.get('module')
        data = body.get('data')

        if method == 'PUT':
            if module == 'log':

                source = data.get('source','entry')
                description = data.get('details').replace('%',',')
                flag = data.get('flag')
                if flag == 'success':
                    flag = True
                else:
                    flag = False
                name = data.get('contact_person','Not Set')
                phone = data.get('phone')
                subject = data.get('subject')
                mypk = data.get('mypk')
                company = data.get('company_name')
                position = data.get('position')
                email = data.get('email')
                sector = data.get('sector')
                city = data.get('city')
                suburb = data.get('suburb')
                address = data.get('address')

                if not is_valid_email(email):
                    raise exception("Invalid Email Address")

                if source == 'upload':
                    # get source by description
                    if Sector.objects.filter(name=sector).exists():
                        sector  = Sector.objects.filter(name=sector).last().pk
                    else:
                        # create Sector
                        owner = request.user
                        Sector.objects.create(name=sector,owner=owner)
                        sector = Sector.objects.get(name=sector,owner=owner).pk

                    if Positions.objects.filter(name=position).exists():
                        post = Positions.objects.filter(name=position).last().pk
                    else:
                        owner = request.user
                        Positions.objects.create(name=position,owner=owner)
                        post = Positions.objects.get(name=position,owner=owner).pk
                    position = post





                print(data)
                # exit(sector)
                current_datetime = timezone.now()
                formatted_date = current_datetime.strftime('%Y-%m-%d')
                created_date = data.get('date', formatted_date)
                if source == 'upload':
                    created_date = data.get('date')

                Logs(description=description, success=flag, customer=name, phone=phone, subject=subject,
                     owner=User.objects.get(pk=mypk),
                     company=company, position_id=position, email=email, sector_id=sector,
                     created_date=created_date,city_id=city,suburb_id=suburb,address=address,google_sync=False,validity=99).save()

                saved_log = Logs.objects.filter(
                    description=description, success=flag, customer=name, phone=phone, subject=subject,
                    owner=User.objects.get(pk=mypk),
                    company=company, position_id=position, email=email, sector_id=sector,
                    created_date=created_date,city_id=city,suburb_id=suburb,address=address
                ).last().pk

                success_response['message'] = saved_log
                own = User.objects.get(pk=mypk)
                if own.username == 'reza':
                    pass
                    #Logs.objects.filter(owner=own).delete()
                response = success_response

            elif module == 'deal_from_log':
                print(data)
                log_pk = data.get('log')
                asset_pk = data.get('asset')
                note = data.get('note')
                mypk = data.get('mypk')
                own = User.objects.get(pk=mypk)
                log = Logs.objects.get(pk=log_pk)
                asset = CarModel.objects.get(pk=asset_pk)
                # create customer
                comp_url = log.company.replace(' ','-').lower()
                if not SalesCustomers.objects.filter(url=comp_url).exists():
                    SalesCustomers(
                        sector_of_company=log.sector.name,
                        type_of_client='Phone Call',
                        company=log.company,
                        url=comp_url,
                        region=log.city,
                        city=log.suburb,
                        address=log.address,
                        mobile=log.phone,
                        email=log.email,
                        fax=log.phone,
                        first_name=log.customer.split(' ')[0],
                        last_name=log.customer.split(' ')[-1],
                        owner=own,
                    ).save()

                customer = SalesCustomers.objects.get(url=comp_url)

                SalesDeals(customer=customer, owner=own, pur_rep_name=f"{log.customer.split(' ')[0]} {log.customer.split(' ')[-1]}",
                           pur_rep_phone=f"{log.phone}",
                           pur_rep_email=f"{log.email}", asset=asset,
                           requirement=note).save()



                success_response['message'] = comp_url
                response  = success_response
                pass
            elif module == 'follow_up':
                print(data)
                log = data.get('log')
                mypk = data.get('mypk')
                follow_date = data.get('follow_date')

                lg = Logs.objects.get(pk=log)
                owner = User.objects.get(pk=mypk)

                FollowUp(log=lg, owner=owner, follow_date=follow_date).save()

                # add reminder
                Reminder(title="Customer Follow Up", message=f"Follow up with {lg.customer} about {lg.subject}",
                         rem_date=follow_date, rem_time="08:30:00", owner=owner, read_only=True).save()

                success_response['message'] = "Follow Up Added"
                response = success_response
            elif module == 'add_user':
                us_pk = data.get('user')
                us = User.objects.get(pk=us_pk)
                if CrmUsers.objects.filter(user=us).count() > 0:
                    pass
                else:
                    CrmUsers(user=us).save()

                success_response['message'] = f"{us.first_name} {us.last_name} ADDED"
                response = success_response
            elif module == 'sector':
                sector = data.get('sector')
                own_pk = data.get('mypk')
                owner = User.objects.get(pk=own_pk)
                Sector(owner=owner, name=sector).save()
                success_response['message'] = "Sector added"

            elif module == 'position':
                sector = data.get('position')
                own_pk = data.get('mypk')
                owner = User.objects.get(pk=own_pk)
                Positions(owner=owner, name=sector).save()
                success_response['message'] = "Position added"

            elif module == "campaign":

                description = data.get('description')
                title = data.get('title')
                c_type = data.get('type')
                # make call back link from title
                # callback = title.to_lower().replace(' ','-')
                uni = ''
                if c_type == 'sms':
                    sms_api = data.get('sms_api')
                    sms_template = data.get('sms_template')

                    uni = make_md5_hash(f"{description, sms_api, sms_template, title}")

                    Campaigns.objects.create(
                        uni=uni,
                        title=title,
                        type=c_type,
                        subject="SMS",
                        description=description,
                        sender=sms_api,
                        message_template=sms_template,
                    )


                if c_type == 'email':
                    sender = data.get('em_sender')
                    subject = data.get('subject')
                    email_template = data.get('email_template')
                    uni = make_md5_hash(f"{description, sender, email_template, title}")

                    Campaigns.objects.create(
                        uni=uni,
                        title=title,
                        type=c_type,
                        subject=subject,
                        description=description,
                        sender=sender,
                        message_template=email_template,
                    )



                camp = Campaigns.objects.get(uni=uni)

                tot = 0
                sms_tot = 0
                em_tot = 0

                # que transactions
                for log in Logs.objects.all():
                    contact = ''
                    if c_type == 'sms':
                        contact = log.phone
                    if c_type == 'email':
                        contact = log.email

                    try:
                        CampaignTargets.objects.create(
                            campaign=camp,
                            contact=contact,
                            name=log.customer,
                        )
                    except Exception as e:
                        pass

                success_response['message'] = f"Campaign Created SSuccessfully"
                response = success_response

        elif method == 'VIEW':
            arr = []

            if module == 'log':
                from django.db.models import Q
                from datetime import datetime

                doc = data.get('doc', 'JSON')
                # Define your filters
                owner_filter = data.get('owner',
                                        '*')  # Replace "owner_name" with the actual owner name you want to filter on
                flag_filter = data.get('flag')
                flag = False
                if flag_filter == 'success':
                    flag = True
                start_date = data.get('start_date', None)  # Replace with your start date
                end_date = data.get('end_date', None)  # Replace with your end date
                position_filter = data.get('position')  # Replace None with the actual position you want to filter on
                sector_filter = data.get('sector','*')  # Replace None with the actual sector you want to filter on

                print(data)

                queryset = Logs.objects.all()
                if owner_filter != '*':
                    queryset = queryset.filter(owner__id=owner_filter)

                if flag_filter is not None and flag_filter != '*':
                    queryset = queryset.filter(flag=flag)

                if start_date is not None and end_date is not None:
                    queryset = queryset.filter(created_date__range=(start_date, end_date))

                if position_filter is not None and position_filter != '*':
                    queryset = queryset.filter(position_id=position_filter)

                if sector_filter is not None and sector_filter != '*':
                    queryset = queryset.filter(sector_id=sector_filter)

                lgo = []
                if doc == 'JSON':
                    for l in queryset:
                        obj = {
                            'customer': l.customer,
                            'subject': l.subject,
                            'detail': l.description,
                            'date': l.created_date,
                            'time': l.created_time,
                            'company': l.company,
                            'position': l.position.name,
                            'email': l.email,
                            'sector': l.sector.name,
                            'success': l.success,
                            'phone': l.phone
                        }

                        lgo.append(obj)
                elif doc == 'excel':
                    import openpyxl
                    book = openpyxl.Workbook()
                    sheet = book.active
                    sheet.title = "CRM Report"

                    sheet["A1"] = "Company"
                    sheet["B1"] = "Sector"
                    sheet['C1'] = "Contact Person"
                    sheet['D1'] = "Position"
                    sheet['E1'] = "Entry Date"
                    sheet['F1'] = "Phone"
                    sheet['G1'] = 'Email'
                    sheet['H1'] = "Subject"
                    sheet['I1'] = "Statue"
                    sheet['J1'] = "Response"

                    sheet_row = 2
                    for log in queryset:
                        sheet[f"A{sheet_row}"] = log.company
                        sheet[f"B{sheet_row}"] = log.sector.name
                        sheet[f"C{sheet_row}"] = log.customer
                        sheet[f"D{sheet_row}"] = log.position.name
                        sheet[f"E{sheet_row}"] = log.created_date
                        sheet[f"F{sheet_row}"] = log.phone
                        sheet[f"G{sheet_row}"] = log.email
                        sheet[f"H{sheet_row}"] = log.subject
                        sheet[f"I{sheet_row}"] = log.success
                        sheet[f"J{sheet_row}"] = log.description
                        sheet_row += 1

                    # save file
                    nn = make_md5_hash(datetime.now())
                    file_name = f'static/general/tmp/crm_report_{nn}.xlsx'
                    book.save(file_name)
                    lgo = file_name

                success_response['message'] = lgo
                response = success_response

            elif module == 'campaign_sense':
                key = data.get('key')
                camp = Campaigns.objects.get(uni=key)
                ip = get_client_ip(request)

                CampaignSense.objects.create(
                    campaign=camp,
                    source = ip
                )

                success_response['message'] = "Sensed"
                response = success_response



            elif module == 'get_crm_contact':
                clients = Logs.objects.all()
                ty = data.get('type')
                for log in clients:
                    if ty == 'email' and is_valid_email(log.email):
                        arr.append(log.contact())

                    if ty == 'phone' and is_valid_phone_number(log.phone):
                        arr.append(log.contact())

                success_response['message'] = arr
                response = success_response

            elif module == 'generate_log_report':
                from django.db.models import Count
                from django.db.models import Count, Q
                from datetime import date

                today = date.today()
                result = Logs.objects.filter(
                    Q(created_date=today)
                ).values('owner').annotate(owner_count=Count('owner'))
                import openpyxl
                attc = ''
                tr = ''
                result = CrmUsers.objects.all()
                for own in result:
                    # get data
                    # user = User.objects.get(pk=owner)
                    owner = own.user
                    us_logs = Logs.objects.filter(owner=owner, created_date=today)
                    l_count = us_logs.count()
                    exit()

                    tr += (f'<tr><td style="border: 1px solid black;">{owner.first_name} {owner.last_name}</td><td '
                           f'style="border: 1px solid black;">{l_count}</tr></tr>')
                    if l_count > 0:
                        # make attachment
                        workbook = openpyxl.Workbook()

                        # start sheet
                        sheet = workbook.active

                        sheet["A1"] = "Company"
                        sheet["B1"] = "SECTOR"
                        sheet['C1'] = "Contact Person"
                        sheet['D1'] = "Position"
                        sheet['E1'] = "Entry Date"
                        sheet['F1'] = "Phone"
                        sheet['G1'] = 'Email'
                        sheet['H1'] = "Subject"
                        sheet['I1'] = "Statue"
                        sheet['J1'] = "Response"

                        x_row = 2
                        for lg in us_logs:
                            print(lg)
                            comp_name = lg.company
                            contact_person = lg.customer
                            position = lg.position.name
                            phone = lg.phone
                            email = lg.email
                            flag = lg.success
                            detail = lg.description

                            sheet[f"A{x_row}"] = lg.company
                            sheet[f"B{x_row}"] = lg.sector.name
                            sheet[f"C{x_row}"] = lg.customer
                            sheet[f"D{x_row}"] = lg.position.name
                            sheet[f"E{x_row}"] = lg.created_date
                            sheet[f"F{x_row}"] = lg.phone
                            sheet[f"G{x_row}"] = lg.email
                            sheet[f"H{x_row}"] = lg.subject
                            sheet[f"I{x_row}"] = lg.success
                            sheet[f"J{x_row}"] = lg.description

                            # sheet[f'A{x_row}'] = comp_name
                            # sheet[f'B{x_row}'] = contact_person
                            # sheet[f'C{x_row}'] = position
                            # sheet[f'D{x_row}'] = phone
                            # sheet[f'E{x_row}'] = email
                            # sheet[f'F{x_row}'] = flag
                            # sheet[f'G{x_row}'] = detail

                            x_row += 1

                        from datetime import datetime
                        current_datetime = datetime.now()
                        formatted_datetime = current_datetime.strftime("%Y_%m_%d_%H_%M_%S")
                        file_name1 = f"{owner.first_name}_{owner.last_name}_CRM_REPORT_{formatted_datetime}.xlsx"

                        file_name = f"static/general/crm-logs-reports/{file_name1}"
                        attc += f"{file_name},"
                        workbook.save(file_name)
                        print(file_name)

                # add to emails
                body = f'<table><tr><th style="border: 1px solid black;">USER</th><th style="border: 1px solid ' \
                       f'black;">LOGS</th></td>{tr}</table>'
                print(tr)
                cc = "uyinsolomon2@gmail.com,solomon@snedaghana.com,ajay@snedaghana.com,bharat@snedaghana.com"
                # Emails(sent_from='crm@snedaghana.com', sent_to='bharat@snedaghana.com',
                #        subject=f"CRM REPORTS ON {today}",
                #        body=body, email_type='crm', attachments=attc, cc=cc).save()
                #
                # Emails(sent_from='crm@snedaghana.com', sent_to='solomon@snedaghana.com',
                #        subject=f"CRM REPORTS ON {today}",
                #        body=body, email_type='crm', attachments=attc, cc=cc).save()

                MailQueues(
                    sender=MailSenders.objects.get(is_default=1),
                    recipient='solomon@snedaghana.com',
                    body=body,
                    subject=f"CRM REPORTS ON {today}",
                    cc=cc
                ).save()
                mail = MailQueues.objects.all().last()
                for attchment in attc.split(','):
                    if len(attchment) > 0:
                        MailAttachments(mail=mail, attachment=attchment).save()

                success_response['message'] = "EMAILS LOG"
                response = success_response

            elif module == 'sync_google_cloud':
                import gspread
                from oauth2client.service_account import ServiceAccountCredentials

                # Define the scope and authenticate using the JSON key file
                scope = ["https://spreadsheets.google.com/feeds", "https://www.googleapis.com/auth/drive"]
                creds = ServiceAccountCredentials.from_json_keyfile_name("static/general/snedaghana-8ac36ff86480.json", scope)
                client = gspread.authorize(creds)

                # Open the Google Sheet by name or by URL
                sheet = client.open("DAILY_CUSTOMER_HUNT")  # Use .sheet1 for the first sheet

                # Add a new sheet to the spreadsheet
                sync_date = data.get('date',timezone.now().date())
                records = Logs.objects.filter(created_date=sync_date,google_sync=False)[:10]
                if records.count() > 0:
                    # add row

                    sheet_name = str(sync_date)
                    try:
                        new_sheet = sheet.worksheet(sheet_name)
                        hd = []
                    except gspread.exceptions.WorksheetNotFound:
                        new_sheet = sheet.add_worksheet(title=sheet_name, rows="100", cols="20")
                        hd = ["OWNER", "SECTOR", "COMPANY", "CONTACT PERSON", "POSITION", "PHONE", "EMAIL", "SUBJECT",
                              "REACHABLE","NEXT FOLLOW UP", "FEEDBACK"]

                    dt = []
                    if len(hd) > 0:
                        dt.append(hd)

                    # new_sheet.insert_row(hd,index=1)

                    for lg in records:
                        li = [

                            lg.owner.get_full_name(),
                            lg.sector.name,
                            lg.company,
                            lg.customer,
                            lg.position.name,
                            lg.phone,
                            lg.email,
                            lg.subject,
                            lg.success,
                            lg.followup_date(),
                            lg.description

                        ]
                        dt.append(li)
                        lg.google_sync = True
                        lg.save()

                    #new_sheet.update('A1',dt)
                    new_sheet.append_rows(dt, value_input_option="USER_ENTERED")
                    # for i, row in enumerate(dt):
                    #     new_sheet.insert_row(row, i + 1)


                success_response['message'] = f"SUCCESS for {sync_date}"
                response = success_response

            elif module == 'sector':
                key = data.get('key', '*')
                arr = []
                if key == '*':
                    sectors = Sector.objects.all().order_by('name')
                else:
                    sectors = Sector.objects.get(pk=key)

                for sector in sectors:
                    arr.append(sector.ob())

                success_response['message'] = arr

                response = success_response

            elif module == 'position':
                key = data.get('key', '*')
                arr = []
                if key == '*':
                    positions = Positions.objects.all().order_by('name')
                else:
                    positions = Positions.objects.get(pk=key)

                for position in positions:
                    arr.append(position.ob())

                success_response['message'] = arr

                response = success_response

            elif module == 'contacts':
                c_type = data.get('type')
                arr = []
                # get emails from logs
                lgs = Logs.objects.all()
                for lg in lgs:
                    arr.append({
                        'first_name': lg.customer.split(' ')[0],
                        'last_name': lg.customer.split(' ')[-1],
                        'contact': lg.email if c_type == 'email' else lg.phone
                    })

                success_response['message'] = arr
                response = success_response

            elif module == 'campaign':
                key = data.get('key','')
                if key == '*':
                    campaigns = Campaigns.objects.all().order_by('-pk')
                else:
                    campaigns = Campaigns.objects.filter(pk=key)

                for camp in campaigns:
                    arr.append(camp.obj())

                success_response['message'] = arr
                response = success_response

            else:
                response = {'message': 'NO MODULE FOUND', 'status_code': 404}

        elif method == 'PATCH':
            if module == 'follow_up':
                mypk = data.get('mypk')
                pk = data.get('f_pk')
                ext_date = data.get('date')
                new_reason = data.get('new_reason')

                folo = FollowUp.objects.get(pk=pk)
                original_log = folo.log
                description = new_reason
                flag = False
                customer = original_log.customer
                name = customer
                phone = original_log.phone
                subject = original_log.subject
                company = original_log.company
                position = original_log.position_id
                email = original_log.email
                sector = original_log.sector_id
                created_date = timezone.now().date()
                city = original_log.city_id
                suburb = original_log.suburb_id
                address = original_log.address



                reason = folo.reason


                folo.follow_date = ext_date
                folo.reason = f"{reason}###{new_reason}"
                Logs(description=description, success=flag, customer=name, phone=phone, subject=subject,
                     owner=User.objects.get(pk=mypk),
                     company=company, position_id=position, email=email, sector_id=sector,
                     created_date=created_date, city_id=city, suburb_id=suburb, address=address,
                     google_sync=False).save()
                saved_log = Logs.objects.get(
                    description=description, success=flag, customer=name, phone=phone, subject=subject,
                    owner=User.objects.get(pk=mypk),
                    company=company, position_id=position, email=email, sector_id=sector,
                    created_date=created_date, city_id=city, suburb_id=suburb, address=address
                )

                folo.log = saved_log

                folo.save()

                success_response['message'] = f"FOLLOWED UP date adjusted to {ext_date} ans new log created"
                response = success_response

            elif module == 'request_campaing_approval':
                key = data.get('key')
                cp = Campaigns.objects.get(pk=key)
                sender_pk = cp.sender
                li = ""
                if cp.type == 'email':
                    api = MailSenders.objects.get(pk=sender_pk)
                    # text_recipeients = [
                    #     'solomon@snedaghana.com',
                    #     'bharat@snedaghana.com',
                    #     'aj@snedaghana.com',
                    #     'sambeasare@hotmail.com',
                    #     'sales2@snedamotors.com'
                    # ]

                    text_recipeients = [
                        'solomon@snedaghana.com',
                        'rootech.inc@proton.me'
                    ]

                    for rec in text_recipeients:
                        MailQueues.objects.create(
                            sender=api,
                            recipient=rec,
                            body=cp.message_template,
                            subject=cp.subject,
                            mail_key = make_md5_hash(f"{rec,cp.message_template}")
                        )

                        li += f"{rec},"

                success_response['message'] = f"Approval request sent to {li}"


            elif module == 'band_user':
                user_pk = data.get('pk')
                user = User.objects.get(pk=user_pk)
                CrmUsers.objects.get(user=user).delete()
                success_response['message'] = f"BAND USER FOUND UP DONE"
                response = success_response

            elif module == 'close_follow_up':

                key = data.get('pk')
                follow = FollowUp.objects.get(pk=key)
                print(follow.is_open)
                follow.is_open = False
                follow.save()

                success_response['message'] = f"CLOSED FOLLOWED UP DATE"
                response = success_response

            elif module == 'valid_log':
                pending_logs = Logs.objects.filter(validity=99)
                for log in pending_logs:
                    LogValidity.objects.filter(log=log).delete()
                    valid = 1
                    if not is_valid_email(log.email):
                        valid = 0
                        LogValidity(
                            log=log,part='email',is_valid=False
                        ).save()
                    else:
                        LogValidity(
                            log=log, part='email', is_valid=True
                        ).save()

                    if not is_valid_phone_number(log.phone):
                        valid = 0
                        LogValidity(
                            log=log, part='phone', is_valid=False
                        ).save()
                    else:
                        LogValidity(
                            log=log, part='phone', is_valid=True
                        ).save()

                    # checn name
                    # if log.

                    log.validity = valid
                    if valid == 1:
                        print("VALID")
                    else:
                        print("Invalid")
                    log.save()

            else:
                response = {'message': f'NO MODULE {module}', 'status_code': 404}

        elif method == 'DELETE':
            if module == 'campaign':
                pk = data.get('pk')
                Campaigns.objects.get(pk=pk).delete()

                success_response['message'] = "Campaign Deleted"
                response = success_response

    except Exception as e:
        error_type, error_instance, traceback = sys.exc_info()
        tb_path = traceback.tb_frame.f_code.co_filename
        line_number = traceback.tb_lineno
        response["status_code"] = 500
        response[
            "message"] = f"An error of type {error_type} occurred on line {line_number} in file {tb_path}. Details: {str(e)}"
        # response["message"] = f"Details: {e}"
        print(e)

    return JsonResponse(response, safe=False)
