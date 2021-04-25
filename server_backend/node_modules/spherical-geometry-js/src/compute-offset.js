import { EARTH_RADIUS, toDegrees, toRadians } from './utils.js';
import LatLng, { convert } from './latlng.js';

/**
 * Returns the LatLng resulting from moving a distance from an origin in the
 * specified heading (expressed in degrees clockwise from north).
 * @param {LatLng} from
 * @param {number} distance
 * @param {number} heading
 * @param {number} [radius]
 * @returns {LatLng}
 */
export default function computeOffset(
    from,
    distance,
    heading,
    radius = EARTH_RADIUS
) {
    from = convert(from);
    distance /= radius;
    heading = toRadians(heading);

    const fromLat = toRadians(from.lat());
    const cosDistance = Math.cos(distance);
    const sinDistance = Math.sin(distance);
    const sinFromLat = Math.sin(fromLat);
    const cosFromLat = Math.cos(fromLat);
    const sc =
        cosDistance * sinFromLat + sinDistance * cosFromLat * Math.cos(heading);

    return new LatLng(
        toDegrees(Math.asin(sc)),
        toDegrees(
            toRadians(from.lng()) +
                Math.atan2(
                    sinDistance * cosFromLat * Math.sin(heading),
                    cosDistance - sinFromLat * sc
                )
        )
    );
}
