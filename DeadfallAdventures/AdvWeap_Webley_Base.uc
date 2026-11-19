class AdvWeap_Webley_Base extends AdvWeap_Pistol_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated function RollDrum()
{
    local UDKSkelControl_Rotate SkelControlDrum;
    local Rotator DesiredRotation;

    SkelControlDrum = UDKSkelControl_Rotate(SkeletalMeshComponent(Mesh).FindSkelControl('beben'));
    // End:0x1A9
    if(SkelControlDrum != none)
    {
        DesiredRotation = SkelControlDrum.DesiredBoneRotation;
        // End:0x107
        if(!UsesOffhand)
        {
            DesiredRotation.Roll += int(float(60) * 182.0444000);
            // End:0x104
            if(float(DesiredRotation.Roll) >= (float(360) * 182.0444000))
            {
                DesiredRotation.Roll = 0;
            }            
        }
        else
        {
            DesiredRotation.Roll -= int(float(60) * 182.0444000);
            // End:0x181
            if(float(DesiredRotation.Roll) <= (float(-360) * 182.0444000))
            {
                DesiredRotation.Roll = 0;
            }
        }
        SkelControlDrum.DesiredBoneRotation = DesiredRotation;
    }
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
    WeaponStatMP_Damage=7
    WeaponStatMP_Firerate=4
    WeaponStatMP_Accuracy=6
    WeaponStatMP_Magazines=4
    WeaponStatMP_ReloadSpeed=7
    EWeaponType=WeaponType.TYPE_Revolver
    DefaultInfiniteWeapon=true
    DisplayDotCrosshair=true
    ZoomedCrosshair=true
    DefaultAmmoCount=60
    MaxAmmoCount=60
    MaxAmmoCountSurvivalMultiplier=1.0000000
    MagazineAmmoCount=6
    MagazineMaxAmmoCount=6
    WeaponHitRange=3000.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotSpreadModifier=0.0900000
    ShotSpreadBackSpeed=1.0000000
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Webley_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Mk.VI Ammo"
    ReloadTime=3.7080000
    InventoryGroup=1
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-5.0000000,Y=-7.7697000,Z=0.4057000)
    ZoomedMeshRotation=(Pitch=-529,Yaw=561,Roll=-628)
    ZoomedMeshScale=1.5689000
    DOF_FocusDistance=50.0000000
    GroupWeight=0.1000000
    // Reference: AudioComponent'Default__AdvWeap_Webley_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Webley_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Webley"
    CrouchAnimTime=1.0420000
    StandUpAnimTime=1.0420000
    SprintAnimTime=1.0000000
    PlayerViewOffset=(X=33.5292000,Y=9.7070000,Z=-7.6999000)
    PlayerRotationOffset=(Pitch=-41,Yaw=-735,Roll=152)
    CurrentRating=0.1000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.3300000
    PutDownTime=0.3300000
    bInstantHit=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Webley_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.1000000
    ItemName="Mk.VI"
    MaxDesireability=0.1000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Webley_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}