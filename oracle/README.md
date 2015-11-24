**Introduction**

The scripts included in this repository are :

- `test.pl` : this script comes from http://www.connecteddba.com/howto/MigratetoRDS.html and test the connection from EC2 instance to the RDS instance.

You need to make sure to change the following variables

    my $RDS_PORT=<port>; #usually 1521 by default
    my $RDS_HOST="<endpoint>.rds.amazonaws.com";
    my $RDS_LOGIN="<username>/<password>";
    my $RDS_SID="<sid>";

*Usage of script*
    
    bash-4.1$ perl test.pl
    Got here without dying

- `copy_to_rds.pl` : this script comes from [http://www.connecteddba.com/howto/MigratetoRDS.html](http://www.connecteddba.com/howto/MigratetoRDS.html) (script from this page has a typo) and [https://d0.awsstatic.com/whitepapers/strategies-for-migrating-oracle-database-to-aws.pdf](https://d0.awsstatic.com/whitepapers/strategies-for-migrating-oracle-database-to-aws.pdf)

The script allows to copy any files from EC2 instance into an RDS instance.
you need to make sure to change the following variables

    my $RDS_PORT=<port>; #usually 1521 by default
    my $RDS_HOST="<endpoint>.rds.amazonaws.com";
    my $RDS_LOGIN="<username>/<password>";
    my $RDS_SID="<sid>";

*Usage of script*

    bash-4.1$ perl copy_rds.pl files_{01..03}.dmp
    Copied 566m - 100% of files_01.dmp at 1063m/min, ETA Tue Oct 20 21:08:37 2015
    Copied 1561m - 100% of files_02.dmp at 1052m/min, ETA Tue Oct 20 21:10:06 2015
    Copied 1189m - 100% of files_03.dmp at 1097m/min, ETA Tue Oct 20 21:11:11 2015


