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

sub initController
{
    my $self = shift;

    get '/interface' => sub {
        my $list = WebInterface::Models::Vh::listDomains($self);
        my $t = template 'index.phtml', { title => 'Rest Admin Interface',
            data => $list
        };

        #print $t;
    };
}

1;
