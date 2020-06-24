# -*- coding: utf-8 -*-
import logging
import pymysql,json

# if you open the initializer feature, please implement the initializer function, as below:
# def initializer(context):
#   logger = logging.getLogger()
#   logger.info('initializing')

'''

'''
def roleConfigList(token):
  from decrpt import decrpt
  workid = decrpt(token)

  MASTER_LIST=['']
  DEV_LIST=['005596','000045','003600','000366','005460']
  LEADER_LIST=['000060']
  TEST_LIST=[]
  if workid in DEV_LIST:
    return 'DEV',workid
  elif workid in TEST_LIST:
    return 'TEST',workid
  elif workid in MASTER_LIST:
    return 'MASTER',workid
  else:
    return 'token invaild! :('


def handler(event, context):
  logger = logging.getLogger()
  #重点
  # API GATEWAY METHOD
  logger.info(event)
  try:
    token = json.loads(event.decode('utf-8'))["pathParameters"]["token"]
    try:
      sql = json.loads(event.decode('utf-8'))["queryParameters"]["query"]
    except Exception as e:
      logger.error(e)
  except Exception as e:
    return '100004 NOT Authed!'

  connection = mysqlConnector()
  ROLES_ASSIGN={'DEV':['SELECT','INSERT','UPDATE','DELETE'],
                'MASTER':['SELECT','INSERT','UPDATE','DELETE','ALTER','SHOW','DESC'],
                'TEST':['SELECT']}

 
  # TODO TMP ADD
  role,workid="","999999"
  if token=='15CNW23T7SO28EMG82799SC23T7SO28EMG823T7SO28EMG828EMG81J4VUO1J4VUO1J4VUO1NQAI81J4VUO1Q0ZU02799SC1MKXUC':
    role='MASTER'
  else:
    try:
      role,workid=roleConfigList(token)
    except Exception as e:
      return '100007 token invaild! :('
  sqlType=sql.split()[0].upper()
  logger.info(sqlType)
  try:
    if sqlType in ROLES_ASSIGN[role]:
      logger.info("workid:{} ==> Operation:{} ".format(workid,sqlType))
      try:
        if sqlType in ['SELECT','SHOW','DESC']:
          return selectOps(connection,sql)
        elif sqlType in ['INSERT','UPDATE','DELETE','ALTER']:
          return dataOperation(connection,sql,sqlType)
        else:
          return '100008 there are some problem here! :('
      except Exception as e:
        return '100001 SQL syntax problem! :-<'
    else:
      return '100010 this Operation is not allowed! :('
  except Exception as e:
    return '100016 token invaild! :('


  # SELF DEFIND JSON
  # sql = json.loads(event.decode('utf-8'))['query']
  # print(json.loads(event.decode('utf-8'))['query'])
  # if sql=="":
  #   sql = "show tables"


  return 'token invaild'

def mysqlConnector():
  return pymysql.connect(host='172.20.1.141', user='suncash', passwd='9mx9dolPI7L1AzUA', db='approval', port=35632,
                              charset='utf8',
                              cursorclass=pymysql.cursors.DictCursor)

def selectOps(connection,sql):
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
      # print(len(results),type(results))
      # for v in results[0].keys():
      #   print("{}".format(v),end="\t\t")
      # print()
      # for result in results:
      #   for v in result.values():
      #     print("{}".format(v), end="\t")
      #   print()
          # for key, value in result.items():
          #     print(key, value)
  else:
      print('This will never be reached when join gevent')
  return results

def dataOperation(connection,sql,sqlType):
  try:
    with connection.cursor() as cursor:
      cursor.execute(sql+";")
    connection.commit()
  finally:
    connection.close()
  return sqlType+' Operation success!'