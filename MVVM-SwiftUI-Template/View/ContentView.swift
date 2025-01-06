//
//  ContentView.swift
//  MVVM-SwiftUI-Template
//
//  Created by Fabricio Padua on 12/20/24.
//

import SwiftUI
import Combine

struct ErrorMessage: Identifiable {
    var id = UUID()  // Make it Identifiable
    var message: String
}

struct ContentView: View {
    @StateObject private var viewModel = Define_ViewModel()

    var body: some View {
        VStack(spacing: 20) {
            if let modelData = viewModel.modelData {
                Text("User: \(modelData.name)")
                    .font(.system(size: 20))
                
                Text("Email: \(modelData.email)")
                    .font(.system(size: 16))
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .font(.system(size: 18))
            } else {
                Text("Loading...")
                    .font(.system(size: 25))
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetch() // Fetch data when view appears
        }
        .alert(item: $viewModel.errorAlert) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}
