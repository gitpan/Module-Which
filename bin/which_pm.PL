#!/usr/bin/perl -w

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01_01';

use Module::Which;

our $VERBOSE = 0 || $ENV{WHICH_PM_VERBOSE};

my $which_options = {
	return => 'ARRAY',
	verbose => $VERBOSE
};

my $info = which(@ARGV, $which_options);

for (@$info) {
	my $pm_info = $_;
	$pm_info->{version} = "(not found)" unless defined $pm_info->{version};
	printf "%-20s $pm_info->{version}\n", $pm_info->{pm};
}



__END__
=head1 NAME

which_pm - Perl script to find out which versions of certain Perl modules are installed

=head1 SYNOPSIS

  which_pm DBI DBD::*
  which_pm Module::Find Module::Which File::*

=head1 DESCRIPTION

See the the documentation of L<Module::Which>.

=head1 SEE ALSO

Please report bugs via CPAN RT L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Which>.

=head1 AUTHOR

Adriano R. Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Adriano R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
