#!/usr/bin/perl

package Vh::Models::Libvirt;

use strict;
use warnings;

use Data::Dumper;

use Rex;
use Rex::Config;
use Rex::Commands::Virtualization;

Rex::Config->set(virtualization => "LibVirt");

=head1 NAME

Model::Libvirt

=head1 DESCRIPTION

vo2rest model for Libvirt

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 connect

=cut

sub listDomains
{
    my $prefixes = shift;

    my $domains = vm list => "all";

    return $domains;
}

=head2 detailsVM

detailsVM

=cut

sub detailsVM
{
    my $vmName = shift;
    my $prefixes = shift;

    my $details = {
        infos      => Vh::Models::Libvirt::getInfosVM($vmName),
        devices    => Vh::Models::Libvirt::getDisks($vmName),
        interfaces => Vh::Models::Libvirt::getInterfaces($vmName),
        #display    => Vh::Models::RexLibvirt::getDisplay($vmName),
    };

    return $details;
}

=head2 startVM

Start VM

=cut

sub startVM
{
    my $vmName = shift;
    vm start => $vmName;

}

=head2 destroyVM

Destroy VM

=cut

sub destroyVM
{
    my $vmName   = shift;
    vm destroy => $vmName;
}

=head2 shutdownVM

shutDown VM

=cut

sub shutdownVM
{
    my $vmName = shift;
    vm shutdown => $vmName;
}

=head2 getInfosVM

getInfos VM

=cut

sub getInfosVM
{
    my $vmName   = shift;

    my $tmp = vm info => "$vmName";
    my $infos = {};

    $infos->{name} = $tmp->{'Name'} if $tmp->{'Name'};
    $infos->{cpu} = $tmp->{'CPU(s)'} if $tmp->{'CPU(s)'};
    $infos->{id} = $tmp->{'Id'} if $tmp->{'Id'};
    $infos->{autostart} = $tmp->{'Autostart'} if $tmp->{'Autostart'};
    $infos->{state} = $tmp->{'State'} if $tmp->{'State'};
    $infos->{persistent} = $tmp->{'Persistent'} if $tmp->{'Persistent'};
    $infos->{managedSave} = $tmp->{'Managed save'} if $tmp->{'Managed save'};
    $infos->{uuid} = $tmp->{'UUID'} if $tmp->{'UUID'};
    $infos->{osType} = $tmp->{'OS Type'} if $tmp->{'OS Type'};
    $infos->{maxMemory} = $tmp->{'Max memory'} ? $tmp->{'Max memory'} : 0;
    $infos->{maxMemory} =~s/\s*kB//;
    $infos->{usedMemory} = $tmp->{'Used memory'} ? $tmp->{'Used memory'}: 0;
    $infos->{usedMemory} =~s/\s*kB//;

    return $infos;
}

=head2 getDisplay

getDisplay

=cut

sub getDisplay
{
    my $vmName   = shift;
    return vm vncdisplay => $vmName;
}

sub getDisks
{
    my $vmName = shift;

    my $devices = vm blklist => "$vmName", details => 1, unit => 1024*1024*1024;

    return $devices;
}

sub getInterfaces
{
    my $vmName = shift;

    my $devices = vm iflist => "$vmName";
    return $devices;
}


1;
