import Foundation

let input = challengeInput(for: 7)
var inputLines = input.components(separatedBy: "\n")

//struct File: Hashable {
//    let id = UUID()
//    let name: String
//    let dir: Dir
//    let size: Int
//    init(_ name: String, in dir: Dir, size: Int) {
//        self.name = name
//        self.dir = dir
//        self.size = size
//    }
//
//    static func ==(lhs: File, rhs: File) -> Bool {
//        return lhs.name == rhs.name
//        && lhs.size == rhs.size
//        // && lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//        hasher.combine(id)
//    }
//
//}
//
//struct Dir: Hashable {
//    let id = UUID()
//    let name: String
//    var files = [File]()
//    var dirs = [Dir]()
//
//    var filesSize: Int { files.reduce(0) { $0 + $1.size } }
//    var totalSize: Int { filesSize + dirs.reduce(0) { $0 + $1.totalSize } }
//
//    var fileSet: Set<File> { Set(files) }
//    var dirSet: Set<Dir> { Set(dirs) }
//
//    init(_ name: String) {
//        self.name = name
//    }
//
//    mutating func add(_ newFile: File) {
//        self.files.append(newFile)
//        assert(files.count == fileSet.count)
//    }
//
//    mutating func add(_ newDir: Dir) {
//        self.dirs.append(newDir)
//        assert(dirs.count == dirSet.count)
//    }
//
//    public static func ==(lhs: Self, rhs: Self) -> Bool {
//        return lhs.name == rhs.name && lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//        hasher.combine(id)
//    }
//
//}
//
//
//let input = challengeInput(for: 7)
//
//let inputLines = input.components(separatedBy: "\n")
//
//
//var homeDir = Dir("temp")
//
//
//struct Line {
//
//    enum Kind {
//        case command
//        case file
//        case dir
//    }
//
//    var kind: Kind
//
//    init(str: String) {
//
//    }
//}
//
//
//for line in inputLines {
//
//    let lineParts = line.components(separatedBy: " ")
//
//
//
//
//}


/*
enum Command: Equatable {
    case moveOut
    case moveInto(String)
    case list(String)

    var strValue: String { String(describing: self.self) }

    init?(line: String) {
        guard line.hasPrefix("$") else { return nil }
        let commandInputIndex = line.index(line.startIndex, offsetBy: 4)
        let commandInput = String(line[commandInputIndex...])
        switch true {
        case line.hasPrefix("$ cd .."): self = .moveOut
        case line.hasPrefix("$ cd"): self = .moveInto(commandInput)
        case line.hasPrefix("$ ls"): self = .list(commandInput)
        default:
            fatalError()
        }
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.strValue == rhs.strValue
    }

}


enum Node: Equatable {
    static let homeDirName = "/"

    case file(_ name: String, size: Int)
    indirect case folder(_ name: String, contents: [Node])

    var isFolder: Bool {
        switch self {
        case .file: return false
        case .folder: return true
        }
    }

    mutating func addContentIfAble(_ newValue: Node) -> Bool {
        var result = false
        if case let .folder(name, current) = self {
            self = .folder(name, contents: current + [newValue])
            result = true
        }
        return result
    }

    mutating func moveOut() -> Node? {
        switch self {
        case .file: return nil
        case .folder(let name, _):
            guard name != Self.homeDirName else { return nil }


        }

    }

}



assert(inputLines.first! == "$ cd /")

let firstLine = inputLines.removeFirst()

let firstCommand = Command(line: firstLine)!
assert(firstCommand == .moveInto("/"))

var homeDir = Node.folder("/", contents: [])

var current = homeDir

for line in inputLines {

    if let executedCommand = Command(line: line) {

        switch executedCommand {
        case .moveInto(let dirName):
        case .moveOut:
            switch current {
            case .file: fatalError()
            case .folder(let name, _):
                guard name != Self.homeDirName else { return nil }


            }

        case .list(let filename):
        }


    }
}
*/


var poAction = false


class Datum: Hashable {
    let name: String
    let id = UUID()
    init(_ name: String) {
        self.name = name
        if poAction {
            print(initOutput())
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    static func ==(lhs: Datum, rhs: Datum) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }

    func initOutput() -> String {
        return name
    }

    func contentsOutput() -> String {
        return name
    }

}

class File: Datum {
    let size: Int
    init(_ name: String, size: Int) {
        self.size = size
        super.init(name)
    }

    override func contentsOutput() -> String {
        return super.contentsOutput() + "| \(size)"
    }

    override func initOutput() -> String {
        return "init File:\(size)|" + super.initOutput()
    }

}

class Folder: Datum {

    private var fileSet = Set<File>()
    private var folderSet = Set<Folder>()

    var files: [File] { Array(fileSet) }
    var folders: [Folder] { Array(folderSet) }

    var parent: Folder? = nil

    var depth: Int {
        guard let parent = parent else { return 0 }
        return parent.depth + 1
    }

    var filesSize: Int { files.reduce(0) { $0 + $1.size } }
    var totalSize: Int { filesSize + folders.reduce(0) { $0 + $1.filesSize }}

    init(_ name: String, contents: [Datum] = []) {
        super.init(name)
        contents.forEach(addDatum)
    }

    override func initOutput() -> String {
        return "init Folder:" + super.initOutput()
    }

    func addDatum(_ datum: Datum) {
        if let file = datum as? File {
            add(file)
        } else if let folder = datum as? Folder {
            add(folder)
        }
    }

    func add(_ newFile: File) {
        fileSet.insert(newFile)
    }

    func add(_ newFolder: Folder) {
        folderSet.insert(newFolder)
        newFolder.parent = self
    }

    func path() -> String {
        return _path()
    }

    func printContents() {

        let indent = String(repeating: "\t", count: depth)

        files.forEach { print("\(indent)\($0.name)| \($0.size)") }

        folders.forEach { print($0.printContents()) }
    }

    override func contentsOutput() -> String {
        return 🗂️
    }

    private func _path(currentPath: [String] = []) -> String {
        var reversedNames = currentPath + [name]
        if let parent = parent {
            return parent._path(currentPath: reversedNames)
        } else {
            return reversedNames.reversed().joined(separator: "/")
        }
    }
}

//var dir_lvl_3 = Folder("lvl_3")
//var dir_lvl_2 = Folder("lvl_2")
//dir_lvl_2.add(dir_lvl_3)
//var dir_lvl_1 = Folder("lvl_1")
//dir_lvl_1.add(dir_lvl_2)
//var base = Folder("base", contents: [dir_lvl_1])

enum Command {
    case moveInto(String)
    case moveOut
    case list

    init?(line: String) {
        switch line.prefix(4) {
        case "$ cd":
            if line == "$ cd .." {
                self = .moveOut
            } else {
                let suffixStartIndex = line.index(line.startIndex, offsetBy: 5)
                let dirname = line.suffix(from: suffixStartIndex)
                self = .moveInto(String(dirname))
            }
        case "$ ls":
            self = .list

        default:
            return nil

        }
    }
}

enum Line {
    case command(Command)
    case content(String)
    var isContent: Bool {
        switch self {
        case .command: return false
        case .content: return true
        }
    }

    init(str: String) {
        if let command = Command(line: str) {
            self = .command(command)
        } else {
            self = .content(str)
        }
    }
}


let (expected, demo) = demoInput(for: 7)
var demoLinesStrings = demo.components(separatedBy: "\n")
let baseLineString = demoLinesStrings.removeFirst()
assert(baseLineString == "$ cd /")

let baseLine = Line(str: baseLineString)
assert(!baseLine.isContent)

let base = Folder("BASE")

var currentDir: Folder = base

func build(from inputLines: [String]) {

    func handleCommand(_ command: Command) {
        switch command {
        case .moveInto(let dirname):
            guard let nextDir = currentDir.folders.first(where: { $0.name == dirname }) else { fatalError() }
            currentDir = nextDir
        case .moveOut:
            guard let nextDir = currentDir.parent else { fatalError() }
            currentDir = nextDir
        case .list:
            break
        }
    }

    func handleContent(_ contentLineStr: String) {
        let parts = contentLineStr.components(separatedBy: " ")
        let name = parts[1]
        switch parts[0] {
        case "dir":
            let newFolder = Folder(name)
            currentDir.add(newFolder)
        default:

            guard let size = Int(parts[0]) else { fatalError() }
            let newFile = File(name, size: size)
            currentDir.add(newFile)
        }
    }

    var mutableInputLines = inputLines

    while !mutableInputLines.isEmpty {
        let currentLineString = mutableInputLines.removeFirst()
        if currentLineString.isEmpty { break }
        var currentLine = Line(str: currentLineString)
        switch currentLine {
        case .command(let command): handleCommand(command)
        case .content(let lineStr): handleContent(lineStr)
        }
    }

}
poAction = false
build(from: demoLinesStrings)

base.printContents()



