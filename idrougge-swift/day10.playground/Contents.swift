import Foundation

let filename = "\(NSHomeDirectory())/Documents/advent_of_code_2020/idrougge-swift/day10.txt"
var adapters = try! String.init(contentsOfFile: filename).components(separatedBy: "\n")
    .compactMap(Int.init)
    .sorted()
//    .map { $0 - 3 ... $0 }

print(adapters)
let top = adapters.last! + 3

let differences = zip([0] + adapters, adapters + [adapters.last! + 3]).map { $1 - $0 }
print(differences)
let answer1 = [1, 3].map { number in
    differences.reduce(0) { $1 == number ? $0 + 1 : $0 }
}.reduce(1, *)
answer1

adapters = [0] + adapters //+ [top]
let ranges = adapters.map { $0 - 3 ... $0 - 1}
//let ranges = adapters.map { $0 + 1 ... $0 + 3 }
print(ranges)
let it = ranges.makeIterator()
ranges.forEach { range in
    
}
var noted: [Int: Int] = [:]
let possible = ranges.flatMap({Array($0)})
print(possible.sorted())
let actual = possible.filter { adapters.contains($0) }
print(actual.sorted())
let dict = Dictionary.init(zip(actual, sequence(first: 1, next: {$0}))) { (old, new) in
    old + 1
}
dict
print(dict.sorted(by: { (l, r) -> Bool in
    l.key < r.key
}).map { (k, v) in "\(k): \(v)"}.joined(separator: ", "))
let summed = dict.reduce(into: 0) { (result, kv) in result += kv.value }
summed
summed - dict.count
let product = dict.reduce(into: 1) { (result, kv) in result *= kv.value }
product
product - dict.count
dict.filter { (k, v) -> Bool in
    v > 1
}
print("--------")
func find(_ nr: Int, in adapters: ArraySlice<Int>) -> Int {
    print(nr, adapters)
    if adapters.isEmpty { return 1 }
    guard adapters.first == nr else { return 0 }
//    guard let first = adapters.first,
//          nr+1...nr+3 ~= first else { return 0 }
    var found = 0
    let dropped = adapters.drop { nr...nr+2 ~= $0 }
    let diff = adapters.count - dropped.count
    print("dropped:", dropped)
    if diff > 0 { found += diff; print("Diffen är:", diff)}
    guard let first = dropped.first else { return 1 }
    found += find(dropped.first!, in: dropped)
//    found += find(first, in: dropped)
//    for i in 1 ... 3 {
//        print(i)
//        found += find(nr + i, in: adapters.dropFirst())
//    }
    return found
}
find(0, in: adapters[0...])
