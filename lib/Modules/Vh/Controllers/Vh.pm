package Vh::Controllers::Vh;
use Dancer ':syntax';

use Vh::Models::RexLibvirt;

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
    #$_model  = Users::Models::Users->new ({module => $_module});

    bless($self, $class);

    return $self;
}

sub getSandbox
{
    my $self = shift;
    return $_sb;
}

sub _testGroup
{
    my $self = shift;
    my $group = shift;

    my $role = session('role');

    return unless $role->{prefixes};

    my $groups = "$role->{prefixes},";
    $group .= ',';
    return ( $groups eq 'all,' || $groups =~ m/${group}/ );

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

sub listDomains
{
    my $self = shift;
    my $vms = Vh::Models::RexLibvirt::listDomains();

    my $ret = [];

    foreach my $vm ( @$vms ) {
        my $infos = $self->vmInfos($vm->{name});
        push @$ret, $infos;
    }
    return $ret;
};

sub vmInfos
{
    my $self = shift;
    my $vmName = shift;

    my $vm = {};
    ($vm->{group}, $vm->{short}) = $self->_getGroup($vmName);
    if ( $self->_testGroup($vm->{group}) ) {
        $vm->{details} = Vh::Models::RexLibvirt::detailsVM($vmName);
        $vm->{id} = $vm->{details}{infos}{id};
        $vm->{name} = $vm->{details}{infos}{name};
    }
    return $vm
};


sub startStopVM
{
    my $self = shift;
    my $vmName = params->{vmName};
    my $action = params->{action};

    if ( $action eq 'start' ) {
        $_module->newEvent($vmName, 0, $action, 'prepare to start', '');
        Vh::Models::RexLibvirt::startVM($vmName);
        $_module->newEvent($vmName, 0, $action, 'started', '');
    }

    if ($action eq 'stop' ) {
        $_module->newEvent($vmName, 0, $action, 'prepare to halt', '');
        Vh::Models::RexLibvirt::destroyVM($vmName);
        $_module->newEvent($vmName, 0, $action, 'stopped', '');
    }

    return ;
};

sub setSession
{
    my $username = 'admin';
    my $password = 'pass1';

    session 'logged_in' => true;
    session 'username' => $username;
    session 'role' => {
        role     => 'admin',
        entity   => '',
        prefixes => 'all',
        vlan     => '',
    };
}

sub initController
{
    my $self = shift;

    get '/vh/vms' => sub { $self->setSession(); return $self->listDomains() };
    get '/vh/:vmName' => sub {
        $self->setSession();
        return $self->vmInfos(params->{vmName})
    };
    post '/vh/:vmName' => sub { $self->setSession(); $self->startStopVM(@_); };
}

1;
