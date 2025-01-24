// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
import Foundation

// MARK: - Swift Bundle Accessor

private class BundleFinder {}

extension Foundation.Bundle {
/// Since AccountData is a staticFramework, the bundle containing the resources is copied into the final product.
static let module: Bundle = {
    let bundleName = "AccountData_AccountData"

    var candidates = [
        Bundle.main.resourceURL,
        Bundle(for: BundleFinder.self).resourceURL,
        Bundle.main.bundleURL,
    ]

    // This is a fix to make Previews work with bundled resources.
    // Logic here is taken from SPM's generated `resource_bundle_accessors.swift` file,
    // which is located under the derived data directory after building the project.
    if let override = ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_PATH"] {
        candidates.append(URL(fileURLWithPath: override))

        // Deleting derived data and not rebuilding the frameworks containing resources may result in a state
        // where the bundles are only available in the framework's directory that is actively being previewed.
        // Since we don't know which framework this is, we also need to look in all the framework subpaths.
        if let subpaths = try? FileManager.default.contentsOfDirectory(atPath: override) {
            for subpath in subpaths {
                if subpath.hasSuffix(".framework") {
                    candidates.append(URL(fileURLWithPath: override + "/" + subpath))
                }
            }
        }
    }

    for candidate in candidates {
        let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
        if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
            return bundle
        }
    }
    fatalError("unable to find bundle named AccountData_AccountData")
}()
}

// MARK: - Objective-C Bundle Accessor

@objc
public class AccountDataResources: NSObject {
@objc public class var bundle: Bundle {
    return .module
}
}
// swiftlint:enable all
// swiftformat:enable all
