package Module::Downgrade;

use 5.005;
use strict;
#use warnings unless $] < 5.006;

require Exporter;

#no ours
use vars qw(@ISA @EXPORT $VERSION);
@ISA = qw(Exporter);
@EXPORT = qw(downgrade);

$VERSION = '0.00_02';

# make substitutions to Perl 5.6.1 code to make it (hopefully)
# work with Perl 5.005
sub s_pm {
	my $f = shift;
	open SOURCE, "<$f"
		or die "can't open '$f': $!";
	open OUT, ">$f.out"
		or die "can't open '$f.out': $!";
	while (<SOURCE>) {
		if (/^\s*#/) {
			print OUT; next;
		}
		if (s/use\s+5.006/#$&/) {
			print OUT;
			print OUT "use 5.005;\n";
			next;
		}
		if (s/use\s+warnings/#$&/) {
			print OUT;
			next;
		}
		if (s/our\s+([\$@%]\w+)(.*?);/#$&/) {
			print OUT;
			print OUT "use vars qw($1);\n";
			print OUT "$1$2;\n";
			next;
		}
		print OUT;
	}
	close OUT;
	close SOURCE;
	rename $f, "$f.orig"
		or die "can't rename '$f' to '$f.orig': $!";
	rename "$f.out", $f
		or die "can't rename '$f.out' to '$f': $!";

}

sub downgrade {
	for my $pm (@_) {
		s_pm($pm);
	}
}

1;
__END__

=head1 NAME

Module::Downgrade - Tries to turn Perl 5.6 code to Perl 5.005

=head1 SYNOPSIS

  use Module::Downgrade;
  downgrade('Mod.pm', 'script.pl');

=head1 DESCRIPTION

C<Module::Downgrade> is a joke for trying to be compatible.
It depends entirely on the generosity of the code being translated.

Don't use it. It is not ready for general use.

=back

=head2 EXPORT

C<downgrade> is exported by default.

=head1 SEE ALSO

Please report bugs via CPAN RT L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Which>.

=head1 AUTHOR

Adriano R. Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Adriano R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
