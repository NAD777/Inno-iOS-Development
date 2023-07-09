/*

 Список персонажей из Рика и Морти, реализовать с помощью таблицы.

 По нажатию должна открываться модально деталка с персонажем, в которой можно менять данные. Изменить можно определенные поля (выбираете сами)
 После изменения данных экран должен закрываться и показывать обновленные данные на списке.
 Картинки для персонажей можете добавть в Assets и получать их по названию.
 Визуальное представление интефейса на ваше усмотрение.
 
 -------------
 
 A list of characters from Rick and Morty, implemented using a table.

 When pressed, a modal detail with a character should open, in which you can change the data. You can change certain fields (choose yourself)
 After changing the data, the screen should close and show the updated data.
 You can add pictures for characters to Assets and get them by name.
 The visual representation of the interface is at your discretion.
 
*/

struct Character {
    enum Status: String {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "Unknown"
    }
    
    enum Gender: String {
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown = "Unknown"
    }
    
    let id: Int
    var name: String
    let status: Status
    var species: String
    let gender: Gender
    let location: String
    let image: String
    
    func getStatusString() -> String {
        status.rawValue
    }
    
    func getGenderString() -> String {
        gender.rawValue
    }
    
    mutating func setValues(other: Self) {
        self = other
    }
}
