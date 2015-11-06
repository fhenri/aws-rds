**Install Package**

On fresh centos EC2 machine, install the following package

    yum install perl-CPAN
    yum install 'perl(CGI)' 'perl(LWP::UserAgent)'
    yum install bc
    yum install libaio
    yum install gcc


**Oracle PreRequisites**

Add swap file to install make Oracle installation

Step 1. Create the new file

    root@bootux:~# dd if=/dev/zero of=/swapfile bs=1024000 count=3096

Step 2. Format the new file to make it a swap file

    root@bootux:~# mkswap /swapfile

Step 3. Enable the new swapfile. Only the swapon command is needed, but with the free command you can clearly see the swap space is made available to the system.

    root@bootux:~# swapon /swapfile


**Oracle variables**

Install oracle client and set variable (make sure to change `ORACLE_HOME` if needed)

    export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
    PATH=$ORACLE_HOME/bin:$PATH
    LD_LIBRARY_PATH=$ORACLE_HOME/lib
    export ORACLE_HOME
    export LD_LIBRARY_PATH
    export PATH


**perl libraries**
Install the following libraries from cpan

    cpan[]> install DBI
    cpan[]> install install Class::HPLOO
    cpan[]> install DBD
    cpan[]> install DBD:Oracle


