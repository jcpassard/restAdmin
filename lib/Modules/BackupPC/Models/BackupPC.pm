#!/usr/bin/perl

package BackupPC::Models::BackupPC;

use strict;
use warnings;

use Data::Dumper;


=head1 NAME

Model::BackupPC

=head1 DESCRIPTION

vo2rest model for BackupPC

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub userBackupPC
{
    $> = 56;
    $) = 56
}

sub effectiveUser
{
    $> = $<;
    $) = $(;
}

my $server;
userBackupPC();

use lib '/opt/BackupPC/lib';
use BackupPC::Lib;


if (!($server = BackupPC::Lib->new))
{
        print STDERR "BACKUPPC CRITICAL - Couldn't connect to BackupPC\n";
}
effectiveUser();

=head2 connect

=cut
sub connect
{
    return 0 unless ( $server );

#    userBackupPC();
    my %Conf = $server->Conf();
#    $server->ChildInit();

    my $err = $server->ServerConnect($Conf{ServerHost}, $Conf{ServerPort});
#    effectiveUser();

    if ($err)
    {
        print STDERR ("BACKUPPC UNKNOWN - Can't connect to server ($err)\n");
        return 0;
    }
    return 1;
}


sub list
{
    return unless ( $server );
#foreach my $host ( GetUserHosts(1) ) {
    #userBackupPC();
    my $status_raw = $server->ServerMesg('status hosts');
    #effectiveUser();
    my %Status;
    eval $status_raw ;
    return [ grep(!/^ [^ ]+ $/, keys %Status) ];
}

sub hostStatus
{
    my $host = shift;

    return unless $server && $host;

    my @host_status = $server->BackupInfoRead($host);

=pod
    my($fullDur, $incrCnt, $incrAge, $fullSize, $fullRate, $reasonHilite,
        $lastAge, $tempState, $tempReason, $lastXferErrors);
    my($shortErr);
    my @Backups = $server->BackupInfoRead($host);
    my $fullCnt = $incrCnt = 0;
    my $fullAge = $incrAge = $lastAge = -1;

    $bpc->ConfigRead($host);
    %Conf = $bpc->Conf();

    next if ( $Conf{XferMethod} eq "archive" );

    for ( my $i = 0 ; $i < @Backups ; $i++ ) {
        if ( $Backups[$i]{type} eq "full" ) {
            $fullCnt++;
            if ( $fullAge < 0 || $Backups[$i]{startTime} > $fullAge ) {
                $fullAge  = $Backups[$i]{startTime};
                $fullSize = $Backups[$i]{size} / (1024 * 1024);
                $fullDur  = $Backups[$i]{endTime} - $Backups[$i]{startTime};
            }
            $fullSizeTot += $Backups[$i]{size} / (1024 * 1024);
        } else {
            $incrCnt++;
            if ( $incrAge < 0 || $Backups[$i]{startTime} > $incrAge ) {
                $incrAge = $Backups[$i]{startTime};
            }
            $incrSizeTot += $Backups[$i]{size} / (1024 * 1024);
        }
    }

    if ( $fullAge > $incrAge && $fullAge >= 0 )  {
        $lastAge = $fullAge;
    } else {
        $lastAge = $incrAge;
    }
    if ( $lastAge < 0 ) {
            $lastAge = "";
    } else {
        $lastAge = sprintf("%.1f", (time - $lastAge) / (24 * 3600));
    }
    if ( $fullAge < 0 ) {
        $fullAge = "";
        $fullRate = "";
    } else {
        $fullAge = sprintf("%.1f", (time - $fullAge) / (24 * 3600));
        $fullRate = sprintf("%.2f",
            $fullSize / ($fullDur <= 0 ? 1 : $fullDur));
    }
    if ( $incrAge < 0 ) {
        $incrAge = "";
    } else {
        $incrAge = sprintf("%.1f", (time - $incrAge) / (24 * 3600));
    }
    $fullTot += $fullCnt;
    $incrTot += $incrCnt;
    $fullSize = sprintf("%.2f", $fullSize / 1000);
    $incrAge = "&nbsp;" if ( $incrAge eq "" );
    $lastXferErrors = $Backups[@Backups-1]{xferErrs} if ( @Backups );
    $reasonHilite = $Conf{CgiStatusHilightColor}{$Status{$host}{reason}}
        || $Conf{CgiStatusHilightColor}{$Status{$host}{state}};
    if ( $Conf{BackupsDisable} == 1 ) {
        if ( $Status{$host}{state} ne "Status_backup_in_progress"
            && $Status{$host}{state} ne "Status_restore_in_progress" ) {
            $reasonHilite = $Conf{CgiStatusHilightColor}{Disabled_OnlyManualBackups};
            $tempState = "Disabled_OnlyManualBackups";
            $tempReason = "";
        } else {
            $tempState = $Status{$host}{state};
            $tempReason = $Status{$host}{reason};
        }
    } elsif ($Conf{BackupsDisable} == 2 ) {
        $reasonHilite = $Conf{CgiStatusHilightColor}{Disabled_AllBackupsDisabled};
        $tempState = "Disabled_AllBackupsDisabled";
        $tempReason = "";
    } else {
        $tempState = $Status{$host}{state};
        $tempReason = $Status{$host}{reason};
    }
    $reasonHilite = " bgcolor=\"$reasonHilite\"" if ( $reasonHilite ne "" );
    if ( $tempState ne "Status_backup_in_progress"
        && $tempState ne "Status_restore_in_progress"
        && $Conf{BackupsDisable} == 0
        && $Status{$host}{error} ne "" ) {
        ($shortErr = $Status{$host}{error}) =~ s/(.{48}).*/$1.../;
        $shortErr = " ($shortErr)";
    }

    if ( @Backups == 0 ) {
        $hostCntNone++;
        $strNone .= $str;
    } else {
        $hostCntGood++;
        $strGood .= $str;
    }
    #$fullSizeTot = sprintf("%.2f", $fullSizeTot / 1000);
    #$incrSizeTot = sprintf("%.2f", $incrSizeTot / 1000);
   # my $now      = timeStamp2(time);
   # my $DUlastTime   = timeStamp2($Info{DUlastValueTime});
    #my $DUmaxTime    = timeStamp2($Info{DUDailyMaxTime});
=cut

    return \@host_status;
}

1;
