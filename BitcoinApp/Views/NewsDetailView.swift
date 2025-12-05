import SwiftUI

struct NewsDetailView: View {
    let article: NewsArticle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(article.title)
                    .font(.title2.bold())
                if let description = article.description {
                    Text(description)
                        .font(.body)
                }
                Link("Read full article", destination: URL(string: article.url)!)
                    .padding(.top)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }
}

#Preview {
    NavigationStack {
        NewsDetailView(article: NewsArticle(
            title: "Bitcoin Hits New High Amid ETF Hype",
            description: "Bitcoin price soars as traders anticipate ETF approval from SEC.",
            url: "https://example.com/bitcoin-news",
            publishedAt: Date()
        ))
    }
}
