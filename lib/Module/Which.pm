package Module::Which;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
#our %EXPORT_TAGS = ( 'all' => [ qw() ] );
#our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw(which);

our $VERSION = '0.02_02';
eval $VERSION;

#print "ENTERING Module::Which\n";

#use Module::Find;
use Module::Which::List qw(list_pm_files);
use Data::Hash::Transform qw(hash_em);

#sub pm_require {
#    my $pm = shift;
#    my $verbose = shift;
#    eval "require $pm";
#    if ($@) { # error
#        warn "'require $pm' failed: $@" if $verbose;
#        return (0, $@);
#    }
#    return 1
#}

#sub pm_version {
#    my $pm = shift;
#    no strict 'refs';
#    return ${"${pm}::VERSION"};
#}

use ExtUtils::MakeMaker;

=begin private

=item B<pm_version>

  $v = pm_version($pm);

Parses a PM file and return what it thinks is $VERSION
in this file. (Actually implemented with 
C<use ExtUtils::MakeMaker; MM->parse_version($file)>.)
C<$pm> is the filename (eg., F<lib/Data/Dumper.pm>).

=end private

=cut
sub pm_version {
    my $pm = shift;
    my $v;
    eval { $v = MM->parse_version($pm); };
    return $@ ? undef : $v;
}

sub pm_info {
    my $pm = shift; # --- { pm: (pm), path: (path), base: (base), }
    my $options = shift;

    my $version = pm_version($pm->{path});

    return { 
        version => $version, 
        pm => $pm->{pm}, 
        path => $pm->{path}, 
        base => $pm->{base}  
    };
}

#sub is_wildcard {
#    return shift =~ /::\*$/;
#}

#sub expand_wildcard {
#    my $wildcard = shift;
#    $wildcard =~ s/::\*$//;
#    return findallmod $wildcard;
#}

# turns an array of hashes to a hash of hashes
sub hashify (\@$) {
    my ($ary, $opt_meth) = @_;
    our %meth = ( 'HASH' => 'f', 'HASH(FIRST)' => 'f', 'HASH(MULTI)' => 'm', 'HASH(LIST)' => 'a' );
    my $meth = $meth{$opt_meth}
        or die "hash strategy '$opt_meth' unknown";
    return hash_em($ary, 'pm', $meth);
}


# which(@pm)
# which(@pm, $options) where $options is a hash ref
sub which {
    my $options = {};
    $options = pop @_ if ref $_[-1];
    $options->{return} = 'ARRAY' unless $options->{return};

    my @pm = @_;

    my @info;
    for my $pm (@pm) {

        #push @info, pm_info($_, $options) for list_pm_files($pm, recurse => 1);

        my @pm_files = list_pm_files($pm, recurse => 1);
        if (@pm_files) {
            push @info, pm_info($_, $options) for @pm_files;
        } else {
            push @info, { pm => $pm };
        }

        #if (is_wildcard($pm)) {
        #    push @info, pm_info($_, $options) for expand_wildcard($pm);
        #} else {
        #    push @info, pm_info($pm, $options);
        #}
    }
    return \@info if $options->{return} eq 'ARRAY';

    return hashify(@info, $options->{return});
}

1;

__END__

=head1 NAME

Module::Which - Finds out which version of Perl modules are installed

=head1 SYNOPSIS

  use Module::Which;
  my $info = which('Module::Which', 'YAML', 'XML::', 'DBI', 'DBD::');
  while (my ($mod, $info) = each %$info) {
      print "$mod: $info->{version}\n"; 
  }

=head1 DESCRIPTION

C<Module::Which> is the basis of the script C<which_pm> intented
to show which version of a Perl module is installed (if it is there at all).

Modules are searched by name (like 'YAML') or by subcategories
('DBD::' means all modules under the DBD subdirectories of
your Perl installation, matching both 'DBD::Oracle' and 'DBD::ODBC::Changes').

This module is very simple and most won't need it.
But it has been instructive for the author to see how many broken modules
one can find under your Perl installation (some which don't accept
even a 'require' statement), modules with no version number and
documentation files (named '.pm') which do not return a true value.

=for comment
To find out modules under subcategories, L<Module::Find> by Christian
Renz was used.

Well, all that said, this module is no more than automating:

  perl -MInteresting::Module -e 'print $Interesting::Module::VERSION'

or better the one-liner

  perl -e '$pm = shift; eval "require $pm"; print ${"${pm}::VERSION"}' DBI

=over 4

=item B<which>

  my $info = which(@pm)
  my $info = which(@pm, { return => 'HASH', verbose => 1 }

Returns an array ref with information about the modules specified 
(by name or '::*' patterns). This information is a hash ref which
actually contains:

   pm: (the name of the Perl module)
   version: (the installed version)

The version is the one found by accessing the scalar variable C<$VERSION> 
of the package, after a I<require> statement.
If the module was not found, 'version' is C<undef>. If the
module has no C<$VERSION>, 'version' is C<'undef'> (the string).
If the 'require' statement failed, 'version' is 'unknown'.

A hash ref of options can be given as the last argument.
The option C<return> can take one of the values: 'ARRAY', 'HASH',
'HASH(FIRST)', 'HASH(MULTI)', 'HASH(LIST)'.
'ARRAY' is the default and means to return an array ref.
'HASH' forces the return of a hash ref where the module name
is used as key. 

The different strategies for returning a hash are different 
only if the same module is found twice or more times
in the current search path. 'HASH' which is the same as 
'HASH(FIRST)' only considers the first occurrence.
'HASH(MULTI)' will store multiple values in an array ref
(if needed). The problem with MULTI is that sometimes
you get a hash ref and sometimes an array ref of hash refs.
If 'HASH(LIST)' is used, an array ref will be stored
always, even if there is only one occurrence.

The option C<verbose> can be set to turn on and off
warnings on requiring the sought modules.

=back

=head2 EXPORT

C<which> is exported by default.

=head1 SEE ALSO

L<Module::Find> was my friend to implement this module as a breeze.
But I have found some itches and wrote my own L<Module::Which::List>
based on this and L<Module::List> by Andrew Main. 

After releasing it into CPAN, I found

    Module::InstalledVersion
    Module::Info
    Module::List
    Module::Locate

Module::InstalledVersion has a different approach (it does not run 
the modules to find
out their versions, but extract them via regexes) and does not
has a command-line interface which was the main thrust of this
distribution. I have been studying the others too.

=head1 BUGS

Known bugs:

=over 4

=item *

When a module is found twice or more in the library path,
the version is the one of the first file.

=back

Please report bugs via CPAN RT L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Which>.

=head1 AUTHOR

Adriano R. Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Adriano R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
