//
// swift-ui-carousel-oskey-org
// Copyright (c) 2022 OSkey SAS. MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import SwiftUI

/// A control that displays horizontally sliding cards
///
/// Several aspect of the carousel can be customized:
///   - `spacing`: The distance between adjacent subviews. The default is `16`.
///   - `headspace`: The width of the exposed side subviews, default is `16`.
///   - `sidesScaling`: The scale of the subviews on both sides, between 0 and 1. The default is `0.8`.
///   - `isWrap`: When `true`, it restart from the beginning when it reach the end, default is `false`.
///   - `autoScroll`: Set to `.active(_:)` or `.inactive`the autoscrolling. When set to
///     `.active(_ timeInterval :TimeInterval)`, it scrolls automatically, every
///     `timeInterval` second(s). The default is `.inactive`.
///   - `allowSwipe`: Allow user to swipe left or right
///
/// The style can also be defined using ``oskuiCarouselStyle(_:)``.
///
/// This control relies on the parent view been bound, therefore, if used inside an unbound view (like
/// ``ScrollView``), a ``GeometryProxy`` must be provided.///
///
public struct OSKUICarousel<OSKUIData: RandomAccessCollection, OSKUIID: Hashable, OSKUIContent: View> : View {
    private let content: (OSKUIData.Element) -> OSKUIContent
    private let proxy: GeometryProxy?

    @ObservedObject private var viewModel: OSKUICarouselViewModel<OSKUIData, OSKUIID>

    @Environment(\.oskuiCarouselStyle) private var style: OSKUIAnyCarouselStyle
    
    // MARK: - Initializer
    
    /// Creates an instance that uniquely identifies and creates views across updates based on the provided
    /// key path to the underlying data’s identifier.
    ///
    /// - Parameters:
    ///   - data: The data that the ``OSKUICarousel`` instance uses to create views  dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - index: The index of currently active.
    ///   - spacing: The distance between adjacent subviews. The default is `16`.
    ///   - headspace: The width of the exposed side subviews, default is `16`.
    ///   - sidesScaling: The scale of the subviews on both sides, between 0 and 1. The default is `0.8`.
    ///   - isWrap: When `true`, it restart from the beginning when it reach the end, default is `false`.
    ///   - autoScroll: Set to `.active(_:)` or `.inactive`the autoscrolling. When set to
    ///     `.active(_ timeInterval :TimeInterval)`, it scrolls automatically, every
    ///     `timeInterval` second(s). The default is `.inactive`.
    ///   - allowSwipe: Allow user to swipe left or right
    ///   - proxy: The geometry proxy when placed in unbound container (like ``ScrollView``)
    ///   - content: A block generated based on a given `OSKUIData.Element`.
    ///
    public init(
        _ data: OSKUIData,
        id: KeyPath<OSKUIData.Element, OSKUIID>,
        index: Binding<Int> = .constant(0),
        spacing: CGFloat = 16,
        headspace: CGFloat = 16,
        sidesScaling: CGFloat = 0.8,
        isWrap: Bool = false,
        autoScroll: OSKUICarouselAutoScroll = .inactive,
        allowSwipe: Bool = true,
        proxy: GeometryProxy? = nil,
        @ViewBuilder content: @escaping (OSKUIData.Element) -> OSKUIContent
    ) {
        self.viewModel = OSKUICarouselViewModel(
            data,
            id: id,
            index: index,
            spacing: spacing,
            headspace: headspace,
            sidesScaling: sidesScaling,
            isWrap: isWrap,
            autoScroll: autoScroll,
            allowSwipe: allowSwipe
        )
        self.content = content
        self.proxy = proxy
        if let proxy = proxy {
            viewModel.viewSize = proxy.size
        }
    }
    
    // MARK: - Private

    /// Generate the content (fill the configuration, then call the style)
    ///
    private func generateContent(proxy: GeometryProxy) -> some View {
        var index: Int = 0
        let configuration = OSKUICarouselStyleConfiguration(
            content: AnyView(
                HStack(spacing: viewModel.spacing) {
                    ForEach(viewModel.data, id: viewModel.dataId) {
                        content($0)
                            .frame(minWidth: viewModel.itemWidth)
                            .scaleEffect(x: 1, y: viewModel.itemScaling($0), anchor: .center)
                    }
                }
                .frame(width: proxy.size.width, alignment: .leading)
                .offset(x: viewModel.offset)
                .gesture(viewModel.dragGesture)
                .animation(viewModel.offsetAnimation, value: viewModel.offset)
                .onReceive(timer: viewModel.timer, perform: viewModel.receiveTimer)
                .onReceiveAppLifeCycle(perform: viewModel.setTimerActive)
            ),
            maxWidth: proxy.size.width,
            itemMaxWidth: viewModel.itemWidth,
            dots: viewModel.data.map {
                let dot = OSKUICarouselDot(index: index, isActiveItem: viewModel.isActiveItem($0))
                index += 1
                return dot
            }
        )
        
        return  style.makeBody(configuration: configuration)
    }

    /// Generate the body
    ///
    public var body: some View {
        ZStack {
            if let proxy = proxy {
                AnyView(generateContent(proxy: proxy))
            } else {
                GeometryReader { proxy -> AnyView in
                    viewModel.viewSize = proxy.size
                    return AnyView(generateContent(proxy: proxy))
                }
            }
        }
    }
}

@available(iOS 15.0, OSX 11.0, *)
extension OSKUICarousel where OSKUIID == OSKUIData.Element.ID, OSKUIData.Element: Identifiable {

    /// Creates an instance that uniquely identifies and creates views across updates based on the identity
    /// of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``OSKUICarousel`` instance uses to  create views
    ///     dynamically.
    ///   - index: The index of currently active.
    ///   - spacing: The distance between adjacent subviews. The default is `16`.
    ///   - headspace: The width of the exposed side subviews, default is `16`.
    ///   - sidesScaling: The scale of the subviews on both sides, between 0 and 1. The default is `0.8`.
    ///   - isWrap: When `true`, it restart from the beginning when it reach the end, default is `false`.
    ///   - autoScroll: Set to `.active(_:)` or `.inactive`the autoscrolling. When set to
    ///     `.active(_ timeInterval :TimeInterval)`, it scrolls automatically, every
    ///     `timeInterval` second(s). The default is `.inactive`.
    ///   - allowSwipe: Allow user to swipe left or right
    ///   - proxy: The geometry proxy when placed in unbound container (like ``ScrollView``)
    ///   - content: A block generated based on a given `OSKUIData.Element`.
    ///
    ///
    public init(
        _ data: OSKUIData,
        index: Binding<Int> = .constant(0),
        spacing: CGFloat = 16,
        headspace: CGFloat = 16,
        sidesScaling: CGFloat = 0.8,
        isWrap: Bool = false,
        autoScroll: OSKUICarouselAutoScroll = .inactive,
        allowSwipe: Bool = true,
        proxy: GeometryProxy? = nil,
        @ViewBuilder content: @escaping (OSKUIData.Element) -> OSKUIContent
    ) {
        self.viewModel = OSKUICarouselViewModel(
            data,
            index: index,
            spacing: spacing,
            headspace: headspace,
            sidesScaling: sidesScaling,
            isWrap: isWrap,
            autoScroll: autoScroll,
            allowSwipe: allowSwipe
        )
        self.content = content
        self.proxy = proxy
        if let proxy = proxy {
            viewModel.viewSize = proxy.size
        }
    }
}

@available(iOS 15.0, OSX 11.0, *)
struct OSKUICarousel_LibraryContent: LibraryContentProvider {
    let Datas = Array(repeating: _Item(color: .red), count: 3)

    @LibraryContentBuilder var views: [LibraryItem] {
        /// A simple carousel, with everything defaulted
        ///
        LibraryItem(
            OSKUICarousel(Datas) { _ in },
            title: "OSkey UI - Carousel",
            category: .control
        )

        /// A simple carousel, with every properties
        ///
        LibraryItem(
            OSKUICarousel(
                Datas,
                index: .constant(0),
                spacing: 10,
                headspace: 10,
                sidesScaling: 0.8,
                isWrap: false,
                autoScroll: .inactive,
                allowSwipe: true
            ) { _ in },
            title: "OSkey UI - Carousel (full)",
            category: .control
        )
    }

    @LibraryContentBuilder func modifiers<OSKUIData: RandomAccessCollection, OSKUIID: Hashable, OSKUIContent: View>(base: OSKUICarousel<OSKUIData, OSKUIID, OSKUIContent>) -> [LibraryItem] {
        /// Set a style for a carousel
        ///
        /// The style must implement the ``OSKUICarouselStyle`` protocol.
        LibraryItem(
            base.oskuiCarouselStyle(OSKUIDefaultCarouselStyle()),
            title: "OSkey UI - Carousel Style",
            category: .control
        )
    }
    
    struct _Item: Identifiable {
        let id = UUID()
        let color: Color
    }
}
