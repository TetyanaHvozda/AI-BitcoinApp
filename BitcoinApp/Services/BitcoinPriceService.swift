import Foundation

struct BitcoinPriceService {
    static func fetchRealTimePrice(completion: @escaping (Double?) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let decoded = try? JSONDecoder().decode(BitcoinPriceResponse.self, from: data)
            else {
                completion(nil)
                return
            }
            completion(decoded.bitcoin.usd)
        }.resume()
    }
}
