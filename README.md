# PelikoneScrape

## Used Swift packages

If you are cloning this project you need to add the following two packages to your XCode project

### Theo

https://github.com/Neo4j-Swift/Neo4j-Swift.git

### SwiftSoup

https://github.com/scinfu/SwiftSoup.git

## Usage

First rudimentary version of a scraper to scrape pelikone data to a Neo4J instance

## Prep Database

```
CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE
CREATE CONSTRAINT ON (c:Club) ASSERT c.id IS UNIQUE
CREATE CONSTRAINT ON (p:Player) ASSERT p.id IS UNIQUE

UNWIND range(1999, 2021) as id
CREATE (a:Year {id:id})

CREATE (:Season {name: "Indoor", srch: "Talvi"}),(:Season {name: "Outdoor", srch: "Kesä"}),(:Season {name: "Beach", srch: "Ranta"})

CREATE (:Series {name: "Open"}),(:Series {name: "Women"}),(:Series {name: "Mixed"}),(:Series {name: "Open Masters"}),(:Series {name: "Juniors U20"}),(:Series {name: "Mixed Masters"}),(:Series {name: "Juniors U15"}),(:Series {name: "Juniors U16"}),(:Series {name: "Juniors U17"})
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

LOAD CSV FROM 'file:///players.csv' AS row
MERGE (p:Player {name: row[0], altName: row[1], id: row[2], url: row[3]})

LOAD CSV FROM 'file:///rosters.csv' AS row
MERGE (t:Team {name: row[3], season: row[1], series: row[2]})
WITH t, row
MATCH (p:Player) WHERE p.id = row[0]
MERGE (p)-[:PLAYS_FOR]->(t)
```

## Clean the database

Delete Clubs with no teams (these are just mistakenly created clubs, wrong spellings etc.)
```
MATCH (c:Club)
WHERE NOT (c)-[:BELONGS_TO]-(:Team)
DETACH DELETE c
```

Execute the following query for all number pairs listed below. This consolidates the same clubs created with different names.
```
MATCH (t:Team)-[]->(c:Club) WHERE c.id = "172"
MATCH (c2:Club) WHERE c2.id = "5"
WITH t, c, c2
MERGE (t)-[:BELONGS_TO]->(c2)
DETACH DELETE c

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
159 & 144
166 & 144
112 & 144
109 & 91
122 & 91
119 & 91
161 & 17
118 & 90
162 & 90
150 & 117
```

## Create additional dependencies

Add countries to teams
```
MATCH (c:Club) WHERE c.id IN ["146","97","98","155","157","94","96","123","125","156","124","177","105","110"] SET c.country = "Russia"
MATCH (c:Club) WHERE c.id IN ["91","174","154"] SET c.country = "Estonia"
MATCH (c:Club) WHERE c.id IN ["141"] SET c.country = "Latvia"
MATCH (c:Club) WHERE NOT EXISTS(c.country) SET c.country = "Finland"
```
Connect the teams to certain year node

```
MATCH (y:Year), (t:Team) WHERE t.season CONTAINS toString(y.id)
MERGE (t)-[:PLAYS_IN_YEAR]->(y)
```

Connect the teams to certain season node. Note, that this does not connect all teams (100+ do not contain words Kesä, Talvi or Beach)

```
MATCH (s:Season), (t:Team) WHERE t.season CONTAINS s.srch
MERGE (t)-[:PLAYS_IN_SEASON]->(s)
```
Use some manual magic to connect the rest of the teams to seasons
```
MATCH (t:Team), (s:Season)
WHERE NOT (t:Team)-[:PLAYS_IN_SEASON]-() AND t.season CONTAINS "Juniori" AND s.name = "Outdoor"
MERGE (t)-[:PLAYS_IN_SEASON]-(s)

MATCH (t:Team), (s:Season)
WHERE NOT (t:Team)-[:PLAYS_IN_SEASON]-() AND t.season CONTAINS "Mixed" AND s.name = "Outdoor"
MERGE (t)-[:PLAYS_IN_SEASON]-(s)

MATCH (t:Team), (s:Season)
WHERE NOT (t:Team)-[:PLAYS_IN_SEASON]-() AND t.season CONTAINS "OSM" AND s.name = "Indoor"
MERGE (t)-[:PLAYS_IN_SEASON]-(s)

```
# Some interesting queries

Find players, who have represented the most clubs
```
match (p:Player)-[r]-(:Team)--(c:Club) return p.name, count(distinct c) order by count(distinct c) desc limit 10
```

Show all the teams and clubs one player has represented
```
match (p:Player)-[r]-(t:Team)-[r2]-(c:Club) where p.name = "Salmela Jasmiina" return p,r,t,r2,c
```

Show all the players who have played in the same teams as one specific player
```
match (p:Player)-[r]-(t:Team)-[r2]-(p2:Player) where p.name = "Kontiainen Olli" return p,r,t,r2,p2
```
