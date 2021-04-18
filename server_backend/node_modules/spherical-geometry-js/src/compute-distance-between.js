import { EARTH_RADIUS, toRadians } from './utils.js';
import { convert } from './latlng.js';

export function computeDistanceBetweenHelper(from, to) {
    const radFromLat = toRadians(from.lat());
    const radFromLng = toRadians(from.lng());
    const radToLat = toRadians(to.lat());
    const radToLng = toRadians(to.lng());
    return (
        2 *
        Math.asin(
            Math.sqrt(
                Math.pow(Math.sin((radFromLat - radToLat) / 2), 2) +
                    Math.cos(radFromLat) *
                        Math.cos(radToLat) *
                        Math.pow(Math.sin((radFromLng - radToLng) / 2), 2)
            )
        )
    );
}

/**
 * Returns the distance, in meters, between to LatLngs. You can optionally
 * specify a custom radius. The radius defaults to the radius of the Earth.
 * @param {LatLng} from
 * @param {LatLng} to
 * @param {number} [radius]
 * @returns {number} distance
 */
export default function computeDistanceBetween(
    from,
    to,
    radius = EARTH_RADIUS
) {
    from = convert(from);
    to = convert(to);
    return computeDistanceBetweenHelper(from, to) * radius;
}
