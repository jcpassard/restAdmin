#!/usr/bin/perl

package BackupPC::Module;

use strict;
use warnings;

use base 'Module';

use Dancer(':syntax');

use BackupPC::Controllers::BackupPC;

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

    $self->{controller} = BackupPC::Controllers::BackupPC->new({ module => $self });
    $self->{controller}->initController();

}

1;