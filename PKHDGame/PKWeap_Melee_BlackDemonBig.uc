class PKWeap_Melee_BlackDemonBig extends EvilWeap_Melee_HumanMelee
    config(Weapon)
    hidecategories(Navigation);

simulated function DoMeleeDamage(float DamageScale, optional Actor Target = none, optional Vector HitLocaltion = vect(0.0000000, 0.0000000, 0.0000000))
{
    local PKPawn_BlackDemon_Base BlackDemonPawn;

    BlackDemonPawn = PKPawn_BlackDemon_Base(Instigator);
    // End:0x122
    if(BlackDemonPawn != none)
    {
        // End:0x122
        if(BlackDemonPawn.bShouldEarthQuakeAttack)
        {
            // End:0x122
            if(BlackDemonPawn.MyPKAI != none)
            {
                BlackDemonPawn.MyPKAI.Enemy.TakeDamage(int(float(2) * DamageScale), Instigator.Controller, HitLocaltion, vect(0.0000000, 0.0000000, 0.0000000), InstantHitDamageTypes[0],, self);
            }
        }
    }
    super(EvilWeap_Melee_Base).DoMeleeDamage(DamageScale, Target, HitLocaltion);
    //return;    
}

defaultproperties
{
    WeaponHitRange=600.0000000
    WeaponDamage=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Melee_BlackDemonBig.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilWeap_Melee_HumanMelee.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__PKWeap_Melee_BlackDemonBig.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Melee_BlackDemonBig.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Melee_BlackDemonBig.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__PKWeap_Melee_BlackDemonBig.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}