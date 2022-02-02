# nvm-bash

nvm-bash is a bash script for changing node version in windows without admin privileges.

Note: You can only access these node versions from git bash. 

## Requirements
1. Git bash
2. Zip package of nodejs.

## Installation

1. Copy the script in your home directory.
2. Add script in .bash_profile under home directory
3. Download the zip of node version manually from their official website and extract it under a common directory where all other node versions will be extracted. 

Note: Also rename the directory with its version. for eg. 
if extracted dir name is: node-v13.12.0 win . then rename it to 13.12.
```bash
cp nvm-bash.sh ~/
echo ". ~/nvm-bash.sh" >> ~/.bash_profile
```
4. Open nvm-bash.sh in any text editor. Change the value of NODE_BASE_PATH and NODE_VERSION.
```bash
# NODE_BASE_PATH is the directory where node package is extracted. Keep in mind that all
# node versions should be extracted in same base path.
# For eg. 
# $ ls $NODE_BASE_PATH
# 13.12/  16.3/
NODE_BASE_PATH="/c/Users/{username}/nodejs"

# Use the directory name where the node package is extracted. The node.exe must be 
# present inside this directory name.
NODE_VERSION=13.12
```

5. Start a new session of git bash.

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
#for eg. 
# >> nvm_use 16.3
# Node js 16.3 version found. Updating the PATH.
# Node version set to 16.3.
```

## Why this script is not working for me?
1. Check if NODE_BASE_PATH is set correctly in the script.
2. Check if the nvm-bash.sh is present in the home directory.
3. Check if nvm-bash.sh script is invoked from ~/.bash_profile.
If '. ~/nvm-bash.sh' line not found then execute this from git bash.
```bash
echo ". ~/nvm-bash.sh" >> ~/.bash_profile
```