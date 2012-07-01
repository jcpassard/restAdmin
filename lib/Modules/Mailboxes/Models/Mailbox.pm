#!/usr/bin/perl

package Mailboxes::Models::Mailbox;

use strict;
use warnings;

use Data::Dumper;

use Rex;
use Rex::Config;
use Rex::Commands::Fs;

=head1 NAME

Model::Mailbox

=head1 DESCRIPTION

vo2rest model for Mailbox

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 connect

=cut

sub _isMailbox
{
    my $path = shift;

    if ( is_dir($path) &&  is_dir("$path/Maildir") ) {
        return 1;
    }
    return 0;
}

sub list
{
    my $path = shift;
    my @dirList = ls $path;
    my $mailboxes = [];

print STDERR Dumper(\@dirList), "\n";

    foreach my $dir ( @dirList ) {
        push @$mailboxes, $dir if _isMailbox("$path/$dir");
    }

    return $mailboxes;
}

sub size
{
    my $path = shift;

    return unless _isMailbox($path);
    my $info = du $path;

    return $info;
}

1;
