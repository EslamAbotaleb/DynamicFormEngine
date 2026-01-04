//
//  BaseListBottomSheetViewModel.swift
//  CERQEL
//
//  Created by ahmed maher on 19/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
internal import Promises

public class BaseListBottomSheetViewModel: BaseVM {
    
    // Dependencies
    
    private var router:CerqelRouterManager
    
    public var list: DynamicObjects<[ListModel]> = DynamicObjects([])
    public var selectedList: DynamicObjects<[ListModel]> = DynamicObjects([])
    public var searchList: DynamicObjects<[ListModel]> = DynamicObjects([])
    public var searchText: DynamicObjects<String> = DynamicObjects("")
    
     var bottomSheetItem: BottomSheetItem?
     var baseListItem: BaseListItem?
    
    
    public init( router: CerqelRouterManager, bottomSheetItem: BottomSheetItem) {
        self.router = router
        self.bottomSheetItem = bottomSheetItem
    }
    
    public init( router: CerqelRouterManager, baseListItem: BaseListItem) {
        self.router = router
        self.baseListItem = baseListItem
    }
    
    public override func hydrate() {
        
    }
    
    
    public func checkForSelectedItem(){
        
    }
    
    public func selectItem(index: Int){
        let currentItem = self.list.value[index]
        bottomSheetItem?.selectedItem(currentItem)
        baseListItem?.selectedItem(currentItem)
        self.list.value = self.list.value.map{var item = $0; item.isSelected = $0.id == currentItem.id ; return item;}
    }
    
    public  func multiSelectItem(index: Int) {
        let item = self.list.value[index]
        self.list.value = self.list.value.map { listItem in
            var updatedItem = listItem
            if item.id == updatedItem.id {
                updatedItem.isSelected?.toggle()
            }
            return updatedItem
        }
    }
    
    public  func saveMultiSelectionArray() {
        self.selectedList.value.removeAll()
        self.selectedList.value = list.value.filter { $0.isSelected ?? false }
        baseListItem?.multiSelectedItems(self.selectedList.value)
        bottomSheetItem?.multiSelectedItems(self.selectedList.value)
    }
    
    public  func searchBar() {
       
            searchList.value = list.value.filter({$0.nameEn!.lowercased().contains(searchText.value.lowercased())})

      }
    
    //endPoint
    public  func setlist() {
        if self.baseListItem?.isSingleSelection == true {
            self.list.value = baseListItem?.list.map{var item = $0;
                if $0.id == baseListItem?.currentSelectedItem?.id {
                    item.isSelected = true
                }
                else {
                    item.isSelected = false
                }
                 return item;

            } ?? []
        }
        else {
            if let selectedSections = baseListItem?.currentMultiSelectedItems, !selectedSections.isEmpty {
                self.list.value = baseListItem?.list.map { item in
                    if selectedSections.contains(where: {$0.id == item.id}) {
                        return selectedSections.first{ $0.id == item.id } ?? item
                    } else {
                        return item
                    }
                } ?? []
            }
            else {
                self.list.value = baseListItem?.list ?? []
            }
        }
    }
    
    public func listEndPoint() {
        self.showLoadingCerqel()
        var request: Promise<BaseResponse<[ListModel]>>!
        switch bottomSheetItem?.endPoint {
        case .categories :
            request = bottomSheetItem?.repo.categories()
        case .subCategories(let categoryId) :
            request = bottomSheetItem?.repo.subCategories(categoryId: categoryId)
        case .degreeLvlList:
            request = bottomSheetItem?.repo.degreeLvlList()
        case .relationList:
            request = bottomSheetItem?.repo.relationList()
        case .linksList:
            request = bottomSheetItem?.repo.linksList()
        default:
            break
        }
        
        request.then { (response) in
            self.list.value = response.result.data
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
        }
    }
}
