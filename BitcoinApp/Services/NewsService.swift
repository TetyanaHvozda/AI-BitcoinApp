import Foundation

class NewsService {
    static let shared = NewsService()
    private init() {}

    func fetchBitcoinNews(completion: @escaping ([NewsArticle]) -> Void) {
        let apiKey = ""
        let urlString = "https://newsapi.org/v2/everything?q=bitcoin&sortBy=publishedAt&language=en&apiKey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                    print("News API error: \(error.localizedDescription)")
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("News API status code: \(httpResponse.statusCode)")
                }

                guard let data = data else {
                    print("No data received.")
                    completion([])
                    return
                }
            let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                do {
                    let decoded = try decoder.decode(NewsAPIResponse.self, from: data)
                    completion(decoded.articles)
                } catch {
                    print("Decoding error: \(error)")
                    completion([])
                }
            }.resume()
    }
}

struct NewsAPIResponse: Codable {
    let articles: [NewsArticle]
}

