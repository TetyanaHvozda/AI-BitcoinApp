import SwiftUI

struct BitcoinPriceView: View {
    @StateObject private var viewModel = BitcoinPriceViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Bitcoin Price")
                .font(.largeTitle)
            Text(viewModel.currentPrice)
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .foregroundColor(.orange)

            Button("Refresh") {
                viewModel.fetchPrice()
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .onAppear {
            viewModel.startFetchingPriceEvery10Seconds()
        }
    }
}


struct BitcoinPriceView_Previews: PreviewProvider {
    static var previews: some View {
        BitcoinPriceView()
    }
}
