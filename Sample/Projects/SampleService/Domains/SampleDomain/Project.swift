import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Sample"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.sample)
    ]
)
