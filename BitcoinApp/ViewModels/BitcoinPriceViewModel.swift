import Foundation

class BitcoinPriceViewModel: ObservableObject {
    @Published var currentPrice: String = "--"
    private var timer: Timer?
    
    func startFetchingPriceEvery10Seconds() {
            // Immediately fetch once
            fetchPrice()

            // Then every 10 seconds
            timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
                print("🔄 Timer triggered: Attempting to fetch latest Bitcoin price...")
                self.fetchPrice()
            }
        }

        func stopFetching() {
            timer?.invalidate()
            timer = nil
        }

    func fetchPrice(retries: Int = 2) {
        BitcoinPriceService.fetchRealTimePrice { [weak self] price in
            DispatchQueue.main.async {
                
                guard let self = self else { return }
                
                if let price = price {
                    self.currentPrice = String(format: "$%.2f", price)
                    
                    
                    PriceAlertManager.shared.checkAndNotify(currentPrice: price)
                } else if retries > 0 {
                    print("⚠️ Fetch failed, retrying...")
                    self.fetchPrice(retries: retries - 1)
                } else {
                    print("❌ Failed to fetch price after retries")
                    self.currentPrice = "Error"
                }
            }
        }
    }
}

