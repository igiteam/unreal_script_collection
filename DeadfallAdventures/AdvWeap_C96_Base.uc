class AdvWeap_C96_Base extends AdvWeap_Pistol_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated function bool ShouldRefire()
{
    return super(AdvWeap_Base).ShouldRefire();
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x18
        if(CheckZoom(FireModeNum))
        {
            return;
        }
        global.BeginFire(FireModeNum);
        // End:0x6D
        if(!HasShareAmmo(FireModeNum) && int(FireModeNum) == int(CurrentFireMode))
        {
            WeaponEmpty();
            return;
        }
        // End:0xC5
        if(((int(FireModeNum) == int(1)) || int(FireModeNum) != int(CurrentFireMode)) || MagazineAmmoCount < ShotCost[int(FireModeNum)])
        {
            return;
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    WeaponStatMP_Damage=2
    WeaponStatMP_Firerate=6
    WeaponStatMP_Accuracy=7
    WeaponStatMP_ReloadSpeed=6
    EWeaponType=WeaponType.TYPE_AutomaticPistol
    ZoomedCrosshair=true
    bFastRepeater=true
    DefaultAmmoCount=60
    MaxAmmoCount=60
    MaxAmmoCountSurvivalMultiplier=1.0000000
    MagazineAmmoCount=20
    MagazineMaxAmmoCount=20
    WeaponHitRange=4000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadModifier=0.0900000
    ShotSpreadBackSpeed=5.0000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_C96_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="C-96 Ammo"
    ReloadTime=1.9000000
    InventoryGroup=1
    ZoomedMeshTranslation=(X=-13.9544000,Y=-11.8030000,Z=7.8885000)
    ZoomedMeshRotation=(Pitch=-456,Yaw=-49,Roll=-1843)
    ZoomedMeshScale=1.4463000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__AdvWeap_C96_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_C96_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    RecoilDelta=450.0000000
    RecoilMax=500.0000000
    WeaponName="C96"
    PlayerViewOffset=(X=48.3379000,Y=14.5373000,Z=-15.8030000)
    PlayerRotationOffset=(Pitch=-41,Yaw=-195,Roll=-528)
    CurrentRating=0.3000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.3300000
    PutDownTime=0.3300000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_C96_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3000000
    ItemName="C-96"
    MaxDesireability=0.3000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_C96_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}