//
//  MathUtilities.swift
//  Link
//
//  Created by AlecNipp on 10/28/23.
//

import simd
extension FloatingPoint {
    // Converts degrees to radians.
    var degreesToRadians: Self { self * .pi / 180 }
    // Converts radians to degrees.
    var radiansToDegrees: Self { self * 180 / .pi }
}

// Provides the azimuth from an argument 3D directional.
func azimuth(from direction: simd_float3) -> Float {
    return asin(direction.x)
}

// Provides the elevation from the argument 3D directional.
func elevation(from direction: simd_float3) -> Float {
    return atan2(direction.z, direction.y) + .pi / 2
}
