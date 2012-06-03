#!/usr/bin/perl
package Module;

use strict;
use warnings;

use Data::Dumper;

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

    $self->{_sb} = $params->{sandbox};
    return bless($self, $class);
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
    return $self->{_sb};
}

sub logEvent
{
    my $self  = shift;
    my $event = shift;

    my ($source, undef) = caller();
    $source =~ s/^([^:]*)::.*$/$1/;

    $self->getSandbox()->notify({
        type   => 'logger-add',
        source => $source,
        msg => $event,
    });
}
1;