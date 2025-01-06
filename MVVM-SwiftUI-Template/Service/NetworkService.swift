//
//  NetworkService.swift
//  MVVM-SwiftUI-Template
//
//  Created by Fabricio Padua on 12/20/24.
//
import Alamofire
import Combine

class NetworkService {

    private let apiKey = "MY_API_KEY" // Your API key
    private let baseURL = "https://api.example.com/" // Base URL of your API

    // Method to generate the full URL with query parameters
    private func makeURL(_ endpoint: String) -> URL? {
        var components = URLComponents(string: baseURL + endpoint)
        components?.queryItems = [
            URLQueryItem(name: "appid", value: apiKey), // Your API key
        ]
        return components?.url
    }

    // Generic GET Request using Combine
    func get<T: Decodable>(endpoint: String) -> AnyPublisher<T, NetworkError> {
        guard let url = makeURL(endpoint) else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }

        return AF.request(url, method: .get)
            .validate()
            .publishData()
            .tryMap { response in
                guard let data = response.data else {
                    throw NetworkError.noData
                }
                return try JSONDecoder().decode(T.self, from: data)
            }
            .catch { error in
                // Use Fail to convert the error to NetworkError and pass it to the pipeline
                Fail(error: ErrorHandler.handle(error: error)) // Convert the error to NetworkError
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // Generic POST Request using Combine
    func post<T: Decodable, U: Encodable>(endpoint: String, body: U) -> AnyPublisher<T, NetworkError> {
        let url = baseURL + endpoint

        return AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default)
            .validate()
            .publishData()
            .tryMap { response in
                guard let data = response.data else {
                    throw NetworkError.noData
                }
                return try JSONDecoder().decode(T.self, from: data)
            }
            .catch { error in
                Fail(error: ErrorHandler.handle(error: error))  // Convert the error to NetworkError
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // Generic PUT Request using Combine
    func put<T: Decodable, U: Encodable>(endpoint: String, body: U) -> AnyPublisher<T, NetworkError> {
        let url = baseURL + endpoint

        return AF.request(url, method: .put, parameters: body, encoder: JSONParameterEncoder.default)
            .validate()
            .publishData()
            .tryMap { response in
                guard let data = response.data else {
                    throw NetworkError.noData
                }
                return try JSONDecoder().decode(T.self, from: data)
            }
            .catch { error in
                Fail(error: ErrorHandler.handle(error: error))  // Convert the error to NetworkError
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // Generic DELETE Request using Combine
    func delete<T: Decodable>(endpoint: String) -> AnyPublisher<T, NetworkError> {
        let url = baseURL + endpoint

        return AF.request(url, method: .delete)
            .validate()
            .publishData()
            .tryMap { response in
                guard let data = response.data else {
                    throw NetworkError.noData
                }
                return try JSONDecoder().decode(T.self, from: data)
            }
            .catch { error in
                Fail(error: ErrorHandler.handle(error: error))  // Convert the error to NetworkError
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
