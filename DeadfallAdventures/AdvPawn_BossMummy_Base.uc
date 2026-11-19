class AdvPawn_BossMummy_Base extends AdvPawn_Mummy_Base
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

var EvilAnimDef AnimDefArchetypeAfterLostShield;
var export editinline AdvGhostingEffectComponent GhostingComponent;

function bool CanEngageCharge()
{
    return ((AST_GetAnimCount(114)) > 0) && super(EvilPawn).CanEngageCharge();
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    local EvilInventoryManager invmng;

    super.PostBeginPlay();
    invmng = EvilInventoryManager(InvManager);
    // End:0x56
    if(invmng != none)
    {
        invmng.bInfiniteAmmo = true;
    }
    // End:0x86
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
    // End:0x35
    if(!bHasShield)
    {
        return super(AdvPawn).GetHitAnimIndex(EvilDamageType, bKickHit);        
    }
    else
    {
        return PackRandomAnimInfo(37);
    }
    //return ReturnValue;    
}

simulated function DoSpecialClothActionOnRagdoll(EvilTypes.EClothAssetSpecialActionOnRagdoll Action, EvilPawnClothAssetInterface clothComponent)
{
    // End:0x65
    if(int(Action) == int(1))
    {
        bHasShield = false;
        ForceLimitedMoveMode(DefaultMoveMode);
        bForceMoveMode = false;
        AnimDefArchetype = AnimDefArchetypeAfterLostShield;
        SetAnimSetsFromAnimDef(AnimDefArchetypeAfterLostShield);
    }
    //return;    
}

simulated function DoSpecialClothActionOnZeroHealth(EvilTypes.EClothAssetSpecialActionOnZeroHealth Action, EvilPawnClothAssetInterface clothComponent)
{
    // End:0x80
    if(int(Action) == int(1))
    {
        bHasShield = false;
        ForceLimitedMoveMode(DefaultMoveMode);
        bForceMoveMode = false;
        AnimDefArchetype = AnimDefArchetypeAfterLostShield;
        SetAnimSetsFromAnimDef(AnimDefArchetypeAfterLostShield);
        ServerDoPawnAction(30,,, PackRandomAnimInfo(88));
    }
    //return;    
}

simulated function DoSpecialClothActionOnTakeDamage(EvilTypes.EClothAssetSpecialActionOnTakeDamage Action, EvilPawnClothAssetInterface clothComponent, bool bHealthStepOcurred)
{
    // End:0x191
    if(bHasShield && int(Action) == int(1))
    {
        // End:0x191
        if(MyEvilAI != none)
        {
            // End:0x88
            if((EvilWeap_Melee_Base(CurrentHitInformation.DamageCauser) != none) && FRand() > 0.5000000)
            {
                ServerDoPawnAction(1,,, GetHitAnimIndex(none, true));
                return;
            }
            // End:0x11E
            if((((bHealthStepOcurred && int(Physics) != int(10)) && !IsJumping()) && CanDoPawnAction(1)) && FRand() > 0.6000000)
            {
                bForceMoveMode = true;
                MoveModeToEnforce = 1;
                bShouldWalkFast = false;
                ServerDoPawnAction(1,,, GetHitAnimIndex(none));                
            }
            else
            {
                // End:0x191
                if(!bStrafing)
                {
                    bForceMoveMode = true;
                    MoveModeToEnforce = 1;
                    bShouldWalkFast = false;
                    MyEvilAI.DoStrafeByDirection(((FRand() > 0.5000000) ? 2 : 3), 100.0000000 + float(Rand(50)));
                }
            }
        }
    }
    //return;    
}

simulated function Burn(float InTotalTime, float InDamageInterval, float InDamageAmount, optional bool bMaterialsBlackEffects = true, optional bool bMaterialsDotEffects = true, optional bool bResetActualBlackMaterialValue = true, optional bool bResetActualDotsMaterialValue = true)
{
    // End:0x71
    if((float(Health) - InDamageAmount) < (float(HealthMax) * 0.1000000))
    {
        InDamageAmount = FMax(float(Health) - (float(HealthMax) * 0.1000000), 0.0000000);
    }
    super.Burn(InTotalTime, InDamageInterval, InDamageAmount, bMaterialsBlackEffects, bMaterialsDotEffects, bResetActualBlackMaterialValue, bResetActualDotsMaterialValue);
    //return;    
}

function int GetChargeAnimIndex()
{
    // End:0x27
    if(BurnEffectPS == FireBurnEffectPS)
    {
        return PackRandomAnimInfo(114);        
    }
    else
    {
        return super(EvilPawn).GetChargeAnimIndex();
    }
    //return ReturnValue;    
}

function DoBurnDamageTimer()
{
    // End:0x112
    if((float(Health) <= (float(HealthMax) * 0.1000000)) && bCanBeAffectedByLight)
    {
        RunAnimIndex = 1 + Rand(2);
        bCanBeAffectedByLight = false;
        bOnLightInfluenceFromVolume = false;
        bOnLightInfluenceFromFlashLight = false;
        StopBurning();
        BurnEffectPS = FireBurnEffectPS;
        Burn(-1.0000000, 3.0000000, 1.0000000, true, true, false, false);
        CustomTimeDilation = 1.0000000;
        DropClothesOnRagdoll(Class'EvilGame.EvilDmgType_Light', vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), false);
        bForceMoveMode = false;
        RequestDefaultMovementMode();
        ServerDoPawnAction(54,,, PackAnimInfo(86, 0));        
    }
    else
    {
        // End:0x16F
        if((float(Health) - BurningDamageAmount) < (float(HealthMax) * 0.1000000))
        {
            BurningDamageAmount = FMax(float(Health) - (float(HealthMax) * 0.1000000), 0.0000000);
        }
        // End:0x1C5
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

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    NotifyTakeHit(EventInstigator, HitLocation, Damage, DamageType, Momentum, DamageCauser);
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    local EvilAnim_TurnInPlace_Player TIPP;

    super.PostInitAnimTree(SkelComp);
    RunAnimIndex = 0;
    // End:0xBE
    if(SkelComp == Mesh)
    {
        GhostingComponent.Init(SkelComp);
        // End:0xBE
        if(TurnInPlaceNode != none)
        {
            // End:0xBD
            foreach TurnInPlaceNode.PlayerNodes(TIPP)
            {
                TIPP.Rate = 4.0000000;                
            }            
        }
    }
    //return;    
}

function ReduceDamage(out int Damage, const out Controller EventInstigator, class<DamageType> DamageType)
{
    Damage = 0;
    //return;    
}

simulated function StartShootAttack()
{
    PlaySoundFromArchetypeByChance(7);
    ServerDoPawnAction(11,,, GetShootAnimPackedIndex());
    //return;    
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    local Vector Retval, HitLoc, HitNorm;

    // End:0x55
    if((WeaponLeft != none) && CurrentWeapon == WeaponLeft)
    {
        Retval = CurrentWeaponLeftAttachment.GetEffectLocation();        
    }
    else
    {
        Retval = CurrentWeaponAttachment.GetEffectLocation();
    }
    // End:0xF8
    if(AdvWeap_BossMummySpell_Base(CurrentWeapon) != none)
    {
        // End:0xF8
        if(none != Trace(HitLoc, HitNorm, Retval - vect(0.0000000, 0.0000000, 1024.0000000), Retval, false))
        {
            Retval = HitLoc + vect(0.0000000, 0.0000000, 30.0000000);
        }
    }
    return Retval;
    //return ReturnValue;    
}

simulated function OnStartFire()
{
    // End:0x17
    if(IsAiming())
    {
        StopAim();
    }
    StartFire(0);
    super(EvilPawn).OnStartFire();
    //return;    
}

simulated function OnStopFire()
{
    StopFire(0);
    super(EvilPawn).OnStopFire();
    //return;    
}

simulated event Tick(float DeltaTime)
{
    super(AdvPawn).Tick(DeltaTime);
    // End:0x77
    if((int(CurrentMoveMode) == int(0)) && TurnInPlaceNode != none)
    {
        GhostingComponent.bGhostingEnabled = TurnInPlaceNode.bPlayingTurnTransition;
    }
    GhostingComponent.Tick(DeltaTime);
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x49
    if(super.Died(Killer, DamageType, HitLocation))
    {
        GhostingComponent.Destroy();
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    GhostingComponent.Destroy();
    super(AdvPawn).Destroyed();
    //return;    
}

function MoveModeChanged(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    super(EvilPawn).MoveModeChanged(InNewMode, InOldMode);
    GhostingComponent.bGhostingEnabled = int(InNewMode) == int(2);
    //return;    
}

simulated function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    // End:0xBE
    if(bInLightCone != bOnLightInfluenceFromFlashLight)
    {
        bOnLightInfluenceFromFlashLight = bInLightCone;
        // End:0x59
        if(bBeamActive && bInLightCone)
        {
            StartInLightEffects();            
        }
        else
        {
            // End:0x72
            if(!bOnLightInfluenceFromVolume)
            {
                StopInLightEffects();
            }
            // End:0xBE
            if(bOnLightInfluenceFromFlashLight && MyAdvAI != none)
            {
                MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
            }
        }
    }
    super.SetLightAffectionFromFlashLight(bInLightCone, bBeamActive);
    UpdateLightInfluence_T();
    //return;    
}

function SetLightAffectionFromVolume(bool bInLightVolume)
{
    // End:0x61
    if(bInLightVolume != bOnLightInfluenceFromVolume)
    {
        bOnLightInfluenceFromVolume = bInLightVolume;
        // End:0x48
        if(bInLightVolume)
        {
            StartInLightEffects();            
        }
        else
        {
            // End:0x61
            if(!bOnLightInfluenceFromFlashLight)
            {
                StopInLightEffects();
            }
        }
    }
    //return;    
}

function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
    local UTPlayerController Hearer;
    local class<EvilDmgType_Base> EvilDamageType;
    local bool HitSoundPlayed;
    local editinline EvilAudioComponent EvilFacialAudioComp;

    EvilFacialAudioComp = EvilAudioComponent(FacialAudioComp);
    EvilDamageType = class<EvilDmgType_Base>(DamageType);
    // End:0xDA
    if(((InstigatedBy != none) && class<EvilDmgType_Base>(DamageType) != none) && class<EvilDmgType_Base>(DamageType).default.bDirectDamage)
    {
        Hearer = UTPlayerController(InstigatedBy);
        // End:0xDA
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
    // End:0x642
    if((Damage > float(0)) || (Controller != none) && Controller.bGodMode)
    {
        CheckHitInfo(HitInfo, Mesh, Normal(Momentum), HitLocation);
        // End:0x42F
        if(bShieldAbsorb)
        {
            SetBodyMatColor(SpawnProtectionColor, 1.0000000);
            PlaySound(ArmorHitSound);
            bShieldAbsorb = false;
            return;            
        }
        else
        {
            // End:0x4D8
            if(((EvilDamageType != none) && EvilDamageType.default.DamageOverlayTime > 0.0000000) && EvilDamageType.default.XRayEffectTime <= 0.0000000)
            {
                SetBodyMatColor(EvilDamageType.default.DamageBodyMatColor, EvilDamageType.default.DamageOverlayTime);
            }
        }
        LastTakeHitInfo.Damage = int(Damage);
        LastTakeHitInfo.HitLocation = HitLocation;
        LastTakeHitInfo.Momentum = Momentum;
        LastTakeHitInfo.DamageType = DamageType;
        LastTakeHitInfo.HitBone = HitInfo.BoneName;
        LastTakeHitTimeout = WorldInfo.TimeSeconds + ((EvilDamageType != none) ? EvilDamageType.static.GetHitEffectDuration(self, Damage) : Class'EvilGame.EvilDmgType_Base'.static.GetHitEffectDuration(self, Damage));
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

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local Vector PreTeleportLocation;
    local Rotator PreTeleportRotation;

    PreTeleportLocation = Location;
    PreTeleportRotation = Rotation;
    super(AdvPawn).OnTeleport(Action);
    // End:0x9C
    if(VSizeSq(Location - PreTeleportLocation) > 1.0000000)
    {
        GhostingComponent.CreateTeleportTrail(PreTeleportLocation, Location, PreTeleportRotation, Rotation);
    }
    //return;    
}

defaultproperties
{
    AnimDefArchetypeAfterLostShield=EvilAnimDef'AnimDefs.AnimDef_AztecMummy'
    // Reference: AdvGhostingEffectComponent'Default__AdvPawn_BossMummy_Base.GhostingComponent0'
    begin object name=GhostingComponent0 class=Class'AdvGhostingEffectComponent'
    end object
    GhostingComponent=GhostingComponent0
    bHasShield=true
    FireBurnEffectPS=ParticleSystem'ps_Mummy.Effects.ps_ch_BurningMummy'
    // Reference: SkeletalMeshComponent'Default__AdvPawn_BossMummy_Base.WPawnSkeletalMeshComponent_Skeleton'
    begin object name=WPawnSkeletalMeshComponent_Skeleton
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_BossMummy_Base.MyLightEnvironment'
    end object
    SkeletonMesh=WPawnSkeletalMeshComponent_Skeleton
    // Reference: SkeletalMeshComponent'Default__AdvPawn_BossMummy_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_BossMummy_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_BossMummy_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    // Reference: AudioComponent'Default__AdvPawn_BossMummy_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bCanBeAffectedByLight=true
    CharacterFootStepType=ECharacterFootStepType.CFST_AztecMummy
    PawnActionClasses=/* Array type was not detected. */
    SpawnAnims=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_BossMummy_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_BossMummy_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_BossMummy_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_BossMummy_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_BossMummy_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_BossMummy_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_BossMummy_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_BossMummy_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_BossMummy_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_BossMummy_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_BossMummy_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_BossMummy_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_BossMummy_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_BossMummy_Base.FaceAudioComponent'
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
    Components[11]=GhostingComponent0
    CollisionComponent=CollisionCylinder
}