class SkyWeaponBeam extends SkyWeapon
    native
    config(Game);

struct native BeamSoundImpact
{
    var() name Material;
    var() SoundCue Sound;

    structdefaultproperties
    {
        Material="None"
        Sound=none
    }
};

struct native s_CachedBeamDamage
{
    var Actor Victim;
    var int DamageAmount;
    var Controller InstigatorController;
    var Vector HitLocation;
    var Vector PushForce;
    var class<DamageType> DamageType;
    var TraceHitInfo HitInfo;
    var Actor DamageCauser;

    structdefaultproperties
    {
        Victim=none
        DamageAmount=0
        InstigatorController=none
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        PushForce=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DamageType=none
        HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none)
        DamageCauser=none
    }
};

var transient s_CachedBeamDamage CachedBeamDamage;
var(Ammo) array<float> BeamAmmoUsePerSecond;
var(Effects) array<SEffectInfo> Beam;
var(Effects) float BeamTargetRandomOffset;
var deprecated name EndPointParamName;
var deprecated name StartPointParamName;
var(Physics) array<float> MomentumTransfer;
var(Sounds) bool bProjectLoopingFirePositionAlongBeam;
var transient bool bUseLastSpread;
var(Sounds) array<BeamSoundImpact> LoopingImpactSounds;
var deprecated array<float> MinimumDamage;
var(Weapon) float ValidFiringAngle;
var transient float SavedDamage;
var transient float SavedAmmoUse;
var transient float PartialAmmo;
var transient Actor Victim;
var transient SkyWeaponBeamLight BeamLight;
var transient SkyEmitter BeamEndpointEffect;
var transient Rotator LastSpread;
var transient float ValidFiringAngleCos;
var export editinline transient AudioComponent LoopingSoundAC;
var transient int CurrLOD;
var transient float CurrentFireDuration;
var transient Rotator CachedSweepOffsetStart;
var transient Vector CachedSweepOffsetDelta;
var(Weapon) array<float> SweepDuration;
var(Weapon) array<float> SweepRadius;
var(Weapon) array<float> SweepMinDistance;
var(Weapon) array<float> SweepChangeMinTime;
var(Weapon) array<float> SweepChangeMaxTime;
var deprecated array<float> CoolDownTime;

// Export USkyWeaponBeam::execUpdateBeamAudioPosition(FFrame&, void* const)
native function UpdateBeamAudioPosition(Vector Start, Vector End);

// Export USkyWeaponBeam::execGetCurrentBeamLOD(FFrame&, void* const)
native function int GetCurrentBeamLOD();

simulated function PostBeginPlay()
{
    ValidFiringAngleCos = Cos((ValidFiringAngle / 180.0000000) * 3.1415930);
    super.PostBeginPlay();
    //return;    
}

simulated function StartFire(byte FireModeNum)
{
    local float ChargeTime;

    // End:0xAA
    if(SkyPawn_Archon(Owner) != none)
    {
        SkyBotArchon(SkyPawn_Archon(Owner).Controller).CachedAimLocation = SkyBotArchon(SkyPawn_Archon(Owner).Controller).GetFireTarget().Location;
        InitSweep(VSize(SkyBotArchon(SkyPawn_Archon(Owner).Controller).CachedAimLocation - Owner.Location));        
    }
    else
    {
        InitSweep(WeaponRange);
        // End:0x16E
        if((SweepChangeMinTime[int(CurrentFireMode)] <= SweepChangeMaxTime[int(CurrentFireMode)]) && SweepChangeMaxTime[int(CurrentFireMode)] > 0.0000000)
        {
            // End:0x12E
            if((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length)
            {
                ChargeTime = ChargeUpParams[CurrChargeUpStage].Duration;                
            }
            else
            {
                ChargeTime = 0.0000000;
            }
            SetTimer(ChargeTime + RandRange(SweepChangeMinTime[int(CurrentFireMode)], SweepChangeMaxTime[int(CurrentFireMode)]), false, 'ReInitSweep');
        }
    }
    super(Weapon).StartFire(FireModeNum);
    //return;    
}

function ReInitSweep()
{
    InitSweep(WeaponRange, true);
    // End:0x76
    if((SweepChangeMinTime[int(CurrentFireMode)] <= SweepChangeMaxTime[int(CurrentFireMode)]) && SweepChangeMaxTime[int(CurrentFireMode)] > 0.0000000)
    {
        SetTimer(RandRange(SweepChangeMinTime[int(CurrentFireMode)], SweepChangeMaxTime[int(CurrentFireMode)]), false, 'ReInitSweep');
    }
    //return;    
}

function Rotator GetAimDirAsRotator()
{
    local Rotator Result;

    FindEmitterSocketLoc(Beam[CurrLOD].Socket, Result);
    return Result;
    //return ReturnValue;    
}

// Export USkyWeaponBeam::execGetSweepOffset(FFrame&, void* const)
native simulated function Rotator GetSweepOffset();

simulated function InitSweep(float Distance, optional bool bUseCurrentOffset = false)
{
    local float ang, tempSin, tempCos, theta;

    // End:0x45
    if(Distance < SweepMinDistance[int(CurrentFireMode)])
    {
        CachedSweepOffsetDelta = vect(0.0000000, 0.0000000, 0.0000000);
        CachedSweepOffsetStart = rot(0, 0, 0);        
    }
    else
    {
        // End:0x8A
        if(Distance > float(0))
        {
            theta = (Asin(SweepRadius[int(CurrentFireMode)] / Distance) * 65536.0000000) / (2.0000000 * 3.1415930);            
        }
        else
        {
            theta = 0.0000000;
        }
        ang = RandRange(0.0000000, 6.2820000);
        // End:0xC4
        if(bUseCurrentOffset)
        {
            CachedSweepOffsetStart = GetSweepOffset();
        }
        tempCos = Cos(ang) * theta;
        tempSin = Sin(ang) * theta;
        // End:0x164
        if(!bUseCurrentOffset)
        {
            CachedSweepOffsetStart.Yaw = int(tempCos);
            CachedSweepOffsetStart.Pitch = int(tempSin);
            CachedSweepOffsetDelta.X = -2.0000000 * tempCos;
            CachedSweepOffsetDelta.Y = -2.0000000 * tempSin;            
        }
        else
        {
            CachedSweepOffsetDelta.X = tempCos - float(CachedSweepOffsetStart.Yaw);
            CachedSweepOffsetDelta.Y = tempSin - float(CachedSweepOffsetStart.Pitch);
        }
    }
    CurrentFireDuration = 0.0000000;
    //return;    
}

simulated event WeaponEmpty()
{
    super.WeaponEmpty();
    DisableWeapon();
    //return;    
}

// Export USkyWeaponBeam::execUpdateBeam(FFrame&, void* const)
native simulated function UpdateBeam(float DeltaTime);

// Export USkyWeaponBeam::execUpdateBeamAudio(FFrame&, void* const)
native simulated function UpdateBeamAudio(out ImpactInfo Impact, bool bFiring, optional Vector Start, optional Vector End);

// Export USkyWeaponBeam::execUpdateBeamEmitter(FFrame&, void* const)
native simulated function UpdateBeamEmitter(Vector EndLoc, Vector HitNormal);

// Export USkyWeaponBeam::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

simulated event Destroyed()
{
    super(SkyWeaponBase).Destroyed();
    // End:0x1E
    if(BeamLight != none)
    {
        BeamLight.Destroy();
    }
    KillEndpointEffect();
    //return;    
}

// Export USkyWeaponBeam::execSetBeamHidden(FFrame&, void* const)
native simulated function SetBeamHidden(bool bHide);

// Export USkyWeaponBeam::execKillEndpointEffect(FFrame&, void* const)
native simulated function KillEndpointEffect();

// Export USkyWeaponBeam::execConsumeBeamAmmo(FFrame&, void* const)
native function ConsumeBeamAmmo(float Amount);

function bool CanAttack(Actor Other)
{
    // End:0x0F
    if(IsFiring())
    {
        return false;
    }
    return super.CanAttack(Other);
    //return ReturnValue;    
}

// Export USkyWeaponBeam::execProcessBeamHits(FFrame&, void* const)
native simulated function ProcessBeamHits(Vector StartTrace, Vector AimDir, out ImpactInfo TestImpact, float DeltaTime);

simulated function DisableWeapon()
{
    super(SkyWeaponBase).DisableWeapon();
    global.EndFire(CurrentFireMode);
    bDisabled = true;
    SetBeamHidden(true);
    bIsFiring = false;
    // End:0x48
    if(BeamLight != none)
    {
        BeamLight.Destroy();
    }
    Victim = none;
    GotoState('Active');
    //return;    
}

simulated function EnableWeapon()
{
    bDisabled = false;
    SetBeamHidden(false);
    // End:0x35
    if(BeamLight == none)
    {
        BeamLight = Spawn(Class'SkyWeaponBeamLight');
    }
    //return;    
}

simulated event EndFireFromNative(byte FireModeNum)
{
    EndFire(FireModeNum);
    //return;    
}

simulated function EndFire(byte FireModeNum)
{
    bIsFiring = false;
    super.EndFire(FireModeNum);
    // End:0x2F
    if(bWeaponPutDown)
    {
        GotoState('WeaponPuttingDown');
        return;        
    }
    else
    {
        GotoState('Active');
    }
    //return;    
}

// Export USkyWeaponBeam::execAddSpread(FFrame&, void* const)
native simulated function Rotator AddSpread(Rotator BaseAim);

// Export USkyWeaponBeam::execGetAdjustedAim(FFrame&, void* const)
native simulated function Rotator GetAdjustedAim(Vector StartFireLoc);

function byte BestMode()
{
    return 0;
    //return ReturnValue;    
}

simulated function DoCachedBeamDamage()
{
    // End:0xBD
    if((CachedBeamDamage.Victim != none) && CachedBeamDamage.DamageAmount != 0)
    {
        CachedBeamDamage.Victim.TakeDamage(CachedBeamDamage.DamageAmount, CachedBeamDamage.InstigatorController, CachedBeamDamage.HitLocation, CachedBeamDamage.PushForce, CachedBeamDamage.DamageType, CachedBeamDamage.HitInfo, CachedBeamDamage.DamageCauser);
    }
    CachedBeamDamage.Victim = none;
    CachedBeamDamage.DamageAmount = 0;
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        local SkyPawn POwner;
        local SEffectInfo CurrBeam;

        CurrLOD = GetCurrentBeamLOD();
        POwner = SkyPawn(Instigator);
        bUseLastSpread = false;
        // End:0x58
        if(UseLoopingFireSound())
        {
            LoopingWeaponFire[int(CurrentFireMode)].Component.Play();
        }
        // End:0x6E
        if(SkyWeap_ArchonBeam(self) == none)
        {
            RefireCheckTimer();
        }
        TimeWeaponFiring(CurrentFireMode);
        // End:0xBA
        if(POwner != none)
        {
            CurrBeam = Beam[CurrLOD];
            AddEmitter(CurrBeam);
            Beam[CurrLOD] = CurrBeam;
        }
        // End:0x122
        if(((PlayerController(Instigator.Controller) != none) && Instigator.IsLocallyControlled()) && (BeamLight == none) || BeamLight.bDeleteMe)
        {
            BeamLight = Spawn(Class'SkyWeaponBeamLight');
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        // End:0x0F
        if(ShouldRefire())
        {
            return;
        }
        //return;        
    }

    function SetFlashLocation(Vector HitLocation)
    {
        global.SetFlashLocation(HitLocation);
        SetCurrentFireMode(CurrentFireMode);
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        // End:0x1B
        if(!HasAnyAmmo())
        {
            WeaponEmpty();
            return;
        }
        UpdateBeam(DeltaTime);
        //return;        
    }

    simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
    {
        CauseMuzzleFlash();
        //return;        
    }

    simulated function bool TryPutDown()
    {
        bWeaponPutDown = true;
        return false;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        local ImpactInfo Impact;

        Impact.HitInfo.PhysMaterial = none;
        bUseLastSpread = true;
        ClearTimer('RefireCheckTimer');
        ClearFlashLocation();
        super.EndState(NextStateName);
        SetBeamHidden(true);
        UpdateBeamAudio(Impact, false);
        bIsFiring = false;
        // End:0x87
        if(BeamLight != none)
        {
            BeamLight.Destroy();
        }
        Victim = none;
        //return;        
    }
    stop;    
}
