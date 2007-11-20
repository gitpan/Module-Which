
use 5.005;
use ExtUtils::MakeMaker;

my $EUMM_VERSION = eval $ExtUtils::MakeMaker::VERSION;

BEGIN {
    if ($] < 5.006) {
        print "Downgrading source code from 5.006 to 5.005\n";
        require lib; lib->import( qw(inc) );
        require Module::Downgrade; Module::Downgrade->import;
        downgrade( qw( lib/Module/Which.pm
                       lib/Module/Which/List.pm
                       lib/Data/Hash/Transform.pm
                       bin/which_pm
        ) );
    }
}

WriteMakefile(
    NAME              => 'Module::Which',
    VERSION_FROM      => 'lib/Module/Which.pm', # finds $VERSION
    PREREQ_PM         => {
        'Getopt::Long'            => 0,
        'Pod::Usage'              => 0,
        'File::Find'              => 0,
        'File::Spec::Unix'        => 0,
        'File::Spec'              => 0.8,
        'File::Glob'              => 0,
        'String::Truncate'        => 0,

        'Test::More'              => 0,
    },
    EXE_FILES          => [ 'bin/which_pm' ],
    ( $] >= 5.005 ? (
      ABSTRACT_FROM  => 'lib/Module/Which.pm', # retrieve abstract from module
      AUTHOR         => 'A. R. Ferreira <ferreira@cpan.org>',
    ) : () ),
    ( $EUMM_VERSION > 6.31 ? (
      LICENSE        => 'perl',
      EXTRA_META     => <<YAML,

recommends:
    Test::Pod:                     1.18
    Term::Size:                    0
no_index:
    file:
        - inc/Module/Downgrade.pm

YAML
    ) : () ),
);
