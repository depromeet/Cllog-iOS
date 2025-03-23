import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Report"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.cllog)
    ]
)
