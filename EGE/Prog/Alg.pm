package EGE::Prog::Alg;

use strict;
use warnings;
use utf8;

our %sortings = (
    bubble => [
        '=', 'n1', [ '-', 'n', 1 ],
        'for', 'j', 0, 'n1', [
            'for', 'i', 0, [ '-', [ '-', 'n1', 1 ], 'j' ], [
                'if', [ '<', [ '[]', 'a', [ '+' , 'i', 1 ] ], [ '[]', 'a', 'i' ] ], [
                    '=', 'tmp', [ '[]', 'a', 'i' ],
                    '=', [ '[]', 'a', 'i' ], [ '[]', 'a', [ '+', 'i', 1 ] ],
                    '=', [ '[]', 'a', [ '+', 'i', 1 ] ], 'tmp'
                ]
            ]
        ]
    ],
    selection => [
        '=', 'n1', [ '-', 'n', 1 ],    
        'for', 'j', 0, 'n1', [ 
            'for', 'i', [ '+', 'j', 1], 'n1', [
                'if', [ '<', [ '[]', 'a', 'i' ], [ '[]', 'a', 'j' ], ], [
                    '=', 'tmp', [ '[]', 'a', 'i' ],
                    '=', [ '[]', 'a', 'i' ], [ '[]', 'a', 'j' ],
                    '=', [ '[]', 'a', 'j' ], 'tmp'
                ],
            ],
        ]
    ],
    insert => [
        '=', 'n1', [ '-', 'n', 1 ],
        'for', 'j', 1, 'n1', [
            '=', 'i', 'j',
            '=', 'tmp', [ '[]', 'a', 'i' ],
            'while', [ '&&', [ '>=', [ '--%s', 'i' ], 0 ], [ '>', [ '[]', 'a', 'i', ], 'tmp' ] ], [
                '=', [ '[]', 'a', [ '+', 'i', 1 ] ], [ '[]', 'a', 'i' ]
            ],
            '=', [ '[]', 'a', [ '+', 'i', 1 ] ], 'tmp'
        ]
    ]
)