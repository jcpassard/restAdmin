#!/usr/bin/perl

package WebInterface::Module;

use strict;
use warnings;

use base 'Module';

use Data::Dumper;

use WebInterface::Controllers::WebInterface;

my $_sb = undef;

my $eventTemplate = {};

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
    $self->{controller} = WebInterface::Controllers::WebInterface->new({ module => $self });
    $self->{controller}->initController();
}

1;