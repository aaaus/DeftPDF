//
//  MainView.swift
//  DeftPDF
//
//  Created by Aleksandr Andrusenko on 28.12.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            TabView {
                FilesView()
                    .tabItem {
                        Label("Files", image: "Files")
                    }
                
                ToolsView()
                    .tabItem {
                        Label("Tools", image: "Tools")
                    }
                
                AccountView()
                    .tabItem {
                        Label("Account", image: "Account")
                    }
            }
            .accentColor(Color("Purple"))
            
            VStack {
                Spacer()
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(Color("LightGrayColor"))
                    .padding(.bottom, 52)
            }
        }
    }
}
