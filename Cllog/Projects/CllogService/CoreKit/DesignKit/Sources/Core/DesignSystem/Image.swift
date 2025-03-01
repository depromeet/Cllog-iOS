//
//  Image.swift
//  DesignKit
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

extension ClLogUI where Base == Image {
    
    // Login
    public static var appleLogo: Image { Image(#function, bundle: .clLogUIBundle)}
    public static var clogLogo: Image { Image(#function, bundle: .clLogUIBundle)}
    public static var kakaoLogo: Image { Image(#function, bundle: .clLogUIBundle)}
    
    // Folder
    public static var icn_folder_selected: Image { Image(#function, bundle: .clLogUIBundle) }
    public static var icn_folder_unselected: Image { Image(#function, bundle: .clLogUIBundle) }
    
    // Record
    public static var btn_flash_off: Image { Image(#function, bundle: .clLogUIBundle)}
    public static var btn_flash_on: Image { Image(#function, bundle: .clLogUIBundle)}
    public static var icn_camera_selected: Image { Image(#function, bundle: .clLogUIBundle) }
    public static var icn_camera_unselected: Image { Image(#function, bundle: .clLogUIBundle) }
    public static var recording_on: Image { Image(#function, bundle: .clLogUIBundle) }
    public static var recording_off: Image { Image(#function, bundle: .clLogUIBundle) }
    
    // report
    public static var icn_report_selected: Image { Image(#function, bundle: .clLogUIBundle) }
    public static var icn_report_unselected: Image { Image(#function, bundle: .clLogUIBundle)}
}
