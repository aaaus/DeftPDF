//
//  SearchbarView.swift
//  DeftPDF
//
//  Created by Aleksandr Andrusenko on 28.12.2023.
//

import SwiftUI

struct SearchbarView: View {
    @Binding var searchText: String
    private var textFieldInFocus: FocusState<Bool>.Binding
    private let doSomething: (String) -> Void
    
    init(
        searchText: Binding<String>,
        textFieldInFocus: FocusState<Bool>.Binding,
        doSomething: @escaping (String) -> Void) {
            self._searchText = searchText
            self.textFieldInFocus = textFieldInFocus
            self.doSomething = doSomething
        }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: 16)
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Search documents", text: $searchText)
                .focused(textFieldInFocus)
                .submitLabel(.done)
                .disableAutocorrection(true)
                .onChange(of: searchText) { value in
                    doSomething(value)
                }
                .padding(.horizontal, 4)
            
            if searchText != "" {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 16)
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
                    .onTapGesture {
                        searchText = ""
                    }
            }
        }
        .frame(height: 36)
        .background(.gray.opacity(0.15))
        .cornerRadius(10)
    }
}
