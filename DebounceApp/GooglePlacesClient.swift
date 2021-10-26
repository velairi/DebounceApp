//
//  GooglePlacesClient.swift
//  DebounceApp
//
//  Created by Valerie Don on 10/19/21.
//

import Foundation

enum GooglePlacesClient {
    case search(SearchRequest)

    static let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?")!
    static let secretKey = "AIzaSyC3s4DuNYs_SccOm3ZvXlozsMeQzuiMbHo" //USE YOUR OWN
    static let encoder = JSONEncoder()
    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    enum HTTPMethod: String {
        case post
        case delete
        case get
        case patch
    }

    var method: HTTPMethod {
        switch self {
        case .search:
            return .post
        }
    }

    var queries: [URLQueryItem] {
        switch self {
        case .search(let request):
            let urlQueryItem = URLQueryItem(name: "input", value: request.query)
            let urlQueryItem2 = URLQueryItem(name: "key", value: Self.secretKey)
            return [urlQueryItem, urlQueryItem2]
        }
    }

    var path: URL {
        switch self {
        case .search:
            var components = URLComponents(url: Self.baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems = queries
            guard let url = components?.url else {
                return Self.baseURL
            }
            return url
        }
    }

    var body: Data? {
        switch self {
        case .search(let request):
            return try? Self.encoder.encode(request)
        }
    }

    var request: URLRequest {
        var request = URLRequest(url: path)
        request.httpBody = body
        request.httpMethod = method.rawValue
        return request
    }

    func execute<T: Decodable>(forResponse response: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decoded = try Self.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
