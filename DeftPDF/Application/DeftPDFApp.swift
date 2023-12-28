//
//  DeftPDFApp.swift
//  DeftPDF
//
//  Created by Aleksandr Andrusenko on 28.12.2023.
//

import SwiftUI
import Firebase
import GoogleSignIn  

@main
struct DeftPDFApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView().onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
