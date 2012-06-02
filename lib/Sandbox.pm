package Sandbox;

use strict;
use warnings;

use Data::Dumper;


=head1 NAME

Sandbox

=head1 DESCRIPTION

Sandbox assure the communication between modules and Core
Each module has his own sandbox

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 module private members

=cut

my $CORE = undef;

=head2 getUsers

return the list of Users

=cut

sub new
{
    my $proto  = shift;
    my $params = shift;

    my $class = ref($proto) || $proto;
    my $self = {};


    return unless ( $params->{CORE} &&
                    $params->{module} &&
                    ref($params->{CORE}) eq 'Core'
                   );

    $self->{CORE} = $params->{CORE};
    $self->{module} = $params->{module};

    bless($self, $class);

    return $self;
}

sub CORE
{
    my $self = shift;
    return $self->{CORE};
}

sub module
{
    my $self = shift;
    return $self->{module};
}

sub addListeners
{
    my $self = shift;
    my $listeners = shift;

    return unless ( ref($listeners) eq 'HASH' );

    $self->CORE()->registerListeners($self->module(), $listeners);
}

sub notify
{
    my $self = shift;
    my $event = shift;

    return unless ref($event) eq 'HASH';
    return unless $event->{type};

    $self->CORE()->triggerEvent($event);
}

1;
