import pymysql
import csv
import xlrd
import configparser
import os
import sys
import datetime

'''
1. 通过config.ini来配置数据库连接信息、csv导出路径、导出表配置xlsx文件
2. 如果表按每日抽取，则导出T-1数据。
    如果表按每周抽取，则在每周一导出T-7数据
3. 如果表有updated_time字段就生成T-1数据增量数据csv
    如果表没有updated_time字段就生成全量csv
'''

def readConf(confPath):
    confxlsx = xlrd.open_workbook(filename=confPath)
    sheet = confxlsx.sheet_by_index(0)
    list = [sheet.row_values(rowNum) for rowNum in range(1, sheet.nrows)]
    return list

def chkFileExists(path):
    if not os.path.exists(path) or not os.path.isfile(path):
        print("%s 路径不存在或不是文件或目录！请检查配置文件！" % path)
        sys.exit()
    else:
        return True

def save(db,database, tableName, frequency, savePath,curDate):
    # print(db["host"],db["user"], db["password"])
    conn = pymysql.connect(host=db["host"], user=db["user"], password=db["password"])
    cursor = conn.cursor()
    cursor.execute(
        "SELECT 1 FROM `information_schema`.`columns` where table_schema='%s' and table_name = '%s' and column_name = 'updated_time'" % (
            database, tableName))
    switch = {
        "每日":1,
        "每周":7
    }
    interval = switch.get(frequency)
    # print(interval)
    extractSql = "select * from `%s`.`%s`" % (database, tableName)
    isIncr = cursor.fetchone()
    # if tableName in ["act_hi_procinst","act_hi_taskinst"]:
    #     return
    if isIncr:
        extractSql = extractSql + " where updated_time between concat(current_date()-interval %d day,' 23:30:00') and concat(current_date(),' 23:59:59')" % (interval)
    # print(extractSql)
    cursor.execute(extractSql)

    result = cursor.fetchall()
    outfilePath = os.path.join(savePath, curDate, database + '.' + tableName + '.csv')

    flag =False
    if not os.path.exists(outfilePath):
        cols = [col[0] for col in cursor.description]
        # print(cols)
        flag = True

    with open(file=outfilePath, mode="a", encoding="utf8") as outfile:
        csvWriter = csv.writer(outfile)
        if flag:
            csvWriter.writerow(cols)
        for row in result:
            csvWriter.writerow(row)
    cursor.close()
    conn.close()

def export2csv():
    curDate = datetime.datetime.now().strftime('%Y-%m-%d')
    weekday = datetime.datetime.now().weekday()
    conf = configparser.ConfigParser()
    conf.read("config.ini")
    savepath = (dict)(conf.items("save"))["savepath"]
    # if chkFileExists(savepath):
    if not os.path.exists(os.path.join(savepath, curDate)):
        os.mkdir(os.path.join(savepath, curDate))
    confPath = (dict)(conf.items("table"))["confpath"]
    _ = chkFileExists(confPath)
    db = (dict)(conf.items("db"))
    for row in readConf(confPath):
        if (row[2] == "每周" and weekday == 0) or row[2] == "每日":
            # print(row)
            save(db=db, database=row[0], tableName=row[1], frequency=row[2], savePath=savepath,curDate=curDate)

if __name__ == '__main__':
    export2csv()