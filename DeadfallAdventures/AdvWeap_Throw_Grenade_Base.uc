class AdvWeap_Throw_Grenade_Base extends EvilWeap_Throw_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated function Activate()
{
    local AdvPlayerPawnMP P;

    P = AdvPlayerPawnMP(Owner);
    // End:0xBA
    if(P != none)
    {
        P.PlayShoutSound(class<AdvFamilyInfo_MP_Hero_Base>(AdvPRI(P.Controller.PlayerReplicationInfo).static.GetCharClassInfo()).default.GrenadeShouts);
    }
    super(EvilWeap_Melee_Base).Activate();
    //return;    
}

defaultproperties
{
    MaxHoldTime=4.0000000
    BothHandWeapon=true
    bSplashJump=true
    bRecommendSplashDamage=true
    DefaultAmmoCount=1
    MaxAmmoCount=5
    WeaponDamage=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Throw_Grenade_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=50
    // Reference: AudioComponent'Default__AdvWeap_Throw_Grenade_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Throw_Grenade_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Grenade"
    PlayerViewOffset=(X=14.0000000,Y=-6.0000000,Z=-4.0000000)
    CurrentRating=0.0000000
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.2000000
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Throw_Grenade_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.0000000
    ItemName="Grenade"
    MaxDesireability=0.0000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Throw_Grenade_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}