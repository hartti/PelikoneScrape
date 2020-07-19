//
//  ContentView.swift
//  PelikoneScrape
//
//  Created by Hartti Suomela on 19/7/20.
//  Copyright © 2020 Linnani. All rights reserved.
//

import SwiftUI
import Theo
import SwiftSoup

struct ContentView: View {
    @State private var hostname = "18.207.236.67"
    @State private var port = 35536
    @State private var username = "neo4j"
    @State private var password = "arrivals-nights-governments"
    @State private var pelikoneBaseUrl = "https://www.ultimate.fi/pelikone/"
    
    @State private var scrapeDisabled = true
    
    @State private var neo4jClient: BoltClient? = nil
    
    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Neo4j hostname").bold()
                    TextField("Neo4j hostname", text: $hostname)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Neo4j server port").bold()
                    TextField("Neo4j server port", value: $port, formatter: NumberFormatter())
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Neo4j username").bold()
                    TextField("Neo4j username", text: $username)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Neo4j password").bold()
                    SecureField("Neo4j password", text: $password)
                }
                Spacer()
                Button("Connect") {
                    // Connect to server
                    self.neo4jClient = self.connect(hostname: self.hostname, port: self.port, username: self.username, password: self.password)
                    self.scrapeDisabled = (self.neo4jClient == nil)
                }
            }
            .padding()
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Pelikone base url").bold()
                    TextField("Pelikone base url", text: $pelikoneBaseUrl)
                }
                Spacer()
                Button("Scrape pelikone") {
                    // scrape from start
                }
                .disabled(scrapeDisabled)
            }
            .padding()
        }
    }
    
    func connect(hostname: String, port: Int, username: String, password: String) -> BoltClient? {
        // add some data validation here, but for now trust that the Neo4j server details are correct
        do {
            let client = try BoltClient(hostname: hostname,
                                  port: port,
                                  username: username,
                                  password: password,
                                  encrypted: true)
            return client
        } catch {
            print("Probleema")
            return nil
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
