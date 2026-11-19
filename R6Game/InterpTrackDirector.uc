class InterpTrackDirector extends InterpTrack
    native
    collapsecategories
    hidecategories(Object);

struct DirectorTrackCut
{
    var float Time;
    var float TransitionTime;
    var() name TargetCamGroup;

    structdefaultproperties
    {
        Time=0.0000000
        TransitionTime=0.0000000
        TargetCamGroup="None"
    }
};

var array<DirectorTrackCut> CutTrack;

defaultproperties
{
    TrackInstClass=Class'InterpTrackInstDirector'
    TrackTitle="Director"
    bOnePerGroup=true
    bDirGroupOnly=true
}