//
//  main.swift
//  Simple game in swift
//
//  Created by Антон Нехаев on 19.06.2023.
//

import Foundation

func clearScreen() {
    print(String(repeating: "\n", count: 30))
}

struct CONSTS {
    static let DEFINED_HEROES_NAMES = ["Anton", "Rozaliya", "Nikita",
                                       "Rishat", "Ravil", "Albert",
                                       "Sanya", "Igor", "Elina",
                                       "Oleg", "Robot", "Kirill",
                                       "Vladimir", "Vladic", "Zuev",
                                       "Reza", "Kudasov", "Moofy",
                                       "Fedia", "Mansur", "Munir",
                                       "Khan", "Muhammadjon"]
    static let ITEMS = [Item(name: "Hammer", buffHp: 0, buffDamage: 15),
                        Item(name: "Cake", buffHp: 20, buffDamage: 0, instantUse: true),
                        Item(name: "Sword", buffHp: 0, buffDamage: 25),
                        Item(name: "Cursed Sword", buffHp: -5, buffDamage: 20),
                        Item(name: "Injection", buffHp: 30, buffDamage: 0, instantUse: true),
                        Item(name: "Pillow", buffHp: 0, buffDamage: 10),
                        Item(name: "Knife", buffHp: 0, buffDamage: 15)]
    static let DAMAGE_RANGE_DEFAULT = 25...40
    static let HEALTH_RANGE_DEFAULT = 35...70
    static let NUMBER_OF_HEROES_IN_TEAM = 4
    static let PLAYER_CHOSE_FROM = 3
}

struct Item: CustomStringConvertible {
    let name: String
    let buffHp: Int
    let buffDamage: Int
    let instantUse: Bool
    
    init(name: String, buffHp: Int, buffDamage: Int, instantUse: Bool = false) {
        self.name = name
        self.buffHp = buffHp
        self.buffDamage = buffDamage
        self.instantUse = instantUse
    }
    
    var description: String {
        let desc: String = (instantUse == true ? "uses instantly" : "can be placed in intentory")
        return "\(name) with buffs (hp: \(buffHp), damage: \(buffDamage)) is \(desc)"
    }
    
    var info: String {
        return "\(name) { hp: \(buffHp), damage: \(buffDamage) }"
    }
}

class Hero: CustomStringConvertible {
    private(set) var name: String
    private var damage: Int
    private(set) var health: Int
    private(set) var items: [Item] = .init()
    
    func smallBuff() {
        health += 5
        damage += 5
    }
    
    var calculatedDamage: Int {
        var result = damage
        for item in items {
            result += item.buffDamage
        }
        return result
    }
    
    init(name: String, damage: Int, health: Int) {
        self.name = name
        self.damage = damage
        self.health = health
    }
    
    func addDamage(_ number: Int) {
        damage += number
    }
    
    func addHealth(_ number: Int) {
        health += number
    }
    
    func addItem(_ item: Item) {
        if item.instantUse {
            damage += item.buffDamage
        } else {
            items.append(item)
        }
        health += item.buffHp
    }
    
    convenience init() {
        self.init(name: CONSTS.DEFINED_HEROES_NAMES.randomElement()!,
                  damage: Int.random(in: CONSTS.DAMAGE_RANGE_DEFAULT),
                  health: Int.random(in: CONSTS.HEALTH_RANGE_DEFAULT))
    }
    
    var isAlive: Bool {
        health > 0
    }
    
    func takeDamage(damage: Int) {
        health = max(0, health - damage)
    }
    
    var description: String {
        "\(name) (damage: \(calculatedDamage), health: \(health))"
    }
}

class Team: CustomStringConvertible {
    private var heroes: [Hero] = .init()
    private(set) var name: String
    
    var count: Int {
        heroes.count
    }
    
    init(heroes: [Hero]? = nil, name: String) {
        if let heroes = heroes {
            self.heroes = heroes
        } else {
            for _ in 0..<CONSTS.NUMBER_OF_HEROES_IN_TEAM {
                self.heroes.append(Hero())
            }
        }
        self.name = name
    }
    
    func giveItem(heroIndex: Int, item: Item) {
        guard 0 <= heroIndex && heroIndex < count else { return }
        heroes[heroIndex].addItem(item)
        
    }
    
    func getRandomHero() -> Hero {
        heroes.randomElement()!
    }
    
    func removeHero(hero: Hero) {
        for (i, el) in heroes.enumerated() {
            if el === hero {
                heroes.remove(at: i)
                return
            }
        }
    }
    
    var isAlive: Bool {
        !heroes.isEmpty
    }
    
    func refresh() {
        var tmpHeroes: [Hero] = .init()
        for hero in heroes {
            if hero.isAlive {
                tmpHeroes.append(hero)
            }
        }
        heroes = tmpHeroes
    }
    
    var description: String {
        var result = "\(name)"
        for (i, hero) in heroes.enumerated() {
            result += "\n\(i + 1): \(hero)"
        }
        return result
    }
    
    var descriptionWithItems: String {
        var result = "\(name)"
        for (i, hero) in heroes.enumerated() {
            result += "\n\(i + 1): \(hero) Items: [\(hero.items.map{ $0.info }.joined(separator: ", "))]"
        }
        return result
    }
    
    var shortDescription: String {
        let descsHeroes = heroes.map {
            $0.description
        }
        return "\(name) { \(descsHeroes.joined(separator: ", ")) }"
    }
    
    var accumulatedDescription: String {
        var accumDam = 0
        var accumHealth = 0
        for hero in heroes {
            accumDam += hero.calculatedDamage
            accumHealth += hero.health
        }
        return "\(name): total damage: \(accumDam) | total health: \(accumHealth)"
    }
}

struct BattleResult {
    var winTeam: Team, lostTeam: Team, items: [Item]
}

class Battle {
    var team1: Team
    var team2: Team
    var verbous: Bool
    
    init(team1: Team, team2: Team, verbous: Bool = false) {
        self.team1 = team1
        self.team2 = team2
        self.verbous = verbous
    }
    
    func run() -> BattleResult {
        var roundNum = 1
        var droppedItems = [Item]()
        if verbous {
            print("New battle\n\(team1)\nvs\n\(team2)\n")
        }
        while team1.isAlive && team2.isAlive {
            if verbous {
                print("Round: \(roundNum)")
            }
            let t1 = roundNum % 2 == 1 ? team1: team2
            let t2 = roundNum % 2 == 1 ? team2: team1
            droppedItems.append(contentsOf: performRound(team1: t1, team2: t2))
            roundNum += 1
            if verbous {
                print("")
            }
        }
        
        if verbous, team1.isAlive {
            print("\(team1.name) wins the battle!")
        } else if verbous, team2.isAlive {
            print("\(team2.name) wins the battle!")
        }
        
        let winnerTeam: Team
        let looserTeam: Team
        if team1.isAlive {
            winnerTeam = team1
            looserTeam = team2
        } else {
            winnerTeam = team2
            looserTeam = team1
        }
        
        return BattleResult(winTeam: winnerTeam, lostTeam: looserTeam, items: droppedItems)
    }
    
    func performRound(team1: Team, team2: Team) -> [Item] {
        var items: [Item] = .init()
        let hero1 = team1.getRandomHero()
        let hero2 = team2.getRandomHero()
        if verbous {
            print("Turn of \(team1.name)\n\(hero1) attacks \(hero2)")
        }
        hero2.takeDamage(damage: hero1.calculatedDamage)
        if !hero2.isAlive {
            team2.removeHero(hero: hero2)
            if verbous {
                print("\(hero2.name) from \(team2.name) is defeated by \(hero1.name) from \(team1.name).")
            }
            items.append(contentsOf: hero2.items)
            return items
        }
        if verbous {
            print("Turn of \(team2.name)\n\(hero2) attacks \(hero1)")
        }
        hero1.takeDamage(damage: hero2.calculatedDamage)
        if !hero1.isAlive {
            team1.removeHero(hero: hero1)
            if verbous {
                print("\(hero1.name) from \(team1.name) is defeated by \(hero2.name) from \(team2.name).")
            }
            items.append(contentsOf: hero1.items)
            return items
        }
        return items
    }
}


class Game {
    private var playerTeam: Team!
    private var numberPlayers: Int!
    private var teams = [Team]()
    
    private func getValidInputInt(range: ClosedRange<Int>) -> Int {
        print("Enter the number in range [\(range.lowerBound), \(range.upperBound)]: ")
        while true {
            guard let stringValue = readLine() else {
                print("Please write number")
                continue
            }
            guard let intValue = Int(stringValue) else {
                print("Please write number")
                continue
            }
            if !range.contains(intValue) {
                print("The number not in range")
                continue
            }
            return intValue
        }
    }
    
    private func createPlayerTeam() -> Team {
        var team: [Hero] = .init()
        
        for heroNum in 0..<CONSTS.NUMBER_OF_HEROES_IN_TEAM {
            print("Choose for \(heroNum + 1) hero that will be in your team")
            var rollHeroes: [Hero] = .init()
            for heroNumForChoose in 0..<CONSTS.PLAYER_CHOSE_FROM {
                let hero = Hero()
                hero.smallBuff()
                rollHeroes.append(hero)
                print("\(heroNumForChoose + 1): \(rollHeroes[heroNumForChoose])")
            }
            print("Enter number of hero that you wanna pick: ")
            let userInput = getValidInputInt(range: 1...CONSTS.PLAYER_CHOSE_FROM)
            team.append(rollHeroes[userInput - 1])
            clearScreen()
        }
        print("\nWow! What a great new team!")
        let pickedTeam = Team(heroes: team, name: "Player's team")
        print(pickedTeam)
        return pickedTeam
    }
    
    private func createRestOfTeams(n: Int) {
        for teamNum in 0..<n {
            teams.append(Team(name: "Team \(teamNum + 1)"))
        }
    }
    
    private func helpCommand() {
        print("""
                Some commands that can be performed:
                help - print this message
                team {Team name} (for ex. Team 1) - info about team
                list teams - print accumulater info about all teams
                start fights - starts new round of fights, after it will be round of resource gathering
                """)
    }
    
    private func teamCommand(teamName: String) {
        /// Yea, this is O(n), we can implement this logic using dictionary, but I think this implementation is suitable for this task
        if teamName == "Player's team" {
            print(playerTeam!.descriptionWithItems)
            return
        }
        for team in teams {
            if team.name == teamName {
                print(team.descriptionWithItems)
                return
            }
        }
        print("No team with name \(teamName) was found")
    }
    
    private func listTeamsCommand() {
        print("List of teams")
        print("Your team: \(playerTeam.accumulatedDescription)")
        for team in game.teams {
            print(team.accumulatedDescription)
        }
    }
    
    private func exitCommand() {
        print("Game finished")
        exit(0)
    }
    
    func start() {
        print("""
              Greet you, challenger!
              Let me tell you how the game’s going to play out. First you will need to enter the number n, which will then affect the number of commands you will fight, the total of commands will be 2^n. Next, you’re gonna have to pick the heroes that will be on your team from the offer.
              And then you can start the round of battles! Battles consist of two teams, and it happens automatically! On each round of battle, each team selects a random character and they deal damage to each other equal to their attack + attack bonuses from the items! The team that survives at least one hero wins!
              After the battle phase, the collection stage begins! Now you can choose to distribute the items that were knocked out of the opponent’s team, and that you just happened to find, between your team! There are also some commands you can use during your progress. You can find them by writing `help` (here you can find command that starts fight round and etc.)! Let’s get started!
              """)
        print("Enter n: ")
        let n = getValidInputInt(range: 1...8)
        
        numberPlayers = Int(pow(Double(2), Double(n)))
        createRestOfTeams(n: numberPlayers - 1)
        clearScreen()
        playerTeam = createPlayerTeam()
        
        mainLoop()
    }
    
    private func startFightsCommand() -> [BattleResult] {
        clearScreen()
        let playerFight = Battle(team1: playerTeam, team2: teams.first!, verbous: true)
        let playerBattleResult = playerFight.run()
        if playerBattleResult.lostTeam === playerTeam {
            print("Oh, no, you lost! Thanks for trying my game!")
            exitCommand()
        }
        print("\nYour team after battle:\n\(playerBattleResult.winTeam)")
        var battlesResults: [BattleResult] = .init()
        battlesResults.append(playerBattleResult)
        for i in stride(from: 1, to: teams.count - 1, by: 2) {
            let botsFight = Battle(team1: teams[i], team2: teams[i + 1])
            battlesResults.append(botsFight.run())
        }
        return battlesResults
    }
    
    private func getRamdomResource() -> Item? {
        if Int.random(in: 0...10) > 7 {
            return nil
        }
        return CONSTS.ITEMS.randomElement()!
    }
    
    private func gatherPlayerTeam(playerTeam: Team, resources: [Item]) {
        var res = resources
        if !res.isEmpty {
            print("After fight you obtained some resources from the opponent team:")
            for (i, el) in resources.enumerated() {
                print(i + 1, el)
            }
            print()
        }
        if let randomRes = getRamdomResource() {
            print("You are lucky today! You have found new item!\n\(randomRes)")
            res.append(randomRes)
            print()
        }
        
        if res.isEmpty {
            print("You don't have any items to deliver to your team.")
            return
        }
        
        print("Now! You need to deliver this items to your team!")
        for item in res {
            print(playerTeam)
            print(item)
            let heroIndex = getValidInputInt(range: 1...playerTeam.count)
            playerTeam.giveItem(heroIndex: heroIndex - 1, item: item)
        }
        
        print("Your team after gathering:")
        print(playerTeam)
    }
    
    private func gatherBot(winTeam: Team, resources: [Item]) {
        var items = resources
        if let randomRes = getRamdomResource() {
            items.append(randomRes)
        }
        for item in items {
            winTeam.giveItem(heroIndex: Int.random(in: 0..<winTeam.count), item: item)
        }
    }
    
    private func startGathering(battleRes: [BattleResult]) {
        let playersResult = battleRes.first!
        gatherPlayerTeam(playerTeam: playersResult.winTeam, resources: playersResult.items)
        for i in stride(from: 1, to: battleRes.count, by: 1) {
            gatherBot(winTeam: battleRes[i].winTeam, resources: battleRes[i].items)
        }
    }
    
    private func teamsRefresh() {
        var tmpTeams: [Team] = .init()
        for team in teams {
            team.refresh()
            if team.isAlive {
                tmpTeams.append(team)
            }
        }
        teams = tmpTeams
    }
    
    private func mainLoop() {
        while true {
            print("Enter command (type `help` for list of commands): ")
            let command = readLine()
            if command == "exit" {
                exitCommand()
            } else if command == "start fights" {
                let results = startFightsCommand()
                print("Press enter to start gathering or exit - to exit the game!")
                let proceed = readLine()
                if proceed == "exit" {
                    exitCommand()
                }
                startGathering(battleRes: results)
                teamsRefresh()
                listTeamsCommand()
                if teams.isEmpty {
                    clearScreen()
                    print("YOU WON!!")
                    print("You final team:")
                    print(playerTeam.descriptionWithItems)
                    exitCommand()
                }
                
            } else if command == "help" {
                clearScreen()
                helpCommand()
            } else if command == "list teams" {
                clearScreen()
                listTeamsCommand()
            } else if let command = command, command.starts(with: "team") {
                clearScreen()
                let teamName = String(command[command.index(command.startIndex, offsetBy: 5)...])
                teamCommand(teamName: teamName)
            } else {
                print("Unknown command, type `help` for list of commands")
            }
        }
    }
}


var game = Game()
game.start()
