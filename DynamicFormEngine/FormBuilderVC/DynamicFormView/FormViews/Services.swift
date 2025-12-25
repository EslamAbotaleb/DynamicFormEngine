//
//  Service.swift
//  FormBuilderSample
//
//  Created by Yasser Osama on 17/01/2023.
//

import UIKit

public class Services {
    
    static public let shared = Services()
    
    /// Get DynamicForm
    /// - Parameters:
    ///   - serviceId: current service to be rendered
    ///   - completion: (serviceName,scheme,error message)
    func getForm(serviceId: String, isEdit: Bool, isApproverForm: Bool, completion: @escaping (String?, String?, JSON2?, String?) -> Void) {
        var formResponseKey = "requestForm"
        guard var url = URL(string: "\(cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.selfService.rawValue)SelfServices/RequestService/\(serviceId)") else {
              print("Invalid URL")
              completion(nil, nil, nil, "Invalid URL")
              return
          }

        if isEdit { // for edit request
            url =  URL(string: "\(cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.selfService.rawValue)Request/GetSchemaWithValuesById/\(serviceId)?roleType=1")!

        } else if isApproverForm {
            formResponseKey = "viewForm" // to make the parse of response succeed
            url = URL(string: "\(cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.selfService.rawValue)Tasks/GetById/\(serviceId)?roleType=2")!
        }
        
//        url = URL(string: "https://mocki.io/v1/6bb0be77-344d-4391-b02d-e9957e9453d7")!
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let token = AuthManager.shared.token
        let languageCode = isArabic() ? "Ar" : "En"
        
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(token)",
            "LanguageCode": languageCode,
            "Platform": "IOS",
            "Content-Type": "application/json",
            "charset": "utf-8",
            "TenantId": AuthManager.shared.tenant?.tenantId ?? ""
        ]
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error retrieving form data: \(error)")
                completion(nil, nil, nil, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response status code")
                completion(nil, nil, nil, "Unexpected response status code")
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil, nil, nil, "No data received")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let result = json["result"] as? [String: Any],
                      let data = result["data"] as? [String: Any] else {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonDict = json as? [String: Any], let message = jsonDict["message"] as? String {
                        print(message)
                        completion(nil, nil, nil, message)
                    } else {
                        completion(nil, nil, nil, nil)
                    }
                    return
                }
                
                if let requestForm = data[formResponseKey] as? [String: Any],
                   let schema = requestForm["schema"] as? JSON2 {
                    let formVersionId: String? = data["formVersionId"] as? String
                    let serviceName: String? = data["serviceName"] as? String
                    
                    // Convert schema to camelCase
                    let camelCaseSchema = self.convertKeysToCamelCase(schema) as? JSON2
                    
                    // Pass the camelCased schema to completion
                    completion(serviceName, formVersionId, camelCaseSchema, nil)
                } else if let viewForm = data["viewForm"] as? [String: Any],
                          let schema = viewForm["schema"] as? JSON2 {
                    let formVersionId: String? = data["formVersion"] as? String
                    let serviceName: String? = data["serviceName"] as? String
                    
                    // Convert schema to camelCase
                    let camelCaseSchema = self.convertKeysToCamelCase(schema) as? JSON2
                    
                    // Pass the camelCased schema to completion
                    completion(serviceName, formVersionId, camelCaseSchema, nil)
                } else {
                    completion(nil, nil, nil, "Invalid form structure")
                }
            } catch let error {
                print("Error parsing JSON: \(error)")
                completion(nil, nil, nil, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
//    func getForm(serviceId: String, isEdit: Bool, isApproverForm: Bool, completion: @escaping (String?, String?, JSON2?, String?) -> Void) {
//        // Function to load local JSON data if available
//        func loadLocalJSONData() -> Data? {
//            guard let path = Bundle.main.path(forResource: "originalForm", ofType: "json") else {
//                return nil
//            }
//            
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                return data
//            } catch {
//                print("Error loading local JSON data: \(error)")
//                return nil
//            }
//        }
//        
//        //         Attempt to load local JSON data
//        if let localData = loadLocalJSONData() {
//            // Parse JSON data locally
//            do {
//                guard let json = try JSONSerialization.jsonObject(with: localData, options: []) as? [String: Any],
//                      let result = json["result"] as? [String: Any],
//                      let data = result["data"] as? [String: Any],
//                      let requestForm = data["requestForm"] as? [String: Any],
//                      let formVersionId = data["formVersionId"] as? String,
//                      let serviceName = data["serviceName"],
//                      let schema = requestForm["schema"] as? JSON2 else {
//                    completion(nil, nil, nil, "Local JSON data structure invalid")
//                    return
//                }
//                
//                // Convert schema to camelCase
//                let camelCaseSchema = self.convertKeysToCamelCase(schema) as? JSON2
//                
//                // Pass the camelCased schema to completion
//                completion(serviceName as? String, formVersionId, camelCaseSchema, nil)
//                return
//            } catch {
//                print("Error parsing local JSON data: \(error)")
//                completion(nil, nil, nil, error.localizedDescription)
//                return
//            }
//        }
//    }
    
    
    func getRequestDetailsForm(id: String, isRequest: Bool, completion: @escaping (String?, String?, JSON2?, String?) -> Void) {
        
        guard var url = URL(string: "\(cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.selfService.rawValue)Tasks/GetById/\(id)") else {
            print("Invalid URL")
            completion(nil, nil, nil, "Invalid URL")
            return
        }
        
        if isRequest {
            url = URL(string: "\(cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.selfService.rawValue)Request/GetById/\(id)")!
        }
        
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let token = AuthManager.shared.token
        let languageCode = isArabic() ? "Ar" : "En"
        
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(token)",
            "LanguageCode": languageCode,
            "Platform": "IOS",
            "Content-Type": "application/json",
            "charset": "utf-8",
            "TenantId": AuthManager.shared.tenant?.tenantId ?? ""
        ]
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error retrieving form data: \(error)")
                completion(nil, nil, nil, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response status code")
                completion(nil, nil, nil, "Unexpected response status code")
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil, nil, nil, "No data received")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let result = json["result"] as? [String: Any],
                      let data = result["data"] as? [String: Any] else {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonDict = json as? [String: Any], let message = jsonDict["message"] as? String {
                        print(message)
                        completion(nil, nil, nil, message)
                    } else {
                        completion(nil, nil, nil, nil)
                    }
                    return
                }
                
                if let requestForm = data as? JSON2 {
                    let formVersionId: String? = data["formVersionId"] as? String
                    let serviceName: String? = data["serviceName"] as? String
                    
                    // Convert schema to camelCase
                    let camelCaseSchema = self.convertKeysToCamelCase(requestForm) as? JSON2
                    
                    // Pass the camelCased schema to completion
                    completion(serviceName, formVersionId, camelCaseSchema, nil)
                } else {
                    completion(nil, nil, nil, "Invalid form structure")
                }
            } catch let error {
                print("Error parsing JSON: \(error)")
                completion(nil, nil, nil, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    
    func convertPascalCaseToCamelCase(_ key: String) -> String {
        guard !key.isEmpty else { return key }
        
        let firstChar = key.prefix(1).lowercased()
        let otherChars = key.dropFirst()
        return "\(firstChar)\(otherChars)"
    }
    
    func convertKeysToCamelCase(_ json: Any) -> Any {
        if var dict = json as? [String: Any] {
            var result = [String: Any]()
            for (key, value) in dict {
                let camelCaseKey = convertPascalCaseToCamelCase(key)
                result[camelCaseKey] = convertKeysToCamelCase(value)
            }
            return result
        } else if var array = json as? [Any] {
            for (index, value) in array.enumerated() {
                array[index] = convertKeysToCamelCase(value)
            }
            return array
        } else {
            return json
        }
    }
    
    
    /// Get DynamicActions in task details
    /// - Parameters:
    ///   - actionId: action id that will render a dynamicForm
    ///   - completion: (serviceName,scheme,error message)
    func getActionForm(actionId: String, completion: @escaping (String?,JSON2?, String?) -> Void) {
        guard let url = URL(string: "\(cerqel_Environment.Api_Base_URL)NewFormBuilder/api/Forms/GetSchema") else {
            print("Invalid URL")
            completion(nil,nil, "Invalid URL")
            return
        }
        
        let json: [String: Any] = ["formId": actionId]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let token = AuthManager.shared.token
        let languageCode = isArabic() ? "Ar" : "En"
        
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(token)",
            "LanguageCode": languageCode,
            "Platform":"IOS",
            "Content-Type":"application/json",
            "charset": "utf-8",
            "TenantId": AuthManager.shared.tenant?.tenantId ?? ""
        ]
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error retrieving form data: \(error)")
                completion(nil,nil, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response status code")
                completion(nil,nil, "Unexpected response status code")
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil,nil, "No data received")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let data = json["data"] as? [String: Any],
                      let schema = data["schema"] as? JSON2 else {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonDict = json as? [String: Any], let message = jsonDict["message"] as? String {
                        print(message)
                        completion(nil,nil, message)
                    }else{
                        completion(nil,nil, nil)
                    }
                    return
                }
                
                completion("",schema, nil)
            } catch let error {
                print("Error parsing JSON: \(error)")
                completion(nil,nil, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    
    
    
}

public struct Utilities {
    static public func deviceIsIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    static public func handleNavBarAppearance(vc: UIViewController, tintColor: UIColor, shadowColor: UIColor? = .clear) {
        
        vc.navigationController?.navigationBar.isHidden = false
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        vc.tabBarController?.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        vc.navigationController?.navigationBar.prefersLargeTitles = false
        vc.tabBarController?.navigationController?.navigationBar.barTintColor = .white//tintColor
        vc.tabBarController?.navigationController?.navigationBar.tintColor = .white
        
        if shadowColor != nil {
            vc.tabBarController?.navigationController?.navigationBar.shadowImage = shadowColor!.as1ptImage()
        }
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = attributes
            appearance.backgroundColor = tintColor
            if shadowColor != nil {
                appearance.shadowColor = shadowColor
            }
            vc.tabBarController?.navigationController?.navigationBar.standardAppearance = appearance
            vc.tabBarController?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    
    static public func storyboard(withName name: String, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    static public func mainStoryBoard() -> UIStoryboard {
        return Utilities.storyboard(withName: "CheckMain")
    }
    
    static public func mainiPadStoryBoard() -> UIStoryboard {
        return Utilities.storyboard(withName: "MainiPad")
    }
    
    static public func instantiateVCWithId(_ id: String) -> UIViewController {
        if Utilities.deviceIsIpad() {
            return Utilities.mainiPadStoryBoard().instantiateViewController(withIdentifier: id)
        } else {
            return Utilities.mainStoryBoard().instantiateViewController(withIdentifier: id)
        }
    }
    
    // ---------------------- MOTIVAY ------------------- //
    
    //    static func storyboard(withName name: String, bundle: Bundle? = nil) -> UIStoryboard {
    //        return UIStoryboard(name: name, bundle: bundle)
    //    }
    
    static public func screedHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static public func screedWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    
    static public func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    //    public func loadJSON() -> JSON {
    //        let defaults = NSUserDefaults.standardUserDefaults()
    //        return JSON.parse(defaults.valueForKey("json") as! String))
    //        // JSON from string must be initialized using .parse()
    //    }
    
    static public func saveString(_ str: String, toFile: String){
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(toFile)
            
            //writing
            do {
                try str.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }
    }
    
    static public func readString(fromFile: String) -> String? {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(fromFile)
            //reading
            do {
                return try String(contentsOf: path, encoding: String.Encoding.utf8)
            }
            catch {
                
            }
        }
        
        return nil
    }
    
    static public func saveJSON(_ json: Any, toFile: String){
        if FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first != nil {
            var str: String?
            
            do {
                var data1: Data = Data()
                if let jsonObj = json as? JSON2 {
                    data1 =  try JSONSerialization.data(withJSONObject: jsonObj, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                } else if let jsonArray = json as? JSONArray {
                    data1 =  try JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                    
                } else {
                }
                
                str = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            }
            catch {
            }
            if str == nil {
            }else{
                Utilities.saveString(str!, toFile: toFile)
            }
        }
    }
    
    
    static func readJSON(fromFile: String) -> JSON2? {
        
        let str = Utilities.readString(fromFile: fromFile)
        if str == nil {
        }else{
            let data = str!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            //            var json: JSON?
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON2 {
                    return json
                }else{
                }
            } catch let error as NSError {
            }
        }
        return nil
    }
    
    
    static public func readJSONArray(fromFile: String) -> JSONArray? {
        
        let str = Utilities.readString(fromFile: fromFile)
        if str == nil {
        }else{
            let data = str!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONArray {
                    return json
                }else{
                }
            } catch let error as NSError {
            }
        }
        return nil
    }
    
    static public func getAppVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    static public func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    static public func deviceIs_iPhone5() -> Bool{
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return true
            break
        default:
            return false
        }
    }
    
    static public func getOsVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    static public func instantiateType(fromString string: String) -> AnyClass? {
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return nil
        }
        
        return NSClassFromString("\(namespace).\(string)")
    }
    
    static public func openAppStoreWith(appId: String){
        
        let url = URL(string: "https://itunes.apple.com/us/app/apple-store/id" + Constants.appStoreId + "?mt=8")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
    
    static public func suffixNumber(number: NSNumber) -> String {
        
        var num:Double = number.doubleValue
        let sign = ((num < 0) ? "-" : "" )
        
        num = fabs(num);
        
        if (num < 1000.0) {
            let intNum = Int(num)
            return "\(sign)\(intNum)"
        }
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        var units:[String]
        if isArabicCerqel() {
            units  = ["أ",
                      "م",
                      "مل",
                      "ت",
                      "كواد",
                      "كوينت"];
        } else {
            units  = ["K","M","B","TR","Quad","Quint"];
        }
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10
        let roundedInt = Int(roundedNum)
        return "\(sign)\(roundedInt)\(units[exp-1])"
    }
}
