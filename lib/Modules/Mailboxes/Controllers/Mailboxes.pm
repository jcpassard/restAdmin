package Mailboxes::Controllers::Mailboxes;
use Dancer ':syntax';

use strict;
use warnings;

use Mailboxes::Models::Mailbox;

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
                          ref($params->{module}) eq 'Mailboxes::Module'
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

sub size
{
    my $self = shift;
    my $path = shift;

    return Mailboxes::Models::Mailbox::size($path);
}

sub list
{
    my $self = shift;
    my $path = shift;

    return Mailboxes::Models::Mailbox::list($path);
}

sub initController
{
    my $self = shift;

    get '/rest/mailboxes' => sub {
        my $path = params->{path};
        return { 'mailboxes' => $self->list($path) };
    };

    get '/rest/mailboxes/size' => sub {
        my $path = params->{path};
        my $list = params->{list};

        my $result = [];
        if ( $list ) {
            my $mailboxes = $self->list($path);
            foreach my $mailbox ( @$mailboxes ) {
               push @$result, { $mailbox => $self->size("$path/$mailbox") };
            }
        } else {
            my $size = $self->size("$path");
            push @$result, { $path => defined($size) ? $size : "Not a mailbox" };
        }
        return $result;
    };
}

1;
