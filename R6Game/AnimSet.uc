class AnimSet extends Object
    native
    hidecategories(Object);

struct AnimSetMeshLinkup
{
    var SkeletalMesh SkelMesh;
    var array<int> BoneToTrackTable;

    structdefaultproperties
    {
        SkelMesh=none
        BoneToTrackTable=none
    }
};

var() bool bAnimRotationOnly;
var const bool m_bAnimRotationOnlyUpdated;
var array<name> TrackBoneNames;
var array<AnimSequence> Sequences;
var transient array<AnimSetMeshLinkup> LinkupCache;
var() /*0x08000000-0x00000000*/ array</*0x08000000-0x00000000*/ name> UseTranslationBoneNames;
var name PreviewSkelMeshName;
var() byte m_DefaultFPS;

defaultproperties
{
    m_DefaultFPS=15
}