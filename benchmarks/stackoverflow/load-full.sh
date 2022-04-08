chmod 660 /fastdisk/sqlserver_storage/data/*
chmod 660 /fastdisk/sqlserver_storage/log/*

chgrp mssql /fastdisk/sqlserver_storage/data/*
chgrp mssql /fastdisk/sqlserver_storage/log/*

chown mssql /fastdisk/sqlserver_storage/data/*
chown mssql /fastdisk/sqlserver_storage/log/*

sqlcmd -S localhost -U sa -P cqa2022! -i load-full.sql
