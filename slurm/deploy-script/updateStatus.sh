scontrol update NodeName=worker01 State=RESUME
scontrol update NodeName=worker02 State=RESUME
scontrol update NodeName=worker03 State=RESUME
for x in `seq 10 30`;
do
scontrol update NodeName=worker$x State=RESUME
done
