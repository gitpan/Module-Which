#!/usr/bin/perl -w

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01_02';

use Module::Which;
use Getopt::Long;
use Pod::Usage;

our $VERBOSE = 0 || $ENV{WHICH_PM_VERBOSE};

my %which_options;
%which_options = (
	return => 'ARRAY',
	verbose => $VERBOSE,
	quiet => sub { $which_options{verbose} = 0 },	
);

GetOptions(
	\%which_options,
	"verbose",
	"quiet",
	#"include=s@"
	"help",
	"man",
) or pod2usage(2);

#pod2usage(1) if $which_options{help};
pod2usage(-exitstatus => 1, -verbose => 1) if $which_options{help};
pod2usage(-exitstatus => 0, -verbose => 2) if $which_options{man};

#use YAML; #$YAML::DumpCode = 1;
#print Dump \%which_options;

my $info = which(@ARGV, \%which_options);

for (@$info) {
	my $pm_info = $_;
	$pm_info->{version} = "(not found)" unless defined $pm_info->{version};
	printf "%-20s $pm_info->{version}\n", $pm_info->{pm};
}



__END__

=head1 NAME

which_pm - Perl script to find out which versions of certain Perl modules are installed

=head1 SYNOPSIS

  which_pm [--verbose] [--quiet] DBI DBD::*
  which_pm --help
  which_pm --man

  which_pm Module::Find Module::Which File::*

  Options:
    -verbose       shows error messages (due to "require $module")
    -quiet         hides error messages (due to "require $module")
    -help          brief help message
    -man           full documentation

=head1 OPTIONS

=over 4

=item B<-verbose>

Version is determined by doing a C<require> on runtime.
In case, the statement fails, error messages are shown.

=item B<-quiet>

Version is determined by doing a C<require> on runtime.
In case, the statement fails, error messages are silently hidden.
This is the default. A failure during C<require> will
result 'unknown' as version.

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

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
