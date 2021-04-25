const LAT = 'latitude';
const LNG = 'longitude';

/**
 * Converts an object into a LatLng. Tries a few different methods:
 * 1. If instanceof LatLng, clone and return the object
 * 2. If it has 'lat' and 'lng' properties...
 *    2a. if the properties are functions (like Google LatLngs),
 *        use the lat() and lng() values as lat and lng
 *    2b. otherwise get lat and lng, parse them as floats and try them
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
 * @param {any} like
 * @returns {LatLng}
 */
export function convert(like) {
    if (like instanceof LatLng) {
        return new LatLng(like[LAT], like[LNG]);
    } else if ('lat' in like && 'lng' in like) {
        if (typeof like.lat == 'function' && typeof like.lng == 'function') {
            return new LatLng(like.lat(), like.lng());
        } else {
            return new LatLng(parseFloat(like.lat), parseFloat(like.lng));
        }
    } else if ('lat' in like && 'long' in like) {
        return new LatLng(parseFloat(like.lat), parseFloat(like.long));
    } else if ('lat' in like && 'lon' in like) {
        return new LatLng(parseFloat(like.lat), parseFloat(like.lon));
    } else if ('latitude' in like && 'longitude' in like) {
        return new LatLng(
            parseFloat(like.latitude),
            parseFloat(like.longitude)
        );
    } else if (typeof like[0] === 'number' && typeof like[1] === 'number') {
        return new LatLng(like[1], like[0]);
    } else if ('x' in like && 'y' in like) {
        return new LatLng(parseFloat(like.y), parseFloat(like.x));
    } else {
        throw new TypeError(`Cannot convert ${like} to LatLng`);
    }
}

/**
 * Comparison function
 * @param {LatLng} one
 * @param {LatLng} two
 * @returns {boolean}
 */
export function equals(one, two) {
    one = convert(one);
    two = convert(two);
    return (
        Math.abs(one[LAT] - two[LAT]) < Number.EPSILON &&
        Math.abs(one[LNG] - two[LNG]) < Number.EPSILON
    );
}

export default class LatLng {
    /**
     * @param {number} lat
     * @param {number} lng
     * @param {boolean} noWrap
     */
    constructor(lat, lng, noWrap = false) {
        lat = parseFloat(lat);
        lng = parseFloat(lng);

        if (Number.isNaN(lat) || Number.isNaN(lng)) {
            throw TypeError('lat or lng are not numbers');
        }

        if (!noWrap) {
            //Constrain lat to -90, 90
            lat = Math.min(Math.max(lat, -90), 90);
            //Wrap lng using modulo
            lng = lng == 180 ? lng : ((((lng + 180) % 360) + 360) % 360) - 180;
        }

        Object.defineProperty(this, LAT, { value: lat });
        Object.defineProperty(this, LNG, { value: lng });
        this.length = 2;

        Object.freeze(this);
    }

    /**
     * Comparison function
     * @param {LatLng} other
     * @returns {boolean}
     */
    equals(other) {
        return equals(this, other);
    }

    /**
     * Returns the latitude in degrees.
     * (I'd rather use getters but this is for consistency)
     * @returns {number}
     */
    lat() {
        return this[LAT];
    }

    /**
     * Returns the longitude in degrees.
     * (I'd rather use getters but this is for consistency)
     * @returns {number}
     */
    lng() {
        return this[LNG];
    }

    /** @type {number} alias for lng */
    get x() {
        return this[LNG];
    }
    /** @type {number} alias for lat */
    get y() {
        return this[LAT];
    }
    /** @type {number} alias for lng */
    get 0() {
        return this[LNG];
    }
    /** @type {number} alias for lat */
    get 1() {
        return this[LAT];
    }
    /** @type {number} alias for lng */
    get long() {
        return this[LNG];
    }
    /** @type {number} alias for lng */
    get lon() {
        return this[LNG];
    }

    /**
     * Converts to JSON representation. This function is intended to be used via
     * JSON.stringify.
     * @returns {LatLngLiteral}
     */
    toJSON() {
        return { lat: this[LAT], lng: this[LNG] };
    }

    /**
     * Converts to string representation.
     * @returns {string}
     */
    toString() {
        return `(${this[LAT]}, ${this[LNG]})`;
    }

    /**
     * Returns a string of the form "lat,lng" for this LatLng. We round the
     * lat/lng values to 6 decimal places by default.
     * @param {number} [precision=6]
     * @returns {string}
     */
    toUrlValue(precision = 6) {
        precision = parseInt(precision);
        return (
            parseFloat(this[LAT].toFixed(precision)) +
            ',' +
            parseFloat(this[LNG].toFixed(precision))
        );
    }

    [Symbol.iterator]() {
        let i = 0;
        return {
            next: () => {
                if (i < this.length) {
                    return { value: this[i++], done: false };
                } else {
                    return { done: true };
                }
            },
            [Symbol.iterator]() {
                return this;
            },
        };
    }
}
