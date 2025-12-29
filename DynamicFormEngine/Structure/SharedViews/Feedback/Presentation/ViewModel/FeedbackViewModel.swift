//
//  FeedbackViewModel.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 25/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

class FeedbackViewModel: BaseVM {
    
    var isFullScreen: DynamicObjects<Bool> = DynamicObjects(true)
    
    var router:CerqelRouterManager
    private var surveyUseCase: SurveyUseCase
    private var localNotification: LocalNotificationProtocol = LocalNotificationManager.shared
    private var userAuthoriationHandler: AuthorizationHandler = UserAuthoriationHandler()
    private var localData: LocalData
    var surveyItem: SurveyItem
    var rating: Int = 0
    
    
    init(router: CerqelRouterManager,surveyUseCase: SurveyUseCase,surveyItem: SurveyItem,localData: LocalData = LocalDataImpl()) {
        self.router = router
        self.surveyUseCase = surveyUseCase
        self.surveyItem = surveyItem
        self.localData = localData
    }
    
    func backToAllServices(){
        self.router.dismiss()
        
    }
    
    
    //endPoint
    func callSurveyEndPoint(serviceId: String ,comment: String, complition: @escaping () -> Void) {
        showLoadingCerqel()
        let payload = SurveyPayload(serviceId: serviceId ,rating: rating ,comment: comment )
        surveyUseCase.execute(surveyPayload: payload).then { (response) in
            self.hideLoadingCerqel()
            if(response.success ?? false){
                complition()
            }
            else {
                self.showErrorAlert(message:  response.message ?? "Failed")
            }
        }
        .catch { (error) in
            self.hideLoadingCerqel()
            self.showSystemError(error: error)
            
        }
        .always {
            self.hideLoadingCerqel()
            
        }
    }
    
}
