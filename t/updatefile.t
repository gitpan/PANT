# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

use Test::More tests => 6;

BEGIN { use_ok('PANT') };

#########################

my $outfile = "xxxtest";
my @testarg = ("-output", $outfile);
@ARGV = @testarg;

my @dellist = ("$outfile.html");

StartPant("Test UpdateFile stuff");

my $tmpfile = "xxxtest.txt";
push(@dellist, $tmpfile);

WriteFile($tmpfile, <<'EOF');
This is a test file
It has some stuff I want to modify
#define VERSION 1.1
#define RELDATE 1/1/0000
EOF
ok(UpdateFileVersion($tmpfile,
		     qr/(\#define\s*VERSION\s*\d+\.)(\d+)/=>q{"$1" . ($2+1)}),
   "File been updated");
my $contents = FileLoad($tmpfile);
like($contents, qr/VERSION\s*1\.2/, "Version number has been incremented");
my $date = localtime();
ok(UpdateFileVersion($tmpfile,
		     qr/(\#define\s*VERSION\s*\d+\.)(\d+)/=>q{"$1" . ($2+1)},
		     qr/(RELDATE\s*)(.*)/ => qq{"\$1$date"}
		     ),
   "File has been updated"
   );

$contents = FileLoad($tmpfile);
like($contents, qr/VERSION\s*1\.3/, "Version number has been incremented");
like($contents, qr/RELDATE\s*$date/, "Version date has changed");
EndPant();

unlink(@dellist);

sub WriteFile {
	my($name, $contents) = @_;
	open(FILE, ">$name") || die "Can't write file $name: $!";
	print FILE $contents;
	close(FILE);
}


sub FileLoad {
    my $fname = shift;
    local(*INPUT, $/);
    open (INPUT, $fname) || die "Can't open file $fname: $!";
    return <INPUT>;
}

