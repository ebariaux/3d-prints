import Cadova
import Helical

await Project {

    let length = 158.0
    let width = 40.0
    let height = 23.0

    let sideSpacing = 2.0

    let ventilationSlidHeight = 13.0
    let ventilationSlidWidth = 2.0
    let ventilationSlidSpacing = 10.0
    let ventilationSlidHOffset = 15.0
    let ventilationSlidVOffset = 7.0
    let numberOfVentilationSlids = 13

    let lidClipOffset = 58.0
    let lidClipLength = 40.0

    await Model("case") {
        let thickness = 4.0

        let boardSupportHeight = 4.0
        let boardSupportDiameter = 3.0
        let boardThroughHoleHeight: Double = 2.0
        let boardThroughHoleDiameter: Double = 1.9

        // Working from https://github.com/OLIMEX/ESP32-POE-ISO/blob/master/HARDWARE/Dimensions/Revision%20J%20and%20newer/ESP32-POE-ISO-revision-J-dimensions.pdf
        let boardHoleBottomLeft = Vector2D(x: 7.64, y: 2.73)
        let boardHoleTopLeft = Vector2D(x: 2.5654, y: 70.675)
        let boardHoleTopRight = Vector2D(x: 25.4254, y: 70.675)

        Union {
            // Bottom
            Box(x: length, y: width, z: thickness)

            // Long sides
            Box(x: length, y: thickness, z: height)
                .translated(z: thickness)
                .subtracting {
                    for i in 0..<numberOfVentilationSlids {
                        Box(x: ventilationSlidWidth, y: thickness, z: ventilationSlidHeight)
                            .translated(x: ventilationSlidHOffset + ventilationSlidSpacing * Double(i), z: ventilationSlidVOffset)
                    }
                }
            Box(x: length, y: thickness, z: height)
                .translated(y: width - thickness, z: thickness)
                .subtracting {
                    for i in 0..<numberOfVentilationSlids {
                        Box(x: ventilationSlidWidth, y: thickness, z: ventilationSlidHeight)
                            .translated(x: ventilationSlidHOffset + ventilationSlidSpacing * Double(i), y: width - thickness, z: ventilationSlidVOffset)
                    }
                }
            // Short sides
            Box(x: thickness, y: width - 2 * thickness, z: height)
                .translated(y: thickness, z: thickness)
            Box(x: thickness, y: width - 2 * thickness, z: height)
                .translated(x: length - thickness, y: thickness, z: thickness)

            // Lid clips
            Box(x: lidClipLength, y: 1.732, z: 6.0)
                .translated(x: lidClipOffset, y: 4.0, z: 21.0)
                .cuttingEdgeProfile(.chamfer(depth: 3.0, angle: 30°), on: .back)
            Box(x: lidClipLength, y: 1.732, z: 6.0)
                .translated(x: lidClipOffset, y: width - thickness - 1.732, z: 21.0)
                .cuttingEdgeProfile(.chamfer(depth: 3.0, angle: 30°), on: .front)

            // Board support front
            Cylinder(diameter: boardSupportDiameter, height: boardSupportHeight)
                .translated(x: length - thickness - boardHoleBottomLeft.y, y: thickness + sideSpacing + boardHoleBottomLeft.x, z: thickness)

            // Board supports back
            Cylinder(diameter: boardSupportDiameter, height: boardSupportHeight)
                .translated(x: length - thickness - boardHoleTopLeft.y, y: thickness + sideSpacing + boardHoleTopLeft.x, z: thickness)
            Cylinder(diameter: boardThroughHoleDiameter, height: boardThroughHoleHeight)
                .translated(x: length - thickness - boardHoleTopLeft.y, y: thickness + sideSpacing + boardHoleTopLeft.x, z: thickness + boardSupportHeight)

            Cylinder(diameter: boardSupportDiameter, height: boardSupportHeight)
                .translated(x: length - thickness - boardHoleTopRight.y, y: thickness + sideSpacing + boardHoleTopRight.x, z: thickness)
            Cylinder(diameter: boardThroughHoleDiameter, height: boardThroughHoleHeight)
                .translated(x: length - thickness - boardHoleTopRight.y, y: thickness + sideSpacing + boardHoleTopRight.x, z: thickness + boardSupportHeight)

            // RS-232 supports
            Box(x: 10.0, y: 4.3, z: 3.0)
                .translated(x: 18.0, y: thickness, z: thickness)
            Cylinder(diameter: 2.65, height: 1.5)
                .translated(x: 25.8, y: thickness + 1.35 + 0.7, z: thickness + 3.0)

            Box(x: 10.0, y: 4.3, z: 3.0)
                .translated(x: 18.0, y: width - 2 * thickness, z: thickness)
            Cylinder(diameter: 2.65, height: 1.5)
                .translated(x: 25.8, y: width - thickness - 1.35 - 0.7, z: thickness + 3.0)
        }
        .cuttingEdgeProfile(.fillet(radius: thickness), along: .z)

        // Ethernet jack hole
        .subtracting(Box(x: thickness, y: 17.0, z: 14.0)
            .translated(x: length - thickness, y: 14.5 + sideSpacing, z: 8.5))

        // RS-232 connector hole
        .subtracting(Box(x: 14.2, y: 31, z: thickness)
            .rotated(angle: 90°, around: .positiveY)
            .translated(y: thickness, z: thickness + 14.2 + 3.0))
    }

    await Model("lid") {
        let lidThickness = 2.0
        let lidBorderHeight = 6.0
        let lidBorderSpacing = 4.5

        Union {
            Box(x: length, y: width, z: lidThickness)
                .cuttingEdgeProfile(.fillet(radius: lidBorderSpacing), along: .z)
                .subtracting {
                    for i in 0..<numberOfVentilationSlids {
                        Box(x: ventilationSlidWidth, y: ventilationSlidHeight, z: lidThickness)
                            .translated(x: ventilationSlidHOffset + ventilationSlidSpacing * Double(i), y: (width - ventilationSlidHeight) / 2.0)
                    }
                }

            Box(x: length - 2 * lidBorderSpacing, y: lidThickness, z: lidBorderHeight)
                .translated(x: lidBorderSpacing, y: lidBorderSpacing, z: lidThickness)
            Box(x: length - 2 * lidBorderSpacing, y: lidThickness, z: lidBorderHeight)
                .translated(x: lidBorderSpacing, y: width - lidBorderSpacing - lidThickness, z: lidThickness)
            Box(x: lidThickness, y: width - 2 * (lidBorderSpacing + lidThickness), z: lidBorderHeight)
                .translated(x: lidBorderSpacing, y: lidBorderSpacing + lidThickness, z: lidThickness)
            Box(x: lidThickness, y: width - 2 * (lidBorderSpacing + lidThickness), z: lidBorderHeight)
                .translated(x: length - lidBorderSpacing - lidThickness, y: lidBorderSpacing + lidThickness, z: lidThickness)

            Box(x: lidClipLength + 1.072, y: 1.309, z: 6.0)
                .translated(x: lidClipOffset - 1.072 / 2.0, y: lidBorderSpacing + lidThickness, z: lidThickness)
                .cuttingEdgeProfile(.chamfer(depth: 1.309, angle: 60°), on: .verticalBackLeft)
                .cuttingEdgeProfile(.chamfer(depth: 1.309, angle: 60°), on: .verticalBackRight)
            Box(x: lidClipLength + 1.072, y: 1.309, z: 6.0)
                .translated(x: lidClipOffset - 1.072 / 2.0, y: width - lidBorderSpacing - lidThickness - 1.309, z: lidThickness)
                .cuttingEdgeProfile(.chamfer(depth: 1.309, angle: 60°), on: .verticalFrontLeft)
                .cuttingEdgeProfile(.chamfer(depth: 1.309, angle: 60°), on: .verticalFrontRight)
        }
        .subtracting {
            Box(x: lidThickness, y: 17, z: 2)
                .translated(x: lidBorderSpacing, y: width - lidBorderSpacing - lidThickness - 18.0, z: lidThickness + lidBorderHeight - 2)

            Box(x: lidClipLength + 0.4, y: 1.732, z: 6.2)
                .translated(x: lidClipOffset - 0.2, y: lidBorderSpacing, z: lidThickness - 0.1)
                .cuttingEdgeProfile(.chamfer(depth: 3.0, angle: 30°), on: .back)
            Box(x: lidClipLength + 0.4, y: 1.732, z: 6.2)
                .translated(x: lidClipOffset - 0.2, y: width - lidBorderSpacing - 1.732, z: lidThickness - 0.1)
                .cuttingEdgeProfile(.chamfer(depth: 3.0, angle: 30°), on: .front)
        }
    }
}
