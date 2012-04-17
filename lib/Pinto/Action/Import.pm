# ABSTRACT: Import a package (and its prerequisites) into the local repository

package Pinto::Action::Import;

use Moose;

use version;

use namespace::autoclean;

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

extends qw( Pinto::Action );

#------------------------------------------------------------------------------

with qw( Pinto::Role::PackageImporter
         Pinto::Role::Interface::Action::Import );

#------------------------------------------------------------------------------

sub execute {
    my ($self) = @_;

    my ($dist, $imported_flag) = $self->find_or_import( $self->target );
    return 0 if not $dist;

    $self->add_message( Pinto::Util::imported_dist_message($dist) )
        if $imported_flag;

    unless ( $self->norecurse() ) {
        my $archive = $dist->archive( $self->repos->root_dir() );
        my @imported_prereqs = $self->import_prerequisites($archive);
        $self->add_message( Pinto::Util::imported_prereq_dist_message( $_ ) ) for @imported_prereqs;
        $imported_flag += @imported_prereqs;
    }

    return $imported_flag;
}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------

1;

__END__
