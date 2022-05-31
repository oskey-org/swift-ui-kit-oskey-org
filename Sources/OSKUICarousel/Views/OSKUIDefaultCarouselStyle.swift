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

/// Defines the default carousel style
///
public class OSKUIDefaultCarouselStyle: OSKUICarouselStyle {
    public init() {}

    public func makeBody(configuration: OSKUIConfiguration) -> some View {
        VStack(spacing: 16) {
            configuration.content

            if configuration.dots.count > 1 {
                HStack(spacing: 4) {
                    ForEach(configuration.dots) { dot in
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: dot.isActiveItem ? 8 : 4, height: dot.isActiveItem ? 8 : 4, alignment: .center)
                            .scaledToFit()
                            .foregroundColor(dot.isActiveItem ? .accentColor : .white)
                    }
                }
                .padding(8)
                .frame(maxWidth: configuration.itemMaxWidth)
                .background(Color.black.opacity(0.13))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .scaledToFit()
            }
        }
    }
}
