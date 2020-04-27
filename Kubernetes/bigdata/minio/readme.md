### Running minio container
```
docker pull minio/minio
docker run --name minio -p 9000:9000 -v data:/data minio/minio server /data
```

### Grab access and secret key
/data/.minio.sys/config/config.json
```
docker exec -it minio cat /data/.minio.sys/config/config.json | egrep "(access|secret)Key"
```
Change access key and secret key from the Minio dashboard.