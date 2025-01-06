//
//  Define_ViewModel.swift
//  MVVM-SwiftUI-Template
//
//  Created by Fabricio Padua on 12/20/24.
//

import Combine

class Define_ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var networkService = NetworkService()
    
    @Published var modelData: Define_Model?
    @Published var errorMessage: String?
    @Published var errorAlert: ErrorMessage?  // Updated to hold Identifiable error

    func fetch() {
        networkService.get(endpoint: "weather?q=London")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { (modelData: Define_Model) in
                self.modelData = modelData
            })
            .store(in: &cancellables)
    }

    private func handleError(_ error: Error) {
        // Create an identifiable error message
        if let networkError = error as? NetworkError {
            self.errorAlert = ErrorMessage(message: networkError.errorDescription ?? "An error occurred")
        } else {
            self.errorAlert = ErrorMessage(message: "An unexpected error occurred")
        }
    }
}
