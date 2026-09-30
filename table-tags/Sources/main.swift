import Cadova
import Foundation

let baseFolder = URL(filePath: #filePath).deletingLastPathComponent().deletingLastPathComponent()

let logos = [
    "pacman-svgrepo-com.svg",
    // https://www.svgrepo.com/svg/485837/pacman
    // PD License: https://www.svgrepo.com/page/licensing/#PD
    "ghost-pacman-svgrepo-com.svg",
    // https://www.svgrepo.com/svg/203693/ghost-pacman
    // CC0 License: https://www.svgrepo.com/page/licensing/#CC0
    "space-invaders-pixel-retro-arcade-svgrepo-com.svg",
    // https://www.svgrepo.com/svg/390749/space-invaders-pixel-retro-arcade
    // Author: wishforge.games
    // CC Attribution License: https://www.svgrepo.com/page/licensing/#CC%20Attribution
    "floppy-svgrepo-com.svg",
    // https://www.svgrepo.com/svg/408867/floppy
    // Author: Cosmin Negoita
    // CC Attribution License: https://www.svgrepo.com/page/licensing/#CC%20Attribution
    "joystick-controller-play-games-svgrepo-com.svg",
    // joystick-controller-play-games-svgrepo-com.svg https://www.svgrepo.com/svg/390730/joystick-controller-play-games
    // Author: wishforge.games
    // CC Attribution License: https://www.svgrepo.com/page/licensing/#CC%20Attribution
    "joystick-svgrepo-com.svg",
    // joystick-svgrepo-com https://www.svgrepo.com/svg/459075/joystick
    // Author: Sanity.io
    // MIT License: https://www.svgrepo.com/page/licensing/#MIT
    "apple-173-svgrepo-com.svg",
    // https://www.svgrepo.com/svg/511330/apple-173
    // PD License: https://www.svgrepo.com/page/licensing/#PD
]

await Project(packageRelative: "Models") {
    await Model("Rings") {
        Metadata(
            title: "Rings",
            description: "Napkin rings with retro-computing logo",
            author: "Eric Bariaux",
            license: "MIT license",
            application: "https://github.com/ebariaux/3d-prints"
        )

        Stack(.x, spacing: 2.0) {
            for logo in logos {
                let p = Part(logo)
                EngravedRing(name: logo).inPart(p)
            }
        }
    }

    await Model("Hooks") {
        Metadata(
            title: "Hooks",
            description: "Hooks to attach tags to a glass",
            author: "Eric Bariaux",
            license: "MIT license",
            application: "https://github.com/ebariaux/3d-prints"
        )
        Stack(.x, spacing: 2.0) {
            for _ in logos {
                Hook()
            }
        }
    }

    await Model("Tags") {
        Metadata(
            title: "Tags",
            description: "Tags with retro-computing logo",
            author: "Eric Bariaux",
            license: "MIT license",
            application: "https://github.com/ebariaux/3d-prints"
        )
        Stack(.x, spacing: 2.0) {
            for logo in logos {
                let p = Part(logo)
                Tag(name: logo).inPart(p)
            }
        }
    }
}

// Adapted from OpenSCAD model https://makerworld.com/en/models/488557-glass-marker-name-tag-fob-customizable#profileId-401561
struct Tag: Geometry3D {
    let name: String
    let inverted: Bool

    let hookRadius = 5.0
    let plateSize = Vector2D(21, 24)

    init(name: String, inverted: Bool = false) {
        self.name = name
        self.inverted = inverted
    }

    var body: any Geometry3D {
        Union {
            Union {
                Cylinder(radius: hookRadius, height: 2.0)
                    .aligned(at: .centerXY)
                .subtracting(
                    Box(x: 3, y: 6, z: 6).translated(x: -1.5, y: -8, z: -3)
                )
                Box(Vector3D(plateSize + [3.5, 3.0], z: 2.0))
                    .aligned(at: .centerY)
                    .translated(x: 2.0)
                    .cuttingEdgeProfile(
                        .fillet(radius: 2.0),
                        on: [.verticalBackLeft, .verticalBackRight,
                            .verticalFrontLeft, .verticalFrontRight]
                    )
            }
            .subtracting(
                Cylinder(radius: hookRadius - 1.5, height: 2)
                    .aligned(at: .centerXY)
            )
            .subtracting(
                Box(Vector3D(plateSize, z: 1.0)).aligned(at: .centerY)
                    .translated(x: 4.5)
            )

            if inverted {
                Box(Vector3D(plateSize, z: 1.0))
                    .aligned(at: .centerY)
                    .translated(x: 4.5)
                .subtracting(
                    ScaledShape(name: name, targetHeight: 16.0)
                        .extruded(height: 1.0)
                        .aligned(at: .centerXY)
                        .rotated(.degrees(90), around: .z)
                        .translated(x: 15)
                )
            } else {
                ScaledShape(name: name, targetHeight: 16.0)
                    .extruded(height: 1.0)
                    .aligned(at: .centerXY)
                    .rotated(.degrees(90), around: .z)
                    .translated(x: 15)
            }

            Cylinder(radius: 0.8, height: 2)
                .translated(x: -1.4, y: -3.97)
            Cylinder(radius: 1, height: 2)
                .translated(x: 1.8, y: -4.05)
        }
        .scaled(y: -1)
        .flipped(along: .z)
    }
}

// Adapted from OpenSCAD model https://makerworld.com/en/models/488557-glass-marker-name-tag-fob-customizable#profileId-401561
struct Hook: Geometry3D {
    let clipgap = 1.0  // gap size, distance between the two arms
    let filamenthole_dia = 3.2  // size of the hole for the filament

    let epsilon = 0.05  // extra length to avoid gaps between the sections

    let height = 3.0  // height of the clip
    let wallth = 2.0  // thickness of the wall
    let length0 = 10.0  // length of the first straight section
    let length4 = 0.5  // length of the last straight section

    let bigr = 8.0
    let smallr = 5.0

    let squareRootTwo = 2.0.squareRoot()

    var body: any Geometry3D {
        let length2 = (7.364 - wallth - clipgap) * squareRootTwo
       
        Union {
            Box(x: wallth, y: length0 + epsilon, z: height)
                .translated(x: -wallth / 2, y: -length0 + epsilon)
            Cylinder(radius: 3.2, height: height)
                .translated(x: -2.2, y: -10.0)
        }
        .subtracting {
            Cylinder(radius: filamenthole_dia / 2, height: height)
                .translated(x: -2.2, y: -10.0)
        }

        Cylinder(radius: (bigr + wallth) / 2, height: height)
            .subtracting {
                Cylinder(radius: (bigr - wallth) / 2, height: height)
                Box(x: bigr, y: bigr, z: height)
                    .translated(x: -bigr, y: -bigr)
                Box(x: bigr, y: bigr, z: height)
                    .translated(x: -bigr, y: -bigr)
                    .rotated(.degrees(45), around: .z)
            }
            .translated(x: bigr / 2)

        Box(x: length2 + 2 * epsilon - 1.6, y: wallth, z: height)
            .translated(x: -epsilon + 0.5, y: -wallth - 0.7)
            .rotated(.degrees(-135), around: .z)
            .translated(x: 8.536, y: -3.536)

        Cylinder(radius: (smallr + wallth) / 2, height: height)
            .subtracting(
                Cylinder(radius: (smallr - wallth) / 2, height: height)
            )
            .subtracting(
                Box(x: 20, y: 10, z: height).translated(x: -10, y: -10)
            )
            .subtracting(Box(x: 10, y: 10, z: height))
            .rotated(z: .degrees(45))
            .translated(
                x: 10 - length2 / squareRootTwo,
                y: -3.2 - length2 / squareRootTwo
            )

        Box(x: length4 + 2 * epsilon, y: wallth, z: height)
            .translated(x: -epsilon, y: -wallth / 2)
            .adding(
                Cylinder(radius: wallth / 2, height: height).translated(
                    x: length4
                )
            )
            .rotated(.degrees(-45), around: .z)
            .translated(
                x: 8.25 - length2 / squareRootTwo,
                y: -5 - length2 / squareRootTwo
            )
    }
}

// Inspired by https://www.printables.com/model/107345-rond-de-serviette/files
struct EngravedRing: Geometry3D {
    let name: String

    var body: any Geometry3D {
        Sphere(diameter: 40)
            .intersecting(
                Box(x: 40.0, y: 40.0, z: 20.0)
                    .aligned(at: .center)
            )
            .subtracting(
                Cylinder(radius: 15.0, height: 20.0).aligned(at: .center)
            )
            .cuttingEdgeProfile(.fillet(radius: 0.5), on: .top)
            .cuttingEdgeProfile(.fillet(radius: 0.5), on: .bottom)
            .subtracting(Engraving(name: name, targetHeight: 16.0))
    }
}

struct Engraving: Geometry3D {
    let name: String
    var scale: Double? = nil
    var targetHeight: Double? = nil

    var body: any Geometry3D {
        ScaledShape(name: name, scale: scale, targetHeight: targetHeight)
            .extruded(height: 10.0)
            .aligned(at: .center)
            .rotated(.degrees(90.0), around: .x)
            .translated(y: -18.0)
            .subtracting(Sphere(radius: 19.0).aligned(at: .center))
    }
}

struct ScaledShape: Geometry2D {
    let name: String
    var scale: Double? = nil
    var targetHeight: Double? = nil

    var body: any Geometry2D {
        let shape = Import(svg: baseFolder.appendingPathComponent(name))
        if let scale {
            return shape.scaled(scale)
        }
        return shape.measuringBounds { shape, bounds in
            var scaleFactor: Double
            if let targetHeight {
                scaleFactor = targetHeight / bounds.size.y
            } else {
                scaleFactor = 1.0
            }
            shape.scaled(scaleFactor)
        }
    }
}
