//
//  DelegatorsViewModel.swift
//  CERQEL
//
//  Created by Youxel on 12/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

class DelegatorsViewModel : BaseVM {
    
    private var userUseCase: UserUseCase!
    
    @Published var appState: AppState = .initial
    @Published var delegators: [UserEntity] = []
    @Published var pageNumber: Int = 1
    @Published var pageSize: Int = 10
    @Published var selectedList : [UserEntity] = []
    @Published  var singleSelectedItem : UserEntity? = nil
    var payload: GetUsersPayload = GetUsersPayload(filter: UserFilterModel(searchString: ""), searchOptions : nil,pageSize : 100, pageNumber: 1)
    private let searchDelay = 1.0
    private var searchTimer: Timer?
    
    override init() {
        super.init()
        self.userUseCase = UserUseCaseImpl()

    }
  
    
    func selectItem(id: String, isSingleSelection: Bool){
        isSingleSelection ? selectSingleItems(id: id) : selectMultibleItems(id: id)
    }
    
   private func selectSingleItems(id: String){
        for index in 0..<delegators.count {
            delegators[index].isSelected = false
        }

       if let index =  delegators.firstIndex(where: { $0.id == id }) {
           delegators[index].isSelected.toggle()
           singleSelectedItem = delegators[index]
       }
        
       print("SelectedItem: \(String(describing: singleSelectedItem))" )

   }
    
    private func startSearchTimer(searchString: String,selectedDelegators: [UserEntity]?) {
         searchTimer?.invalidate()
         searchTimer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false) { _ in
             self.searchInDelegators(searchString: searchString,selectedDelegators: selectedDelegators)
         }
     }
    
    private  func selectMultibleItems(id: String){
       if let index =  delegators.firstIndex(where: { $0.id == id }) {
           delegators[index].isSelected.toggle()
       }
        selectedList = delegators.filter { $0.isSelected }
   }
    
    private  func searchInDelegators(searchString: String,selectedDelegators: [UserEntity]?){
        if( searchString.isEmpty || searchString == "") {
            singleSelectedItem = nil
            delegators = []
        }
        else {
            refreshDelegators(searchString: searchString, selectedDelegators: selectedDelegators)
        }
    }
    
    func search(searchString: String,selectedDelegators: [UserEntity]?){
        startSearchTimer(searchString: searchString,selectedDelegators: selectedDelegators)
    }
    
 private func setSelectedDelegators(selectedDelegators: [UserEntity]?) {
     if(selectedDelegators != nil){
         selectedList = selectedDelegators!
         for (index, var item) in delegators.enumerated() {
             if selectedList.contains(where: { $0.id == item.id }) {
                 item.isSelected = true
                 delegators[index] = item
             }
         }
     }
     else {
         selectedList = []
     }
    }
    
    //endPoint
    private func getDelegatorsEndPoint(fromPagination: Bool, searchString: String, selectedDelegators: [UserEntity]?) {
        appState = fromPagination ? .LoadingPagination : .Loading
        payload.filter?.searchString = searchString
        payload.pageNumber = pageNumber
        payload.pageSize = pageSize

        userUseCase.getUsersList(payload: payload).then { response in
            let newData = response.result.data
            let totalPages = response.result.pagesCount ?? 1
            let totalItems = response.result.totalCount ?? 10

            if self.pageNumber == 1 {
                // First page → replace data
                self.delegators = newData
            } else {
                // Subsequent pages → append data
                self.delegators.append(contentsOf: newData)
            }

            // Update selected items
            self.setSelectedDelegators(selectedDelegators: selectedDelegators)

            // Check if we reached the last page or loaded all items
            if self.pageNumber >= totalPages || self.delegators.count >= totalItems {
                self.appState = .noMoreData
            } else {
                self.appState = .fetched
            }

        }.catch { _ in
            self.appState = .error
        }
    }


    func loadMore(searchString: String, selectedDelegators: [UserEntity]?) {
        guard !appState.isBlockingLoad else { return }
        appState = .LoadingPagination
        pageNumber += 1
        getDelegatorsEndPoint(fromPagination: true, searchString: searchString, selectedDelegators: selectedDelegators)
    }

    /// Call this when user starts a new search
    func refreshDelegators(searchString: String, selectedDelegators: [UserEntity]?) {
        pageNumber = 1
        appState = .initial // reset state so pagination works again
        getDelegatorsEndPoint(fromPagination: false, searchString: searchString, selectedDelegators: selectedDelegators)
    }


}
