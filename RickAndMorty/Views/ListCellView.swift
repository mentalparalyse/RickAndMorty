//
//  ListCellView.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import SwiftUI

struct ListCellView: View {
    var displayedData: DisplayedData
    var servicesContainer: ServicesContainerProtocol
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 5) {
                logoView
                infoView
                Spacer()
                suplimentalView
            }
            
            if isExpanded {
                additionalListView
                    .transition(.scale.combined(with: .slide))
            }
        }
        .padding(.horizontal, 5)
    }
}

extension ListCellView {
    @ViewBuilder
    var logoView: some View {
        if let imageURL = displayedData.imageUrl {
            AsyncImage(cacher: servicesContainer.imageCacherService, urlString: imageURL)
                .frame(height: 45)
                .clipShape(Circle())
//                .cornerRadius(15)
        }
    }
    
    @ViewBuilder
    var infoView: some View {
        VStack(alignment: .leading) {
            Text(displayedData.title)
                .font(.system(size: 20, weight: .medium, design: .monospaced))
                .foregroundStyle(.white)
            
            Text(displayedData.subTitle)
                .font(.system(size: 15, weight: .light, design: .monospaced))
                .foregroundStyle(Color(hex: 0x87CEEB))
        }
    }
    
    @ViewBuilder
    var additionalListView: some View {
        if isExpanded, let list = displayedData.additionalInfo {
            VStack(alignment: .leading) {
                ForEach(list, id: \.self) { model in
                    Text(model)
                }
            }
        }
    }
    
    @ViewBuilder
    var suplimentalView: some View {
        if displayedData.hasChevron {
            HStack(spacing: 5) {
                Text(isExpanded ? "Collapse" : "Expand")
                Image(systemName: "chevron.forward")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0), anchor: .center)
                    .animation(.default.speed(1.25), value: isExpanded)
            }
            .font(.system(size: 14, design: .rounded))
            .onTapGesture {
                withAnimation(.interactiveSpring) {
                    isExpanded.toggle()
                }
            }
        }
    }
}
