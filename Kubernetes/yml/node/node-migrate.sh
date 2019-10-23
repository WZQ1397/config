# HOW TO CHANGE NODE
# Step 1. get node information
kubectl get node
# Step 2. set node unschedule
kubectl cordon $node_name
# Step 3. schedul all services of this node to other
kubectl cordon $node_name
# Step 4. delete node 
kubectl delete $node_name