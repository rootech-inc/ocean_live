import json


def token(username,password):
    url = 'http://192.168.2.15/jwt-api-token-auth/'
    data = {
        'username':username,
        'password':password
    }

    header = {
        'Content-Type':'application/json'
    }

    import requests
    response = requests.post(url,json=data,headers=header)
    token = json.loads(response.text).get('token')
    print(token)
    print(response.text)
    print("hello")
    return token