# genereate self signed key + certificate

```bash
openssl req -x509 -newkey rsa:4096 -nodes \
  -keyout harbor.key \
  -out harbor.crt \
  -days 365 \
  -subj "/CN=harbor.towelie.dev"
```

# create secret of genereated key + certificate
```bash
kubectl create secret tls harbor-cert \
  --cert=harbor.crt \
  --key=harbor.key \
  --namespace harbor \
  --dry-run=client \
  -o yaml > apps/base/harbor/cert.yaml
```

# careful
when updating coredns apply a new yaml in gitops, otherwise default values might be missing
