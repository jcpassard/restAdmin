package BackupPC::Controllers::BackupPC;
use Dancer ':syntax';

use strict;
use warnings;

use BackupPC::Models::BackupPC;

use Data::Dumper;

my $_module = undef;
my $_sb     = undef;
my $_model  = undef;

my $init = 0;

sub new
{
    my $proto  = shift;
    my $params = shift;

    my $class = ref($proto) || $proto;
    my $self = {};

    return undef unless ( $params->{module} &&
                          ref($params->{module}) eq 'BackupPC::Module'
                         );
    $_module = $params->{module};
    $_sb     = $_module->getSandbox();

    bless($self, $class);

    return $self;
}

sub getSandbox
{
    my $self = shift;
    return $_sb;
}

sub hostStatus
{
    my $self = shift;
    my $path = shift;

    return BackupPC::Models::BackupPC::hostStatus($path);
}

sub list
{
    my $self = shift;
    BackupPC::Models::BackupPC::connect();
    return BackupPC::Models::BackupPC::list();
}

sub list
{
    my $self = shift;
    my $host = shift;
    BackupPC::Models::BackupPC::connect();
    return BackupPC::Models::BackupPC::hostStatus($host);
}


sub initController
{
    my $self = shift;

    get '/rest/backuppc' => sub {
        return { 'hosts' => $self->list() };
    };

    get '/rest/backuppc/:host' => sub {
        my $host = params->{host};
        return $self->hostStatus($host) };
}

1;
