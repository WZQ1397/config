id=`docker ps | grep worker | awk '{print $NF}'`
echo "=======  $id  =========="
docker exec -it $id slurmd -C

