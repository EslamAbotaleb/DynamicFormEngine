//
//  SendBackViewModel.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 12/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

class AddCommentViewModel: BaseVM {
    
    // Dependencies
    private var router:CerqelRouterManager
    var item: AddCommentItem
    init(router: CerqelRouterManager, item : AddCommentItem) {
        self.router = router
        self.item = item
    }
    
    override func hydrate() {
        
    }
    
    func successCallBack() {
        router.dismiss()
    }
    
}
