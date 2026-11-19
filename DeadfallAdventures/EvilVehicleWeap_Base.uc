class EvilVehicleWeap_Base extends EvilWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

const MAXFLASHLOCATION = 20;

var int SeatIndex;
var repnotify EvilVehicle_Base MyVehicle;
var array<name> FireTriggerTags;
var array<name> AltFireTriggerTags;
var float LastCorrectAimTime;
var float LastInCorrectAimTime;
var float MaxFinalAimAdjustment;
var bool bIgnoreSocketPitchRotation;
var bool bIgnoreDownwardPitch;
var bool bDebugTurret;
var class<EvilVehicle_Base> VehicleClass;
var Vector LastFiringFlashLocation;
var repnotify Vector FlashLocationArray[20];
var repnotify byte FlashCount;
var EvilAttachment_Weap_Base Attachment;

replication
{
    // Pos:0x000
    if(bNetInitial && bNetOwner
        MyVehicle, SeatIndex;

    // Pos:0x019
    if(bNetDirty
        FlashCount, FlashLocationArray;
}

simulated function bool CanHitDesiredTarget(Vector SocketLocation, Rotator SocketRotation, Vector DesiredAimPoint, Actor TargetActor, out Vector RealAimPoint)
{
    local int I;
    local array<Actor> IgnoredActors;
    local Actor HitActor;
    local Vector HitLocation, HitNormal;
    local bool bResult;

    // End:0x1F9
    if((Normal(DesiredAimPoint - SocketLocation) Dot Normal(RealAimPoint - SocketLocation)) >= (GetMaxFinalAimAdjustment()))
    {
        I = 0;
        J0x48:

        // End:0x108 [Loop If]
        if(I < AimingTraceIgnoredActors.Length)
        {
            // End:0xFA
            if((AimingTraceIgnoredActors[I] != none) && AimingTraceIgnoredActors[I].bProjTarget)
            {
                AimingTraceIgnoredActors[I].bProjTarget = false;
                IgnoredActors[IgnoredActors.Length] = AimingTraceIgnoredActors[I];
            }
            I++;
            // [Loop Continue]
            goto J0x48;
        }
        HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, DesiredAimPoint, SocketLocation, true,,, 1);
        // End:0x18A
        if((HitActor == none) || HitActor == TargetActor)
        {
            bResult = true;            
        }
        else
        {
            RealAimPoint = HitLocation;
        }
        I = 0;
        J0x1A8:

        // End:0x1F9 [Loop If]
        if(I < IgnoredActors.Length)
        {
            IgnoredActors[I].bProjTarget = true;
            I++;
            // [Loop Continue]
            goto J0x1A8;
        }
    }
    return bResult;
    //return ReturnValue;    
}

static simulated function DrawKillIcon(Canvas Canvas, float ScreenX, float ScreenY, float HUDScaleX, float HUDScaleY)
{
    // End:0x5B
    if(default.VehicleClass != none)
    {
        default.VehicleClass.static.DrawKillIcon(Canvas, ScreenX, ScreenY, HUDScaleX, HUDScaleY);
    }
    //return;    
}

simulated event Vector GetDesiredAimPoint(optional out Actor TargetActor)
{
    local Vector CameraLocation, HitLocation, HitNormal, DesiredAimPoint;
    local Rotator CameraRotation;
    local Controller C;
    local PlayerController PC;

    C = ((MyVehicle != none) ? MyVehicle.Seats[SeatIndex].SeatPawn.Controller : none);
    PC = PlayerController(C);
    // End:0x165
    if(PC != none)
    {
        PC.GetPlayerViewPoint(CameraLocation, CameraRotation);
        DesiredAimPoint = CameraLocation + (Vector(CameraRotation) * (GetTraceRange()));
        TargetActor = GetTraceOwner().Trace(HitLocation, HitNormal, DesiredAimPoint, CameraLocation);
        // End:0x162
        if(TargetActor != none)
        {
            DesiredAimPoint = HitLocation;
        }        
    }
    else
    {
        // End:0x1C5
        if(C != none)
        {
            DesiredAimPoint = C.GetFocalPoint();
            TargetActor = C.Focus;
        }
    }
    return DesiredAimPoint;
    //return ReturnValue;    
}

simulated function GetFireStartLocationAndRotation(out Vector StartLocation, out Rotator StartRotation)
{
    // End:0x11
    if(MyVehicle == none)
    {
        return;
    }
    // End:0x90
    if(MyVehicle.Seats[SeatIndex].GunSocket.Length > 0)
    {
        MyVehicle.GetBarrelLocationAndRotation(SeatIndex, StartLocation, StartRotation);        
    }
    else
    {
        StartLocation = MyVehicle.Location;
        StartRotation = MyVehicle.Rotation;
    }
    //return;    
}

simulated event bool IsAimCorrect()
{
    local Vector SocketLocation, DesiredAimPoint, RealAimPoint;
    local Rotator SocketRotation;

    DesiredAimPoint = GetDesiredAimPoint();
    GetFireStartLocationAndRotation(SocketLocation, SocketRotation);
    RealAimPoint = SocketLocation + (Vector(SocketRotation) * (GetTraceRange()));
    return (Normal(DesiredAimPoint - SocketLocation) Dot Normal(RealAimPoint - SocketLocation)) >= (GetMaxFinalAimAdjustment());
    //return ReturnValue;    
}

simulated function Activate()
{
    // End:0x1D
    if(!IsFiring())
    {
        GotoState('Active');
    }
    //return;    
}

simulated function PutDownWeapon()
{
    GotoState('Inactive');
    //return;    
}

simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
    // End:0x34
    if(MyVehicle != none)
    {
        return MyVehicle.GetPhysicalFireStartLoc(self);        
    }
    else
    {
        return Location;
    }
    //return ReturnValue;    
}

simulated function BeginFire(byte FireModeNum)
{
    local EvilVehicle_Base V;

    V = EvilVehicle_Base(Instigator);
    // End:0x93
    if((V == none) || !V.bIsDisabled && !V.OverrideBeginFire(FireModeNum))
    {
        super(Weapon).BeginFire(FireModeNum);
    }
    //return;    
}

simulated function EndFire(byte FireModeNum)
{
    local EvilVehicle_Base V;

    V = EvilVehicle_Base(Instigator);
    // End:0x6D
    if((V == none) || !V.OverrideEndFire(FireModeNum))
    {
        super.EndFire(FireModeNum);
    }
    //return;    
}

simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
    return Instigator.GetAdjustedAimFor(self, StartFireLoc);
    //return ReturnValue;    
}

simulated function Projectile ProjectileFire()
{
    local Projectile SpawnedProjectile;

    IncrementFlashCount();
    // End:0xBB
    if(int(Role) == int(ROLE_Authority))
    {
        SpawnedProjectile = Spawn(GetProjectileClass(),,, MyVehicle.GetPhysicalFireStartLoc(self));
        // End:0xBB
        if(SpawnedProjectile != none)
        {
            SpawnedProjectile.Init(Vector(AddSpread(MyVehicle.GetWeaponAim(self))));
        }
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}

simulated function Vector InstantFireStartTrace()
{
    return ((MyVehicle != none) ? MyVehicle.GetPhysicalFireStartLoc(self) : vect(0.0000000, 0.0000000, 0.0000000));
    //return ReturnValue;    
}

simulated function Vector InstantFireEndTrace(Vector StartTrace)
{
    // End:0x19
    if(MyVehicle == none)
    {
        return StartTrace;
    }
    return StartTrace + (Vector(AddSpread(MyVehicle.GetWeaponAim(self))) * (GetTraceRange()));
    //return ReturnValue;    
}

simulated function Actor GetTraceOwner()
{
    return ((MyVehicle != none) ? MyVehicle : super(Weapon).GetTraceOwner());
    //return ReturnValue;    
}

simulated function float GetMaxFinalAimAdjustment()
{
    return MaxFinalAimAdjustment;
    //return ReturnValue;    
}

simulated function NotifyVehicleDeployed()
{
    //return;    
}

simulated function NotifyVehicleUndeployed()
{
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x26
    if(VarName == 'FlashLocationArray')
    {
        FlashLocationArrayUpdated(true);        
    }
    else
    {
        // End:0x4B
        if(VarName == 'FlashCount')
        {
            FlashCountUpdated(true);            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}

simulated function SetFlashLocationArray(array<Vector> HitLocationArray, optional bool bIsMelee = false)
{
    local int I;

    // End:0x17
    if(HitLocationArray.Length == 0)
    {
        return;
    }
    // End:0x4A
    if(HitLocationArray[0] == LastFiringFlashLocation)
    {
        HitLocationArray[0] += vect(0.0000000, 0.0000000, 1.0000000);
    }
    // End:0x80
    if(HitLocationArray[0] == vect(0.0000000, 0.0000000, 0.0000000))
    {
        HitLocationArray[0] = vect(0.0000000, 0.0000000, 1.0000000);
    }
    bForceNetUpdate = true;
    LastFiringFlashLocation = HitLocationArray[0];
    I = 0;
    J0xAC:

    // End:0x10F [Loop If]
    if(I < 20)
    {
        // End:0xDA
        if(I > (HitLocationArray.Length - 1))
        {
            // [Explicit Break]
            goto J0x10F;
        }
        FlashLocationArray[I] = HitLocationArray[I];
        I++;
        // [Loop Continue]
        goto J0xAC;
    }
    J0x10F:

    FlashLocationArrayUpdated(false, false);
    //return;    
}

function ClearFlashLocationArray(optional bool bIsMelee = false)
{
    local int I;

    // End:0x7A
    if(!IsZero(FlashLocationArray[0]))
    {
        bForceNetUpdate = true;
        I = 0;
        J0x2F:

        // End:0x6E [Loop If]
        if(I < 20)
        {
            FlashLocationArray[I] = vect(0.0000000, 0.0000000, 0.0000000);
            I++;
            // [Loop Continue]
            goto J0x2F;
        }
        FlashLocationArrayUpdated(false);
    }
    //return;    
}

simulated function IncrementFlashCount()
{
    bForceNetUpdate = true;
    FlashCount++;
    // End:0x38
    if(int(FlashCount) == int(0))
    {
        FlashCount += 2;
    }
    FlashCountUpdated(false);
    //return;    
}

simulated function ClearFlashCount()
{
    // End:0x37
    if(int(FlashCount) != int(0))
    {
        bForceNetUpdate = true;
        FlashCount = 0;
        FlashCountUpdated(false);
    }
    //return;    
}

simulated function FlashLocationArrayUpdated(bool bViaReplication, optional bool bIsMelee = false)
{
    // End:0x39
    if(!IsZero(FlashLocationArray[0]))
    {
        WeaponFired(bViaReplication, bIsMelee);        
    }
    else
    {
        WeaponStoppedFiring(bViaReplication);
    }
    //return;    
}

simulated function FlashCountUpdated(bool bViaReplication)
{
    // End:0x2C
    if(int(FlashCount) > int(0))
    {
        WeaponFired(bViaReplication);        
    }
    else
    {
        WeaponStoppedFiring(bViaReplication);
    }
    //return;    
}

simulated function WeaponFired(bool bViaReplication, optional bool bIsMelee = false)
{
    local int I;

    // End:0x1D5
    if(Attachment != none)
    {
        // End:0x65
        if(!Instigator.IsFirstPerson())
        {
            Attachment.ThirdPersonFireEffects(FlashLocationArray[0]);            
        }
        else
        {
            PlayFireEffects(CurrentFireMode, FlashLocationArray[0]);
            // End:0xCF
            if(Class'Engine.Engine'.static.IsSplitScreen())
            {
                Attachment.ThirdPersonFireEffects(FlashLocationArray[0]);
            }
        }
        // End:0x1D2
        if((FlashLocationArray[0] != vect(0.0000000, 0.0000000, 0.0000000)) && ((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || bViaReplication)
        {
            I = 0;
            J0x15C:

            // End:0x1D2 [Loop If]
            if(I < 20)
            {
                // End:0x1C4
                if(FlashLocationArray[I] != vect(0.0000000, 0.0000000, 0.0000000))
                {
                    Attachment.PlayImpactEffects(FlashLocationArray[I]);
                }
                I++;
                // [Loop Continue]
                goto J0x15C;
            }
        }        
    }
    else
    {
        PlayFireEffects(CurrentFireMode, FlashLocationArray[0]);
    }
    //return;    
}

simulated function WeaponStoppedFiring(bool bViaReplication)
{
    // End:0x44
    if(Attachment != none)
    {
        Attachment.StopThirdPersonFireEffects();
        StopFireEffects(CurrentFireMode);        
    }
    else
    {
        StopFireEffects(CurrentFireMode);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x6C
    if(AttachmentClass != none)
    {
        Attachment = Spawn(AttachmentClass, Instigator);
        Attachment.Instigator = Instigator;
    }
    // End:0x135
    if(((Mesh == none) || (SkeletalMeshComponent(Mesh) != none) && SkeletalMeshComponent(Mesh).SkeletalMesh == none) || (StaticMeshComponent(Mesh) != none) && StaticMeshComponent(Mesh).StaticMesh == none)
    {
        Mesh = Instigator.Mesh;
    }
    //return;    
}

simulated function Destroyed()
{
    super.Destroyed();
    // End:0x3C
    if(Attachment != none)
    {
        Attachment.Destroy();
        Attachment = none;
    }
    //return;    
}

defaultproperties
{
    MaxFinalAimAdjustment=0.9950000
    bExportMenuData=false
    ShotCost[0]=0
    ShotCost[1]=0
    // Reference: ForceFeedbackWaveform'Default__EvilVehicleWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=100
    GroupWeight=0.5000000
    // Reference: AudioComponent'Default__EvilVehicleWeap_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__EvilVehicleWeap_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    AimError=600.0000000
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__EvilVehicleWeap_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__EvilVehicleWeap_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}