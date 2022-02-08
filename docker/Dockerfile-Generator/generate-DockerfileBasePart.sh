HEADER_ROOT=project
LOCAL_REPO=http://192.168.1.124:10006/base_runtime_pkgs
PY_VERSION=37
PIP_VERSION=3.7
HAS_TENSORRT=false
function check_list()
{
      value=$1
      if [[ $value =~ ^-* ]];
      then
        echo $value
      fi
}

function get_pkg(){
   pkg_name=$1
   if [[ $pkg_name =~ ^TensorRT* ]];
   then
#     echo "======================"
     HAS_TENSORRT=$(echo $pkg_name | awk -F '.' '{print $1"."$2"."$3"."$4}' | awk -F '-' '{print $NF}')     
  #   echo $HAS_TENSORRT
 #    echo "====================="
   fi

   if [[ $pkg_name =~ ^cudnn* ]];
   then
     pkg_name=$pkg_name".tgz"
   elif [[ $pkg_name =~ *.py ]];
   then
     echo "$pkg_name"
   else
     pkg_name=$pkg_name".tar.gz"
   fi
   download_path=$2
   echo "RUN curl -L ${LOCAL_REPO}/${pkg_name} -o \${WORK_DATA_PATH}/${pkg_name} && tar zxvf \${WORK_DATA_PATH}/${pkg_name} -C \${WORK_DATA_PATH} && mv -v \${WORK_DATA_PATH}/${pkg_name} /tmp"
}

function chk_tensorrt()
{
  if [[ $HAS_TENSORRT ]];
  then
     echo "RUN pip${PIP_VERSION} install \${WORK_DATA_PATH}/TensorRT-${HAS_TENSORRT}/python/tensorrt-${HAS_TENSORRT}-cp${PY_VERSION}-none-linux_x86_64.whl"
     echo "RUN echo 'export LD_LIBRARY_PATH=/data/TensorRT-${HAS_TENSORRT}/lib:$LD_LIBRARY_PATH' >> ~/.bashrc"
  fi
}

function get_py(){
      value=$1
      echo "RUN apt install -y ${value} ${value}-dev"
      get_pkg get-pip.py /tmp
      echo "RUN ${value} /tmp/get-pip.py -i https://pypi.douban.com/simple/"
      version=$(echo ${value} | tr -cd "[0-9]")
      echo "ENV PY_VERSION=${version}"
      echo "ENV PIP_VERSION=${value:6}"
      PY_VERSION=${version}
      PIP_VERSION=${value:6}
}

#ARR_SIZE=$(cat config.yml | shyaml get-length $HEADER_ROOT)
#echo $ARR_SIZE
for item in $(cat config.yml | shyaml keys $HEADER_ROOT);
do
  # echo "${HEADER_ROOT}-${ind}";
  #cat config.yml | shyaml get-length $HEADER_ROOT.$item 
  #cat config.yml | shyaml get-value $HEADER_ROOT.$item 
  #echo ""
  backgroundstr="#=========== + ============#"
  echo ${backgroundstr/+/$item}
  
  PKG_LIST=""
  
  CHECK_SYSTEM_PKG=0
  values=($(cat config.yml | shyaml get-values $HEADER_ROOT.$item))
  for value in ${values[@]};
  do
     if [[ $item == name ]];
     then
       continue
     fi
     if [[ $item == env_var ]];
     then
      # value=$(echo $value | awk -F '-' '{print $NF}' )
       echo "RUN echo ${value} >> ~/.bashrc"
     elif [[ $item == base_runtime ]];
     then
       echo "FROM ${value}"
       echo "RUN echo 'export LD_LIBRARY_PATH=/usr/local/cuda-${value}/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc"
       cat Dockerfile.basic.templ
     elif [[ $item == base_runtime_pkgs ]];
     then
       get_pkg ${value} /home/data
     elif [[ $item == python_version ]];
     then
       get_py ${value}
     elif [[ $item == "system-pkgs" ]];
     then
       CHECK_SYSTEM_PKG=1
       PKG_LIST=$PKG_LIST" "${value}
     elif [[ $item == "pip-pkgs" ]];
     then
       echo "RUN pip${PIP_VERSION} install -r ${value} -i http://pypi.douban.com/simple"
       chk_tensorrt 
     else
       echo "ERROR! Not accept data!"
     fi

  done
  if [[ $CHECK_SYSTEM_PKG -eq 1 ]];
  then
    echo "RUN apt install -y $PKG_LIST"
  fi
done
cat Dockerfile.proj.templ
