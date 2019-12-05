#! /bin/sh

htpasswd -c auth foo

kubectl -n demo-echo create secret generic basic-auth --from-file=auth

kubectl -n demo-echo get secret basic-auth -o yaml
