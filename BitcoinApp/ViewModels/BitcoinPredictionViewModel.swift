import Foundation

class BitcoinPredictionViewModel: ObservableObject {
    @Published var actualPrices: [Double] = []
    @Published var predictedPrices: [Double] = []
    @Published var dates: [Date] = []

    private let predictionService = BitcoinPredictionService()

    func fetchAndPredict() {
        // Step 1: Fetch historical BTC prices (last N days)
        let urlString = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=30"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let decoded = try? JSONDecoder().decode(MarketChartResponse.self, from: data)
            else { return }

            let allEntries = decoded.prices
            // Convert to [(Date, Double)] first
            let entries: [(Date, Double)] = allEntries.map { (timestampArray) in
                let date = Date(timeIntervalSince1970: timestampArray[0] / 1000)
                let price = timestampArray[1]
                return (date, price)
                    }
            
            // Group by day using Calendar
            let calendar = Calendar.current
            let groupedByDay = Dictionary(grouping: entries) { entry -> Date in
                let components = calendar.dateComponents([.year, .month, .day], from: entry.0)
                return calendar.date(from: components)!
            }
            
            // For each day, pick last price of the day as closing price
            let sortedDays = groupedByDay.keys.sorted()
            var dailyDates: [Date] = []
            var dailyPrices: [Double] = []
            
            for day in sortedDays {
                if let dayEntries = groupedByDay[day] {
                    // Sort by time ascending to get last entry for the day
                    let sortedDayEntries = dayEntries.sorted { $0.0 < $1.0 }
                    if let lastEntry = sortedDayEntries.last {
                        dailyDates.append(day)
                        dailyPrices.append(lastEntry.1)
                    }
                }
                    }

            // Generate predictions based on dailyPrices
            var predictions: [Double] = []
            for i in 1..<dailyPrices.count {
                if let predicted = self.predictionService.predictNextPrice(from: dailyPrices[i - 1]) {
                    predictions.append(predicted)
                } else {
                    predictions.append(0)
                }
            }
            
            // Drop first date to align with predictions
            let adjustedDates = Array(dailyDates.dropFirst())
            let adjustedPrices = Array(dailyPrices.dropFirst())
            
            DispatchQueue.main.async {
                self.actualPrices = adjustedPrices
                self.predictedPrices = predictions
                self.dates = adjustedDates
                        }

        }.resume()
    }
}


