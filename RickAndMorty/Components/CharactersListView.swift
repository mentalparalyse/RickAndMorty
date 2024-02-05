//
//  CharactersListView.swift
//  RickAndMorty
//
//  Created by Lex Sava on 25.01.2024.
//

import SwiftUI

struct CharactersListView: View {
    var services: ServicesContainerProtocol?
    @Binding var displayableData: [DisplayedData]
    @Binding var offset: CGFloat
    @Binding var shouldLoadMore: Bool
    
    @State private var searchText: String = ""
    
    private var items: [DisplayedData] {
        if searchText.isEmpty {
            return displayableData
        } else {
            return displayableData.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack {
            searchBarView
            ScrollViewOffset(offset: $offset) {
                createCharactersStack(for: items)
            }
            .scrollDismissesKeyboard(.immediately)
            .padding(.bottom, 55)
        }
    }
    
    @ViewBuilder
    private func createCharactersStack(for data: [DisplayedData]) -> some View {
        LazyVStack(spacing: 8) {
            ForEach(data, id: \.id) { model in
                ListCellView(
                    displayedData: model,
                    servicesContainer: services
                ) {
                    
                }
                .onAppear {
                    shouldLoadMore = model.id == data.last?.id
                }
            }
            .padding(.bottom, 10)
        }
    }
    
    private var searchBarView: some View {
        TextField("", text: $searchText)
            .padding(.horizontal, 15)
            .placeholder(when: searchText.isEmpty, alignment: .leading) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                        .font(.system(size: 16,
                                      weight: .regular,
                                      design: .monospaced)
                        )
                }
                .foregroundColor(.init(hex: 0xBBBBC2))
                .padding(.leading, 16)
            }
            .frame(minHeight: 48)
            .background(
                Color.white.opacity(0.35)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
            )
            .padding(.horizontal, 16)
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
    }
}
