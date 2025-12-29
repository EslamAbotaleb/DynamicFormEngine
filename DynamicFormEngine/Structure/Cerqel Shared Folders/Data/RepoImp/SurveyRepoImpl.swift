//
//  SurveyRepoImpl.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 21/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import Promises
import DynamicFormEngine

public class SurveyRepoImpl: SurveyRepo{
 
    private var network: Network
    private var localData: LocalData

    public init(network: Network = NetworkServiceImpl(), localData: LocalData = LocalDataImpl()) {
        self.network = network
        self.localData = localData
    }
    
    public func survey(surveyPayload: SurveyPayload) -> Promise<BaseSuccessResponse> {
        return self.network.callModel(BaseSuccessResponse.self, endpoint: SurveyEndPoint(surveyPayload: surveyPayload))
    }
}
