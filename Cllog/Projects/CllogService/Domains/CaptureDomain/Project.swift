import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Capture"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.cllog)
    ]
)
