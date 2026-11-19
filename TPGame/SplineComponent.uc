
class SplineComponent extends PrimitiveComponent
	native
	noexport
	collapsecategories
	hidecategories(Object)
	editinlinenew;

var() vector				Vert1, Vert2;
var() vector				CP1, CP2;
var() color					LineColor;
var() int					DetailLevel;
var() float					SplineLength;

// Gets the point on the spline at time(T), where (0 <= T <= 1)
native final function vector GetPositionAtTime(float Time);
// Gets the orientation at time(T), where (0 <= T <= 1)
native final function rotator GetOrientationAtTime(float Time);

// Gets the total length of the spline
native final function float GetSplineLength();

