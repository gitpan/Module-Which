
use 5.005;
use ExtUtils::MakeMaker;

if ($] < 5.006) {
    print "Downgrading source code from 5.006 to 5.005\n";
    use lib qw(inc);
    use Module::Downgrade;
    downgrade('lib/Module/Which.pm', 
		      'lib/Module/Which/List.pm', 
		      'lib/Data/Hash/Transform.pm', 
		      'bin/which_pm');
}

WriteMakefile(
    NAME              => 'Module::Which',
    VERSION_FROM      => 'lib/Module/Which.pm', # finds $VERSION
    PREREQ_PM         => {
        #Module::Find  => 0,
        Getopt::Long             => 0, 
        Pod::Usage               => 0,
        Test::More               => 0,
        File::Glob               => 0,
        File::Find               => 0,
        File::Spec               => 0.8,
    }, 
    EXE_FILES          => [ 'bin/which_pm' ],
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Module/Which.pm', # retrieve abstract from module
       AUTHOR         => 'A. R. Ferreira <ferreira@cpan.org>',
       NO_META           => 1) : ()),
);
