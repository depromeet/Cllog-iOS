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
    
    // icon
    public static var alert: UIImage { asset(#function) }
    public static var back: UIImage { asset(#function) }
    public static var camera: UIImage { asset(#function) }
    public static var close: UIImage { asset(#function) }
    public static var down: UIImage { asset(#function) }
    public static var flashOff: UIImage { asset(#function) }
    public static var flashOn: UIImage { asset(#function) }
    public static var folder: UIImage { asset(#function) }
    public static var list: UIImage { asset(#function) }
    public static var location: UIImage { asset(#function) }
    public static var report: UIImage { asset(#function) }
    public static var right: UIImage { asset(#function) }
    public static var share: UIImage { asset(#function) }
    public static var stamp: UIImage { asset(#function) }
    public static var up: UIImage { asset(#function) }
    public static var dotVertical: UIImage { asset(#function) }
    public static var calendarAfter: UIImage { asset(#function) }
    public static var calendarBefore: UIImage { asset(#function) }
    public static var time: UIImage { asset(#function) }
    public static var check: UIImage { asset(#function) }
    public static var setting: UIImage { asset(#function) }
}

extension ClLogUI where Base == Image {
    public static var appleLogo: Image { asset(#function) }
    public static var clogLogo: Image { asset(#function) }
    public static var kakaoLogo: Image { asset(#function) }
    public static var recodeButton: Image { asset(#function) }
    public static var recordingButton: Image { asset(#function) }
    
    // icon
    public static var alert: Image { asset(#function) }
    public static var back: Image { asset(#function) }
    public static var camera: Image { asset(#function) }
    public static var close: Image { asset(#function) }
    public static var down: Image { asset(#function) }
    public static var flashOff: Image { asset(#function) }
    public static var flashOn: Image { asset(#function) }
    public static var folder: Image { asset(#function) }
    public static var list: Image { asset(#function) }
    public static var location: Image { asset(#function) }
    public static var report: Image { asset(#function) }
    public static var right: Image { asset(#function) }
    public static var share: Image { asset(#function) }
    public static var stamp: Image { asset(#function) }
    public static var stampSmall: Image { asset(#function) }
    public static var up: Image { asset(#function) }
    public static var dotVertical: Image { asset(#function) }
    public static var calendarAfter: Image { asset(#function) }
    public static var calendarBefore: Image { asset(#function) }
    public static var time: Image { asset(#function) }
    public static var icn_close: Image { asset(#function) }
    public static var check: Image { asset(#function) }
    public static var setting: Image { asset(#function) }
    
    // Edit
    public static var playSmall: Image { asset(#function) }
    public static var stopSmall: Image { asset(#function) }
    public static var redo: Image { asset(#function) }
    public static var undo: Image { asset(#function) }
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
