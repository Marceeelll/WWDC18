/*:
 # Demo:
 [Back to Features](@previous)
 */

import UIKit
import PlaygroundSupport

//: - Experiment:
//: Each country prefers a different day to start their week with. America usually starts with Sunday despite Germany starts their week on Monday. You have the ability to customize the calendar by selecting your prefered weekday.
let weekday = UICalendarWeekday.sunday


//: - Experiment:
//: You can easily add your own birthday to the calendar.
//: If you entered valid data your birthday will appear on the calendar.
let name = "iPhone"
let day = 09
let month = 01
let year = 2007


//: - Note:
//: Only one particle animation at a time can appear.
//: Please don't change the following lines.

let birthdayCtrl = BirthdayController()
var userBirthdayEvents: [Event] = []
if let person = birthdayCtrl.createPerson(name: name, birthdayDay: day, birthdayMonth: month, birthdayYear: year) {
    userBirthdayEvents = birthdayCtrl.addPersonToCalendar(person: person)
}


let vCtrl = WelcomeViewController()
vCtrl.userBirthdayEvents = userBirthdayEvents
vCtrl.selectedWeekdayStart = weekday
let navCtrl = UINavigationController(rootViewController: vCtrl)

PlaygroundPage.current.liveView = navCtrl
