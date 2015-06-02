# Copyright © 2010 Alexander S. Klenin
# Licensed under GPL version 2 or later.
# http://github.com/klenin/EGE
use strict;
use warnings;

use Carp;
$SIG{__WARN__} = \&Carp::cluck;
$SIG{__DIE__} = $SIG{INT} = \&Carp::confess;

use Data::Dumper;
use Encode;

use lib '.';

use EGE::Generate;
use EGE::Gen::Math::Summer;

my $questions;

my ($g, $g1, $g2, $g3) = map "EGE::${_}Generate"->new, qw(EGE Asm Database Alg);

sub g { push @$questions, $g->g(@_); }
sub g1 { push @$questions, $g1->g(@_); }
sub g2 { push @$questions, $g2->g(@_); }
sub g3 { push @$questions, $g3->g(@_); }

sub print_dump {
    for (@$questions) {
        my $dump = Dumper($_);
        Encode::from_to($dump, 'UTF8', 'CP866');
        print $dump;
    }
}

sub print_html {
    print q~<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ru" xml:lang="ru">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <style type="text/css">li.correct { color: red; } div.q { border-bottom: 1px solid black; } </style>
</head>
<body>
~;
    print $_->to_html for @$questions; 
    print "</body>\n</html>";
}

sub print_json {
    print "[\n" . join(",\n", map $_->to_json, @$questions) . "\n]\n";
}

sub print_elt {
    print <<EOT
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<ELT-Test name="EGE sample">
EOT
;
    for my $q (@$questions) {
        my $type = {
            'sc' => 'singlechoice',
            'mc' => 'multichoice',
            'di' => 'input',
        }->{$q->{type}};
        my $mode =
            $type ne 'input' ? '' :
            $q->{correct} =~ /^\d+$/ ? 'number' :
            $q->{correct} =~ /^\w+$/ ? 'word' :
            'any';
        $mode &&= qq~ mode="$mode"~;
        print qq~<question type="$type"$mode>\n~;
        print '<text>', $q->{text}, "</text>\n";
        print '<answer value="1">', $q->{correct}, "</answer>\n";
        print qq~<answer value="0">$_</answer>\n~ for @{$q->{variants}};
        print "</question>\n";
    }
    print "</ELT-Test>\n";
}

binmode STDOUT, ':utf8';

#g('A01', 'recode');
#g('A01', 'simple');
#g('A02', 'sport');
#g('A02', 'car_numbers');
#g('A02', 'database');
#g('A02', 'units');
#g('A02', 'min_routes');
#g('A03', 'ones');
#g('A03', 'zeroes');
#g('A03', 'convert');
#g('A03', 'range');
#g('A04', 'sum');
#g('A05', 'arith');
#g('A05', 'div_mod_10');
#g('A05', 'div_mod_rotate');
#g('A05', 'crc');
#g('A06', 'count_by_sign');
#g('A06', 'bus_station');
#g('A06', 'find_min_max');
#g('A06', 'count_odd_even');
#g('A06', 'alg_min_max');
#g('A06', 'alg_avg');
#g('A07', 'names');
#g('A07', 'animals');
#g('A07', 'random_sequences');
#g('A07', 'restore_password');
#g('A07', 'spreadsheet_shift');
#g('A08', 'equiv_3');
#g('A08', 'equiv_4');
#g('A09', 'truth_table_fragment');
#g('A09', 'find_var_len_code');
#g('A09', 'error_correction_code');
#g('A10', 'graph_by_matrix');
#g('A11', 'variable_length');
#g('A11', 'fixed_length');
#g('A11', 'password_length');
#g('A12', 'beads');
#g('A13', 'file_mask');
#g('A13', 'file_mask2');
#g('A14', 'database');
#g('A15', 'rgb');
#g('A16', 'spreadsheet');
#g('A17', 'diagram');
#g('A18', 'robot_loop');
#g('B01', 'direct');
#g('B02', 'flowchart');
#g('B03', 'q1234');
#g('B03', 'last_digit');
#g('B03', 'count_digits');
#g('B04', 'impl_border');
#g('B05', 'calculator');
#g('B06', 'solve');
#g('B07', 'who_is_right');
#g('B08', 'identify_letter');
#g('B10', 'trans_rate');
#g('B11', 'ip_mask');
#g('B12', 'search_query');
#g('B13', 'plus_minus');
#g('B14', 'find_func_min');
#g('B15', 'logic_var_set');
#g1('Arch01', 'reg_value_add');
#g1('Arch01', 'reg_value_logic');
#g1('Arch01', 'reg_value_shift');
#g1('Arch01', 'reg_value_convert');
#g1('Arch01', 'reg_value_jump');
#g1('Arch02', 'flags_value_add');
#g1('Arch02', 'flags_value_logic');
#g1('Arch02', 'flags_value_shift');
#g1('Arch03', 'choose_commands_mod_3');
#g1('Arch04', 'choose_commands');
#g1('Arch05', 'sort_commands');
#g1('Arch05', 'sort_commands_stack');
#g1('Arch06', 'match_values');
#g1('Arch07', 'loop_number');
#g1('Arch08', 'choose_jump');
#g1('Arch09', 'reg_value_before_loopnz');
#g1('Arch09', 'zero_fill');
#g1('Arch09', 'stack');
#g1('Arch10', 'jcc_check_flags');
#g1('Arch10', 'cmovcc');
#g1('Arch12', 'cond_max_min');
#g1('Arch12', 'divisible_by_mask');
#g2('Db01', 'trivial_select');
#g2('Db01', 'trivial_delete');
#g2('Db02', 'select_where');
#g2('Db03', 'trivial_update');
#g2('Db04', 'choose_update');
#g2('Db05', 'insert_delete');
#g2('Db06', 'select_between');
#g2('Db06', 'select_expression');
#g2('Db07', 'trivial_inner_join');
#g2('Db08', 'parents') for 1..3;
#g2('Db08', 'grandchildren') for 1..3;
#g2('Db08', 'nuncle') for 1..3;
#g2('Db09', 'inner_join');
#g2('Db10', 'many_inner_join');
#g3('Complexity', 'o_poly');
#g3('Complexity', 'o_poly_cmp');
#g3('Complexity::ComplexityDI', 'cycle_complexity');
#g3('Complexity', 'complexity');
#g3('Complexity', 'substitution');
#g3('Complexity', 'amortized');
#g3('CallCount', 'super_recursion');
#g3('Tree', 'node_count');
#g3('Tree', 'height');
#g3('Graph', 'graph_seq');
#g3('List', 'construct_command');
#g3('Sorting', 'sort_command');

push @$questions, EGE::Gen::Math::Summer::g($_) for qw(p1 p2 p3 p4 p5 p6 p7);
$questions = $g->all;
$questions = $g1->all;
$questions = $g2->all;
$questions = $g3->all;

print_html;
#print_json;
#print_elt;
