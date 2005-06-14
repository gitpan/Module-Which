#!/usr/bin/perl -w

use 5.005;
use strict;
use warnings;

our $VERSION = '0.01';

use Module::Which;
#$Module::Which::VERBOSE = 0;

my $info = which(@ARGV);

#for (@ARGV) {
for (keys %$info) {
	my $pm_info = $info->{$_};
	$pm_info->{version} = "(not found)" unless defined $pm_info->{version};
	printf "%-20s $pm_info->{version}\n", $_;
}



__END__
=head1 NAME

which_pm - Perl script to find out which versions of certain Perl modules are installed

=head1 SYNOPSIS

  which_pm DBI "DBD::*"
  which_pm Module::Find Module::Which "File::*"

=head1 DESCRIPTION

See the the documentation of L<Module::Which>.

=head1 TO DO

=over 4

=item *

Provide a way to preserve the order of the modules according to
the original order of modules and subcategories given as arguments.
This will provide a nicer and more intuitive output to the script.

=item *

Produce a nicer output for long module names.

=item *

Options to control C<which_pm> behavior: like C<--verbose>, etc.

=item *

More comprehensive test suite.

=back

=head1 SEE ALSO

Please report bugs via CPAN RT L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Which>.

=head1 AUTHOR

Adriano R. Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Adriano R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
