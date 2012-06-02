#!/usr/bin/perl
package Module;

use strict;
use warnings;
use Dancer ':syntax';

use Data::Dumper;



our $_sb = undef;
our $eventTemplate = {};

sub new
{
    my $proto  = shift;
    my $params = shift;

    my $class = ref($proto) || $proto;
    my $self = {};

    return undef unless (
            $params->{sandbox} &&
            ref($params->{sandbox}) eq 'Sandbox'
    );

    $_sb = $params->{sandbox};
    bless($self, $class);

    return $self;
}

sub install
{
    my $self = shift;
}


sub init
{
    my $self = shift;
}

sub getSandbox
{
    my $self = shift;
    return $_sb;
}

sub sendEvent
{
    my $self  = shift;
    my $event = shift;

    $_sb->notify({
        type => 'log-add-event',
        data => $event,
    });
}
1;