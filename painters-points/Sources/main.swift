import Cadova

await Project(packageRelative: "Models") {
    await Model("painters-points") {
        Metadata(
            title: "Painters points",
            description: "Painters points with base to fit in Black&Decker Workmate workbench",
            author: "Eric Bariaux",
            license: "MIT license",
            application: "https://github.com/ebariaux/3d-prints"
        )

        Stack(.z) {
            Cylinder(diameter: 19.6, height: 10)
            Cylinder(bottomDiameter: 30.0, topDiameter: 0.8, height: 15.0)
                .withSegmentation(count: 4)
                .subtracting(
                    Cylinder(diameter: 10, height: 30)
                        .aligned(at: .center)
                        .scaled(z: 1.4)
                        .withSegmentation(count: 3)
                        .shapingEdges(.fillet(radius: 0.5), matching: .along(.z))
                        .withSegmentation(count: 64)
                        .rotated(x: 180°, y: -90°, z: 45°)
                        .translated(z: 7)
                )
                .subtracting(
                    Cylinder(diameter: 10, height: 30)
                        .aligned(at: .center)
                        .scaled(z: 1.4)
                        .withSegmentation(count: 3)
                        .shapingEdges(.fillet(radius: 0.5), matching: .along(.z))
                        .withSegmentation(count: 64)
                        .rotated(x: 180°, y: -90°, z: -45°)
                        .translated(z: 7)
                )
        }
    }
}
