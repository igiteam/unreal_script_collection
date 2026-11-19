class AdvWeap_PZB38_Base extends AdvWeap_Base
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
    //return;    
}

simulated event SetPosition(UDKPawn Holder)
{
    super(EvilWeap_Base).SetPosition(Holder);
    //return;    
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
    super.DrawWeaponCrosshair(HUD);
    //return;    
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    local EvilTouchPickUp_Base tmpPickup;

    // End:0x5F
    if(AmmoCount == 0)
    {
        tmpPickup = PickupArchetype;
        PickupArchetype = none;
        super.DropFrom(StartLocation, StartVelocity);
        PickupArchetype = tmpPickup;        
    }
    else
    {
        super.DropFrom(StartLocation, StartVelocity);
    }
    //return;    
}

simulated function bool CanUseAmmoBox()
{
    return false;
    //return ReturnValue;    
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

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPawn P;
        local bool bSuppressDrop;

        super.BeginState(PreviousStateName);
        // End:0x93
        if(WorldInfo.GRI.IsMultiplayerGame() && (AdvPlayerPawnMP(Instigator) != none) && AdvPlayerPawnMP(Instigator).bIsDevastator)
        {
            return;
        }
        bSuppressDrop = (EvilInvManager.PendingWeapon == none) || EvilInvManager.PendingWeapon.bMeleeWeapon;
        P = EvilPawn(Instigator);
        // End:0x15F
        if((P != none) && !bSuppressDrop)
        {
            P.TossInventory(self);
            WeaponIsDown();
        }
        //return;        
    }
    stop;    
}

simulated state WeaponAbortEquip
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPawn P;
        local bool bSuppressDrop;

        super.BeginState(PreviousStateName);
        // End:0x93
        if(WorldInfo.GRI.IsMultiplayerGame() && (AdvPlayerPawnMP(Instigator) != none) && AdvPlayerPawnMP(Instigator).bIsDevastator)
        {
            return;
        }
        bSuppressDrop = (EvilInvManager.PendingWeapon == none) || EvilInvManager.PendingWeapon.bMeleeWeapon;
        P = EvilPawn(Instigator);
        // End:0x155
        if((P != none) && !bSuppressDrop)
        {
            P.TossInventory(self);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    WeaponStatMP_Damage=10
    WeaponStatMP_Firerate=2
    WeaponStatMP_Accuracy=9
    WeaponStatMP_Magazines=2
    EWeaponType=WeaponType.TYPE_Special
    WeaponUsingScope=true
    BothHandWeapon=true
    AlwaysBothHandReload=true
    DefaultAmmoCount=16
    MaxAmmoCount=16
    MaxAmmoCountSurvivalMultiplier=1.0000000
    WeaponHitRange=30000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponZoomDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadModifier=0.0000000
    MoveSpreadMultiplier=1.0500000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_PZB38_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Pzb.38 Anti-Tank Ammo"
    ReloadTime=2.0667000
    InventoryGroup=3
    ZoomedTargetFOV=15.0000000
    ZoomedMeshTranslation=(X=-36.4512000,Y=-2.3785000,Z=11.3184000)
    ZoomedMeshRotation=(Pitch=233,Yaw=169,Roll=-341)
    ZoomedMeshScale=2.0000000
    ZoomedSpreadMult=0.0010000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.3500000
    // Reference: AudioComponent'Default__AdvWeap_PZB38_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_PZB38_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Panzerb?chse"
    PlayerViewOffset=(X=24.7312000,Y=7.1649000,Z=-11.3977000)
    PlayerRotationOffset=(Pitch=-989,Yaw=-18,Roll=454)
    CurrentRating=0.7000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=1.1000000
    PutDownTime=1.1000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_PZB38_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3500000
    ItemName="Pzb.38 Anti-Tank"
    MaxDesireability=0.3500000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_PZB38_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}