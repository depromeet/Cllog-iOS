//
//  UserDefault.swift
//  VideoFeature
//
//  Created by Junyoung on 3/26/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import VideoDomain

enum VideoDataKey {
    static let storyId = "storyId"
    static let problemId = "problemId"
    static let attemptCount = "attemptCount"
}

struct VideoDataManager {
    static var savedStory: SavedStory? {
        guard let storyId = storyId, let problemId = problemId else {
            return nil
        }
        return SavedStory(storyId: storyId, problemId: problemId)
    }
    
    static func save(story: SavedStory) {
        storyId = story.storyId
        problemId = story.problemId
    }
    
    static func clear() {
        storyId = nil
        problemId = nil
        attemptCount = 0
    }
    
    private static var storyId: Int? {
        get {
            UserDefaults.standard.object(forKey: VideoDataKey.storyId) as? Int
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: VideoDataKey.storyId)
            } else {
                UserDefaults.standard.removeObject(forKey: VideoDataKey.storyId)
            }
        }
    }

    private static var problemId: Int? {
        get {
            UserDefaults.standard.object(forKey: VideoDataKey.problemId) as? Int
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: VideoDataKey.problemId)
            } else {
                UserDefaults.standard.removeObject(forKey: VideoDataKey.problemId)
            }
        }
    }
    
    static var attemptCount: Int {
        get {
            UserDefaults.standard.integer(forKey: VideoDataKey.attemptCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: VideoDataKey.attemptCount)
        }
    }
}
