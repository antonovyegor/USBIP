#!/bin/bash
trap "printf '\nGoodbye...\n' & exit" SIGINT  SIGHUP  SIGTERM

echo "Пакет USB/IP выполняет все команды в режиме superuser/root"
if [ $USER  != "root" ]
then 
	echo "Запустите скрипт с правами root"
	exit
else 


echo "Программа для настрйоки и установки USB/IP"
kernelversion=`uname -r`
echo "Версия вашего ядра - $kernelversion "
sleep 1


if sudo apt install linux-tools-$kernelversion; sudo apt install linux-cloud-tools-$kernelversion
then 
	echo "USB/IP   установлено  "
	if usbip version = "usbip (usbip-utils 2.0)" 
	then 
		echo "ОК"
		sleep 1
	else
		echo "Ошибка. Установлена другая версия"
		sudo apt remove --purge usbip* libusbip*
	fi
echo 
else 
	echo "Не удалось установить необходимые пакеты"
fi
sleep 1
sudo modprobe usbip-core 
sudo modprobe vhci-hcd 
#lsmod | grep usbip
ServerAdress="10.230.234.100"
echo "IP адрес сервера"
#read -r ServerAdress
echo $ServerAdress
echo "Порты для связи с USB: Rasp1 - 3241, Rasp2 - 3242, Rasp3 - 3243"
echo "Введите номер Rasp "
read -r RaspNum
if [ "$RaspNum" = 1 ] ||  [ "$RaspNum" = 3241 ]
then 
	PortUSBIP=3241
elif [ "$RaspNum" = 2 ] ||  [ "$RaspNum" = 3242 ]
then 
	PortUSBIP=3242
elif [ "$RaspNum" = 3 ] ||  [ "$RaspNum" = 3243 ]
then 
	PortUSBIP=3243
else 
	PortUSBIP=3240
fi
sleep 1

list=$((usbip --tcp-port $PortUSBIP list -r $ServerAdress) 2>&1 | grep "no")
if [ "$list" = "usbip: info: no exportable devices found on 10.230.234.100" ] ;then
	echo "No exportable device"
	exit
else
usbip --tcp-port $PortUSBIP list -r $ServerAdress

fi


echo "Введите необходимый порт"
echo "Для завершения ввода напишите END"


trap "sudo usbip  detach -p 00; printf '\nDetach port 00'
		sudo usbip  detach -p 01 ;printf '\nDetach port 01'
		sudo usbip  detach -p 02 ;printf '\nDetach port 02'
		sudo usbip  detach -p 03 ;printf '\nDetach port 03\n' 
		exit " SIGINT  SIGHUP
		
		
while true
do
	read -r PortNum 
	if  [ "$PortNum" != "END" ]
	then 
		sudo usbip --tcp-port $PortUSBIP attach -r $ServerAdress -b $PortNum
	else 
		break
	fi
done
sleep 1
echo "Подключенные порты"
usbip port
echo "ВНИМАНИЕ  Перед выключением клиента или сервера отпишитесь от порта"
#echo "Команда usbip port показывает подключенные порты"
#echo "Команда usbip detach -p xx    отключает порт"
echo "По завершению работы наберите в строке  detach"
echo "--- Ожидание ---"
while true
do
	read -r command 
	if  [ "$command" = "detach" ]
	then 
		sudo usbip  detach -p 00; echo "Detach port 00"
		sudo usbip  detach -p 01 ;echo "Detach port 01"
		sudo usbip  detach -p 02 ;echo "Detach port 02"
		sudo usbip  detach -p 03 ;echo "Detach port 03"
		echo "Done"
		exit
	fi
done



echo "END OF SCRIPT"
fi
exit
