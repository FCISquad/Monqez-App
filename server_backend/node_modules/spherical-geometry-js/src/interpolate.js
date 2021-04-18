import LatLng, { convert } from './latlng.js';
import { computeDistanceBetweenHelper } from './compute-distance-between.js';
import { toRadians, toDegrees } from './utils.js';

/**
 * Returns the LatLng which lies the given fraction of the way between the
 * origin LatLng and the destination LatLng.
 * @param {LatLng} from
 * @param {LatLng} to
 * @param {number} fraction
 * @returns {LatLng}
 */
export default function interpolate(from, to, fraction) {
    from = convert(from);
    to = convert(to);
    const radFromLat = toRadians(from.lat()),
        radFromLng = toRadians(from.lng()),
        radToLat = toRadians(to.lat()),
        radToLng = toRadians(to.lng()),
        cosFromLat = Math.cos(radFromLat),
        cosToLat = Math.cos(radToLat);

    const radDist = computeDistanceBetweenHelper(from, to);
    const sinRadDist = Math.sin(radDist);

    if (1e-6 > sinRadDist) return from;

    const a = Math.sin((1 - fraction) * radDist) / sinRadDist;
    const b = Math.sin(fraction * radDist) / sinRadDist;
    const c =
        a * cosFromLat * Math.cos(radFromLng) +
        b * cosToLat * Math.cos(radToLng);
    const d =
        a * cosFromLat * Math.sin(radFromLng) +
        b * cosToLat * Math.sin(radToLng);

    return new LatLng(
        toDegrees(
            Math.atan2(
                a * Math.sin(radFromLat) + b * Math.sin(radToLat),
                Math.sqrt(Math.pow(c, 2) + Math.pow(d, 2))
            )
        ),
        toDegrees(Math.atan2(d, c))
    );
}
