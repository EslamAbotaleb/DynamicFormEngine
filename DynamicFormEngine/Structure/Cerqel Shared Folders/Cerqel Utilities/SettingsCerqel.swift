//
//  Settings.swift
//  GAZT
//
//  Created by iSlam on 10/6/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit
//internal import MOLH
//import PopupDialog
import Network
internal import Toast
internal import JGProgressHUD
internal import Kingfisher
import Photos
import UIKit

public var appsDicCerqel: [String : String] = [
    "facebook" : "fb://" ,
    "kiloloco" : "kilolocossss://",
    "instagram" : "instagram://",
    "twitter" : "twitter://",
    "microsoft-outlook" : "ms-outlook://",
    "microsoft-teams" : "msteams://",
    "microsoft-authenticator" : "msauth://",
    "figma" : "figma://",
    "gmail" : "googlegmail://",
    "youtube" : "youtube://",
]

public let globalHeaders = [
    "Authorization": "Bearer " + AuthManagerDynamicForm.shared.token,
    "TenantId": AuthManagerDynamicForm.shared.tenant?.tenantId ?? "",
    "LanguageCode": isArabicCerqel() ? "Ar" : "En",
    "Platform":"IOS",
    "Content-Type":"application/json",
    "charset" : "utf-8",
    "TimeZone": TimeZone.current.identifier,
]

internal let modifier = AnyModifier { request in
    var r = request

    let token = AuthManagerDynamicForm.shared.token
    r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    return r
}

public let dummyEmptyImgNameCerqel = "empty-dummy"
public let tempServiceImgNameCerqel = "service1"
public let avatarImgNameCerqel = "User"

public let dummyEmptyImgCerqel = UIImage(named: "empty-dummy")
public let favEmptyImgCerqel = UIImage(named: "heart")
public let favImageCerqel = UIImage(named: "filledFav")
public let notFavImageCerqel = UIImage(named: "Favorite")
public let favImageForDetailsCerqel = UIImage(named: "fav-Undimmed")
public let notFavImageForDetailsCerqel = UIImage(named: "fav-dimmed")
public let tempServiceImgCerqel = UIImage(named: "service1")
public let tempVacationImgCerqel = UIImage(named: "vacation")
public var loadingUserInteractionEnabledCerqel = false
public let avatarCerqel = UIImage(named: "User")
public let avatar_BigCerqel = UIImage(named: "avatar_Big")
public var offersCountInDashboardCerqel = 0
public var recentSearchKeyCerqel = "RECENT_SEARCH_LIST"
public var kbRecentSearchKeyCerqel = "kb_RECENT_SEARCH_LIST"
public let FF_New_Form_DesignCerqel = true
public let timeZone_UTC = TimeZone(abbreviation: "UTC") ?? TimeZone.current

public let dateFormatterLocale_arCerqel = Locale(identifier: "ar")
public let dateFormatterLocal_en_USCerqel = Locale(identifier: "en_US")
public let utc_TimeZoneCerqel = TimeZone(abbreviation: "UTC")
public let currentTimeZoneCerqel = TimeZone.current
public let favImageForDetails = UIImage(named: "fav-Undimmed")
public let notFavImageForDetails = UIImage(named: "fav-dimmed")
public let FF_New_Form_Design = true
public let favStar = UIImage(named: "starfilled")
public let unFavStar = UIImage(named: "starunfill")
public let tempServiceImg = UIImage(named: "service1")

public let peoplesInvitedImgBaseURLCerqel = "https://cerqel-be.azurewebsites.net/content_youxel/api/Calendar/attendsProfilePicture/"

public func isArabicCerqel()-> Bool{
    return MOLHLanguage.isArabic()
}

public func changeLanguageCerqel(){
    if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }else{
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }

}



public func findDateDiffCerqel(time1Str: String, time2Str: String, timeFormat: String) -> String {
    let timeformatter = DateFormatter()
    timeformatter.dateFormat = timeFormat

    guard let time1 = timeformatter.date(from: time1Str),
          let time2 = timeformatter.date(from: time2Str) else { return "" }

    //You can directly use from here if you have two dates

    let interval = time2.timeIntervalSince(time1)
    let hour = interval / 3600;
    let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
    let intervalInt = Int(interval)
    return "\(Int(hour)) Hours \(Int(minute)) Minutes"
}



public func hexStringToUIColor(hex: String) -> UIColor {
    var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if cString.hasPrefix("#") {
        cString.remove(at: cString.startIndex)
    }

    if cString.count == 6 {
        cString = cString + "FF"
    } else if cString.count != 8 {
        return UIColor.gray
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    let red = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
    let green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
    let blue = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
    let alpha = CGFloat(rgbValue & 0x000000FF) / 255.0 // Keep as is

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}

public func delayCerqel(seconds: Double, completion: @escaping () -> ()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)

    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}


public func setNavUserImageBtnCerqel(btn: UIBarButtonItem){

}

//func goToMyRequestsFormSuccessFormCerqel(navCtl: UINavigationController, tabCtl: BubbleTabBarController){
//
//    navCtl.popToRootViewController(animated: false)
//    tabCtl.selectedIndex = 1
//    if let navCtl = tabCtl.viewControllers?[1] as? UINavigationController{
//        let inbxList = CERQEL_Router.goTo(viewName: .inboxRequestList(fromSubmitFormFlag: true))
////        let inbxDetails = CERQEL_Router.goTo(viewName: .requestDetails(Id: taskId, isMyRequestFlag: true))
////        navCtl.
//        navCtl.pushViewController(inbxList, animated: false)
////        navCtl.pushViewController(inbxDetails, animated: false)
//    }
//
//}

public func openAttachmentCerqel(withURLString: String) {
    guard let url = URL(string: withURLString) else { return }
    UIApplication.shared.open(url)
}

public func openAppFromCerqelAppCerqel(appStoreURL: String) -> Bool {
    for key in appsDicCerqel.keys {
        //        if key == appStoreURL {
        if appStoreURL.contains(key) {
            return openAppCerqel(scheme: appsDicCerqel[key], appStoreURL: appStoreURL)
        }
    }
    guard verifyUrlCerqel(urlString: appStoreURL) else { return false }
    return openAppCerqel(scheme: appStoreURL, appStoreURL: appStoreURL)
}

public func verifyUrlCerqel(urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}

public func openAppCerqel(scheme: String?, appStoreURL: String) -> Bool {
    let url = URL(string: scheme ?? "")!
    let application = UIApplication.shared
    // Check if the App is installed
    if application.canOpenURL(url) {
        application.open(url)
    } else {
        guard verifyUrlCerqel(urlString: appStoreURL) else { return false }
        application.open(URL(string: appStoreURL)!)
    }
    return verifyUrlCerqel(urlString: appStoreURL)
}

//func goToTaskDetailsFromNotificationListCerqel(taskId: String, tabCtl: BubbleTabBarController){
//    tabCtl.selectedIndex = 1
//    if let navCtl = tabCtl.viewControllers?[1] as? UINavigationController{
//        let inbxList = CERQEL_Router.goTo(viewName: .inboxRequestList(fromSubmitFormFlag: false))
//        let inbxDetails = CERQEL_Router.goTo(viewName: .requestDetails(Id: taskId, isMyRequestFlag: true, requestId: taskId))
//        navCtl.pushViewController(inbxList, animated: false)
//        navCtl.pushViewController(inbxDetails, animated: false)
//    }
//}

//func goToRequestListFromEmployeeDashboardCerqel(navCtl: UINavigationController, tabCtl: BubbleTabBarController, torRequestList: Bool = false, toInboxScreen: Bool = false){
//    navCtl.popToRootViewController(animated: false)
//    tabCtl.selectedIndex = 1
//    if let navCtl = tabCtl.viewControllers?[1] as? UINavigationController{
//        let inbxList = CERQEL_Router.goTo(viewName: .inboxRequestList(fromSubmitFormFlag: torRequestList))
////        let inbxDetails = CERQEL_Router.goTo(viewName: .requestDetails(Id: taskId, isMyRequestFlag: true, requestId: taskId))
//        if toInboxScreen{
//            return
//        }
//        navCtl.pushViewController(inbxList, animated: false)
////        navCtl.pushViewController(inbxDetails, animated: false)
//    }
//}

public func convertDateStringToAnotherFormatCerqel(oldFormat: String, newFormat: String, dateString: String) -> String {
    let myDateString = dateString

    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = oldFormat
    dateFormatter.timeZone = currentTimeZoneCerqel //TimeZone.current//
    dateFormatter.locale = dateFormatterLocal_en_USCerqel
    let myDate = dateFormatter.date(from: myDateString)!

    dateFormatter.dateFormat = newFormat
    let newDate = dateFormatter.string(from: myDate)

    return newDate
}

public func compareBetweenTwoDatesCerqel(start: String, end: String) -> Bool {

    let formatter = DateFormatter()
    formatter.dateFormat = "dd/mm/yyyy"
    formatter.timeZone = currentTimeZoneCerqel //TimeZone.current//
    formatter.locale = dateFormatterLocal_en_USCerqel
    let firstDate = formatter.date(from: start)
    let secondDate = formatter.date(from: end)

    if firstDate?.compare(secondDate!) == .orderedAscending {
        print("First Date is smaller then second date")
        return true
    } else {
        return false
    }

}

public func getTimeDifferenceCerqel(dt: Date, includeDays: Bool, includeDaysIfCurrentIsLess: Bool)-> (String?, String?, String?, String?){
    var cal = Calendar.current
    cal.timeZone = currentTimeZoneCerqel
    let comps = cal.dateComponents([.hour, .minute, .second, .day], from: dt)
    let hours = comps.hour
    let min = comps.minute
    let sec = comps.second
    let days = comps.day

    let currentComps = cal.dateComponents([.hour, .minute, .second, .day], from: Date())
    let currHours = currentComps.hour
    let currMin = currentComps.minute
    let currSec = currentComps.second
    let currDays = currentComps.day


    if includeDays {
        if let d = days, let cd = currDays, (cd - d) > 0{
            if (cd - d) == 1{
                return ( nil, nil, nil, "day ago".localized)
            }else{
                return (nil, nil, nil,String(format: "days ago".localized, "\(cd - d)"))
            }
        }
    }

    if includeDaysIfCurrentIsLess {
        if let d = days, let cd = currDays, (d - cd) >= 0 {
            if (d - cd) == 0 || (d - cd) == 1 {
                //                return ( nil, nil, nil,String(format: "day".localized, "\(d - cd)"))
                return ( nil, nil, nil, String(d - cd) + " " + "day".localized)
            }else{
                //                return (nil, nil, nil,String(format: "days".localized, "\(d - cd)"))
                return ( nil, nil, nil, String(d - cd) + " " + "days".localized)
            }
        }
    }

    if let h = hours, let ch = currHours, (ch - h) > 0{
        if (ch - h) == 1{
            return ("hour ago".localized, nil, nil, nil)
        }
        return (String(format: "hours ago".localized, "\(ch - h)"), nil, nil, nil)
    }else if let m = min, let cm = currMin, (cm - m) > 0{
        if (cm - m) == 1{
            return ("minute ago".localized, nil, nil, nil)
        }
        return (nil, String(format: "minutes ago".localized, "\(cm - m)"), nil, nil)
    }else if let s = sec, let cs = currSec, (cs - s) > 0{
        return (nil, nil, "\(cs - s) \("seconds ago".localized)", nil )
    }else{
        return(nil, nil, nil, nil)
    }

}

public func showToastCerqel(parentView: UIViewController, msg: String){

    var style = ToastStyle()
    style.imageSize = CGSize(width: 20, height: 20)
    style.messageFont = UIFont.bodyLMedium()
    style.messageColor = .white
    style.backgroundColor = .black
    style.fadeDuration = 3

    parentView.view.makeToast(msg, point: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 140), title: nil, image: nil, style: style, completion: nil)
}


public func showNoConnectionPopupCerqel(parentView: UIViewController){
//    let vc = CERQELShared_Router.goTo(viewName: .NoConnectionPopup)
//    let popup = PopupDialog(viewController: vc)
//    if let v = vc as? CerqelConnectionPopup{
//        v.didTapOk = {
//            popup.dismiss()
//        }
//    }
//    // Present dialog
//    parentView.present(popup, animated: true, completion: nil)
}

public func getCurrentDateCerqel(dateFormat: String) -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.timeZone = currentTimeZoneCerqel //TimeZone.current//
    formatter.locale = dateFormatterLocal_en_USCerqel
    formatter.dateFormat = dateFormat
    let today = formatter.string(from: date)
    return today
}

public func checkReachabilityCerqel(){
    DispatchQueue.main.async {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected")
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
                }

            } else {
                print("Disconnected")
                DispatchQueue.main.async {
                    if let v = UIApplication.shared.keyWindow?.rootViewController{
                        showNoConnectionPopupCerqel(parentView: v)
                        UIApplication.shared.keyWindow!.isUserInteractionEnabled = false

                    }
                }
            }
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)


    }

}

public func createInitialsImage(name: String, backgroundColor: UIColor, textColor: UIColor, size: CGSize, font: UIFont) -> UIImage? {
    let initials = name.split(separator: " ").compactMap { $0.first }.prefix(2)
    let initialsString = isArabicCerqel() ? initials.map { String($0) }.joined(separator: "\u{00A0}") : initials.map { String($0) }.joined(separator: "")

    // Begin drawing the image
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }

    // Set the background color
    context.setFillColor(backgroundColor.cgColor)
    context.fill(CGRect(origin: .zero, size: size))

    // Define the attributes
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: textColor
    ]

    // Calculate the size of the text to center it properly
    let textSize = initialsString.size(withAttributes: attributes)

    // Calculate the position to center the text vertically and horizontally
    let textX = (size.width - textSize.width) / 2
    let textY = (size.height - textSize.height) / 2

    // Draw the initials in the center of the image
    initialsString.draw(
        in: CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height),
        withAttributes: attributes
    )

    // Extract the image
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
}

public func handleImageWithKFCerqel(
    imgUrl: String?,
    img: UIImageView,
    name: String?,
    color: UIColor,
    textColor: UIColor,
    withDummyImg: Bool = false,
    initialDummyImageName: String = "User"
) {
    var placeHolder: UIImage?

    // Create the placeholder image with initials if name is provided
    if let nameStr = name, !nameStr.isEmpty {
        let initialsImage = createInitialsImage(
            name: nameStr,
            backgroundColor: color,
            textColor: textColor,
            size: CGSize(width: 40, height: 40),
            font: UIFont.boldSystemFont(ofSize: 18)
        )

        placeHolder = initialsImage
    }

    // If dummy image is required, use the specified dummy image name
    if withDummyImg {
        placeHolder = UIImage(named: initialDummyImageName)
    }

    img.loadUserWebImage(imageUrl: imgUrl ?? "", placeHolderImage: placeHolder  ?? UIImage())

}


public func textToImageCerqel(drawText text: String, inImage image: UIImage, atPoint point: CGPoint, textSize: CGSize,textColor:UIColor) -> UIImage {
    // let textColor = UIColor.white
    let textFont = UIFont.SST_Arabic_Medium(ofSize: 18)

    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

    let textFontAttributes = [
        NSAttributedString.Key.font: textFont,
        NSAttributedString.Key.foregroundColor: textColor,
    ] as [NSAttributedString.Key : Any]

    image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
    print("origin: \(CGPoint.zero)")

    let rect = CGRect(origin: point, size: textSize)
    text.draw(in: rect, withAttributes: textFontAttributes)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}

public func makeACallCerqel(num: String){
    guard let url = URL(string: "tel://\(num)"),
          UIApplication.shared.canOpenURL(url) else { return }
    if #available(iOS 10, *) {
        UIApplication.shared.open(url)
    } else {
        UIApplication.shared.openURL(url)
    }

}

public func sendAnEmailCerqel(email: String){
    if let url = URL(string: "mailto:\(email)") {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}


public func mergeDatesCerqel(usingDateFrom: Date, UsingTimeFrom: Date) -> Date?{
    var cal = Calendar.current
    cal.timeZone = currentTimeZoneCerqel
    var dateComps = cal.dateComponents([.day, .month, .year, .hour , .minute], from: usingDateFrom)
    let timeComps = cal.dateComponents([.hour, .minute], from: UsingTimeFrom)

    dateComps.hour = timeComps.hour
    dateComps.minute = timeComps.minute

    let newDate = cal.date(from: dateComps)
    return newDate

}

public func getDatesDifferenceInDaysCerqel(fromDate: Date?, toDate: Date?) -> Int?{

    guard let fromDate = fromDate, let toDate = toDate else{
        return nil
    }
    var cal = Calendar.current
    cal.timeZone = currentTimeZoneCerqel

    let date1 = cal.startOfDay(for: fromDate)
    let date2 = cal.startOfDay(for: toDate)

    let components = cal.dateComponents([.day, .month, .year], from: date1, to: date2)

    print("WE GOT DIFF = \(components.day) DAYS, \(components.month) MON, \(components.year) YEAR")

    let days = components.day ?? 0
    let month = ((components.month ?? 0) * 30)
    let year = ((components.year ?? 0) * 12 * 30)

    let allDays = days + month + year
    //    let allDays = (components.day ?? 0) + ((components.month ?? 0) * 30) + ((components.year ?? 0) * 12 * 30)
    //    let allDays = (components.day ?? 0) + ((components.month ?? 0)) + ((components.year ?? 0))

    return allDays + 1
}

@MainActor
public func handleImageWithKF(imgUrl:String? ,img:UIImageView ,name:String?, color: UIColor, textColor: UIColor){
    let imgTo = UIImage(color: color)
    let to = imgTo?.resized(to: CGSize(width: 40, height: 40))
    var placeHolder: UIImage?
    var textSize: CGSize?
    if let nameStr = name?.initialsFromString(string: name ?? "") {
        textSize = CGSize(width: (nameStr.width(withConstrainedHeight: 24, font: UIFont.SST_Arabic_Medium(ofSize: 18))), height: 27)
        placeHolder = textToImage(drawText: nameStr, inImage: to!, atPoint: CGPoint(x: ((40 - (nameStr.width(withConstrainedHeight: 24, font: UIFont.SST_Arabic_Medium(ofSize: 18)))) / 2), y: 9), textSize: textSize!, textColor: textColor)
    }

    img.kf.setImage(with: URL(string: imgUrl ?? ""), placeholder: placeHolder, options:nil, progressBlock: nil,completionHandler: { result in
    })
}

public func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint, textSize: CGSize,textColor:UIColor) -> UIImage {
    // let textColor = UIColor.white
    let textFont = UIFont.SST_Arabic_Medium(ofSize: 18)
    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

    let textFontAttributes = [
        NSAttributedString.Key.font: textFont,
        NSAttributedString.Key.foregroundColor: textColor,
    ] as [NSAttributedString.Key : Any]

    image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
    print("origin: \(CGPoint.zero)")

    let rect = CGRect(origin: point, size: textSize)
    text.draw(in: rect, withAttributes: textFontAttributes)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}


