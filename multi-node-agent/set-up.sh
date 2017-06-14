#!/bin/bash

###########
#
# HoangDH - 14/6/2017
# - Neu muon cau hinh dia chi IP cua srv OMD vui long bo comment o bien va 2 dong cau hinh o funciton setup()
# - Khai bao cac server o file servers.txt [IP USER PASSWORD] va 1 dong trong o cuoi file
###########


function test_file() {
	CUR_D=`pwd`
	check_ag=`ls $CUR_D | grep check-mk-agent*.rpm`
	check_xd=`ls $CUR_D | grep xinetd*.rpm`
	if [ -n "$check_ag" ] && [ -n "$check_xd" ]
    then
        echo "File: $check_ag, $check_xd"
    else
        echo "Not found Check_MK's Agent or xinetd in this folder." 
		exit
    fi
	
}

function setup() {

	echo "Script is installing on `hostname`"
	
	check_pk=`rpm -qa | grep xinetd`

    if [ -n "$check_pk" ]
    then
		cd /opt/mdt-agent
        echo "$check_pk has been installed."
		echo "Agent is installing..."
		#cat check-mk-agent*
		rpm -ivh check-mk-agent*
		systemctl restart xinetd
		systemctl enable xinetd
		#sed -i '/#only_from    =*/ s//only_from = $OMDSERVER/' /etc/xinetd.d/check_mk
    else
		cd /opt/mdt-agent
        echo "$check_pk is installing..." 
		rpm -ivh xinetd*
		#cat xinetd*
		echo "Agent is installing..."
		#cat check-mk-agent*
		rpm -ivh check-mk-agent*
		#sed -i '/#only_from    =*/ s//only_from = $OMDSERVER/' /etc/xinetd.d/check_mk
		systemctl enable xinetd
		systemctl restart xinetd
    fi 
	
	
	check_fw=`rpm -qa | grep firewalld`
	if [ -n "$check_fw" ]
	then
		firewall-cmd --add-port=6556/tcp --permanent
		firewall-cmd --reload
		echo "Firewall has been configured."
	fi 
}


IPs=`cat servers.txt | awk {'print $1'}`
USER=`cat servers.txt | awk {'print $2'}`
PASS=`cat servers.txt | awk {'print $3'}`
#OMDSERVER=0.0.0.0

arr_ip=(`echo $IPs | sed 's/ /\n/g'`)
arr_user=(`echo $USER | sed 's/ /\n/g'`)
arr_pass=(`echo $PASS | sed 's/ /\n/g'`)

LINE=`cat servers.txt | wc -l`
LINE=`echo $(( ${LINE#0} -1))`

for x in `seq 0 $LINE`;
do
	#echo "${arr_ip[$x]} ${arr_user[$x]} ${arr_pass[$x]}" 
	test_file
	sshpass -p ${arr_pass[$x]} ssh ${arr_user[$x]}@${arr_ip[$x]} "mkdir -p /opt/mdt-agent"
	sshpass -p ${arr_pass[$x]} scp -r $CUR_D/*.rpm ${arr_user[$x]}@${arr_ip[$x]}:/opt/mdt-agent
	sshpass -p ${arr_pass[$x]} ssh ${arr_user[$x]}@${arr_ip[$x]} "$(typeset -f); setup"
	sleep 10
done 


