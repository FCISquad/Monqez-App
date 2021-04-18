import { convert } from './latlng.js';
import { toRadians, toDegrees } from './utils.js';

function fmod(angle, start, end) {
    end -= start;
    return ((((angle - start) % end) + end) % end) + start;
}

/**
 * Returns the heading from one LatLng to another LatLng. Headings are expressed
 * in degrees clockwise from North within the range [-180, 180).
 * @param {LatLng} from
 * @param {LatLng} to
 * @returns {number}
 */
export default function computeHeading(from, to) {
    from = convert(from);
    to = convert(to);

    const fromLat = toRadians(from.lat());
    const toLat = toRadians(to.lat());
    const deltaLng = toRadians(to.lng()) - toRadians(from.lng());

    const angle = toDegrees(
        Math.atan2(
            Math.sin(deltaLng) * Math.cos(toLat),
            Math.cos(fromLat) * Math.sin(toLat) -
                Math.sin(fromLat) * Math.cos(toLat) * Math.cos(deltaLng)
        )
    );

    return fmod(angle, -180, 180);
}
