//
//  ListCellView.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import SwiftUI

struct ListCellView: View {
    var displayedData: DisplayedData
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                logoView
                Spacer()
                infoView
                Spacer()
                suplimentalView
            }
            
            if isExpanded {
                additionalListView
                    .transition(.scale.combined(with: .slide))
            }
        }
    }
}

extension ListCellView {
    
    @ViewBuilder
    var logoView: some View {
        if let imageURL = displayedData.imageUrl {
            AsyncImage(urlString: imageURL)
                .frame(height: 30)
                .cornerRadius(15)
        }
    }
    
    @ViewBuilder
    var infoView: some View {
        VStack {
            Text(displayedData.title)
                .font(.system(.title))
                .foregroundStyle(.black)
            
            Text(displayedData.subTitle)
                .font(.system(.title2))
                .foregroundStyle(.black.opacity(0.75))
        }
    }
    
    @ViewBuilder
    var additionalListView: some View {
        if isExpanded, let list = displayedData.additionalInfo {
            List {
                ForEach(list, id: \.self) { model in
                    Text(model)
                }
            }
        }
    }
    
    @ViewBuilder
    var suplimentalView: some View {
        if displayedData.hasChevron {
            HStack {
                Text("Expand")
                Image(systemName: "chevron.\(isExpanded ? "down" : "forward")")
            }
        }
    }
}
