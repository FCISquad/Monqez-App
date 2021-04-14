const { LatLng, LatLngBounds } = require('../../');

module.exports = {
    donostia: new LatLng(43.320812, -1.984447),
    london: new LatLng(51.508129, -0.128005),
    newyork: new LatLng(40.71417, -74.00639),
    sydney: new LatLng(-33.873651, 151.20689),
    moscow: new LatLng(55.7522222, 37.6155556),
    buenosaires: new LatLng(-34.608418, -58.373161),
    path: [
        new LatLng(44.394627717861205, -79.69491139054298),
        new LatLng(44.39457357555244, -79.69505790621042),
        new LatLng(44.39450050731302, -79.69500459730625),
        new LatLng(44.39456351370196, -79.6948466822505),
    ],
    bigIsland: new LatLngBounds(
        new LatLng(18.719955, -156.007002),
        new LatLng(20.297632, -154.714628)
    ),
    hawaii: new LatLngBounds(
        new LatLng(18.850912, -160.66249),
        new LatLng(22.240875, -153.791741)
    ),
    oahu: new LatLngBounds(
        new LatLng(21.235191, -158.326847),
        new LatLng(21.744683, -157.57099)
    ),
};
