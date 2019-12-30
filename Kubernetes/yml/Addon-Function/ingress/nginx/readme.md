### TODO 
使用canary功能时，主版本ingress保持原状，不需要任何改动。
金丝雀ingress和主ingress使用相同的host和path，区别在于多出了一些annotation。
kubectl -n web create -f .

'''
访问金丝雀服务: 
(-H 中对应 canary-by-header: "version"
           canary-by-header-value: "canary")
''''

#### 金丝雀效果
使用下面的方式时，50% 的请求转发到金丝雀服务（对应设置 canary-weight）：
> $ curl -H "Host: canary.echo.example"  192.168.99.100:30933/

带有 "version: canary" 头的请求，转发到金丝雀服务（对应设置 canary-by-header 和 canary-by-header-value）：
> $ curl -H "Host: canary.echo.example" -H "version: canary" 192.168.99.100:30933/

带有 canary-cookie 且 cookie 值为 always 的请求，转发到金丝雀服务（对应设置 canary-by-cookie）：
> $ curl -H "Host: canary.echo.example" -b canary-cookie=always 192.168.99.100:30933/

带有 canary-cookie 且 cookie 值为 always 的请求，转发到主服务（对应设置 canary-by-cookie）：
>$ curl -H "Host: canary.echo.example" -b canary-cookie=never 192.168.99.100:30933/


header、cookie、weight 的优先级：canary-by-header -> canary-by-cookie -> canary-weight。

