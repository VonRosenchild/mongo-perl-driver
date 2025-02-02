#  Copyright 2009 - present MongoDB, Inc.
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

use 5.010001;
use strict;
use warnings;

package MongoDB;
# ABSTRACT: Official MongoDB Driver for Perl

use version;
our $VERSION = 'v2.2.1';

# regexp_pattern was unavailable before 5.10, had to be exported to load the
# function implementation on 5.10, and was automatically available in 5.10.1
use if ($] eq '5.010000'), 're', 'regexp_pattern';

use Carp ();
use MongoDB::MongoClient;
use MongoDB::Database;
use MongoDB::Collection;
use MongoDB::BulkWrite;
use MongoDB::_Link;
use MongoDB::_Protocol;
use BSON::Types;

# regexp_pattern was unavailable before 5.10, had to be exported to load the
# function implementation on 5.10, and was automatically available in 5.10.1
if ( $] eq '5.010' ) {
    require re;
    re->import('regexp_pattern');
}

=method connect

    $client = MongoDB->connect(); # localhost, port 27107
    $client = MongoDB->connect($host_uri);
    $client = MongoDB->connect($host_uri, $options);

This function returns a L<MongoDB::MongoClient> object.  The first parameter is
used as the C<host> argument and must be a host name or L<connection string
URI|MongoDB::MongoClient/CONNECTION STRING URI>.  The second argument is
optional.  If provided, it must be a hash reference of constructor arguments
for L<MongoDB::MongoClient::new|MongoDB::MongoClient/ATTRIBUTES>.

If an error occurs, a L<MongoDB::Error> object will be thrown.

B<NOTE>: To connect to a replica set, a replica set name must be provided.
For example, if the set name is C<"setA">:

    $client = MongoDB->connect("mongodb://example.com/?replicaSet=setA");

=cut

sub connect {
    my ($class, $host, $options) = @_;
    $host ||= "mongodb://localhost";
    $options ||= {};
    $options->{host} = $host;
    return MongoDB::MongoClient->new( $options );
}

1;


__END__

=for Pod::Coverage

=begin :prelude

=head1 END OF LIFE NOTICE

Version v2.2.0 is the final feature release of the MongoDB Perl driver.
The driver is now in a 12-month "sunset" period and will receive security
patches and critical bug fixes only.  The Perl driver will be end-of-life
and unsupported on August 13, 2020.

=end :prelude

=head1 SYNOPSIS

    use MongoDB;

    my $client     = MongoDB->connect('mongodb://localhost');
    my $collection = $client->ns('foo.bar'); # database foo, collection bar
    my $result     = $collection->insert_one({ some => 'data' });
    my $data       = $collection->find_one({ _id => $result->inserted_id });

=head1 DESCRIPTION

This is the official Perl driver for L<MongoDB|http://www.mongodb.com>.
MongoDB is an open-source document database that provides high performance,
high availability, and easy scalability.

A MongoDB server (or multi-server deployment) hosts a number of databases. A
database holds a set of collections. A collection holds a set of documents. A
document is a set of key-value pairs. Documents have dynamic schema. Using dynamic
schema means that documents in the same collection do not need to have the same
set of fields or structure, and common fields in a collection's documents may
hold different types of data.

Here are some resources for learning more about MongoDB:

=for :list
* L<MongoDB Manual|http://docs.mongodb.org/manual/contents/>
* L<MongoDB CRUD Introduction|http://docs.mongodb.org/manual/core/crud-introduction/>
* L<MongoDB Data Modeling Introductions|http://docs.mongodb.org/manual/core/data-modeling-introduction/>

To get started with the Perl driver, see these pages:

=for :list
* L<MongoDB Perl Driver Tutorial|MongoDB::Tutorial>
* L<MongoDB Perl Driver Examples|MongoDB::Examples>

Extensive documentation and support resources are available via the
L<MongoDB community website|http://www.mongodb.org/>.

=head1 USAGE

The MongoDB driver is organized into a set of classes representing
different levels of abstraction and functionality.

As a user, you first create and configure a L<MongoDB::MongoClient> object
to connect to a MongoDB deployment.  From that client object, you can get a
L<MongoDB::Database> object for interacting with a specific database.

From a database object, you can get a L<MongoDB::Collection> object for
CRUD operations on that specific collection, or a L<MongoDB::GridFSBucket>
object for working with an abstract file system hosted on the database.
Each of those classes may return other objects for specific features or
functions.

See the documentation of those classes for more details or the
L<MongoDB Perl Driver Tutorial|MongoDB::Tutorial> for an example.

L<MongoDB::ClientSession> objects are generated from a
L<MongoDB::MongoClient> and allow for advanced consistency options, like
causal-consistency and transactions.

=head2 Error handling

Unless otherwise documented, errors result in fatal exceptions.  See
L<MongoDB::Error> for a list of exception classes and error code
constants.

=head1 SEMANTIC VERSIONING SCHEME

Starting with MongoDB C<v1.0.0>, the driver reverts to the more familiar
three-part version-tuple numbering scheme used by both Perl and MongoDB:
C<vX.Y.Z>

=for :list
* C<X> will be incremented for incompatible API changes.
* Even-value increments of C<Y> indicate stable releases with new
  functionality.  C<Z> will be incremented for bug fixes.
* Odd-value increments of C<Y> indicate unstable ("development") releases that
  should not be used in production.  C<Z> increments have no semantic meaning;
  they indicate only successive development releases.

See the Changes file included with releases for an indication of the nature of
changes involved.

=head1 ENVIRONMENT VARIABLES

If the C<PERL_MONGO_WITH_ASSERTS> environment variable is true before the
MongoDB module is loaded, then its various classes will be generated with
internal type assertions enabled.  This has a severe performance cost and
is not recommended for production use.  It may be useful in diagnosing
bugs.

If the C<PERL_MONGO_NO_DEP_WARNINGS> environment variable is true, then
deprecated methods will not issue warnings when used.  (Normally, a
deprecation warning is issued once per call-site for deprecated methods.)

=head1 THREADS

Per L<threads> documentation, use of Perl threads is discouraged by the
maintainers of Perl and the MongoDB Perl driver does not test or provide support
for use with threads.

=cut

# vim: set ts=4 sts=4 sw=4 et tw=75:
