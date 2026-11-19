class TurokLurkerSurface extends Actor
    native
    placeable
    hidecategories(Navigation);

enum ELurkerSurface
{
    ELKRS_FLAT,                     // 0
    ELKRS_TREE,                     // 1
    ELKRS_ROUND,                    // 2
    ELKRS_MAX                       // 3
};

var(lurkerSurface) byte mLurkerSurfaceType;
var @NULL mLurkerVolume;
var @NULL mLurker;
var @NULL mEntryNode;
var @NULL mPreparationNode;
var float mMaxFlatJumpAngleDEG;
var float mMaxTreeJumpAngleDEG;
var float mFlatCubeSize;
var float mTreeCubeSize;
var bool mInUse;
var bool mUnreachable;
var private editoronly export editinline @NULL mSurfaceMesh;

// Export UTurokLurkerSurface::execSetLurker(FFrame&, void* const)
native function int SetLurker(@NULL Lurker);

// Export UTurokLurkerSurface::execClearLurker(FFrame&, void* const)
native function int ClearLurker(@NULL Lurker);

// Export UTurokLurkerSurface::execIsMySurface(FFrame&, void* const)
native function bool IsMySurface(@NULL Lurker);

defaultproperties
{
    mMaxFlatJumpAngleDEG=60.0000000
    mMaxTreeJumpAngleDEG=70.0000000
    mFlatCubeSize=864.0000000
    mTreeCubeSize=1100.0000000
    // Reference: StaticMeshComponent'Default__TurokLurkerSurface.surfaceMesh'
    begin object name=surfaceMesh class=Class'Engine.StaticMeshComponent'
        Rotation=(Pitch=0,Yaw=16383,Roll=0)
    end object
    mSurfaceMesh=surfaceMesh
    Components[0]=surfaceMesh
    TickGroup=3
}