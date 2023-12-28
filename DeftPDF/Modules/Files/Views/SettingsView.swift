//
//  SettingsView.swift
//  DeftPDF
//
//  Created by Aleksandr Andrusenko on 28.12.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: FilesViewModel
    
    var body: some View {
        let thumbSize = CGSize(width: 48, height: 64)
        VStack {
            HStack {
                if let url = vm.selectedItem?.url,
                   let pdfDoc = vm.pdfPreview(url: url) {
                    PDFThumbnail(pdfDoc: pdfDoc, size: thumbSize)
                        .frame(width: thumbSize.width + 8, height: thumbSize.height + 8)
                        .cornerRadius(5)
                        .shadow(color: .gray.opacity(0.5), radius: 3, x: 1, y: 1)
                }
                
                VStack {
                    Text(vm.selectedItem?.name ?? "")
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color("MainTextColor"))
                        .font(.custom("OpenSans-Regular", size: 16))
                    
                    Text("\(vm.selectedItem?.creationDate ?? "") • \(vm.selectedItem?.fileSize ?? "")")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color("SubTextColor"))
                        .font(.custom("OpenSans-Regular", size: 14))
                }
                
                Spacer()
            }
            
            Divider()
                .foregroundColor(Color("GrayTextColor"))
                .padding(.vertical, 8)
            
            VStack(spacing: 0) {
                HStack {
                    Text("Edit")
                    
                    Spacer()
                    
                    Image("Edit")
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                
                Divider()
                    .foregroundColor(Color("GrayTextColor"))
                
                HStack {
                    Text("Sign")
                    
                    Spacer()
                    
                    Image("Sign")
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                
                Divider()
                    .foregroundColor(Color("GrayTextColor"))
                
                HStack {
                    Text("Convert to")
                    
                    Spacer()
                    
                    Image("ConvertTo")
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
            }
            .foregroundColor(Color("MainTextColor"))
            .font(.custom("OpenSans-Regular", size: 16))
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color("GrayTextColor"), lineWidth: 1))
            
            VStack(spacing: 0) {
                HStack {
                    Text("Share")
                    
                    Spacer()
                    
                    Image("Share")
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                
                Divider()
                    .foregroundColor(Color("GrayTextColor"))
                
                HStack {
                    Text("Save on device")
                    
                    Spacer()
                    
                    Image("SaveOnDevice")
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                
                Divider()
                    .foregroundColor(Color("GrayTextColor"))
                
                HStack {
                    Text("Save in cloud")
                    
                    Spacer()
                    
                    Image("SaveInCloud")
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                
                Divider()
                    .foregroundColor(Color("GrayTextColor"))
                
                HStack {
                    Text("Rename")
                    
                    Spacer()
                    
                    Image("Rename")
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                
                Divider()
                    .foregroundColor(Color("GrayTextColor"))
                
                HStack {
                    Text("Delete")
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Image("Delete")
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .onTapGesture {
                    vm.removeFile()
                    vm.isShowSettingsView = false
                }
            }
            .foregroundColor(Color("MainTextColor"))
            .font(.custom("OpenSans-Regular", size: 16))
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color("GrayTextColor"), lineWidth: 1))
            .padding(.top, 8)
        }
        .padding(.horizontal, 16)
    }
}

