import Foundation

public protocol ClLogCaptureInterface: Sendable {
    func start(on: UIViewController) async throws
}
