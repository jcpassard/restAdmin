#!/usr/bin/perl

package Logger::Module;

use strict;
use warnings;

use base 'Module';

use Dancer(':syntax');
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

    $_sb->addListeners({
        'logger-add'  => sub {
            my $source = shift;
            my $msg = shift;
            $self->writeLog($source, $msg);

        },
    });

}

sub writeLog
{
    my $self = shift;
    my $source = shift;
    my $log = shift;

    my $time = localtime();
    my $logFile = setting('logPath') . "/$source.log";
    my $LOG;

    open($LOG, '>>', $logFile) || die "can't open $logFile: $!";;
    print $LOG "$time $source $log\n";
    close($LOG);
}

1;