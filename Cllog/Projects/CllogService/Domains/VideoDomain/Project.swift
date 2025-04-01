import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Video"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.cllog)
    ]
)
