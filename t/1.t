# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

use Test::More tests => 15;
BEGIN { use_ok('PANT') };

#########################

my $outfile = "xxxtest";
my @testarg = ("-output", $outfile);
@ARGV = @testarg;

StartPant();
EndPant();
ok(-f "$outfile.html", "HTML output generated from @testarg");
ok(unlink("$outfile.html"), "Remove file works");

@ARGV =@testarg;
StartPant();

ok(Task(1, "Task works"), "Task works");
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
ok(unlink("$outfile.html"), "Remove file works");
