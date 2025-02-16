import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Login"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.cllog)
    ]
)
