class SkyWeap_ArchonBeam extends SkyWeaponBeam
    native
    config(Game);

var(Weapon) float CriticalDamageDistance;
var(Weapon) float InstantHitDamageCritical;
var(Weapon) float ApplyImpulseIntervalMin;
var(Weapon) float ApplyImpulseIntervalMax;
var(Weapon) name NoseSocket;
var transient bool bAllowImpulse;

// Export USkyWeap_ArchonBeam::execGetCurrentBeamLOD(FFrame&, void* const)
native function int GetCurrentBeamLOD();

simulated event PostBeginPlay()
{
    SkyPawn(Owner).CurrWeaponAttachment.Mesh.SetHidden(true);
    super.PostBeginPlay();
    //return;    
}

// Export USkyWeap_ArchonBeam::execGetPhysicalFireStartLoc(FFrame&, void* const)
native simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir);

simulated function AddEmitter(out SEffectInfo EffectInfo, optional bool bAttach)
{
    local editinline SkeletalMeshComponent SkelMeshComp;

    super(SkyWeaponBase).AddEmitter(EffectInfo);
    // End:0xEA
    if(EffectInfo.Emitter != none)
    {
        EffectInfo.Emitter.SetBase(none);
        EffectInfo.Emitter.SetHardAttach(true);
        EffectInfo.Emitter.SetBase(Owner);
        // End:0xEA
        if(SkyPawn(Owner) != none)
        {
            SkelMeshComp = SkyPawn(Owner).Mesh;
            // End:0xEA
            if(SkelMeshComp != none)
            {
                SkelMeshComp.AttachComponentToSocket(EffectInfo.Emitter.ParticleSystemComponent, EffectInfo.Socket);
            }
        }
    }
    //return;    
}

// Export USkyWeap_ArchonBeam::execUpdateBeam(FFrame&, void* const)
native simulated function UpdateBeam(float DeltaTime);

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    return true;
    //return ReturnValue;    
}

// Export USkyWeap_ArchonBeam::execHasAnyAmmo(FFrame&, void* const)
native simulated event bool HasAnyAmmo();

// Export USkyWeap_ArchonBeam::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

// Export USkyWeap_ArchonBeam::execConsumeBeamAmmo(FFrame&, void* const)
native function ConsumeBeamAmmo(float Amount);

// Export USkyWeap_ArchonBeam::execReload(FFrame&, void* const)
native simulated function Reload();

// Export USkyWeap_ArchonBeam::execProcessBeamHits(FFrame&, void* const)
native simulated function ProcessBeamHits(Vector StartTrace, Vector AimDir, out ImpactInfo TestImpact, float DeltaTime);

simulated function AllowImpulse()
{
    bAllowImpulse = true;
    //return;    
}

simulated state WeaponFiring
{
    simulated function RefireCheckTimer()
    {
        EndFire(CurrentFireMode);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x36
        if(SkyPawn_Archon(Owner).NoseCannonHasBeenDestroyed())
        {
            DisableWeapon();
            GotoState('Active');
            return;
        }
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}
