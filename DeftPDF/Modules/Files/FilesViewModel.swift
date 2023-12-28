//
//  FilesViewModel.swift
//  DeftPDF
//
//  Created by Aleksandr Andrusenko on 28.12.2023.
//

import SwiftUI
import PDFKit

class FilesViewModel: ObservableObject {
    @Published var localFiles = [LocalFile]()
    @Published var isShowPdfView = false
    @Published var isShowSettingsView = false
    @Published var pdfDoc: PDFDocument?
    @Published var searchText = ""
    var selectedItem: LocalFile?
    
    private var allLocalFiles = [LocalFile]()
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    init() {
        getLocalFiles()
        
        $searchText
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .map { text in
                if text.count >= 2 {
                    return self.localFiles.filter { item in
                        item.name.lowercased().contains(text.lowercased())
                    }
                } else {
                    return self.allLocalFiles
                }
            }
            .assign(to: &$localFiles)
    }
    
    func copyFiles(result: Result<[URL], Error>) {
        do {
            saveFile(fileURLs: try result.get())
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
        
        getLocalFiles()
    }
    
    private func saveFile(fileURLs: [URL]) {
        fileURLs.forEach { url in
            do {
                let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
                try FileManager.default.copyItem(at: url, to: destinationURL)
            }
            catch {
                print("Save Error: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFile() {
        if let fileURL = selectedItem?.url,
           FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                getLocalFiles()
            } catch {
                print("Remove Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func getLocalFiles() {
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: nil
            ).filter {
                $0.lastPathComponent.suffix(4) == ".pdf"
            }
            
            allLocalFiles.removeAll()
            
            directoryContents
                .forEach { url in
                    allLocalFiles.append(LocalFile(name: url.lastPathComponent,
                                                   url: url,
                                                   creationDate: creationDate(url: url) ?? "",
                                                   fileSize: fileSize(fromPath: url.path) ?? ""))
                }
            
            searchText = ""
        } catch {
            print(error)
        }
    }
    
    func pdfPreview(url: URL) -> PDFView? {
        guard let pdfDoc = PDFDocument(url: url) else {
            return nil
        }
        let pdfView = PDFView()
        pdfView.document = pdfDoc
        
        return pdfView
    }
    
    func pdfDoc(url: URL) {
        guard let pdfDoc = PDFDocument(url: url) else { return }
        isShowPdfView = true
        self.pdfDoc = pdfDoc
        
    }
    
    private func creationDate(url: URL) -> String? {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) as [FileAttributeKey: Any],
           let date = attributes[.creationDate] as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.YYYY"
            return formatter.string(from: date)
        }
        return nil
    }
    
    private func fileSize(fromPath path: String) -> String? {
        guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
              let fileSize = size as? UInt64 else {
            return nil
        }
        
        if fileSize < 1023 {
            return String(format: "%lu bytes", CUnsignedLong(fileSize))
        }
        
        var floatSize = Float(fileSize / 1024)
        if floatSize < 1023 {
            return String(format: "%.0f KB", floatSize)
        }
        
        floatSize = floatSize / 1024
        if floatSize < 1023 {
            return String(format: "%.1f MB", floatSize)
        }
        
        floatSize = floatSize / 1024
        return String(format: "%.1f GB", floatSize)
    }
    
    func buttonBack(completion: @escaping () -> ()) -> some View {
        var btnBack: some View {
            ZStack {
                HStack {
                    Button {
                        completion()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                
                Color.gray.opacity(0.0001)
                    .frame(width: 64, height: 36)
                    .onTapGesture {
                        completion()
                    }
            }
        }
        return btnBack
    }
}
