#!/usr/bin/perl
package WebInterface::Models::Vh;

use strict;
use warnings;

use Data::Dumper;

sub listDomains
{
    my $group  = shift;
    my $module = shift;

    my $sb = $module->getSandbox();
    my $domains;

    $sb->notify({
        type => 'vh-listdomains',
        source => $module,
        msg  => {
            group    => $group,
            callback => sub {
                $domains = shift;
            }
        }
    });
    return $domains;
}

sub vmInfos
{
    my $group  = shift;
    my $module = shift;
    my $vmName = shift;
    my $sb = $module->getSandbox();
    my $vm;

    $sb->notify({
        type => 'vh-vminfos',
        source => $module,
        msg  => {
            group    => $group,
            vmName   => $vmName,
            callback => sub {
                $vm = shift;
            }
        }
    });
    return $vm;
}

1;