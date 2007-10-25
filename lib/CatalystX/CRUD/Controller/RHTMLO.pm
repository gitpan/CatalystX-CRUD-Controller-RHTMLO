package CatalystX::CRUD::Controller::RHTMLO;
use strict;
use base qw( CatalystX::CRUD::Controller );
use NEXT;

our $VERSION = '0.04';

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

=head2 form( I<context> )

Returns an instance of config->{form_class}. A single form object is instantiated and
cached in the controller object. The form's clear() method is called before returning.
In addition the I<context> object is stashed via the forms's app() method.

=cut

sub form {
    my ($self, $c) = @_;
    $self->{_form} ||= $self->form_class->new;
    $self->{_form}->clear;
    $self->{_form}->app($c);
    return $self->{_form};
}


=head2 form_to_object( I<context> )

Overrides base method.

=cut

sub form_to_object {
    my ( $self, $c ) = @_;

    my $form      = $c->stash->{form};
    my $obj       = $c->stash->{object};
    my $obj_meth  = $self->init_object;
    my $form_meth = $self->init_form;
    my $id        = $c->stash->{object_id};
    my $pk        = $self->primary_key;

    # initialize the form with the object's values
    $form->$form_meth( $obj->delegate );

    # set param values from request
    $form->params( $self->param_hash($c) );

    # id always comes from url but not necessarily from form
    $form->param( $pk, $id );

    # override object's values with those from params
    $form->init_fields();

    # return if there was a problem with any param values
    unless ( $form->validate() ) {
        $c->stash->{error} = $form->error;    # NOT throw_error()
        $c->stash->{template} ||= $self->default_template;    # MUST specify
        return 0;
    }

    # re-set object's values from the now-valid form
    $form->$obj_meth( $obj->delegate );

  # set id explicitly since there's some bug with param() setting it in save()
    $obj->$pk( $c->stash->{object_id} );

    # let serial column work its magic
    $obj->$pk(undef)
        if ( !$obj->$pk or $obj->$pk == 0 or $c->stash->{object_id} == 0 );

    return $obj;
}

=head2 do_search( I<context>, I<arg> )

Makes form values sticky then calls the base do_search() method with NEXT.

=cut

sub do_search {
    my ( $self, $c, @arg ) = @_;

    # make form sticky
    $c->stash->{form} ||= $self->form;
    $c->stash->{form}->params( $c->req->params );
    $c->stash->{form}->init_fields();

    return $self->NEXT::do_search( $c, @arg );
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

