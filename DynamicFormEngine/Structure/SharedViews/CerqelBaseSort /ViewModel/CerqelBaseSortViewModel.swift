//
//  CerqelBaseSortViewModel.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 22/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import Foundation
public import RxCocoa
public import RxSwift

public enum sortSectionsCerqel : String {
    case radioBtnTV
    case checkBoxTV
    case tagsCV
}

public struct sortModelCerqel {
    var sortId:String?
    var sortName:String?
    var isSelected = false
}

class CerqelBaseSortViewModel : CerqelBaseViewModel {
    private let service: cerqel_NetworkServiceDynamicForm
    private let disposeBag = DisposeBag()
    var sortType: sortSectionsCerqel?
    var arrOfSections: [sortSectionsCerqel] = [.radioBtnTV,.checkBoxTV,.tagsCV]
    init(_ service: cerqel_NetworkServiceDynamicForm) {
        self.service = service
        super.init()
    }
}
