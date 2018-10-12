# Generate Let's Encrypt certificate

## Install acme.sh

```
curl  https://get.acme.sh | sh
```

## Generate TXT record

```
acme.sh --issue --dns -d mixhub.cn -d '*.mixhub.cn' --yes-I-know-dns-manual-mode-enough-go-ahead-please
```

After this command you will get a subdomain and TXT record, then update your DNS record according to this.

## Generate certificate

```
acme.sh --renew --dns -d mixhub.cn -d '*.mixhub.cn' --yes-I-know-dns-manual-mode-enough-go-ahead-please
```

You will get something like this:

```
[Thu Aug 16 08:04:20 EDT 2018] Your cert is in  /root/.acme.sh/mixhub.cn/mixhub.cn.cer
[Thu Aug 16 08:04:20 EDT 2018] Your cert key is in  /root/.acme.sh/mixhub.cn/mixhub.cn.key
[Thu Aug 16 08:04:20 EDT 2018] The intermediate CA cert is in  /root/.acme.sh/mixhub.cn/ca.cer
[Thu Aug 16 08:04:20 EDT 2018] And the full chain certs is there:  /root/.acme.sh/mixhub.cn/fullchain.cer
```

refer:
https://github.com/Neilpang/acme.sh