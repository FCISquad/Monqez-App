/**
 * Spherical Geometry Library v2.0.0
 * This code is a port of some classes from the Google Maps Javascript API
 * @module spherical-geometry
 * @todo computeOffsetOrigin
 */

/** Earth's radius (at the Equator) of 6378137 meters. */
export const EARTH_RADIUS = 6378137;

export function toDegrees(radians: number): number;

export function toRadians(angleDegrees: number): number;

export class LatLng implements Iterable<number> {
    /**
     * @param lat Latitude
     * @param lng Longitude
     * @param noWrap By default, constrain latitude and longitude.
     * Ensures latitude is between [-90, 90] and
     * longitude is below 180.
     * Set noWrap to true to avoid this behavior.
     */
    constructor(lat: number | string, lng: number | string, noWrap?: boolean);

    /** Comparison function */
    equals(other: LatLngLike): boolean;

    /**
     * Returns the latitude in degrees.
     * (I'd rather use getters but this is for consistency)
     */
    lat(): number;

    /**
     * Returns the longitude in degrees.
     * (I'd rather use getters but this is for consistency)
     */
    lng(): number;

    /** alias for lng */
    readonly x: number;
    /** alias for lat */
    readonly y: number;
    /** alias for lat */
    readonly latitude: number;
    /** alias for lng */
    readonly longitude: number;
    /** alias for lng */
    readonly 0: number;
    /** alias for lat */
    readonly 1: number;
    /** alias for lng */
    readonly long: number;
    /** alias for lng */
    readonly lon: number;

    readonly length: 2;

    /**
     * Converts to JSON representation. This function is intended to be used via
     * JSON.stringify.
     * @returns LatLngLiteral
     */
    toJSON(): { lat: number; lng: number };

    /** Converts to string representation. */
    toString(): string;

    /**
     * Returns a string of the form "lat,lng" for this LatLng. We round the
     * lat/lng values to 6 decimal places by default.
     * @param precision Number of decimal places.
     */
    toUrlValue(precision?: number): string;

    [Symbol.iterator](): Iterator<number>;

    readonly [index: number]: number;
}

/**
 * Types that can be automatically converted into a LatLng using the
 * `convertLatLng` function. Other library functions automatically
 * convert your inputs so you don't need to call convert yourself.
 */
type LatLngLike =
    | LatLng
    | { lat(): number; lng(): number }
    | { lat: string | number; lng: string | number }
    | { lat: string | number; long: string | number }
    | { lat: string | number; lon: string | number }
    | { latitude: string | number; longitude: string | number }
    | [number, number]
    | { 0: number; 1: number }
    | { x: string | number; y: string | number };

/**
 * Converts an object into a LatLng. Tries a few different methods:
 * 1. If instanceof LatLng, clone the object and return it.
 * 2. If it has 'lat' and 'lng' properties...
 *    2a. if the properties are functions (like Google LatLngs),
 *        use the lat() and lng() values as latitude and longitude.
 *    2b. otherwise get lat and lng, parse them as floats and use them
 * 3. If it has 'lat' and *'long'* properties,
 *    parse them as floats and return a LatLng
 * 4. If it has 'lat' and *'lon'* properties,
 *    parse them as floats and return a LatLng
 * 5. If it has 'latitude' and 'longitude' properties,
 *    parse them as floats and return a LatLng
 * 6. If it has number values for 0 and 1, use 1 as latitude and 0
 *    as longitude.
 * 7. If it has x and y properties, try using y as latitude and x and
 *    longitude.
 */
export function convertLatLng(like: LatLngLike): LatLng;

/**
 * Compares two different coordinates.
 */
export function equalLatLngs(one: LatLngLike, two: LatLngLike): boolean;

/**
 * Returns the area of a closed path. The computed area uses the same units as
 * the radius. The radius defaults to the Earth's radius in meters, in which
 * case the area is in square meters.
 * @param path Path expressed as array representing points on the path.
 * @param radius Radius of planet.
 */
export function computeArea(
    path: ReadonlyArray<LatLngLike>,
    radius?: number
): number;

/**
 * Returns the distance, in meters, between to LatLngs. You can optionally
 * specify a custom radius. The radius defaults to the radius of the Earth.
 * @param from Starting point
 * @param to Ending point
 * @param radius Radius of planet.
 */
export function computeDistanceBetween(
    from: LatLngLike,
    to: LatLngLike,
    radius?: number
): number;

/**
 * Returns the heading from one LatLng to another LatLng. Headings are expressed
 * in degrees clockwise from North within the range [-180, 180).
 */
export function computeHeading(from: LatLngLike, to: LatLngLike): number;

/**
 * Returns the length of the given path.
 * @param path Path expressed as array representing points on the path.
 * @param radius Radius of planet.
 */
export function computeLength(
    path: ReadonlyArray<LatLngLike>,
    radius?: number
): number;

/**
 * Returns the LatLng resulting from moving a distance from an origin in the
 * specified heading (expressed in degrees clockwise from north).
 * @param radius Radius of planet.
 */
export function computeOffset(
    from: LatLngLike,
    distance: number,
    heading: number,
    radius?: number
): LatLng;

/**
 * Returns the location of origin when provided with a LatLng destination,
 * meters travelled and original heading. Headings are expressed in degrees
 * clockwise from North. This function returns null when no solution is
 * available.
 * @param radius Radius of planet.
 */
export function computeOffsetOrigin(
    to: LatLngLike,
    distance: number,
    heading: number,
    radius?: number
): LatLng | null;

/**
 * Returns the signed area of a closed path. The signed area may be used to
 * determine the orientation of the path. The computed area uses the same units
 * as the radius. The radius defaults to the Earth's radius in meters, in which
 * case the area is in square meters.
 * @param loop Path expressed as array representing points on the path.
 * @param radius Radius of planet.
 */
export function computeSignedArea(
    loop: ReadonlyArray<LatLngLike>,
    radius?: number
): number;

/**
 * Returns the LatLng which lies the given fraction of the way between the
 * origin LatLng and the destination LatLng.
 * @param from Starting point
 * @param to Ending point
 * @param fraction Percentage from [0, 1].
 */
export function interpolate(
    from: LatLngLike,
    to: LatLngLike,
    fraction: number
): LatLng;

export interface LatLngBoundsLiteral {
    east: number;
    north: number;
    south: number;
    west: number;
}

export class LatLngBounds {
    constructor(southwest?: LatLngLike, northeast?: LatLngLike);

    /**
     * Check if point is within bounds.
     */
    contains(latlng: LatLngLike): boolean;

    /**
     * Check if two bounds are equal.
     * @param {LatLngBounds | LatLngBoundsLiteral} other
     * @returns {boolean}
     */
    equals(other: LatLngBounds | LatLngBoundsLiteral): boolean;

    /**
     * Mutate the bounds to include the given point.
     */
    extend(point: LatLngLike): this;

    /**
     * Computes and returns the center point of the bounds.
     */
    getCenter(): LatLng;

    getNorthEast(): LatLng;

    getSouthWest(): LatLng;

    /**
     * Check if two bounds intersect at all.
     */
    intersects(other: LatLngBounds): boolean;

    /**
     * Return true if the southwest and northeast corners are equal.
     */
    isEmpty(): boolean;

    /**
     * Convert into a LatLngBoundsLiteral.
     */
    toJSON(): LatLngBoundsLiteral;

    toSpan(): never;

    toString(): string;

    toUrlValue(precision?: number): string;

    /**
     * Mutate the bounds to include the other bounds.
     */
    union(other: LatLngBounds): this;
}
