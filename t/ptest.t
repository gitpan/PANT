use Test::More tests => 4;
BEGIN { use_ok('PANT') };
BEGIN { use_ok('PANT::Test') };

my $outfile = "xxxtest2";
my @testarg = ("-output", $outfile);
@ARGV = @testarg;
@delfiles = ();
StartPant();
push(@delfiles, "$outfile.html");
ok(RunTests(qw(t/fake.t)), "Run tests completes ok");

EndPant();

my $contents = FileLoad("$outfile.html");
like($contents, qr{\d+/\d+ subtests failed, \d+\.\d*% okay}i, "Test summary appears");

unlink(@delfiles);
sub FileLoad {
    my $fname = shift;
    local(*INPUT, $/);
    open (INPUT, $fname) || die "Can't open file $fname: $!";
    return <INPUT>;
}