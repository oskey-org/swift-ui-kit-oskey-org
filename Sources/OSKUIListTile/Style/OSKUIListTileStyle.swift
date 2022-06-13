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

/// A type that applies standard interaction behavior and a custom appearance to all list tiles within a view
/// hierarchy.
///
/// To configure the current list tile style for a view hierarchy, use the ``oskuiListTileStyle(_:)``
/// modifier. Specify a style that conforms to ``OSKUIListTileStyle`` when creating a list tile that
/// uses the standard list tile interaction behavior defined for each platform.
///
@available(iOS 15.0, OSX 12, *)
public protocol OSKUIListTileStyle {
    /// A view that represents the body of a list tile.
    ///
    associatedtype OSKUIBody: View

    /// Creates a view that represents the body of a list tile.
    ///
    func makeBody(configuration: Self.OSKUIConfiguration) -> Self.OSKUIBody

    /// The properties of a list tile.
    ///
    typealias OSKUIConfiguration = OSKUIListTileStyleConfiguration
}

@available(iOS 15.0, OSX 12, *)
extension OSKUIListTileStyle {
    func makeBodyTypeErased(configuration: Self.OSKUIConfiguration) -> AnyView {
        AnyView(makeBody(configuration: configuration))
    }
}
