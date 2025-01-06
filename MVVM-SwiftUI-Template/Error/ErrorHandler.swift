//
//  ErrorHandler.swift
//  MVVM-SwiftUI-Template
//
//  Created by Fabricio Padua on 12/20/24.
//

import Foundation
import Alamofire

enum NetworkError: LocalizedError {
    case badURL
    case noData
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .decodingError:
            return "Failed to decode data"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
    
    var alertTitle: String {
        switch self {
        case .badURL:
            return "URL Error"
        case .noData:
            return "Data Error"
        case .serverError:
            return "Server Error"
        case .decodingError:
            return "Decoding Error"
        case .unknownError:
            return "Unknown Error"
        }
    }
}

class ErrorHandler {
    
    static func handle(error: Error) -> NetworkError {
        // Check if the error is a server error
        if error is URLError {
            return NetworkError.badURL
        }
        
        // Handle Alamofire validation errors
        if let afError = error as? AFError {
            switch afError {
            case .responseValidationFailed(let reason):
                if case .unacceptableStatusCode(let code) = reason {
                    return NetworkError.serverError(statusCode: code)
                }
            default:
                return NetworkError.unknownError
            }
        }
        
        // Handle generic network error (unknown)
        return NetworkError.unknownError
    }
}
