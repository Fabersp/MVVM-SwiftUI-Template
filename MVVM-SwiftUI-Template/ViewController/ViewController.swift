//
//  ViewController.swift
//  MVVM-SwiftUI-Template
//
//  Created by Fabricio Padua on 12/21/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var viewModel = Define_ViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch data when the view loads
        viewModel.fetch()
        
        // Observe error messages
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.handleError(errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
