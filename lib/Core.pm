package Core;

use strict;
use warnings;

use lib qw(lib /home/system/apache/Rex/lib lib/Modules);

use Dancer ':syntax';
use Sandbox;

use Data::Dumper;


=head1 NAME

Core

=head1 DESCRIPTION

Core manage creation, destruction, life of Modules

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 module private members

=cut

my $modules = {};

=head2 new

Instanciation

=cut

sub new
{
    my $proto  = shift;
    my $params = shift;

    my $class = ref($proto) || $proto;
    my $self = {};

    bless($self, $class);

    return $self;
}

sub _getModules
{
    my $self = shift;
    return $modules;
}

sub registerModule
{
    my $self = shift;
    my $module = shift;

    eval {
        my $modPath = $module;
        $modPath =~ s/::/\//g;
        require $modPath.'.pm';
        1;
    };
    print "Loading $module failed $@ \n" if $@;
    my $sandbox = Sandbox->new( { CORE => $self, module => $module } );

    if ( ! $self->_isRegistered($module) ) {
        my $newModule = $module->new( { sandbox => $sandbox });
        if ( $newModule ) {
            $modules->{$module} = {
                instance => $newModule,
                events   => {}
            };
            return 1;
        }
    }
    return undef;
}

sub _isRegistered
{
    my $self = shift;
    my $module = shift;

    return defined($modules->{$module});
}

sub _isInitialized
{
    my $self = shift;
    my $module = shift;

    return $self->_isRegistered($module) &&
           $modules->{$module}{instance} &&
           ref($modules->{$module}{instance}) eq $module;
}

sub _getModuleInstance
{
    my $self = shift;
    my $module = shift;

    if ( $self->_isRegistered($module) &&
         $modules->{$module}{instance} &&
         ref($modules->{$module}{instance}) eq $module ) {

        return $modules->{$module}{instance};
    }
    return undef;
}

sub _getModuleEvents
{
    my $self = shift;
    my $module = shift;

    if ( $self->_isInitialized($module) ) {
        return $modules->{$module}{events};
    }
    return undef;
}

sub initModule
{
    my $self = shift;
    my $module = shift;

    if ( my $instance = $self->_getModuleInstance($module) ) {
        $instance->init();
        return 1;
    }
    return undef;
}

sub installModule
{
    my $self = shift;
    my $module = shift;

    if ( my $instance = $self->_getModuleInstance($module) ) {
        $instance->install();
        return 1;
    }
    return undef;
}

sub registerListeners
{
    my $self = shift;
    my $module = shift;
    my $listeners = shift;

    return unless $self->_isRegistered($module) ;
    return unless ref($listeners) eq 'HASH' ;
    if ( my $events = $self->_getModuleEvents($module) ) {
        foreach my $event ( keys %$listeners ) {
            $events->{$event} = $listeners->{$event};
        }
        return 1;
    }
    return undef;
}

sub triggerEvent
{
    my $self = shift;
    my $event = shift;

    return unless ref($event) eq 'HASH';
    return unless $event->{type};

    foreach my $module ( keys %$modules ) {
        if ( my $events = $self->_getModuleEvents($module) ) {
            if ( my $cb = $events->{$event->{type}} ) {
                &$cb($event->{msg});
            }
        }
    }
}

1;
