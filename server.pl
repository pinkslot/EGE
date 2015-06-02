 #!perl -w
use v5.10;
use strict;

use EGE::Generate;
use CATS::Server;
use CATS::DB;
use lib '.';

my %generate = map { $_ => "EGE::${_}Generate"->new } qw(EGE Asm Database Alg);
my $server;

sub main_loop
{
    for (my $i = 0; ; $i++) {
        sleep 2;
        print "...\n" if $i % 5 == 0;
        
        my $p = $server->select_generating_req;
        my @res;
        if ($p) {
            print "Generating for req $p->{rid} from user $p->{uid}\n";
            $server->set_state($p->{rid}, $cats::st_install_processing);
            my @generators = @{eval($p->{gens})};
            for my $g (@generators) {
                my ($subj, $unit, $meth) = split '::', $g;
                my @data = eval {
                    $unit eq 'all' ?
                    @{$generate{$subj}->all} :
                    $generate{$subj}->g($unit, $meth) 
                };
                
                if (my $e = $@) {
                    print "error while generating:\n";
                    $server->set_state($p->{rid}, $cats::st_unhandled_error);
                    print $e;
                }
                else {
                    push @res, @data;
                }
            }
            $server->insert_data($p->{rid}, @res);
            $server->set_state($p->{rid}, $cats::request_processed);
        }
    }
}

CATS::DB::sql_connect;
$server = CATS::Server->new;
main_loop;
CATS::DB::sql_disconnect;

1;
