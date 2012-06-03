package Users::Controllers::Users;

use strict;
use warnings;

use Dancer ':syntax';

use Users::Models::RexUsers;

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
                          ref($params->{module}) eq 'Users::Module'
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

    my $ret = Users::Models::RexUsers::getUser($username);

    return $ret;
};

sub groupInfo
{
    my $self = shift;
    my $group = shift;

    my $ret = Users::Models::RexUsers::getGroup($group);

    return $ret;
};

sub initController
{
    my $self = shift;

    get '/rest/users' => sub {
        return Users::Models::RexUsers::userList();
    };

    get '/rest/users/:username' => sub {
        return $self->userInfo(params->{username});
    };
    get '/rest/groups/:group' => sub {
        return $self->groupInfo(params->{group});
    };
}

1;
