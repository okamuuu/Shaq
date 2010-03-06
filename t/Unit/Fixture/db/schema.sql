CREATE TABLE books (
id INTEGER PRIMARY KEY AUTOINCREMENT,
author_id INT,
name TEXT UNIQUE,
published_at TEXT,
created_at TEXT,
updated_at TEXT
);

CREATE TABLE authors (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT,
category TEXT,
debuted_at TEXT,
created_at TEXT,
updated_at TEXT
);


