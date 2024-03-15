//
//  CacheManager.swift
//  TomoVideoPlayer
//
//  Created by mobus sun on 2024/3/14.
//

import Foundation

class CacheManager {
    private let cacheDirectory: URL
    private var preloadTask: URLSessionDataTask?
    
    init() {
        // TODO: should save into share storage
        cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func loadFromCache(url: URL) -> Data? {
        let cachedFileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        guard FileManager.default.fileExists(atPath: cachedFileURL.path) else {
            return nil
        }
        do {
            return try Data(contentsOf: cachedFileURL)
        } catch {
            print("Failed to load cached data:", error)
            return nil
        }
    }
    
    func preloadHLSSegments(urls: [URL], chunkCount: Int = 2) {
        // 取消之前的预加载任务
        preloadTask?.cancel()
            
        for url in urls {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    print("Failed to preload HLS segments for URL:", url, error ?? "Unknown error")
                    return
                }
                if let manifest = String(data: data, encoding: .utf8) {
                    let segmentURLs = self?.extractSegmentURLs(from: manifest, count: chunkCount) ?? []
                    self?.preloadSegments(urls: segmentURLs)
                }
            }
            task.resume()
        }
        preloadTask = nil
    }
        
    private func extractSegmentURLs(from manifest: String, count: Int) -> [URL] {
        var urls: [URL] = []
        var segmentCount = 0
        for line in manifest.components(separatedBy: "\n") {
            if line.hasPrefix("#EXTINF:") {
                let segmentURL = line.components(separatedBy: ",")[1]
                urls.append(URL(string: segmentURL)!)
                segmentCount += 1
                if segmentCount >= count {
                    break
                }
            }
        }
        return urls
    }
    
    private func preloadSegments(urls: [URL]) {
        for url in urls {
            downloadAndSaveToCache(url: url) { result in
                switch result {
                case .success:
                    print("Segment preloaded:", url)
                case .failure(let error):
                    print("Failed to preload segment:", url, error)
                }
            }
        }
    }
    
    public func downloadAndSaveToCache(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "inc.tomo", code: 0, userInfo: nil)))
                return
            }
            let cachedFileURL = self.cacheDirectory.appendingPathComponent(url.lastPathComponent)
            do {
                try data.write(to: cachedFileURL)
                completion(.success(data))
            } catch {
                print("Failed to save data to cache:", error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
