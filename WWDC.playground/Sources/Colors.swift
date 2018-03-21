import UIKit

public struct AppColor {
    private init() {}
    
    private static let alphaAlternative: CGFloat = 0.6
    
    private static let main: UIColor = UIColor(red: 76/255.0, green: 199/255.0, blue: 122/255.0, alpha: 1.0) // green - Main Color
    
    public struct Theme {
        private init() {}
        public static let main = AppColor.main
    }
    
    public struct Calendar {
        private init() {}
        public static let headerMonth = UIColor.white
        public static let headerButton = UIColor.white
        public static let weekdayBar = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        public static let evenDay = UIColor.white
        public static let oddDay = UIColor.white
        public static let text = UIColor.black
        public static let trainingMarker = UIColor.darkGray
        public static let otherMonth = UIColor.lightGray
        public static let selectedDay = UIColor.darkGray
        public static let selectedDayText = UIColor.white
        public static let selectedToday = AppColor.Theme.main
    }
    
    public struct Apple {
        private init() {}
        public static let green = UIColor(red: 100.0/255.0, green: 185.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        public static let yellow = UIColor(red: 251.0/255.0, green: 183.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        public static let orange = UIColor(red: 243.0/255.0, green: 130.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        public static let red = UIColor(red: 222.0/255.0, green: 60.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        public static let purple = UIColor(red: 149.0/255.0, green: 65.0/255.0, blue: 149.0/255.0, alpha: 1.0)
        public static let blue = UIColor(red: 25.0/255.0, green: 158.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        public static let allColors: [UIColor] = [Apple.green,
                                                  Apple.yellow,
                                                  Apple.orange,
                                                  Apple.red,
                                                  Apple.purple,
                                                  Apple.blue]
    }
}
