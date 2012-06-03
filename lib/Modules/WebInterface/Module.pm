#!/usr/bin/perl

package WebInterface::Module;

use strict;
use warnings;

use base 'Module';

use Data::Dumper;

use WebInterface::Controllers::WebInterface;

my $_instance;
my $_sb;

sub new
{
    unless ( $_instance ) {
        my $proto  = shift;
        my $params = shift;

        my $class = ref($proto) || $proto;

        $_instance = $class->SUPER::new($params);
        $_sb = $_instance->SUPER::getSandbox();
    }
    return $_instance;
}

sub init
{
    my $self = shift;

    $self->SUPER::init();
    $self->{controller} = WebInterface::Controllers::WebInterface->new({ module => $self });
    $self->{controller}->initController();
}

1;