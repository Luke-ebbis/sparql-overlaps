# Finding overlaps with a `sparql` query

# Introduction

Suppose you have a table and you want to find the overlapping records based on `start` and `end` position.

| start | end  | name |
| ----- | ---- | ---- |
| 1     | 100  | a    |
| 2     | 50   | b    |
| 40    | 45   | c    |
| 45    | 60   | d    |
| 101   | 500  | e    |
| 200   | 300  | f    |

But it has like 20000 rows or something. Then it might be a better option to use a professional database to find the overlaps.

Finding overlaps with a sparql query.

```sparql 
PREFIX schema: <http://schema.org/>
PREFIX base: <http://example.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?x_name ?y_name ?x_summary ?y_summary WHERE {
  ?x rdf:type base:range .
  ?y rdf:type base:range .
  ?x base:name ?x_name .
  ?y base:name ?y_name .
  filter(?x != ?y)
  
  ?x base:start ?x_start .
  ?x base:end ?x_end .
 
  ?y base:start ?y_start .
  ?y base:end ?y_end .
  
  FILTER(?x_start > ?y_start && ?x_end < ?y_end) .
  BIND(CONCAT(STR(?x_start), "-", STR(?x_end)) as ?x_summary) .
  BIND(CONCAT(STR(?y_start), "-", STR(?y_end)) as ?y_summary) .
  
} LIMIT 10
```

Will give you

| x name | y name | x summary | y summary |
| ------ | ------ | --------- | --------- |
| f      | e      | 200-300   | 101-500   |
| b      | a      | 2-50      | 1-100     |
| d      | a      | 45-60     | 1-100     |
| c      | b      | 40-45     | 2-50      |
| c      | a      | 40-45     | 1-100     |

# How to get it

```sh
$ ls
data  deps  LICENSE  README.md  script
$ curl https://sh.rustup.rs -sSf | sh
$ cargo install oxigraph_server
$ bash script/make_triple.sh
$ bash script/run.sh
```

# Credits

If you use it, please cite TARQL properly https://tarql.github.io/