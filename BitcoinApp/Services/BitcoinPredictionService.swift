import CoreML

class BitcoinPredictionService {
    private let model: BitcoinPricePredictor
    
    init() {
            do {
                let config = MLModelConfiguration()
                model = try BitcoinPricePredictor(configuration: config)
            } catch {
                fatalError("❌ Failed to load BitcoinPricePredictor model: \(error)")
            }
        }

    func predictNextPrice(from currentPrice: Double) -> Double? {
        do {
            let prediction = try model.prediction(previous_price: currentPrice)
            return prediction.predicted_price
        } catch {
            print("Prediction error: \(error)")
            return nil
        }
    }
}
