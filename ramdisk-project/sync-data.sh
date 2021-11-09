#!/bin/bash
subdir=`date +%Y%m%d`
rsync -avzP /zach-ramdisk/image/1/$subdir /data/park-data/park/data/image/1/
rsync -avzP /zach-ramdisk/snap_shot/全部/$subdir /data/park-data/park/data/snap_shot/全部/
rsync -avzP /zach-ramdisk/snap_shot/可疑发热/$subdir /data/park-data/park/data/snap_shot/可疑发热/

