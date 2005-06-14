package Module::Which;

use 5.005;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
#our %EXPORT_TAGS = ( 'all' => [ qw() ] );
#our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw(which);

our $VERSION = '0.01';

use Module::Find;

our $VERBOSE = 1;

sub pm_version {
	my $pm = shift;
	no strict 'refs';
	return ${"${pm}::VERSION"};
}

sub pm_info {
	my $pm = shift;
	eval "require $pm";
	my $version;
	if ($@) {
		if ($@ =~ /^Can't locate/) {
			$version = undef 
		} else {
			warn "'require $pm' failed: $@" if $VERBOSE;
			$version = -1;
		}
	} else {
		$version = pm_version($pm) || 'undef';
	}
	return { version => $version  };
}

sub is_wildcard {
	return shift =~ /::\*$/;
}

sub expand_wildcard {
	my $wildcard = shift;
	$wildcard =~ s/::\*$//;
	return findallmod $wildcard;
}

sub which {
	my @pm = @_;
	my %info;
	for my $pm (@pm) {
		if (is_wildcard($pm)) {
			$info{$_} = pm_info($_) for expand_wildcard($pm);
		} else {
			$info{$pm} = pm_info($pm);
		}
	}
	return \%info;
}

1;
__END__

=head1 NAME

Module::Which - Finds out which version of Perl modules are installed

=head1 SYNOPSIS

  use Module::Which;
  my $info = which('Module::Which', 'YAML', 'XML::*', 'DBI', 'DBD::*');
  while (my ($mod, $info) = each %$info) {
	  print "$mod: $info->{version}\n"; 
  }

=head1 DESCRIPTION

C<Module::Which> is the basis of the script C<which_pm> intented
to show which version of a Perl module is installed (if it is there at all).

Modules are searched by name (like 'YAML') or by subcategories
('DBD::*' means all modules under the DBD subdirectories of
your Perl installation, matching both 'DBD::Oracle' and 'DBD::ODBC::Changes').

This module is very simple and most won't need it.
But it has been instructive for the author to see how many broken modules
one can find under your Perl installation (some which don't accept
even a 'require' statement), modules with no version number and
documentation files (named '.pm') which do not return a true value.

To find out modules under subcategories, L<Module::Find> by Christian
Renz was used.

Well, all that said, this module is no more than automating:

  perl -MModule::I::Want::To::Know::About -e "print $Module::I::Want::To::Know::About::VERSION"

or better the one-liner

  perl -e '$pm = shift; eval "require $pm"; print ${"${pm}::VERSION"}' DBI

=over 4

=item B<which>

  my $info = which(@pm)

Returns a hash ref with the modules specified (by name or '::*' patterns)
as keys and a hash ref as value (which actually contains only the pair C<version => $v>).
The version is the one found by accessing the scalar variable C<$VERSION> 
of the package, after a I<require> statement.

=back

=head2 EXPORT

C<which> is exported by default.

=head1 SEE ALSO

L<Module::Find> was my friend to implement this module as a breeze.

Please report bugs via CPAN RT L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Which>.

=head1 AUTHOR

Adriano R. Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Adriano R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
