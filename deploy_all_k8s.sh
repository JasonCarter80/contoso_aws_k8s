#!/usr/local/bin/bash
ACTION=$1
PROJECT=$2
SKIP_FOLDER_NUM=15

if [[ $@ == *"--dry-run"* ]]; then
  DRYRUN="1"
fi

if [[ $@ == *"--debug"* ]]; then
  DEBUG="1"
fi
for D in *; do
    if [ -d "${D}" ]; then
        IFS='_' read -r NUM OTHER <<< "${D}"
        if [[ ! "$NUM" -gt "$SKIP_FOLDER_NUM" ]]; then
            echo "Skipping ${D}"
            continue
        else
            if [ "$DEBUG" == "1" ]; then
                echo "DEBUG: Found ${D}"
            fi 
        fi
        if [ -d "${D}/environments" ]; then        
            EXECUTED=()
            for F in ${D}/environments/$PROJECT*; do
                if [ -f "${F}" ]; then
                    filename=$(basename -- "$F")
                    extension="${filename##*.}"
                    PROJECT_THIS="${filename%.*}"
                    if [[ ! "${EXECUTED[@]}" =~ "${PROJECT_THIS}" ]]; then
                        if [ "$DEBUG" == "1" ]; then
                            echo "DEBUG: Processeing $PROJECT_THIS"
                        fi 
                        COMMAND="./deploy.sh $ACTION ${D} $PROJECT_THIS"
                        if [ "$DRYRUN" == "1" ]; then
                            echo "DRYRUN: $COMMAND"
                        else
                            $COMMAND
                        fi
                        EXECUTED+=($PROJECT_THIS)
                    else
                        if [ "$DEBUG" == "1" ]; then
                            echo "DEBUG: Already processed $PROJECT_THIS"
                        fi 

                    fi
                else
                    if [ "$DEBUG" == "1" ]; then
                        echo "DEBUG: ${D}/environments/$PROJECT* -  not found"
                    fi 
                fi
            done 
        else
            if [ "$DEBUG" == "1" ]; then
                echo "DEBUG: ${D} - environments folder not found"
            fi 
        fi
    fi
done

#echo $1;
#./deploy.sh apply 15_kubernetes $1
#./deploy.sh apply 18_kubernetes_tiller $1
#./deploy.sh apply 19_istio $1
#./deploy.sh apply 19_cluster_autoscaler $1
##./deploy.sh apply 30_weave $1