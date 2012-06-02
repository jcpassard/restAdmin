#! /usr/bin/perl
use Dancer;
use Core;

use Data::Dumper;

use RestAdmin;


our $CORE = Core->new();

$CORE->registerModule('Vh::Module');
$CORE->installModule('Vh::Module');
$CORE->initModule('Vh::Module');

print "CORE : ", Dumper $CORE->_getModules();

dance;


