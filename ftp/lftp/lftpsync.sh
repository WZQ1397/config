#!/bin/bash
lftp -u meizhi,"mlszws&mz" -e "set ftp:sync-mode off;set net:timeout 10;set net:max-retries 2;set ftp:ssl-allow off;mirror --ignore-time --parallel=1 / /DATA5_DB8/data/mz_data/ml/; quit" 114.116.42.142
