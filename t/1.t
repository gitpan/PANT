# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

use Test::More tests => 18;

BEGIN { use_ok('PANT') };

#########################

my $outfile = "xxxtest";
my @testarg = ("-output", $outfile);
@ARGV = @testarg;

my $titlename = "This is my title";
StartPant($titlename);
EndPant();
ok(-f "$outfile.html", "HTML output generated from @testarg");
my $fcontents = FileLoad("$outfile.html");

like($fcontents, qr{<title\s*>$titlename</title\s*>}i, "Title is as expected");

ok(unlink("$outfile.html"), "Remove file works");

@ARGV =@testarg;
StartPant();

ok(Task(1, "Task works"), "Task works using @testarg");
ok(Task(1, "2nd Task Works"), "2nd task works");
ok(Command("echo hello"), "Command echo works");

my @dellist = ();
ok(open(TFILE, ">test.tmp"), "Created temporary file");
push(@dellist, "test.tmp");
sleep 1;
ok(open(TFILE, ">test2.tmp"), "Created 2nd temporary file");
close(TFILE);
push(@dellist, "test2.tmp");

ok(!NewerThan(sources=>[qw(test.tmp)], targets=>[qw(test2.tmp)]), "Newer test");
ok(NewerThan(sources=>[qw(test2.tmp)], targets=>[qw(test.tmp)]), "Older test");

ok(CopyFile("test2.tmp", "test3.tmp"), "Copied file");
push(@dellist, "test3.tmp");
ok(-f "test3.tmp", "test3.tmp exists");
is(-s "test3.tmp", -s "test2.tmp", "Files are the same size");

ok(unlink(@dellist), "Removed temporary files");
EndPant();
$fcontents = FileLoad("$outfile.html");
like($fcontents, qr{<li\s*>\s*Task works}i, "Task1 appears in output");
like($fcontents, qr{<li\s*>\s*2nd Task works}i, "Task1 appears in output");
ok(unlink("$outfile.html"), "Remove file works");


sub FileLoad {
    my $fname = shift;
    local(*INPUT, $/);
    open (INPUT, $fname) || die "Can't open file $fname: $!";
    return <INPUT>;
}