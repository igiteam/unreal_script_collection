class PhysicsVolume extends Volume
    native
    nativereplication
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

var() interp Vector ZoneVelocity;
var() float GroundFriction;
var() float TerminalVelocity;
var() float DamagePerSec;
var() class<DamageType> DamageType;
var() int Priority;
var() float FluidFriction;
var() bool bPainCausing;
var bool BACKUP_bPainCausing;
var() bool bDestructive;
var() bool bNoInventory;
var() bool bMoveProjectiles;
var() bool bBounceVelocity;
var() bool bNeutralZone;
var() bool bPhysicsOnContact;
var bool bWaterVolume;
var() float RigidBodyDamping;
var() float MaxDampingForce;
var Info PainTimer;
var PhysicsVolume NextPhysicsVolume;
var() SoundCue m_pPhysicsEntrySound;
var() ParticleSystem m_pPhysicsEntryFX;

// Export UPhysicsVolume::execGetGravityZ(FFrame&, void* const)
native function float GetGravityZ();

simulated function PostBeginPlay()
{
    PostBeginPlay();
    BACKUP_bPainCausing = bPainCausing;
    // End:0x26
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0x54
    if(bPainCausing)
    {
        PainTimer = __NFUN_278__(Class'VolumeTimer', self);
        PainTimer.SetTickGroup(0);
    }
    return;
}

simulated function PreBeginPlay()
{
    PreBeginPlay();
    // End:0x2A
    if(bPainCausing && int(TickGroup) != int(0))
    {
        SetTickGroup(0);
    }
    return;
}

event PhysicsChangedFor(Actor other)
{
    return;
}

event ActorEnteredVolume(Actor other)
{
    return;
}

event ActorLeavingVolume(Actor other)
{
    return;
}

event PawnEnteredVolume(Pawn other)
{
    return;
}

event PawnLeavingVolume(Pawn other)
{
    return;
}

function TimerPop(VolumeTimer T)
{
    local Actor A;

    // End:0x61
    if(T == PainTimer)
    {
        // End:0x1C
        if(!bPainCausing)
        {
            return;
        }
        // End:0x60
        foreach TouchingActors(Class'Actor', A)
        {
            // End:0x5F
            if(A.bCanBeDamaged && !A.bStatic)
            {
                CausePainTo(A);
            }            
        }        
    }
    return;
}

// Export UPhysicsVolume::execCausePainTo(FFrame&, void* const)
native final function CausePainTo(Actor other);

defaultproperties
{
    GroundFriction=8.0000000
    TerminalVelocity=3500.0000000
    DamageType=Class'DamageType'
    FluidFriction=0.3000000
    MaxDampingForce=1000000.0000000
    // Reference: BrushComponent'Default__PhysicsVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: BrushComponent'Default__Volume.BrushComponent0'
    begin object name="BrushComponent0"
        BlockZeroExtent=true
    end object
    BrushComponent=BrushComponent0
    bAlwaysRelevant=true
    bOnlyDirtyReplication=true
    Components[0]=BrushComponent0
    NetUpdateFrequency=0.1000000
    CollisionComponent=BrushComponent0
}