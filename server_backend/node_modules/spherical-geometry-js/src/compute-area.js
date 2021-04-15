import computeSignedArea from './compute-signed-area.js';
import { EARTH_RADIUS } from './utils.js';

/**
 * Returns the area of a closed path. The computed area uses the same units as
 * the radius. The radius defaults to the Earth's radius in meters, in which
 * case the area is in square meters.
 * @param {LatLng[]} path
 * @param {number} [radius]
 * @returns {number} area
 */
export default function computeArea(path, radius = EARTH_RADIUS) {
    return Math.abs(computeSignedArea(path, radius));
}
