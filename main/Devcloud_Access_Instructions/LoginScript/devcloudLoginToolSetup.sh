
devcloud_login()
{
    red=$'\e[1;31m'
    blu=$'\e[1;34m'
    end=$'\e[0m'

    echo
    printf "%s\n" "${blu}What are you trying to use the Devcloud for? Please select a number from the list below: ${end}"
    echo
    echo "1) Arria 10 PAC Card Programming"
    echo "2) Stratix 10 PAC Card Programming"
    echo "3) Compilation Only"
    echo "4) Enter Specific Node Number"
    echo
    echo -n "Number: "  
    read -e number

    until [ "$number" -eq 1 ] || [ "$number" -eq 2 ] || [ "$number" -eq 3 ] || [ "$number" -eq 4 ]
    do
        printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
        echo -n "Number: "
        read -e number
    done

    currentNode="$(echo $HOSTNAME | grep -o -E '13[0-9]')"

    if [ $number -eq 1  ]; 
    then
        if [ -z $currentNode ]; #if current node is empty
        then
            #pbsnodes -s v-qsvr-fpga | grep -B 4 'arria10' | grep -B 1 "state = free"| grep -B 1 '13[0-9]' | grep -o '...$' > ~/nodes.txt
            #node=$(head -n 1 nodes.txt)
            readarray availableNodes < <(pbsnodes -s v-qsvr-fpga | grep -B 4 'arria10' | grep -B 1 "state = free"| grep -B 1 '13[0-9]' | grep -o '...$')
            if [ ${#availableNodes[@]} == 0 ]; #if length of availableNodes is empty then no nodes are available
            then
                echo
                echo
                printf "%s\n" "${red}--------------------------------------------------------------- ${end} "
                printf "%s\n" "${red}No available nodes for this hardware. Please select a new node. ${end} "
                printf "%s\n" "${red}--------------------------------------------------------------- ${end} "
                devcloud_login
            else
                node=(${availableNodes[0]})
                echo
                echo --------------------------------------------------------------------------------------
                printf "%s\n" "${blu}Please copy and paste the following text in a new mobaxterm terminal: ${end} "
                echo
                printf  "%s\n" "${blu}ssh -L 4002:s001-n"$node":22 colfax-intel${end} "
                echo
                echo --------------------------------------------------------------------------------------
                echo
                qsub -q batch@v-qsvr-fpga -I -l nodes=s001-n"$node":ppn=2
            fi
        else
            printf "%s\n" "${red}You are currently on a node. Please exit the current node and try again.${end}"
        fi
    elif [ $number -eq 2 ]; 
    then
        if [ -z $currentNode ]; 
        then
            readarray availableNodes < <(pbsnodes -s v-qsvr-fpga | grep -B 4 'darby' | grep -B 1 "state = free"  | grep -B 1 '189' | grep -o '...$')
            if [ ${#availableNodes[@]} == 0 ]; #if length of availableNodes is empty then no nodes are available
            then
                echo
                echo
                printf "%s\n" "${red}--------------------------------------------------------------- ${end} "
                printf "%s\n" "${red}No available nodes for this hardware. Please select a new node. ${end} "
                printf "%s\n" "${red}--------------------------------------------------------------- ${end} "
                devcloud_login
            else
                node=(${availableNodes[0]})
                echo
                echo --------------------------------------------------------------------------------------
                printf "%s\n" "${blu}Please copy and paste the following text in a new mobaxterm terminal: ${end} "
                echo
                printf  "%s\n" "${blu}ssh -L 4002:s001-n"$node":22 colfax-intel${end} "
                echo
                echo --------------------------------------------------------------------------------------
                echo
                qsub -q batch@v-qsvr-fpga -I -l nodes=s001-n"$node":ppn=2
            fi
        else
            printf "%s\n" "${red}You are currently on a node. Please exit the current node and try again.${end}"
        fi
    elif [ $number -eq 3 ]; 
    then
        if [ -z $currentNode ]; 
        then
            readarray availableNodes < <(pbsnodes | grep -B 1 "state = free"| grep -T '13[0-6]' | grep -o '...$')
            if [ ${#availableNodes[@]} == 0 ]; #if length of availableNodes is empty then no nodes are available
            then
                echo
                echo
                printf "%s\n" "${red}--------------------------------------------------------------- ${end} "
                printf "%s\n" "${red}No available nodes for this hardware. Please select a new node. ${end} "
                printf "%s\n" "${red}--------------------------------------------------------------- ${end} "
                devcloud_login
            else
                node=(${availableNodes[0]})
                echo
                echo --------------------------------------------------------------------------------------
                printf "%s\n" "${blu}Please copy and paste the following text in a new mobaxterm terminal: ${end} "
                echo
                printf  "%s\n" "${blu}ssh -L 4002:s001-n"$node":22 colfax-intel${end} "
                echo
                echo --------------------------------------------------------------------------------------
                echo
                qsub -I -l nodes=s001-n"$node":ppn=2
            fi
        else
            printf "%s\n" "${red}You are currently on a node. Please exit the current node and try again.${end}"
        fi
    elif [ $number -eq 4 ];
    then
        if [ -z $currentNode ]; 
        then

            readarray availableNodesNohardware < <(pbsnodes |grep -B 1 "state = free"| grep -T '13[0-6]' | grep -o '...$')
            readarray availableNodesArria < <(pbsnodes -s v-qsvr-fpga | grep -B 4 'arria10' | grep -B 1 "state = free"| grep -B 1 '13[0-9]' | grep -o '...$')
            readarray availableNodesStratix < <(pbsnodes -s v-qsvr-fpga | grep -B 4 'darby' | grep -B 1 "state = free"  | grep -B 1 '189' | grep -o '...$')
            # availableNodes=() #initialize the empty array
            # availableNodes+=($availableNodesNohardware) #append an
            # availableNodes+=($availableNodesArria)
            # availableNodes+=($availableNodesStratix)
            # echo ${availableNodes}
            availableNodes=( "${availableNodesNohardware[@]}" "${availableNodesArria[@]}" "${availableNodesStratix[@]}" )
            echo ${availableNode[@]}
            echo ${availableNode[2]}
            echo "                               Showing available nodes below:                          "
            echo --------------------------------------------------------------------------------------
            printf "%s\n" "${blu}Nodes with no attached hardware:${end}          "
            pbsnodes |grep -B 1 "state = free"| grep -T '13[0-6]' | grep -o '...$'
            echo
            echo --------------------------------------------------------------------------------------
            printf "%s\n" "${blu}Nodes with Arria 10${end}         "
            pbsnodes -s v-qsvr-fpga | grep -B 4 'arria10' | grep -B 1 "state = free"| grep -B 1 '13[0-9]' | grep -o '...$'
            printf "%s\n" "${blu}Nodes with Stratix 10${end}         "
            pbsnodes -s v-qsvr-fpga | grep -B 4 'darby' | grep -B 1 "state = free"  | grep -B 1 '189' | grep -o '...$'
            echo --------------------------------------------------------------------------------------
            echo
            echo What node would you like to use?
            echo
            echo -n "Node: "
            read -e node

            until  [ $node -lt 140 ] && [ $node -gt 129 ]  ||  [ "$node" == 189 ]
            do
                printf "%s\n" "${red}Please input an available node number: ${end}"
                echo -n "Node: "
                read -e node
            done

            if [ ${#availableNodes[@]} == 0  ];
            then
                echo
                echo
                printf "%s\n" "${red}--------------------------------------------------------------- ${end} "
                printf "%s\n" "${red}No available nodes. Try again later. ${end} "
                printf "%s\n" "${red}--------------------------------------------------------------- ${end} "
            else
                if [ $node -lt 136 ];
                then
                    echo
                    echo --------------------------------------------------------------------------------------
                    printf "%s\n" "${blu}Please copy and paste the following text in a new mobaxterm terminal: ${end} "
                    echo
                    printf  "%s\n" "${blu}ssh -L 4002:s001-n"$node":22 colfax-intel${end} "
                    echo
                    echo --------------------------------------------------------------------------------------
                    echo
                    qsub -I -l nodes=s001-n"$node":ppn=2
                else
                    echo
                    echo --------------------------------------------------------------------------------------
                    printf "%s\n" "${blu}Please copy and paste the following text in a new mobaxterm terminal: ${end} "
                    echo
                    printf  "%s\n" "${blu}ssh -L 4002:s001-n"$node":22 colfax-intel${end} "
                    echo
                    echo --------------------------------------------------------------------------------------
                    echo
                    qsub -q batch@v-qsvr-fpga -I -l nodes=s001-n"$node":ppn=2
                fi
            fi
        else
            printf "%s\n" "${red}You are currently on a node. Please exit the current node and try again.${end}"
        fi
    fi
}





tools_setup()
{
    red=$'\e[1;31m'
    blu=$'\e[1;34m'
    end=$'\e[0m'

    QUARTUS_LITE_VERSIONS=("18.1")
    QUARTUS_STANDARD_VERSIONS=("18.1")
    QUARTUS_PRO_VERSIONS=("17.1" "18.1" "19.2" "19.3")
    # QUARTUS_LITE_VERSIONS="18.1"
    # QUARTUS_STANDARD_VERSIONS="18.1"
    # QUARTUS_PRO_VERSIONS="17.1 18.1 19.1 19.3"

    #defined paths
    GLOB_INTELFPGA_PRO="/glob/development-tools/versions/intelFPGA_pro"
    GLOB_INTELFPGA_LITE="/glob/development-tools/versions/intelFPGA_lite"
    GLOB_INTELFPGA_STANDARD="/glob/development-tools/versions/intelFPGA"
    QUARTUS_PATHS=($GLOB_INTELFPGA_LITE $GLOB_INTELFPGA_STANDARD $GLOB_INTELFPGA_PRO)
    OPT_INTEL="/opt/intel"
    OPT_INTEL_2="/opt/intel/2.0.1"

    echo
    printf "%s\n" "${blu}Which tool would you like to source? Please select a number from the list below: ${end}"
    echo
    echo "1) Quartus Prime Lite"
    echo "2) Quartus Prime Standard"
    echo "3) Quartus Prime Pro"
    echo "4) OpenCL"
    echo "5) HLS"
    echo "6) Arria 10 Development Stack (only if on n137, n138, n139)"
    echo "7) Arria 10 RunTime Environment (only if on n137, n138, n139)"
    echo "8) Stratix 10 Development Stack (only if on n189)"
    echo "9) Stratix 10 RunTime Environment (only if on n189)"
    echo
    echo -n "Number: "  
    read -e number

    until [ "$number" -lt 10 ] && [ "$number" -gt 0 ]
    do
        printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
        echo -n "Number: "
        read -e number
    done


    if [ $number -eq 1  ]; 
    then
        len=${#QUARTUS_LITE_VERSIONS[@]}
        if [ $len -eq 0 ];
        then
            echo "${red}Something went wrong, does not support any quartus Lite versions ${end}"
        elif [ $len -eq 1 ];
        then
            #source the one version
            echo "sourcing $GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[0]}/init_quartus.sh"
            source $GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[0]}/init_quartus.sh
            echo
        elif [ $len -gt 1 ];
        then
            echo "${blu}which quartus Lite version would you like to source?${end}"
            # let i=1
            # for version in $QUARTUS_LITE_VERSIONS
            for (( i=0; i<${len}; i++ ));
            do
                # echo "${i} ) ${version}"
                echo "${i} ) ${QUARTUS_LITE_VERSIONS[$i]}"
                # let i++
            done
            echo
            echo -n "2nd Number: "  
            read -e second_number
            until [ $len -gt $second_number ];
            do
                printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
                echo -n "2nd Number: "
                read -e second_number
            done
            echo "sourcing $GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[$second_number]}/init_quartus.sh"
            #source depending on what second_number they chose
            source $GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[$second_number]}/init_quartus.sh
            echo
        else
            echo "${red}Something went wrong sourcing the lite version ${end}"
        fi

    elif [ $number -eq 2 ];
    then
        len=${#QUARTUS_STANDARD_VERSIONS[@]}
        if [ $len -eq 0 ];
        then
            echo "${red}Something went wrong, does not support any quartus standard versions ${end}"
        elif [ $len -eq 1 ];
        then
            echo "sourcing $GLOB_INTELFPGA_STANDARD/${QUARTUS_STANDARD_VERSIONS[0]}/init_quartus.sh"
            #source the one version
            source $GLOB_INTELFPGA_STANDARD/${QUARTUS_STANDARD_VERSIONS[0]}/init_quartus.sh
            echo
        elif [ $len -gt 1 ];
        then
            echo "${blu}which quartus standard version would you like to source?${end}"
            # let i=1
            # for version in $QUARTUS_LITE_VERSIONS
            for (( i=0; i<${len}; i++ ));
            do
                # echo "${i} ) ${version}"
                echo "${i} ) ${QUARTUS_STANDARD_VERSIONS[$i]}"
                # let i++
            done
            echo
            echo -n "2nd Number: "  
            read -e second_number
            until [ $len -gt $second_number ];
            do
                printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
                echo -n "2nd Number: "
                read -e second_number
            done
            echo "sourcing $GLOB_INTELFPGA_STANDARD/${QUARTUS_STANDARD_VERSIONS[$second_number]}/init_quartus.sh"
            #source depending on what second_number they chose
            source $GLOB_INTELFPGA_STANDARD/${QUARTUS_STANDARD_VERSIONS[$second_number]}/init_quartus.sh
            echo
        else
            echo "${red}Something went wrong sourcing the standard version ${end}"
        fi

    elif [ $number -eq 3 ];
    then
        len=${#QUARTUS_PRO_VERSIONS[@]}
        if [ $len -eq 0 ];
        then
            echo "${red}Something went wrong, does not support any quartus pro versions ${end}"
        elif [ $len -eq 1 ];
        then
            echo "sourcing $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/init_quartus.sh"
            #source the one version
            source $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/init_quartus.sh
            echo
        elif [ $len -gt 1 ];
        then
            echo "${blu}which quartus pro version would you like to source?${end}"
            # let i=1
            # for version in $QUARTUS_LITE_VERSIONS
            for (( i=0; i<${len}; i++ ));
            do
                # echo "${i} ) ${version}"
                echo "${i} ) ${QUARTUS_PRO_VERSIONS[$i]}"
                # let i++
            done
            echo
            #echo "length of array is ${len}"
            echo -n "2nd Number: "  
            read -e second_number
            until [ $len -gt $second_number ];
            do
                printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
                echo -n "2nd Number: "
                read -e second_number
            done
            echo "sourcing $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[$second_number]}/init_quartus.sh"
            #source depending on what second_number they chose
            source $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[$second_number]}/init_quartus.sh
            echo
        else
            echo "${red}Something went wrong sourcing the pro version ${end}"
        fi
    elif [ $number -eq 4 ]; #case for OpenCL
    then
        len=${#QUARTUS_PRO_VERSIONS[@]}
        if [ $len -eq 0 ];
        then
            echo "${red}Something went wrong, does not support any quartus pro versions ${end}"
        elif [ $len -eq 1 ];
        then
            export INTELFPGAOCLSDKROOT=$GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/hld

            #source the one version of quartus
            echo "sourcing $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/init_quartus.sh"
            source $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/init_quartus.sh

            #source the one version of OpenCL
            echo "sourcing $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/hls/init_opencl.sh"
            source $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/hls/init_opencl.sh

            echo
        elif [ $len -gt 1 ];
        then
            #ask which verison of openCL
            echo "${blu}which openCL version would you like to source?${end}"
            for (( i=0; i<${len}; i++ ));
            do
                echo "${i} ) ${QUARTUS_PRO_VERSIONS[$i]}"
            done
            echo
            #echo "length of array is ${len}"
            echo -n "2nd Number: "  
            read -e second_number
            until [ $len -gt $second_number ];
            do
                printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
                echo -n "2nd Number: "
                read -e second_number
            done

            export INTELFPGAOCLSDKROOT=$GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[$second_number]}/hld

            #source quartus
            echo "sourcing $INTELFPGAOCLSDKROOT/../init_quartus.sh"
            source $INTELFPGAOCLSDKROOT/../init_quartus.sh

            #source opencl
            echo "sourcing $INTELFPGAOCLSDKROOT/init_opencl.sh"
            source $INTELFPGAOCLSDKROOT/init_opencl.sh
        
        else
            echo "something went wrong with sourcing openCL"
        fi

    elif [ $number -eq 5 ]; #case for HLS
    then
        
        #ask which quartus version
        echo "${blu}which quartus version would you like?${end}"
        echo "1) Quartus Prime Standard"
        echo "2) Quartus Prime Lite"
        echo "3) Quartus Prime Pro"
        echo
        #echo "length of array is ${len}"
        echo -n "Number: "  
        read -e qnumber
        until [ "$qnumber" -lt 4 ] && [ "$number" -gt 0 ]
        do
            printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
            echo -n "Number: "
            read -e qnumber
        done

        if [ $qnumber -eq 1 ]; #case for quartus STANDARD
        then
            len=${#QUARTUS_STANDARD_VERSIONS[@]}
            if [ $len -eq 0 ];
            then
                echo "${red}Something went wrong, does not support any quartus standard versions ${end}"
            elif [ $len -eq 1 ];
            then
                export INTELFPGAOCLSDKROOT=$GLOB_INTELFPGA_STANDARD/${QUARTUS_STANDARD_VERSIONS[0]}/hls

                #source the one version of quartus
                echo "sourcing $GLOB_INTELFPGA_STANDARD/${QUARTUS_STANDARD_VERSIONS[0]}/init_quartus.sh"
                source $GLOB_INTELFPGA_STANDARD/${QUARTUS_STANDARD_VERSIONS[0]}/init_quartus.sh

                #source the one version of OpenCL
                echo "sourcing $GLOB_INTELFPGA_STANDARD/${QUARTUS_STANDARD_VERSIONS[0]}/hls/init_hls.sh"
                source $GLOB_INTELFPGA_STANDARD/${QUARTUS_STANDARD_VERSIONS[0]}/hls/init_hls.sh

                echo
            elif [ $len -gt 1 ];
            then
                #ask which verison of openCL
                echo "${blu}which openCL version would you like to source?${end}"
                for (( i=0; i<${len}; i++ ));
                do
                    echo "${i} ) ${QUARTUS_LITE_VERSIONS[$i]}"
                done
                echo
                #echo "length of array is ${len}"
                echo -n "2nd Number: "  
                read -e second_number
                until [ $len -gt $second_number ];
                do
                    printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
                    echo -n "2nd Number: "
                    read -e second_number
                done

                export INTELFPGAOCLSDKROOT=$GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[$second_number]}/hls

                #source quartus
                echo "sourcing $INTELFPGAOCLSDKROOT/../init_quartus.sh"
                source $INTELFPGAOCLSDKROOT/../init_quartus.sh

                #source opencl
                echo "sourcing $INTELFPGAOCLSDKROOT/init_hls.sh"
                source $INTELFPGAOCLSDKROOT/init_hls.sh
            
            else
                echo "something went wrong with sourcing hls for quartus lite"
            fi
        elif [ $qnumber -eq 2 ]; #case for quartus LITE
        then
            len=${#QUARTUS_LITE_VERSIONS[@]}
            if [ $len -eq 0 ];
            then
                echo "${red}Something went wrong, does not support any quartus lite versions ${end}"
            elif [ $len -eq 1 ];
            then
                export INTELFPGAOCLSDKROOT=$GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[0]}/hls

                #source the one version of quartus
                echo "sourcing $GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[0]}/init_quartus.sh"
                source $GLOB_INTELFPGA_LITE/${QUARTUS_PRO_VERSIONS[0]}/init_quartus.sh

                #source the one version of OpenCL
                echo "sourcing $GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[0]}/hls/init_hls.sh"
                source $GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[0]}/hls/init_hls.sh

                echo
            elif [ $len -gt 1 ];
            then
                #ask which verison of openCL
                echo "${blu}which openCL version would you like to source?${end}"
                for (( i=0; i<${len}; i++ ));
                do
                    echo "${i} ) ${QUARTUS_LITE_VERSIONS[$i]}"
                done
                echo
                #echo "length of array is ${len}"
                echo -n "2nd Number: "  
                read -e second_number
                until [ $len -gt $second_number ];
                do
                    printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
                    echo -n "2nd Number: "
                    read -e second_number
                done

                export INTELFPGAOCLSDKROOT=$GLOB_INTELFPGA_LITE/${QUARTUS_LITE_VERSIONS[$second_number]}/hls

                #source quartus
                echo "sourcing $INTELFPGAOCLSDKROOT/../init_quartus.sh"
                source $INTELFPGAOCLSDKROOT/../init_quartus.sh

                #source opencl
                echo "sourcing $INTELFPGAOCLSDKROOT/init_hls.sh"
                source $INTELFPGAOCLSDKROOT/init_hls.sh
            
            else
                echo "something went wrong with sourcing hls for quartus lite"
            fi
        elif [ $qnumber -eq 3 ]; #case for quartus PRO
        then
            len=${#QUARTUS_PRO_VERSIONS[@]}
            if [ $len -eq 0 ];
            then
                echo "${red}Something went wrong, does not support any quartus pro versions ${end}"
            elif [ $len -eq 1 ];
            then
                export INTELFPGAOCLSDKROOT=$GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/hls

                #source the one version of quartus
                echo "sourcing $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/init_quartus.sh"
                source $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/init_quartus.sh

                #source the one version of OpenCL
                echo "sourcing $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/hls/init_hls.sh"
                source $GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[0]}/hls/init_hls.sh

                echo
            elif [ $len -gt 1 ];
            then
                #ask which verison of openCL
                echo "${blu}which openCL version would you like to source?${end}"
                for (( i=0; i<${len}; i++ ));
                do
                    echo "${i} ) ${QUARTUS_PRO_VERSIONS[$i]}"
                done
                echo
                #echo "length of array is ${len}"
                echo -n "2nd Number: "  
                read -e second_number
                until [ $len -gt $second_number ];
                do
                    printf "%s\n" "${red}Invalid Entry. Please input a correct number from the list above. ${end} "
                    echo -n "2nd Number: "
                    read -e second_number
                done

                export INTELFPGAOCLSDKROOT=$GLOB_INTELFPGA_PRO/${QUARTUS_PRO_VERSIONS[$second_number]}/hls

                #source quartus
                echo "sourcing $INTELFPGAOCLSDKROOT/../init_quartus.sh"
                source $INTELFPGAOCLSDKROOT/../init_quartus.sh

                #source opencl
                echo "sourcing $INTELFPGAOCLSDKROOT/init_hls.sh"
                source $INTELFPGAOCLSDKROOT/init_hls.sh
            
            else
                echo "something went wrong with sourcing hls for quartus pro"
            fi
        else
            echo "something went wrong with case statements for hls"
        fi

    elif [ $number -eq 6 ]; #case for arria 10 development stack
    then
        #need to check if on correct node only on 137,138,139
        temp_string="$(echo $HOSTNAME | grep -o -E '13[7-9]')"
        if [ -n temp_string ]; #if len of temp_string is greater than zero
        then
            echo "sourcing /opt/a10/inteldevstack/init_env.sh"
            #source command
            source /opt/a10/inteldevstack/init_env.sh
            echo
        else
            echo "Not on a node 137-139. You need to be on a node 137-139 to run Arria Development Stack"
        fi
    elif [ $number -eq 7 ]; #case for arria 10 RunTime environment
    then
        #need to check if on correct node only on 137 138 139
        temp_string="$(echo $HOSTNAME | grep -o -E '13[7-9]')"
        if [ -n temp_string ]; #if len of temp_string is greater than zero
        then 
            echo "sourcing /opt/a10/intelrtestack/init_env.sh"
            #source command
            source /opt/a10/intelrtestack/init_env.sh
            echo
        else
            echo "Not on a node 137-139. You need to be on a node 137-139 to run Arria RunTime Environment"
        fi
    elif [ $number -eq 8 ]; #case for stratix 10 development stack
    then
        temp_string="$(echo $HOSTNAME | grep -o -E '189')"
        if [ -n $temp_string ];
        then
            echo "sourcing $OPT_INTEL_2/inteldevstack/init_env.sh"
            source $OPT_INTEL_2/inteldevstack/init_env.sh
            echo
        else
            echo "you are not on node 189. You need 189 to run Stratix Development Stack"
        fi
    elif [ $number -eq 9 ]; #case for stratix 10 RunTime environment
    then
        #need to check if on correct node only on 189
        temp_string="$(echo $HOSTNAME | grep -o -E '189')"
        if [ -n $temp_string ];
        then
            echo "sourcing $OPT_INTEL_2/intelrtestack/init_env.sh"
            source $OPT_INTEL_2/intelrtestack/init_env.sh
            echo
        else
            echo "you are not on node 189. You need 189 to run Stratix RunTime Environment"
        fi
    else
        echo "printing else statement for sourcing cases"
    fi


}

