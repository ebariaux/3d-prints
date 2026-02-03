import Cadova

await Project {
    await Model("lamp-support") {
        Cylinder(radius: 58, height: 5)
            .cuttingEdgeProfile(.fillet(radius: 4), on: .top)
            .subtracting(Cylinder(radius: 54.2, height: 2)
                .translated(z: 3))
            .subtracting(Cylinder(radius: 22.05, height: 2)
                .translated(z: 1))
            .subtracting(Cylinder(radius: 15.82, height: 1))
    }

    await Model("inner-cap") {
        let height = 15.0
        Cylinder(radius: 22, height: 2)
            .translated(z: -2)
        Cylinder(radius: 4.85, height: height)
        Cylinder(radius: 15.8, height: height)
            .subtracting(Cylinder(radius: 13.65, height: height))
    }
}
