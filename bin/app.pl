#!D:\strawberry\perl\bin\perl.exe
use Dancer;
use Core;
#use webamin;

#use Users::Controllers::Users;
#use Vh::Controllers::Vh;
#use Vnc::Controllers::Vnc;

use Data::Dumper;

#set 'session'      => 'Simple';
#set 'template'     => 'template_toolkit';
#set 'logger'       => 'console';
#set 'log'          => 'debug';
#set 'show_errors'  => 1;
#set 'startup_info' => 1;
#set 'warnings'     => 1;
#set 'userdb'       => 'userdb';

our $CORE = Core->new();

$CORE->registerModule('Log::Module');
$CORE->registerModule('Users::Module');
$CORE->registerModule('Vh::Module');

#$CORE->installModule('Users::Module');

$CORE->initModule('Log::Module');
$CORE->initModule('Users::Module');
$CORE->initModule('Vh::Module');

print "CORE : ", Dumper $CORE->_getModules();

dance;


