//
//  FilesView.swift
//  DeftPDF
//
//  Created by Aleksandr Andrusenko on 28.12.2023.
//

import SwiftUI
import WrappingStack

struct FilesView: View {
    @StateObject private var vm = FilesViewModel()
    @State private var isShowDocumentsPicker = false
    @FocusState private var textFieldInFocus: Bool
    private let itemWidth = (UIScreen.screenWidth / 3) - 18
    
    var body: some View {
        let thumbSize = CGSize(width: itemWidth - 48, height: itemWidth - 16)
        VStack(spacing: 0) {
            HStack {
                Text("My Files")
                    .foregroundColor(Color("MainTextColor"))
                    .font(.custom("OpenSans-Bold", size: 24))
                
                Spacer()
                
                Image("Bell")
                
                Image("More")
                    .padding(.leading, 4)
            }
            
            SearchbarView(searchText: $vm.searchText, textFieldInFocus: $textFieldInFocus) { _ in }
                .padding(.vertical, 12)
            
            ScrollView(.vertical, showsIndicators: true) {
                WrappingHStack(id: \.self,
                               alignment: .leading,
                               horizontalSpacing: 8,
                               verticalSpacing: 24
                ) {
                    
                    ForEach(vm.localFiles, id: \.self) { item in
                        VStack(spacing: 4) {
                            if let pdfDoc = vm.pdfPreview(url: item.url) {
                                PDFThumbnail(pdfDoc: pdfDoc, size: thumbSize)
                                    .frame(width: itemWidth - 32, height: itemWidth - 8)
                                    .cornerRadius(5)
                                    .shadow(color: .gray.opacity(0.5), radius: 3, x: 1, y: 1)
                            }
                            
                            Text(item.name)
                                .multilineTextAlignment(.center)
                                .lineLimit(2, reservesSpace: true)
                                .foregroundColor(Color("MainTextColor"))
                                .font(.custom("OpenSans-Regular", size: 14))
                            
                            Text("\(item.creationDate) • \(item.fileSize)")
                                .foregroundColor(Color("SubTextColor"))
                                .font(.custom("OpenSans-Regular", size: 11))
                            
                            Button {
                                textFieldInFocus = false
                                vm.selectedItem = item
                                vm.isShowSettingsView = true
                            } label: {
                                Text("• • •")
                                    .foregroundColor(Color("DotsColor"))
                                    .font(.custom("OpenSans-SemiBold", size: 10))
                                    .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color("GrayTextColor")))
                            }
                            .padding(.top, 4)
                            
                        }
                        .frame(width: itemWidth)
                        .onTapGesture {
                            textFieldInFocus = false
                            vm.pdfDoc(url: item.url)
                        }
                    }
                }
                .padding(.top, 8)
                
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        .background(Color("Background"))
        .onTapGesture {
            textFieldInFocus = false
        }
        .overlay(alignment: .bottomTrailing) {
            if !textFieldInFocus {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Image("Plus")
                            .padding(8)
                            .onTapGesture {
                                isShowDocumentsPicker.toggle()
                            }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $vm.isShowPdfView) {
            VStack {
                HStack {
                    vm.buttonBack() {
                        vm.isShowPdfView.toggle()
                    }
                    .padding(.leading, 16)
                    Spacer()
                }
                
                if let pdfDoc = vm.pdfDoc {
                    PDFKitView(pdfDoc: pdfDoc)
                }
            }
        }
        .sheet(isPresented: $vm.isShowSettingsView) {
            SettingsView()
                .environmentObject(vm)
                .presentationDetents([.height(550)])
                .presentationBackground(.white)
                .presentationCornerRadius(12)
                .presentationDragIndicator(.visible)
        }
        .fileImporter(isPresented: $isShowDocumentsPicker,
                      allowedContentTypes: [.pdf],
                      allowsMultipleSelection: true) { (result) in
            vm.copyFiles(result: result)
            
        }
    }
}
