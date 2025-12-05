import Foundation

class CohereSummaryService {
    private let apiKey = ""

        func summarize(headlines: [String], completion: @escaping (String?) -> Void) {
            let joinedText = headlines.joined(separator: "\n")
            let prompt = "Summarize the following Bitcoin news headlines in 2-3 sentences:\n\(joinedText)"

            guard let url = URL(string: "https://api.cohere.ai/v1/chat") else {
                completion(nil)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "chat_history": [],
                "message": prompt,
                "model": "command-r-plus-08-2024", 
                "temperature": 0.5,
                "max_tokens": 200
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let text = json["text"] as? String
                else {
                    completion(nil)
                    return
                }

                completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
            }.resume()
        }
}
