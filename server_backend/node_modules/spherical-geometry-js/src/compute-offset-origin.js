import { EARTH_RADIUS, toRadians, toDegrees } from './utils.js';
import LatLng, { convert } from './latlng.js';

/**
 * Returns the location of origin when provided with a LatLng destination,
 * meters travelled and original heading. Headings are expressed in degrees
 * clockwise from North. This function returns null when no solution is
 * available.
 * @todo
 * @param {LatLng} to
 * @param {number} distance
 * @param {number} heading
 * @param {number} [radius]
 * @returns {LatLng}
 */
export default function computeOffsetOrigin(
    to,
    distance,
    heading,
    radius = EARTH_RADIUS
) {
    to = convert(to);
    distance /= radius;
    heading = toRadians(heading);

    const quarterRadian = Math.PI / 2;
    const toLat = toRadians(to.lat());
    const toLng = toRadians(to.lng());

    const cosDistance = Math.cos(distance);
    const sinDistance = Math.sin(distance);
    const lngHeading = Math.cos(heading);
    const latHeading = Math.sin(heading);
    const lngSinHeading = sinDistance * lngHeading;
    const latSinHeading = sinDistance * latHeading;
    const sinToLat = Math.sin(toLat);

    const lngSinHeadingSquared = lngSinHeading * lngSinHeading;
    const cosDistanceSquared = cosDistance * cosDistance;
    // A function to complex I had more trouble with variable names
    const lotsOfMathSquared =
        lngSinHeadingSquared * cosDistanceSquared +
        cosDistanceSquared * cosDistanceSquared -
        cosDistanceSquared * sinToLat * sinToLat;
    if (0 > lotsOfMathSquared) return null;
    const lotsOfMath = Math.sqrt(lotsOfMathSquared);

    const distByLng = cosDistanceSquared + lngSinHeadingSquared;
    const moreMath = (lngSinHeading * sinToLat + lotsOfMath) / distByLng;
    const evenMoreMath = (sinToLat - lngSinHeading * moreMath) / cosDistance;
    let latRadian = Math.atan2(evenMoreMath, moreMath);
    if (latRadian < -quarterRadian || latRadian > quarterRadian) {
        latRadian = lngSinHeading * sinToLat - lotsOfMath;
        latRadian = Math.atan2(evenMoreMath, latRadian / distByLng);
    }
    if (latRadian < -quarterRadian || latRadian > quarterRadian) return null;

    return new LatLng(
        toDegrees(latRadian),
        toDegrees(
            toLng -
                Math.atan2(
                    latSinHeading,
                    cosDistance * Math.cos(latRadian) -
                        lngSinHeading * Math.sin(latRadian)
                )
        )
    );
}
