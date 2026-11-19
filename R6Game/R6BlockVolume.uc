class R6BlockVolume extends Actor
    native
    notplaceable
    hidecategories(lighting);

var Pawn m_pOwner;
var export editinline BoxComponent m_pBoxComponent;
var Vector m_vSize;
var array<R6InteractiveDoorRotating> m_aTouchingDoors;
var array<R6Pawn> m_aTouchingPawns;
var array<R6Pawn> m_aExceptionList;
var bool m_bIsLocked;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_pOwner, m_vSize;
}

// Export UR6BlockVolume::execDisableVolume(FFrame&, void* const)
native final function DisableVolume();

defaultproperties
{
    // Reference: BoxComponent'Default__R6BlockVolume.CollisionBox'
    begin object name="CollisionBox" class=Class'BoxComponent'
    end object
    m_pBoxComponent=CollisionBox
    bUpdateSimulatedPosition=true
    bBlockActors=true
    bNoSelect=true
    // Reference: SpriteComponent'Default__R6BlockVolume.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=CollisionBox
    RemoteRole=1
    m_eExplosionCollisionOverride=2
    TickGroup=1
    CollisionComponent=CollisionBox
}