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

import SwiftUI

#if os(macOS)
    import AppKit
    typealias OSKUIApplication = NSApplication
#else
    import UIKit
    typealias OSKUIApplication = UIApplication
#endif

@available(iOS 15.0, OSX 12, *)
struct AppLifeCycleModifier: ViewModifier {
    let active = NotificationCenter.default.publisher(for: OSKUIApplication.didBecomeActiveNotification)
    let inactive = NotificationCenter.default.publisher(for: OSKUIApplication.willResignActiveNotification)

    private let action: (Bool) -> Void

    init(_ action: @escaping (Bool) -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .onAppear() /// `onReceive` will not work in the Modifier Without `onAppear`
            .onReceive(active, perform: { _ in
                action(true)
            })
            .onReceive(inactive, perform: { _ in
                action(false)
            })
    }
}

@available(iOS 15.0, OSX 12, *)
extension View {
    func onReceiveAppLifeCycle(perform action: @escaping (Bool) -> Void) -> some View {
        modifier(AppLifeCycleModifier(action))
    }
}
