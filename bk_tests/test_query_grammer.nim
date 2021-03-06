import unittest

include ../src/allographer/query_builder/grammars

suite "grammer":
  test "table":
    let t = RDB().table("test1")
    check t.query["table"].getStr == "test1"

  test "raw":
    let t = RDB().raw("SELECT * FROM users")
    check t.sqlStringSeq[0] == "SELECT * FROM users"

  test "select id":
    let t = RDB().table("test").select("id")
    check t.query["select"][0].getStr == "id"
    
  test "select id, name":
    let t = RDB().table("test").select("id", "name")
    check t.query["select"][0].getStr == "id"
    check t.query["select"][1].getStr == "name"

  test "select *":
    let t = RDB().table("test").select()
    check t.query["select"][0].getStr == "*"

  test "where int":
    let t = RDB().table("test").where("id", "<", 3).where("id", ">", 10)
    check t.query["where"][0] == %*{"column":"id","symbol":"<","value":3}
    check t.query["where"][1] == %*{"column":"id","symbol":">","value":10}

  test "where str":
    let t = RDB().table("test").where("name", "=", "John").where("name", "=", "Paul")
    check t.query["where"][0] == %*{"column":"name","symbol":"=","value":"John"}
    check t.query["where"][1] == %*{"column":"name","symbol":"=","value":"Paul"}

  test "orWhere int":
    let t = RDB().table("test").orWhere("id", "<", 3).orWhere("id", ">", 10)
    check t.query["or_where"][0] == %*{"column":"id","symbol":"<","value":3}
    check t.query["or_where"][1] == %*{"column":"id","symbol":">","value":10}

  test "orWhere str":
    let t = RDB().table("test").orWhere("name", "=", "John").orWhere("name", "=", "Paul")
    check t.query["or_where"][0] == %*{"column":"name","symbol":"=","value":"John"}
    check t.query["or_where"][1] == %*{"column":"name","symbol":"=","value":"Paul"}

  test "join":
    let t = RDB().table("test")
      .join("t1", "t1.c1", "=", "test.c1")
      .join("t2", "t2.c2", "=", "t1.c2")
    check t.query["join"][0] == %*{"table":"t1","column1":"t1.c1","symbol":"=","column2":"test.c1"}
    check t.query["join"][1] == %*{"table":"t2","column1":"t2.c2","symbol":"=","column2":"t1.c2"}

  test "limit":
    let t = RDB().table("test").limit(5)
    check t.query["limit"].getInt == 5

  test "offset":
    let t = RDB().table("test").offset(3)
    check t.query["offset"].getInt == 3