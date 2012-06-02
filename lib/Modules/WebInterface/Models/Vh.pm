#!/usr/bin/perl
package WebInterface::Models::Vh;

use strict;
use warnings;

use Data::Dumper;

sub listDomains
{
    my $module = shift;
    my $sb = $module->getSandbox();
    my $domains;

    $sb->notify({
        type => 'vh-listdomains',
        msg  => {
            callback => sub {
                $domains = shift;
            }
        }
    });
    return $domains;
}

1;