class AdvWeap_Gew98_Base extends AdvWeap_3PhaseReload_Base
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
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x31
        if((int(CurrentFireMode) != int(0)) && CheckZoom(FireModeNum))
        {
            return;            
        }
        else
        {
            // End:0x8F
            if((int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
            {
                // End:0x8D
                if(int(ZoomedFireModeNum) < int(255))
                {
                    ZoomedFireModeNum = 255;
                }
                return;
            }
        }
        global.BeginFire(FireModeNum);
        // End:0xE4
        if(!HasShareAmmo(FireModeNum) && int(FireModeNum) == int(CurrentFireMode))
        {
            WeaponEmpty();
            return;
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xB1
        if(((int(CurrentFireMode) == int(0)) && PC != none) && int(GetZoomedState()) == int(3))
        {
            EndZoom(PC);
            // End:0xB1
            if(int(Role) < int(ROLE_Authority))
            {
                ServerEndZoom(PC);
            }
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xD3
        if((((int(CurrentFireMode) == int(0)) && MagazineAmmoCount > 0) && PC != none) && int(ZoomedFireModeNum) < int(255))
        {
            StartZoom(PC, ZoomedFireModeNum);
            // End:0xD3
            if(int(Role) < int(ROLE_Authority))
            {
                ServerStartZoom(PC, ZoomedFireModeNum);
            }
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AudioComponent'Default__AdvWeap_Gew98_Base.ReloadSoundLoopComp'
    begin object name=ReloadSoundLoopComp
    end object
    ReloadSoundLoop=ReloadSoundLoopComp
    // Reference: AudioComponent'Default__AdvWeap_Gew98_Base.ReloadSoundEndComp'
    begin object name=ReloadSoundEndComp
    end object
    ReloadSoundEnd=ReloadSoundEndComp
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Gew98_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__AdvWeap_Gew98_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Gew98_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Gew98_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Gew98_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
    Components[2]=ReloadSoundLoopComp
    Components[3]=ReloadSoundEndComp
}