#!/usr/bin/env python
# coding=utf-8
from flask import Flask,render_template

app = Flask(__name__)

base_path = ''

@app.route('/login', methods=['GET', 'POST'])
def home():
    resp = render_template("index.html")
    return resp

if __name__ == '__main__':
    app.run()

# def handler(environ, start_response):
#     parsed_tuple = urlparse(environ['fc.request_uri'])
#     li = parsed_tuple.path.split('/')
#     global base_path
#     if not base_path:
#         base_path = "/".join(li[0:5])
#     return app(environ, start_response)