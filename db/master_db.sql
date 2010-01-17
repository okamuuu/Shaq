BEGIN TRANSACTION;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id                   INTEGER         NOT NULL PRIMARY KEY,
    rid                  VARCHAR(10)     NOT NULL,
    name                 VARCHAR(50)     NOT NULL,
    created_at           DATETIME        NOT NULL,
    updated_at           DATETIME        NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS user_ridx ON users (rid);

COMMIT;

