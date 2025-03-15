import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Story"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.cllog)
    ]
)
