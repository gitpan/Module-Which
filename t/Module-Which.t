
use Test::More tests => 2;
BEGIN { use_ok('Module::Which') };

my @pm = qw(Module::Find Module::Which File::Spec);

my $info = which(@pm);

require Module::Find;
require Module::Which;
require File::Spec;

is_deeply($info,
	{ 
	'Module::Find' => { version => $Module::Find::VERSION },
	'Module::Which' => { version => $Module::Which::VERSION },
	'File::Spec' => { version => $File::Spec::VERSION },
	}, "very simple test is ok");
