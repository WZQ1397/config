from urllib import request

# if you open the initializer feature, please implement the initializer function, as below:
# def initializer(context):
#    logger = logging.getLogger()  
#    logger.info('initializing')


def handler(environ, start_response):
    # context = environ['fc.context']
    # request_uri = environ['fc.request_uri']

    data=[]
    html=b""
    print(environ['QUERY_STRING'])
    if not environ['PATH_INFO'].startswith("/="):
        return "format error"
    with request.urlopen("https://"+environ['PATH_INFO'][2:]) as f:
        data = f.readlines()
        # print('Status:', f.status, f.reason)
        # for k, v in f.getheaders():
        #     print('%s: %s' % (k, v))
    for v in data:
        #print('Data:', v.decode('utf-8'))
        html = html + v
    status = '200 OK'
    response_headers = [('Content-type', 'text/html')]
    start_response(status, response_headers)
    return [html]