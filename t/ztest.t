use Test::More tests => 14;
BEGIN { use_ok('PANT') };
BEGIN { use_ok('PANT::Zip') };

my $outfile = "xxxtest3";
my @testarg = ("-output", $outfile);
my $zipname = "foo.zip";
@ARGV = @testarg;
@delfiles = ();
StartPant();
push(@delfiles, "$outfile.html");
{
    my $zip = Zip($zipname);
    ok($zip, "Zip object created");
    ok($zip->AddFile("Changes", "ChangeLog"), "Add Changes");
    ok($zip->AddTree('t', 'tests', sub { -f }), "Add tree t as tests");
    ok($zip->Close(), "ZIP written");
    ok(-f $zipname, "Zip file now exists");
    push(@delfiles, $zipname);
}
EndPant();

my $contents = FileLoad("$outfile.html");
ok($contents, "File $outfile.html read");
like($contents, qr{title}i, "Test summary appears");

{
    require Archive::Zip;
    $zip = Archive::Zip->new("foo.zip");
    ok($zip, "Zip file read");
    ok($zip->memberNamed( 'ChangeLog' ), "ChangeLog found");
    ok(!$zip->memberNamed( 'Changes' ), "Changes not found");
    ok($zip->memberNamed( 'tests/basic.t' ), "tests/basic.t found");
    ok(!$zip->memberNamed( 't/basic.t' ), "t/basic.t not found");
}

unlink(@delfiles);

sub FileLoad {
    my $fname = shift;
    local(*INPUT, $/);
    open (INPUT, $fname) || die "Can't open file $fname: $!";
    return <INPUT>;
}
