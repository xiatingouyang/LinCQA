mkdir dependencies
cd dependencies

# install JAVA

apt install default-jre


# install cavsat

wget http://pages.cs.wisc.edu/~xouyang/programs/dependencies/cavsat-jar.zip
unzip cavsat-jar.zip


# install cplex

wget http://pages.cs.wisc.edu/~xouyang/programs/dependencies/cplex.bin
chmod 700 cplex.bin
./cplex.bin


# install MaxHS

git clone https://github.com/fbacchus/MaxHS.git
echo 'export PATH="$PATH:/fastdisk/LinCQA/dependencies/MaxHS/build/release/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/fastdisk/LinCQA/dependencies/MaxHS/build/release/bin"' >> ~/.bashrc
source ~/.bashrc


# install sqlserver

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)"
sudo apt-get update
sudo apt-get install -y mssql-server
sudo /opt/mssql/bin/mssql-conf setup

sudo apt-get update 
sudo apt install curl
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update 
sudo apt-get install mssql-tools unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc


mkdir sqlserver_storage/
mkdir sqlserver_storage/data
mkdir sqlserver_storage/log

sudo chown mssql sqlserver_storage/data
sudo chgrp mssql sqlserver_storage/data

sudo chown mssql sqlserver_storage/log
sudo chgrp mssql sqlserver_storage/log


sudo /opt/mssql/bin/mssql-conf set filelocation.defaultdatadir sqlserver_storage/data
sudo /opt/mssql/bin/mssql-conf set filelocation.defaultlogdir sqlserver_storage/log
systemctl restart mssql-server

