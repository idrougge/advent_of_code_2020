import Foundation

enum Seat: String {
    case vacant = "L"
    case occupied = "#"
    case floor = "."
}
extension Seat: CustomStringConvertible {
    var description: String { rawValue }
}

extension Array {
    func adjacentIndices(to index: Index) -> ClosedRange<Index> {
        (index - 1 ... index + 1).clamped(to: ClosedRange(indices))
    }
}

typealias Point = (x: Int, y: Int)

extension Array where Element == [Seat] {
    subscript(x: Index, y: Index) -> Seat {
        get { self[y][x] }
        set { self[y][x] = newValue }
    }
    
    subscript(point: Point) -> Seat {
        get { self[point.x, point.y] }
        set {self[point.x, point.y] = newValue}
    }
    
    func adjacentIndices(to point: Point) -> [Point] {
        self.adjacentIndices(to: point.y)
            .map { (point.x, $0) }
            .map { (x, y) in (self[y].adjacentIndices(to: x), y) }
            .flatMap { (x, y) in x.map { ($0, y) } }
    }
    
    func numberAdjacent(to point: Point) -> Int {
        self.adjacentIndices(to: point)
            .filter { $0 != point }
            .map { self[$0] }
            .reduce(0) { nr, seat in seat == .occupied ? nr + 1 : nr }
    }
}

let filename = "\(NSHomeDirectory())/Documents/advent_of_code_2020/idrougge-swift/day11.txt"
var input = try! String.init(contentsOfFile: filename).components(separatedBy: "\n")
    .map(Array.init).map { $0.map(String.init).compactMap(Seat.init) }

print(input)

var lounge = input
(-3...11).clamped(to: ClosedRange(input.indices))
input.adjacentIndices(to: 1)

let spotss = input.adjacentIndices(to: (1, 1))
print(spotss)
print(spotss.map { input[$0] })

let seq = sequence(first: (input.startIndex, input[0].startIndex)) { (point: Point) in
    guard input.indices ~= point.y else { return nil }
    switch point {
    case (input[point.y].endIndex - 1, input.indices.endIndex - 1):
        return nil
    case (input[point.y].endIndex - 1, input.indices):
        return (input[point.y].startIndex, point.y + 1)
    case (input[point.y].indices, input.indices): return (point.x + 1, point.y)
    case _: preconditionFailure()
    }
    return nil
}
seq.forEach { (p) in print(p)}
seq.forEach { (p) in print("-",p)}

func sit(in lounge: [[Seat]]) -> [[Seat]] {
    var new = lounge
    seq.forEach { point in
        switch lounge[point] {
        case .floor: return
        case .occupied where lounge.numberAdjacent(to: point) >= 4: new[point] = .vacant
        case .occupied: return
        case .vacant where lounge.numberAdjacent(to: point) == 0: new[point] = .occupied
        case .vacant: return
        }
    }
    return new
}
func pp(_ seats: [[Seat]]) {
    print(seats.hashValue)
    for row in seats { print(row.map(\.rawValue).joined()) }
    print(seats.flatMap {$0}.reduce(0, { nr, seat in seat == .occupied ? nr + 1 : nr }))
}
/*
var new = sit(in: lounge)

pp(new)
new = sit(in: new)
pp(new)
new = sit(in: new)
pp(new)
new = sit(in: new)
pp(new)
new = sit(in: new)
pp(new)
new = sit(in: new)
pp(new)
new = sit(in: new)
pp(new)
*/

let result = sequence(first: lounge) { old in
    let new = sit(in: old)
    if new == old {
        return nil
    } else {
        return new
    }
}.reduce(lounge) { old, new in
    new
}.flatMap { $0 }.reduce(0) { nr, seat in seat == .occupied ? nr + 1 : nr }
print(result)
