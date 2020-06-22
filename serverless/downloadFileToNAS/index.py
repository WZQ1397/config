# -*- coding: utf-8 -*-
import logging

# if you open the initializer feature, please implement the initializer function, as below:
# def initializer(context):
#   logger = logging.getLogger()
#   logger.info('initializing')

def handler(event, context):
    IMAGE_URL = "https://www.google.hk"
    html=""
    
    def urllib_download(html):
        from urllib.request import urlretrieve
        urlretrieve(IMAGE_URL, '/mnt/zach/MidtermExamSolutions.mp4')
        with open('/mnt/zach/MidtermExamSolutions.mp4','r') as f:
          html = f.readlines()
        return html
    html = urllib_download(html)
    logging.info(html)
    return html