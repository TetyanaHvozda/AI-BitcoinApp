import Foundation

class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var summary: String = "Loading summary..."

    func fetchNews() {
        NewsService.shared.fetchBitcoinNews { [weak self] articles in
            DispatchQueue.main.async {
                self?.articles = articles

                let topHeadlines = Array(articles.prefix(3)).map { $0.title }
                print("🔍 Top Headlines to summarize: \(topHeadlines)")
                CohereSummaryService().summarize(headlines: topHeadlines) { summary in
                    DispatchQueue.main.async {
                        self?.summary = summary ?? "Summary unavailable."
                    }
                }
            }
        }
    }
}
