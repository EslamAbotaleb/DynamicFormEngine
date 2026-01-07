//
//  GeneralRepoImpl.swift
//  it_graduate_new
//
//  Created by Mahmoud Ibaraheim on 7/11/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import Promises

class GeneralRepoImpl: GeneralRepo {

    private var network: Network
    private var localData: LocalData

    init(network: Network = NetworkServiceImpl(), localData: LocalData = LocalDataImpl()) {
        self.network = network
        self.localData = localData
    }

    var recentSearch: [String] {
        set { localData.set(object: newValue, key: .recentSearch) }
        get { return  localData.get(object: [String].self, key: .recentSearch) ?? []}
    }

    func getFAQList(cerqelFilterPayload: CerqelFilterPayload) -> Promise<BaseResponse<[FAQDTO]>> {
        return self.network.callModel(BaseResponse<[FAQDTO]>.self, endpoint: FAQEndPoint(cerqelFilterPayload: cerqelFilterPayload ))
    }

    func getFAQCategories() -> Promise<BaseResponse<[FAQsCategoriesDTO]>> {
        return self.network.callModel(BaseResponse<[FAQsCategoriesDTO]>.self, endpoint: FAQsCategoriesEndPoint( ))
    }
}
