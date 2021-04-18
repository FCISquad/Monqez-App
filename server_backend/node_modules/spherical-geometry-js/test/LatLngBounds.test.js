const { LatLngBounds } = require('../');
const places = require('./data/places');
const googleMaps = require('./data/google-maps.json');

describe('LatLngBounds', () => {
    it('should construct bounds', () => {
        expect(() => new LatLngBounds()).not.toThrow();
        expect(() => new LatLngBounds([0, 0])).not.toThrow();
        expect(() => new LatLngBounds([0, 0], [1, 1])).not.toThrow();
    });

    it('should convert to string like Google Maps', () => {
        expect(places.hawaii.toString()).toBe(googleMaps['bounds.toString()']);
        expect(String(places.hawaii)).toBe(googleMaps['bounds.toString()']);
    });

    it('should convert to URL value like Google Maps', () => {
        expect(places.hawaii.toUrlValue()).toBe(
            googleMaps['bounds.toUrlValue()']
        );
        expect(places.hawaii.toUrlValue(3)).toBe(
            googleMaps['bounds.toUrlValue(3)']
        );
    });

    it('should be equal to itself', () => {
        expect(places.hawaii.equals(places.hawaii)).toBe(true);
        expect(places.hawaii.equals(places.bigIsland)).toBe(false);
    });

    it('should be equal to LatLngBoundsLiteral version', () => {
        expect(places.hawaii.equals(places.hawaii.toJSON())).toBe(true);
        expect(places.hawaii.equals(places.bigIsland.toJSON())).toBe(false);
    });

    it('should return true if a point is contained in the bounds', () => {
        const corner = places.oahu.getNorthEast();
        const outerCorner = places.bigIsland.getSouthWest();
        expect(places.hawaii.contains(corner)).toBe(true);
        expect(places.hawaii.contains(outerCorner)).toBe(false);
    });

    it('should return true if bounds intersect', () => {
        expect(places.hawaii.intersects(places.bigIsland)).toBe(true);
        expect(places.hawaii.intersects(places.oahu)).toBe(true);
    });

    it('should return true if empty', () => {
        expect(new LatLngBounds([0, 0], [0, 0]).isEmpty()).toBe(true);
        expect(places.hawaii.isEmpty()).toBe(false);
    });

    it('should be able to extend its bounds', () => {
        const oahu1 = new LatLngBounds(
            places.oahu.getSouthWest(),
            places.oahu.getNorthEast()
        );
        expect(oahu1.extend(places.newyork).toJSON()).toEqual(
            googleMaps['bounds.extend()']
        );
    });

    it('should be able to find the union of two bounds', () => {
        const hawaii1 = new LatLngBounds(
            places.hawaii.getSouthWest(),
            places.hawaii.getNorthEast()
        );
        const hawaii2 = new LatLngBounds(
            places.hawaii.getSouthWest(),
            places.hawaii.getNorthEast()
        );
        expect(hawaii1.union(places.oahu).toJSON()).toEqual(
            googleMaps['bounds.union(oahu)']
        );
        expect(hawaii2.union(places.bigIsland).toJSON()).toEqual(
            googleMaps['bounds.union(bigIsland)']
        );
    });
});
