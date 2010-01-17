BEGIN TRANSACTION;

DROP TABLE IF EXISTS nodes;
CREATE TABLE nodes (
    id            INTEGER           NOT NULL PRIMARY KEY,
    number        INTEGER           NOT NULL, -- nodeの番号(同一ホスト内でユニーク)
    host          VARCHAR(20)       NOT NULL, -- ホスト名
    role          VARCHAR(5)        NOT NULL, -- nodeの役割 master or slave
    status        VARCHAR(4)        NOT NULL, -- nodeの状態 ok, down, wait
    type          VARCHAR(20)       NOT NULL, -- nodeの用途 eg. user, archive, etc .. 
    created_at    DATETIME          NOT NULL,
    updated_at    DATETIME          NOT NULL
); -- 接続先データベース情報

CREATE INDEX IF NOT EXISTS node_idx ON nodes (type, role, status);

DROP TABLE IF EXISTS rows;
CREATE TABLE rows (
    id            INTEGER           NOT NULL PRIMARY KEY,
    role          VARCHAR(5)        NOT NULL, -- rowの役割
    type          VARCHAR(10)       NOT NULL, -- rowの用途 nodes.typeと対応
    type_key      VARCHAR(128)      NOT NULL, -- rowのキー(同一type内でユニーク)
    node_id       INTEGER           NOT NULL,
    created_at    DATETIME          NOT NULL,
    updated_at    DATETIME          NOT NULL
); -- データを行単位で分割するので、行ごとの接続先データベース情報

CREATE UNIQUE INDEX IF NOT EXISTS row_idx ON rows (node_id, role, type, type_key);

COMMIT;

