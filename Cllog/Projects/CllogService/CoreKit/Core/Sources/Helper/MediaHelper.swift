//
//  MediaHelper.swift
//  Core
//
//  Created by soi on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared
import Photos

public enum MediaUtility {
    public static func getURL(fromAssetID assetID: String) async -> URL? {
        await withCheckedContinuation { continuation in
            PHAsset.getURL(fromAssetID: assetID) { url in
                continuation.resume(returning: url)
            }
        }
    }
}
