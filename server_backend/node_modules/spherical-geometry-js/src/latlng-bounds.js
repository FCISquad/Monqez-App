import LatLng, { convert, equals } from './latlng';

export default class LatLngBounds {
    /**
     * @param {LatLngLike} [sw] southwest
     * @param {LatLngLike} [ne] northeast
     */
    constructor(sw, ne) {
        this.sw = convert(sw || [1, 180]);
        if (!ne) {
            ne = sw ? sw : [-1, -180];
        }
        this.ne = convert(ne);
    }

    /**
     * Check if point is within bounds.
     * @param {LatLngLike} latlng
     * @returns {boolean}
     */
    contains(latlng) {
        const [lng, lat] = convert(latlng);
        return (
            this.sw.lat() <= lat &&
            lat <= this.ne.lat() &&
            this.sw.lng() <= lng &&
            lng <= this.ne.lng()
        );
    }

    /**
     * Check if two bounds are equal.
     * @param {LatLngBounds | LatLngBoundsLiteral} other
     * @returns {boolean}
     */
    equals(other) {
        if (!other) {
            return false;
        } else if (other instanceof LatLngBounds) {
            return (
                equals(this.sw, other.getSouthWest()) &&
                equals(this.ne, other.getNorthEast())
            );
        } else if (
            [other.north, other.south, other.east, other.west].every(
                n => typeof n === 'number'
            )
        ) {
            const literal = this.toJSON();
            return (
                other.north === literal.north &&
                other.south === literal.south &&
                other.east === literal.east &&
                other.west === literal.west
            );
        } else {
            return false;
        }
    }

    /**
     * Mutate the bounds to include the given point.
     * @param {LatLngLike} point
     * @returns {LatLngBounds}
     */
    extend(point) {
        point = convert(point);
        this.sw = new LatLng(
            Math.min(this.sw.lat(), point.lat()),
            Math.min(this.sw.lng(), point.lng())
        );
        this.ne = new LatLng(
            Math.max(this.ne.lat(), point.lat()),
            Math.max(this.ne.lng(), point.lng())
        );

        return this;
    }

    /**
     * Computes and returns the center point of the bounds.
     * @returns {LatLng}
     */
    getCenter() {
        return new LatLng(
            (this.sw.lat() + this.ne.lat()) / 2,
            (this.sw.lng() + this.ne.lng()) / 2
        );
    }

    /** @returns {LatLng} */
    getNorthEast() {
        return this.ne;
    }

    /** @returns {LatLng} */
    getSouthWest() {
        return this.sw;
    }

    /**
     * Check if two bounds intersect at all.
     * @param {LatLngBounds} other
     * @returns {boolean}
     */
    intersects(other) {
        return (
            this.contains(other.getSouthWest()) ||
            this.contains(other.getNorthEast())
        );
    }

    /**
     * Return true if the southwest and northeast corners are equal.
     */
    isEmpty() {
        return equals(this.sw, this.ne);
    }

    /**
     * Convert into a LatLngBoundsLiteral.
     */
    toJSON() {
        return {
            east: this.ne.lng(),
            north: this.ne.lat(),
            south: this.sw.lat(),
            west: this.sw.lng(),
        };
    }

    toSpan() {
        throw new Error('Unsupported');
    }

    toString() {
        return `(${this.sw}, ${this.ne})`;
    }

    toUrlValue(precision) {
        return (
            this.sw.toUrlValue(precision) + ',' + this.ne.toUrlValue(precision)
        );
    }

    /**
     * Mutate the bounds to include the other bounds.
     * @param {LatLngBounds} bounds
     * @returns {LatLngBounds}
     */
    union(other) {
        if (!(other instanceof LatLngBounds)) {
            throw new TypeError(`${other} is not a LatLngBounds`);
        }
        return this.extend(other.getSouthWest()).extend(other.getNorthEast());
    }
}
