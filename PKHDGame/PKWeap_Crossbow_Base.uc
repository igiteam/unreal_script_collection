class PKWeap_Crossbow_Base extends PainWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var(Effects) ParticleSystem BoltFireEffect;
var(Effects) name BoltFireEffectSocket;
var export editinline UTParticleSystemComponent BoltFireEffectComponent;

function int AddAmmo(int Amount)
{
    local int iAmmo;

    iAmmo = super(EvilWeap_Base).AddAmmo(Amount);
    UpdateArrows();
    return iAmmo;
    //return ReturnValue;    
}

simulated function MoveRailUp()
{
    MoveRail(true, 1);
    //return;    
}

simulated function bool ShouldRefire()
{
    StopFire(CurrentFireMode);
    return false;
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated function MoveRail(bool Up, int Levels, optional bool Instant = false)
{
    local array<SkelControlSingleBone> RailControls;
    local SkelControlSingleBone RailControl;
    local int I;

    I = 0;
    J0x10:

    // End:0xA7 [Loop If]
    if(I < 3)
    {
        RailControl = SkelControlSingleBone(SkeletalMeshComponent(Mesh).FindSkelControl(name("szyna" $ string(I + 1))));
        // End:0x99
        if(RailControl != none)
        {
            RailControls.AddItem(RailControl);
        }
        I++;
        // [Loop Continue]
        goto J0x10;
    }
    // End:0x29D
    if(RailControls.Length == 3)
    {
        // End:0x1AE
        if(Up)
        {
            I = 0;
            J0xD0:

            // End:0x1AB [Loop If]
            if(I < 3)
            {
                // End:0x113
                if(RailControls[I].ControlStrength > float(0))
                {                    
                }
                else
                {
                    // End:0x156
                    if(Instant)
                    {
                        RailControls[I].SetSkelControlStrength(1.0000000, 0.0000000);                        
                    }
                    else
                    {
                        RailControls[I].SetSkelControlActive(true);
                    }
                    --Levels;
                    // End:0x19D
                    if(Levels == 0)
                    {
                        // [Explicit Break]
                        goto J0x1AB;
                    }
                }
                I++;
                // [Loop Continue]
                goto J0xD0;
            }
            J0x1AB:
            
        }
        else
        {
            I = 3;
            J0x1BA:

            // End:0x29D [Loop If]
            if(I > 0)
            {
                // End:0x1FF
                if(RailControls[I - 1].ControlStrength < float(1))
                {                    
                }
                else
                {
                    // End:0x245
                    if(Instant)
                    {
                        RailControls[I - 1].SetSkelControlStrength(0.0000000, 0.0000000);                        
                    }
                    else
                    {
                        RailControls[I - 1].SetSkelControlActive(false);
                    }
                    --Levels;
                    // End:0x28F
                    if(Levels == 0)
                    {
                        // [Explicit Break]
                        goto J0x29D;
                    }
                }
                I--;
                // [Loop Continue]
                goto J0x1BA;
            }
        }
    }
    J0x29D:

    //return;    
}

simulated function UpdateArrows(optional bool HideAll = false)
{
    local array<SkelControlSingleBone> ArrowControls;
    local SkelControlSingleBone ArrowControl;
    local int I;

    I = 0;
    J0x10:

    // End:0xD4 [Loop If]
    if(I < 4)
    {
        ArrowControl = SkelControlSingleBone(SkeletalMeshComponent(Mesh).FindSkelControl(name(string(I + 1))));
        // End:0xC6
        if(ArrowControl != none)
        {
            // End:0xB0
            if(HideAll)
            {
                ArrowControl.SetSkelControlStrength(1.0000000, 0.0000000);
            }
            ArrowControls.AddItem(ArrowControl);
        }
        I++;
        // [Loop Continue]
        goto J0x10;
    }
    // End:0xE3
    if(HideAll)
    {
        return;
    }
    // End:0x250
    if(ArrowControls.Length > 0)
    {
        // End:0x181
        if((MagazineAmmoCount >= ArrowControls.Length) || IsReloading())
        {
            I = 0;
            J0x125:

            // End:0x17E [Loop If]
            if(I < ArrowControls.Length)
            {
                ArrowControls[I].SetSkelControlStrength(0.0000000, 0.0000000);
                I++;
                // [Loop Continue]
                goto J0x125;
            }            
        }
        else
        {
            I = 0;
            J0x18C:

            // End:0x1E4 [Loop If]
            if(I < MagazineAmmoCount)
            {
                ArrowControls[I].SetSkelControlStrength(0.0000000, 0.0000000);
                I++;
                // [Loop Continue]
                goto J0x18C;
            }
            I = MagazineAmmoCount;
            J0x1F7:

            // End:0x250 [Loop If]
            if(I < ArrowControls.Length)
            {
                ArrowControls[I].SetSkelControlStrength(1.0000000, 0.0000000);
                I++;
                // [Loop Continue]
                goto J0x1F7;
            }
        }
    }
    //return;    
}

simulated state ReloadState
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        UpdateArrows(true);
        SetTimer(FMax(((SkeletalMeshComponent(Mesh).GetAnimLength(WeaponReloadAnim) / SkeletalMeshComponent(Mesh).FindAnimSequence(WeaponReloadAnim).RateScale) * 0.3000000) - ReloadResumeTime, 0.0010000), false, 'UpdateArrows');
        MoveRail(false, 3);
        // End:0xFA
        if(BoltFireEffectComponent != none)
        {
            BoltFireEffectComponent.DeactivateSystem();
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x42
        if(BoltFireEffectComponent != none)
        {
            BoltFireEffectComponent.ActivateSystem();
        }
        //return;        
    }
    stop;    
}

simulated state SprintReloadState
{
    simulated event PushedState()
    {
        // End:0xC0
        if(!IsTimerActive('ReloadTimer'))
        {
            UpdateArrows(true);
            SetTimer((SkeletalMeshComponent(Mesh).GetAnimLength(WeaponReloadAnim) / SkeletalMeshComponent(Mesh).FindAnimSequence(WeaponReloadAnim).RateScale) * 0.3000000, false, 'UpdateArrows');
            MoveRail(false, 3);
        }
        // End:0xEE
        if(BoltFireEffectComponent != none)
        {
            BoltFireEffectComponent.DeactivateSystem();
        }
        super(Object).PushedState();
        //return;        
    }

    simulated event PoppedState()
    {
        super(Object).PoppedState();
        // End:0x39
        if(BoltFireEffectComponent != none)
        {
            BoltFireEffectComponent.ActivateSystem();
        }
        //return;        
    }
    stop;    
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
        if(!HasAmmo(FireModeNum) && int(FireModeNum) == int(CurrentFireMode))
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
        // End:0x111
        if(BoltFireEffectComponent != none)
        {
            BoltFireEffectComponent.DeactivateSystem();
            BoltFireEffectComponent.KillParticlesForced();
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xCA
        if((((int(CurrentFireMode) == int(0)) && MagazineAmmoCount > 0) && PC != none) && int(ZoomedFireModeNum) < int(255))
        {
            StartZoom(PC);
            // End:0xCA
            if(int(Role) < int(ROLE_Authority))
            {
                ServerStartZoom(PC, ZoomedFireModeNum);
            }
        }
        super.EndState(NextStateName);
        // End:0x11D
        if((BoltFireEffectComponent != none) && MagazineAmmoCount > 0)
        {
            BoltFireEffectComponent.ActivateSystem();
        }
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x10E
        if(BoltFireEffectComponent == none)
        {
            BoltFireEffectComponent = new (Outer) Class'EvilGame.UTParticleSystemComponent';
            BoltFireEffectComponent.SetTemplate(BoltFireEffect);
            BoltFireEffectComponent.SetDepthPriorityGroup(2);
            BoltFireEffectComponent.SetFOV(UDKSkeletalMeshComponent(Mesh).FOV);
            UDKSkeletalMeshComponent(Mesh).AttachComponentToSocket(BoltFireEffectComponent, BoltFireEffectSocket);            
        }
        else
        {
            // End:0x155
            if(!BoltFireEffectComponent.bIsActive)
            {
                BoltFireEffectComponent.ActivateSystem();                
            }
            else
            {
                BoltFireEffectComponent.DeactivateSystem();
                BoltFireEffectComponent.ActivateSystem();
            }
        }
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function EndState(name NextStateName)
    {
        // End:0x2E
        if(BoltFireEffectComponent != none)
        {
            BoltFireEffectComponent.DeactivateSystem();
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Crossbow_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__PKWeap_Crossbow_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Crossbow_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Crossbow_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__PKWeap_Crossbow_Base.PickupMesh'
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