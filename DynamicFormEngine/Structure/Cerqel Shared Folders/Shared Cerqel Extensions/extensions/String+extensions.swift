//
//  String+extensions.swift
//  CERQEL
//
//  Created by mac on 7/27/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        
        
        return ceil(boundingBox.width)
        
    }
    
       
    
    //    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    
    //        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    
    //        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
    //        print(ceil(boundingBox.height))
    
    //        return ceil(boundingBox.height)
    
    //    }
    
       
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        
        label.numberOfLines = 0
        
        label.text = self
        
        label.font = font
        
        label.sizeToFit()
        
               
        
        return label.frame.height
        
    }
    
       
    
    func lines(font : UIFont, width : CGFloat) -> Int {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return Int(boundingBox.height/font.lineHeight)
        
    }
    
    
    
    func size(font: UIFont, width: CGFloat) -> CGFloat {
        
        let attrString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
        
        let bounds = attrString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return bounds.width
        
    }
    
    func initialsFromString(string: String) -> String {
        var nameComponents = string.uppercased().components(separatedBy: CharacterSet.letters.inverted)
        nameComponents.removeAll(where: {$0.isEmpty})
        
        let firstInitial = nameComponents.first?.first
        let lastInitial  = nameComponents.count > 1 ? nameComponents[1].first : nil
    //        let lastInitial  = nameComponents.count > 1 ? nameComponents.last?.first : nil
        
        var isAr: Bool?
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
        predicate.evaluate(with: string)
        if predicate.evaluate(with: string) {
            isAr = true
        } else {
            isAr = false
        }
        
        if isAr ?? false {
            return (firstInitial != nil ? "\(firstInitial!) " : "") + (lastInitial != nil ? "\(lastInitial!)" : "")
        } else {
            return (firstInitial != nil ? "\(firstInitial!)" : "") + (lastInitial != nil ? "\(lastInitial!)" : "")
        }
    }
    
    func getImageFromBase64()-> UIImage?{
        let strr = self.replacingOccurrences(of: "data:image/png;base64,", with: "")
        let imageData = Data.init(base64Encoded: strr, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image
    }
    
    func base64DecodedImageData() -> Data? {
         // Check if the string contains a base64 metadata prefix like "data:image/png;base64,"
         guard let range = self.range(of: "base64,") else {
             // If no prefix is found, try to decode the string directly as a base64 string
             return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
         }
         
         // Extract the actual base64 string part (remove the prefix)
         let base64ImageString = self[range.upperBound...]
         
         // Decode the base64 string into Data
         return Data(base64Encoded: String(base64ImageString), options: .ignoreUnknownCharacters)
     }
    
    /// Converts a base64-encoded image string into a URL by saving it to a temporary file.
      /// - Returns: A `URL` pointing to the saved image file, or `nil` if the conversion fails.
      func base64ImageToTemporaryURL() -> URL? {
          // Step 1: Check if the string contains the base64 metadata prefix like "data:image/png;base64,"
          guard let range = self.range(of: "base64,") else {
              // If no prefix is found, try to decode the string directly as base64 data
              guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
                  print("Failed to decode base64 string")
                  return nil
              }
              return saveImageDataToTemporaryURL(imageData: imageData)
          }
          
          // Step 2: Remove the "data:image/png;base64," prefix
          let base64ImageString = self[range.upperBound...]
          
          // Step 3: Decode the Base64 string into Data
          guard let imageData = Data(base64Encoded: String(base64ImageString), options: .ignoreUnknownCharacters) else {
              print("Failed to decode base64 string")
              return nil
          }
          
          // Step 4: Save the image data to a temporary file and return the file URL
          return saveImageDataToTemporaryURL(imageData: imageData)
      }
      
      /// Saves the image data to a temporary file and returns the file URL.
      private func saveImageDataToTemporaryURL(imageData: Data) -> URL? {
          // Create a temporary file URL
          let tempDirectory = FileManager.default.temporaryDirectory
          let fileName = UUID().uuidString + ".png"  // Unique filename with .png extension
          let tempFileURL = tempDirectory.appendingPathComponent(fileName)
          
          do {
              // Write the image data to the temporary file
              try imageData.write(to: tempFileURL)
              return tempFileURL
          } catch {
              print("Failed to write image data to file: \(error)")
              return nil
          }
      }
    
    func base64ImageToCustomMediaURL() -> String? {
        // Step 1: Check if the string contains the base64 metadata prefix like "data:image/png;base64,"
        guard let range = self.range(of: "base64,") else {
            print("Invalid base64 string")
            return nil
        }

        // Step 2: Remove the "data:image/png;base64," prefix
        let base64ImageString = self[range.upperBound...]

        // Step 3: Decode the Base64 string into Data
        guard let imageData = Data(base64Encoded: String(base64ImageString), options: .ignoreUnknownCharacters) else {
            print("Failed to decode base64 string")
            return nil
        }

        // Step 4: Save the image data to a temporary file
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".png"  // Unique filename with .png extension
        let tempFileURL = tempDirectory.appendingPathComponent(fileName)

        do {
            // Write the image data to the temporary file
            try imageData.write(to: tempFileURL)
            
            // Step 5: Convert the temporary file URL to a string and generate the custom media URL
            let tempFileString = tempFileURL.absoluteString
            return tempFileString.cerqel_CreateMediaURL()

        } catch {
            print("Failed to write image data to file: \(error)")
            return nil
        }
    }
    
       func convertToTimeAgo() -> String {
           // Check for nil or empty string
           guard !self.isEmpty else {
                      return "_"
                  }
                  
        // Assuming `getDateFromString()` is a method that converts the string to a Date object
          let date = self.getDateFromString() ?? Date()

           let secondsAgo = Int(Date().timeIntervalSince(date))
           let minutesAgo = secondsAgo / 60
           let hoursAgo = minutesAgo / 60
           let daysAgo = hoursAgo / 24
           let weeksAgo = daysAgo / 7
           let monthsAgo = weeksAgo / 4
           let yearsAgo = monthsAgo / 12

           var timeAgo = ""
           if yearsAgo > 0 {
//               timeAgo = "\(yearsAgo) \(yearsAgo == 1 ? "year".localized : "years".localized)"
               timeAgo = self.formatToLocalizedDateString(formate: "dd MMM yyyy")
           } else if monthsAgo > 0 {
//               timeAgo = "\(monthsAgo) \(monthsAgo == 1 ? "month".localized : "months".localized)"
               timeAgo = self.formatToLocalizedDateString(formate: "dd MMM yyyy")
           } else if weeksAgo > 0 {
//               timeAgo = "\(weeksAgo) \(weeksAgo == 1 ? "week".localized : "weeks".localized)"
               timeAgo = self.formatToLocalizedDateString(formate: "dd MMM yyyy")
           } else if daysAgo > 0 {
               timeAgo =  daysAgo == 1 ? "day ago".localized : (daysAgo > 1 ) && (daysAgo < 11) ?  String(format: "days ago".localized, "\(daysAgo)") : String(format: "dayss ago".localized, "\(daysAgo)")
           } else if hoursAgo > 0 {
               timeAgo =  hoursAgo == 1 ? "hour ago".localized : (hoursAgo > 1 ) && (hoursAgo < 11) ?  String(format: "hours ago".localized, "\(hoursAgo)") : String(format: "hourss ago".localized, "\(hoursAgo)")
           } else if minutesAgo > 0 {
               timeAgo = minutesAgo == 1 ? "minute ago".localized : (minutesAgo > 1 ) && (minutesAgo < 11) ? String(format: "minutes ago".localized, "\(minutesAgo)") : String(format: "minutess ago".localized, "\(minutesAgo)")
           } else {
               timeAgo = secondsAgo == 1 ? "second ago".localized : (hoursAgo > 1 ) && (hoursAgo < 11) ? String(format: "seconds ago".localized, "\(secondsAgo)") : String(format: "secondss ago".localized, "\(secondsAgo)")
           }

           return timeAgo
       }
}

extension String {
    
    var withoutHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>",
                                         with: "",
                                         options: .regularExpression,
                                         range: nil)
        .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

