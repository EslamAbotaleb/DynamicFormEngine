//
//  TopNavigationBarViewWidget.swift
//  SwiftUIDemo
//
//  Created by Youxel on 31/10/2023.
//

import SwiftUI

public struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    let onBack: (()->())?

    public var body: some View {
        
        HStack {
            Image("swiftUIBackIcon")
                .foregroundStyle(Color(uiColor: typographyTitle))
                .rotationEffect(isArabic() ? Angle(degrees: 180) : .zero)
            Button("Back".localized) {
                //presentationMode.wrappedValue.dismiss()
                dismiss()
                onBack!()
            }
            .font(CerqelFonts.bodyLMedium)
            .buttonStyle(.plain)
            .foregroundColor(Color(uiColor: typographyTitle))
           
        }
    }
}

public class NavigationBarHiddenUIHostingController<Content: View>: UIHostingController<Content> {

    override public func viewDidLoad() {
        super.viewDidLoad()
        if navigationController?.isNavigationBarHidden == false {
          navigationController?.isNavigationBarHidden = true
        }
    }

}
