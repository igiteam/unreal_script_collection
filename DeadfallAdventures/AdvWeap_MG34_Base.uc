class AdvWeap_MG34_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

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
    // End:0x73
    if(((WorldInfo != none) && WorldInfo.GRI != none) && WorldInfo.GRI.IsMultiplayerGame())
    {
        return false;        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

simulated function bool BlockMeleeAction()
{
    return true;
    //return ReturnValue;    
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
    WeaponStatMP_Damage=4
    WeaponStatMP_Firerate=6
    WeaponStatMP_Accuracy=3
    WeaponStatMP_Magazines=8
    WeaponStatMP_ReloadSpeed=1
    EWeaponType=WeaponType.TYPE_HMG
    FlashlightBaseSpotlightOffset=(X=-10.0000000,Y=-7.0000000,Z=-25.0000000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-500,Yaw=300,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-10.0000000,Y=-1.7500000,Z=-24.0000000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-500,Yaw=0,Roll=0)
    BlockSprint=true
    BothHandWeapon=true
    bFastRepeater=true
    DefaultAmmoCount=200
    MaxAmmoCount=200
    MaxAmmoCountSurvivalMultiplier=1.0000000
    MagazineAmmoCount=100
    MagazineMaxAmmoCount=100
    WeaponHitRange=9000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    MoveSpreadMultiplier=1.6000000
    MinReloadPct=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_MG34_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="MG-34 Ammo"
    ReloadTime=4.8330000
    MovementSpeedModifier=0.7000000
    InventoryGroup=3
    ZoomedTargetFOV=55.0000000
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-19.0460000,Y=-10.5485000,Z=-4.9092000)
    ZoomedMeshRotation=(Pitch=-555,Yaw=517,Roll=0)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.8000000
    // Reference: AudioComponent'Default__AdvWeap_MG34_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_MG34_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    BackForceVector=(X=-0.4000000,Y=0.0400000,Z=0.2000000)
    BackForceMax=(X=15.0000000,Y=0.0000000,Z=0.0000000)
    RecoilDelta=40.0000000
    RecoilMax=2500.0000000
    WeaponName="MG34"
    CrouchAnimTime=1.0420000
    StandUpAnimTime=1.0420000
    SprintStartAnimTime=1.2080000
    SprintAnimTime=0.7000000
    PlayerViewOffset=(X=4.0000000,Y=5.0000000,Z=-4.0000000)
    PlayerRotationOffset=(Pitch=-364,Yaw=-546,Roll=0)
    CurrentRating=0.8000000
    UpgradeModifier_BonusMagazines=1
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=1.1000000
    PutDownTime=1.1000000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_MG34_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.8000000
    ItemName="MG-34"
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_MG34_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}