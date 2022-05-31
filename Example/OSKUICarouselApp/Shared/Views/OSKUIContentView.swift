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

import OSKUICarousel
import SwiftUI

struct OSKUIContentView: View {
    let colors = [
        OSKUIColor(name: "Red", color: .red),
        OSKUIColor(name: "Green", color: .green),
        OSKUIColor(name: "Blue", color: .blue),
    ]

    @State private var currentIndex1 = 0
    @State private var currentIndex2 = 0

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Default style")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()

                        OSKUICarousel(
                            colors,
                            index: $currentIndex1,
                            spacing: 16,
                            headspace: 16,
                            sidesScaling: 0.8,
                            isWrap: false,
                            autoScroll: .active(5),
                            allowSwipe: true,
                            proxy: proxy
                        ) { color in
                            VStack {
                                color.color
                                    .aspectRatio(16 / 9, contentMode: .fit)
                                Text("**Color:** \(color.name)")
                                    .padding()
                            }
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        }
                        .padding(.vertical)

                        Divider()

                        HStack {
                            Text("Custom style")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()

                        OSKUICarousel(
                            colors,
                            index: $currentIndex2,
                            spacing: 16,
                            headspace: 16,
                            sidesScaling: 0.8,
                            isWrap: false,
                            autoScroll: .active(1),
                            allowSwipe: true,
                            proxy: proxy
                        ) { color in
                            VStack {
                                color.color
                                    .aspectRatio(16 / 9, contentMode: .fit)
                                Text("**Color:** \(color.name)")
                                    .padding()
                            }
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        }
                        .oskuiCarouselStyle(OSKUIMyCarouselStyle())
                    }
                }
            }
            .navigationTitle("Peoples")
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(.red)
        }
        .navigationViewStyle(.stack)
    }
}

struct OSKUIContentView_Previews: PreviewProvider {
    static var previews: some View {
        OSKUIContentView()
            .preferredColorScheme(.light)
    }
}
