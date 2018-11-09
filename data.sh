#!/bin/bash

unset LD_LIBRARY_PATH

set -x

oldifs="$IFS"
IFS=$'\n'

deviceip=(192.168.1.241 192.168.1.242 192.168.1.243 192.168.1.244 192.168.1.245)

declare -u ip

for ip in ${deviceip[@]};do
  {
    set -a IfNumber
    set -a IfDescr
    set -a IfOperStatus
    set -a IfAdminStatus
    set -a IfInDiscard
    set -a ifInErrors
    set -a ifHCOutOctets
    set -a ifHCInOctets
    set -a IfOutDiscard
    set -a ipAdEntAddrtemp
    set -a ipAdEntNetMasktemp
    set -a ipAdEntIfIndex
    set -a ipAdEntAddr
    set -a ipAdEntNetMask
    HostName=`snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.1.5.0 | sed -r 's/[^\"]*\"([^"]+)\"[^\"]*/\1/'`
    
    IfNumber=`snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.2.1.0 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`
    echo $IfNumber
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.2.2.1.2 | sed -r 's/[^\"]*\"([^"]+)\"[^\"]*/\1/'`;do
      	IfDescr[$index]=$Ifdata;
      	let index=index+1;
    done
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.2.2.1.8 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`;do
      	IfOperStatus[$index]=$Ifdata;
      	let index=index+1;
    done
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.2.2.1.7 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`;do
      	IfAdminStatus[$index]=$Ifdata;
      	let index=index+1;
    done
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.2.2.1.13 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`;do
      	IfInDiscard[$index]=$Ifdata;
      	let index=index+1;
    done
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.2.2.1.14 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`;do
      	IfInErrors[$index]=$Ifdata;
      	let index=index+1;
    done
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.31.1.1.1.10 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`;do
      	ifHCOutOctets[$index]=$Ifdata;
      	let index=index+1;
    done
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.31.1.1.1.6 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`;do
      	ifHCInOctets[$index]=$Ifdata;
      	let index=index+1;
    done
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.2.2.1.19 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`;do
      	IfOutDiscard[$index]=$Ifdata;
      	let index=index+1;
    done
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.4.20.1.1 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`;do
        ipAdEntAddrtemp[$index]=$Ifdata;
        let index=index+1;
    done
    
    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.4.20.1.3 | sed -r 's/[^:]*:\s*([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/\1/'`;do
        ipAdEntNetMasktemp[$index]=$Ifdata;
        let index=index+1;
    done

    index=0
    for Ifdata in `snmpwalk -v 2c -c public $ip 1.3.6.1.2.1.4.20.1.2 | sed -r 's/[^:]*:\s*([0-9]+)/\1/'`;do
        ipAdEntIfIndex[$index]=$Ifdata;
        let index=index+1;
    done

    for ((i = 0;i < $index;i++));do
      ipAdEntAdd[${ipAdEntIfIndex[$i]}-1]=${ipAdEntAddrtemp[$i]};
      ipAdEntNetMask[${ipAdEntIfIndex[$i]}-1]=${ipAdEntNetMasktemp[$i]}
    done
    
    for j in $(seq 1 $IfNumber);do
    	echo "`date +"%Y-%m-%d %H:%M"`:00 HostName=$HostName ifindex=$j IfDescr=${IfDescr[$j-1]} IfAdminStatus=${IfAdminStatus[$j-1]} IfOperStatus=${IfOperStatus[$j-1]} IfInDiscard=${IfInDiscard[$j-1]} IfInErrors=${IfInErrors[$j-1]} ifHCOutOctets=${ifHCOutOctets[$j-1]} ifHCInOctets=${ifHCInOctets[$j-1]} IfOutDiscard=${IfOutDiscard[$j-1]} ipAdEntAdd=${ipAdEntAdd[$j-1]} ipAdEntNetMask=${ipAdEntNetMask[$j-1]}"
    done
    unset IfNumber
    unset IfDescr
    unset IfOperStatus
    unset IfAdminStatus
    unset IfInDiscard
    unset ifInErrors
    unset ifHCOutOctets
    unset ifHCInOctets
    unset IfOutDiscard
    unset ipAdEntAddrtemp
    unset ipAdEntNetMasktemp
    unset ipAdEntIfIndex
    unset ipAdEntAdd
    unset ipAdEntNetMask
  }
done
IFS="$oldifs"
