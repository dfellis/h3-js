# h3-js

[![Build Status](https://travis-ci.org/uber/h3-js.svg?branch=master)](https://travis-ci.org/uber/h3-js) [![Coverage Status](https://coveralls.io/repos/github/uber/h3-js/badge.svg?branch=master)](https://coveralls.io/github/uber/h3-js?branch=master)

The `h3-js` library provides a pure-JavaScript version of the [H3 Core Library](https://github.com/uber/h3), a hexagon-based geographic grid system. It can be used either in Node >= 4 or in the browser. The core library is transpiled from C using [emscripten](http://kripken.github.io/emscripten-site), offering full parity with the C API and highly efficient operations.

For more information on H3 and for the full API documentation, please see the [H3 Documentation](https://uber.github.io/h3/).

-   Post **bug reports or feature requests** to the [Github Issues page](https://github.com/uber/h3-js/issues)
-   Ask **questions** by posting to the [H3 tag on StackOverflow](https://stackoverflow.com/questions/tagged/h3)

## Install

    npm install h3-js

## Usage

The library uses CommonJS modules. It can run natively in Node, but will require a bundler like Browserify or Webpack for use in the browser.

### Core functions

```
const h3 = require("h3-js");

// Convert a lat/lng point to a hexagon index at resolution 7
const h3Index = h3.geoToH3(37.3615593, -122.0553238, 7);
// -> '87283472bffffff'

// Get the center of the hexagon
const hexCenterCoordinates = h3.h3ToGeo(h3Index);
// -> [37.35171820183272, -122.05032565263946]

// Get the vertices of the hexagon
const hexBoundary = h3.h3ToGeoBoundary(h3Index);
// -> [ [37.341099093235684, -122.04156135164334 ], ...]
```

### Useful algorithms

```
// Get all neighbors within 1 step of the hexagon
const kRing = h3.kRing(h3Index, 1);
// -> ['87283472bffffff', '87283472affffff', ...]

// Get the set of hexagons within a polygon
const polygon = [
    [37.813318999983238, -122.4089866999972145],
    [37.7198061999978478, -122.3544736999993603],
    [37.8151571999998453, -122.4798767000009008]
];
const hexagons = h3.polyfill(polygon, 7);
// -> ['872830828ffffff', '87283082effffff', ...]

// Get the outline of a set of hexagons, as a GeoJSON-style MultiPolygon
const coordinates = h3.h3SetToMultiPolygon(hexagons, true);
// -> [[[
//      [-122.37681938644465, 37.76546768434345],
//      [-122.3856345540363,37.776004200673846],
//      ...
//    ]]]
```

## API Reference

<a name="h3IsValid"></a>

## h3IsValid(h3Index) ⇒ <code>Boolean</code>
Whether a given string represents a valid H3 index

**Returns**: <code>Boolean</code> - Whether the index is valid  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index to check |


* * *

<a name="h3IsPentagon"></a>

## h3IsPentagon(h3Index) ⇒ <code>Boolean</code>
Whether the given H3 index is a pentagon

**Returns**: <code>Boolean</code> - isPentagon  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index to check |


* * *

<a name="h3IsResClassIII"></a>

## h3IsResClassIII(h3Index) ⇒ <code>Boolean</code>
Whether the given H3 index is in a Class III resolution (rotated versus
the icosahedron and subject to shape distortion adding extra points on
icosahedron edges, making them not true hexagons).

**Returns**: <code>Boolean</code> - isResClassIII  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index to check |


* * *

<a name="h3GetBaseCell"></a>

## h3GetBaseCell(h3Index) ⇒ <code>Number</code>
Get the number of the base cell for a given H3 index

**Returns**: <code>Number</code> - Index of the base cell (0-121)  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index to get the base cell for |


* * *

<a name="h3GetResolution"></a>

## h3GetResolution(h3Index) ⇒ <code>Integer</code>
Returns the resolution of an H3 index

**Returns**: <code>Integer</code> - The number (0-15) resolution, or -1 if invalid  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index to get resolution |


* * *

<a name="geoToH3"></a>

## geoToH3(lat, lng, res) ⇒ [<code>H3Index</code>](#H3Index)
Get the hexagon containing a lat,lon point

**Returns**: [<code>H3Index</code>](#H3Index) - H3 index  

| Param | Type | Description |
| --- | --- | --- |
| lat | <code>Number</code> | Latitude of point |
| lng | <code>Number</code> | Longtitude of point |
| res | <code>Number</code> | Resolution of hexagons to return |


* * *

<a name="h3ToGeo"></a>

## h3ToGeo(h3Index) ⇒ <code>Array.&lt;Number&gt;</code>
Get the lat,lon center of a given hexagon

**Returns**: <code>Array.&lt;Number&gt;</code> - Point as a [lat, lng] pair  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index |


* * *

<a name="h3ToGeoBoundary"></a>

## h3ToGeoBoundary(h3Index, formatAsGeoJson) ⇒ <code>Array.&lt;Array&gt;</code>
Get the vertices of a given hexagon (or pentagon), as an array of [lat, lng]
points. For pentagons and hexagons on the edge of an icosahedron face, this
function may return up to 10 vertices.

**Returns**: <code>Array.&lt;Array&gt;</code> - Array of [lat, lng] pairs  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index |
| formatAsGeoJson | <code>Boolean</code> | Whether to provide GeoJSON output: [lng, lat], closed loops |


* * *

<a name="h3ToParent"></a>

## h3ToParent(h3Index, res) ⇒ [<code>H3Index</code>](#H3Index)
Get the parent of the given hexagon at a particular resolution

**Returns**: [<code>H3Index</code>](#H3Index) - H3 index of parent, or null for invalid input  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index to get parent for |
| res | <code>Number</code> | Resolution of hexagon to return |


* * *

<a name="h3ToChildren"></a>

## h3ToChildren(h3Index, res) ⇒ [<code>Array.&lt;H3Index&gt;</code>](#H3Index)
Get the children/descendents of the given hexagon at a particular resolution

**Returns**: [<code>Array.&lt;H3Index&gt;</code>](#H3Index) - H3 indexes of children, or empty array for invalid input  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index to get children for |
| res | <code>Number</code> | Resolution of hexagons to return |


* * *

<a name="kRing"></a>

## kRing(h3Index, ringSize) ⇒ [<code>Array.&lt;H3Index&gt;</code>](#H3Index)
Get all hexagons in a k-ring around a given center. The order of the hexagons is undefined.

**Returns**: [<code>Array.&lt;H3Index&gt;</code>](#H3Index) - H3 indexes for all hexagons in ring  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index of center hexagon |
| ringSize | <code>Number</code> | Radius of k-ring |


* * *

<a name="kRingDistances"></a>

## kRingDistances(h3Index, ringSize) ⇒ <code>Array.&lt;Array.&lt;H3Index&gt;&gt;</code>
Get all hexagons in a k-ring around a given center, in an array of arrays
ordered by distance from the origin. The order of the hexagons within each ring is undefined.

**Returns**: <code>Array.&lt;Array.&lt;H3Index&gt;&gt;</code> - Array of arrays with H3 indexes for all hexagons each ring  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index of center hexagon |
| ringSize | <code>Number</code> | Radius of k-ring |


* * *

<a name="hexRing"></a>

## hexRing(h3Index, ringSize) ⇒ [<code>Array.&lt;H3Index&gt;</code>](#H3Index)
Get all hexagons in a hollow hexagonal ring centered at origin with sides of a given length.
Unlike kRing, this function will throw an error if there is a pentagon anywhere in the ring.

**Returns**: [<code>Array.&lt;H3Index&gt;</code>](#H3Index) - H3 indexes for all hexagons in ring  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index of center hexagon |
| ringSize | <code>Number</code> | Radius of ring |


* * *

<a name="polyfill"></a>

## polyfill(coordinates, res, isGeoJson) ⇒ [<code>Array.&lt;H3Index&gt;</code>](#H3Index)
Get all hexagons with centers contained in a given polygon. The polygon
is specified with GeoJson semantics as an array of loops. Each loop is
an array of [lat, lng] pairs (or [lng, lat] if isGeoJson is specified).
The first loop is the perimeter of the polygon, and subsequent loops are
expected to be holes.

**Returns**: [<code>Array.&lt;H3Index&gt;</code>](#H3Index) - H3 indexes for all hexagons in polygon  

| Param | Type | Description |
| --- | --- | --- |
| coordinates | <code>Array.&lt;Array&gt;</code> | Array of loops, or a single loop |
| res | <code>Number</code> | Resolution of hexagons to return |
| isGeoJson | <code>Boolean</code> | Whether to expect GeoJson-style [lng, lat]                                  pairs instead of [lat, lng] |


* * *

<a name="h3SetToMultiPolygon"></a>

## h3SetToMultiPolygon(h3Indexes, formatAsGeoJson) ⇒ <code>Array.&lt;Array&gt;</code>
Get the outlines of a set of H3 hexagons, returned in GeoJSON MultiPolygon
format (an array of polygons, each with an array of loops, each an array of
coordinates). Coordinates are returned as [lat, lng] pairs unless GeoJSON
is requested.

**Returns**: <code>Array.&lt;Array&gt;</code> - MultiPolygon-style output.  

| Param | Type | Description |
| --- | --- | --- |
| h3Indexes | [<code>Array.&lt;H3Index&gt;</code>](#H3Index) | H3 indexes to get outlines for |
| formatAsGeoJson | <code>Boolean</code> | Whether to provide GeoJSON output: [lng, lat], closed loops |


* * *

<a name="compact"></a>

## compact(h3Set) ⇒ <code>Array.&lt;$tring&gt;</code>
Compact a set of hexagons of the same resolution into a set of hexagons across
multiple levels that represents the same area.

**Returns**: <code>Array.&lt;$tring&gt;</code> - Compacted H3 indexes  
**Throws**:

- if there is a malformed input


| Param | Type | Description |
| --- | --- | --- |
| h3Set | [<code>Array.&lt;H3Index&gt;</code>](#H3Index) | H3 indexes to compact |


* * *

<a name="uncompact"></a>

## uncompact(compactedSet, res) ⇒ [<code>Array.&lt;H3Index&gt;</code>](#H3Index)
Uncompact a compacted set of hexagons to hexagons of the same resolution

**Returns**: [<code>Array.&lt;H3Index&gt;</code>](#H3Index) - The uncompacted H3 indexes  
**Throws**:

- if there is malformed input


| Param | Type | Description |
| --- | --- | --- |
| compactedSet | [<code>Array.&lt;H3Index&gt;</code>](#H3Index) | H3 indexes to uncompact |
| res | <code>Number</code> | The resolution to uncompact to |


* * *

<a name="h3IndexesAreNeighbors"></a>

## h3IndexesAreNeighbors(origin, destination) ⇒ <code>Boolean</code>
Whether two H3 indexes are neighbors (share an edge)

**Returns**: <code>Boolean</code> - Whether the hexagons share an edge  

| Param | Type | Description |
| --- | --- | --- |
| origin | [<code>H3Index</code>](#H3Index) | Origin hexagon index |
| destination | [<code>H3Index</code>](#H3Index) | Destination hexagon index |


* * *

<a name="getH3UnidirectionalEdge"></a>

## getH3UnidirectionalEdge(origin, destination) ⇒ [<code>H3Index</code>](#H3Index)
Get an H3 index representing a unidirectional edge for a given origin and destination

**Returns**: [<code>H3Index</code>](#H3Index) - H3 index of the edge, or null if no edge is shared  

| Param | Type | Description |
| --- | --- | --- |
| origin | [<code>H3Index</code>](#H3Index) | Origin hexagon index |
| destination | [<code>H3Index</code>](#H3Index) | Destination hexagon index |


* * *

<a name="getOriginH3IndexFromUnidirectionalEdge"></a>

## getOriginH3IndexFromUnidirectionalEdge(edgeIndex) ⇒ [<code>H3Index</code>](#H3Index)
Get the origin hexagon from an H3 index representing a unidirectional edge

**Returns**: [<code>H3Index</code>](#H3Index) - H3 index of the edge origin  

| Param | Type | Description |
| --- | --- | --- |
| edgeIndex | [<code>H3Index</code>](#H3Index) | H3 index of the edge |


* * *

<a name="getDestinationH3IndexFromUnidirectionalEdge"></a>

## getDestinationH3IndexFromUnidirectionalEdge(edgeIndex) ⇒ [<code>H3Index</code>](#H3Index)
Get the destination hexagon from an H3 index representing a unidirectional edge

**Returns**: [<code>H3Index</code>](#H3Index) - H3 index of the edge destination  

| Param | Type | Description |
| --- | --- | --- |
| edgeIndex | [<code>H3Index</code>](#H3Index) | H3 index of the edge |


* * *

<a name="h3UnidirectionalEdgeIsValid"></a>

## h3UnidirectionalEdgeIsValid(edgeIndex) ⇒ <code>Boolean</code>
Whether the input is a valid unidirectional edge

**Returns**: <code>Boolean</code> - Whether the index is valid  

| Param | Type | Description |
| --- | --- | --- |
| edgeIndex | [<code>H3Index</code>](#H3Index) | H3 index of the edge |


* * *

<a name="getH3IndexesFromUnidirectionalEdge"></a>

## getH3IndexesFromUnidirectionalEdge(edgeIndex) ⇒ [<code>Array.&lt;H3Index&gt;</code>](#H3Index)
Get the [origin, destination] pair represented by a unidirectional edge

**Returns**: [<code>Array.&lt;H3Index&gt;</code>](#H3Index) - [origin, destination] pair as H3 indexes  

| Param | Type | Description |
| --- | --- | --- |
| edgeIndex | [<code>H3Index</code>](#H3Index) | H3 index of the edge |


* * *

<a name="getH3UnidirectionalEdgesFromHexagon"></a>

## getH3UnidirectionalEdgesFromHexagon(h3Index) ⇒ [<code>Array.&lt;H3Index&gt;</code>](#H3Index)
Get all of the unidirectional edges with the given H3 index as the origin (i.e. an edge to
every neighbor)

**Returns**: [<code>Array.&lt;H3Index&gt;</code>](#H3Index) - List of unidirectional edges  

| Param | Type | Description |
| --- | --- | --- |
| h3Index | [<code>H3Index</code>](#H3Index) | H3 index of the origin hexagon |


* * *

<a name="getH3UnidirectionalEdgeBoundary"></a>

## getH3UnidirectionalEdgeBoundary(edgeIndex, formatAsGeoJson) ⇒ <code>Array.&lt;Array&gt;</code>
Get the vertices of a given edge as an array of [lat, lng] points. Note that for edges that
cross the edge of an icosahedron face, this may return 3 coordinates.

**Returns**: <code>Array.&lt;Array&gt;</code> - Array of geo coordinate pairs  

| Param | Type | Description |
| --- | --- | --- |
| edgeIndex | [<code>H3Index</code>](#H3Index) | H3 index of the edge |
| formatAsGeoJson | <code>Boolean</code> | Whether to provide GeoJSON output: [lng, lat] |


* * *

<a name="h3Distance"></a>

## h3Distance(origin, destination) ⇒ <code>Number</code>
Get the grid distance between two hex indexes. This function may fail
to find the distance between two indexes if they are very far apart or
on opposite sides of a pentagon.

**Returns**: <code>Number</code> - Distance between hexagons, or a negative
                             number if the distance could not be computed  

| Param | Type | Description |
| --- | --- | --- |
| origin | [<code>H3Index</code>](#H3Index) | Origin hexagon index |
| destination | [<code>H3Index</code>](#H3Index) | Destination hexagon index |


* * *

<a name="hexArea"></a>

## hexArea(res, unit) ⇒ <code>Number</code>
Average hexagon area at a given resolution

**Returns**: <code>Number</code> - Average area  

| Param | Type | Description |
| --- | --- | --- |
| res | <code>Number</code> | Hexagon resolution |
| unit | <code>String</code> | Area unit (either UNITS.m2 or UNITS.km2) |


* * *

<a name="edgeLength"></a>

## edgeLength(res, unit) ⇒ <code>Number</code>
Average hexagon edge length at a given resolution

**Returns**: <code>Number</code> - Average edge length  

| Param | Type | Description |
| --- | --- | --- |
| res | <code>Number</code> | Hexagon resolution |
| unit | <code>String</code> | Area unit (either UNITS.m or UNITS.km) |


* * *

<a name="numHexagons"></a>

## numHexagons(res) ⇒ <code>Number</code>
The total count of hexagons in the world at a given resolution. Note that above
resolution 8 the exact count cannot be represented in a JavaScript 32-bit number,
so consumers should use caution when applying further operations to the output.

**Returns**: <code>Number</code> - Count  

| Param | Type | Description |
| --- | --- | --- |
| res | <code>Number</code> | Hexagon resolution |


* * *

<a name="degsToRads"></a>

## degsToRads(deg) ⇒ <code>Number</code>
Convert degrees to radians

**Returns**: <code>Number</code> - Value in radians  

| Param | Type | Description |
| --- | --- | --- |
| deg | <code>Number</code> | Value in degrees |


* * *

<a name="radsToDegs"></a>

## radsToDegs(rad) ⇒ <code>Number</code>
Convert radians to degrees

**Returns**: <code>Number</code> - Value in degrees  

| Param | Type | Description |
| --- | --- | --- |
| rad | <code>Number</code> | Value in radians |


* * *

<a name="H3Index"></a>

## H3Index : <code>String</code>
A hexidecimal string uniquely identifying a H3 hexagon or H3 unidirectional edge.


* * *


## Development

The `h3-js` library uses `yarn` as the preferred package manager. To install the dev dependencies, just run:

    yarn

To lint the code:

    yarn lint

To run the tests in both native ES6 (requires Node >= 6) and transpiled ES5:

    yarn test

### Benchmarks

The `h3-js` library includes a basic benchmark suite using [Benchmark.js](https://benchmarkjs.com/). Because many of the functions may be called over thousands of hexagons in a "hot loop", performance is an important concern. Benchmarks are run against the transpiled ES5 code by default. To run the benchmarks:

    yarn run benchmarks

Sample output (Macbook Pro running Node 6):

```
h3IsValid x 3,725,046 ops/sec ±0.47% (90 runs sampled)
geoToH3 x 227,458 ops/sec ±0.84% (89 runs sampled)
h3ToGeo x 843,167 ops/sec ±0.96% (87 runs sampled)
h3ToGeoBoundary x 220,797 ops/sec ±2.56% (86 runs sampled)
kRing x 144,955 ops/sec ±3.06% (85 runs sampled)
polyfill x 9,291 ops/sec ±1.12% (88 runs sampled)
h3SetToMultiPolygon x 311 ops/sec ±1.56% (82 runs sampled)
compact x 1,336 ops/sec ±4.51% (86 runs sampled)
uncompact x 574 ops/sec ±0.91% (85 runs sampled)
h3IndexesAreNeighbors x 670,031 ops/sec ±1.36% (88 runs sampled)
getH3UnidirectionalEdge x 356,089 ops/sec ±1.17% (85 runs sampled)
getOriginH3IndexFromUnidirectionalEdge x 1,052,652 ops/sec ±0.54% (89 runs sampled)
getDestinationH3IndexFromUnidirectionalEdge x 891,680 ops/sec ±0.90% (91 runs sampled)
h3UnidirectionalEdgeIsValid x 3,551,111 ops/sec ±0.69% (85 runs sampled)
```

When making code changes that may affect performance, please run benchmarks against `master` and then against your branch to identify any regressions.

### Transpiling the C Source

The core library is transpiled using [emscripten](http://kripken.github.io/emscripten-site). The easiest way to build from source locally is by using Docker. Make sure Docker is installed, then:

    yarn init-docker
    yarn run build-emscripten

The build script uses the `H3_VERSION` file to determine the version of the core library to build.

NOTE: The current `h3-js` is built with `emscripten-1.37.40`. Earlier or later versions MAY NOT WORK (emscripten does not follow semver, so patch updates may include breaking changes).

## Contributing

Pull requests and [Github issues](https://github.com/uber/h3-js/issues) are welcome. Please include tests for new work, and keep the library test coverage at 100%. Please note that the purpose of this module is to expose the API of the [H3 Core library](https://github.com/uber/h3), so we will rarely accept new features that are not part of that API. New proposed feature work is more appropriate in the core C library or in a new JS library that depends on `h3-js`.

Before we can merge your changes, you must agree to the [Uber Contributor License Agreement](http://cla-assistant.io/uber/h3-js).

## Versioning

The [H3 core library](https://github.com/uber/h3) adheres to [Semantic Versioning](http://semver.org/). The `h3-js` library has a `major.minor.patch` version scheme. The major and minor version numbers of `h3-js` are the major and minor version of the bound core library, respectively. The patch version is incremented independently of the core library.

## Legal and Licensing

The `h3-js` library is licensed under the [Apache 2.0 License](https://github.com/uber/h3-js/blob/master/LICENSE).

DGGRID Copyright (c) 2015 Southern Oregon University
