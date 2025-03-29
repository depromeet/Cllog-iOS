import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Edit"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.cllog)
    ]
)
