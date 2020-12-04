import Cocoa

let filename = "\(NSHomeDirectory())/Documents/advent_of_code_2020/idrougge-swift/day04.txt"
let lines = try! String.init(contentsOfFile: filename).components(separatedBy: "\n\n")
let c = lines.map { $0.components(separatedBy: CharacterSet(charactersIn: " \n")) }
                                
c
print(c)
let d = c.map { $0.map { $0.components(separatedBy: ":") }.map { ($0[0], $0[1]) } }
d
let e = d.map(Dictionary.init)
e
print(e)
struct PassportCandidate {
    let byr: String? // Birth Year
    let iyr: String? // Issue Year
    let eyr: String? // Expiration Year
    let hgt: String? // Height
    let hcl: String? // Hair Color
    let ecl: String? // Eye Color
    let pid: String? // Passport ID
    let cid: String? // Country ID
    init(dictionary: [String: String]) {
        byr = dictionary["byr"]
        iyr = dictionary["iyr"]
        eyr = dictionary["eyr"]
        hgt = dictionary["hgt"]
        hcl = dictionary["hcl"]
        ecl = dictionary["ecl"]
        pid = dictionary["pid"]
        cid = dictionary["cid"]
    }
}
let f = e.map(PassportCandidate.init)
print(f)

struct Year {
    let value: Int
    init?(_ value: String, valid range: ClosedRange<Int>) {
        guard value.count == 4,
              let value = Int(value)
        else { return nil }
        self.value = value
    }
}

struct Height {
    enum Unit: String { case cm, inch = "in" }
    init?(_ value: String) {
        guard let length = Scanner(string: value).scanInt(),
              let unit = Unit(rawValue: String(value.suffix(2)))
        else { return nil }
        switch (length, unit) {
        case (150...193, .cm): return
        case (59...76, .inch): return
        case _: return nil
        }
    }
}

struct HairColour {
    init?(value: String) {
        let s = Set(value.dropFirst())
        guard value.first == "#",
              s.isSubset(of: "0123456789abcdef")
        else { return nil }
    }
}
struct Passport {
    var byr: Year? // Birth Year
    let iyr: Year? // Issue Year
    let eyr: Year? // Expiration Year
    let hgt: Height? // Height
    let hcl: HairColour? // Hair Color
    let ecl: String? // Eye Color
    let pid: String? // Passport ID
    let cid: String? // Country ID
    init?(dictionary: [String: String]) {
        guard let byr = dictionary["byr"],
              let iyr = dictionary["iyr"],
              let eyr = dictionary["eyr"]
        else { return nil }
        self.byr = Year(byr, valid: 1920...2002)
        self.iyr = Year(iyr, valid: 2010...2020)
        self.eyr = Year(eyr, valid: 2020...2030)
        guard let hgt = dictionary["hgt"].map(Height.init)
        else { return nil }
        self.hgt = hgt
        hcl = dictionary["hcl"].flatMap(HairColour.init)
        ecl = dictionary["ecl"]
        pid = dictionary["pid"]
        cid = dictionary["cid"]
    }
}
