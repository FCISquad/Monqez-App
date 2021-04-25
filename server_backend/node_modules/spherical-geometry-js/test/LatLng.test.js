const { LatLng, equalLatLngs, convertLatLng } = require('../');
const places = require('./data/places');
const googleMaps = require('./data/google-maps.json');

describe('LatLng', () => {
    it('should construct a point', () => {
        expect(() => new LatLng(0, 0)).not.toThrow();
    });

    it('should wrap large coordinates if specified', () => {
        const point = new LatLng(300, 300, false);
        expect(point.lat()).toBeCloseTo(90);
        expect(point.lng()).toBeCloseTo(-60);
    });

    it('should not wrap large coordinates if not specified', () => {
        const point = new LatLng(300, 300, true);
        expect(point.lat()).toBeCloseTo(300);
        expect(point.lng()).toBeCloseTo(300);
    });

    it('should convert to string like Google Maps', () => {
        expect(places.sydney.toString()).toBe(googleMaps['toString()']);
        expect(String(places.sydney)).toBe(googleMaps['toString()']);
    });

    it('should convert to URL value like Google Maps', () => {
        expect(places.sydney.toUrlValue()).toBe(googleMaps['toUrlValue()']);
        expect(places.sydney.toUrlValue(3)).toBe(googleMaps['toUrlValue(3)']);
    });

    it('should be equal to itself', () => {
        expect(places.sydney.equals(places.sydney)).toBe(true);
        expect(places.sydney.equals(places.buenosaires)).toBe(false);
    });

    it('should be equal to LatLngLiteral version', () => {
        expect(places.sydney.equals(places.sydney.toJSON())).toBe(true);
        expect(places.sydney.equals(places.buenosaires.toJSON())).toBe(false);
    });

    it('should work with Array.from', () => {
        const arr = Array.from(places.sydney);
        expect(arr[0]).toBeCloseTo(151.20689);
        expect(arr[1]).toBeCloseTo(-33.873651);
        expect(arr.length).toBe(2);
        expect(Array.isArray(arr)).toBe(true);
    });

    const points = [
        places.donostia,
        places.london,
        places.newyork,
        places.sydney,
        places.moscow,
        places.buenosaires,
    ];

    it('should alias latitude', () => {
        for (const place of points) {
            expect(place.lat()).toBe(place.y);
            expect(place.lat()).toBe(place.latitude);
            expect(place.lat()).toBe(place[1]);
        }
    });

    it('should alias longitude', () => {
        for (const place of points) {
            expect(place.lng()).toBe(place.x);
            expect(place.lng()).toBe(place[0]);
            expect(place.lng()).toBe(place.long);
            expect(place.lng()).toBe(place.lon);
            expect(place.lng()).toBe(place.longitude);
        }
    });

    it('should return an iterator', () => {
        let i = 0;
        for (const n of places.london) {
            expect(n).toEqual(places.london[i]);
            i++;
        }
        expect(i).toEqual(2);
    });
});

describe('equalLatLngs', () => {
    it('should be equal to itself', () => {
        expect(equalLatLngs(places.sydney, places.sydney)).toBe(true);
        expect(equalLatLngs(places.sydney, places.buenosaires)).toBe(false);
    });

    it('should be equal to LatLngLiteral version', () => {
        expect(equalLatLngs(places.sydney, places.sydney.toJSON())).toBe(true);
        expect(equalLatLngs(places.sydney, places.buenosaires.toJSON())).toBe(
            false
        );
    });
});

describe('covertLatLng', () => {
    it('should clone LatLngs', () => {
        const copy = convertLatLng(places.sydney);
        expect(copy).not.toBe(places.sydney);
        expect(copy.equals(places.sydney)).toBe(true);
    });

    it('should convert Google Maps LatLngs', () => {
        const fakeGoogleMapsLatLng = {
            lat() {
                return places.london.lat();
            },
            lng() {
                return places.london.lng();
            },
        };
        expect(convertLatLng(fakeGoogleMapsLatLng)).toEqual(places.london);
    });

    it('should convert Google Maps LatLngLiterals', () => {
        const fakeGoogleMapsLatLng = {
            lat: places.london.lat(),
            lng: places.london.lng(),
        };
        expect(convertLatLng(fakeGoogleMapsLatLng)).toEqual(places.london);
    });

    it('should convert GTFS objects', () => {
        const gtfsStopPoint = {
            lat: places.newyork.lat(),
            lon: places.newyork.lng(),
        };
        expect(convertLatLng(gtfsStopPoint)).toEqual(places.newyork);
    });

    it('should convert Javascript Coordinates from Geolocation API', () => {
        class Coordinates {
            /**
             *
             * @param {number} latitude
             * @param {number} longitude
             */
            constructor(latitude, longitude) {
                this._la = latitude;
                this._lo = longitude;
            }

            get latitude() {
                return this._la;
            }

            get longitude() {
                return this._lo;
            }
        }

        const coords = new Coordinates(
            places.newyork.lat(),
            places.newyork.lng()
        );
        expect(convertLatLng(coords)).toEqual(places.newyork);
    });

    it('should convert GeoJSON', () => {
        /** @type {[number, number]} */
        const geoJson = [places.newyork.lng(), places.newyork.lat()];
        expect(convertLatLng(geoJson)).toEqual(places.newyork);
    });

    it("should convert GeoJSON that's sort of an array", () => {
        const geoJson = {
            0: places.newyork.lng(),
            1: places.newyork.lat(),
        };
        expect(convertLatLng(geoJson)).toEqual(places.newyork);
    });

    it('should convert objects with x and y', () => {
        const place = {
            x: places.newyork.lng(),
            y: places.newyork.lat(),
        };
        expect(convertLatLng(place)).toEqual(places.newyork);
    });

    it('should not convert other objects', () => {
        /** @type {any} */
        const notPlace = {
            foo: 10,
            bar: 12,
        };
        expect(() => convertLatLng(notPlace)).toThrow(TypeError);
    });
});
