class EvilWeap_MeleeHands extends EvilWeap_Melee_Base
    config(Weapon)
    hidecategories(Navigation);

simulated function Activate()
{
    super(EvilWeap_Base).Activate();
    //return;    
}

simulated function SetPlayingCustomAnim(bool bState)
{
    // End:0x32
    if(bState && !IsInState('Frozen'))
    {
        GotoState('Frozen');        
    }
    else
    {
        // End:0x61
        if(!bState && IsInState('Frozen'))
        {
            GotoState('Active');
        }
    }
    //return;    
}

simulated function HandleFinishedFiring()
{
    super(EvilWeap_Base).HandleFinishedFiring();
    //return;    
}

simulated function SetSpreadMoving(bool bState)
{
    local AnimNodeSequence AnimSeq;
    local EvilPawn P;

    super(EvilWeap_Base).SetSpreadMoving(bState);
    P = EvilPawn(Owner);
    // End:0x15D
    if(P != none)
    {
        AnimSeq = GetArmAnimNodeSeq();
        // End:0x142
        if(IsInState('Active') && (bState && !P.IsSprinting) && (AnimSeq.AnimSeqName != 'Arms_Walk') || !AnimSeq.bPlaying)
        {
            PlayArmAnim('Arms_Walk', 0.0000000, SprintAnimBlendTimes.BlendIn, SprintAnimBlendTimes.BlendOut, true);            
        }
        else
        {
            // End:0x15D
            if(IsInState('Active'))
            {
                RestartIdleAnim();
            }
        }
    }
    //return;    
}

simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
{
    EvilPawn(Owner).NotifyWeapQuickHideDone(self);
    return true;
    //return ReturnValue;    
}

simulated function bool ShouldLagRot()
{
    return false;
    //return ReturnValue;    
}

simulated state WeaponEquipping
{
    simulated function WeaponEquipped()
    {
        // End:0x19
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        GotoState('Active');
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function WeaponIsDown()
    {
        // End:0x24
        if(InvManager.CancelWeaponChange())
        {
            return;
        }
        DetachWeapon();
        GotoState('Inactive');
        // End:0x73
        if(int(GetHand()) == int(3))
        {
            EvilInvManager.ChangedWeaponLeft();            
        }
        else
        {
            // End:0x135
            if(int(GetHand()) == int(2))
            {
                // End:0x116
                if((EvilWeap_Base(EvilInvManager.PendingWeapon) == none) || EvilWeap_Base(EvilInvManager.PendingWeapon).BothHandWeapon)
                {
                    EvilInvManager.ChangedWeaponLeft();
                }
                EvilInvManager.ChangedWeapon();
            }
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function RestartIdleAnim(optional bool bInstant = false)
    {
        local AnimNodeSequence AnimSeq;

        AnimSeq = GetArmAnimNodeSeq();
        // End:0x3F
        if(!MoveSpreadState)
        {
            super.RestartIdleAnim(bInstant);            
        }
        else
        {
            // End:0xE4
            if((AnimSeq.AnimSeqName != 'Arms_Walk') || !AnimSeq.bPlaying)
            {
                PlayArmAnim('Arms_Walk', 0.0000000, SprintAnimBlendTimes.BlendIn, SprintAnimBlendTimes.BlendOut, true);
            }
        }
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function Tick(float DeltaTime)
    {
        super(EvilWeap_Base).Tick(DeltaTime);
        //return;        
    }
    stop;    
}

defaultproperties
{
    LockerAmmoCount=99
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_MeleeHands.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    bZoomedFireMode[0]=0
    bZoomedFireMode[1]=0
    InventoryGroup=99
    AttachmentClass=Class'EvilAttachment_Weap_MeleeHands'
    ArmIdleAnims[0]="Arms_Idle"
    IdleAnimBlendTimes=(BlendIn=0.5000000)
    SprintAnimBlendTimes=(BlendIn=0.5000000)
    // Reference: AudioComponent'Default__EvilWeap_MeleeHands.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    ArmSprintAnim="Arms_Sprint"
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_MeleeHands.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    CurrentRating=0.0000000
    AmmoCount=99
    WeaponFireTypes=/* Array type was not detected. */
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__EvilWeap_MeleeHands.FirstPersonMesh'
    begin object name=FirstPersonMesh
        Animations=AnimNodeSequence'Default__EvilWeap_MeleeHands.MeshSequenceA'
        ReplacementPrimitive=none
        DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_World
        bCastStaticShadow=false
    end object
    Mesh=FirstPersonMesh
    AIRating=0.0000000
    MaxDesireability=0.0000000
    // Reference: SkeletalMeshComponent'Default__EvilWeap_MeleeHands.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}