# PelikoneScrape

## Used Swift packages

If you are cloning this project you need to add the following two packages to your XCode project

### Theo

https://github.com/Neo4j-Swift/Neo4j-Swift.git

### SwiftSoup

https://github.com/scinfu/SwiftSoup.git

## Usage

First rudimentary version of a scraper to scrape pelikone data to a Neo4J instance

## Database

```
CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE
CREATE CONSTRAINT ON (c:Club) ASSERT c.id IS UNIQUE
CREATE CONSTRAINT ON (p:Player) ASSERT p.id IS UNIQUE
```

## Imprt the CSV files

```
LOAD CSV FROM 'file:///clubs.csv' AS row
MERGE (c:Club {name: row[0], id: row[1], url: row[2]})

LOAD CSV FROM 'file:///teams.csv' AS row
MERGE (t:Team {name: row[0], season: row[1], series: row[2], id: row[3], url: row[4]})
WITH row, t
MATCH (c:Club) WHERE c.id = row[5]
MERGE (t)-[:BELONGS_TO]->(c)
```


## Clean the database

Delete CLubs with no teams (these are just mistakenly created clubs, wrong spellings etc.)
```
MATCH (c:Club)
WHERE NOT (c)-[:BELONGS_TO]-(:Team)
DETACH DELETE c
```

## Data cleanup

match (t:Team)-[]->(c:Club) where c.id = "172"
match (c2:Club) where c2.id = "5"
with t, c, c2
merge (t)-[:BELONGS_TO]->(c2)
detach del

77 & 70
82 & 160
21 & 160
14 & 160
111 & 96
169 & 58
121 & 58
74 & 37
104 & 37
173 & 113
107 & 114
163 & 114
168 & 141
126 & 46
18 & 108
