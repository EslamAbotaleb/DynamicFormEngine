//
//  BottomSheetItem.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import Foundation
import UIKit

public typealias SelectedCallBack = ((ListModel) -> ())
public typealias MultiSelectedCallBack = (([ListModel]) -> ())
public typealias CerqelSelectedCallBack = ((CerqelListModel) -> ())

public class BottomSheetItem: BaseItem,Equatable {

    var repo: BaseRepo
    var endPoint: EndPointServiceCerqel
    var type: BottomSheetType
    var isSingleSelection: Bool?
    var selectedItem: SelectedCallBack
    var multiSelectedItems : MultiSelectedCallBack
    
    public init(repo: BaseRepo,endPoint:EndPointServiceCerqel,type: BottomSheetType,isSingleSelection: Bool? = false, selectedItem: @escaping SelectedCallBack, multiSelectedItems : @escaping MultiSelectedCallBack) {
        self.type = type
        self.repo = repo
        self.endPoint = endPoint
        self.isSingleSelection = isSingleSelection
        self.selectedItem = selectedItem
        self.multiSelectedItems = multiSelectedItems
    }

    static public func == (lhs: BottomSheetItem, rhs: BottomSheetItem) -> Bool {
        return true

    }

}
