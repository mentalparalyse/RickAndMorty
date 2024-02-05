//
//  ListCellView.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import SwiftUI
/**
 View used to display given content data.
 
- Parameters:
    - displayedData: DisplayedData - by default is passed in from main view.
    - query: String - parameter passed as an additional link from supplimented view with list of persons in that case.
    - servicesContainer: ServicesContainerProtocol? - Container with services to request/retreive data from network/cache.
 ```
 func loadCharacter() async
 ```
 Updates the suplimental cell within given query.
*/


struct ListCellView: View {
    var displayedData: DisplayedData = .mock
    var query: String = ""
    var servicesContainer: ServicesContainerProtocol?
    
    var onTapAction: (() -> Void)?
    
    @State private var isExpanded = false
    @State private var queryItem: DisplayedData?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 16) {
                logoView
                infoView
                Spacer()
                suplimentalView
            }
            .padding(4)
            
            if isExpanded {
                additionalListView
            }
        }
        .onTapGesture {
            guard !(queryItem ?? displayedData).hasChevron else { return }
            onTapAction?()
        }
        .padding(.vertical, isExpanded ? 19 : 0)
        .frame(minHeight: 72)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.15))
                .animation(nil, value: isExpanded)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isExpanded ? Color(hex: 0x23CE3E) : .clear,
                                lineWidth: 2)
                }
                .if(queryItem != nil) {
                    $0.shadow(
                        color: .black,
                        radius: 1,
                        x: 0, y: 2
                    )
                }
        )
        .padding(.horizontal, query.isEmpty ? 16 : 0)
        .animation(nil, value: isExpanded)
        .task(id: query, loadCharacter)
    }
}

extension ListCellView {
    @ViewBuilder
    var logoView: some View {
        if let imageURL = (queryItem ?? displayedData).imageUrl, let cacher = servicesContainer?.imageCacherService {
            AsyncImage(cacher: cacher, urlString: imageURL)
                .frame(height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            Spacer()
                .frame(width: 20)
        }
    }
    
    @ViewBuilder
    var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text((queryItem ?? displayedData).title)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundStyle(Color.init(hex: 0x23CE3E))
                .minimumScaleFactor(0.5)
            
            Text((queryItem ?? displayedData).subTitle)
                .font(.system(size: 16, weight: .light, design: .monospaced))
                .foregroundStyle(Color(hex: 0xF1F1F1))
        }
    }
    
    @ViewBuilder
    var additionalListView: some View {
        if isExpanded, let list = (queryItem ?? displayedData).additionalInfo {
            VStack(alignment: .leading) {
                ForEach(0..<list.count, id: \.self) { index in
                    let item = list[index]
                    ListCellView(query: item, servicesContainer: servicesContainer)
                        .zIndex(-Double(index))
                }
            }
            .padding(.horizontal, 19)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .opacity
                )
            )
        }
    }
    
    @ViewBuilder
    var suplimentalView: some View {
        if (queryItem ?? displayedData).hasChevron && (queryItem ?? displayedData).additionalInfo?.isEmpty == false {
            ChevronView {
                isExpanded.toggle()
            }
        }
    }
}
//MARK: - Additional requests for suppliments
extension ListCellView {
    @Sendable
    private func loadCharacter() async {
        guard query.isEmpty == false else { return }
        let characterModelResult = await servicesContainer?.networkService
            .load(model: CharacterModel.self, link: query)
        await MainActor.run {
            switch characterModelResult {
            case .success(let success):
                guard let success else { return }
                updateData(.init(character: success))
            case .failure(let failure):
                print(failure.localizedDescription, query)
            default: break
            }
        }
    }
    
    private func updateData(_ model: DisplayedData) {
        queryItem = model
    }
}

#Preview {
    let diContainer = DependencyContainer()
    return ZStack() {
        Color.black.ignoresSafeArea()
        ListCellView(displayedData: .mock, servicesContainer: diContainer.services).id("qqqqqqqq")
            .background(Color.black)
    }
}

