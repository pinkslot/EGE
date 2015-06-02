# Copyright © 2010 Alexander S. Klenin
# Copyright © 2013 Natalia D. Zemlyannikova
# Licensed under GPL version 2 or later.
# http://github.com/klenin/EGE

use strict;
use warnings;

package EGE::GenBase;

sub new {
    my ($class, %init) = @_;
    my $self = { text => undef, correct => undef };
    bless $self, $class;
    $self->init;
    $self;
}

sub post_process {}

sub list_to_html {
    my ($self, $correct, $variants) = @_;
    $variants ||= $self->{variants};
    $correct ||= $self->{correct};
    join '', map(
        ($correct->[$_] ? '<li class="correct">' : '<li>') . "$variants->[$_]</li>\n",
        0 .. $#{$variants}
    );
}

sub to_html {
    qq~
<div class="q">
$_[0]->{text}
<ol>
~ .
$_[0]->vars_to_html .
qq~</ol>
</div>
~;
}

sub quote {
    my ($s) = @_;
    $s =~ s/\\/\\\\/g;
    $s =~ s/"/\\"/g;
    $s =~ s/\n/\\n/g;
    # TODO написать в AQuiz'е аналогичный stringify
    # Запретить восьмеричные литералы
    # $s =~ /^(0|[1-9]\d+)$/ ? $s : qq~"$s"~;
    qq~"$s"~
}

sub json {
    !ref $_[0] ? quote($_[0]) :
    ref $_[0] eq 'ARRAY' ? '[' . join(', ', map(json($_), @{$_[0]})) . ']' :
    ref $_[0] eq 'HASH' ? '{' . join(', ', map(qq~"$_":~ . json($_[0]->{$_}), keys %{$_[0]})) . '}' :
    die ref $_[0];
}

sub to_hash {
    my ($self, @keys) = @_;
    @keys = qw(type text correct variants options) if !@keys;
    map { exists $self->{$_} ? ($_ => $self->{$_}) : () } @keys;

}

sub to_json {
    my $self = shift;
    json({ $self->to_hash(@_) });
}

package EGE::GenBase::SingleChoice;
use base 'EGE::GenBase';

use EGE::Random;

sub init {
    $_[0]->{type} = 'sc';
    $_[0]->{correct} = 0;
}

sub variants {
    my $self = shift;
    $self->{variants} = [ @_ ];
}

sub formated_variants {
    my ($self, $format) = (shift, shift);
    $self->variants(map {sprintf $format, $_} @_);
}

sub shuffle_variants {
    my ($self)= @_;
    $self->{variants} or die;
    my @order = rnd->shuffle(0 .. @{$self->{variants}} - 1);
    $self->{correct} = $order[$self->{correct}];
    my @v;
    $v[$order[$_]] = $self->{variants}->[$_] for @order;
    $self->{variants} = \@v;
}

sub post_process { $_[0]->shuffle_variants; }

sub vars_to_html {
    $_[0]->list_to_html(
        [ map $_ == $_[0]->{correct}, 0 .. $#{$_[0]->{variants}} ]
    );
}

package EGE::GenBase::DirectInput;
use base 'EGE::GenBase';

sub init {
    $_[0]->{type} = 'di';
    $_[0]->{accept} = qr/.+/;
}

sub accept_number {
    $_[0]->{accept} = qr/^\d+$/;
}

sub post_process {
    $_[0]->{correct} =~ $_[0]->{accept} or
        die 'Correct answer is not acceptable in ', ref $_[0], ': ', $_[0]->{correct};
}

sub vars_to_html {
    $_[0]->list_to_html([1], [ $_[0]->{correct} ]);
}

package EGE::GenBase::MultipleChoice;
use base 'EGE::GenBase::SingleChoice';

use EGE::Random;

sub init {
    $_[0]->{type} = 'mc';
    $_[0]->{correct} = [];
}

sub shuffle_variants {
    my ($self)= @_;
    $self->{variants} or die;
    my @order = rnd->shuffle(0 .. @{$self->{variants}} - 1);
    my (@v, @c);
    $v[$order[$_]] = $self->{variants}->[$_], $c[$order[$_]] = $self->{correct}->[$_] for @order;
    $self->{variants} = \@v;
    $self->{correct} = \@c;
}

sub vars_to_html {
    $_[0]->list_to_html;
}

package EGE::GenBase::MultipleChoiceFixedVariants;
use base 'EGE::GenBase::MultipleChoice';

sub shuffle_variants {
}

package EGE::GenBase::Sortable;
use base 'EGE::GenBase::SingleChoice';

use EGE::Random;

sub init {
    $_[0]->{type} = 'sr';
    $_[0]->{correct} = [];
}

sub shuffle_variants {
    my ($self)= @_;
    $self->{variants} or die;
    my @order = rnd->shuffle(0 .. @{$self->{variants}} - 1);
    my (@v, @c);
    for my $o (@order) {
        $v[$order[$o]] = $self->{variants}->[$o];
        my $id = -1;
        for my $i (0..$#{$self->{correct}}) {
            $id = $i if ($self->{correct}->[$i] == $o);
        }
        $c[$id] = $order[$o];
    }
    $self->{variants} = \@v;
    $self->{correct} = \@c;
}

sub vars_to_html {
    $_[0]->list_to_html([]) . "</ol>\n<ol>\n" . $_[0]->list_to_html(
        [ map 1, 0 .. $#{$_[0]->{correct}} ],
        [ map $_[0]->{variants}->[$_], @{$_[0]->{correct}} ]
    );
}

package EGE::GenBase::Match;
use base 'EGE::GenBase::Sortable';

sub init {
    $_[0]->{type} = 'mt';
    $_[0]->{correct} = [];
    $_[0]->{left_column} = [];
}

sub post_process {
    $_[0]->shuffle_variants;
    $_[0]->{variants} = [ $_[0]->{left_column}, $_[0]->{variants} ];
}

sub vars_to_html {
    $_[0]->list_to_html(
        [],
        [ map "$_[0]->{variants}->[0]->[$_] - $_[0]->{variants}->[1]->[$_]", 0 .. $#{$_[0]->{variants}->[1]} ]
    ) .
    $_[0]->list_to_html(
        [ map 1, 0 .. $#{$_[0]->{variants}->[1]} ],
        [ map "$_[0]->{variants}->[0]->[$_] - $_[0]->{variants}->[1]->[$_[0]->{correct}->[$_]]", 0 .. $#{$_[0]->{variants}->[1]} ]
    );
}

package EGE::GenBase::Construct;
use base 'EGE::GenBase::Sortable';

sub shuffle_variants { }

sub init {
    $_[0]->{type} = 'cn';
    $_[0]->{correct} = [];
}

1;
