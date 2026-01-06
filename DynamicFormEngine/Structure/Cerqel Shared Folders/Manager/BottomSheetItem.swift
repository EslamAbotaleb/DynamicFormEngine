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

class BottomSheetItem: BaseItem,Equatable {

    public var repo: BaseRepo
    public var endPoint: EndPointServiceCerqel
    public var type: BottomSheetType
    public var isSingleSelection: Bool?
    public var selectedItem: SelectedCallBack
    public var multiSelectedItems : MultiSelectedCallBack
    
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
