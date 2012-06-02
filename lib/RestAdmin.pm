package RestAdmin;
use Dancer ':syntax';

use Data::Dumper;

our $VERSION = '0.1';


get '/' => sub {
    return { location => 'Homepage' };
};

get '/vhName' => sub {
    return setting('vhName');
};

true;
