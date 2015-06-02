package CATS::Server;

use strict;
use warnings;
use CATS::Constants;
use CATS::DB qw(new_id $dbh);

sub new {
    my $class = shift;
    my $self = { gen_name_id => {} };
    bless $self, $class;
    $self;
}

sub select_generating_req {
    my ($self) = @_;
    $dbh->commit;               # don't refresh db w/o this line
    my $sth = $dbh->prepare_cached(qq~
        SELECT R.id as rid, P.json_data as gens, R.account_id as uid FROM reqs R
        INNER JOIN problems P ON R.problem_id = P.id
        WHERE R.state = ?
        ~);
    $dbh->selectrow_hashref($sth, { Slice => {} }, $cats::generating_req);
}

sub set_state {
    my ($self, $rid, $st) = @_;
    $dbh->do(q~
        UPDATE reqs SET state = ? WHERE id = ?~, {},
    $st, $rid);
    $dbh->commit;
}

sub insert_data {
    my ($self, $rid, @data) = @_;
    my $str = EGE::GenBase::json([ map({{ $_->to_hash(qw(type text variants options)) }} @data) ]);

    $dbh->do(q~
        UPDATE sources SET src = ?, fname = ?, hash = 0
        WHERE req_id = ?~, {},
        $str, $rid . '.ege', $rid
    );
    $dbh->commit;
}

1;
