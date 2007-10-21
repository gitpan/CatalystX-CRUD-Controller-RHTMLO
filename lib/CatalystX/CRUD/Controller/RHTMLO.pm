package CatalystX::CRUD::Controller::RHTMLO;
use strict;
use base qw( CatalystX::CRUD::Controller );
use NEXT;

our $VERSION = '0.02';

=head1 NAME

CatalystX::CRUD::Controller::RHTMLO - Rose::HTML::Objects CRUD controller

=head1 SYNOPSIS

 see CatalystX::CRUD::Controller

=head1 DESCRIPTION

This is an implementation of CatalystX::CRUD::Controller
for Rose::HTML::Objects. It supercedes Catalyst::Controller::Rose for
basic CRUD applications.

=cut

=head1 METHODS

The following methods are new or override base methods.

=cut

=head2 save_obj( I<context>, I<object> )

Overrides base save_obj() to set the stash() C<object_id> in the I<object>.
The primarly column will also be set to C<undef> if the C<object_id> is
undefined or zero.

=cut

sub save_obj {
    my ( $self, $c, $o ) = @_;

    my $pk = $self->primary_key;

  # set id explicitly since there's some bug with param() setting it in save()
    $o->$pk( $c->stash->{object_id} );

    # let serial column work its magic
    $o->$pk(undef)
        if ( !$o->$pk or $o->$pk == 0 or $c->stash->{object_id} == 0 );

    $self->NEXT::save_obj( $c, $o );
}

1;

__END__

=head1 AUTHOR

Peter Karman, C<< <karman at cpan dot org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-catalystx-crud-controller-rhtmlo at rt.cpan.org>, 
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CatalystX-CRUD-Controller-RHTMLO>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CatalystX::CRUD::Controller::RHTMLO

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CatalystX-CRUD-Controller-RHTMLO>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CatalystX-CRUD-Controller-RHTMLO>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CatalystX-CRUD-Controller-RHTMLO>

=item * Search CPAN

L<http://search.cpan.org/dist/CatalystX-CRUD-Controller-RHTMLO>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Peter Karman, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

