# PANT::Test - Test modules from PANT

package PANT::Test;

use 5.008;
use strict;
use warnings;
use Carp;
use Cwd;
use XML::Writer;
use Test::Harness;
use Benchmark;
use Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use PANT ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw() ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( );

our $VERSION = '0.01';


sub new {
    my($clsname, $writer, @args) =@_;
    my $self = { 
	writer=>$writer,
	@args
    };
    bless $self, $clsname;
    return $self;
}

sub RunTests {
    my($self, @tests) = @_;
    my $writer = $self->{writer};
    my $retval = 1;
    $writer->startTag('li');
    $writer->characters("Run the following tests");
    $writer->startTag('ul');
    if ($self->{dryrun}) {
	foreach my $t (@tests) {
	    $writer->dataElement('li', "Test $t");
	}
    }
    else {

	my @headers = ('Failed Test', 'Stat', 'Wstat', 'Total', 'Fail', 'Failed', 'List of failed tests');
	my($tot, $failedtests) = Test::Harness::_run_all_tests(@tests);
	$writer->dataElement('li',
			     sprintf(" %d/%d subtests failed, %.2f%% okay.",
				     $tot->{max} - $tot->{ok}, $tot->{max}, 
				     100*$tot->{ok}/$tot->{max}));

	$retval = Test::Harness::_all_ok($tot);
	if (!$retval) {
	    $writer->startTag('table', border=>1);
	    $writer->startTag('tr');
	    foreach my $h (@headers) {
		$writer->dataElement('th', $h);
	    }
	    $writer->endTag('tr');
	    foreach my $t (sort keys %{ $failedtests }) {
		$writer->startTag('tr');
		my @things = qw(name estat wstat max failed percent canon);
		foreach my $h (@things) {
		    $writer->dataElement('td', $failedtests->{$t}->{$h});
		}
		$writer->endTag('tr');
	    }
	    $writer->endTag('table');
	}
	$writer->dataElement('li', sprintf ("Files=%d, Tests=%d, %s\n",
					    $tot->{files}, $tot->{max}, 
					     timestr($tot->{bench}, 'nop')));
    }
    $writer->endTag('ul');
    $writer->endTag('li');
    return $retval;
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

PANT::Test - PANT support for running tests

=head1 SYNOPSIS

  use PANT::Test;

  $tester = new PANT::Test($xmlwriter);
  $tester->runtests(@testlist);

=head1 ABSTRACT

  This is part of a module to help construct automated build environments.
  This part is for running tests.

=head1 DESCRIPTION

This module is part of a set to help run automated
builds of a project and to produce a build log. This part
is designed to incorporate runs of the perl test suite.
By careful massage, it is possible (though more tricky than you
might think!) to run arbritrary tests that output perl test format
output.

=head1 EXPORTS

=head2 new

Constructor for a test object. Requires an XML::Writer object as a parameter, which it
will use for subsequent log construction.

=head1 METHODS

=head2 runtests

This takes a list of files with tests in to run. The output is 
trapped and diverted to the logging stream.


=head1 SEE ALSO

Makes use of XML::Writer to construct the build log.


=head1 AUTHOR

Julian Onions, E<lt>julianonions@yahoo.nospam-co.uk<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by Julian Onions

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 


=cut
