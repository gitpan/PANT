use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'PANT',
    'VERSION_FROM'	=> 'PANT.pm', # finds $VERSION
    'PREREQ_PM'		=> {XML::Writer=>0.52 }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'PANT.pm', # retrieve abstract from module
       AUTHOR     => 'Julian Onions <julianonions@yahoo.co.uk>') : ()),
    'LIBS'		=> [''], # e.g., '-lm'
    'DEFINE'		=> '', # e.g., '-DHAVE_SOMETHING'
    'INC'		=> '-I.', # e.g., '-I. -I/usr/include/other'
);
