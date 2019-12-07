#! /bin/sh


echo "生成自签署的 ca 证书"
openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 3560 -nodes -subj '/CN=My Cert Authority'

echo "生成用上述 ca 签署的 server 证书"
openssl req -new -newkey rsa:4096 -keyout server.key -out server.csr -nodes -subj '/CN=auth-cert.echo.example'
openssl x509 -req -sha256 -days 3650 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

echo "生成用上述 ca 签署的 client 证书"
openssl req -new -newkey rsa:4096 -keyout client.key -out client.csr -nodes -subj '/CN=My Client'
openssl x509 -req -sha256 -days 3650 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt

# kubectl -n web create secret generic ca-secret --from-file=ca.crt=ca.crt
# kubectl -n web create secret generic tls-secret --from-file=tls.crt=server.crt --from-file=tls.key=server.key