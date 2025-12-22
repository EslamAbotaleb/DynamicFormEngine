//
//  NetworkIcon.swift
//  CERQEL
//
//  Created by Youxel on 17/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import SwiftUI
struct NetworkIcon: View {
    let icon : String?
    let width : Double
    let height : Double
    var body: some View {
        AsyncImage(url: URL(string: icon?.replace(target: "Download", withString: "Preview") ?? "")) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit().frame(width: width,height: height)
                    
            case .failure:
                Image("icon _warning").resizable().scaledToFit().frame(width: width,height: height)
            @unknown default:
                Image("icon _warning").resizable().scaledToFit().frame(width: width,height: height)
            }
        }
    }
}
