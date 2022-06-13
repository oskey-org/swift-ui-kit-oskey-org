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

@available(iOS 15.0, OSX 12, *)
public struct OSKUIListTile: View {
    private var configuration: OSKUIListTileStyleConfiguration

    @Environment(\.oskuiListTileStyle) private var style: OSKUIAnyListTileStyle

    public init<OSKUITitle: View, OSKUISubtitle: View>(
        @ViewBuilder title: @escaping () -> OSKUITitle,
        @ViewBuilder subtitle: @escaping () -> OSKUISubtitle
    ) {
        configuration = OSKUIListTileStyleConfiguration(
            title: AnyView(title()),
            subtitle: AnyView(subtitle()),
            leading: nil,
            trailing: nil
        )
    }

    public init<OSKUITitle: View>(@ViewBuilder title: @escaping () -> OSKUITitle) {
        configuration = OSKUIListTileStyleConfiguration(
            title: AnyView(title()),
            subtitle: nil,
            leading: nil,
            trailing: nil
        )
    }

    init(title: AnyView, subtitle: AnyView? = nil, leading: AnyView? = nil, trailing: AnyView? = nil) {
        configuration = OSKUIListTileStyleConfiguration(title: title, subtitle: subtitle, leading: leading, trailing: trailing)
    }

    public var body: some View {
        style.makeBody(configuration: configuration)
    }
}

@available(iOS 15.0, OSX 12, *)
public extension OSKUIListTile {
    func oskuiLeading<OSKUILeading: View>(@ViewBuilder leading: @escaping () -> OSKUILeading) -> OSKUIListTile {
        OSKUIListTile(title: configuration.title, subtitle: configuration.subtitle, leading: AnyView(leading()), trailing: nil)
    }

    func oskuiLeading<OSKUILeading: View, OSKUITrailing: View>(
        @ViewBuilder leading: @escaping () -> OSKUILeading,
        @ViewBuilder trailing: @escaping () -> OSKUITrailing
    ) -> OSKUIListTile {
        OSKUIListTile(title: configuration.title, subtitle: configuration.subtitle, leading: AnyView(leading()), trailing: AnyView(trailing()))
    }

    func oskuiTrailing<OSKUITrailing: View>(@ViewBuilder trailing: @escaping () -> OSKUITrailing) -> OSKUIListTile {
        OSKUIListTile(title: configuration.title, subtitle: configuration.subtitle, leading: nil, trailing: AnyView(trailing()))
    }
}

// struct OSKUILeadingViewModifier<OSKUILeading: View>: ViewModifier {
//    let leading: OSKUILeading
//
//    init(@ViewBuilder leading: @escaping () -> OSKUILeading) {
//        self.leading = leading()
//    }
//
//    func body(content: Content) -> some View {
//        HStack(spacing: 8) {
//            leading
//
//            content
//        }
//    }
// }
//
// struct OSKUITrailingViewModifier<OSKUITrailing: View>: ViewModifier {
//    let trailing: OSKUITrailing
//
//    init(@ViewBuilder trailing: @escaping () -> OSKUITrailing) {
//        self.trailing = trailing()
//    }
//
//    func body(content: Content) -> some View {
//        HStack(spacing: 8) {
//            content
//
//            trailing
//        }
//    }
// }
//
// extension View {
//    func oskuiLeading<OSKUILeading: View>(@ViewBuilder leading: @escaping () -> OSKUILeading) -> some View {
//        modifier(OSKUILeadingViewModifier(leading: leading))
//    }
//
//    func oskuiTrailing<OSKUITrailing: View>(@ViewBuilder trailing: @escaping () -> OSKUITrailing) -> some View {
//        modifier(OSKUITrailingViewModifier(trailing: trailing))
//    }
// }
//
// struct OSKUIListTile<OSKUITitle: View, OSKUISubtitle: View>: View {
//    let title: OSKUITitle
//    let subtitle: OSKUISubtitle
//    private var hasSubtitle: Bool
//
//    init(@ViewBuilder title: @escaping () -> OSKUITitle, @ViewBuilder subtitle: @escaping () -> OSKUISubtitle) {
//        self.title = title()
//        self.subtitle = subtitle()
//        hasSubtitle = true
//    }
//
//    private init(@ViewBuilder title: @escaping () -> OSKUITitle, @ViewBuilder subtitle: @escaping () -> OSKUISubtitle, hasSubtitle: Bool) {
//        self.title = title()
//        self.subtitle = subtitle()
//        self.hasSubtitle = hasSubtitle
//    }
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 0) {
//                title.font(.headline)
//                subtitle
//                    .font(.subheadline)
//                    .conditionalModifier(hasSubtitle) { content in
//                        content.padding(.top, 8)
//                    }
//            }
//            Spacer()
//        }
//    }
// }
//
// extension OSKUIListTile where OSKUISubtitle == EmptyView {
//    init(@ViewBuilder title: @escaping () -> OSKUITitle) {
//        self.init(
//            title: title,
//            subtitle: {
//                EmptyView()
//            },
//            hasSubtitle: false
//        )
//    }
// }

// struct OSKListTile_Previews: PreviewProvider {
//    static var previews: some View {
//        List {
//            OSKListTile(
//                title: {
//                    Text("Title and no subtitle")
//                }
//            )
//
//            OSKListTile(
//                title: {
//                    Text("Title")
//                },
//                subtitle: {
//                    Text("Subtitle")
//                }
//            )
//
//            OSKListTile(
//                title: {
//                    Text("Title")
//                },
//                subtitle: {
//                    Text("Subtitle in blue")
//                        .foregroundColor(/*@START_MENU_TOKEN@*/ .blue/*@END_MENU_TOKEN@*/)
//                }
//            )
//
//            OSKListTile {
//                Text("This is a very long title")
//            }
//            subtitle: {
//                Text("This is an even longer subtitle, which will have to go on multiple lines, and the font is changed to footnote")
//                    .font(.footnote)
//            }
//            .leading {
//                Image(systemName: "questionmark")
//                    .circleAvatar(size: 48)
//            }
//            .trailing {
//                Image(systemName: "chevron.right")
//            }
//        }
//    }
// }
