//
//  ContentView.swift
//  BitcoinApp
//
//  Created by Tetyana Hvozda on 23.07.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
                    List {
                        NavigationLink("📈 Current Bitcoin Price", destination: BitcoinPriceView())
                        NavigationLink("🔔 Set Price Alert", destination: PriceAlertSettingsView())
                        NavigationLink("📰 Crypto News", destination: CryptoNewsView())
                        NavigationLink("📊 Prediction", destination: BitcoinPredictionView())
                    }
                    .navigationTitle("Bitcoin App")
                }
            }
}

#Preview {
    ContentView()
}
