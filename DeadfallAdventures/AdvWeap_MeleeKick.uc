class AdvWeap_MeleeKick extends EvilWeap_Melee_Base
    config(Weapon)
    hidecategories(Navigation);

var() array<name> KickAnims;

function bool ShouldSaveForCheckpoint()
{
    return false;
    //return ReturnValue;    
}

function bool ShouldSaveBetweenLevels()
{
    return false;
    //return ReturnValue;    
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    local name Anim;

    Anim = KickAnims[Rand(KickAnims.Length)];
    PlayWeaponAnim(Anim, GetFireInterval(CurrentFireMode), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut);
    CauseMuzzleFlash();
    ShakeView();
    //return;    
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    local EvilPawn UTP;
    local editinline SkeletalMeshComponent SkelMesh;

    UTP = EvilPawn(Instigator);
    SkelMesh = SkeletalMeshComponent(Mesh);
    // End:0xBA
    if(Instigator.IsFirstPerson())
    {
        AttachComponent(Mesh);
        EnsureWeaponOverlayComponentLast();
        SetHidden(true);
        bPendingShow = true;
        Mesh.SetLightEnvironment(LightEnvironment);        
    }
    else
    {
        SetHidden(true);
        // End:0xFC
        if(UTP != none)
        {
            Mesh.SetLightEnvironment(LightEnvironment);
        }
    }
    SetWeaponOverlayFlags(UTP);
    // End:0x21E
    if((int(Role) == int(ROLE_Authority)) && UTP != none)
    {
        UTP.CurrentMeleeWeaponAttachmentClass = AttachmentClass;
        // End:0x21E
        if(((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_Client)) && Instigator.IsLocallyControlled())
        {
            UTP.WeaponMeleeAttachmentChanged();
        }
    }
    SetSkin(EvilPawn(Instigator).ReplicatedBodyMaterial);
    // End:0x2A2
    if(SkelMesh != none)
    {
        // End:0x28F
        if(SkelMesh.Animations != none)
        {
            UpdateAnimNodeReferences();            
        }
        else
        {
            SetTimer(0.1000000, false, 'UpdateAnimNodeReferences');
        }
    }
    //return;    
}

simulated function PerformWeaponChange()
{
    //return;    
}

simulated function SetupArmsAnim()
{
    //return;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;
        local int I;

        PC = EvilPlayerController(Instigator.Controller);
        // End:0xE5
        if(PC != none)
        {
            // End:0x8C
            if(LocalPlayer(PC.Player) != none)
            {
                PC.EndZoom();
            }
            EndZoomInstant(PC);
            // End:0xE5
            if(PuttingDownCameraAnim != none)
            {
                PC.PlayCameraAnim(PuttingDownCameraAnim,,, 0.2000000, 0.2000000);
            }
        }
        TimeWeaponPutDown();
        bWeaponPutDown = false;
        I = 0;
        J0x106:

        // End:0x155 [Loop If]
        if(I < AfterShotEffectComponent.Length)
        {
            AfterShotEffectComponent[I].DeactivateSystem();
            I++;
            // [Loop Continue]
            goto J0x106;
        }
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        EvilPawn(Instigator).EndMeleeKick();
        //return;        
    }
    stop;    
}

defaultproperties
{
    KickAnims[0]="WeaponFire1"
    ForceTossZ=0.7000000
    ForceTossZPhys=30.0000000
    ShouldBeRestored=false
    LockerAmmoCount=99
    WeaponHitRange=200.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_MeleeKick.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=99
    AttachmentClass=Class'AdvAttachment_Weap_MeleeKick'
    // Reference: AudioComponent'Default__AdvWeap_MeleeKick.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_MeleeKick.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    CurrentRating=0.0000000
    AmmoCount=99
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_MeleeKick.FirstPersonMesh'
    begin object name=FirstPersonMesh
        Animations=AnimNodeSequence'Default__AdvWeap_MeleeKick.MeshSequenceA'
        ReplacementPrimitive=none
        DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_World
        bCastStaticShadow=false
    end object
    Mesh=FirstPersonMesh
    AIRating=0.0000000
    MaxDesireability=0.0000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_MeleeKick.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}