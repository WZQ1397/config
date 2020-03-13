[root@master1 mod-chart]# tree
.
├── Chart.yaml  # chart版本信息文件
├── README.md  # chart说明文件
├── templates  # kubernetes资源yaml模板
│   ├── configmap.yaml  # configmap模板
│   ├── deployment-statefulset.yaml  # deployment或statefulset模板
│   ├── _helpers.tpl  # 辅助模板和 partials
│   ├── ingress.yaml  # ingress模板
│   ├── NOTES.txt  # 部署chart后输出的帮助文档
│   ├── pvc.yaml  # pvc模板
│   ├── secret.yaml  # secret模板
│   ├── service-headless.yaml  # service headless模板
│   └── service.yaml  # service模板
└── values.yaml  # 默认设置

1 directory, 12 files
[root@master1 mod-chart]# helm3 lint --strict .
1 chart(s) linted, 0 chart(s) failed

helm模板语法
模板引用方式,{{ .Release.Name }}, 通过双括号注入,小数点开头表示从最顶层命名空间引用.

helm内置对象
# Release, release相关属性
# Chart, Chart.yaml文件中定义的内容
# Values, values.yaml文件中定义的内容
模板中使用管道
apiVersion: v1
kind: ConfigMap
metadata:
   name: {{ .Release.Name }}-configmap
data:
  myvalue: "Hello World"
  drink: {{ .Values.favorite.drink | repeat 5 | quote }}
  food: {{ .Values.favorite.food | upper | quote }}
if语句
{{ if PIPELINE }}
# Do something
{{ else if OTHER PIPELINE }}
# Do something else
{{ else }}
# Default case
{{ end }}
操作符, and/eq/or/not

{{/* include the body of this if statement when the variable .Values.fooString exists and is set to "foo" */}}
{{ if and .Values.fooString (eq .Values.fooString "foo") }}
    {{ ... }}
{{ end }}

{{/* do not include the body of this if statement because unset variables evaluate to false and .Values.setVariable was negated with the not function. */}}
{{ if or .Values.anUnsetVariable (not .Values.aSetVariable) }}
   {{ ... }}
{{ end }}
控制语句块在渲染后生成模板会多出空行,需要使用{{- if ...}}的方式消除此空行.如:
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
data:
  myvalue: "Hello World"
  {{- if eq .Values.favorite.drink "coffee"}}
  mug: true
  {{- end}}
引入相对命名空间,with命令:
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
data:
  myvalue: "Hello World"
  {{- with .Values.favorite }}
  drink: {{ .drink | default "tea" | quote }}
  food: {{ .food | upper | quote }}
  {{- end }}
range命令实现循环,如:

# values.yaml
favorite:
  drink: coffee
  food: pizza
pizzaToppings:
  - mushrooms
  - cheese
  - peppers
  - onions

#configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
data:
  myvalue: "Hello World"
  toppings: |-
    {{- range .Values.pizzaToppings }}
    - {{ . }}
    # .表示range的命令空间下的取值
    {{- end }}
    {{- range $key, $val := .Values.favorite }}
    {{ $key }}: {{ $val | quote }}
    {{- end}} 
变量赋值
ApiVersion: v1
Kind: ConfigMap
Metadata:
  name: {{ .Release.Name }}-configmap
Data:
  myvalue: "Hello World"
  # 由于下方的with语句引入相对命令空间,无法通过.Release引入,提前定义relname变量
  {{- $relname := .Release.Name -}}
  {{- with .Values.favorite }}
  food: {{ .food }}
  release: {{ $relname }}
  # 或者可以使用$符号,引入全局命名空间
  release: {{ $.Release.Name }}
  {{- end }}
公共模板,define定义,template引入,在templates目录中默认下划线_开头的文件为公共模板(_helpers.tpl)

# _helpers.tpl文件
{{- define "mychart.labels" }}
  labels:
    generator: helm
    date: {{ now | htmlDate }}
{{- end }}

# configmap.yaml文件
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
  {{- template "mychart.labels" }}
data:
  myvalue: "Hello World"
template语句的升级版本include,template是语句无法在后面接管道符来对引入变量做定义,
include实现了此功能.

# _helpers.tpl文件
{{- define "mychart.app" -}}
app_name: {{ .Chart.Name }}
app_version: "{{ .Chart.Version }}+{{ .Release.Time.Seconds }}"
{{- end -}}

# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
  labels:
    {{- include "mychart.app" . | nindent 4 }}
data:
  myvalue: "Hello World"
  {{- range $key, $val := .Values.favorite }}
  {{ $key }}: {{ $val | quote }}
  {{- end }}
  {{- include "mychart.app" . | nindent 2 }}

# 如果使用template只能手动空格,不能使用管道后的nindent函数来做缩进