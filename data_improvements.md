# Changes for Pelikone data (Liitokiekkoliito instance)

## Mistakes in the data

### Player identities

There are small number of players, who might have mixed identities in the system. This becomes visible, when one navigates from the page listing all players (https://www.ultimate.fi/pelikone/?view=allplayers&list=all) to the individual player pages (like for Janne Aittomäki to https://www.ultimate.fi/pelikone/?view=playercard&series=0&player=12410) and compares the player name in the link (on the listing page) and the name on the player detail page. There are of course certain people who have changed their names (for example through marriage) or there are cases, where slighly different names for the same player have been used for different seasons. Below is a list of the players, which likely have some problems (although there are a couple of border cases like Janne Aittomäki, Jori Kuvaja and Juhani Puumalainen). In the following list the first name string is the name one has to follow from the player listing page and the second one is the one shown on the player detail page.
* "Aittomäki Janne" -> "#21 Viljami Aittomäki", player id: 12410
* "Hakalahti Johanna" -> "#", player id: 10929
* "Hankalin Ville" -> "Iris Toivonen", player id : 6630
* "Heinonen Riku" -> "Tuukka Lahti", player id: 6626
* "Kima Riitta-Liisa" -> "#22 Tiina Lehtinen", player id: 9756
* "Kuvaja Jori" -> "#88 George Kuvaja", player id: 28809
* "Puumalainen Juhani" -> "Max Puumalainen", player id: 395
* "Sellin Jutta" -> "Topias Mononen", player id: 6823
* "Suonpää Mika" -> "Jesse Savo", player id: 6638
* "Suoranta Simo" -> "Pia Olkinuora", player id: 5179
* "Vehkaoja Antti" -> "Kalle Kyrö", player id: 6640

## Suggested data improvements

### Consistent series naming and categories

Currently different series category naming conventions are used. Also in some cases the category information is split between the category and series name.

### Consolidate duplicate clubs and remove "childless" clubs

There are currently a number of clubs, which do not have any teams representing them. These are likely clubs which have been originally created as duplicates through a mistake and then the representing team is moved to already exiting club. These could be either deleted from the database, or just not displayed in the page listing all clubs.
Number of such childless teams: TO BE DETERMINED

Additionally there are duplicate clubs entities for a number of clubs. The following list

172 & 5
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

After consolidating these teams / clubs, the newly created childless clubs (no teams representing them) could be deleted or then not shown on the club listing pages

### Add country & city information on all clubs





