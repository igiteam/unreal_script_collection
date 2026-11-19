class Weapon extends Inventory
    abstract
    native
    config(Game)
    notplaceable
    hidecategories(lighting);

enum EWeaponFireType
{
    EWFT_InstantHit,                // 0
    EWFT_Projectile,                // 1
    EWFT_Custom,                    // 2
    EWFT_None,                      // 3
    EWFT_MAX                        // 4
};

var byte CurrentFireMode;
var array<byte> ShouldFireOnRelease;
var array<Weapon.EWeaponFireType> WeaponFireTypes;
var array<name> FiringStatesArray;
var array< class<Projectile> > WeaponProjectiles;
var() array<float> FireInterval;
var() array<float> Spread;
var() array<float> InstantHitDamage;
var() array<float> InstantHitMomentum;
var array< class<DamageType> > InstantHitDamageTypes;
var() float EquipTime;
var() float PutDownTime;
var() Vector FireOffset;
var bool bWeaponPutDown;
var bool m_bFiringBullets;
var bool bCanThrow;
var bool bInstantHit;
var bool bMeleeWeapon;
var() float WeaponRange;
var() export editinline MeshComponent Mesh;
var config float Priority;
var float WarnTargetPct;
var float BotRefireRate;
var float AIRating;

replication
{
    // Pos:0x000
    if((bNetInitial || bNetDirty) && int(Role) == int(ROLE_Authority))
        CurrentFireMode;
}

// Export UWeapon::execBeginStateWeaponFiring(FFrame&, void* const)
native simulated function BeginStateWeaponFiring(name PreviousStateName);

// Export UWeapon::execEndStateWeaponFiring(FFrame&, void* const)
native simulated function EndStateWeaponFiring(name NextStateName);

// Export UWeapon::execBeginStateActive(FFrame&, void* const)
native simulated function BeginStateActive(name PreviousStateName);

simulated function PostBeginPlay()
{
    local int I;

    PostBeginPlay();
    I = 0;
    J0x0E:

    // End:0x4D [Loop If]
    if(I < WeaponFireTypes.Length)
    {
        bInstantHit = bInstantHit || int(WeaponFireTypes[I]) == int(0);
        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    return;
}

simulated event Destroyed()
{
    Destroyed();
    return;
}

function HolderDied()
{
    ServerStopFire(CurrentFireMode);
    return;
}

simulated function bool DoOverrideNextWeapon()
{
    return false;
    return;
}

simulated function bool DoOverridePrevWeapon()
{
    return false;
    return;
}

reliable client simulated event ClientWeaponThrown()
{
    // End:0x12
    if(int(Role) == int(ROLE_Authority))
    {
        return;
    }
    DetachWeapon();
    GotoState('Inactive');
    return;
}

// Export UWeapon::execIsFiring(FFrame&, void* const)
native simulated function bool IsFiring();

simulated function bool DenyClientWeaponSet()
{
    return false;
    return;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local array<string> DebugInfo;
    local int I;

    GetWeaponDebug(DebugInfo);
    HUD.Canvas.SetDrawColor(0, byte(255), 0);
    I = 0;
    J0x34:

    // End:0xA3 [Loop If]
    if(I < DebugInfo.Length)
    {
        HUD.Canvas.__NFUN_465__("  " @ DebugInfo[I]);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0000000, out_YPos);
        I++;
        // [Loop Continue]
        goto J0x34;
    }
    return;
}

simulated function GetWeaponDebug(out array<string> DebugInfo)
{
    local string T;
    local int I;

    DebugInfo[DebugInfo.Length] = (((((("Weapon:" $ (GetItemName(string(self)))) @ "State:") $ string(GetStateName())) @ "Instigator:") $ string(Instigator)) @ "Owner:") $ string(Owner);
    DebugInfo[DebugInfo.Length] = (((("IsFiring():" $ string(IsFiring())) @ "CurrentFireMode:") $ string(CurrentFireMode)) @ "bWeaponPutDown:") $ string(bWeaponPutDown);
    DebugInfo[DebugInfo.Length] = (((("ShotCount:" $ string(Instigator.ShotCount)) @ "FlashCount:") $ string(Instigator.FlashCount)) @ "FlashLocation:") $ string(Instigator.FlashLocation);
    T = "PendingFires:";
    I = 0;
    J0x149:

    // End:0x18C [Loop If]
    if(I < InvManager.PendingFire.Length)
    {
        T = (T $ string(PendingFire(I))) $ " ";
        I++;
        // [Loop Continue]
        goto J0x149;
    }
    DebugInfo[DebugInfo.Length] = T;
    // End:0x24E
    if(Timers.Length > 0)
    {
        I = 0;
        J0x1B1:

        // End:0x24E [Loop If]
        if(I < Timers.Length)
        {
            DebugInfo[DebugInfo.Length] = (((("Timer" @ string(Timers[I].FuncName)) @ string(Timers[I].Count)) @ string(Timers[I].Rate)) @ string(int((Timers[I].Count / Timers[I].Rate) * float(100)))) $ "%";
            I++;
            // [Loop Continue]
            goto J0x1B1;
        }
    }
    return;
}

simulated function DumpWeaponDebugToLog()
{
    return;
}

simulated function WeaponLog(coerce string Msg, coerce string FuncStr)
{
    return;
}

// Export UWeapon::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

function int AddAmmo(int Amount)
{
    return;
}

// Export UWeapon::execHasAmmo(FFrame&, void* const)
native simulated function bool HasAmmo(byte FireModeNum, optional int Amount);

// Export UWeapon::execHasAnyAmmo(FFrame&, void* const)
native simulated function bool HasAnyAmmo();

// Export UWeapon::execPendingFire(FFrame&, void* const)
native simulated function bool PendingFire(int FireMode);

// Export UWeapon::execSetPendingFire(FFrame&, void* const)
native final simulated function SetPendingFire(int FireMode);

// Export UWeapon::execClearPendingFire(FFrame&, void* const)
native final simulated function ClearPendingFire(int FireMode);

function class<Projectile> GetProjectileClass()
{
    return WeaponProjectiles[int(CurrentFireMode)];
    return;
}

simulated function Rotator AddSpread(Rotator BaseAim)
{
    local Vector X, Y, Z;
    local float CurrentSpread, RandY, RandZ;

    CurrentSpread = Spread[int(CurrentFireMode)];
    // End:0x29
    if(CurrentSpread == float(0))
    {
        return BaseAim;        
    }
    else
    {
        GetAxes(BaseAim, X, Y, Z);
        RandY = FRand() - 0.5000000;
        RandZ = Sqrt(0.5000000 - Square(RandY)) * (FRand() - 0.5000000);
        return Rotator((X + ((RandY * CurrentSpread) * Y)) + ((RandZ * CurrentSpread) * Z));
    }
    return;
}

function float MaxRange()
{
    // End:0x11
    if(bInstantHit)
    {
        return GetTraceRange();
    }
    return 5000.0000000;
    return;
}

function float GetDamageRadius()
{
    local class<Projectile> CurrentProjectileClass;

    CurrentProjectileClass = GetProjectileClass();
    // End:0x1E
    if(CurrentProjectileClass == none)
    {
        return 0.0000000;
    }
    return CurrentProjectileClass.default.DamageRadius;
    return;
}

function float GetAIRating()
{
    return AIRating;
    return;
}

simulated function float GetWeaponRating()
{
    // End:0x1D
    if(InvManager != none)
    {
        return InvManager.GetWeaponRatingFor(self);
    }
    // End:0x2F
    if(!HasAnyAmmo())
    {
        return -1.0000000;
    }
    return 1.0000000;
    return;
}

function float RefireRate()
{
    return BotRefireRate;
    return;
}

function bool RecommendRangedAttack()
{
    return false;
    return;
}

function bool FocusOnLeader(bool bLeaderFiring)
{
    return false;
    return;
}

function bool RecommendLongRangedAttack()
{
    return false;
    return;
}

function float RangedAttackTime()
{
    return 0.0000000;
    return;
}

function bool CanAttack(Actor other)
{
    return true;
    return;
}

function float SuggestAttackStyle()
{
    return 0.0000000;
    return;
}

function float SuggestDefenseStyle()
{
    return 0.0000000;
    return;
}

function bool FireOnRelease()
{
    return (ShouldFireOnRelease.Length > 0) && int(ShouldFireOnRelease[int(CurrentFireMode)]) != 0;
    return;
}

simulated function SetHidden(bool bNewHidden)
{
    // End:0x20
    if(Mesh != none)
    {
        Mesh.super(Weapon).SetHidden(bNewHidden);
    }
    return;
}

simulated function WeaponPlaySound(SoundCue Sound)
{
    // End:0x1A
    if((Sound == none) || Instigator == none)
    {
        return;
    }
    // End:0x51
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        Owner.PlaySound(Sound, 5, true, false, true);        
    }
    else
    {
        Owner.PlaySound(Sound, 5);
    }
    return;
}

// Export UWeapon::execPlayFireEffects(FFrame&, void* const)
native function PlayFireEffects(byte FireModeNum, Vector HitLocation);

// Export UWeapon::execStopFireEffects(FFrame&, void* const)
native function StopFireEffects(byte FireModeNum);

// Export UWeapon::execPlayFiringSound(FFrame&, void* const)
native simulated function PlayFiringSound();

// Export UWeapon::execGetFireInterval(FFrame&, void* const)
native function float GetFireInterval(byte FireModeNum);

// Export UWeapon::execTimeWeaponFiring(FFrame&, void* const)
native simulated function TimeWeaponFiring(byte FireModeNum);

simulated function TimeWeaponPutDown()
{
    SetTimer(((PutDownTime > float(0)) ? PutDownTime : 0.0100000), false, 'WeaponIsDown');
    return;
}

simulated function TimeWeaponEquipping()
{
    SetTimer(((EquipTime > float(0)) ? EquipTime : 0.0100000), false, 'WeaponEquipped');
    return;
}

simulated function Activate(optional bool bInstantSwitch)
{
    // End:0x17
    if(!IsFiring())
    {
        GotoState('WeaponEquipping');
    }
    return;
}

// Export UWeapon::execPutDownWeapon(FFrame&, void* const)
native simulated function PutDownWeapon();

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    // End:0x11
    if(ItemClass == Class)
    {
        return true;
    }
    return false;
    return;
}

// Export UWeapon::execIncrementFlashCount(FFrame&, void* const)
native simulated function IncrementFlashCount();

// Export UWeapon::execClearFlashCount(FFrame&, void* const)
native simulated function ClearFlashCount();

simulated event SetFlashLocation(Vector HitLocation)
{
    // End:0x26
    if(Instigator != none)
    {
        Instigator.SetFlashLocation(self, CurrentFireMode, HitLocation);
    }
    return;
}

// Export UWeapon::execClearFlashLocation(FFrame&, void* const)
native simulated function ClearFlashLocation();

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    return;
}

// Export UWeapon::execDetachWeapon(FFrame&, void* const)
native function DetachWeapon(optional bool bToBody);

simulated function GetViewAxes(out Vector XAxis, out Vector YAxis, out Vector ZAxis)
{
    local Rotator AimRot;

    AimRot = Instigator.GetBaseAimRotation();
    GetAxes(AimRot, XAxis, YAxis, ZAxis);
    return;
}

simulated function float AdjustFOVAngle(float FOVAngle)
{
    return FOVAngle;
    return;
}

simulated event ClientWeaponSet(bool bOptionalSet)
{
    // End:0x17
    if(Instigator == none)
    {
        GotoState('PendingClientWeaponSet');
        return;
    }
    // End:0x2E
    if(InvManager == none)
    {
        GotoState('PendingClientWeaponSet');
        return;
    }
    InvManager.ClientWeaponSet(self, bOptionalSet);
    return;
}

simulated function WeaponCalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot)
{
    return;
}

// Export UWeapon::execStartFire(FFrame&, void* const)
native simulated function StartFire(byte FireModeNum);

reliable server event ServerStartFire(byte FireModeNum)
{
    BeginFire(FireModeNum);
    return;
}

// Export UWeapon::execBeginFire(FFrame&, void* const)
native simulated function BeginFire(byte FireModeNum);

// Export UWeapon::execStopFire(FFrame&, void* const)
native simulated function StopFire(byte FireModeNum);

reliable server event ServerStopFire(byte FireModeNum)
{
    StopFire(FireModeNum);
    return;
}

// Export UWeapon::execEndFire(FFrame&, void* const)
native simulated function EndFire(byte FireModeNum);

simulated function ForceEndFire()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x47 [Loop If]
    if(I < InvManager.PendingFire.Length)
    {
        // End:0x3D
        if(PendingFire(I))
        {
            EndFire(byte(I));
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

// Export UWeapon::execSendToFiringState(FFrame&, void* const)
native simulated function SendToFiringState(byte FireModeNum);

// Export UWeapon::execSetCurrentFireMode(FFrame&, void* const)
native simulated function SetCurrentFireMode(byte FiringModeNum);

// Export UWeapon::execFireAmmunition(FFrame&, void* const)
native simulated function FireAmmunition();

simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
    local Rotator R;

    R = Instigator.GetAdjustedAimFor(self, StartFireLoc);
    return AddSpread(R);
    return;
}

simulated event float GetTraceRange()
{
    return WeaponRange;
    return;
}

simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList)
{
    local Vector HitLocation, HitNormal;
    local Actor HitActor;
    local TraceHitInfo HitInfo;
    local ImpactInfo CurrentImpact;

    HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo);
    // End:0x48
    if(HitActor == none)
    {
        HitLocation = EndTrace;
    }
    CurrentImpact.HitSourceLocation = Location;
    CurrentImpact.HitActor = HitActor;
    CurrentImpact.HitLocation = HitLocation;
    CurrentImpact.HitNormal = HitNormal;
    CurrentImpact.RayDir = Normal(HitLocation - StartTrace);
    CurrentImpact.HitInfo = HitInfo;
    ImpactList[ImpactList.Length] = CurrentImpact;
    // End:0x136
    if((HitActor != none) && HitActor.IsA('Trigger') || HitActor.IsA('TriggerVolume'))
    {
        HitActor.bProjTarget = true;
        CurrentImpact = CalcWeaponFire(HitLocation, EndTrace, ImpactList);
        HitActor.bProjTarget = false;
    }
    return CurrentImpact;
    return;
}

// Export UWeapon::execInstantFire(FFrame&, void* const)
native simulated function InstantFire();

simulated event ProcessInstantHit(byte FiringMode, ImpactInfo Impact)
{
    // End:0xB5
    if((Impact.HitActor != none) && int(Impact.HitActor.Role) == int(ROLE_Authority))
    {
        Impact.HitActor.TakeDamage(int(InstantHitDamage[int(FiringMode)]), int(InstantHitDamage[int(FiringMode)]), Instigator.Controller, Impact.HitSourceLocation, Impact.HitLocation, InstantHitMomentum[int(FiringMode)] * Impact.RayDir, InstantHitDamageTypes[int(FiringMode)], Impact.HitInfo);
    }
    return;
}

simulated event Vector GetPhysicalFireStartLoc()
{
    // End:0x36
    if(Instigator != none)
    {
        return Instigator.GetPawnViewLocation() + (FireOffset >> Instigator.GetViewRotation());
    }
    return Location;
    return;
}

simulated event bool TryPutDown(optional bool bInstantSwitch)
{
    bWeaponPutDown = true;
    return true;
    return;
}

simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly)
{
    return;
}

// Export UWeapon::execRefireCheckTimer(FFrame&, void* const)
native simulated function RefireCheckTimer();

// Export UWeapon::execShouldRefire(FFrame&, void* const)
native simulated function bool ShouldRefire();

// Export UWeapon::execStillFiring(FFrame&, void* const)
native simulated function bool StillFiring(byte FireMode);

auto state Inactive
{
    reliable server function ServerStartFire(byte FireModeNum)
    {
        // End:0x39
        if((Instigator != none) && Instigator.Weapon == self)
        {
            GotoState('Active');
            global.ServerStartFire(FireModeNum);            
        }
        else
        {
            // End:0x67
            if((InvManager != none) && InvManager.PendingWeapon == self)
            {
                SetPendingFire(int(FireModeNum));
            }
        }
        return;
    }

    reliable server event ServerStopFire(byte FireModeNum)
    {
        ClearPendingFire(int(FireModeNum));
        return;
    }

    simulated function bool TryPutDown(optional bool bInstantSwitch)
    {
        return false;
        return;
    }
    stop;
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        BeginStateActive(PreviousStateName);
        return;
    }

    function bool ReadyToFire(bool bFinished)
    {
        return true;
        return;
    }

    simulated function bool TryPutDown(optional bool bInstantSwitch)
    {
        PutDownWeapon();
        return true;
        return;
    }
    stop;
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        BeginStateWeaponFiring(PreviousStateName);
        return;
    }

    simulated function EndState(name NextStateName)
    {
        EndStateWeaponFiring(NextStateName);
        return;
    }
    stop;
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        TimeWeaponEquipping();
        bWeaponPutDown = false;
        return;
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('WeaponEquipped');
        return;
    }

    simulated function WeaponEquipped()
    {
        // End:0x12
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        GotoState('Active');
        return;
    }
    stop;
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        TimeWeaponPutDown();
        bWeaponPutDown = false;
        ForceEndFire();
        return;
    }

    simulated function WeaponIsDown()
    {
        // End:0x15
        if(InvManager.CancelWeaponChange())
        {
            return;
        }
        DetachWeapon(true);
        InvManager.ChangedWeapon();
        GotoState('Inactive');
        return;
    }

    simulated function bool TryPutDown(optional bool bInstantSwitch)
    {
        return false;
        return;
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('WeaponIsDown');
        return;
    }
    stop;
}

state PendingClientWeaponSet
{
    simulated function PendingWeaponSetTimer()
    {
        ClientWeaponSet(true);
        return;
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetTimer(0.0500000, true, 'PendingWeaponSetTimer');
        return;
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('PendingWeaponSetTimer');
        return;
    }
    stop;
}

defaultproperties
{
    EquipTime=0.3300000
    PutDownTime=0.3300000
    bCanThrow=true
    WeaponRange=16384.0000000
    Priority=-1.0000000
    WarnTargetPct=0.9000000
    BotRefireRate=0.9500000
    AIRating=0.5000000
    ItemName="Weapon"
    bRenderOverlays=true
    RespawnTime=30.0000000
    bOnlyRelevantToOwner=false
    bReplicateInstigator=true
    bOnlyDirtyReplication=false
    Components=none
}