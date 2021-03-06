//
// swift-ui-kit-oskey-org
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

import Combine
import SwiftUI

@available(iOS 15.0, OSX 11.0, *)
class OSKUICarouselViewModel<OSKUIData: RandomAccessCollection, OSKUIID: Hashable>: ObservableObject {
    // MARK: - Parameters

    @Binding private var index: Int
    private let _data: OSKUIData
    private let _dataId: KeyPath<OSKUIData.Element, OSKUIID>
    private let _spacing: CGFloat
    private let _headspace: CGFloat
    private let _isWrap: Bool
    private let _sidesScaling: CGFloat
    private let _autoScroll: OSKUICarouselAutoScroll
    private let _allowSwipe: Bool

    // MARK: - Variables

    var viewSize: CGSize = .zero

    // MARK: - Publishers

    @Published var activeIndex: Int = 0
    @Published var dragOffset: CGFloat = .zero

    // MARK: - Private vars

    private var timing: TimeInterval = 0
    private var isTimerActive = true

    // MARK: - Initializer

    init(
        _ data: OSKUIData,
        id: KeyPath<OSKUIData.Element, OSKUIID>,
        index: Binding<Int>,
        spacing: CGFloat,
        headspace: CGFloat,
        sidesScaling: CGFloat,
        isWrap: Bool,
        autoScroll: OSKUICarouselAutoScroll,
        allowSwipe: Bool
    ) {
        guard index.wrappedValue < data.count else {
            fatalError("The index should be less than the count of data ")
        }

        _data = data
        _dataId = id
        _spacing = spacing
        _headspace = headspace
        _isWrap = isWrap
        _sidesScaling = sidesScaling
        _autoScroll = autoScroll
        _allowSwipe = allowSwipe

        if data.count > 1, isWrap {
            activeIndex = index.wrappedValue + 1
        } else {
            activeIndex = index.wrappedValue
        }

        _index = index
    }

//    /// The index of the currently active subview.
//    @Published var activeIndex: Int = 0 {
//        willSet {
//            if isWrap {
//                if newValue > _data.count || newValue == 0 {
//                    return
//                }
//                index = newValue - 1
//            } else {
//                index = newValue
//            }
//        }
//        didSet {
//            changeOffset()
//        }
//    }

//    /// Offset x of the view drag.
//    @Published var dragOffset: CGFloat = .zero
//
//    /// size of GeometryProxy
//    var viewSize: CGSize = .zero
//
//
//    /// Counting of time
//    /// work when `isTimerActive` is true
//    /// Toggles the active subviewview and resets if the count is the same as
//    /// the duration of the auto scroll. Otherwise, increment one
//    private var timing: TimeInterval = 0
//
//    /// Define listen to the timer
//    /// Ignores listen while dragging, and listen again after the drag is over
//    /// Ignores listen when App will resign active, and listen again when it become active
//    private var isTimerActive = true
    func setTimerActive(_ active: Bool) {
        isTimerActive = active
    }
}

@available(iOS 15.0, OSX 11.0, *)
extension OSKUICarouselViewModel where OSKUIID == OSKUIData.Element.ID, OSKUIData.Element: Identifiable {
    convenience init(
        _ data: OSKUIData,
        index: Binding<Int>,
        spacing: CGFloat,
        headspace: CGFloat,
        sidesScaling: CGFloat,
        isWrap: Bool,
        autoScroll: OSKUICarouselAutoScroll,
        allowSwipe: Bool
    ) {
        self.init(
            data,
            id: \.id,
            index: index,
            spacing: spacing,
            headspace: headspace,
            sidesScaling: sidesScaling,
            isWrap: isWrap,
            autoScroll: autoScroll,
            allowSwipe: allowSwipe
        )
    }
}

@available(iOS 15.0, OSX 11.0, *)
extension OSKUICarouselViewModel {
    var data: OSKUIData {
        guard _data.count != 0 else {
            return _data
        }
        guard _data.count > 1 else {
            return _data
        }
        guard isWrap else {
            return _data
        }
        return [_data.last!] + _data + [_data.first!] as! OSKUIData
    }

    var dataId: KeyPath<OSKUIData.Element, OSKUIID> {
        _dataId
    }

    var spacing: CGFloat {
        _spacing
    }

    var offsetAnimation: Animation? {
        guard isWrap else {
            return .spring()
        }
        return isAnimatedOffset ? .spring() : .none
    }

    var itemWidth: CGFloat {
        max(0, viewSize.width - defaultPadding * 2)
    }

    var timer: OSKUITimePublisher? {
        guard autoScroll.isActive else {
            return nil
        }
        return Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    /// Defines the scaling based on whether the item is currently active or not.
    /// - Parameter item: The incoming item
    /// - Returns: scaling
    func itemScaling(_ item: OSKUIData.Element) -> CGFloat {
        guard activeIndex < data.count else {
            return 0
        }
        let activeItem = data[activeIndex as! OSKUIData.Index]
        return activeItem[keyPath: _dataId] == item[keyPath: _dataId] ? 1 : sidesScaling
    }

    func isActiveItem(_ item: OSKUIData.Element) -> Bool {
        guard activeIndex < data.count else {
            return false
        }
        let activeItem = data[activeIndex as! OSKUIData.Index]
        return activeItem[keyPath: _dataId] == item[keyPath: _dataId]
    }
}

// MARK: - private variable

@available(iOS 15.0, OSX 11.0, *)
private extension OSKUICarouselViewModel {
    var isWrap: Bool {
        _data.count > 1 ? _isWrap : false
    }

    var autoScroll: OSKUICarouselAutoScroll {
        guard _data.count > 1 else { return .inactive }
        guard case let .active(t) = _autoScroll else { return _autoScroll }
        return t > 0 ? _autoScroll : .defaultActive
    }

    var defaultPadding: CGFloat {
        _headspace + spacing
    }

    var itemActualWidth: CGFloat {
        itemWidth + spacing
    }

    var sidesScaling: CGFloat {
        max(min(_sidesScaling, 1), 0)
    }

    /// Is animated when view is in offset
    var isAnimatedOffset: Bool {
        get { UserDefaults.isAnimatedOffset }
        set { UserDefaults.isAnimatedOffset = newValue }
    }
}

// MARK: - Offset Method

@available(iOS 15.0, OSX 11.0, *)
extension OSKUICarouselViewModel {
    /// current offset value
    var offset: CGFloat {
        let activeOffset = CGFloat(activeIndex) * itemActualWidth
        return defaultPadding - activeOffset + dragOffset
    }

    /// change offset when acitveItem changes
    private func changeOffset() {
        isAnimatedOffset = true
        guard isWrap else {
            return
        }

        let minimumOffset = defaultPadding
        let maxinumOffset = defaultPadding - CGFloat(data.count - 1) * itemActualWidth

        if offset == minimumOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.activeIndex = self.data.count - 2
                self.isAnimatedOffset = false
            }
        } else if offset == maxinumOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.activeIndex = 1
                self.isAnimatedOffset = false
            }
        }
    }
}

// MARK: - Drag Gesture

@available(iOS 15.0, OSX 11.0, *)
extension OSKUICarouselViewModel {
    /// drag gesture of view
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged(dragChanged)
            .onEnded(dragEnded)
    }

    private func dragChanged(_ value: DragGesture.Value) {
        guard _allowSwipe else { return }

        isAnimatedOffset = true

        /// Defines the maximum value of the drag
        /// Avoid dragging more than the values of multiple subviews at the end of the drag,
        /// and still only one subview is toggled
        var offset: CGFloat = itemActualWidth
        if value.translation.width > 0 {
            offset = min(offset, value.translation.width)
        } else {
            offset = max(-offset, value.translation.width)
        }

        /// set drag offset
        dragOffset = offset

        /// stop active timer
        isTimerActive = false
    }

    private func dragEnded(_ value: DragGesture.Value) {
        guard _allowSwipe else { return }
        /// reset drag offset
        dragOffset = .zero

        /// reset timing and restart active timer
        resetTiming()
        isTimerActive = true

        /// Defines the drag threshold
        /// At the end of the drag, if the drag value exceeds the drag threshold,
        /// the active view will be toggled
        /// default is one third of subview
        let dragThreshold: CGFloat = itemWidth / 3

        var activeIndex = activeIndex
        if value.translation.width > dragThreshold {
            activeIndex -= 1
        }
        if value.translation.width < -dragThreshold {
            activeIndex += 1
        }
        self.activeIndex = max(0, min(activeIndex, data.count - 1))
    }
}

// MARK: - Receive Timer

@available(iOS 15.0, OSX 11.0, *)
extension OSKUICarouselViewModel {
    /// timer change
    func receiveTimer(_: Timer.TimerPublisher.Output) {
        /// Ignores listen when `isTimerActive` is false.
        guard isTimerActive else {
            return
        }
        /// increments of one and compare to the scrolling duration
        /// return when timing less than duration
        activeTiming()
        timing += 1
        if timing < autoScroll.interval {
            return
        }

        if activeIndex == data.count - 1 {
            /// `isWrap` is false.
            /// Revert to the first view after scrolling to the last view
            activeIndex = 0
        } else {
            /// `isWrap` is true.
            /// Incremental, calculation of offset by `offsetChanged(_: proxy:)`
            activeIndex += 1
        }
        resetTiming()
    }

    /// reset counting of time
    private func resetTiming() {
        timing = 0
    }

    /// time increments of one
    private func activeTiming() {
        timing += 1
    }
}

private extension UserDefaults {
    private enum Keys {
        static let isAnimatedOffset = "isAnimatedOffset"
    }

    static var isAnimatedOffset: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.isAnimatedOffset)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isAnimatedOffset)
        }
    }
}
