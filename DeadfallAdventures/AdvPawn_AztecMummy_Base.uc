class AdvPawn_AztecMummy_Base extends AdvPawn_Mummy_Base
    abstract
    config(Pawn)
    hidecategories(Navigation);

struct DogdeInfo
{
    var() name AnimName;
    var() Vector DodgeDelta;

    structdefaultproperties
    {
        AnimName="None"
        DodgeDelta=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var AnimSet ShieldedAnimSet;
var EvilAnimDef AnimDefArchetypeAfterLostShield;

function bool CanEngageCharge()
{
    return ((AST_GetAnimCount(114)) > 0) && super(EvilPawn).CanEngageCharge();
    //return ReturnValue;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);
    //return;    
}

function InitDefaultHealth()
{
    Health = 1000;
    HealthMax = 1000;
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    Mesh.bRootMotionExtractedNotify = true;
    // End:0x5B
    if(bHasShield)
    {
        ForceLimitedMoveMode(1);
        bShouldWalkFast = true;
        EquipShield(none);
    }
    Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, Mesh);
    //return;    
}

function int GetHitAnimIndex(class<EvilDmgType_Base> EvilDamageType, optional bool bKickHit = false)
{
    local bool bHitMelee;
    local EvilTypesNative.EAnimationSetType AST;

    bHitMelee = class<EvilDmgType_Melee>(EvilDamageType) != none;
    // End:0x85
    if(!bHasShield)
    {
        // End:0x64
        if(bHitMelee && (AST_GetAnimCount(186)) > 0)
        {
            AST = 186;            
        }
        else
        {
            return super(AdvPawn).GetHitAnimIndex(EvilDamageType, bKickHit);
        }        
    }
    else
    {
        AST = 37;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

simulated function DoSpecialClothActionOnRagdoll(EvilTypes.EClothAssetSpecialActionOnRagdoll Action, EvilPawnClothAssetInterface clothComponent)
{
    local EvilAnim_AST an;

    // End:0x131
    if(int(Action) == int(1))
    {
        bHasShield = false;
        ForceLimitedMoveMode(DefaultMoveMode);
        bForceMoveMode = false;
        Mesh.AnimSets.RemoveItem(ShieldedAnimSet);        
        UpdateAnimSetList();
        AnimDefArchetype = AnimDefArchetypeAfterLostShield;
        RunAnimIndex = AST_GetRandomAnimIndex(67);
        // End:0xF4
        foreach Mesh.AllAnimNodes(Class'EvilGame.EvilAnim_AST', an)
        {
            an.ForceUpdateFromAnimDef(,, true);            
        }        
        Mesh.bRootMotionExtractedNotify = true;
        ServerDoPawnAction(30,,, PackRandomAnimInfo(88));
    }
    //return;    
}

simulated function DoSpecialClothActionOnZeroHealth(EvilTypes.EClothAssetSpecialActionOnZeroHealth Action, EvilPawnClothAssetInterface clothComponent)
{
    local EvilAnim_AST an;

    // End:0x12D
    if(int(Action) == int(1))
    {
        bHasShield = false;
        ForceLimitedMoveMode(DefaultMoveMode);
        bForceMoveMode = false;
        Mesh.AnimSets.RemoveItem(ShieldedAnimSet);        
        UpdateAnimSetList();
        AnimDefArchetype = AnimDefArchetypeAfterLostShield;
        // End:0xDD
        foreach Mesh.AllAnimNodes(Class'EvilGame.EvilAnim_AST', an)
        {
            an.ForceUpdateFromAnimDef(,, true);            
        }        
        Mesh.bRootMotionExtractedNotify = true;
        ServerDoPawnAction(30,,, PackRandomAnimInfo(88));
        SetTimer(5.0000000, false, 'DisableExtractedNotifyFromMesh');
    }
    //return;    
}

function DisableExtractedNotifyFromMesh()
{
    Mesh.bRootMotionExtractedNotify = false;
    //return;    
}

simulated function DoSpecialClothActionOnTakeDamage(EvilTypes.EClothAssetSpecialActionOnTakeDamage Action, EvilPawnClothAssetInterface clothComponent, bool bHealthStepOcurred)
{
    // End:0x121
    if(bHasShield && int(Action) == int(1))
    {
        // End:0x121
        if(MyEvilAI != none)
        {
            // End:0x88
            if((EvilWeap_Melee_Base(CurrentHitInformation.DamageCauser) != none) && FRand() > 0.5000000)
            {
                ServerDoPawnAction(1,,, GetHitAnimIndex(none, true));
                return;
            }
            // End:0x106
            if((((bHealthStepOcurred && int(Physics) != int(10)) && !IsJumping()) && CanDoPawnAction(1)) && FRand() > 0.6000000)
            {
                bShouldWalkFast = false;
                ServerDoPawnAction(1,,, GetHitAnimIndex(none));                
            }
            else
            {
                // End:0x121
                if(!bStrafing)
                {
                    bShouldWalkFast = false;
                }
            }
        }
    }
    //return;    
}

simulated function Burn(float InTotalTime, float InDamageInterval, float InDamageAmount, optional bool bMaterialsBlackEffects = true, optional bool bMaterialsDotEffects = true, optional bool bResetActualBlackMaterialValue = true, optional bool bResetActualDotsMaterialValue = true)
{
    super.Burn(InTotalTime, InDamageInterval, InDamageAmount, bMaterialsBlackEffects, bMaterialsDotEffects, bResetActualBlackMaterialValue, bResetActualDotsMaterialValue);
    //return;    
}

function int GetChargeAnimIndex()
{
    // End:0x2C
    if((IsBurning()) && bOnLightInfluenceFromFlashLight)
    {
        return PackRandomAnimInfo(114);        
    }
    else
    {
        return super(EvilPawn).GetChargeAnimIndex();
    }
    //return ReturnValue;    
}

simulated function bool CheckBerserkerMode(optional bool bStartBurning = true)
{
    // End:0x59
    if(!bBerserkerMode && super.CheckBerserkerMode(bStartBurning))
    {
        Health = int(DefaultHealth);
        HealthMax = int(DefaultHealth);
        return true;
    }
    return bBerserkerMode;
    //return ReturnValue;    
}

function DoBurnDamageTimer()
{
    // End:0x9D
    if(!CheckBerserkerMode())
    {
        // End:0x66
        if(bOnLightInfluenceFromVolume || bOnLightInfluenceFromFlashLight)
        {
            TakeDamage(int(BurningDamageAmount), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Light',, self);            
        }
        else
        {
            TakeDamage(int(BurningDamageAmount), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Fire',, self);
        }
    }
    //return;    
}

simulated function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    // End:0x6E
    if(bBeamActive || bOnLightInfluenceFromVolume)
    {
        // End:0x6B
        if(!SizzleSoundComponent.IsPlaying())
        {
            SizzleSoundComponent.FadeIn(0.1000000, 1.0000000);
        }        
    }
    else
    {
        // End:0xDF
        if(!SizzleSoundComponent.IsFadingOut() && SizzleSoundComponent.IsPlaying())
        {
            SizzleSoundComponent.FadeOut(0.5000000, 0.0000000);
        }
    }
    // End:0x126
    if(!CanBeAffectedByLight())
    {
        bFlashlightBeamActive = bBeamActive;
        bInFlashlightCone = bInLightCone;
        bForceNetUpdate = true;
        return;
    }
    // End:0x250
    if(bInLightCone && bBeamActive)
    {
        // End:0x175
        if(MyAdvAI != none)
        {
            MyAdvAI.CoverFromLightStartTime = -1.0000000;
        }
        // End:0x1AC
        if(!bBerserkerMode)
        {
            // End:0x1AC
            if(LightDissolveAlpha < 0.0000000)
            {
                LightDissolveAlpha = -LightDissolveAlpha;
            }
        }
        // End:0x24D
        if(((HasShield()) && MyEvilAI != none) && (MyEvilAI.MoveAction == none) || MyEvilAI.MoveAction.bInterruptable)
        {
            ForceLimitedMoveMode(1);
            bShouldWalkFast = false;
            bForceNetUpdate = true;
        }        
    }
    else
    {
        // End:0x305
        if(MyEvilAI != none)
        {
            // End:0x284
            if(!HasShield())
            {
                ForceLimitedMoveMode(DefaultMoveMode);                
            }
            else
            {
                // End:0x305
                if((MyEvilAI.MoveAction == none) || MyEvilAI.MoveAction.bInterruptable)
                {
                    ForceLimitedMoveMode(1);
                    bShouldWalkFast = true;
                    bForceNetUpdate = true;
                }
            }
        }
    }
    // End:0x526
    if((bInLightCone != bOnLightInfluenceFromFlashLight) || !IsBurning())
    {
        bOnLightInfluenceFromFlashLight = bInLightCone;
        // End:0x3B9
        if(bBeamActive && bInLightCone)
        {
            // End:0x3AC
            if(bOnLightInfluenceFromFlashLight && MyAdvAI != none)
            {
                MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
            }
            StartInLightEffects();            
        }
        else
        {
            // End:0x3E3
            if(!bOnLightInfluenceFromFlashLight || !bBeamActive)
            {
                StopInLightEffects();
            }
            // End:0x523
            if(bOnLightInfluenceFromFlashLight)
            {
                // End:0x453
                if(LightDissolvePSC == none)
                {
                    LightDissolvePSC = new (self) Class'Engine.ParticleSystemComponent';
                    AttachComponent(LightDissolvePSC);
                    LightDissolvePSC.SetActorParameter('BoneSocketActor', self);
                }
                // End:0x4C6
                if(LightDissolvePSC.Template == LightDissolvePS)
                {
                    LightDissolvePSC.DeactivateSystem();
                    LightDissolvePSC.SetTemplate(LightDissolveWeakPS);
                }
                LightDissolvePSC.ActivateSystem();
                // End:0x523
                if(MyAdvAI != none)
                {
                    MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
                }
            }
        }        
    }
    else
    {
        // End:0x55F
        if(((IsBurning()) && !bBeamActive) && !bOnLightInfluenceFromVolume)
        {
            StopInLightEffects();
        }
    }
    super.SetLightAffectionFromFlashLight(bInLightCone, bBeamActive);
    UpdateLightInfluence_T();
    //return;    
}

function SetLightAffectionFromVolume(bool bInLightVolume)
{
    // End:0x6C
    if(bInLightVolume || bFlashlightBeamActive)
    {
        // End:0x69
        if(!SizzleSoundComponent.IsPlaying())
        {
            SizzleSoundComponent.FadeIn(0.1000000, 1.0000000);
        }        
    }
    else
    {
        // End:0xDD
        if(!SizzleSoundComponent.IsFadingOut() && SizzleSoundComponent.IsPlaying())
        {
            SizzleSoundComponent.FadeOut(0.5000000, 0.0000000);
        }
    }
    // End:0x18A
    if(bInLightVolume != bOnLightInfluenceFromVolume)
    {
        bOnLightInfluenceFromVolume = bInLightVolume;
        // End:0x125
        if(bInLightVolume)
        {
            StartInLightEffects();            
        }
        else
        {
            // End:0x13E
            if(!bOnLightInfluenceFromFlashLight)
            {
                StopInLightEffects();
            }
            // End:0x18A
            if(bOnLightInfluenceFromVolume && MyAdvAI != none)
            {
                MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
            }
        }
    }
    //return;    
}

function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
    local UTPlayerController Hearer;
    local class<EvilDmgType_Base> UTDamage;
    local bool HitSoundPlayed;
    local editinline EvilAudioComponent EvilFacialAudioComp;
    local class<EvilDmgType_Base> EvilDamageType;

    EvilFacialAudioComp = EvilAudioComponent(FacialAudioComp);
    // End:0xBE
    if(((InstigatedBy != none) && class<EvilDmgType_Base>(DamageType) != none) && class<EvilDmgType_Base>(DamageType).default.bDirectDamage)
    {
        Hearer = UTPlayerController(InstigatedBy);
        // End:0xBE
        if(Hearer != none)
        {
            Hearer.bAcuteHearing = true;
        }
    }
    // End:0x248
    if((WorldInfo.TimeSeconds - LastPainSound) >= 0.4000000)
    {
        LastPainSound = WorldInfo.TimeSeconds;
        // End:0x248
        if((Damage > float(0)) && Health > 0)
        {
            HitSoundPlayed = false;
            EvilDamageType = class<EvilDmgType_Base>(DamageType);
            // End:0x205
            if(((EvilDamageType != none) && EvilDamageType.default.bIsLightDmgType || EvilDamageType.default.bIsFireDmgType) && EvilFacialAudioComp != none)
            {
                // End:0x1F9
                if(!EvilFacialAudioComp.IsPlaying())
                {
                    PlayFireHitSound();
                }
                HitSoundPlayed = true;
            }
            // End:0x248
            if(!HitSoundPlayed)
            {
                SoundGroupClass.static.PlayTakeHitSound(self, int(Damage), DamageType);
            }
        }
    }
    // End:0x2FB
    if((((Health <= 0) && PhysicsVolume.bDestructive) && WaterVolume(PhysicsVolume) != none) && WaterVolume(PhysicsVolume).ExitActor != none)
    {
        Spawn(WaterVolume(PhysicsVolume).ExitActor);
    }
    super(Pawn).PlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
    // End:0x36B
    if(Hearer != none)
    {
        Hearer.bAcuteHearing = false;
    }
    UTDamage = class<EvilDmgType_Base>(DamageType);
    // End:0x65E
    if((Damage > float(0)) || (Controller != none) && Controller.bGodMode)
    {
        CheckHitInfo(HitInfo, Mesh, Normal(Momentum), HitLocation);
        // End:0x44B
        if(bShieldAbsorb)
        {
            SetBodyMatColor(SpawnProtectionColor, 1.0000000);
            PlaySound(ArmorHitSound);
            bShieldAbsorb = false;
            return;            
        }
        else
        {
            // End:0x4F4
            if(((UTDamage != none) && UTDamage.default.DamageOverlayTime > 0.0000000) && UTDamage.default.XRayEffectTime <= 0.0000000)
            {
                SetBodyMatColor(UTDamage.default.DamageBodyMatColor, UTDamage.default.DamageOverlayTime);
            }
        }
        LastTakeHitInfo.Damage = int(Damage);
        LastTakeHitInfo.HitLocation = HitLocation;
        LastTakeHitInfo.Momentum = Momentum;
        LastTakeHitInfo.DamageType = DamageType;
        LastTakeHitInfo.HitBone = HitInfo.BoneName;
        LastTakeHitTimeout = WorldInfo.TimeSeconds + ((UTDamage != none) ? UTDamage.static.GetHitEffectDuration(self, Damage) : Class'EvilGame.EvilDmgType_Base'.static.GetHitEffectDuration(self, Damage));
        PlayTakeHitEffects();
    }
    //return;    
}

function PlayDyingSound()
{
    // End:0x1F
    if(int(GetFacialCompnentSoundSetType()) != int(2))
    {
        super(UTPawn).PlayDyingSound();
    }
    //return;    
}

defaultproperties
{
    AnimDefArchetypeAfterLostShield=EvilAnimDef'AnimDefs.AnimDef_AztecMummy'
    bHasShield=true
    FireBurnEffectPS=ParticleSystem'ps_Mummy.Effects.ps_ch_BurningMummy'
    // Reference: SkeletalMeshComponent'Default__AdvPawn_AztecMummy_Base.WPawnSkeletalMeshComponent_Skeleton'
    begin object name=WPawnSkeletalMeshComponent_Skeleton
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_AztecMummy_Base.MyLightEnvironment'
    end object
    SkeletonMesh=WPawnSkeletalMeshComponent_Skeleton
    // Reference: SkeletalMeshComponent'Default__AdvPawn_AztecMummy_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_AztecMummy_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_AztecMummy_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    // Reference: AudioComponent'Default__AdvPawn_AztecMummy_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bCanBeAffectedByLight=true
    CharacterFootStepType=ECharacterFootStepType.CFST_AztecMummy
    PawnActionClasses=/* Array type was not detected. */
    SpawnAnims=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_AztecMummy_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_AztecMummy_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_AztecMummy_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_AztecMummy_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_AztecMummy_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_AztecMummy_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_AztecMummy_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_AztecMummy_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_AztecMummy_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_AztecMummy_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_AztecMummy_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_AztecMummy_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_AztecMummy_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_AztecMummy_Base.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=PawnBlocker0
    Components[7]=FaceAudioComponent
    Components[8]=SPawnSkeletalMeshComponent
    Components[9]=SizzleAudioComponent0
    Components[10]=WPawnSkeletalMeshComponent_Skeleton
    CollisionComponent=CollisionCylinder
}