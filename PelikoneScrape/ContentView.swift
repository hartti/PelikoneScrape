//
//  ContentView.swift
//  PelikoneScrape
//
//  Created by Hartti Suomela on 19/7/20.
//  Copyright © 2020 Linnani. All rights reserved.
//

import SwiftUI
import SwiftSoup

struct ContentView: View {
    @State private var pelikoneBaseUrl = "https://www.ultimate.fi/pelikone/"
    let clubList = "?view=allclubs&list=all"
    let playerList = "?view=allplayers&list=all"
    
    @State private var pelikoneCurrentSeason = "Kesä 2020"  // this could be found from the Web page as well we will use this as a hard coded value for now

    @State private var scrapeDelay = 2.0  // default in seconds, can be changed

    @State private var scrapeLimitOn = false    // by default run through all entries
    private let scrapeLimit = 200     // for testing purposes, only used when scrapeLimitOn is true
    
    @State private var noOfItemsToSkip = 0
    
    @State private var csvForClubs = ""
    @State private var csvForTeams = ""
    @State private var csvForPlayers = ""
    @State private var csvForRoster = ""

    
    private var startTime = Date()
    
    @State private var scrapeDisabled = false        // true by default, turns on when connection is available
    
    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Pelikone base url").bold()
                    TextField("Pelikone base url", text: $pelikoneBaseUrl)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Pelikone current season").bold()
                    TextField("Talvi 2020", text: $pelikoneCurrentSeason)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text("Number of items to skip").bold()
                    TextField("0", value: $noOfItemsToSkip, formatter: NumberFormatter())
                }
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text("Scrape delay between pages is \(Int(scrapeDelay)) s").bold()
                    Slider(value: $scrapeDelay, in: 0...20)
                }
                HStack(alignment: .center, spacing: 0) {
                    Toggle(isOn: $scrapeLimitOn) {
                        Text("Limit scrapes to \(scrapeLimit) entities").bold()
                    }
                    Spacer()
                }
                Spacer()
                Button("1. Scrape Clubs and Teams") {
                    // scrape from start
                    self.startClubAndTeamScrape()
                    // self.scrapeTeamsForClub(clubUrl: self.pelikoneBaseUrl + "?view=clubcard&club=5", clubNode: nil)
                }
                .disabled(scrapeDisabled)
                Button("2. Scrape Players") {
                    // scrape utilizing Team data already in the db, Clubs and Teams have been scraped
                    self.startPlayerScrape()
                }
                .disabled(scrapeDisabled)
            }
            .padding()
            VStack {
                Text("Resulting CSV for Clubs").bold()
                TextField("CSV here", text: $csvForClubs)
                Spacer()
            }
            .padding()
            VStack {
                Text("Resulting CSV for Teams").bold()
                TextField("CSV here", text: $csvForTeams)
                Spacer()
            }
            .padding()
            VStack {
                Text("Resulting CSV for Players").bold()
                TextField("CSV here", text: $csvForPlayers)
                Spacer()
            }
            .padding()
            VStack {
                Text("Resulting CSV for Roster").bold()
                TextField("CSV here", text: $csvForRoster)
                Spacer()
            }
            .padding()
        }
    }
    
    func startClubAndTeamScrape() {
        let url = URL(string: pelikoneBaseUrl + clubList)!

        print("Loading club list")
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            print("Club list loaded")
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    self.goThroughClubs(htmlString: string)
                }
            }
        }
        task.resume()
    }
    
    func goThroughClubs(htmlString: String) {
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            let links: Elements = try doc.select("a[href~=.+club\\=\\d+]")
            print("Found \(links.count) clubs")
            for (index, link) in links.enumerated() {
                if scrapeLimitOn && index >= scrapeLimit {
                    print("in Break, index passes scrapeLimit")
                    break
                }
                print("Evaluating \(index). club, scrape limit is \(scrapeLimit)" )
                let clubName = try link.text()
                let linkUrl = try link.attr("href")
                var firstIdChar = linkUrl.lastIndex(of: "=")!
                firstIdChar = htmlString.index(firstIdChar, offsetBy: 1)
                let linkId = String(linkUrl[firstIdChar...])
                print("\(clubName) \(linkId) \(linkUrl)")
                print()
                let csvLine = "\"\(clubName)\",\"\(linkId)\",\"\(linkUrl)\"\n"
                csvForClubs = csvForClubs + csvLine
                DispatchQueue.main.asyncAfter(deadline: .now() + scrapeDelay * Double(index)) {
                    self.scrapeTeamsForClub(clubUrl: self.pelikoneBaseUrl + linkUrl, clubId: linkId)
                }
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    func scrapeTeamsForClub(clubUrl: String, clubId: String) {
        let url = URL(string: clubUrl)!
        
        print("Loading \(clubUrl) \(Int(startTime.distance(to: Date()))) after start")
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            print("Finished loading \(clubUrl)")
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    self.goThroughTeams(htmlString: string, clubId: clubId)
                }
            }
        }
        task.resume()
    }
    
    func goThroughTeams(htmlString: String, clubId: String) {
        do {
            var seasonBufferCount = 0
            let doc: Document = try SwiftSoup.parse(htmlString)
            let teamNameLinks: Elements = try doc.select("a[href~=.+teamcard.+team\\=\\d+]")
            let seriesLinks: Elements = try doc.select("a[href~=.+poolstatus.+series\\=\\d+]")
            let seasonData = try doc.select("h2:containsOwn(historia) ~ table  td[style=width:20%]:matches(.{4,10}\\s\\d{4})")
            print("Found \(teamNameLinks.count) and \(seriesLinks.count) and \(seasonData.count) teams for Club")
            if teamNameLinks.count == seriesLinks.count && seasonData.count < teamNameLinks.count {
                seasonBufferCount = teamNameLinks.count - seasonData.count
            }
            for (index, link) in teamNameLinks.enumerated() {
                if scrapeLimitOn && index >= scrapeLimit {
                    break
                }
                let series = try seriesLinks[index].text()
                var season = ""
                if (index < seasonBufferCount) {
                    season = pelikoneCurrentSeason
                } else {
                    season = try seasonData[index - seasonBufferCount].text()
                }
                let teamName = try link.text()
                let linkUrl = try link.attr("href")
                var firstIdChar = linkUrl.lastIndex(of: "=")!
                firstIdChar = htmlString.index(firstIdChar, offsetBy: 1)
                let linkId = String(linkUrl[firstIdChar...])
                print("\(season) \(series): \(teamName) \(linkId) \(linkUrl)\n")
                let csvLine = "\"\(teamName)\",\"\(season)\",\"\(series)\",\"\(linkId)\",\"\(linkUrl)\",\"\(clubId)\"\n"
                csvForTeams = csvForTeams + csvLine
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }

    func startPlayerScrape() {
        let url = URL(string: pelikoneBaseUrl + playerList)!

        print("Loading player list")
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            print("Player list loaded")
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    self.goThroughPlayers(htmlString: string)
                }
            }
        }
        task.resume()
    }
    
    func goThroughPlayers(htmlString: String) {
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            let links: Elements = try doc.select("a[href~=.+player\\=\\d+]")
            print("Found \(links.count) players")
            for (index, link) in links.enumerated() {
                if scrapeLimitOn && index >= scrapeLimit + noOfItemsToSkip {
                    print("in Break, index passes scrapeLimit")
                    break
                }
                if index >= noOfItemsToSkip {
                    print("Evaluating \(index). player, scrape limit is \(scrapeLimit)" )
                    let playerName = try link.text()
                    let playerUrl = try link.attr("href")
                    var firstIdChar = playerUrl.lastIndex(of: "=")!
                    firstIdChar = htmlString.index(firstIdChar, offsetBy: 1)
                    let playerId = String(playerUrl[firstIdChar...])
                    print("\(playerName) \(playerId) \(playerUrl)\n")
                    DispatchQueue.main.asyncAfter(deadline: .now() + scrapeDelay * Double(index-noOfItemsToSkip)) {
                        self.scrapeTeamsForPlayer(playerId: playerId, playerName: playerName, playerUrl: playerUrl)
                    }
                }
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    func scrapeTeamsForPlayer(playerId: String, playerName: String, playerUrl: String) {
        let url = URL(string: pelikoneBaseUrl + playerUrl)!
        
        print("Loading \(playerUrl) \(Int(startTime.distance(to: Date()))) after start")
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            print("Finished loading \(playerUrl)")
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    self.getTeamsForPlayer(htmlString: string, playerId: playerId, playerName: playerName, playerUrl: playerUrl)
                }
            }
        }
        task.resume()
    }
    
    func getTeamsForPlayer(htmlString: String, playerId: String, playerName: String, playerUrl: String) {
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            let secondaryName = try doc.select("h1").first()!.text()
            print("\(secondaryName)")

            let csvLine = "\"\(playerName)\",\"\(secondaryName)\",\"\(playerId)\",\"\(playerUrl)\"\n"
            csvForPlayers = csvForPlayers + csvLine

            let tableElements: Elements = try doc.select("table")
            print("Table elements on page \(tableElements.count)")
            let noOfTables = tableElements.count
            for i in 1...noOfTables {
                let teamsTableElement: Element = tableElements.get(noOfTables-i).child(0)
                if try! teamsTableElement.child(0).child(0).html() == "Tapahtuma" {
                    for row in teamsTableElement.children() {
                        let season = try row.child(0).html()
                        if season != "Tapahtuma" {
                            let series = try row.child(1).html()
                            let teamName = try row.child(2).html()
                            
                            let csvLine = "\"\(playerId)\",\"\(season)\",\"\(series)\",\"\(teamName)\"\n"
                            csvForRoster = csvForRoster + csvLine

                            let cypherString = "match (t:Team), (p:Player) where t.season = \"\(season)\" and t.series = \"\(series)\" and t.name = \"\(teamName)\" and p.id = \"\(playerId)\" merge (p)-[r:PLAYS_FOR]->(t) \n"
                            print(cypherString)
        //                    let result = neo4jClient!.executeCypherSync(cypherString)
                        }
                    }
                    break
                }
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
        
    func getTeamDetails(htmlString: String, teamId: String) {
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            let seasonData = try doc.select("span.profileheader").first()
            let splitSD = try seasonData!.text().split(separator: " ")
            let season = splitSD[0]
            let year = splitSD[1]
            let series = try doc.select("a[href~=.+poolstatus.+series\\=\\d+]").first()?.text()
            print("Extracted \(season) \(year) \(series)")
            let links: Elements = try doc.select("a[href~=.+playercard.+player\\=\\d+]")
            print("Found \(links.count) Players for Team")
            for (index, link) in links.enumerated() {
                if scrapeLimitOn && index >= scrapeLimit {
                    break
                }
                let playerName = try link.text()
                let linkUrl = try link.attr("href")
                var firstIdChar = linkUrl.lastIndex(of: "=")!
                firstIdChar = htmlString.index(firstIdChar, offsetBy: 1)
                let linkId = String(linkUrl[firstIdChar...])
                print("Adding player \(playerName) \(linkId) \(linkUrl)")
                print()
//                let playerNode = createNode(nodeLabel: "Player", properties: ["name": playerName, "id": linkId, "href": linkUrl])!
//                neo4jClient!.relateSync(node: playerNode, to: teamNode, type: "PLAYS_FOR")
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
