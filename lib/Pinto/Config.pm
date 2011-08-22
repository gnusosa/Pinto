package Pinto::Config;

# ABSTRACT: Internal configuration for a Pinto repository

use Moose;

use MooseX::Configuration;

use MooseX::Types::Moose qw(Str Bool Int);
use Pinto::Types qw(URI Dir);

use namespace::autoclean;

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------
# Moose attributes

has repos   => (
    is        => 'ro',
    isa       => Dir,
    required  => 1,
    coerce    => 1,
);


has source  => (
    is        => 'ro',
    isa       => URI,
    key       => 'source',
    default   => 'http://cpan.perl.org',
    coerce    => 1,
);


has nocleanup => (
    is        => 'ro',
    isa       => Bool,
    key       => 'nocleanup',
    default   => 0,
);


has noinit   => (
    is       => 'ro',
    isa      => Bool,
    key      => 'noinit',
    default  => 0,
);


has store => (
    is        => 'ro',
    isa       => Str,
    key       => 'store',
    default   => 'Pinto::Store',
);


has svn_trunk => (
    is        => 'ro',
    isa       => Str,
    key       => 'trunk',
    section   => 'Pinto::Store::VCS::Svn',
);


has svn_tag => (
    is        => 'ro',
    isa       => Str,
    key       => 'tag',
    section   => 'Pinto::Store::VCS::Svn',
);

#------------------------------------------------------------------------------
# Builders

sub _build_config_file {
    my ($self) = @_;

    my $repos = $self->repos();

    my $config_file = Path::Class::file($repos, qw(config pinto.ini) );

    return -e $config_file ? $config_file : ();
}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------

1;

__END__

=head1 DESCRIPTION

This is a private module for internal use only.  There is nothing for
you to see here (yet).

=cut