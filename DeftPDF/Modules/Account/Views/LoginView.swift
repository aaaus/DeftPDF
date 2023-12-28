//
//  LoginView.swift
//  DeftPDF
//
//  Created by Aleksandr Andrusenko on 28.12.2023.
//

import SwiftUI

struct LoginView: View {
    @State private var err : String = ""
    
    var body: some View {
        Button{
            Task {
                do {
                    try await Authentication().googleOauth()
                } catch let e {
                    print(e)
                    err = e.localizedDescription
                }
            }
        }label: {
            HStack {
                Image(systemName: "person.badge.key.fill")
                Text("Sign in with Google")
            }.padding(8)
        }.buttonStyle(.borderedProminent)
        
        Text(err).foregroundColor(.red).font(.caption)
    }
}
