#!/usr/bin/swift

import Cocoa

extension Dictionary where Value: Equatable {
    func key(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}


func transform(input: String) -> String {

    let indexStartOfText = input.index(input.startIndex, offsetBy: 19)
    let indexEndOfText = input.index(input.endIndex, offsetBy: -3)

    let transformed = input[indexStartOfText...indexEndOfText]
    let key = String(transformed)

    guard let oldStrings = try? String(contentsOfFile: "old_strings.txt") else { return ""}
    let oldStringsDictionary = stringToDictionary(input: oldStrings)

    guard let oldTextValue = oldStringsDictionary[key] else {return ""}

    guard let newStrings = try? String(contentsOfFile: "new_strings.txt") else { return ""}
    let newStringsDictionary = stringToDictionary(input: newStrings)


    if let newKey = newStringsDictionary.key(forValue: oldTextValue) {
        let camelCase = camelCasedKey(input: newKey)
        return repleacement(key: camelCase)

    } else {
        writeToMissingListFile(key: key, value: oldStringsDictionary[key] ?? "")
        return oldValue(key: key)
    }

}

func removeSpecialCharacters(input: String) -> String {
    let output = input.replacingOccurrences(of: ";", with: "").replacingOccurrences(of: "\"", with: "")
    return output
}

func stringToDictionary(input: String) -> [String : String] {
    let withoutSpecialCharacters = removeSpecialCharacters(input: input)
    let dataArray = withoutSpecialCharacters.components(separatedBy: "\n")

    var dictionary:[String: String] = [:]

    for line in dataArray {
        let components = line.components(separatedBy: " = ")
        if let key = components.first, let value = components.last {
            dictionary[key] = value
        }
    }
    return dictionary
}

func camelCase(input: String, separator: String) -> String {
    let items = input.components(separatedBy: separator)
    var camelCase = ""

    for item in items.enumerated() {
        let element = item.element
        let capitalizedElement = element.capitalizingFirstLetter()
        let offset = item.offset

        camelCase += offset == 0 ? element : capitalizedElement
    }

    return camelCase
}

func camelCasedKey(input: String) -> String {
    let withoutDot = camelCase(input: input, separator: ".")
    let withoutUnderscore = camelCase(input: withoutDot, separator: "_")
    return withoutUnderscore
}

func oldValue(key: String) -> String {
    return "NSLocalizedString("\(key)", comment: "")"
}

func repleacement(key: String) -> String {
    return "L10n.\(key)"
}

func writeToMissingListFile(key: String, value: String) {

    let file = "missing_strings.txt"
    var log = (try? String(contentsOfFile: file)) ?? ""

    let newItem = "\(key) = \(value)\n"
    log.append(newItem)

    do {
        try log.write(toFile: file, atomically: true, encoding: .utf8)
    } catch {
        print("Failed to write to log: \(error.localizedDescription)")
    }
}


let textToReplace = CommandLine.arguments[1]
let result = transform(input: textToReplace)

print(result)

