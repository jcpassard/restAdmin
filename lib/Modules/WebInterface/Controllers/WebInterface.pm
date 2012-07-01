package WebInterface::Controllers::WebInterface;
use Dancer ':syntax';

use Data::Dumper;

use WebInterface::Models::Vh;

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
                          ref($params->{module}) eq 'WebInterface::Module'
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

sub setSession
{
    my $username = 'admin';
    my $password = 'pass1';

    session 'logged_in' => true;
    session 'username' => $username;
    session 'role' => {
        role     => 'admin',
        entity   => '',
        group => 'restAdmin',
        vlan     => '',
    };
}

sub initController
{
    my $self = shift;

    get '/interface/html/vh/:vmName?' => sub {
        $self->setSession();
        my $group = session->{role}{group};
        $group = $group eq 'restAdmin' ? 'all' : $group;

        my $list = WebInterface::Models::Vh::listDomains($group, $self);
        return 'Aucune machine virtuelle' unless $list && scalar(@$list);
        my $vmName = params->{vmName} || $list->[0]{name};
        my $info = WebInterface::Models::Vh::vmInfos($group, $self, $vmName);
        my $t = template '/html/vh.phtml', {
            title   => 'Rest Admin Interface',
            list    => $list,
            info    => $info,
        };
        return $t;
    };

    get '/interface/mobile/vh/vms' => sub {
        $self->setSession();
        my $group = session->{role}{group};
        $group = $group eq 'restAdmin' ? 'all' : $group;

        my $list = WebInterface::Models::Vh::listDomains($group, $self);
        my $t = template 'mobile/vm_list.phtml',
            { data => $list },
            { layout => undef };
        return $t;
    };

    get '/interface/mobile/vh/:vmName' => sub {
        $self->setSession();
        my $group = session->{role}{group};
        $group = $group eq 'restAdmin' ? 'all' : $group;

        my $info = WebInterface::Models::Vh::vmInfos($group, $self, params->{vmName});
        my $t = template 'mobile/vm_info.phtml',
            { data => $info },
            { layout => undef };
        return $t;
    };
}

1;
