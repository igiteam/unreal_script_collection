class PKWeap_Shotgun_Base extends PainWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated function float GetCurrentSpread(byte FireModeNum)
{
    // End:0x3E
    if((int(FireModeNum) == int(0)) && HasWeaponModifier())
    {
        return super.GetCurrentSpread(FireModeNum) / 4.0000000;
    }
    return super.GetCurrentSpread(FireModeNum);
    //return ReturnValue;    
}

simulated event float GetTraceRange()
{
    // End:0x1F
    if(HasWeaponModifier())
    {
        return super(Weapon).GetTraceRange() * 1.5000000;
    }
    return super(Weapon).GetTraceRange();
    //return ReturnValue;    
}

simulated function InstantFire()
{
    local int I;
    local PKPlayerController PKPC;
    local array<Actor> UniqueKilledMonsters;
    local float CurrentTime;

    super(EvilWeap_Base).InstantFire();
    // End:0x6F
    if(NotEqual_InterfaceInterface(EvilPlayer_interface(Owner), EvilPlayer_interface(none)))
    {
        PKPC = PKPlayerController(EvilPlayer_interface(Owner).GetPC());
    }
    // End:0x1F7
    if(PKPC != none)
    {
        CurrentTime = WorldInfo.TimeSeconds;
        I = 0;
        J0xB1:

        // End:0x1C4 [Loop If]
        if(I < ActorHitWithCurrentShot.Length)
        {
            // End:0x1B6
            if(((PKPawn(ActorHitWithCurrentShot[I]) != none) && !PKPawn(ActorHitWithCurrentShot[I]).IsAliveAndWell()) && UniqueKilledMonsters.Find(ActorHitWithCurrentShot[I]) == -1)
            {
                // End:0x1B6
                if((CurrentTime - PKPawn(ActorHitWithCurrentShot[I]).TimeOfDeath) < 0.2000000)
                {
                    UniqueKilledMonsters.AddItem(ActorHitWithCurrentShot[I]);
                }
            }
            I++;
            // [Loop Continue]
            goto J0xB1;
        }
        // End:0x1F7
        if(UniqueKilledMonsters.Length >= 3)
        {
            PKPC.ClientUnlockAchievement(64);
        }
    }
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        super.BeginFire(FireModeNum);
        // End:0x6B
        if(((int(FireModeNum) > int(0)) || int(FireModeNum) == int(CurrentFireMode)) || MagazineAmmoCount < ShotCost[int(FireModeNum)])
        {
            return;
        }
        HandleFinishedFiring();
        //return;        
    }
    stop;    
}

defaultproperties
{
    bPurchasedWeaponDLC=true
    MaxAmmoAltCount=100
    LowAmmoCountWarningThreshold=7
    LowAmmoAltCountWarningThreshold=5
    MaxAmmoCount=100
    WeaponHitRange=4650.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    NumberOfShots=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Shotgun_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=2
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_Shotgun_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Shotgun_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Shotgun"
    CurrentRating=0.8000000
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.0100000
    PutDownTime=0.0100000
    bInstantHit=true
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Shotgun_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.8000000
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_Shotgun_Base.PickupMesh'
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