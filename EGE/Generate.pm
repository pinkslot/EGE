# Copyright © 2010 Alexander S. Klenin
# Licensed under GPL version 2 or later.
# http://github.com/klenin/EGE

use strict;
use warnings;
use utf8;

package EGE::GenerateBase;

use EGE::Random;

sub new {
    my ($class) = @_;
    my $self = {};
    bless $self, $class;
    $self;
}

sub one {
    my ($self, $package, $method) = @_;
    no strict 'refs';
    local $_;
    my $g = "EGE::Gen::$package"->new;
    $g->$method;
    $g->post_process;
    $g;
}

sub subject_name {}
sub all_names {}

sub g {
    my ($self, $unit, @methods) = @_;
    $self->one($self->subject_name . "::$unit", rnd->pick(@methods));
}

sub gg {
    my ($self, $unit, $methods) = @_;
    map $self->g($unit, $_), @$methods;
}

sub all {
    my ($self) = @_;
    my $names = $self->all_names;
    my @ret;
    for my $unit (keys %$names) {
        for my $method (@{$names->{$unit}}) {
            push @ret, $self->g($unit, $method);
        }
    }
    [ @ret ]
}

package EGE::EGEGenerate;
use base 'EGE::GenerateBase';

use EGE::Random;
use EGE::GenBase;
use EGE::Gen::EGE::A01;
use EGE::Gen::EGE::A02;
use EGE::Gen::EGE::A03;
use EGE::Gen::EGE::A04;
use EGE::Gen::EGE::A05;
use EGE::Gen::EGE::A06;
use EGE::Gen::EGE::A07;
use EGE::Gen::EGE::A08;
use EGE::Gen::EGE::A09;
use EGE::Gen::EGE::A10;
use EGE::Gen::EGE::A11;
use EGE::Gen::EGE::A12;
use EGE::Gen::EGE::A13;
use EGE::Gen::EGE::A14;
use EGE::Gen::EGE::A15;
use EGE::Gen::EGE::A16;
use EGE::Gen::EGE::A17;
use EGE::Gen::EGE::A18;
use EGE::Gen::EGE::B01;
use EGE::Gen::EGE::B02;
use EGE::Gen::EGE::B03;
use EGE::Gen::EGE::B04;
use EGE::Gen::EGE::B05;
use EGE::Gen::EGE::B06;
use EGE::Gen::EGE::B07;
use EGE::Gen::EGE::B08;
use EGE::Gen::EGE::B10;
use EGE::Gen::EGE::B11;
use EGE::Gen::EGE::B12;
use EGE::Gen::EGE::B13;
use EGE::Gen::EGE::B14;
use EGE::Gen::EGE::B15;

sub subject_name { 'EGE' }

sub all_names {{
    A01 => [ qw(recode simple) ],
    A02 => [ qw(sport car_numbers database units min_routes) ],
    A03 => [ qw(ones zeroes convert range) ],
    A04 => [ qw(sum) ],
    A05 => [ qw(arith div_mod_10 div_mod_rotate digit_by_digit crc) ],
    A06 => [ qw(count_by_sign find_min_max count_odd_even alg_min_max alg_avg bus_station) ],
    A07 => [ qw(names animals random_sequences restore_password spreadsheet_shift) ],
    A08 => [ qw(equiv_3 equiv_4 audio_sampling) ],
    A09 => [ qw(truth_table_fragment find_var_len_code error_correction_code) ],
    A10 => [ qw(graph_by_matrix) ],
    A11 => [ qw(variable_length fixed_length password_length) ],
    A12 => [ qw(beads array_flip) ],
    A13 => [ qw(file_mask file_mask2 file_mask3) ],
    A14 => [ qw(database) ],
    A15 => [ qw(rgb) ],
    A16 => [ qw(spreadsheet) ],
    A17 => [ qw(diagram) ],
    A18 => [ qw(robot_loop) ],
    B01 => [ qw(direct recode2) ],
    B02 => [ qw(flowchart) ],
    B03 => [ qw(q1234 last_digit count_digits) ],
    B04 => [ qw(impl_border lex_order) ],
    B05 => [ qw(calculator complete_spreadsheet) ],
    B06 => [ qw(solve) ],
    B07 => [ qw(who_is_right) ],
    B08 => [ qw(identify_letter find_calc_system) ],
    B10 => [ qw(trans_rate) ],
    B11 => [ qw(ip_mask) ],
    B12 => [ qw(search_query) ],
    B13 => [ qw(plus_minus) ],
    B14 => [ qw(find_func_min) ],
    B15 => [ qw(logic_var_set) ],
}}

package EGE::AsmGenerate;
use base 'EGE::GenerateBase';

use EGE::GenBase;
use EGE::Gen::Arch::Arch01;
use EGE::Gen::Arch::Arch02;
use EGE::Gen::Arch::Arch03;
use EGE::Gen::Arch::Arch04;
use EGE::Gen::Arch::Arch05;
use EGE::Gen::Arch::Arch06;
use EGE::Gen::Arch::Arch07;
use EGE::Gen::Arch::Arch08;
use EGE::Gen::Arch::Arch09;
use EGE::Gen::Arch::Arch10;
use EGE::Gen::Arch::Arch12;


sub subject_name { 'Arch' }

sub all_names {{
    Arch01 => [ qw(reg_value_add reg_value_logic reg_value_shift reg_value_convert reg_value_jump) ],
    Arch02 => [ qw(flags_value_add flags_value_logic flags_value_shift) ],
    Arch03 => [ qw(choose_commands_mod_3) ],
    Arch04 => [ qw(choose_commands) ],
    Arch05 => [ qw(sort_commands sort_commands_stack) ],
    Arch06 => [ qw(match_values) ],
    Arch07 => [ qw(loop_number) ],
    Arch08 => [ qw(choose_jump) ],
    Arch09 => [ qw(reg_value_before_loopnz zero_fill stack) ],
    Arch10 => [ qw(jcc_check_flags cmovcc) ],
    Arch12 => [ qw(cond_max_min divisible_by_mask) ],
}}

package EGE::DatabaseGenerate;
use base 'EGE::GenerateBase';

use EGE::GenBase;
use EGE::Gen::Db::Db01;
use EGE::Gen::Db::Db02;
use EGE::Gen::Db::Db03;
use EGE::Gen::Db::Db04;
use EGE::Gen::Db::Db05;
use EGE::Gen::Db::Db06;
use EGE::Gen::Db::Db07;
use EGE::Gen::Db::Db08;
use EGE::Gen::Db::Db09;
use EGE::Gen::Db::Db10;

sub subject_name { 'Db' }

sub all_names {{
    Db01 => [ qw(trivial_select trivial_delete) ],
    Db02 => [ qw(select_where) ],
    Db03 => [ qw(trivial_update) ],
    Db04 => [ qw(choose_update) ],
    Db05 => [ qw(insert_delete) ],
    Db06 => [ qw(select_between select_expression) ],
    Db07 => [ qw(trivial_inner_join) ],
    Db08 => [ qw(parents grandchildren nuncle) ],
    Db09 => [ qw(inner_join) ],
    Db10 => [ qw(many_inner_join) ],
}}

package EGE::AlgGenerate;
use base 'EGE::GenerateBase';

use EGE::GenBase;
use EGE::Gen::Alg::Complexity;
use EGE::Gen::Alg::CallCount;
use EGE::Gen::Alg::Tree;
use EGE::Gen::Alg::Graph;
use EGE::Gen::Alg::List;
use EGE::Gen::Alg::Sorting;

sub subject_name { 'Alg' }

sub all_names {{
    Complexity => [ qw(o_poly o_poly_cmp complexity substitution amortized) ],
    'Complexity::ComplexityDI' => [ qw(cycle_complexity) ],
    CallCount => [ qw(super_recursion) ],
    Tree => [ qw(node_count height) ],
    Graph => [ qw(graph_seq) ],
    List => [ qw(construct_command) ],
    Sorting => [ qw(sort_command) ],
}}

1;
