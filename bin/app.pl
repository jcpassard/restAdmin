#! /usr/bin/perl

use lib qw(lib /home/system/apache/Rex/lib lib/Modules);

use Dancer;
use Core;

use Data::Dumper;

use RestAdmin;


our $CORE = Core->new();

$CORE->registerModule("Logger::Module");
$CORE->installModule("Logger::Module");
$CORE->initModule("Logger::Module");

my $modulesPath = setting('modules');
opendir(my $DIR, $modulesPath) || die "can't opendir $modulesPath: $!";

my @modules = grep { /^[^.]/ &&
    $_ ne 'Logging' &&
    -d "$modulesPath/$_" &&
    -f "$modulesPath/$_/Module.pm"
} readdir($DIR);

foreach my $module ( @modules ) {
    $CORE->registerModule("${module}::Module");
    $CORE->installModule("${module}::Module");
    $CORE->initModule("${module}::Module");
}

#print Dancer::App->current->setting('views'), "\n";

print "CORE : ", Dumper $CORE->_getModules();

dance;


