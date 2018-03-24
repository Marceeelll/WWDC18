/*:
 # Demo:
 [ ◀️ Back to Info](@previous)
 */

import UIKit
import PlaygroundSupport

//: Each country prefers a different day to start their week with. America usually starts with sunday despite Germany starts their week on monday. You have the ability to customize the calendar by selecting your preffered weekday.
let weekday = UICalendarWeekday.monday


//: Erstellen wir einen Geburtstags Eintrag für dich :)
//: You can easily add your own birthday to the calendar.
//: If you entered valid data your birthday will appear on the calendar.
let name = "iPhone"
let day = 09
let month = 01
let year = 2007


//: Now we are able to run the project.

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
