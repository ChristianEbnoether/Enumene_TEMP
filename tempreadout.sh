#!/bin/bash 
hostip="192.168.97.239"
sleeptime=15

get_info () {
	DATA="$(sensors)"
	temp=`echo $DATA | awk -F 'temp1: ' '{print $2}' | awk -F 'crit' '{print $1}' | egrep  -o '[0-9]{1,2}.[0-9]{1,2}'`
} 

print_data () {
    echo "hum: $temp"
}

write_data () {
    #Write the data to the database
    curl -i -XPOST 'http://192.168.100.9:8086/write?db=water' --data-binary "shelly,host=192.168.97.240,sensor=temp value=$temp"
}

while :
do
    #Sleep between readings
    sleep "$sleeptime"

    get_info

    if [ -z "$hum"  ];
        then
            sleep "$sleeptime"
            echo "Skip this datapoint - something went wrong with the read"

        else
            #Output console data for future reference
            #print_data
            write_data
    fi
done

get_sysctl_temp () {
    COUNTER=0
    while [  $COUNTER -lt 4 ]; do
         sensors > tempdatafile
    
         #chelsiotemp=`cat tempdatafile | grep "dev.t6nex.0" |  awk -F':' '{print $2}' | grep -o '[0-9]\+'`
         cpu0temp=`cat tempdatafile | grep "Core 0" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         cpu1temp=`cat tempdatafile | grep "Core 1" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         cpu2temp=`cat tempdatafile | grep "Core 2" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         cpu3temp=`cat tempdatafile | grep "Core 3" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         SFC0=`cat tempdatafile | grep -A7 "sfc-pci-0a00" | grep "Controller board temp.:" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         SFC1=`cat tempdatafile | grep -A7 "sfc-pci-0a01" | grep "Controller board temp.:" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         SYSTIN=`cat tempdatafile | grep "SYSTIN:" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         CPUTIN=`cat tempdatafile | grep "CPUTIN" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         AUXTIN0=`cat tempdatafile | grep "AUXTIN0" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         AUXTIN2=`cat tempdatafile | grep "AUXTIN2" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         AUXTIN3=`cat tempdatafile | grep "AUXTIN3" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         PECI=`cat tempdatafile | grep "PECI Agent 0:" | awk -F'(' '{print $1}' | grep -o '[0-9]\+.[0-9\+]' | cut -c 1-3`
         fan1=`cat tempdatafile | grep "fan1:" | awk -F'(' '{print $1}' | awk '{print $2}' | grep -o '[0-9]\+' | cut -c 1-4`
         fan2=`cat tempdatafile | grep "fan2:" | awk -F'(' '{print $1}' | awk '{print $2}' | grep -o '[0-9]\+' | cut -c 1-4`
         fan3=`cat tempdatafile | grep "fan3:" | awk -F'(' '{print $1}' | awk '{print $2}' | grep -o '[0-9]\+' | cut -c 1-4`
         fan4=`cat tempdatafile | grep "fan4:" | awk -F'(' '{print $1}' | awk '{print $2}' | grep -o '[0-9]\+' | cut -c 1-4`
         fan5=`cat tempdatafile | grep "fan5:" | awk -F'(' '{print $1}' | awk '{print $2}' | grep -o '[0-9]\+' | cut -c 1-4`
         rm tempdatafile 
   
         if [[ $cpu0temp -le 0 ]]; 
	         then
                 echo "Retry getting data - received some invalid data from the read"
             else
                #We got good data - exit this loop
                 COUNTER=10
         
         fi
         let COUNTER=COUNTER+1 


    print"temp ist"$cpu0temp

    done
}
    

write_data () {
     #Write the data to the database
     #curl -i -XPOST 'http://192.168.1.10:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=chelsiotemp value=$chelsiotemp"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=cpu0temp value=$cpu0temp"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=cpu1temp value=$cpu1temp"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=cpu2temp value=$cpu2temp"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=cpu3temp value=$cpu3temp"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=SFC0 value=$SFC0"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=SFC1 value=$SFC1"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=SYSTIN value=$SYSTIN"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=CPUTIN value=$CPUTIN"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=AUXTIN0 value=$AUXTIN0"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=AUXTIN2 value=$AUXTIN2"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=AUXTIN3 value=$AUXTIN3"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,sensor=PECI value=$PECI"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,fan=fan,sensor=FANSPEED1 value=$fan1"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,fan=fan,sensor=FANSPEED2 value=$fan2"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,fan=fan,sensor=FANSPEED3 value=$fan3"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,fan=fan,sensor=FANSPEED4 value=$fan4"
     curl -i -XPOST 'http://192.168.100.9:8086/write?db=temp' --data-binary "health_data,host=$hostip,fan=fan,sensor=FANSPEED5 value=$fan5"
}   
    
    
while :
do
    #Sleep between readings
    sleep "$sleeptime"

    get_sysctl_temp    
    
    if [[ $cpu0temp -le 0 ]];
        then
             echo "Skip this datapoint - something went wrong with the read"
        else
            write_data
    fi
done
