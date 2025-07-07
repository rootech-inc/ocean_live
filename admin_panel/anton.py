import hashlib

from django.contrib.auth.models import User
from django.utils import timezone

from admin_panel.models import UserAddOns, UserSettings, Emails, Sms, SmsApi
from ocean import settings

import re


def is_valid_password(password):
    # Check if password is at least 8 characters long
    if len(password) < 8:
        return False

    # Check if password contains at least one uppercase letter
    if not re.search(r'[A-Z]', password):
        return False

    # Check if password contains at least one lowercase letter
    if not re.search(r'[a-z]', password):
        return False

    # Check if password contains at least one digit
    if not re.search(r'\d', password):
        return False

    # Check if password contains at least one special character
    if not re.search(r'[!@#$%^&*]', password):
        return False

    # If all checks pass, the password is considered valid
    return True

def is_valid_email(email):
    pattern = r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)"
    # Check if keyword "none" is in email (case-insensitive) or if it matches the regex
    return re.match(pattern, email) is not None and "none" not in email.lower()

def is_valid_phone_number(phone):
    import re
    pattern = r'^0[1-9]\d{8}$'
    return re.match(pattern, phone) is not None

def fix_phone_number(phone):
    if phone is not None:
        phone = phone.replace(' ', '').replace('+233', '0')
        if not phone.startswith('0') and phone != '':
            phone = '0' + phone
        return phone
    else:
        return ''

def push_notification(user_pk, subject='', message=''):
    user = User.objects.get(pk=user_pk)
    adon = UserAddOns.objects.get(user=user)
    setting = UserSettings.objects.get(user=user)

    if setting.prim_noif == 'email':
        # send email
        recipient_addr = user.email
        Emails(sent_from=settings.EMAIL_HOST_USER, sent_to=recipient_addr, subject=subject,
               body=message, email_type='system', ref='system').save()

        pass
    elif setting.prim_noif == 'mobile':
        # send sms
        sms_api = SmsApi.objects.get(sender_id='SNEDA SHOP')
        Sms(api=sms_api, to=adon.phone, message=message).save()
        # import requests
        # import json
        #
        # url = "http://127.0.0.1:8000/sms/que/"
        #
        # payload = json.dumps({
        #     "to": adon.phone,
        #     "message": message
        # })
        # headers = {
        #     'Content-Type': 'application/json',
        #     'Cookie': 'csrftoken=LzknwT1ZM6hYeg0P8u5M9Wfyl7JWvOL2'
        # }
        #
        # response = requests.request("GET", url, headers=headers, data=payload)
        #
        # print(response.text)


def remove_html_tags(text):
    clean = re.compile('<.*?>')
    return re.sub(clean, '', text)


def make_md5_hash(text):
    from datetime import datetime
    current_datetime = timezone.now()
    formatted_datetime = current_datetime.strftime("%Y_%m_%d_%H_%M_%S")
    new_text = f"{text}{formatted_datetime}"
    return hashlib.md5(new_text.encode('utf-8')).hexdigest()

def md5only(text):
    return hashlib.md5(str(text).encode('utf-8')).hexdigest()


def generate_random_password():
    import secrets
    import string
    characters = string.ascii_letters + string.digits  # Use letters and digits
    random_password = ''.join(secrets.choice(characters) for i in range(8))
    return random_password


def current_date():
    from datetime import datetime
    current_datetime = datetime.now()
    return current_datetime.strftime("%Y_%m_%d_%H_%M_%S")


def new_sms(to, message):
    api = SmsApi.objects.get(is_default=1)
    Sms(api=api, to=to, message=message).save()


def get_file_type(file_name):
    import os
    import mimetypes
    _, file_extension = os.path.splitext(file_name)
    file_extension = file_extension.lower()  # Convert to lowercase for consistency

    # Use mimetypes to get the MIME type
    mime_type, _ = mimetypes.guess_type(file_name)

    return mime_type


def format_currency(amount):
    # Format number with thousand separators and 2 decimal places
    try:
        # Convert amount to float to handle both string and numeric inputs
        num = float(amount)
        # Format with thousand separator (,) and fixed 2 decimal places
        return "{:,.2f}".format(num)
    except (ValueError, TypeError):
        # Return original amount if conversion fails
        return amount



def get_client_ip(request):
    """Extract the client's IP address from the request."""
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        # Behind a proxy, get the first IP in the list
        ip = x_forwarded_for.split(',')[0]
    else:
        # Direct IP
        ip = request.META.get('REMOTE_ADDR')
    return ip

# create user
def create_new_user(first_name,last_name, email, phone,company,position,emp_code=None):
    # check if email exist
    if email != 'none@domain.com' and User.objects.filter(email=email).count() > 0:
        # update user details
        User.objects.filter(email=email).update(first_name=first_name, last_name=last_name)
        user = User.objects.get(email=email)
        addon = UserAddOns.objects.get(user=user)
        addon.company = company
        addon.position = position
        addon.bio_id=emp_code
        addon.save()
        print("Updated base on email")
        return False

    # check phone number
    if UserAddOns.objects.filter(phone=phone).exists():
        # update user details
        adon = UserAddOns.objects.get(phone=phone)
        adon.user.first_name = first_name
        adon.user.last_name = last_name
        adon.bio_id = emp_code
        print("Updated base on phone")
        User.objects.filter(pk=adon.user.pk).update(first_name=first_name, last_name=last_name)

        return False

    # make username
    if User.objects.filter(username=last_name).exists():
            # generate username
        number = '{:03d}'.format(random.randrange(1, 99))
        username = '{}{}'.format(last_name, number)
    else:
        username = last_name.replace(' ', '').lower()

    pass_w = generate_random_password()
    user = User.objects.create_user(username=username, password=pass_w)
    user.first_name = first_name
    user.last_name = last_name
    user.email = email
    user.is_active = True
    user.save()

    md_mix = f"{pass_w} {first_name} {last_name} {username} "
    hash_object = hashlib.md5(md_mix.encode())
    api_token = hash_object.hexdigest()

    try:
        created_account = User.objects.get(username=username)
        AuthToken(user=created_account, token=api_token).save()

        use_ad_on = UserAddOns(user=created_account, company=company,
                               app_version=VersionHistory.objects.get(version=settings.APP_VERSION),
                               position=position, phone=phone)

        md_mix = f" {first_name} {last_name} {username} "
        hash_object = hashlib.md5(md_mix.encode())
        resettoken = hash_object.hexdigest()
        respwrd = PasswordResetToken(user=created_account, token=resettoken, valid=1)

        use_ad_on.save()
        respwrd.save()

        sms_api = SmsApi.objects.get(is_default=1)
        sms_template = """
                            Hello [User's Name],\n

                            We are pleased to inform you that a profile has been created for you in our Ocean system. Here are your login credentials:\n\n

                            Username: [Username]\n
                            Password: [Password]\n

                            You can now log in to your account using the provided credentials. Please make sure to change your password after your first login for security reasons.\n

                            If you have any questions or need assistance, please don't hesitate to contact our support team at [Support Email] or [Support Phone Number].\n



                            Best regards,
                            SNEDA IT
        """
        sms_message = sms_template.replace("[User's Name]", f"{first_name} {last_name}")
        sms_message = sms_message.replace("[Username]", username)
        sms_message = sms_message.replace("[Password]", pass_w)
        sms_message = sms_message.replace("[Support Email]", "solomon@snedaghana.com")
        sms_message = sms_message.replace("[Support Phone Number]", "054 631 0011 / 020 199 8184")

        Sms(api=sms_api, to=phone, message=sms_message).save()

        return True

    except Exception as e:
        User.objects.filter(username=username).delete()
        return False


def staffs():
    import requests
    url = f"{ATTENDANCE_URL}personnel/api/employees/"
    tk = token('solomon', 'Szczesny@411')
    headers = {
        "Authorization": f"JWT {tk}",
        "Content-Type": "application/json",
    }
    response = requests.get(url, headers=headers, params={
        "page_size": 10000, "ordering": "id"
    })
    return response.json()['data']


def get_week_of_month():
    from datetime import datetime
    today = datetime.today()
    day_of_month = today.day

    # Divide month into 4 equal parts (7 or 8 days each)
    week_number = (day_of_month - 1) // 7 + 1

    # Cap at week 4 for the last days
    return min(week_number, 4)

def month_by_name():
    from datetime import datetime

    # Get full month name (e.g., "May")
    month_name = datetime.now().strftime("%B")

    # Get abbreviated month name (e.g., "May")
    month_abbr = datetime.now().strftime("%b")
    return month_abbr