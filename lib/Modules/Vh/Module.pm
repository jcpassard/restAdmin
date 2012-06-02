#!/usr/bin/perl

package Vh::Module;

use strict;
use warnings;

use base 'Module';

use Vh::Controllers::Vh;

use Data::Dumper;

my $_sb = undef;

my $eventTemplate = {
    logName => 'Log_Vh',
    event   => {
        username    => { type=>'char', size=>'50', default=>''},
        source      => { type=>'char', size=>'50', default=>''},
        vm          => { type=>'char', size=>'50', default=>''},
        crit        => { type=>'int'},
        action      => { type=>'char', size=>'50', default=>''},
        result      => { type=>'char', size=>'50', default=>''},
        text        => { type=>'char', size=>'256', default=>''}
    }
};

sub new
{
    my $proto  = shift;
    my $params = shift;

    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new($params);
    $_sb = $self->getSandbox();
    return $self;
}

sub init
{
    my $self = shift;

    $self->SUPER::init();

    $self->{controller} = Vh::Controllers::Vh->new({ module => $self });
    $self->{controller}->initController();

    $_sb->addListeners({
        'vh-listdomains'  => sub {
            my $msg = shift;
            my $cb = $msg->{callback};

            my $domains = $self->{controller}->listDomains();
            &$cb($domains);
        },
    });

}

sub newEvent
{
    my $self  = shift;
    my ($vm, $crit, $action, $result, $text) = @_;

    my $e = { %$eventTemplate };
    $e->{event} = {
        username    => session('username') || '',
        source      => 'IP Par ex',
        vm          => $vm,
        crit        => $crit,
        action      => $action,
        result      => $result,
        text        => $text
    };

    $self->SUPER::sendEvent($e);
}
1;