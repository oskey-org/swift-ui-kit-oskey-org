[![License](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)

# OSKUICarousel - A Carousel for SwifUI, by OSkey

Copyright (c) 2022 OSkey SAS. MIT License.

`OSKUICarousel` is a stylable carousel to use within you SwiftUI powered apps.

## Supported platforms and minimal versions

| Platform |  Minimal version |  Comments                |
| :------: | :--------------: | ------------------------ |
|  macOS   |        12        | Only tested on macOS v12 |
|   iOS    |        15        | Only test on iOS v15     |

## Adding to your project

### Swift Package Manager

Open Xcode, go to File -> Swift Packages -> Add Package Dependency and enter
`https://github.com/oskey-org/swift-ui-carousel-oskey-org.git`.

You can also add ACarousel as a dependency to your Package.swift:

dependencies: [
.package(url: "https://github.com/oskey-org/swift-ui-carousel-oskey-org.git", from: "1.0.0")
]

## Use in your project

Below is an example of sliding cards, with a person photo and it's name below.

```swift
import SwiftUI
import OSKUICarousel

struct ColorItem: Identifiable {
    let name: String
    let color: Color

    var id: String { return name }
}

struct ContentView: View {
    let colors = [
        ColorItem(name: "Red", color: .red),
        ColorItem(name: "Green", color: .green),
        ColorItem(name: "Blue", color: .blue),
    ]

    @State private var currentIndex = 0

    var body: some View {
      OSKUICarousel(
          colors,
          index: $currentIndex,
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
                  .aspectRatio(16/9, contentMode: .fit)
              Text("**Color:** \(color.name)")
                  .padding()
          }
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .shadow(color: .gray, radius: 2, x: 1, y: 1)
      }
      .padding(.vertical)
    }
}
```

## Styling your carousel

Styling the carousel is done by implementing the `OSKUICarouselStyle` protocol:

```swift
class OSKUIMyCarouselStyle: OSKUICarouselStyle {
    func makeBody(configuration: OSKUIConfiguration) -> some View {
        VStack(spacing: 16) {
            configuration.content

            HStack(spacing: 4) {
                ForEach(configuration.dots) { dot in
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: dot.isActiveItem ? 8 : 4, height: dot.isActiveItem ? 8 : 4, alignment: .center)
                        .scaledToFit()
                        .foregroundColor(dot.isActiveItem ? .red : .white)
                }
            }
            .padding(8)
            .frame(maxWidth: configuration.itemMaxWidth)
            .background(Color.red.opacity(0.13))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaledToFit()
        }
        .padding(.vertical)
        .background(Color.blue.opacity(0.13))
    }
}
```

Then, in the above example, add the modifier
`.oskuiCarouselStyle(OSKUIMyCarouselStyle())`:

```swift

[...]

struct ContentView: View {
    let colors = [
        ColorItem(name: "Red", color: .red),
        ColorItem(name: "Green", color: .green),
        ColorItem(name: "Blue", color: .blue),
    ]

    @State private var currentIndex = 0

    var body: some View {
      OSKUICarousel(
          colors,
          index: $currentIndex,
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
                  .aspectRatio(16/9, contentMode: .fit)
              Text("**Color:** \(color.name)")
                  .padding()
          }
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .shadow(color: .gray, radius: 2, x: 1, y: 1)
      }
      .oskuiCarouselStyle(OSKUIMyCarouselStyle())
      .padding(.vertical)
    }
}
```

## Dependencies

This package has no dependencies.

## Example

An example can be found [here](./Example/OSKUICarouselApp/).

## Thanks

This example is inspired by:

- [A carousel view for SwiftUI](https://iosexample.com/a-carousel-view-for-swiftui/):
  A carousel
- [SwiftUI Custom Styling](https://swiftui-lab.com/custom-styling/): An example
  of custom view with styling (like for Button), with an [example](https://gist.github.com/swiftui-lab/4469338fd099285aed2d1fd00f5da745)

## Contributions

Please find [here](./CONTRIBUTING.md) the instructions for contributions.

## Licenses

Please find [here](./LICENSE) the detail on licensing.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
