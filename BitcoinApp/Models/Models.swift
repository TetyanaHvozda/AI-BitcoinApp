import Foundation


struct BitcoinPriceResponse: Decodable {
    let bitcoin: BitcoinPrice
}

struct BitcoinPrice: Decodable {
    let usd: Double
}

struct MarketChartResponse: Codable {
    let prices: [[Double]]  
}


struct NewsArticle: Codable, Identifiable {
    var id = UUID()
    let title: String
    let description: String?
    let url: String
    let publishedAt: Date
    
    enum CodingKeys: String, CodingKey {
            case title, description, url, publishedAt
        }
}


struct SummarizedNews: Identifiable {
    let id = UUID()
    let summaryText: String
    let sourceURLs: [String]
}


struct PriceAlert: Identifiable, Codable {
    let id: UUID
    let targetPrice: Double
    let isAbove: Bool
    var isActive: Bool
}

