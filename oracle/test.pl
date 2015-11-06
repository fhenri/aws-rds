use DBI;
use warnings;
use strict;

# RDS instance info
my $RDS_PORT=<port>; #usually 1521 by default
my $RDS_HOST="<endpoint>.rds.amazonaws.com";
my $RDS_LOGIN="<username>/<password>";
my $RDS_SID="DATABASE";

my $conn = DBI->connect('dbi:Oracle:host='.$RDS_HOST.';sid='.$RDS_SID.';port='.$RDS_PORT,$RDS_LOGIN, '') || die ( $DBI::errstr . "\n") ;
my $sth = $conn->prepare("select * from dual");
$sth->execute;
print "Got here without dying\n";