#! /bin/bash

# Add base path of node where all the node versions are extracted.
NODE_BASE_PATH="/c/Users/{username}/nodejs"

# Sets the node version during git bash startup.
NODE_VERSION=

# Download url for node versions.
NODE_ARCHIVE_URL="https://nodejs.org/download/release/"

# Set node version in PATH if NODE_VERSION is defined
if [ -n "$NODE_VERSION" ]; then
    if [ -d "$NODE_BASE_PATH/$NODE_VERSION" ]; then
        echo "$PATH" | grep "${NODE_BASE_PATH}/${NODE_VERSION}" >> /dev/null
        if [ $? -ne 0 ]; then
            export PATH=$NODE_BASE_PATH/$NODE_VERSION:$PATH
        fi
    fi    
fi

#
# Check if node version is available in the archive.
# Parameters: Accepts a single string parameter as the value of node version.
#
check_version_availability () {
    node_version=$1
    ret=0
    if [ -z "$node_version" ]; then
        echo "Please enter a node version."
        return 1
    fi
    curl --head --silent --fail "${NODE_ARCHIVE_URL}/v${node_version}/node-v${node_version}-win-x64.zip" | grep 200 >> /dev/null 2>&1
    ret=$?
    if [ $ret -eq 0 ]; then
        echo "Node version found online."
        return $ret
    else
        echo "Node version not found."
        return $ret
    fi
    return $ret
}

#
# Download and extract the node version zip.
# Parameters: Accepts a single string parameter as the value of node version.
#
download_and_extract () {
    node_version=$1
    node_download_name=node-v${node_version}-win-x64
    ret=0
    if [ -z "$node_version" ]; then
        echo "Please enter a node version."
        return 1
    fi
    if [ ! -d ${NODE_BASE_PATH} ]; then
        echo "Creating directory for storing node versions at ${NODE_BASE_PATH}"
        mkdir -p $NODE_BASE_PATH
        ret=$?
        if [ $ret -ne 0 ]; then
            echo "Failed to create the node base path directory. Please check if path is correct and you have permission to create the directory."
            return $ret
        fi
    fi
    # Remove any old zip present for the given version.
    rm -f ${NODE_BASE_PATH}/${node_download_name}.zip >> /dev/null 2>&1

    # Download...
    echo "Downloading node version: ${node_version}"
    curl -L ${NODE_ARCHIVE_URL}/v${node_version}/${node_download_name}.zip -o ${NODE_BASE_PATH}/${node_download_name}.zip >> /dev/null 2>&1
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "Failed to download the node zip."
        return $ret
    fi

    # Extract...
    unzip ${NODE_BASE_PATH}/${node_download_name}.zip -d ${NODE_BASE_PATH} >> /dev/null 2>&1
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "Failed to extract the node zip."
        return $ret
    fi
    echo "Successfully extracted the node zip."

    # Rename...
    mv ${NODE_BASE_PATH}/${node_download_name} ${NODE_BASE_PATH}/${node_version} >> /dev/null 2>&1
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "Failed to rename the node version directory."
        return $ret
    fi

    # Remove the zip file after installation is complete.
    rm -f ${NODE_BASE_PATH}/${node_download_name}.zip >> /dev/null 2>&1

    return 0
}

#
# Print the versions available by doing a lookup in the BASE path. Also prints the node version set in PATH.
#
nvm_list () {
    find $NODE_BASE_PATH -maxdepth 1 -type d | grep -Eo "[0-9\.]*$"
    if [ $? -ne 0 ]; then
        echo "No node versions found. Please check if NODE_BASE_PATH is set correctly."
        return 1
    fi
    out=`echo "$PATH" | grep -Eo "${NODE_BASE_PATH}/[^:]*(:|$)" | head -n 1 | grep -Eo "[^/]*[:$]" | sed "s/://"`
    echo "Current Version: $out"
}

#
# Change the node version.
# Parameters: Accepts a single string parameter as the value of node version.
#
nvm_use () {
    node_version=$1
    ret=0
    if [ -z "$node_version" ]; then
        echo "Please enter a node version."
        return 1
    fi
    # Find the node version locally, if not found, download it from node archive.
    if [ ! -d "$NODE_BASE_PATH/$node_version" ]; then
        echo "Node ${node_version} not found locally. Trying to find it online..."
        check_version_availability ${node_version}
        ret=$?
        if [ $ret -eq 0 ]; then
            download_and_extract ${node_version}
            ret=$?
            if [ $ret -ne 0 ]; then
                echo "Failed to download and extract the node version zip."
                return $ret
            fi
        else
            echo "Node ${node_version} not found online."
            return $ret
        fi
    fi
    # Set PATH variable.
    echo "$PATH" | grep "$NODE_BASE_PATH" >> /dev/null
    if [ $? -eq 0 ]; then
        out=`echo $PATH | sed -r "s@${NODE_BASE_PATH}[^:]*(:|$)@${NODE_BASE_PATH}/${node_version}:@g"`
        ret=$?
        if [ $ret -eq 0 ]; then
            export PATH=$out
        else
            echo "Failed to update the path."
            return 1
        fi
    else
        echo "Node js ${node_version} not found in path. Adding it to the Path."
        export PATH=$NODE_BASE_PATH/${node_version}:$PATH
    fi
    # Change node version in the current file.
    sed -i "s/NODE_VERSION\=.*/NODE_VERSION\=${node_version}/" ~/nvm-bash.sh
    if [ $? -eq 0 ]; then
        echo "Node version set to ${node_version}."
    else
        echo "Failed to set the node version in ~/nvm-bash.sh"
        return 1
    fi
    unset out
    unset node_version
    unset current_dir
    return 0
}

#
# Remove node version
#
nvm_remove () {
    node_version=$1
    ret=0
    if [ -z "$node_version" ]; then
        echo "Please enter a node version."
        return 1
    fi
    if [ -d "${NODE_BASE_PATH}/${node_version}" ]; then
        if [ -f "${NODE_BASE_PATH}/${node_version}/node.exe" ]; then
            # Reset NODE_VERSION and PATH
            sed -i "s/NODE_VERSION\=.*/NODE_VERSION\=/" ~/nvm-bash.sh >> /dev/null 2>&1
            out=`echo $PATH | sed -r "s@${NODE_BASE_PATH}/${node_version}(:|$)@@g"`
            if [ $? -eq 0 ]; then
                export PATH=$out
            fi
            # Remove node version directory
            rm -rf "${NODE_BASE_PATH}/${node_version}"
            ret=$?
            if [ $ret -eq 0 ]; then
                echo "Successfully removed node version ${node_version}."
            else
                echo "Failed to remove node version ${node_version}"
            fi
        fi
    else
        echo "Node ${node_version} not found."
    fi
}

#
# Print Help
#
nvm_help () {
    echo "==== Welcome to nvm_bash ===="
    echo "Usage:"
    echo "nvm_list:                List the node versions available locally. Also displays the current version if set."
    echo "nvm_use <verion>:        Use a specified node version. If not found locally, it downloads from node archive."
    echo "nvm_remove <version>:    Remove the specified node version from local."
    echo "nvm_help:                Display help for using node_bash"
    echo ""
    echo "Note: This works only for node version 6.2.1 and above"
}
