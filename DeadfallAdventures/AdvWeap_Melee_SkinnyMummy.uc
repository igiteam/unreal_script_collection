class AdvWeap_Melee_SkinnyMummy extends AdvWeap_Melee_Mummy
    config(Weapon)
    hidecategories(Navigation);

var config float SurvivalDamageMod;

simulated function PostBeginPlay()
{
    local int I;

    // End:0x8F
    if(EvilGameReplicationInfo(WorldInfo.GRI).IsSurvivalGame())
    {
        I = 0;
        J0x4B:

        // End:0x8F [Loop If]
        if(I < WeaponDamage.Length)
        {
            WeaponDamage[I] *= SurvivalDamageMod;
            I++;
            // [Loop Continue]
            goto J0x4B;
        }
    }
    super(EvilWeap_Melee_Base).PostBeginPlay();
    //return;    
}

defaultproperties
{
    SurvivalDamageMod=2.5000000
    WeaponHitRange=200.0000000
    WeaponDamage=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Melee_SkinnyMummy.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__AdvWeap_Melee_SkinnyMummy.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Melee_SkinnyMummy.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Melee_SkinnyMummy.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Melee_SkinnyMummy.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}