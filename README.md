allographer
===

[![nimble](https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble.png)](https://github.com/yglukhov/nimble-tag)  
![Build Status](https://github.com/itsumura-h/nim-allographer/workflows/Build%20and%20test%20Nim/badge.svg)


A query builder library inspired by [Laravel/PHP](https://readouble.com/laravel/6.0/en/queries.html) and [Orator/Python](https://orator-orm.com) for Nim

## Easy to access RDB
### Query Builder
```nim
import allographer/query_builder

var result = RDB()
            .table("users")
            .select("id", "email", "name")
            .limit(5)
            .offset(10)
            .get()
echo result

>> SELECT id, email, name FROM users LIMIT 5 OFFSET 10
>> @[
  {"id":11,"email":"user11@gmail.com","name":"user11"},
  {"id":12,"email":"user12@gmail.com","name":"user12"},
  {"id":13,"email":"user13@gmail.com","name":"user13"},
  {"id":14,"email":"user14@gmail.com","name":"user14"},
  {"id":15,"email":"user15@gmail.com","name":"user15"}
]
```

### Schema Builder
```nim
import allographer/schema_builder

schema([
  table("auth", [
    Column().increments("id"),
    Column().string("name").nullable(),
    Column().timestamp("created_at").default()
  ])
])

>> CREATE TABLE auth (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR,
    created_at DATETIME DEFAULT (NOW())
)

schema([
  table("users", [
    Column().increments("id"),
    Column().string("name"),
    Column().foreign("auth_id").reference("id").on("auth").onDelete(SET_NULL)
  ])
])

>> CREATE TABLE users (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR NOT NULL,
    auth_id INT,
    FOREIGN KEY(auth_id) REFERENCES auth(id) ON DELETE SET NULL
) 
```

---

## Install
```bach
nimble install allographer
```

## Set up
First of all, add nim binary path
```bash
export PATH=$PATH:~/.nimble/bin
```
After install allographer, "dbtool" command is going to be available.  

### Create config file
```bash
cd /your/project/dir
dbtool makeConf
```
`/your/project/dir/config.nims` will be generated.

### Edit confing file
By default, config file is set to use sqlite.

config.nims
```nim
import os

# DB Connection
putEnv("DB_DRIVER", "sqlite")
putEnv("DB_CONNECTION", "/your/project/dir/db.sqlite3")
putEnv("DB_USER", "")
putEnv("DB_PASSWORD", "")
putEnv("DB_DATABASE", "")

# Logging
putEnv("LOG_IS_DISPLAY", "true")
putEnv("LOG_IS_FILE", "false")
putEnv("LOG_DIR", "/your/project/dir/logs")
```

- DB_DRIVER: `sqlite` or `mysql` or `postgres`
- DB_CONNECTION: `sqlite/file/path` or `host:port`
- DB_USER: login user name
- DB_PASSWORD: login password
- DB_DATABASE: specify the database name

From "connection" to "database", these are correspond to args of open proc of Nim std db package
```nim
let db = open(connection, user, password, database)
```

- LOG_IS_DISPLAY: Whether display logging in terminal console or not.
- LOG_IS_FILE: Whether output logging in log file or not.
- LOG_DIR: Define logging dir path.


## Examples
[Query Builder](./documents/query_builder.md)  
[Schema Builder](./documents/schema_builder.md)  

## API Documents
### Query Builder
[query_builder](https://itsumura-h.github.io/nim-allographer/query_builder.html)  
[base](https://itsumura-h.github.io/nim-allographer/query_builder/base.html)  
[grammars](https://itsumura-h.github.io/nim-allographer/query_builder/grammars.html)  
[exec](https://itsumura-h.github.io/nim-allographer/query_builder/exec.html)  
[connection](https://itsumura-h.github.io/nim-allographer/connection.html)  

### Schema Builder
[schema_builder](https://itsumura-h.github.io/nim-allographer/schema_builder.html)  
[schema](https://itsumura-h.github.io/nim-allographer/schema_builder/schema.html)  
[column](https://itsumura-h.github.io/nim-allographer/schema_builder/column.html)  
[table](https://itsumura-h.github.io/nim-allographer/schema_builder/table.html)  
