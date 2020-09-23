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

### Incorrent and incomplete final standings

There are number of years & series, for which there is no proper final standings list. As one example, there are no final standings for Summer 2018 (and others) because of the tournament format. You can only find the final placings for finals event and for the separate tour events, like 2018 Finals https://www.ultimate.fi/pelikone/?view=teams&season=2018.F&list=bystandings , Tour 3 https://www.ultimate.fi/pelikone/?view=teams&season=2018.T3&list=bystandings , Tour 2 https://www.ultimate.fi/pelikone/?view=teams&season=2018.T2&list=bystandings and Tour 1 https://www.ultimate.fi/pelikone/?view=teams&season=2018.T1&list=bystandings

In other cases, the placings contain additional teams as the finals teams have been given new names like A3, A4 or the teams are created in the system just for finals with the existing name. One example from year 2001 outdoor season is here https://www.ultimate.fi/pelikone/?view=teams&season=2001.1&list=bystandings

## Suggested data improvements

### Consistent series naming and categories

Currently different series category naming conventions are used. Also in some cases the category information is split between the category and series name. 

### Consolidate duplicate clubs and remove "childless" clubs

There are currently a number of clubs, which do not have any teams representing them. These are likely clubs which have been originally created as duplicates through a mistake and then the representing team is moved to already exiting club. These could be either deleted from the database, or just not displayed in the page listing all clubs.

Number of such childless teams: TO BE DETERMINED

Additionally there are duplicate clubs entities for a number of clubs. The following list contains club ids which can be merged with the second id (meaning that the teams blenging to the first club can be moved to point to the second club).
* 172 -> 5
* 77 -> 70
* 82 -> 160
* 21 -> 160
* 14 -> 160
* 111 -> 96
* 169 -> 58
* 121 -> 58
* 74 -> 37
* 104 -> 37
* 173 -> 113
* 107 -> 114
* 163 -> 114
* 168 -> 141
* 126 -> 46
* 18 -> 108
* 159 -> 144
* 166 -> 144
* 112 -> 144
* 109 -> 91
* 122 -> 91
* 119 -> 91
* 161 -> 17
* 118 -> 90
* 162 -> 90
* 150 -> 117

After consolidating these teams / clubs, the newly created childless clubs (no teams representing them) could be deleted or alternatively they should not be shown on the club listing pages.

### Add country & city information on all clubs

The country information is not available for most of the Finnish clubs and there are also good number of foreign clubs which do not seem to have that information. Below is the list of the foreign club ids missing the country information
* Russia 146, 97, 98, 155, 157, 94, 96, 123, 125, 156 , 124, 177, 105, 110
* Estonia 91, 174, 154
* Latvia 141
Rest of the clubs are from Finland.

### Add a parent club for all teams

There are 74 teams (at least) in Pelikone, which do not have club as a parent (meaning that if you try to find those teams from the directions of clubs, you will not find them). Below is a listing of the names of the teams. Most of the teams can be immediately recognized to be part of a club. There are also some teams, for which the parent club can be found (like A3, A4, J1, J2, etc) as those teams are just badly named teams for finals event (this practice has also created problem is final standings for certain years.
* A3
* A4
* Aeroflop
* Disc'O
* Disquitos &amp; UFO
* EUC
* EUC/UFBG
* EePee
* Flying Steps Avoin
* Flying Steps Avoin
* FreezeBees
* Haaga-Helian AMK
* Hamina
* Hazardi
* Hazardi
* Helsingin Yliopisto
* Hut-ilot
* J1
* J2
* Jyväskylä Sleepwalkers
* Jyväskylä Sleepwalkers
* Jyväskylä United
* Jyväskylän yliopisto
* KK&amp;PP
* KK&amp;PP
* Kamaan Ketsup
* Karhukopla
* Kurjaa
* LUC
* LUC
* LUC/Saints
* Lempäälän Kisa
* Mama &amp; Papas
* Mamas &amp; Papas
* Masters-mj
* N3
* N4
* Nasters
* Pros&amp;Mamas&amp;Papas
* Puppets
* SOS
* Saints
* Shadows
* Shadows
* Sisäsuomi United
* Sleepwalkers
* Sun City Ultimate
* TT-lätty
* Tamkon letut
* Team
* Team
* Team 1
* TeamEUC
* Todella Upeeta
* Turku 1
* Turku Terror
* U20
* UFBG
* UFBG
* UFBG
* UFBG
* UFO&amp;Hukka
* Vaasa
* Vaasa
* Vaasa
* Vaasa (n)
* Vaasa Saints
* Vaasa Saints (n)
* ViRHE
* ViRHe
* ViRHe
* WG
* WWW
* Welldone



