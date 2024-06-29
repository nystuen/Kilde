import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let cell = Color("CellColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let darkRed = Color("DarkRedColor")
    let blue = Color("BlueColor")
    let darkBlue = Color("DarkBlueColor")
    let text = Color("TextColor")
    let secondaryText = Color("SecondaryTextColor")
    let secondary = Color("SecondaryColor")
}

struct ColorTheme2 {
    let testColor = Color(#colorLiteral(red: 0.106979318, green: 0.1136908755, blue: 0.1429278851, alpha: 1))
    let accent = Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))
    let background = Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
    let green = Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
    let red = Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
    let secondaryText = Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))
}

