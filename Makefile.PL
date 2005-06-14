
use 5.005;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Module::Which',
    VERSION_FROM      => 'lib/Module/Which.pm', # finds $VERSION
    PREREQ_PM         => {
		Module::Find  => 0,
		Test::More    => 0,
	}, 
	EXE_FILES          => [ 'bin/which_pm.PL' ],
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Module/Which.pm', # retrieve abstract from module
       AUTHOR         => 'A. R. Ferreira <ferreira@cpan.org>') : ()),
);
