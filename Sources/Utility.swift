import Foundation

public enum InputLoadError: LocalizedError {
    case pathFailed(String, String)
    case info(Any)
    case error(Error)
    public var localizedDescription: String {
        switch self {
        case .pathFailed(let name, let ext): return "Failed to get path for resource: \(name).\(ext)"
        case .info(let value): return String(describing: value)
        case .error(let error): return (error as NSError).localizedDescription
        }
    }
}

public func challengeInputResult(for day: Int) -> Result<String, InputLoadError> {
    let resourceName = "input_day_\(day)"
    let ext = "txt"
    guard let resourcePath = Bundle.main.path(forResource: resourceName, ofType: ext) else { return .failure(.pathFailed(resourceName, ext)) }
    do {
        let result = try String(contentsOfFile: resourcePath)
        return .success(result)
    } catch {
        return .failure(.error(error))
    }
}

public func challengeInput(for day: Int) -> String {
    let result = challengeInputResult(for: day)
    switch result {
    case .success(let input): return input
    case .failure(let error): return error.localizedDescription
    }
}

public func demoInputResult(for day: Int) -> Result<(Int, String), InputLoadError> {
    let resourceName = "demo_day_\(day)"
    let ext = "txt"
    guard let resourcePath = Bundle.main.path(forResource: resourceName, ofType: ext) else { return .failure(.pathFailed(resourceName, ext)) }
    do {
        let fileContents = try String(contentsOfFile: resourcePath)
        let parts = fileContents.components(separatedBy: "\n\n")
        let expected = Int(parts[0])!
        let input = parts[1]
        return .success((expected, input))
    } catch {
        return .failure(.error(error))
    }
}

public func demoInput(for day: Int) -> (Int, String) {
    let result = demoInputResult(for: day)
    switch result {
    case .success(let result): return result
    case .failure(let error): return (-1, error.localizedDescription)
    }
}
