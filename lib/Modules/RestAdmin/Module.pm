#!/usr/bin/perl

package RestAdmin::Module;

use strict;
use warnings;

use base 'Module';

use Dancer(':syntax');

use RestAdmin::Controllers::RestAdmin;

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

    $self->{controller} = RestAdmin::Controllers::RestAdmin->new({ module => $self });
    $self->{controller}->initController();

    $_sb->addListeners({
        'restadmin-msg'  => sub {
            my $source = shift;
            my $msg = shift;

            my $cb = $msg->{callback};

            #my $domains = $self->{controller}->listDomains($msg->{group} || undef);
            &$cb(1);
        },
    });
}



1;