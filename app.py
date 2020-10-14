#!/usr/bin/env python3

from flask import Flask, request, escape
from os import environ
import time

app = Flask(__name__)


@app.route('/', methods=['GET'])
def hello_get():
    uid = request.args.get('uid')
    ret = f'''Hello.Rest api GET <br> 
Env : {environ.get("ENV")} <br>
Hostname : {environ.get("HOSTNAME")} <br>
Input uiddddd= : {escape(uid)} <br>
current time : {time.strftime('%A %B, %d %Y %H:%M:%S')}
'''

    return ret


@app.route('/', methods=['POST'])
def hello_post():
    if request.is_json is True:  # Content-Type: json
        print('json type in')
        content = request.get_json()
    else:  # Content-Type: x-www-form-urlencoded
        print('urlencoded type in')
        content = request.form
    uid = content['uid']
    return f'Hello, {escape(uid)}! by post'


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=80)
