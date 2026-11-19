class PKWeap_Stakegun_Base extends PainWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var array< class<Projectile> > WeaponModifierProjectiles;

simulated function Projectile ProjectileFire()
{
    // End:0x1E
    if(int(CurrentFireMode) == int(0))
    {
        HideStake();
    }
    // End:0x41
    if(HasWeaponModifier())
    {
        WeaponProjectiles = WeaponModifierProjectiles;        
    }
    else
    {
        WeaponProjectiles = default.WeaponProjectiles;
    }
    return super(EvilWeap_Base).ProjectileFire();
    //return ReturnValue;    
}

simulated function ShowStake()
{
    local SkelControlSingleBone SkelControl;

    SkelControl = SkelControlSingleBone(SkeletalMeshComponent(Mesh).FindSkelControl('kolek'));
    // End:0x84
    if((SkelControl != none) && AmmoCount > 0)
    {
        SkelControl.SetSkelControlActive(false);
    }
    //return;    
}

simulated function HideStake()
{
    local SkelControlSingleBone SkelControl;

    SkelControl = SkelControlSingleBone(SkeletalMeshComponent(Mesh).FindSkelControl('kolek'));
    // End:0x73
    if(SkelControl != none)
    {
        SkelControl.SetSkelControlActive(true);
    }
    //return;    
}

function int AddAmmoForFireMode(byte FireModeNum, int Amount)
{
    local int OldAmmoCount, Result;

    OldAmmoCount = AmmoCount;
    Result = super.AddAmmoForFireMode(FireModeNum, Amount);
    // End:0x79
    if(((int(FireModeNum) == int(0)) && OldAmmoCount <= 0) && Amount > 0)
    {
        ShowStake();
    }
    return Result;
    //return ReturnValue;    
}

function ConsumeAmmo(byte FireModeNum)
{
    local PainWeap_Base ShareWeap;

    super.ConsumeAmmo(FireModeNum);
    ShareWeap = PainWeap_Base(Instigator.InvManager.FindInventoryType(Class'PKWeap_Chaingun_Base', true));
    // End:0xD0
    if(((int(FireModeNum) == int(1)) && Instigator.Weapon == self) && ShareWeap != none)
    {
        ShareWeap.ConsumeAmmo(0);
    }
    //return;    
}

simulated function FireAmmunition()
{
    local PKPlayerController PKPC;

    super.FireAmmunition();
    // End:0xB2
    if(NotEqual_InterfaceInterface(EvilPlayer_interface(Owner), EvilPlayer_interface(none)))
    {
        PKPC = PKPlayerController(EvilPlayer_interface(Owner).GetPC());
        // End:0xB2
        if(PKPC != none)
        {
            // End:0xB2
            if(int(CurrentFireMode) == int(0))
            {
                ++PKPC.StakeGunShots;
            }
        }
    }
    //return;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        ShowStake();
        //return;        
    }
    stop;    
}

defaultproperties
{
    bPurchasedWeaponDLC=true
    MaxAmmoAltCount=100
    LowAmmoCountWarningThreshold=5
    LowAmmoAltCountWarningThreshold=5
    SplitScreenPlayerViewOffset=(X=-30.0000000,Y=0.0000000,Z=-15.0000000)
    MaxAmmoCount=100
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Stakegun_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=3
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_Stakegun_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Stakegun_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Stakegun"
    CurrentRating=0.8000000
    WeaponFireTypes=/* Array type was not detected. */
    EquipTime=0.0100000
    PutDownTime=0.0100000
    FireOffset=(X=20.0000000,Y=0.0000000,Z=-7.0000000)
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Stakegun_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.8000000
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_Stakegun_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__PainWeap_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}