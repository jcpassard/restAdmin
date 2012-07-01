package Vh::Controllers::Vh;
use Dancer ':syntax';

use strict;
use warnings;

use Vh::Models::Libvirt;

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
                          ref($params->{module}) eq 'Vh::Module'
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

sub _getGroup
{
    my $self = shift;
    my $name = shift;

    my $group = '-';
    my $short = $name;
    if ( $name =~ m/^([^_]*)_(.*)$/ ) {
            $group = $1;
            $short = $2;
    }

    return $group, $short;
}

sub _checkAccess
{
    my $self = shift;
    my $resource = shift;

    my $access = 0;
    $_sb->notify({
        type => 'check-access',
        source => $self,
        msg  => {
            resource => $resource,
            callback => sub {
                $access = shift;
            }
        }
    });
    return $access;
}

sub listDomains
{
    my $self = shift;
    my $group = shift;

    my $vms = Vh::Models::Libvirt::listDomains();

    my $ret = [];

    foreach my $vm ( @$vms ) {
        my $infos = $self->vmInfos($vm->{name});
        push @$ret, $infos if ( $infos );
    }
    return $ret;
};

sub vmInfos
{
    my $self = shift;
    my $vmName = shift;

    my $vm = {};
    ($vm->{group}, $vm->{short}) = $self->_getGroup($vmName);
    return unless $self->_checkAccess($vm->{group});
    $vm->{details} = Vh::Models::Libvirt::detailsVM($vmName);
    $vm->{id} = $vm->{details}{infos}{id};
    $vm->{name} = $vm->{details}{infos}{name};

    return $vm
};

sub startStopVM
{
    my $self = shift;
    my $action = shift;
    my $vmName = shift;

    my $vm = {};
    ($vm->{group}, $vm->{short}) = $self->_getGroup($vmName);
    return unless $self->_checkAccess($vm->{group});
    if ( $action eq 'start' ) {
        $_module->newEvent($vmName, 0, $action, 'prepare to start', '');
        Vh::Models::Libvirt::startVM($vmName);
        $_module->newEvent($vmName, 0, $action, 'started', '');
    }

    if ( $action eq 'stop' ) {
        $_module->newEvent($vmName, 0, $action, 'prepare to halt', '');
        Vh::Models::Libvirt::destroyVM($vmName);
        $_module->newEvent($vmName, 0, $action, 'stopped', '');
    }

    return ;
};

sub initController
{
    my $self = shift;

    get '/rest/vh/vms' => sub {
        return $self->listDomains()
    };
    get '/rest/vh/:vmName' => sub {
        return $self->vmInfos(params->{vmName});
    };
    post '/rest/vh/:vmName' => sub {
        $self->startStopVM(
            params->{action},
            params->{vmName}
        );
    };
}

1;
