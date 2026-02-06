import Cadova

/*
 * Support for attaching a UniFi 5G Ethernet Adapter to a Neomounts DS75-450BL2 monitor arm.
 * Adatper dimensions: 83.4 x 25 x 16.5 mm
 * Support has a 3.2mm deep edge
 */
await Project {

    let length = 70.0
    let height = 16.5
    let width = 25.0
    let clipWidth = 15.0
    let depth = 1.5

    await Model("network-adapter-support") {
        Union {
            Box(x: length, y: width + 2 * depth, z: depth)

            Clip(depth: depth, height: height, width: clipWidth)
                .translated(x: 10.0)
            Clip(depth: depth, height: height, width: clipWidth)
                .translated(x: length - 10.0 - clipWidth)

            Clip(depth: depth, height: height, width: clipWidth)
                .rotated(angle: .degrees(180.0), axis: .z)
                .translated(x: 10.0 + clipWidth, y: width + 2 * depth)

            Clip(depth: depth, height: height, width: clipWidth)
                .rotated(angle: .degrees(180.0), axis: .z)
                .translated(x: length - 10.0, y: width + 2 * depth)

            Box(x: length, y: 4.0 + depth, z: depth)
                .translated(z: -3.2 - depth)
            Box(x: length, y: depth, z: 3.2)
                .translated(z: -3.2)
        }
    }
}

struct Clip: Shape3D {
    var depth: Double
    var height: Double
    var width: Double

    public var body: any Geometry3D {
        Union {
            Box(x: width, y: depth, z: height + depth)
            Box(x: width, y: 3.0, z: depth)
                .translated(y: depth, z: height)
        }.translated(z: depth)
    }
}
