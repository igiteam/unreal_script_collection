class AdvWeap_FlareGun_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var export editinline UDKSkeletalMeshComponent SkeletonFirstPersonMesh;

simulated function bool ShouldRefire()
{
    super.ShouldRefire();
    return false;
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated function FireAmmunition()
{
    super(EvilWeap_Base).FireAmmunition();
    // End:0x28
    if(int(CurrentFireMode) == int(0))
    {
        RotateZamek();
    }
    //return;    
}

simulated function RotateZamek()
{
    local SkelControlSingleBone SkelControlZamek;

    SkelControlZamek = SkelControlSingleBone(SkeletonFirstPersonMesh.FindSkelControl('zamek'));
    // End:0x14A
    if(SkelControlZamek != none)
    {
        switch(MagazineAmmoCount)
        {
            // End:0xBD
            case 3:
                SkelControlZamek.BoneRotation = MakeRotator(0, 0, int(float(130) * 182.0444000));
                SkelControlZamek.SetSkelControlActive(true);
                // End:0x14A
                break;
            // End:0xE5
            case 2:
                SkelControlZamek.SetSkelControlActive(false);
                // End:0x14A
                break;
            // End:0x147
            case 1:
                SkelControlZamek.BoneRotation = MakeRotator(0, 0, int(float(-130) * 182.0444000));
                SkelControlZamek.SetSkelControlActive(true);
                // End:0x14A
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

simulated function ResetControllers()
{
    local SkelControlSingleBone SkelControlHelper;
    local int I;

    SkelControlHelper = SkelControlSingleBone(SkeletonFirstPersonMesh.FindSkelControl('zamek'));
    // End:0xA2
    if(SkelControlHelper != none)
    {
        SkelControlHelper.BoneRotation = MakeRotator(0, 0, int(float(130) * 182.0444000));
        SkelControlHelper.SetSkelControlActive(true);
    }
    I = 1;
    J0xAD:

    // End:0x143 [Loop If]
    if(I < 4)
    {
        SkelControlHelper = SkelControlSingleBone(SkeletonFirstPersonMesh.FindSkelControl(name("pocisk" $ string(I))));
        // End:0x135
        if(SkelControlHelper != none)
        {
            SkelControlHelper.SetSkelControlActive(false);
        }
        I++;
        // [Loop Continue]
        goto J0xAD;
    }
    //return;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        SetTimer(EquipTime * 0.5000000, false, 'RotateZamek');
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    bPurchasedWeaponDLC=false
    WeaponStatMP_Damage=3
    WeaponStatMP_Firerate=3
    WeaponStatMP_Accuracy=4
    WeaponStatMP_Magazines=3
    WeaponStatMP_ReloadSpeed=6
    EWeaponType=WeaponType.TYPE_Special
    ZoomedCrosshair=true
    BothHandWeapon=true
    bRecommendSplashDamage=true
    DefaultAmmoCount=18
    MaxAmmoCount=18
    MagazineAmmoCount=3
    MagazineMaxAmmoCount=3
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_FlareGun_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="FlareGun Rockets"
    ReloadTime=2.2000000
    InventoryGroup=2
    ZoomedMeshTranslation=(X=-5.0000000,Y=-4.5273000,Z=0.7725000)
    ZoomedMeshRotation=(Pitch=15,Yaw=314,Roll=0)
    ZoomedMeshScale=1.3238000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__AdvWeap_FlareGun_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_FlareGun_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="FlareGun"
    PlayerViewOffset=(X=37.9159000,Y=8.1975000,Z=-12.8134000)
    PlayerRotationOffset=(Pitch=353,Yaw=-1436,Roll=910)
    CurrentRating=0.3000000
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.3300000
    PutDownTime=0.3300000
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_FlareGun_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3000000
    ItemName="FlareGun"
    MaxDesireability=0.3000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_FlareGun_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}