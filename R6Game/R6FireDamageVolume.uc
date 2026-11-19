class R6FireDamageVolume extends Volume
    native
    hidecategories(lighting,Object,Movement,Display);

struct SBurningPawn
{
    var R6Pawn m_pPawn;
    var float m_fTime;

    structdefaultproperties
    {
        m_pPawn=none
        m_fTime=0.0000000
    }
};

var array<SBurningPawn> m_touchingPawns;

// Export UR6FireDamageVolume::execAddTouchingActor(FFrame&, void* const)
native final function AddTouchingActor(Actor other);

// Export UR6FireDamageVolume::execRemoveTouchingActor(FFrame&, void* const)
native final function RemoveTouchingActor(Actor other);

defaultproperties
{
    bStatic=false
    TickGroup=1
}