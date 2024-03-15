//
//  ContentView.swift
//  TomoVideoPlayer
//
//  Created by mobus sun on 2024/3/14.
//

import SwiftUI

struct ContentView: View {
    let videoURLs = [
        URL(string: "https://customer-sn5y0tm58c41dbpc.cloudflarestream.com/26f31c067c7561e0ecb806d23972fb80/manifest/video.m3u8")!,
        URL(string: "https://customer-sn5y0tm58c41dbpc.cloudflarestream.com/505fb6c5789ff60aa1d1dbe60c27c420/manifest/video.m3u8")!,
        URL(string: "https://customer-sn5y0tm58c41dbpc.cloudflarestream.com/7814188a7e9dfba238f0ac0a4823d95a/manifest/video.m3u8")!,
        URL(string: "https://customer-sn5y0tm58c41dbpc.cloudflarestream.com/d6a062a6bbd9e03189dc221031f364a8/manifest/video.m3u8")!,
        URL(string: "https://customer-sn5y0tm58c41dbpc.cloudflarestream.com/2bb284bfd2c2d8865a6dfe064040f6e4/manifest/video.m3u8")!,
        URL(string: "https://customer-sn5y0tm58c41dbpc.cloudflarestream.com/80637e1748f94be9aa0456b694e75056/manifest/video.m3u8")!,
        URL(string: "https://customer-sn5y0tm58c41dbpc.cloudflarestream.com/7f7a600c1ff5fa3f560c6e3610fed503/manifest/video.m3u8")!,
        URL(string: "https://customer-sn5y0tm58c41dbpc.cloudflarestream.com/9b23e3c1ad4ae5eef6712152bfd07d6b/manifest/video.m3u8")!,
//        URL(string: "https://r2.sv-dev.unyx.tech/1710429501493-CF9111D2-0894-42CB-8146-9E4D2AE00758_L0_001_1710429115.562107_IMG_0351.MOV")!,
//        URL(string: "https://r2.sv-dev.unyx.tech/1710429453128-D7BC3878-9B04-44F4-8D61-6835F57277C1_L0_001_1710234855.124175_IMG_8071MP4")!,
        URL(string: "https://customer-sn5y0tm58c41dbpc.cloudflarestream.com/7876d04a262c1bbbbe052ed72aa21fe7/manifest/video.m3u8")!
    ]

    var body: some View {
        VideoPlayerScrollView(urls: videoURLs)
            .frame(width: 960, height: 540)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
