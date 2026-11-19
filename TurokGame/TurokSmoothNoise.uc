class TurokSmoothNoise extends Component
    native
    hidecategories(Object);

var() float mMax;
var() float mMin;
var() int mNumSamplePoints;
var() float mStart;
var() float mEnd;
var private @NULL NoiseCurve;

// Export UTurokSmoothNoise::execValueAt(FFrame&, void* const)
native function float ValueAt(float val);

// Export UTurokSmoothNoise::execBuildCurve(FFrame&, void* const)
native function BuildCurve();

defaultproperties
{
    mMax=1.0000000
    mNumSamplePoints=5
    mEnd=1.0000000
}