//
//  DelegatorNames.swift
//  CERQEL
//
//  Created by Youxel on 09/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import SwiftUI

struct DelegatorNames: View {
    @ObservedObject var viewModel = DelegatorsViewModel()
    @Environment(\.dismiss) private var dismiss
    var isSingleSelection: Bool
    @State private var searchQuery = ""
    var popupTitle: String
    var selectedItemResult :  ((UserEntity?)->())
    var currentSelectedUsers : [UserEntity]?
    
    var body: some View {
        VStack {
            
            Divider().frame(width: 60,height: 5, alignment: .center).background(Color.gray).padding(EdgeInsets(top: 8, leading: 0, bottom: 18, trailing: 0))
                .dismissingGesture(direction: .down) {
                    dismiss()
                }
            
            CustomNavBarWithSubmitText(title: popupTitle, onDone: {
                selectedItemResult(viewModel.singleSelectedItem)
            },onBack: {
            },submitBtnTitle: "Delegate".localized , submitIsAvailable: (viewModel.singleSelectedItem != nil || !viewModel.selectedList.isEmpty))
//            SearchBarView(hintText: "Search".localized,text: $searchQuery,onTextChanged :{ viewModel.search(searchString: searchQuery,selectedDelegators: currentSelectedUsers)
//            })
            EmptyView() 
            Group {
                switch viewModel.appState {
                case .Loading : LoadingView()
                case .LoadingRefresh :  DelegatorBody(viewModel: viewModel,
                                                      isSingleSelection: isSingleSelection,
                                                      searchQuery: searchQuery,
                                                      currentSelectedUsers: currentSelectedUsers)
                case.empty: EmptyView()
                case .fetched :   DelegatorBody(viewModel: viewModel,
                                                isSingleSelection: isSingleSelection,
                                                searchQuery: searchQuery,
                                                currentSelectedUsers: currentSelectedUsers)
                default :   DelegatorBody(viewModel: viewModel,
                                          isSingleSelection: isSingleSelection,
                                          searchQuery: searchQuery,
                                          currentSelectedUsers: currentSelectedUsers)
                }
                
            }
            .onViewDidLoad {
                
            }
            
            
        }
    }
}


struct DelegatorBody: View {
    @ObservedObject var viewModel : DelegatorsViewModel
    var isSingleSelection: Bool
    var searchQuery = ""
    var currentSelectedUsers : [UserEntity]?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.delegators) { item in
                        DelegatorItem(
                            delegator: item,
                            isSingleSelection: isSingleSelection,
                            onSelect: { isSelected, id in
                                viewModel.selectItem(id: id, isSingleSelection: isSingleSelection)
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: 60)
                    }

                    // Bottom Loader (only visible during pagination)
                    if viewModel.appState == .LoadingPagination {
                        ProgressView()
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                    }

                    // Detect when scrolled near bottom
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .global).minY) { value in
                                let screenHeight = UIScreen.main.bounds.height
                                if value < screenHeight * 0.9 {
                                    viewModel.loadMore(searchString: searchQuery,
                                                       selectedDelegators: currentSelectedUsers)
                                }
                            }
                    }
                    .frame(height: 0)
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
