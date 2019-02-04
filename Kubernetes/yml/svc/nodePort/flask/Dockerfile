FROM python:2.7.14-alpine3.6

WORKDIR /usr/src/app
ENV 
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", ${FUN_PROGRAME} ]
