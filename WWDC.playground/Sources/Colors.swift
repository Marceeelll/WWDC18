import UIKit

struct AppColor {
    private init() {}
    
    private static let alphaAlternative: CGFloat = 0.6
    
    private static let main: UIColor = UIColor(red: 76/255.0, green: 199/255.0, blue: 122/255.0, alpha: 1.0) // green - Main Color
    private static let textBright: UIColor = UIColor.white
    private static let textBrightAlternative: UIColor = textBright.withAlphaComponent(alphaAlternative)
    private static let textDark: UIColor = UIColor(red: 101/255.0, green: 101/255.0, blue: 101/255.0, alpha: 1.0) // dark gray
    private static let textDarkAlternative: UIColor = textDark.withAlphaComponent(alphaAlternative)
    private static let borderBright: UIColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0) // light gray
    private static let borderDark: UIColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    private static let tableHeaderBackground: UIColor = UIColor.darkGray
    private static let tableHeaderText: UIColor = UIColor.white
    private static let favorite: UIColor = UIColor.yellow
    
    struct Theme {
        private init() {}
        static let main = AppColor.main
        static let borderDark = AppColor.borderDark
        static let background = UIColor.white
        static let backgroundAlternative = AppColor.main
        static let textBright: UIColor = AppColor.textBright
        static let textDark: UIColor = AppColor.textDark
        static let activeButton = AppColor.main
        static let inactiveButton = UIColor.lightGray
        static let error = UIColor(red: 222.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 1.0)
    }
    
    struct Button {
        // ✅⚠️ wird noch nicht an jeder Stelle im Code so gemacht, davorher z.B. über Onboarding ging
        private init() {}
        static let filledNormal = AppColor.main
        static let filledSelected = AppColor.enabled(color: AppColor.main)
    }
    
    struct Onboarding {
        private init() {}
        static let background = UIColor.white
        static let backgroundAlternative = AppColor.main
        static let borderBright = AppColor.borderBright
        static let textDark = AppColor.textDark
        static let textBright = AppColor.textBright
        static let tintColor = AppColor.main
        static let tintColorAlternative = UIColor.white
    }
    
    struct Notification {
        private init() {}
        static let weekdaySelected = main
        static let weekdayDeselected = UIColor.lightGray
    }
    
    struct Calendar {
        private init() {}
        static let headerMonth = UIColor.white
        static let headerButton = UIColor.white
        static let weekdayBar = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        static let evenDay = UIColor.white
        static let oddDay = UIColor.white
        static let text = UIColor.black
        static let trainingMarker = UIColor.darkGray
        static let otherMonth = UIColor.lightGray
        static let selectedDay = UIColor.darkGray
        static let selectedDayText = UIColor.white
        static let selectedToday = AppColor.Theme.main
    }
    
    struct Timer {
        private init() {}
        static let pauseTime = UIColor.darkGray
        static let currentTime = UIColor.black
        static let backgroundCircleColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    struct Shadow {
        private init() {}
        static let colorBright = UIColor.lightGray
    }
    
    struct Keyboard {
        private init() {}
        static let text = UIColor.white
        static let background = AppColor.Theme.borderDark
        static let enterButton = AppColor.Theme.main
    }
    
    static func setUpNavigationBars() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = AppColor.Theme.textBright
        UINavigationBar.appearance().barTintColor = AppColor.Theme.main
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:AppColor.textBright]
    }
    
    static func setUpTabBars() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = AppColor.Theme.main
        UITabBar.appearance().tintColor = AppColor.Theme.textBright
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : AppColor.Theme.textBright], for: .normal)
    }
    
    static func enabled(color: UIColor?) -> UIColor? {
        return color?.withAlphaComponent(0.35)
    }
}
