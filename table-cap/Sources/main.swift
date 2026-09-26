import Cadova

await Project(packageRelative: "Models") {
    await Model("table-cap") {
        let lampSupport = Part("lamp-support")
        let innerCap = Part("inner-cap")
        
        Metadata(
            title: "Table cap",
            description: "A specific item to attach the top of an old pedestal table to the base",
            author: "Eric Bariaux",
            license: "MIT license",
            application: "https://github.com/ebariaux/3d-prints"
        )

        Cylinder(radius: 58, height: 5)
            .cuttingEdgeProfile(.fillet(radius: 4), on: .top)
            .subtracting(Cylinder(radius: 54.2, height: 2)
                .translated(z: 3))
            .subtracting(Cylinder(radius: 22.05, height: 2)
                .translated(z: 1))
            .subtracting(Cylinder(radius: 15.82, height: 1))
            .inPart(lampSupport)

        let height = 15.0
        Union {
            Cylinder(radius: 22, height: 2)
                .translated(z: -2)
            Cylinder(radius: 4.85, height: height)
            Cylinder(radius: 15.8, height: height)
                .subtracting(Cylinder(radius: 13.65, height: height))
        }
        .flipped(along: .yz)
        .translated(z: 1.0)
        .inPart(innerCap)
    }
}
