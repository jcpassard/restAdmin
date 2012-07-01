#!/usr/bin/perl

package Mailboxes::Module;

use strict;
use warnings;

use base 'Module';

use Dancer(':syntax');

use Mailboxes::Controllers::Mailboxes;

use Data::Dumper;

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

    $self->{controller} = Mailboxes::Controllers::Mailboxes->new({ module => $self });
    $self->{controller}->initController();

}

1;