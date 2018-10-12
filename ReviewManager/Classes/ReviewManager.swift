//
//  ReviewManager.swift
//  ReviewManager
//
//  Created by Qi Chen on 2018/8/8.
//

/*
 To Do:
 2. two type of popup 1. official 2. self-make pop, rate now, remind me later, leave me alone
 */

import UIKit
import StoreKit

public class ReviewManager: NSObject {
    public static let shared = ReviewManager()
    
    private struct Constants {
        static let countKey = "reviewManager_countKey"
    }
    
    public enum FireType {
        case tickOnAppOpen(Int)
        case tick(Int)
        case request
    }
    
    private var fireCount: Int!
    
    public func setUp(fireType: FireType = .tickOnAppOpen(3)) {
        switch fireType {
        case .tickOnAppOpen(let fireCount):
            self.fireCount = fireCount
            tick()
            NotificationCenter.default.addObserver(self, selector: #selector(ReviewManager.tick), name: UIApplication.willEnterForegroundNotification, object: nil)
        case .tick(let fireCount):
            self.fireCount = fireCount
        case .request:
            break
        }
    }
    
    public func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc public func tick() {
        let userDefaults = UserDefaults.standard
        var count = userDefaults.integer(forKey: Constants.countKey)
        count += 1
        if count >= 3 {
            count = 0
            requestReview()
        }
        userDefaults.set(count, forKey: Constants.countKey)
        userDefaults.synchronize()
    }
}
