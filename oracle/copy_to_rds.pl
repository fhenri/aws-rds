#!/usr/bin/perl
use DBI;
use File::Basename;
use warnings;
use strict;

use constant MB => 2<<20;

# RDS instance info
my $RDS_PORT=<port>; #usually 1521 by default
my $RDS_HOST="<endpoint>.rds.amazonaws.com";
my $RDS_LOGIN="<username>/<password>";
my $RDS_SID="DATABASE";

#The $ARGV[0] is a parameter you pass into the script
my $dirname = "DATA_PUMP_DIR";

my $data = "dummy";
my $chunk = 32767;
$| = 1; # turn off stdout buffering

my $sql_global = "create or replace package perl_global as fh utl_file.file_type; end;";
my $sql_open = "BEGIN perl_global.fh := utl_file.fopen(:dirname, :fname, 'wb', :chunk); END;";
my $sql_write = "BEGIN utl_file.put_raw(perl_global.fh, :data, true); END;";
my $sql_close = "BEGIN utl_file.fclose(perl_global.fh); END;";

my $conn = DBI->connect('dbi:Oracle:host='.$RDS_HOST.';sid='.$RDS_SID.';port='.$RDS_PORT,$RDS_LOGIN, '') || die ( $DBI::errstr . "\n");

my $updated=$conn->do($sql_global);

while (my $fpath = shift) {;
    my $fname = basename($fpath);

    my $stmt = $conn->prepare ($sql_open);
    $stmt->bind_param_inout(":dirname", \$dirname, 12);
    $stmt->bind_param_inout(":fname", \$fname, 12);
    $stmt->bind_param_inout(":chunk", \$chunk, 4);
    $stmt->execute() || die ( $DBI::errstr . "\n");

    open (INF, $fpath) || die "\nCan't open $fpath for reading: $!\n";
    binmode(INF);
    $stmt = $conn->prepare ($sql_write);
    my %attrib = ('ora_type','24');
    my $val = 1;
    my $size = -s $fpath;
    my $copied = 0;
    my $dur;
    my ($start, $now) = time();
    my ($eta, $rate) = ('?', 0);

    while ($val> 0) {
	$val = read (INF, $data, $chunk);
	$stmt->bind_param(":data", $data , \%attrib);
	$stmt->execute() || die ( $DBI::errstr . "\n") ; 
	$copied += $val;
	$dur = time() - $start;
	if ($dur > 0) {
	    $eta = localtime($start + $dur * $size / $copied);
	    $rate = $copied/MB/$dur*60;
	}
	printf STDERR "\rCopied %3dm - %3d%% of %s at %dm/min, ETA %s        ", $copied/MB, $copied*100./$size, $fpath, $rate, $eta;
    };
    print STDERR "\n";
    die "Problem copying: $!\n" if $!;
    close INF || die "Can't close $fpath: $!\n";
    $stmt = $conn->prepare ($sql_close);
    $stmt->execute() || die ( $DBI::errstr . "\n") ;
}
