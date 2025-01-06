//
//  ErrorHandler.swift
//  MVVM-SwiftUI-Template
//
//  Created by Fabricio Padua on 12/20/24.
//

import Foundation
import Alamofire

enum NetworkError: LocalizedError, Equatable {
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
    
    // Equatable
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL):
            return true
        case (.noData, .noData):
            return true
        case (.decodingError, .decodingError):
            return true
        case (.unknownError, .unknownError):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
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
