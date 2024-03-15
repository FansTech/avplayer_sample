//
//  Video.swift
//  TomoVideoPlayer
//
//  Created by mobus sun on 2024/3/14.
//

import SwiftUI

struct Video {
    let url: URL
    let cacheManager = CacheManager()

    func preload() {
        cacheManager.downloadAndSaveToCache(url: url) { result in
            switch result {
            case .success(let count):
                print("Video preloaded:", count, "bytes")
            case .failure(let error):
                print("Failed to preload video:", error)
            }
        }
    }
}
