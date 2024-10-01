// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Backtrace-PLCrashReporter",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12)
    ],
    products: [
        .library(name: "Backtrace-PLCrashReporter", targets: ["Backtrace-PLCrashReporter"])
    ],
    targets: [
        .target(
            name: "Backtrace-PLCrashReporter",
            path: "",
            exclude: [
                "Source/dwarf_opstream.hpp",
                "Source/dwarf_stack.hpp",
                "Source/PLCrashAsyncDwarfCFAState.hpp",
                "Source/PLCrashAsyncDwarfCIE.hpp",
                "Source/PLCrashAsyncDwarfEncoding.hpp",
                "Source/PLCrashAsyncDwarfExpression.hpp",
                "Source/PLCrashAsyncDwarfFDE.hpp",
                "Source/PLCrashAsyncDwarfPrimitives.hpp",
                "Source/PLCrashAsyncLinkedList.hpp",
                "Source/PLCrashReport.proto",
                "Tools/CrashViewer/",	
                "Other Sources/Crash Demo/"
            ],
            sources: [
                "Source",
                "Dependencies/protobuf-c"
            ],
            resources: [.process("Resources/PrivacyInfo.xcprivacy")],
            cSettings: [
                .define("PLCR_PRIVATE"),
                .define("PLCF_RELEASE_BUILD"),
                .define("PLCRASHREPORTER_PREFIX", to: ""),
                .define("SWIFT_PACKAGE"), // Should be defined by default, Xcode 11.1 workaround.
                .headerSearchPath("Dependencies/protobuf-c")
            ],
            linkerSettings: [
                .linkedFramework("Foundation")
            ]
        )
    ]
)
