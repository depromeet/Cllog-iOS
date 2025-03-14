import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Folder"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.cllog)
    ]
)
