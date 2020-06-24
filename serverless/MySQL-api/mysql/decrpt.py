# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2020-02-07 14:45

import time
'''
workid='005796'
token = 'z'
encrptSql=[]
newtoken = (round(time.time())//100000) * ord(token)
code = ""
print(newtoken)
encrptSql.append(newtoken)
def encrpt(encrptSql,code):
  def intTo62(n):
    sb = []
    b = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
         'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
         'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
         'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
         'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
    while (n != 0):
      #print(b[n % 62])
      sb.append(b[n % 62])
      n = n // 62
    res=""
    while len(sb):
      res += sb.pop()
    return res

  for v in workid:
    encrptSql.append(ord(v)*newtoken)

  print(encrptSql)

  for v in encrptSql:
    code = code + intTo62(v)
    print(intTo62(v),end="")
  print()
  return code
'''

def intTo62Rev(n):
  b = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
       'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
       'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
       'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
       'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
  num, i = 0, 0
  for v in n[::-1]:
    num += b.index(v) * (62 ** i)
    i = i + 1
  return num

def decrpt(code):
  count=6
  str=""
  newtoken=intTo62Rev(code[:4])
  print(newtoken)
  while count:
    startInd=4+((6-count))*5
    endInd=4+((6-count)+1)*5
    # print(code[startInd:endInd])
    str = str+chr(intTo62Rev(code[startInd:endInd])//newtoken)
    count = count - 1
  return str

def chk_date(dateCode):
  print(intTo62Rev(dateCode[:4]))