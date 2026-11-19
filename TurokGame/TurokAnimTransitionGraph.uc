class TurokAnimTransitionGraph extends Object
    native
    hidecategories(Object);

enum GraphCollisionFlags
{
    GCF_CHECK_ALL,                  // 0
    GCF_IGNORE_PRIMARY,             // 1
    GCF_IGNORE_SECONDARY,           // 2
    GCF_IGNORE_BOTH,                // 3
    GCF_MAX                         // 4
};

struct native GraphActiveInfo
{
    var byte mType;
    var bool mbIsActive;

    structdefaultproperties
    {
        mType=0
        mbIsActive=false
    }
};

var name mName;
var array mGraphItems;
var int mDefaultViewX;
var int mDefaultViewY;
var float mDefaultViewZoom;
var @NULL mDefaultTarget;
var float mDefaultPrevPreviewTime;
var float mDefaultNextPreviewTime;
var(Tags) editinline array mTags;
var array mActiveActors;
var transient int mTimesPlayed;
var transient float mLastTimePlayed;
var private array mbIsCooked;
var private array mbIsRootMotionValid;
var private array mbIsContactPointValid;
var private array mbIsSpatialValid;
var private array mDuration;
var private array mRootMotion;
var private array mContactPoint;
var private float mContactRadius;
var private float mBlendInTime;
var private float mAngleOffset;
var private byte mBlendCurveType;
var private float mYawExtentsLeft;
var private float mYawExtentsRight;
var private @NULL mStartingLocoParams;
var private @NULL mEndingLocoParams;
var private bool mbIsReplicateable;

// Export UTurokAnimTransitionGraph::execGetPreviewDuration(FFrame&, void* const)
native function float GetPreviewDuration(@NULL MeshComp, byte actorType);

// Export UTurokAnimTransitionGraph::execIsReplicateable(FFrame&, void* const)
native function bool IsReplicateable();

// Export UTurokAnimTransitionGraph::execGetBlendInTime(FFrame&, void* const)
native function float GetBlendInTime(byte actorType);

// Export UTurokAnimTransitionGraph::execGetAngleOffset(FFrame&, void* const)
native function float GetAngleOffset();

// Export UTurokAnimTransitionGraph::execGetBlendCurveType(FFrame&, void* const)
native function byte GetBlendCurveType();

// Export UTurokAnimTransitionGraph::execGetSpatialYawExtents(FFrame&, void* const)
native function bool GetSpatialYawExtents(@NULL MeshComp, out float leftExtent, out float rightExtent);

// Export UTurokAnimTransitionGraph::execGetStartingLocoParams(FFrame&, void* const)
native function GetStartingLocoParams(out float relMoveAngle, out float Speed, out float Phase);

// Export UTurokAnimTransitionGraph::execGetEndingLocoParams(FFrame&, void* const)
native function bool GetEndingLocoParams(out float relMoveAngle, out float Speed, out float Phase);

// Export UTurokAnimTransitionGraph::execGetWorldRootMotionEndPoint(FFrame&, void* const)
native function bool GetWorldRootMotionEndPoint(@NULL MeshComp, out @NULL pos, out @NULL Rotation, byte actorType);

// Export UTurokAnimTransitionGraph::execGetCharacterRootMotionEndPoint(FFrame&, void* const)
native function bool GetCharacterRootMotionEndPoint(@NULL MeshComp, out @NULL pos, out @NULL Rotation, byte actorType);

// Export UTurokAnimTransitionGraph::execGetWorldCannedContactPoint(FFrame&, void* const)
native function bool GetWorldCannedContactPoint(@NULL MeshComp, out @NULL pos, out @NULL Rotation, out float Radius, byte actorType);

// Export UTurokAnimTransitionGraph::execGetCharacterCannedContactPoint(FFrame&, void* const)
native function bool GetCharacterCannedContactPoint(@NULL MeshComp, out @NULL pos, out @NULL Rotation, out float Radius, byte actorType);

// Export UTurokAnimTransitionGraph::execGetWorldSpatialContactPoint(FFrame&, void* const)
native function bool GetWorldSpatialContactPoint(@NULL MeshComp, @NULL Target, out @NULL pos, out @NULL Rotation, out float Radius);

// Export UTurokAnimTransitionGraph::execGetCharacterSpatialContactPoint(FFrame&, void* const)
native function bool GetCharacterSpatialContactPoint(@NULL MeshComp, @NULL Target, out @NULL pos, out @NULL Rotation, out float Radius);

// Export UTurokAnimTransitionGraph::execGetWorldBone(FFrame&, void* const)
native function bool GetWorldBone(@NULL MeshComp, out @NULL pos, out @NULL Rot, name bone, float Time, byte actorType);

// Export UTurokAnimTransitionGraph::execGetCharacterBone(FFrame&, void* const)
native function bool GetCharacterBone(@NULL MeshComp, out @NULL pos, out @NULL Rot, name bone, float Time, byte actorType);

// Export UTurokAnimTransitionGraph::execGetComponentBone(FFrame&, void* const)
native function bool GetComponentBone(@NULL MeshComp, out @NULL pos, out @NULL Rot, name bone, float Time, byte actorType);

// Export UTurokAnimTransitionGraph::execFindTagByType(FFrame&, void* const)
native function @NULL FindTagByType(class<Class> Type);

// Export UTurokAnimTransitionGraph::execHasTag(FFrame&, void* const)
native function bool HasTag(class<Class> Type);

// Export UTurokAnimTransitionGraph::execTags(FFrame&, void* const)
native final iterator function Tags(class<Class> Type, out @NULL Tag);

// Export UTurokAnimTransitionGraph::execCollisionOK(FFrame&, void* const)
native function bool CollisionOK(@NULL primary, @NULL secondary, array endGraphs, byte checkCollisionFlags);

defaultproperties
{
    mDefaultViewZoom=1.0000000
    mDefaultPrevPreviewTime=2.0000000
    mDefaultNextPreviewTime=2.0000000
    mActiveActors=/* Array type was not detected. */
}