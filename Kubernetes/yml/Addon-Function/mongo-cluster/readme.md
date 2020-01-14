# 1. set up cluster 
rs.initiate({_id: "zach", version: 1, members: [
       { _id: 0, host : "mongo-0.mongo:27017" },
       { _id: 1, host : "mongo-1.mongo:27017" },
       { _id: 2, host : "mongo-2.mongo:27017" }
 ]});
 
# 2. check config
rs.config();

# 3. check cluster status
rs.status();

# 4. add Arbiter
rs.addArb("mongo-3.mongo:27017")

# 5. add node
rs.add("mongo-3.mongo:27017")

#### use auth
kubectl apply -f mongo-sts.yml
kubectl exec -it mongo-0 mongo
# jump to step.1 
use admin
db
db.createUser(
  {
    user: "zach",
    pwd: "zach",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
db.auth("zach","zach")
kubectl delete -f mongo-sts.yml
kubectl apply -f mongo-stsWithAuth.yml
