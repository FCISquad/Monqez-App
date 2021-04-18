import { EARTH_RADIUS, toRadians } from './utils.js';
import { computeDistanceBetweenHelper } from './compute-distance-between.js';
import { convert } from './latlng.js';

function sphericalExcess(a, b, c) {
    const polygon = [a, b, c, a];
    const distances = [];
    let sumOfDistances = 0;
    for (let i = 0; i < 3; i++) {
        distances[i] = computeDistanceBetweenHelper(polygon[i], polygon[i + 1]);
        sumOfDistances += distances[i];
    }

    const semiPerimeter = sumOfDistances / 2;
    let tan = Math.tan(semiPerimeter / 2);
    for (let i = 0; i < 3; i++) {
        tan *= Math.tan((semiPerimeter - distances[i]) / 2);
    }
    return 4 * Math.atan(Math.sqrt(Math.abs(tan)));
}

function sphericalSign(a, b, c) {
    const matrix = [a, b, c].map(point => {
        const lat = toRadians(point.lat());
        const lng = toRadians(point.lng());
        return [
            Math.cos(lat) * Math.cos(lng),
            Math.cos(lat) * Math.sin(lng),
            Math.sin(lat),
        ];
    });

    return 0 <
        matrix[0][0] * matrix[1][1] * matrix[2][2] +
            matrix[1][0] * matrix[2][1] * matrix[0][2] +
            matrix[2][0] * matrix[0][1] * matrix[1][2] -
            matrix[0][0] * matrix[2][1] * matrix[1][2] -
            matrix[1][0] * matrix[0][1] * matrix[2][2] -
            matrix[2][0] * matrix[1][1] * matrix[0][2]
        ? 1
        : -1;
}

function computeSphericalExcess(a, b, c) {
    return sphericalExcess(a, b, c) * sphericalSign(a, b, c);
}

/**
 * Returns the signed area of a closed path. The signed area may be used to
 * determine the orientation of the path. The computed area uses the same units
 * as the radius. The radius defaults to the Earth's radius in meters, in which
 * case the area is in square meters.
 * @param {LatLng[]} loop
 * @param {number} [radius]
 * @returns {number}
 */
export default function computeSignedArea(loop, radius = EARTH_RADIUS) {
    if (loop.length < 3) return 0;
    loop = loop.map(v => convert(v));

    let total = 0;
    for (var i = 1; i < loop.length - 1; i++) {
        total += computeSphericalExcess(loop[0], loop[i], loop[i + 1]);
    }
    return total * radius * radius;
}
