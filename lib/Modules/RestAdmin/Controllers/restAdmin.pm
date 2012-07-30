package RestAdmin::Controllers::RestAdmin;

use strict;
use warnings;

use Dancer ':syntax';

use RestAdmin::Models::RestAdmin;

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
                          ref($params->{module}) eq 'RestAdmin::Module'
                         );
    $_module = $params->{module};
    $_sb     = $_module->getSandbox();

    bless($self, $class);

    return $self;
}

sub userInfo
{
    my $self = shift;
    my $username = shift;

    my $ret = RestAdmin::Models::RexUsers::RestAdmin($username);

    return $ret;
};

sub groupInfo
{
    my $self = shift;
    my $group = shift;

    my $ret = RestAdmin::Models::RestAdmin::getGroup($group);

    return $ret;
};

sub initController
{
    my $self = shift;

    get '/rest/RestAdmin' => sub {
        return RestAdmin::Models::RestAdmin::userList();
    };

    get '/rest/RestAdmin/:username' => sub {
        return $self->userInfo(params->{username});
    };
    get '/rest/RestAdmin/:group' => sub {
        return $self->groupInfo(params->{group});
    };
}

1;
