# HearthstoneKit

An elegant pure-swift SDK for consuming the official Hearthstone API.

## Installation

HearthstoneKit is available through [Swift Package Manager](https://swift.org/package-manager/), a dependency manager built into Xcode.

If you are using Xcode 11 or higher, go to **File / Swift Packages / Add Package Dependency...** and enter package repository URL **https://github.com/StarLard/HearthstoneKit.git**, then follow the instructions.

To remove the dependency, select the project and open **Swift Packages** (which is next to **Build Settings**). You can add and remove packages from this tab.

> Swift Package Manager can also be used [from the command line](https://swift.org/package-manager/).

## Running the Tests

Most tests run offline. The live API tests need your own Blizzard API credentials, which you can create in the [Blizzard developer portal](https://community.developer.battle.net/access/clients). Copy `Tests/HearthstoneKitTests/Resources/HearthstoneKit-Configuration.example.plist` to `HearthstoneKit-Configuration.plist` in the same folder and fill in your client ID and secret. The file is ignored by git. Without it, the live tests fail.

## Author

[@StarLard](https://twitter.com/CalebFriden)

## License

HearthstoneKit is available under the Apache 2.0 license. See the LICENSE file for more info.
