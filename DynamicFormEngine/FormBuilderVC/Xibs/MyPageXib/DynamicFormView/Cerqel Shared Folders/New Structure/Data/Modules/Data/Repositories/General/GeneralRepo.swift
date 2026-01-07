//
//  GeneralRepo.swift
//  it_graduate_new
//
//  Created by Maher on 7/11/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import Promises

protocol GeneralRepo {
    var recentSearch: [String]{get set}
    func getFAQList(cerqelFilterPayload: CerqelFilterPayload) -> Promise<BaseResponse<[FAQDTO]>>
    func getFAQCategories() -> Promise<BaseResponse<[FAQsCategoriesDTO]>>
}

