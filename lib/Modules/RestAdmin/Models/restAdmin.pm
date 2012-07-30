#!/usr/bin/perl
package RestAdmin::Models::RestAdmin;

use strict;
use warnings;

use Data::Dumper;

sub userList
{
    my @l = user_list();
    return \@l;
}

sub getUser
{
    my $username = shift;;

    my %u = get_user($username);
    $u{memberof} = user_groups($username);

    return \%u;
}

sub getGroup
{
    my $group = shift;

    my %g = get_group($group);

    my $users = userList();
    my @members = grep { $g{gid} == getUser($_)->{gid} } @$users;
    foreach my $member ( @members ) {
        unless ( " $g{members} " =~ / $member / ) {
            $g{members} .= " $member";
        }
    }

    foreach my $user ( @$users ) {

    }

    return \%g;
}

1;