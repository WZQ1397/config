# -*- coding: utf-8 -*-
import logging
import pymysql

# if you open the initializer feature, please implement the initializer function, as below:
# def initializer(context):
#    logger = logging.getLogger()  
#    logger.info('initializing')


def handler(environ, start_response):
  # print(environ['QUERY_STRING'].split('=')[2].replace("+",' '))
  logger = logging.getLogger()
  #重点
  sql = '''
  SELECT DATE_FORMAT(created_time,'%Y-%M-%d %H'),count(1) from data_collect_prd.behavioral_data where created_time<'2020-03-09' and created_time>='2020-03-08' group by 1'''
  # sql = environ['QUERY_STRING'].split('=&q=')[1].replace("+"," ")
#   sql = environ['PATH_INFO'].split('?q=')[1].replace("+"," ")
  print(environ['PATH_INFO'])
  print(sql)
  sqlres=b'<table border="1">'
  connection = pymysql.connect(host='172.20.1.141', user='suncash', passwd='9mx9dolPI7L1AzUA', db='suncash_lend', port=35632,
                              charset='utf8',
                              cursorclass=pymysql.cursors.DictCursor)

  try:
      with connection.cursor() as cursor:
        if sql.startswith("select"):
          cursor.execute(sql+" LIMIT 100;")
        else:
          cursor.execute(sql+";")
      connection.commit()
  finally:
      connection.close()
  if cursor is not None:
      results = [result for result in cursor]
      sqlres = sqlres + b"<tr>"
      for v in results[0].keys():
        fmt="<th>{}</th>".format(v)
        sqlres=sqlres+fmt.encode('utf-8')
      # row = '\n' + "-"*50 + '\n'
      # sqlres = sqlres + row.encode('utf-8')
      sqlres = sqlres + b"</tr>"
      for result in results:
        sqlres = sqlres + b"<tr>"
        for v in result.values():
          fmt="<th>{}</th>".format(v)
          sqlres=sqlres+fmt.encode('utf-8')
          # for key, value in result.items():
          #     print(key, value)
        sqlres = sqlres + b"</tr>"
  else:
      print('This will never be reached when join gevent')
  status = '200 OK'
  response_headers = [('Content-type', 'text/html')]
  start_response(status, response_headers)
  # print(sqlres)

  return [sqlres]