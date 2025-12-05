import SwiftUI

struct CryptoNewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("📰 Today's Bitcoin News Summary")
                        .font(.headline)
                        .padding(.horizontal)
                    Text(viewModel.summary)
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Crypto News")
                        .font(.title2.bold())
                        .padding(.horizontal)
                    
                    ForEach(viewModel.articles) { article in
                        NavigationLink(destination: NewsDetailView(article: article)) {
                            VStack(alignment: .leading) {
                                Text(article.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(article.publishedAt, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .onAppear { viewModel.fetchNews() }
        }
    }
}

#Preview {
    CryptoNewsView()
}
