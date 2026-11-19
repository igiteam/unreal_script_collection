class TurokActionVolume extends Volume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

enum eLookDirRestriction
{
    LOOKDIR_None,                   // 0
    LOOKDIR_Point,                  // 1
    LOOKDIR_MAX                     // 2
};

var(Multiplayer) const int mTeamIndex;
var(ActionVolume) const bool mAllowMultipleActors;
var(ActionVolume) const byte mLookDirType;
var export editinline @NULL mLookDirMarker;
var(ActionVolume) const @NULL mLookDirPoint;
var(ActionVolume) const float mMaxAllowedLookDirOffset;
var array mControllers;
var private @NULL mMyMarker;

// Export UTurokActionVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

// Export UTurokActionVolume::execIsOccupied(FFrame&, void* const)
native function bool IsOccupied();

// Export UTurokActionVolume::execRegisterController(FFrame&, void* const)
native function RegisterController(@NULL Controller);

// Export UTurokActionVolume::execDeregisterController(FFrame&, void* const)
native function DeregisterController(@NULL Controller);

// Export UTurokActionVolume::execIsValidActionController(FFrame&, void* const)
native function bool IsValidActionController(@NULL Controller);

// Export UTurokActionVolume::execGetLookDirPoint(FFrame&, void* const)
native function @NULL GetLookDirPoint();

// Export UTurokActionVolume::execIsLookingRightDirection(FFrame&, void* const)
native function bool IsLookingRightDirection(@NULL Controller);

// Export UTurokActionVolume::execIsSameTeam(FFrame&, void* const)
native function bool IsSameTeam(@NULL Controller);

event Touch(@NULL Actor, @NULL HitLocation, @NULL HitNormal)
{
    // End:0x3D
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x3D
        if(Pawn(Actor) != none)
        {
            RegisterController(Pawn(Actor).Controller);
        }
    }
    //return;    
}

event UnTouch(@NULL Actor)
{
    // End:0x3D
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x3D
        if(Pawn(Actor) != none)
        {
            DeregisterController(Pawn(Actor).Controller);
        }
    }
    //return;    
}

defaultproperties
{
    mTeamIndex=255
    mLookDirType=1
    // Reference: DrawSphereComponent'Default__TurokActionVolume.LookDirMarker'
    begin object name=LookDirMarker class=Class'Engine.DrawSphereComponent'
        SphereRadius=5.0000000
        AbsoluteScale=true
    end object
    mLookDirMarker=LookDirMarker
    mMaxAllowedLookDirOffset=15.0000000
    // Reference: BrushComponent'Default__TurokActionVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    NetPriority=1.6000000
    CollisionComponent=BrushComponent0
}