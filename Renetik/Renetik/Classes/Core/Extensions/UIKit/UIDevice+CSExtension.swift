public enum DisplayType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    case iPadNonRetina
    case iPad
    case iPadProBig
    static let iphone7 = iphone6
    static let iphone7plus = iphone6plus
}

public extension UIDevice {
    class func set(orientation: UIDeviceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        UIDevice.current.setValue(UIDeviceOrientation.unknown.rawValue, forKey: "orientation")
    }

    class var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    class var isTablet: Bool { UIDevice.current.userInterfaceIdiom == .pad }
    class var isCarPlay: Bool { UIDevice.current.userInterfaceIdiom == .carPlay }
    class var isTV: Bool { UIDevice.current.userInterfaceIdiom == .tv }

    @nonobjc class var typeIsLike: DisplayType {
        if isPhone && UIScreen.maxLength < 568 {
            return .iphone4
        } else if isPhone && UIScreen.maxLength == 568 {
            return .iphone5
        } else if isPhone && UIScreen.maxLength == 667 {
            return .iphone6
        } else if isPhone && UIScreen.maxLength == 736 {
            return .iphone6plus
        } else if isTablet && !UIScreen.isRetina {
            return .iPadNonRetina
        } else if isTablet && UIScreen.isRetina && UIScreen.maxLength == 1024 {
            return .iPad
        } else if isTablet && UIScreen.maxLength == 1366 {
            return .iPadProBig
        }
        return .unknown
    }

    class var systemVersionInt: Int { Int(UIDevice.current.systemVersion)! }
    class var isIOS10: Bool { systemVersionInt >= 10 }
    class var isIOS11: Bool { systemVersionInt >= 11 }
}
