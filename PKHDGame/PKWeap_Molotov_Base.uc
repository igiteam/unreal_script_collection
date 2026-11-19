class PKWeap_Molotov_Base extends EvilWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated function bool ShouldRefire()
{
    return false;
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super.HandleFinishedFiring();
    //return;    
}

simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
{
    return true;
    //return ReturnValue;    
}

simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
    return InstantFireStartTrace();
    //return ReturnValue;    
}

state ReloadState
{
    simulated function BeginState(name PreviousStateName)
    {
        ReloadAmmo();
        NeedReload = false;
        GotoState('Active');
        //return;        
    }
    stop;    
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
        if(!HasAmmo(FireModeNum) && int(FireModeNum) == int(CurrentFireMode))
        {
            WeaponEmpty();
            return;
        }
        // End:0xC5
        if(((int(FireModeNum) == int(1)) || int(FireModeNum) != int(CurrentFireMode)) || MagazineAmmoCount < ShotCost[int(FireModeNum)])
        {
            return;
        }
        FireAmmunition();
        SetTimer(GetFireInterval(FireModeNum), true, 'RefireCheckTimer');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Molotov_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    ReloadTime=0.1000000
    InventoryGroup=1
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_Molotov_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'EvilGame.Default__EvilWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Molotov_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Molotov"
    CurrentRating=0.3000000
    AmmoCount=200
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.1000000
    PutDownTime=0.1000000
    bInstantHit=true
    WeaponRange=16384.0000000
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Molotov_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'EvilGame.Default__EvilWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3000000
    MaxDesireability=0.3000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_Molotov_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilWeap_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}