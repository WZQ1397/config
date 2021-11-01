#!/bin/bash
#SBATCH -J test                   # 作业名为 test
#SBATCH -o %j.out                 # --output 屏幕上的输出文件重定向到 test.out
#SBATCH --error %j.out            # 错误日志重定向到 test.out
#SBATCH -p gpu                    # 作业提交的分区为 gpu
#SBATCH --qos=debug               # 作业使用的 QoS 为 debug
#SBATCH -N 1                      # --ntasks 作业申请 1 个节点
#SBATCH --ntasks-per-node=1       # 单节点启动的进程数为 1
#SBATCH --cpus-per-task=4         # 单任务使用的 CPU 核心数为 4
#SBATCH --mem-per-cpu=10240M      # memory per CPU core
#SBATCH -t 1:00:00                # 任务运行的最长时间为 1 小时
#SBATCH --gres=gpu:1              # 单个节点使用 1 块 GPU 卡
#SBATCH -w comput6                # 指定运行作业的节点是 comput6，若不填写系统自动分配节点
#SBATCH -exclusive                # 独占节点
#SBATCH --mail-user=myemail@example.com   # email address
echo "$USER: Please change the --mail-user option to your real email address before submitting. Then remove this line."; exit 1
#SBATCH --mail-type=END
#SBATCH --qos=standby			  # Job is preemptable


# 设置运行环境
module add anaconda/3-5.0.0.1     # 添加 anaconda/3-5.0.0.1 模块

# 输入要执行的命令，例如 ./hello 或 python test.py 等
python test.py                    # 执行命令