#!/usr/bin/perl

package Vh::Module;

use strict;
use warnings;

use base 'Module';

use Dancer(':syntax');

use Vh::Controllers::Vh;

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

    $self->{controller} = Vh::Controllers::Vh->new({ module => $self });
    $self->{controller}->initController();

    $_sb->addListeners({
        'vh-listdomains'  => sub {
            my $source = shift;
            my $msg = shift;

            my $cb = $msg->{callback};

            my $domains = $self->{controller}->listDomains($msg->{group} || undef);
            &$cb($domains);
        },
        'vh-vminfos'  => sub {
            my $source = shift;
            my $msg = shift;

            my $cb = $msg->{callback};

            my $vmInfos = $self->{controller}->vmInfos(
                $msg->{group} || undef,
                $msg->{vmName});
            &$cb($vmInfos);
        },
    });

}

sub newEvent
{
    my $self  = shift;
    my ($vm, $crit, $action, $result, $text) = @_;

    my $msg = "$vm $crit $action $result $text";

    $self->SUPER::logEvent($msg);
}
1;