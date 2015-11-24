**Using DBMS_FILE_TRANSFER.PUT_FILE**

If your RDS instance release is 11.2.0.2.v6, you can use `DBMS_FILE_TRANSFER` to transfer files between the two instances via a database link that connects to the RDS instance.

on target (target.cnrsdab7emat.us-east-1.rds.amazonaws.com)

    create user USERX identified by PASSX
    temporary tablespace TEMP;
    grant create session to USERX;
    grant execute on dbms_datapump to USERX;
    grant read, write on directory data_pump_dir to USERX;

on source (source.cnrsdab7emat.us-east-1.rds.amazonaws.com)

    create database link to_rds connect to USERX identified by PASSX
    using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=target.cnrsdab7emat.us-east-1.rds.amazonaws.com)(PORT=1521))(CONNECT_DATA=(SID=<ORCL_SID>)))';


launch the file transfer (from source)

    BEGIN
      DBMS_FILE_TRANSFER.PUT_FILE(
        source_directory_object => 'DATA_PUMP_DIR',
        source_file_name => 'file.dmp',
        destination_directory_object => 'DATA_PUMP_DIR',
        destination_file_name => 'file.dmp',
        destination_database => 'to_rds'
      );
    END;
    /


**IMPORT DB over network link**

on target 

    create database link to_rds connect to USERX identified by PASSX
    using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=source.cnrsdab7emat.us-east-1.rds.amazonaws.com)(PORT=1521))(CONNECT_DATA=(SID=<ORCL_SID>)))';

create Tablespaces and Users

    impdp <master user>/<master pass>@target.cnrsdab7emat.us-east-1.rds.amazonaws.com:1521/ARIBADB network_link=to_rds directory=data_pump_dir EXCLUDE=statistics


**Transfer files from RDS to EC2 running Oracle**

If oracle is running locally on EC2 instance, its possible to transfer files from RDS to the EC2 instance
on Oracle EC2 (target)

    create database link to_ec2db connect to USERX identified by PASSX
    using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=source.cnrsdab7emat.us-east-1.rds.amazonaws.com)(PORT=1521))(CONNECT_DATA=(SID=ARIBADB)))';

    CREATE DIRECTORY DATA_PUMP_DIR AS <local EC2 path>

    BEGIN
      DBMS_FILE_TRANSFER.GET_FILE(
        source_directory_object => 'DATA_PUMP_DIR',
        source_file_name => 'file.dmp',
        destination_directory_object => 'DATA_PUMP_DIR',
        destination_file_name => 'file.dmp',
        source_database => 'to_ec2db'
      );
    END;
    /

