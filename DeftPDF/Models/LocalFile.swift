//
//  LocalFile.swift
//  DeftPDF
//
//  Created by Aleksandr Andrusenko on 28.12.2023.
//

import Foundation

struct LocalFile: Hashable {
    let name: String
    let url: URL
    let creationDate: String
    let fileSize: String
}
