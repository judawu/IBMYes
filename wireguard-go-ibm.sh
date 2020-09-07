#!/bin/bash
SH_PATH=$(cd "$(dirname "$0")";pwd)
cd ${SH_PATH}

create_mainfest_file(){
    echo "进行配置。。。"
    read -p "请输入你的应用名称：" IBM_APP_NAME
    echo "应用名称：${IBM_APP_NAME}"
    read -p "请输入你的应用内存大小(默认64)：" IBM_MEM_SIZE
    if [ -z "${IBM_MEM_SIZE}" ];then
    IBM_MEM_SIZE=64
    fi
  
    
    cd ${SH_PATH}/wireguard-go-ibm
    cat >  ${SH_PATH}/wireguard-go-ibm/manifest.yml  << EOF
    applications:
    - path: .
      name: ${IBM_APP_NAME}
      random-route: true
      memory: ${IBM_MEM_SIZE}M
EOF
    echo "配置完成。"
}

clone_repo(){
  echo "进行初始化。。。"
  mkdir  ${SH_PATH}/wireguard-go-ibm
  cd  ${SH_PATH}/wireguard-go-ibm
  rm -rf wireguard-go
  git clone https://git.zx2c4.com/wireguard-go
  cd wireguard-go
  make
   echo "初始化完成。"
}

 install(){
    echo "进行安装。。。"
    cd ${SH_PATH}/wireguard-go-ibm
    ibmcloud target --cf
    echo "N"|ibmcloud cf install
    ibmcloud cf push
    echo "安装完成。"
   
}

clone_repo
create_mainfest_file
install
exit 0
