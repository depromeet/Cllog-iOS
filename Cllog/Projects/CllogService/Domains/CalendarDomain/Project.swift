import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Calendar"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.cllog)
    ]
)
