import SwiftUI
import Combine

class APIManager {
    static let shared = APIManager()
    
    private var cancellables: Set<AnyCancellable> = []

    private func format(response: HTTPURLResponse, body: String) -> String {
        return "\(response.statusCode):\(body)"
    }

    func sendRequest(url: String, headers: [String: String], method: String, body: String) -> AnyPublisher<String, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body.data(using: .utf8)

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return self.format(response: httpResponse, body: String(data: data, encoding: .utf8) ?? "")
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func bearer(username: String, hash: String, expiry: TimeInterval) -> AnyPublisher<String, Error> {
        let body = "\(username);\(hash);\(expiry)"
        let headers = ["Content-Type": "application/text"]
        return sendRequest(url: "http://localhost:8000/key", headers: headers, method: "GET", body: body)
    }

    func transaction(bearer: String, name: String, amount: Double) -> AnyPublisher<Bool, Error> {
        let body = "\(name);\(amount)"
        let headers = [
            "Content-Type": "application/text",
            "x-bearer": bearer
        ]
        return sendRequest(url: "http://localhost:8000/transaction", headers: headers, method: "POST", body: body)
            .map { $0.contains("OK") }
            .eraseToAnyPublisher()
    }

    func balance(bearer: String) -> AnyPublisher<String, Error> {
        let headers = ["Content-Type": "application/text"]
        return sendRequest(url: "http://localhost:8000/balance/\(bearer)", headers: headers, method: "GET", body: "")
    }

    func transactions(bearer: String) -> AnyPublisher<[String], Error> {
        let headers = ["Content-Type": "application/text"]
        return sendRequest(url: "http://localhost:8000/transactions/\(bearer)", headers: headers, method: "GET", body: "")
            .map { response in
                if let index = response.firstIndex(of: ":") {
                    let startIndex = response.index(after: index)
                    return response[startIndex...].components(separatedBy: "\n")
                } else {
                    return []
                }
            }
            .eraseToAnyPublisher()
    }
}
