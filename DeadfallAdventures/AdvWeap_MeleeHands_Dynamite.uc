class AdvWeap_MeleeHands_Dynamite extends EvilWeap_MeleeHands
    config(Weapon)
    hidecategories(Navigation);

simulated function SetSpreadMoving(bool bState)
{
    super(EvilWeap_Base).SetSpreadMoving(bState);
    //return;    
}

simulated state Active
{
    ignores RestartIdleAnim;
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        local SkelControlBase SkelControl;

        super.BeginState(PreviousStateName);
        SkelControl = UDKSkeletalMeshComponent(Mesh).FindSkelControl('Dynamit');
        // End:0x7D
        if(SkelControl != none)
        {
            SkelControl.SetSkelControlActive(true);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_MeleeHands_Dynamite.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    ArmsAnimSet=AnimSet'wp_dynamite_01.Anim.as_wp_dynamite_hands'
    // Reference: AudioComponent'Default__AdvWeap_MeleeHands_Dynamite.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_MeleeHands_Dynamite.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    PlayerViewOffset=(X=10.0000000,Y=5.0000000,Z=-5.0000000)
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_MeleeHands_Dynamite.FirstPersonMesh'
    begin object name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'wp_dynamite_01.Mesh.sk_wp_dynamite_01'
        AnimTreeTemplate=AnimTree'wp_dynamite_01.Anim.at_wp_dynamite_01'
        Animations=none
        AnimSets[0]=AnimSet'wp_dynamite_01.Anim.as_wp_dynamite_01'
        ReplacementPrimitive=none
        DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_Foreground
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_MeleeHands_Dynamite.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}