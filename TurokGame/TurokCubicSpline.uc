class TurokCubicSpline extends Object
    native;

var array mX;
var array mY;
var array mY2;

// Export UTurokCubicSpline::execInitialize(FFrame&, void* const)
native function Initialize(array Points, const optional float fdfirst, const optional float fdlast);

// Export UTurokCubicSpline::execEvaluate(FFrame&, void* const)
native function float Evaluate(const float X);
