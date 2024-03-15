//
//  VideoPlayerView.swift
//  TomoVideoPlayer
//
//  Created by mobus sun on 2024/3/14.
//

import AVKit
import SwiftUI

struct VideoPlayerScrollView: View {
    let urls: [URL]
    @State private var currentIndex: Int = 0
    @State private var isPlaying: [Bool]
    @State private var players: [AVPlayer] = []
    private let cacheLoaderDelegate = CacheLoaderDelegate()

    init(urls: [URL]) {
        self.urls = urls
        self._isPlaying = State(initialValue: Array(repeating: false, count: urls.count))
        self._players = State(initialValue: urls.map { url in
            
            let asset = AVURLAsset(url: url)
            asset.resourceLoader.setDelegate(cacheLoaderDelegate, queue: DispatchQueue.global())
            
            return AVPlayer(playerItem: AVPlayerItem(asset: asset))
        })
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0 ..< players.count, id: \.self) { index in
                        PlayerView(player: self.players[index])
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .rotation3DEffect(
                                .degrees(Double(index - currentIndex) * -30),
                                axis: (x: 0.0, y: 1.0, z: 0.0),
                                anchor: .center
                            )
                            .onAppear {
                                if currentIndex == index {
                                    players[index].play()
                                } else {
                                    players[index].pause()
                                }
                            }
                    }
                }
            }
            .content.offset(x: CGFloat(currentIndex) * -geometry.size.width)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let offset = value.translation.width
                        let newIndex = currentIndex + (offset > 0 ? -1 : 1)
                        if newIndex >= 0, newIndex < players.count {
                            currentIndex = newIndex
                        }
                    }
            )
        }
        .onAppear {
            // TODO: 需要兼容 非流媒体视频
            CacheManager().preloadHLSSegments(urls: urls)
        }
        .onChange(of: currentIndex, initial: false) { _, newIndex in
            if newIndex >= 0 && newIndex < players.count {
                let player = players[newIndex]
                player.seek(to: .zero)
                player.play()
            }

            for (index, player) in players.enumerated() {
                if index != newIndex {
                    player.pause()
                }
            }
        }
    }
}

struct PlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(player: player)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update code if needed
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()

    init(player: AVPlayer) {
        super.init(frame: .zero)
        playerLayer.player = player
        layer.addSublayer(playerLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
