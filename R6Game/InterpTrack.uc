class InterpTrack extends Object
    abstract
    native
    collapsecategories
    noexport
    hidecategories(Object);

var private native noexport Pointer CurveEdVTable;
var class<InterpTrackInst> TrackInstClass;
var string TrackTitle;
var bool bOnePerGroup;
var bool bDirGroupOnly;

defaultproperties
{
    TrackInstClass=Class'InterpTrackInst'
    TrackTitle="Track"
}