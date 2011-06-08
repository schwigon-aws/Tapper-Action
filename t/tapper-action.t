use strict;
use warnings;
use 5.010;

#################################################
#                                               #
# This test checks whether messages in order    #
# are handled correctly.                        #
#                                               #
#################################################

use Test::More;
use English '-no_match_vars';
use Tapper::Schema::TestTools;
use Test::Fixture::DBIC::Schema;
use Tapper::Model 'model';
use File::Temp qw/ tempdir /;

# -----------------------------------------------------------------------------------------------------------------
construct_fixture( schema  => testrundb_schema, fixture => 't/fixtures/testrundb/testrun_with_preconditions.yml' );
# -----------------------------------------------------------------------------------------------------------------

use_ok('Tapper::Action');

my $output; 

my $dir = tempdir( CLEANUP => 1 );
$ENV{TAPPER_DIR_FOR_ACTION_TEST} = "$dir/output";

# this eval makes sure we even try to stop the daemon when a test dies
eval {
        $output = `$EXECUTABLE_NAME -Ilib bin/tapper-action-daemon start`;
        is($output, '', 'Start without error');
        
        $output =  `$EXECUTABLE_NAME -Ilib bin/tapper-action-daemon status`;
        like($output, qr/Running:\s+yes/, 'Daemon is running');

        my $message = model('TestrunDB')->resultset('Message')->new({type => 'action', message => {action => 'resume', host => 'somehost'}});
        $message->insert;
        
        sleep 3; # give daemon time to work
        if (-e "$dir/output") {
                pass 'Output file for test script exists';
                open my $fh, '<', "$dir/output";
                my $text = do { local( $/ ); <$fh> };
                close $fh;
                like($text, qr/--first --host somehost/, 'All arguments of reset script in file');
        } else {
                fail 'Output file for test script exists';
        }
};


$output = `$EXECUTABLE_NAME -Ilib bin/tapper-action-daemon stop`;
is($output, '', 'Stop without error');



done_testing;