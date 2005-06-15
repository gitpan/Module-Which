
use Test::More tests => 2;
BEGIN { use_ok('Module::Which') };

my @pm = qw(Module::Find Module::Which File::Spec);

my $info = which(@pm);

require Module::Find;
require Module::Which;
require File::Spec;

is_deeply($info,
	[ 
	{ version => $Module::Find::VERSION, pm => 'Module::Find' },
	{ version => $Module::Which::VERSION, pm => 'Module::Which' },
	{ version => $File::Spec::VERSION, pm => 'File::Spec' },
	], "very simple test is ok");
