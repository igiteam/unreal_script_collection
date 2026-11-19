class SkyVehicleWeapon extends SkyWeaponBase
    abstract
    native
    nativereplication
    config(Game);

var int SeatIndex;
var repnotify SkyGameVehicle MyVehicle;
var array<name> FireTriggerTags;
var array<name> AltFireTriggerTags;
var array<MaterialImpactEffect> ImpactEffects;
var array<MaterialImpactEffect> AltImpactEffects;
var MaterialImpactEffect DefaultImpactEffect;
var MaterialImpactEffect DefaultAltImpactEffect;
var SoundCue BulletWhip;
var Color GoodAimColor;
var Color BadAimColor;
var float AimTraceRange;
var float MaxFinalAimAdjustment;
var(Sound) bool bPlaySoundFromSocket;
var bool bHeatingEffectStarted;
var bool bMaterialEffectsManagerInitialized;
var MaterialInstanceConstant WeaponMaterialInst;
var MaterialInstanceConstant WeaponMaterialInstFP;
var(Effects) int WeaponMaterialIndexFP;

replication
{
    // Pos:0x000
    if(((int(Role) == int(ROLE_Authority)) && bNetInitial) && bNetOwner
        MyVehicle, SeatIndex;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    AimTraceRange = MaxRange();
    //return;    
}

function InitMaterialEffectManager()
{
    local editinline SkeletalMeshComponent SkelMesh, SkelMeshFP;
    local SkyVehicle SkyVeh;

    // End:0x0D
    if(MaterialEffectManager == none)
    {
        return;
    }
    WeaponMaterialInst = new (Outer) Class'Engine.MaterialInstanceConstant';
    SkelMesh = MyVehicle.Mesh;
    // End:0xB0
    if((WeaponMaterialInst != none) && SkelMesh != none)
    {
        WeaponMaterialInst.SetParent(SkelMesh.GetMaterial(WeaponMaterialIndex));
        SkelMesh.SetMaterial(WeaponMaterialIndex, WeaponMaterialInst);
        MaterialEffectManager.MaterialInstances.AddItem(WeaponMaterialInst);
    }
    SkyVeh = SkyVehicle(MyVehicle);
    // End:0x16E
    if(SkyVeh != none)
    {
        WeaponMaterialInstFP = new (Outer) Class'Engine.MaterialInstanceConstant';
        SkelMeshFP = SkyVeh.FirstPersonMesh;
        // End:0x16E
        if((WeaponMaterialInstFP != none) && SkelMeshFP != none)
        {
            WeaponMaterialInstFP.SetParent(SkelMeshFP.GetMaterial(WeaponMaterialIndexFP));
            SkelMeshFP.SetMaterial(WeaponMaterialIndexFP, WeaponMaterialInstFP);
            MaterialEffectManager.MaterialInstances.AddItem(WeaponMaterialInstFP);
        }
    }
    MaterialEffectManager.Initialize();
    //return;    
}

simulated function Vector GetDesiredAimPoint()
{
    local Vector CameraLocation, HitLocation, HitNormal, DesiredAimPoint;
    local Rotator CameraRotation;
    local Controller C;
    local PlayerController PC;
    local Actor HitActor;

    C = MyVehicle.Seats[SeatIndex].SeatPawn.Controller;
    PC = PlayerController(C);
    // End:0xD2
    if(PC != none)
    {
        PC.GetPlayerViewPoint(CameraLocation, CameraRotation);
        DesiredAimPoint = CameraLocation + (Vector(CameraRotation) * (GetTraceRange()));
        HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, DesiredAimPoint, CameraLocation);
        // End:0xCF
        if(HitActor != none)
        {
            DesiredAimPoint = HitLocation;
        }        
    }
    else
    {
        // End:0xF3
        if(C != none)
        {
            DesiredAimPoint = C.GetFocalPoint();
        }
    }
    return DesiredAimPoint;
    //return ReturnValue;    
}

simulated function bool IsAimCorrect()
{
    local Vector SocketLocation, DesiredAimPoint, RealAimPoint;
    local Rotator SocketRotation;
    local float DiffAngle;

    DesiredAimPoint = GetDesiredAimPoint();
    // End:0x5D
    if(MyVehicle.Seats[SeatIndex].GunSocket.Length > 0)
    {
        MyVehicle.GetBarrelLocationAndRotation(SeatIndex, SocketLocation, SocketRotation);        
    }
    else
    {
        SocketLocation = MyVehicle.Location;
        SocketRotation = MyVehicle.Rotation;
    }
    RealAimPoint = SocketLocation + (Vector(SocketRotation) * (GetTraceRange()));
    DiffAngle = Normal(DesiredAimPoint - SocketLocation) Dot Normal(RealAimPoint - SocketLocation);
    // End:0xE4
    if(DiffAngle >= (GetMaxFinalAimAdjustment()))
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

// Export USkyVehicleWeapon::execGetFireTriggerTag(FFrame&, void* const)
native static simulated function name GetFireTriggerTag(int BarrelIndex, int FireMode);

simulated function float GetFireInterval(byte FireModeNum)
{
    return FireInterval[int(FireModeNum)];
    //return ReturnValue;    
}

// Export USkyVehicleWeapon::execGetImpactEffect(FFrame&, void* const)
native static simulated function MaterialImpactEffect GetImpactEffect(Actor HitActor, PhysicalMaterial HitMaterial, byte FireModeNum);

simulated function SetHand(SkyPawnBase.ESkyWeaponHand NewWeaponHand)
{
    //return;    
}

simulated function SkyPawnBase.ESkyWeaponHand GetHand()
{
    //return ReturnValue;    
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    //return;    
}

simulated function DetachWeapon()
{
    //return;    
}

simulated event ActivateEvent()
{
    Activate();
    //return;    
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

// Export USkyVehicleWeapon::execGetPhysicalFireStartLoc(FFrame&, void* const)
native simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir);

simulated function BeginFire(byte FireModeNum)
{
    local SkyVehicle V;
    local SkyAirVehicle AV;

    V = SkyVehicle(Instigator);
    AV = SkyAirVehicle(Instigator);
    // End:0x60
    if(((V != none) && V.bIsDisabled) && V.OverrideBeginFire(FireModeNum))
    {
        return;
    }
    // End:0x89
    if((AV != none) && int(AV.AirVehicleState) != int(3))
    {
        return;
    }
    super.BeginFire(FireModeNum);
    //return;    
}

// Export USkyVehicleWeapon::execGetAdjustedAim(FFrame&, void* const)
native simulated function Rotator GetAdjustedAim(Vector StartFireLoc);

// Export USkyVehicleWeapon::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

// Export USkyVehicleWeapon::execInstantFireStartTrace(FFrame&, void* const)
native simulated function Vector InstantFireStartTrace();

// Export USkyVehicleWeapon::execInstantFireEndTrace(FFrame&, void* const)
native simulated function Vector InstantFireEndTrace(Vector StartTrace);

simulated function DrawAmmoCount(HUD H)
{
    //return;    
}

// Export USkyVehicleWeapon::execGetTraceOwner(FFrame&, void* const)
native simulated function Actor GetTraceOwner();

// Export USkyVehicleWeapon::execGetMaxFinalAimAdjustment(FFrame&, void* const)
native simulated function float GetMaxFinalAimAdjustment();

simulated function NotifyVehicleDeployed()
{
    //return;    
}

simulated function NotifyVehicleUndeployed()
{
    //return;    
}

simulated event WeaponPlaySound(SoundCue Sound, optional float NoiseLoudness)
{
    local int Barrel;
    local name Pivot;
    local Vector Loc;
    local Rotator Rot;

    // End:0xDD
    if((bPlaySoundFromSocket && MyVehicle != none) && MyVehicle.Mesh != none)
    {
        // End:0x48
        if((Sound == none) || Instigator == none)
        {
            return;
        }
        Barrel = MyVehicle.GetBarrelIndex(SeatIndex);
        Pivot = MyVehicle.Seats[SeatIndex].GunSocket[Barrel];
        MyVehicle.Mesh.GetSocketWorldLocationAndRotation(Pivot, Loc, Rot);
        Instigator.PlaySound(Sound, false, true, false, Loc);        
    }
    else
    {
        super(Weapon).WeaponPlaySound(Sound, NoiseLoudness);
    }
    //return;    
}

function AttachLoopingWeaponSound(Pawn NewOwner, AudioComponent LoopComponent)
{
    local int Barrel;
    local SkyVehicle SVehicle;

    // End:0x1E
    if(!bPlaySoundFromSocket)
    {
        super.AttachLoopingWeaponSound(NewOwner, LoopComponent);        
    }
    else
    {
        SVehicle = SkyVehicle(Instigator);
        Barrel = SVehicle.GetBarrelIndex(SeatIndex);
        NewOwner.Mesh.AttachComponentToSocket(LoopComponent, SVehicle.Seats[SeatIndex].GunSocket[Barrel]);
    }
    //return;    
}

function StartHeatingTimer(float delay)
{
    SetTimer(delay, false, 'CauseHeatingEffect');
    bHeatingEffectStarted = false;
    //return;    
}

simulated function CauseHeatingEffect()
{
    // End:0x46
    if(MaterialEffectManager != none)
    {
        // End:0x28
        if(!bMaterialEffectsManagerInitialized)
        {
            InitMaterialEffectManager();
            bMaterialEffectsManagerInitialized = true;
        }
        bHeatingEffectStarted = true;
        MaterialEffectManager.ActivateEffect(13);
    }
    //return;    
}

simulated event StopHeatingEffect()
{
    // End:0x2C
    if(bHeatingEffectStarted && MaterialEffectManager != none)
    {
        MaterialEffectManager.ActivateEffect(14);
    }
    //return;    
}

simulated function StopAllEffects()
{
    StopHeatingEffect();
    ClearTimer('CauseHeatingEffect');
    super.StopAllEffects();
    //return;    
}
