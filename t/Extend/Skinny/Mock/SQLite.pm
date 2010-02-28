package t::Extend::Skinny::Mock::SQLite;
use strict;
use warnings;
 
use DBI;
 
sub import {
    my $self = shift;
    my $dbh = DBI->connect('dbi:SQLite:test.db', '', '');
    my @statements = (
        qq{
CREATE TABLE books (
id INTEGER PRIMARY KEY AUTOINCREMENT,
author_id INT,
json_data TEXT,
thumbnail TEXT,
name TEXT UNIQUE,
published_at TEXT,
created_at TEXT,
updated_at TEXT
)
},
        qq{
CREATE TABLE authors (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT,
debuted_on TEXT,
created_on TEXT,
updated_on TEXT
)
},
        q{ INSERT INTO books VALUES (1, 1,'{"width":80, "height":100}', '{"width":80, "height":100, "src": "/path/to", "alt":""}', 'book1', '2008-01-01 09:00:00', '2009-01-01 10:00:00', '2009-01-02 11:00:00') },
        q{ INSERT INTO books VALUES (2, 2,'{"width":80, "height":100}', '{"width":80, "height":100, "src": "/path/to", "alt":""}',  'book2', '2008-01-01 09:01:00', '2009-01-01 10:01:00', '2009-01-02 11:01:00') },
        q{ INSERT INTO books VALUES (3, 1,'{"width":80, "height":100}','{"width":80, "height":100, "src": "/path/to", "alt":""}',  'book3', '2008-01-01 09:02:00', '2009-01-01 10:02:00', '2009-01-02 11:02:00') },
        q{ INSERT INTO authors VALUES (1, 'Mike', '2008-02-01 09:00:00', '2009-02-01 10:00:00', '2009-02-02 11:00:00') },
        q{ INSERT INTO authors VALUES (2, 'John', '2008-02-01 09:01:00', '2009-02-01 10:01:00', '2009-02-02 11:01:00') },
    );
    $dbh->do($_) for @statements;
}
 
END {
    unlink './test.db';
}
 
1;

=head1 SEE ALSO

ここからコピーしてきた

http://github.com/nekoya/p5-dbix-skinny-inflatecolumn-datetime/blob/master/t/Mock/SQLite.pm


