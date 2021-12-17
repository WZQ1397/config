
package main
 
import (
    "encoding/json"
    "fmt"
)

type Pool struct{
    ListenAddr  ListenAddr `json:"ListenAddr,omitempty"`
    Servers []Server `json:"Servers,omitempty"`
    Password string `json:"Password,omitempty"`
}
 
type ListenAddr struct {
    IP string `json:"IP,omitempty"`
    Port string `json:"Port,omitempty"`
}
 
type Server struct {
    IP string `json:"IP,omitempty"`
    Port string `json:"Port,omitempty"`
    Master bool `json:"Master,omitempty"`
}

func main() {
    //定义一个结构体变量，同时初始化
	P1Addr := ListenAddr{"192.179.2.1","26379"}
	
	P1_S1 := ListenAddr{"192.168.2.10","6379",true}
	P1_S2 := ListenAddr{"192.168.2.11","6379",false}
	P1_S3 := ListenAddr{"192.168.2.12","6379",false}
	
    P1_Server := Pool{P1Addr, []string{P1_S1,P1_S2,P1_S3}, "Zzzzz"}
 
    //编码，根据内容生成json文本
    buf, err := json.Marshal(s)
    if err != nil {
        fmt.Println("err = ", err)
        return
    }
    fmt.Println("res = ", string(buf))
}