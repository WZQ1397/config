cat <<EOF | cfssl genkey - | cfssljson -bare server
{
  "hosts": [
    "zach.tsjinrong.top",
    "127.0.0.1",
    "172.16.48.0/24"
  ],
  "CN": "kubernetes",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "Zach",
      "OU": "System"
    }
  ]
}
EOF

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: zach-csr
spec:
  request: $(cat server.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF