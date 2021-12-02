provider "aws" {
    region = "cn-north-1"
    # 使用key , key 和 file 选一个
    #aws_access_key_id = AKIAPTL3B**********
    #aws_secret_access_key = FOdWnJ7JJL9U/****************
    # 使用file 不指定的话，默认值是 "~/.aws/credentials"
    shared_credentials_file  = "/root/.aws/credentials"
    # 不指定的话，默认值是 "default"
    profile = "default"
}

