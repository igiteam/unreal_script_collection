class EvilPlayerPawn extends EvilPawn
    config(Pawn)
    hidecategories(Navigation)
    implements(EvilPlayer_interface);

var() config float AutoRecoveryDelay;
var float LowHealthAmbientThreshold;
var delegate<OnArmAnimEnd> OnLeftArmAnimEndDelegate;
var delegate<OnArmAnimEnd> OnRightArmAnimEndDelegate;
var SkelControlSingleBone LeanController;
//var delegate<OnArmAnimEnd> __OnArmAnimEnd__Delegate;

function EvilPawn GetPlayerPawn()
{
    return self;
    //return ReturnValue;    
}

function EvilPlayerController GetPC()
{
    return EvilPlayerController(Controller);
    //return ReturnValue;    
}

delegate OnArmAnimEnd(bool RightHand, optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    //return;    
}

function SetOnArmAnimEndDelegate(delegate<OnArmAnimEnd> InDelegate, bool bLeftArm)
{
    // End:0x6A
    if(bLeftArm)
    {
        // End:0x54
        if(InDelegate != OnLeftArmAnimEndDelegate && OnLeftArmAnimEndDelegate != none)
        {
            OnArmAnimEnd(true, none, 0.0000000, 0.0000000);
        }
        OnLeftArmAnimEndDelegate = InDelegate;        
    }
    else
    {
        // End:0xB1
        if(InDelegate != OnRightArmAnimEndDelegate && OnRightArmAnimEndDelegate != none)
        {
            OnArmAnimEnd(true, none, 0.0000000, 0.0000000);
        }
        OnRightArmAnimEndDelegate = InDelegate;
    }
    //return;    
}

function ResetOnArmAnimEndDelegate(bool bLeftHand)
{
    // End:0x2B
    if(bLeftHand)
    {
        OnLeftArmAnimEndDelegate = None;        
    }
    else
    {
        OnRightArmAnimEndDelegate = None;
    }
    //return;    
}

function Weapon GetWeaponLeft()
{
    return WeaponLeft;
    //return ReturnValue;    
}

function Weapon GetWeapon()
{
    return Weapon;
    //return ReturnValue;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

simulated function SetCharacterClassFromInfo(class<EvilFamilyInfoBase> Info)
{
    super(UTPawn).SetCharacterClassFromInfo(Info);
    DressUp();
    //return;    
}

simulated function StartReload()
{
    // End:0x25
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(21,,, GetReloadAnimPackedIndex());
    }
    //return;    
}

simulated function StartEquipWeapon()
{
    // End:0x25
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(22,,, GetEquipAnimIndex());
    }
    //return;    
}

simulated function StartHideWeapon()
{
    // End:0x25
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(23,,, GetHideAnimIndex());
    }
    //return;    
}

simulated function DoMelee()
{
    super.DoMelee();
    // End:0x2F
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(24,,, GetMeleeAnimIndex());
    }
    //return;    
}

simulated function DoMeleeKick()
{
    super.DoMeleeKick();
    // End:0x2F
    if(IsLocallyControlled())
    {
        LocalDoPawnAction(6,,, GetKickAnimIndex());
    }
    //return;    
}

function int GetEquipAnimIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0xAC
    if(EvilWeap_Base(Weapon) != none)
    {
        switch(EvilWeap_Base(Weapon).default.AttachmentClass.default.WeapAnimType)
        {
            // End:0x72
            case 0:
                AST = 63;
                // End:0x98
                break;
            // End:0x86
            case 1:
                AST = 64;
                // End:0x98
                break;
            // End:0xFFFF
            default:
                AST = 63;
                // End:0x98
                break;
                break;
        }
        return PackRandomAnimInfo(AST);
    }
    return 0;
    //return ReturnValue;    
}

function int GetHideAnimIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x85
    if(CurrentWeaponAttachment != none)
    {
        switch(CurrentWeaponAttachment.WeapAnimType)
        {
            // End:0x4B
            case 0:
                AST = 65;
                // End:0x71
                break;
            // End:0x5F
            case 1:
                AST = 66;
                // End:0x71
                break;
            // End:0xFFFF
            default:
                AST = 65;
                // End:0x71
                break;
                break;
        }
        return PackRandomAnimInfo(AST);
    }
    return 0;
    //return ReturnValue;    
}

function int GetReloadAnimPackedIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x85
    if(CurrentWeaponAttachment != none)
    {
        switch(CurrentWeaponAttachment.WeapAnimType)
        {
            // End:0x4B
            case 0:
                AST = 55;
                // End:0x71
                break;
            // End:0x5F
            case 1:
                AST = 62;
                // End:0x71
                break;
            // End:0xFFFF
            default:
                AST = 55;
                // End:0x71
                break;
                break;
        }
        return PackRandomAnimInfo(AST);
    }
    return 0;
    //return ReturnValue;    
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
    // End:0x3F
    if(int(Physics) == int(9))
    {
        NewRotation = OnLadder.WallDir;        
    }
    else
    {
        // End:0xF1
        if((int(Physics) == int(1)) || int(Physics) == int(2))
        {
            // End:0xD3
            if((IsZero(Velocity) && TurnInPlaceNode != none) && !bPlayingTurnTransition)
            {
                NewRotation.Yaw = Rotation.Yaw;
            }
            NewRotation.Pitch = 0;
        }
    }
    NewRotation.Roll = Rotation.Roll;
    NewRotation = RLerp(Rotation, NewRotation, DeltaTime * 10.0000000, true);
    SetRotation(NewRotation);
    //return;    
}

function ParticleSystem GetSpecificFootStepEffect(EvilPhysicalMaterialPropertyBase FootstepSounds, int FootDown)
{
    return none;
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    local EvilPlayerController PC;

    super.Tick(DeltaTime);
    PC = GetPlayerController();
    // End:0x1CB
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && PC != none)
    {
        // End:0xDE
        if(float(Health) < (0.5000000 * DefaultHealth))
        {
            // End:0xDB
            if(!PC.GetPPManager().PulseEffectsActive())
            {
                PlayClientPulseEffects(float(Health) / DefaultHealth);
            }            
        }
        else
        {
            // End:0x120
            if(PC.GetPPManager().PulseEffectsActive())
            {
                StopClientPulseEffects();
            }
        }
        // End:0x18A
        if(float(Health) < (LowHealthAmbientThreshold * DefaultHealth))
        {
            // End:0x187
            if(!PC.IsLowHealthAmbientPlaying())
            {
                PC.ClientPlayLowHealthAmbient();
            }            
        }
        else
        {
            // End:0x1CB
            if(PC.IsLowHealthAmbientPlaying())
            {
                PC.ClientStopLowHealthAmbient();
            }
        }
    }
    // End:0x22A
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x22A
        if((float(Health) < DefaultHealth) && !IsTimerActive('HealthRecovery_T'))
        {
            SetTimer(AutoRecoveryDelay, true, 'HealthRecovery_T');
        }
    }
    // End:0x309
    if(LeanController != none)
    {
        // End:0x298
        if(LeanController.ControlStrength ~= 0.0000000)
        {
            // End:0x295
            if(int(CurrentLeanState) != int(0))
            {
                LeanController.SetSkelControlActive(true);
            }            
        }
        else
        {
            // End:0x2CC
            if(int(CurrentLeanState) == int(0))
            {
                LeanController.SetSkelControlActive(false);
            }
            LeanController.BoneRotation.Roll = int(CurrLeanRotVal);
        }
    }
    //return;    
}

simulated function WeaponAttachmentChanged()
{
    super.WeaponAttachmentChanged();
    StartEquipWeapon();
    //return;    
}

function HealthRecovery_T()
{
    // End:0x31
    if(float(Health) < DefaultHealth)
    {
        HealDamage(1, Controller, none);        
    }
    else
    {
        ClearTimer('HealthRecovery_T');
    }
    //return;    
}

simulated function EvilPlayerController GetPlayerController()
{
    // End:0x25
    if(Controller != none)
    {
        return EvilPlayerController(Controller);        
    }
    else
    {
        // End:0x5C
        if(DrivenVehicle != none)
        {
            return EvilPlayerController(DrivenVehicle.Controller);
        }
    }
    return none;
    //return ReturnValue;    
}

reliable client simulated function PlayClientPulseEffects(float Damage)
{
    GetPlayerController().GetPlayerHitEffects().PlayPulseEffects(Damage);
    //return;    
}

reliable client simulated function StopClientPulseEffects()
{
    GetPlayerController().GetPlayerHitEffects().StopPulseEffects();
    //return;    
}

reliable client simulated function PlayClientHitEffects(float Damage)
{
    GetPlayerController().GetPlayerHitEffects().ProcessHitEffects(Damage);
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    super.PlayDying(DamageType, HitLoc);
    //return;    
}

function IgnoreDamage_T()
{
    bDamageCanBeIgnored = false;
    //return;    
}

function ReduceDamage(out int Damage, const out Controller EventInstigator, class<DamageType> DamageType)
{
    // End:0x3B
    if(IsTimerActive('IgnoreDamage_T'))
    {
        Damage = int(float(Damage) * ReduceDamageFactor);
        return;
    }
    // End:0x67
    if(Health > int(DefaultHealth * 0.5000000))
    {
        bDamageCanBeIgnored = true;
    }
    // End:0xBC
    if((float(Health - Damage) < (DefaultHealth * ReduceDamagePercentage)) && bDamageCanBeIgnored)
    {
        SetTimer(IgnoreDamageTimer, false, 'IgnoreDamage_T');
    }
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Pawn InstigatedByPawn;

    InstigatedByPawn = ((EventInstigator != none) ? EventInstigator.Pawn : none);
    // End:0xA8
    if(((GetPlayerController()) != none) && !(InstigatedByPawn != none) && int(GetTeamNum()) == int(InstigatedByPawn.GetTeamNum()))
    {
        PlayClientHitEffects(float(Damage));
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function OnDoPawnAction(SeqAct_DoPawnAction Action)
{
    //return;    
}

simulated function Burn(float InTotalTime, float InDamageInterval, float InDamageAmount, optional bool bMaterialsBlackEffects = true, optional bool bMaterialsDotEffects = true, optional bool bResetActualBlackMaterialValue = true, optional bool bResetActualDotsMaterialValue = true)
{
    //return;    
}

simulated function PlayMeleeImpacts(Vector HitLocation)
{
    // End:0x22
    if(!IsLocallyControlled())
    {
        super.PlayMeleeImpacts(HitLocation);
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x42
    if(EvilPlayerController(Controller) != none)
    {
        EvilPlayerController(Controller).SetButtonFilter(false);
    }
    // End:0x71
    if(BaseSkeletalMeshComp != none)
    {
        BaseSkeletalMeshComp.SetOwnerNoSee(false);
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function ThrowWeaponOnDeath()
{
    //return;    
}

function DamagedSomeone(int InDamage, Pawn InVictim)
{
    //return;    
}

simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    // End:0x56
    if(ArmsMesh[0] == SeqNode.SkelComponent)
    {
        OnRightHandAnimEnd(SeqNode, PlayedTime, ExcessTime);        
    }
    else
    {
        // End:0xA9
        if(ArmsMesh[1] == SeqNode.SkelComponent)
        {
            OnLeftHandAnimEnd(SeqNode, PlayedTime, ExcessTime);
        }
    }
    //return;    
}

simulated event OnRightHandAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    // End:0x41
    if(OnRightArmAnimEndDelegate != none)
    {
        OnArmAnimEnd(true, SeqNode, PlayedTime, ExcessTime);
    }
    //return;    
}

simulated event OnLeftHandAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    // End:0x41
    if(OnLeftArmAnimEndDelegate != none)
    {
        OnArmAnimEnd(false, SeqNode, PlayedTime, ExcessTime);
    }
    //return;    
}

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
    Mesh.SetSkeletalMesh(SkelMesh);
    //return;    
}

simulated function bool CanPlayHitSounds()
{
    return false;
    //return ReturnValue;    
}

simulated function bool CanPlayHitImpactEffects()
{
    return false;
    //return ReturnValue;    
}

simulated function bool CanLeaveBloodDecals()
{
    return false;
    //return ReturnValue;    
}

function RequestDefaultMovementMode()
{
    // End:0xAE
    if(int(SupremeMoveMode) == int(0))
    {
        // End:0x94
        if((MyEvilAI != none) && MyEvilAI.InLatentExecution(503) || MyEvilAI.InLatentExecution(501))
        {
            MyEvilAI.StopLatentExecution();
        }
        ZeroMovementVariables();
        ChangeMoveMode(0);        
    }
    else
    {
        // End:0xE0
        if(bIsWalking)
        {
            bShouldWalkFast = default.bShouldWalkFast;
            ChangeMoveMode(1);            
        }
        else
        {
            // End:0x119
            if((int(SupremeMoveMode) >= int(2)) && ReadyToRunInterval <= 0.0000000)
            {
                ChangeMoveMode(2);                
            }
            else
            {
                // End:0x13A
                if(int(SupremeMoveMode) >= int(1))
                {
                    ChangeMoveMode(1);
                }
            }
        }
    }
    //return;    
}

simulated event CacheAnimNodes()
{
    super.CacheAnimNodes();
    LeanController = SkelControlSingleBone(Mesh.FindSkelControl('LeanController'));
    //return;    
}

defaultproperties
{
    AutoRecoveryDelay=0.1500000
    LowHealthAmbientThreshold=0.5000000
    bDisableEvilAnimWeaponAnims=false
    bShouldPlayDeathAnimationToRagdoll=true
    bCanBeKnockedDown=false
    SupremeMoveMode=EMoveMode.EMM_Run
    LeanLenght=30.0000000
    LeanRoll=3000.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__EvilPlayerPawn.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__EvilPlayerPawn.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__EvilPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    RagdollLifespan=0.1000000
    DefaultMeshScale=1.0000000
    // Reference: UTAmbientSoundComponent'Default__EvilPlayerPawn.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__EvilPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__EvilPlayerPawn.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__EvilPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__EvilPlayerPawn.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__EvilPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    BaseTranslationOffset=0.0000000
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__EvilPlayerPawn.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__EvilPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__EvilPlayerPawn.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__EvilPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__EvilPlayerPawn.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__EvilPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__EvilPlayerPawn.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__EvilPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bCanCrouch=true
    GroundSpeed=225.0000000
    AccelRate=2048.0000000
    JumpZ=322.0000000
    // Reference: SkeletalMeshComponent'Default__EvilPlayerPawn.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__EvilPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilPlayerPawn.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__EvilPlayerPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__EvilPlayerPawn.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__EvilPawn.FaceAudioComponent'
    begin object name="FaceAudioComponent"
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    CollisionComponent=CollisionCylinder
}