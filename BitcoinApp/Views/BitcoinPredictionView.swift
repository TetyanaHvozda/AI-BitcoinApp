import SwiftUI

struct BitcoinPredictionView: View {
    @StateObject private var viewModel = BitcoinPredictionViewModel()

    var body: some View {
        VStack {
            if viewModel.actualPrices.isEmpty {
                ProgressView("Loading predictions...")
            } else {
                
                // Show predicted price for tomorrow
                if let tomorrowPrice = viewModel.predictedPrices.last {
                    Text("Bitcoin Price Tomorrow: $\(String(format: "%.2f", tomorrowPrice))")
                        .font(.headline)
                        .padding(.top)
                }
                
                PricePredictionChartView(
                    actual: viewModel.actualPrices,
                    predicted: viewModel.predictedPrices,
                    dates: viewModel.dates
                )
            }

            Button("Refresh Prediction") {
                viewModel.fetchAndPredict()
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchAndPredict()
        }
    }
}
#Preview {
    BitcoinPredictionView()
}


