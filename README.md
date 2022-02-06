# nvm-bash

nvm-bash is a bash script for changing node version in windows without admin privileges.

Note: You can only access these node versions from git bash. This works only for node version 6.2.1 and above.

## Requirements
1. Git bash

## Installation

1. Copy the script in your home directory.
```bash
cp nvm-bash.sh ~/
```
2. Add script in .bash_profile under home directory
```bash
echo ". ~/nvm-bash.sh" >> ~/.bash_profile
```

3. Open nvm-bash.sh in any text editor. Change the value of NODE_BASE_PATH.
```bash
# NODE_BASE_PATH is the directory where node package is extracted. Keep in mind that all
# node versions will be extracted in the same base path.
# For eg. 
# $ ls $NODE_BASE_PATH
# 13.12.0/  16.3.0/
NODE_BASE_PATH="/c/Users/{username}/nodejs"
```

4. Start a new session of git bash.

## Usage

```bash
# List node versions and display current version.
nvm_list
# for eg. 
# >> nvm_list
# 13.12
# 16.3
# Current Version: 16.3

# Use a different version of nodejs.
nvm_use <version>
# for eg. 
# >> nvm_use 16.3
# Node js 16.3 version found. Updating the PATH.
# Node version set to 16.3.

# To remove a nodejs version
nvm_remove <version>
# for eg.
# >> nvm_remove 6.2.1
# Successfully removed node version 6.2.1.

# Print help
nvm_help
# for eg.
# >> nvm_help
# ****Welcome to nvm_bash****
# Usage:
# nvm_list:                 List the node versions available locally. Also displays the current version if set.
# nvm_use <version>:        Use the specified node version. If not found locally, it downloads from node archive.
# nvm_remove <version>:     Remove the specified node version from local.
# nvm_help:                 Display help for using node_bash
```

## Why this script is not working for me?
1. Check if NODE_BASE_PATH is set correctly in the script.
2. Check if extracted directories of node versions have node.exe.
3. Check if the nvm-bash.sh is present in the home directory.
4. Check if nvm-bash.sh script is invoked from ~/.bash_profile.
If '. ~/nvm-bash.sh' line not found then execute this from git bash.
```bash
echo ". ~/nvm-bash.sh" >> ~/.bash_profile
```
