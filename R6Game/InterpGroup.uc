class InterpGroup extends Object
    native
    collapsecategories
    hidecategories(Object);

struct InterpEdSelKey
{
    var InterpGroup Group;
    var int TrackIndex;
    var int KeyIndex;
    var float UnsnappedPosition;

    structdefaultproperties
    {
        Group=none
        TrackIndex=0
        KeyIndex=0
        UnsnappedPosition=0.0000000
    }
};

var export array<export InterpTrack> InterpTracks;
var name GroupName;
var() Color GroupColor;
var bool bCollapsed;

defaultproperties
{
    GroupName="InterpGroup"
    GroupColor=(R=100,G=80,B=200,A=255)
}