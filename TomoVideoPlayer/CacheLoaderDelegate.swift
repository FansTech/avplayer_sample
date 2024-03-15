//
//  CacheLoaderDelegate.swift
//  TomoVideoPlayer
//
//  Created by mobus sun on 2024/3/14.
//

import AVKit
import Foundation
import SwiftUI

class CacheLoaderDelegate: NSObject, AVAssetResourceLoaderDelegate {
    let cacheManager = CacheManager() // 配置一个缓存管理器

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let url = loadingRequest.request.url else {
            loadingRequest.finishLoading(with: NSError(domain: "inc.tomo", code: 0, userInfo: nil))
            return false
        }

        // 检查缓存是否存在所请求的资源
        if let cachedData = cacheManager.loadFromCache(url: url) {
            // 如果存在缓存，则直接响应请求
            loadingRequest.dataRequest?.respond(with: cachedData)
            loadingRequest.finishLoading()
            return true
        } else {
            // 否则，向网络请求资源，并保存到缓存中
            cacheManager.downloadAndSaveToCache(url: url) { result in
                switch result {
                case .success(let data):
                    loadingRequest.dataRequest?.respond(with: data)
                    loadingRequest.finishLoading()
                case .failure(let error):
                    loadingRequest.finishLoading(with: error)
                }
            }
            return true
        }
    }
}
