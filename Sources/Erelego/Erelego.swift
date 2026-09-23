// Distribution wrapper. The SDK entry point is ErelegoKit.Erelego.
@_exported import ErelegoKit

/// Version of this distribution package, separate from the embedded SDK version.
public enum ErelegoPackage {
    public static func version() -> String {
        return "1.7.4"
    }
}
