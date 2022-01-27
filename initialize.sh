mkdir dependencies
cd dependencies

# install JAVA

apt install default-jre


# install cavsat

wget http://pages.cs.wisc.edu/~xouyang/programs/dependencies/cavsat-jar.zip
unzip cavsat-jar.zip
rm cavsat-jar.zip

# install cplex

wget http://pages.cs.wisc.edu/~xouyang/programs/dependencies/cplex.bin
chmod 700 cplex.bin
./cplex.bin


# install MaxHS

git clone https://github.com/fbacchus/MaxHS.git
cp Makefile dependencies/MaxHS/
cd dependencies/MaxHS
make 
cd ../../
echo 'export PATH="$PATH:/fastdisk/LinCQA/dependencies/MaxHS/build/release/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/fastdisk/LinCQA/dependencies/MaxHS/build/release/bin"' >> ~/.bashrc



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



mkdir /fastdisk/sqlserver_storage/
mkdir /fastdisk/sqlserver_storage/data
mkdir /fastdisk/sqlserver_storage/log

sudo chown mssql /fastdisk/sqlserver_storage/data
sudo chgrp mssql /fastdisk/sqlserver_storage/data

sudo chown mssql /fastdisk/sqlserver_storage/log
sudo chgrp mssql /fastdisk/sqlserver_storage/log


sudo /opt/mssql/bin/mssql-conf set filelocation.defaultdatadir /fastdisk/sqlserver_storage/data
sudo /opt/mssql/bin/mssql-conf set filelocation.defaultlogdir /fastdisk/sqlserver_storage/log
systemctl restart mssql-server

source ~/.bashrc
source ~/.bash_profile
