class AdvWeap_AVS36_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

struct TCubeMap
{
    var string MapName;
    var Texture CubeMap;

    structdefaultproperties
    {
        MapName=""
        CubeMap=none
    }
};

var export editinline UDKSkeletalMeshComponent SkeletonFirstPersonMesh;
var() array<float> FireIntervalLast;
var(Animations) array<name> WeaponFireAnimLast;
var(Animations) array<name> ArmFireAnimLast;
var array<CameraAnim> FireCameraAnimLast;
var(Sounds) array<SoundCue> WeaponFireSndLast;
var transient bool bShowCrosshairZoom;
var MaterialInterface CrosshairZoomMat;
var() array<TCubeMap> CubeMaps;

simulated function bool ShouldRefire()
{
    return false;
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated function EndZoomWorker(EvilPlayerController PC)
{
    super(EvilWeap_Base).EndZoomWorker(PC);
    ChangeVisibility(true);
    bShowCrosshairZoom = false;
    AdvPostProcessManager(PC.GetPPManager()).EnableCustomHUDEffect(false);
    //return;    
}

simulated event SetPosition(UDKPawn Holder)
{
    local Vector VLength;
    local float Length;

    super(EvilWeap_Base).SetPosition(Holder);
    // End:0x117
    if((int(GetZoomedState()) > int(1)) && DesiredMeshTranslation == ZoomedMeshTranslation)
    {
        VLength = Mesh.Translation - DesiredMeshTranslation;
        Length = VSize(VLength);
        // End:0x117
        if(Length < float(1))
        {
            ChangeVisibility(false);
            bShowCrosshairZoom = true;
            AdvPostProcessManager(EvilPlayerController(Holder.Controller).GetPPManager()).EnableCustomHUDEffect(true, CrosshairZoomMat);
        }
    }
    //return;    
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
    // End:0x22
    if(!bShowCrosshairZoom)
    {
        super.DrawWeaponCrosshair(HUD);
    }
    //return;    
}

simulated function DetachWeapon()
{
    local EvilPlayerController PC;

    super(EvilWeap_Base).DetachWeapon();
    // End:0xA3
    if(bShowCrosshairZoom)
    {
        PC = EvilPlayerController(Instigator.Controller);
        bShowCrosshairZoom = false;
        // End:0xA3
        if(PC != none)
        {
            AdvPostProcessManager(PC.GetPPManager()).EnableCustomHUDEffect(false);
        }
    }
    //return;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;

        super.BeginState(PreviousStateName);
        // End:0xAC
        if(bShowCrosshairZoom)
        {
            PC = EvilPlayerController(Instigator.Controller);
            bShowCrosshairZoom = false;
            // End:0xAC
            if(PC != none)
            {
                AdvPostProcessManager(PC.GetPPManager()).EnableCustomHUDEffect(false);
            }
        }
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        local MaterialInstanceConstant Mat;
        local int I, Index;

        super.BeginState(PreviousStateName);
        Index = -1;
        I = 0;
        J0x2D:

        // End:0xBE [Loop If]
        if(I < CubeMaps.Length)
        {
            // End:0xB0
            if(InStr(WorldInfo.GetMapName(true), CubeMaps[I].MapName,, true) > -1)
            {
                Index = I;
                // [Explicit Break]
                goto J0xBE;
            }
            I++;
            // [Loop Continue]
            goto J0x2D;
        }
        J0xBE:

        Mat = Mesh.CreateAndSetMaterialInstanceConstant(4);
        // End:0x1A2
        if(Mat != none)
        {
            // End:0x15C
            if(Index > -1)
            {
                Mat.SetTextureParameterValue('TexCubeMap', CubeMaps[Index].CubeMap);                
            }
            else
            {
                Mat.SetTextureParameterValue('TexCubeMap', CubeMaps[0].CubeMap);
            }
        }
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0xE6
        if(MagazineAmmoCount == 1)
        {
            WeaponFireAnim[int(CurrentFireMode)] = WeaponFireAnimLast[int(CurrentFireMode)];
            ArmFireAnim[int(CurrentFireMode)] = ArmFireAnimLast[int(CurrentFireMode)];
            FireInterval[int(CurrentFireMode)] = FireIntervalLast[int(CurrentFireMode)];
            FireCameraAnim[int(CurrentFireMode)] = FireCameraAnimLast[int(CurrentFireMode)];
            WeaponFireSnd[int(CurrentFireMode)] = WeaponFireSndLast[int(CurrentFireMode)];
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        WeaponFireAnim = default.WeaponFireAnim;
        ArmFireAnim = default.ArmFireAnim;
        FireInterval = WeaponFireInterval;
        FireCameraAnim = default.FireCameraAnim;
        WeaponFireSnd = default.WeaponFireSnd;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    FireIntervalLast[0]=0.4100000
    WeaponStatMP_Damage=8
    WeaponStatMP_Firerate=4
    WeaponStatMP_Accuracy=9
    WeaponStatMP_Magazines=4
    WeaponStatMP_ReloadSpeed=4
    EWeaponType=WeaponType.TYPE_SniperRifle
    WeaponUsingScope=true
    bDisplayCrosshair=false
    BothHandWeapon=true
    DefaultAmmoCount=20
    MaxAmmoCount=20
    MagazineAmmoCount=5
    MagazineMaxAmmoCount=5
    WeaponHitRange=30000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponZoomDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadBackSpeed=0.1000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_AVS36_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="AVS36 Ammo"
    ReloadTime=2.2000000
    InventoryGroup=2
    ZoomedTargetFOV=15.0000000
    ZoomedMeshTranslation=(X=-43.1839000,Y=-16.6564000,Z=5.8196000)
    ZoomedMeshRotation=(Pitch=-567,Yaw=292,Roll=-516)
    ZoomedMeshScale=2.0000000
    ZoomedSpreadMult=0.0010000
    GroupWeight=0.3500000
    // Reference: AudioComponent'Default__AdvWeap_AVS36_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_AVS36_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="AVS36"
    PlayerViewOffset=(X=18.5308000,Y=11.8334000,Z=-6.9642000)
    PlayerRotationOffset=(Pitch=-534,Yaw=-508,Roll=454)
    CurrentRating=0.3500000
    AimingHelpRadius=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4000000
    PutDownTime=0.4000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_AVS36_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3500000
    ItemName="AVS36"
    MaxDesireability=0.3500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_AVS36_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}