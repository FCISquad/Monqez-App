/** @type {number} Earth's radius (at the Equator) of 6378137 meters. */
export const EARTH_RADIUS = 6378137;

export function toDegrees(radians) {
    return (radians * 180) / Math.PI;
}

export function toRadians(angleDegrees) {
    return (angleDegrees * Math.PI) / 180.0;
}
