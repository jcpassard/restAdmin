#! /usr/bin/perl
use Dancer;
use Core;

use Data::Dumper;

use RestAdmin;


our $CORE = Core->new();

$CORE->registerModule('Vh::Module');
$CORE->registerModule('WebInterface::Module');
$CORE->installModule('Vh::Module');
$CORE->installModule('WebInterface::Module');
$CORE->initModule('Vh::Module');
$CORE->initModule('WebInterface::Module');


print Dancer::App->current->setting('views'), "\n";

print "CORE : ", Dumper $CORE->_getModules();

dance;


