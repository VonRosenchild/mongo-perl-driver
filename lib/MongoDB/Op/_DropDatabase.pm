#  Copyright 2016 - present MongoDB, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

use strict;
use warnings;
package MongoDB::Op::_DropDatabase;

# Implements a database drop; returns a MongoDB::CommandResult

use version;
our $VERSION = 'v2.2.1';

use Moo;

use MongoDB::Op::_Command;

use namespace::clean;

with $_ for qw(
  MongoDB::Role::_PrivateConstructor
  MongoDB::Role::_DatabaseOp
  MongoDB::Role::_WriteOp
);

sub execute {
    my ( $self, $link ) = @_;

    my $op = MongoDB::Op::_Command->_new(
        db_name => $self->db_name,
        query   => [
            dropDatabase => 1,
            ( $link->supports_helper_write_concern ? ( @{ $self->write_concern->as_args } ) : () ),
        ],
        query_flags         => {},
        bson_codec          => $self->bson_codec,
        session             => $self->session,
        monitoring_callback => $self->monitoring_callback,
    );

    my $res = $op->execute($link);
    $res->assert_no_write_concern_error;

    return $res;
}

1;
