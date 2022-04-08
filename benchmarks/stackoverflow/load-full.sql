CREATE DATABASE StackOverflow ON 
( FILENAME = '/fastdisk/sqlserver_storage/data/StackOverflow_1.mdf'),
( FILENAME = '/fastdisk/sqlserver_storage/data/StackOverflow_2.ndf'),
( FILENAME = '/fastdisk/sqlserver_storage/data/StackOverflow_3.ndf'),
( FILENAME = '/fastdisk/sqlserver_storage/data/StackOverflow_4.ndf')
LOG ON ( FILENAME = '/fastdisk/sqlserver_storage/log/StackOverflow_log.ldf' )
FOR ATTACH;
GO
