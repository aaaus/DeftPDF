//
//  PDFThumbnail.swift
//  DeftPDF
//
//  Created by Aleksandr Andrusenko on 28.12.2023.
//

import SwiftUI
import PDFKit

struct PDFThumbnail: UIViewRepresentable {
    var pdfDoc: PDFDocument
    var size: CGSize
    
    func makeUIView(context: Context) -> PDFThumbnailView {
        let thumbnail = PDFThumbnailView()
        let pdfView = PDFView()
        pdfView.document = pdfDoc
        thumbnail.pdfView = pdfView
        thumbnail.thumbnailSize = size
        thumbnail.layoutMode = .vertical
        return thumbnail
    }
    
    func updateUIView(_ uiView: PDFThumbnailView, context: Context) {
    }
}
