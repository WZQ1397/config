USERNAME=zach
PASSWORD=123456

# create secret
USERS=$(htpasswd -nb USERNAME PASSWORD)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: authsecret
  namespace: kube-system
type: Opaque
stringData:
  users: ${USERS}
EOF

# create middleware 
cat <<EOF | kubectl apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: roc-auth
  namespace: kube-system
spec:
  basicAuth:
    secret: authsecret
EOF

# create ingress
cat <<EOF | kubectl apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
  name: traefik-dashboard
  namespace: kube-system
spec:
  entryPoints:
  - websecure
  routes:
  - kind: Rule
    match: Host(`traefik.imroc.io`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))
    services:
    - kind: TraefikService
      name: api@internal
    middlewares:
    - name: roc-auth
  tls:
    secretName: traefik-imroc-io-tls
EOF

