#! /bin/bash

# Add base path of node where all the node versions are extracted.
NODE_BASE_PATH="/c/Users/{username}/nodejs"

# Sets the node version during git bash startup.
NODE_VERSION=

if [ -d "$NODE_BASE_PATH/$NODE_VERSION" ]; then
    export PATH=$NODE_BASE_PATH/$NODE_VERSION:$PATH
fi

#
## Print the versions available by doing a lookup in the BASE path. Also prints the node version set in PATH.
#
nvm_list () {
    find $NODE_BASE_PATH -maxdepth 1 -type d | grep -Eo "[0-9\.]*$"
    out=`echo "$PATH" | grep -Eo "${NODE_BASE_PATH}/[^:]*(:|$)" | head -n 1 | grep -Eo "[^/]*[:$]" | sed "s/://"`
    echo "Current Version: $out"
}

#
## Change the node version.
##
## Parameters: Accepts a single string parameter as the value of node version.
## Note: This version must be same as the name of the directory in which node is extracted.
#
nvm_use () {
    node_version=$1
    if [ -z "$node_version" ]; then
        echo "Please enter a node version."
    else 
        if [ -d "$NODE_BASE_PATH/$node_version" ]; then
            echo "$PATH" | grep "$NODE_BASE_PATH" >> /dev/null
            if [ $? -eq 0 ]; then
                echo "Node js ${node_version} version found. Updating the PATH."
                out=`echo $PATH | sed -r "s@${NODE_BASE_PATH}[^:]*(:|$)@${NODE_BASE_PATH}/${node_version}:@g"`
                if [ $? -eq 0 ]; then
                    export PATH=$out
                else
                    echo "Failed to update the path."
                fi
            else
                echo "Node js ${node_version} not found in path. Adding it to the Path."
                export PATH=$NODE_BASE_PATH/$node_version:$PATH
            fi
            # Change node version in the current file
            current_dir=`pwd`
            sed -i "s/NODE_VERSION\=.*/NODE_VERSION\=${node_version}/" ${current_dir}/nvm-bash.sh >> /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "Node version set to ${node_version}."
            else
                echo "Failed to set the node version in ${current_dir}/nvm-bash.sh"
            fi
        else
            echo "Node version path not found."
        fi
    fi
    unset out
    unset node_version
    unset current_dir
}
