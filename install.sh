#!/bin/bash
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
ariaDir=~/.aria2
ariaConf=${ariaDir}/aria2.conf
ariaSession=${ariaDir}/aria2.session

runScript=run_aria2.sh
ServiceName=aria2.service
InstallPath=/usr/bin/

askToDo(){
    echo "${ariaConf} 已存在"
    read -p "是否覆盖? Y/N y/n " input
    case $input in
    # 如果用户输入的内容是以字母y或Y开头，则显示一些信息到标准输出
        [yY]*)
        rm -rf ${ariaConf}
        cp ./aria2.conf ${ariaConf}
        ;;
        # 如果用户输入的内容是以字母n或N开头，则退出脚本的执行
        [nN]*)
        #     return
        ;;
        *)
            echo "Just enter y no n, please."
            askToDo
        ;;
    esac
}

initFile(){
    if [ ! -d ${ariaDir} ];then
        mkdir ${ariaDir}
    else
        echo "${ariaDir}文件夹已存在"
    fi

    if [ ! -f ${ariaConf} ];then
        cp ./aria2.conf ${ariaConf}
    else
        askToDo
    fi

    if [ ! -f ${ariaSession} ];then
        touch $ariaSession
    else
       echo "${ariaSession} 已存在"
    fi

}

setupFile(){
	if [ -f $SHELL_FOLDER/$ServiceName ];then
        rm -rf $SHELL_FOLDER/$ServiceName
		echo "rm $SHELL_FOLDER/$ServiceName"
	fi
    echo "cp $SHELL_FOLDER/$runScript.template $SHELL_FOLDER/$runScript"
    cp $SHELL_FOLDER/$runScript.template $SHELL_FOLDER/$runScript
    sed -i "s#template#$ariaConf#g" $SHELL_FOLDER/$runScript

    echo "cp $SHELL_FOLDER/$ServiceName /usr/lib/systemd/system/"
    cp $SHELL_FOLDER/$ServiceName.template $SHELL_FOLDER/$ServiceName
    sed -i "s#template#$SHELL_FOLDER#g" $SHELL_FOLDER/$ServiceName

    cp $SHELL_FOLDER/$ServiceName /usr/lib/systemd/system/
    echo "cp ./aria2c /usr/bin/"

    cp $SHELL_FOLDER/aria2c $InstallPath

    systemctl daemon-reload
    systemctl start aria2
    systemctl status aria2
    systemctl enable aria2
}

echo "Step 1. 初始化配置文件"
echo "当前路径 $SHELL_FOLDER"
initFile
echo "Step 2. 部署脚本和二进制文件"
setupFile

# cp io.github.aria2.plist ~/Library/LaunchAgents/io.github.aria2.plist
# cd ~/Library/LaunchAgents/
# chmod 644 io.github.aria2.plist
# launchctl load io.github.aria2.plist
# launchctl start io.github.aria2
