//
//  StatusCode.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import Foundation

enum StatusCode: String {
    case inProgress = "in_progress"
    case pending
    case escalated
    case closed
    case approved
    case completed
    case sentBack = "sentback"
    case sendBack = "sendback"
    case withdrawn
    case withdraw
    case rejected
    case new
    case delegated

    var textColor: UIColor {
        switch self {
        case .sentBack, .sendBack:
            return .init(hexString: "#C216FE")
        case .inProgress:
            return .init(hexString: "#3797EF")
        case .pending:
            return .init(hexString: "#FFA072")
        case .escalated:
            return .init(hexString: "#7A72D4")
        case .closed:
            return .init(hexString: "#C93838")
        case .approved:
            return .init(hexString: "#1B998B")
        case .completed:
            return .init(hexString: "#1B998B")
        case .withdrawn, .withdraw:
            return .init(hexString: "#35495E")
        case .rejected:
            return .init(hexString: "#D51B5E")
        case .new:
            return .init(hexString: "#FFA072")
        case .delegated:
            return .init(hexString: "#7A72D4")
        }
    }
    
    var backgroundColor: UIColor {
        return self.textColor.withAlphaComponent(0.08)
    }
}

enum StatusColor: String {
    case orange = "orange"
    case gray = "gray"
    case green = "green"
    case red = "red"
    
    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "orange":
            self = .orange
        case "gray":
            self = .gray
        case "green":
            self = .green
        case "red":
            self = .red
        default:
            return nil
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .orange:
            return .squash
        case .gray:
            return .blue_grey
        case .green:
            return .alertApprovedSuccess
        case .red:
            return UIColor(red: 0.9450980392, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .orange:
            return .squash.withAlphaComponent(0.1)
        case .gray:
            return .blue_grey.withAlphaComponent(0.1)
        case .green:
            return .alertApprovedSuccess.withAlphaComponent(0.1)
        case .red:
            return UIColor(red: 0.9450980392, green: 0.4196078431, blue: 0.4196078431, alpha: 0.1044788099)
        }
    }
}

