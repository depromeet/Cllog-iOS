//
//  Image.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import SwiftUI

extension ClLogUI where Base == UIImage {
    public static var appleLogo: UIImage { asset(#function) }
    public static var clogLogo: UIImage { asset(#function) }
    public static var kakaoLogo: UIImage { asset(#function) }
    public static var recodeButton: UIImage { asset(#function) }
    public static var recordingButton: UIImage { asset(#function) }
    
}

extension ClLogUI where Base == Image {
    public static var appleLogo: Image { asset(#function) }
    public static var clogLogo: Image { asset(#function) }
    public static var kakaoLogo: Image { asset(#function) }
    public static var recodeButton: Image { asset(#function) }
    public static var recordingButton: Image { asset(#function) }
}

extension ClLogUI where Base == UIImage {
    
    private static func asset(_ name: String) -> UIImage {
        guard let image = UIImage(named: name, in: .module, with: nil) else {
            assertionFailure("can't find image asset: \(name)")
            return UIImage()
        }
        return image
    }
}

extension ClLogUI where Base == Image {
    private static func asset(_ name: String) -> Image {
        return Image(uiImage: UIImage.clLogUI.asset(name))
    }
}
