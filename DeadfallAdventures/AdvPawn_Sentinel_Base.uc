class AdvPawn_Sentinel_Base extends AdvPawn_Mummy_Base
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

var AdvAI_Sentinel MyAdvAISentinel;
var EvilAnimDef AnimDefArchetypeAfterLostShield;
var() export editinline AdvGhostingEffectComponent GhostingComponent;
var Actor TeleportDestActor;
var float TeleportDissolveAmount;
var bool bTeleportUpdatesRotation;
var bool bAlreadyTeleported;
var bool bPawnNotifiedAboutTeleport;
var() bool bCanDieInBerserker;
var ParticleSystem TeleportEffect;
var export editinline ParticleSystemComponent TeleportEffectPSC;
var repnotify Actor ReplicatedTeleportDestActor;

replication
{
    // Pos:0x000
    if(bNetDirty
        ReplicatedTeleportDestActor;
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x64
        case 'ReplicatedTeleportDestActor':
            // End:0x61
            if(ReplicatedTeleportDestActor != none)
            {
                bAlreadyTeleported = false;
                OnClientTeleport();
                DelayedTeleport(ReplicatedTeleportDestActor);
                InitClientDelayedTeleport();
            }
            // End:0x7D
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            // End:0x7D
            break;
            break;
    }
    //return;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super(AdvPawn).PossessedBy(C, bVehicleTransition);
    MyAdvAISentinel = AdvAI_Sentinel(C);
    //return;    
}

function InitDefaultHealth()
{
    Health = 1000;
    HealthMax = 1000;
    //return;    
}

simulated function bool CheckBerserkerMode(optional bool bStartBurning = true)
{
    // End:0x48
    if(super.CheckBerserkerMode(bStartBurning))
    {
        Health = int(DefaultHealth);
        HealthMax = int(DefaultHealth);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CanEngageCharge()
{
    return ((AST_GetAnimCount(114)) > 0) && super(EvilPawn).CanEngageCharge();
    //return ReturnValue;    
}

function DoMeleeAttackDamage()
{
    local EvilWeap_Melee_Base Wpn;

    // End:0xD8
    if(((int(PawnAction) == 5) || int(PawnAction) == 7) && TeleportDissolveAmount >= 0.9500000)
    {
        Wpn = EvilWeap_Melee_Base(MeleeWeapon);
        // End:0x82
        if(Wpn == none)
        {
            Wpn = EvilWeap_Melee_Base(Weapon);
        }
        // End:0xD8
        if(Wpn != none)
        {
            Wpn.DoMeleeDamage(DamageScaling, Controller.Enemy);
        }
    }
    //return;    
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
    GhostingComponent.Init(Mesh);
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
    // End:0x5E
    if(int(Action) == int(1))
    {
        bHasShield = false;
        ForceLimitedMoveMode(6);
        bForceMoveMode = false;
        AnimDefArchetype = AnimDefArchetypeAfterLostShield;
        SetAnimSetsFromAnimDef(AnimDefArchetypeAfterLostShield);
    }
    //return;    
}

simulated function DoSpecialClothActionOnZeroHealth(EvilTypes.EClothAssetSpecialActionOnZeroHealth Action, EvilPawnClothAssetInterface clothComponent)
{
    // End:0x79
    if(int(Action) == int(1))
    {
        bHasShield = false;
        ForceLimitedMoveMode(6);
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
    InDamageAmount = 0.0000000;
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

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);
    RunAnimIndex = 0;
    // End:0x5D
    if(SkelComp == Mesh)
    {
        GhostingComponent.Init(SkelComp);
    }
    //return;    
}

simulated function StartShootAttack()
{
    PlaySoundFromArchetypeByChance(7);
    ServerDoPawnAction(11,,, GetShootAnimPackedIndex());
    //return;    
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
    //return;    
}

simulated function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    // End:0x5F
    if(bBeamActive)
    {
        // End:0x5C
        if(!SizzleSoundComponent.IsPlaying())
        {
            SizzleSoundComponent.FadeIn(0.1000000, 1.0000000);
        }        
    }
    else
    {
        // End:0xD0
        if(!SizzleSoundComponent.IsFadingOut() && SizzleSoundComponent.IsPlaying())
        {
            SizzleSoundComponent.FadeOut(0.5000000, 0.0000000);
        }
    }
    // End:0xE1
    if(!CanBeAffectedByLight())
    {
        return;
    }
    // End:0x18F
    if(bInLightCone && bBeamActive)
    {
        // End:0x130
        if(MyAdvAI != none)
        {
            MyAdvAI.CoverFromLightStartTime = -1.0000000;
        }
        // End:0x167
        if(!bBerserkerMode)
        {
            // End:0x167
            if(LightDissolveAlpha < 0.0000000)
            {
                LightDissolveAlpha = -LightDissolveAlpha;
            }
        }
        // End:0x18C
        if(HasShield())
        {
            ForceLimitedMoveMode(1);
            bShouldWalkFast = false;
        }        
    }
    else
    {
        // End:0x1B4
        if(!HasShield())
        {
            ForceLimitedMoveMode(DefaultMoveMode);            
        }
        else
        {
            ForceLimitedMoveMode(1);
            bShouldWalkFast = true;
        }
    }
    // End:0x3ED
    if((bInLightCone != bOnLightInfluenceFromFlashLight) || !IsBurning())
    {
        bOnLightInfluenceFromFlashLight = bInLightCone;
        // End:0x280
        if(bBeamActive && bInLightCone)
        {
            // End:0x273
            if(bOnLightInfluenceFromFlashLight && MyAdvAI != none)
            {
                MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
            }
            StartInLightEffects();            
        }
        else
        {
            // End:0x2AA
            if(!bOnLightInfluenceFromFlashLight || !bBeamActive)
            {
                StopInLightEffects();
            }
            // End:0x3EA
            if(bOnLightInfluenceFromFlashLight)
            {
                // End:0x31A
                if(LightDissolvePSC == none)
                {
                    LightDissolvePSC = new (self) Class'Engine.ParticleSystemComponent';
                    AttachComponent(LightDissolvePSC);
                    LightDissolvePSC.SetActorParameter('BoneSocketActor', self);
                }
                // End:0x38D
                if(LightDissolvePSC.Template == LightDissolvePS)
                {
                    LightDissolvePSC.DeactivateSystem();
                    LightDissolvePSC.SetTemplate(LightDissolveWeakPS);
                }
                LightDissolvePSC.ActivateSystem();
                // End:0x3EA
                if(MyAdvAI != none)
                {
                    MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
                }
            }
        }        
    }
    else
    {
        // End:0x415
        if((IsBurning()) && !bBeamActive)
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
    // End:0xAD
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
            // End:0xAD
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
    local class<EvilDmgType_Base> EvilDamageType;
    local bool HitSoundPlayed;
    local editinline EvilAudioComponent EvilFacialAudioComp;

    EvilDamageType = class<EvilDmgType_Base>(DamageType);
    EvilFacialAudioComp = EvilAudioComponent(FacialAudioComp);
    // End:0xC8
    if(((InstigatedBy != none) && EvilDamageType != none) && EvilDamageType.default.bDirectDamage)
    {
        Hearer = UTPlayerController(InstigatedBy);
        // End:0xC8
        if(Hearer != none)
        {
            Hearer.bAcuteHearing = true;
        }
    }
    // End:0x236
    if((WorldInfo.TimeSeconds - LastPainSound) >= 0.4000000)
    {
        LastPainSound = WorldInfo.TimeSeconds;
        // End:0x236
        if((Damage > float(0)) && Health > 0)
        {
            HitSoundPlayed = false;
            // End:0x1F3
            if(((EvilDamageType != none) && EvilDamageType.default.bIsLightDmgType || EvilDamageType.default.bIsFireDmgType) && EvilFacialAudioComp != none)
            {
                // End:0x1E7
                if(!EvilFacialAudioComp.IsPlaying())
                {
                    PlayFireHitSound();
                }
                HitSoundPlayed = true;
            }
            // End:0x236
            if(!HitSoundPlayed)
            {
                SoundGroupClass.static.PlayTakeHitSound(self, int(Damage), DamageType);
            }
        }
    }
    // End:0x2E9
    if((((Health <= 0) && PhysicsVolume.bDestructive) && WaterVolume(PhysicsVolume) != none) && WaterVolume(PhysicsVolume).ExitActor != none)
    {
        Spawn(WaterVolume(PhysicsVolume).ExitActor);
    }
    super(Pawn).PlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
    // End:0x359
    if(Hearer != none)
    {
        Hearer.bAcuteHearing = false;
    }
    // End:0x630
    if((Damage > float(0)) || (Controller != none) && Controller.bGodMode)
    {
        CheckHitInfo(HitInfo, Mesh, Normal(Momentum), HitLocation);
        // End:0x41D
        if(bShieldAbsorb)
        {
            SetBodyMatColor(SpawnProtectionColor, 1.0000000);
            PlaySound(ArmorHitSound);
            bShieldAbsorb = false;
            return;            
        }
        else
        {
            // End:0x4C6
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
    bAlreadyTeleported = false;
    bPawnNotifiedAboutTeleport = true;
    super(AdvPawn).OnTeleport(Action);
    // End:0x88
    if((MyAdvAISentinel != none) && !MyAdvAISentinel.bControllerNotifiedAboutTeleport)
    {
        MyAdvAISentinel.OnTeleport(Action);
    }
    InitDefaultHealth();
    OnClientTeleport();
    //return;    
}

simulated function OnClientTeleport()
{
    local MaterialInstanceConstant MIC;

    bBerserkerMode = false;
    StopInLightEffects();
    ClearTimer('DarknessGoneDissolve_T');
    LightDissolveAlpha = 0.0000000;
    // End:0x8F
    foreach DissolveMICs(MIC)
    {
        MIC.SetScalarParameterValue('DissolveLight', Abs(LightDissolveAlpha) * LightDissolveMultiplier);        
    }    
    // End:0xD5
    foreach DissolveMICs(MIC)
    {
        MIC.SetScalarParameterValue('Mortal', 0.0000000);        
    }    
    bPawnNotifiedAboutTeleport = false;
    //return;    
}

simulated function bool HandleTeleport(array<Object> DestList, bool bUpdateRotation, bool bCheckOverlap, optional float TeleportDistance, optional array<Volume> TeleportVolumes, optional int PreferredDestIndex)
{
    local int Idx, Cnt;
    local Actor destActor, tempActor, A;
    local Controller C;
    local bool bOccupiedDest, bColliding;
    local Vector Extent;

    Extent = GetCollisionExtent();
    bOccupiedDest = false;
    // End:0x2AE
    if(DestList.Length > 0)
    {
        Idx = ((PreferredDestIndex >= 0) ? PreferredDestIndex : 0);
        // End:0x86
        if(Idx >= DestList.Length)
        {
            Idx = 0;
            PreferredDestIndex = 0;
        }
        Cnt = 0;
        J0x91:

        tempActor = Actor(DestList[Idx]);
        // End:0x241
        if(tempActor != none)
        {
            C = Controller(tempActor);
            // End:0x13F
            if((C != none) && C.Pawn != none)
            {
                tempActor = C.Pawn;
            }
            // End:0x1FA
            if(bCheckOverlap)
            {
                bColliding = false;
                // End:0x1E4
                foreach VisibleCollidingActors(Class'Engine.Actor', A, Extent.X * 2.0000000, tempActor.Location, false, Extent, true)
                {
                    // End:0x1E3
                    if(IsBlockedBy(A))
                    {
                        bColliding = true;
                        // End:0x1E4
                        break;
                    }                    
                }                
                bOccupiedDest = bColliding;
            }
            destActor = tempActor;
            // End:0x241
            if((!bCheckOverlap || !bOccupiedDest) && destActor != none)
            {
                // [Explicit Continue]
                goto J0x2AB;
            }
        }
        ++Idx;
        // End:0x26F
        if(Idx >= DestList.Length)
        {
            Idx = 0;
        }
        ++Cnt;
        // End:0x91
        if(!((Idx == PreferredDestIndex) || Cnt >= DestList.Length))
            goto J0x91;
        J0x2AB:
        
    }
    // End:0x36A
    if((destActor != none) && Class'Engine.SeqAct_Teleport'.static.ShouldTeleport(self, destActor.Location, TeleportDistance, TeleportVolumes))
    {
        bTeleportUpdatesRotation = bUpdateRotation;
        // End:0x368
        if(DelayedTeleport(destActor))
        {
            InitClientDelayedTeleport();
            ReplicatedTeleportDestActor = TeleportDestActor;
            bForceNetUpdate = true;
            return true;
        }
        return false;
    }
    // End:0x37B
    if(destActor == none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function InitClientDelayedTeleport()
{
    local MaterialInstanceConstant MIC;

    // End:0x72
    foreach DissolveMICs(MIC)
    {
        MIC.SetScalarParameterValue('Opacity', 0.0000000);
        MIC.SetScalarParameterValue('DissolveAmount', 0.0000000);        
    }    
    GhostingComponent.CreateTeleportTrail(Location + Mesh.Translation, Location + Mesh.Translation, Rotation, Rotation);
    //return;    
}

simulated function bool DelayedTeleport(optional Actor destActor)
{
    local MaterialInstanceConstant MIC;
    local bool bResult;

    // End:0x26
    if(destActor != none)
    {
        TeleportDestActor = destActor;        
    }
    else
    {
        destActor = TeleportDestActor;
    }
    // End:0x307
    if(!bAlreadyTeleported)
    {
        // End:0x66
        if(destActor == none)
        {
            bResult = false;            
        }
        else
        {
            // End:0x98
            if(TeleportDissolveAmount > 0.0000000)
            {
                TeleportDissolveAmount -= 0.0500000;
                bResult = true;                
            }
            else
            {
                // End:0x2F8
                if(SetLocation(destActor.Location))
                {
                    // End:0x134
                    if(!IsLocallyControlled() && PlayerController(Controller) != none)
                    {
                        PlayerController(Controller).ClientSetLocation(destActor.Location, Rotation);
                    }
                    // End:0x1F1
                    if(TeleportEffect != none)
                    {
                        // End:0x1D1
                        if(TeleportEffectPSC == none)
                        {
                            TeleportEffectPSC = new (self) Class'Engine.ParticleSystemComponent';
                            TeleportEffectPSC.SetTemplate(TeleportEffect);
                            AttachComponent(TeleportEffectPSC);
                            TeleportEffectPSC.SetActorParameter('BoneSocketActor', self);                            
                        }
                        else
                        {
                            TeleportEffectPSC.ActivateSystem();
                        }
                    }
                    PlayTeleportEffect(false, true);
                    // End:0x2AE
                    if(bTeleportUpdatesRotation)
                    {
                        SetRotation(destActor.Rotation);
                        // End:0x2AE
                        if(Controller != none)
                        {
                            Controller.SetRotation(destActor.Rotation);
                            Controller.ClientSetRotation(destActor.Rotation);
                        }
                    }
                    // End:0x2DD
                    if(Controller != none)
                    {
                        Controller.OnTeleport(none);
                    }
                    bAlreadyTeleported = true;
                    bResult = true;                    
                }
                else
                {
                    bResult = false;
                }
            }
        }        
    }
    else
    {
        // End:0x383
        if(TeleportDissolveAmount < 1.0000000)
        {
            // End:0x363
            foreach DissolveMICs(MIC)
            {
                MIC.SetScalarParameterValue('DissolveAmount', TeleportDissolveAmount);                
            }            
            TeleportDissolveAmount += 0.0500000;
            bResult = true;            
        }
        else
        {
            ReplicatedTeleportDestActor = none;
        }
    }
    // End:0x3AF
    if(bResult)
    {
        SetTimer(0.0500000, false, GetFuncName());
    }
    return bResult;
    //return ReturnValue;    
}

function AdjustDamage(out int InDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    // End:0x45
    if(bBerserkerMode && !bCanDieInBerserker)
    {
        InDamage = int(FMin(float(Health - 1), float(InDamage)));
    }
    super.AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
    //return;    
}

simulated event SkeletalMeshComponent GetSkeletalMeshComponentForParticleModules(ParticleSystemComponent PSC)
{
    // End:0x80
    if(PSC.Outer == GhostingComponent)
    {
        return GhostingComponent.GhostMeshes[GhostingComponent.GhostIndex].Mesh;        
    }
    else
    {
        return super(EvilPawn).GetSkeletalMeshComponentForParticleModules(PSC);
    }
    //return ReturnValue;    
}

function bool ShouldPlayFullBodyHit(class<DamageType> DamageType, optional Controller EventInstigator)
{
    return (super.ShouldPlayFullBodyHit(DamageType, EventInstigator) && !bIsInvulnerable) && (MyEvilAI == none) || !MyEvilAI.bGodMode;
    //return ReturnValue;    
}

function RecomputeNextHitTime()
{
    NextHitTime = WorldInfo.TimeSeconds + MinTimeBetweenHits;
    //return;    
}

defaultproperties
{
    AnimDefArchetypeAfterLostShield=EvilAnimDef'AnimDefs.AnimDef_AztecMummy'
    // Reference: AdvGhostingEffectComponent'Default__AdvPawn_Sentinel_Base.GhostingComponent0'
    begin object name=GhostingComponent0 class=Class'AdvGhostingEffectComponent'
    end object
    GhostingComponent=GhostingComponent0
    TeleportDissolveAmount=1.0000000
    bHasShield=true
    FireBurnEffectPS=ParticleSystem'ps_Mummy.Effects.ps_ch_BurningMummy'
    LightDamageTime=3.0000000
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Sentinel_Base.WPawnSkeletalMeshComponent_Skeleton'
    begin object name=WPawnSkeletalMeshComponent_Skeleton
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_Sentinel_Base.MyLightEnvironment'
    end object
    SkeletonMesh=WPawnSkeletalMeshComponent_Skeleton
    VulnerableDmgTypeList[0]=Class'AdvDmgType_Crushed'
    VulnerableDmgTypeList[1]=Class'AdvDmgType_TrapCrushed'
    VulnerableDmgTypeList[2]=Class'AdvDmgType_TrapLight'
    VulnerableDmgTypeList[3]=Class'AdvDmgType_TrapSpear'
    VulnerableDmgTypeList[4]=Class'AdvDmgType_TrapBolt'
    NotVulnerableDmgScale=0.0000000
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Sentinel_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_Sentinel_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_Sentinel_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    RequiredAST[0]=false
    RequiredAST[1]=true
    RequiredAST[2]=false
    RequiredAST[3]=false
    RequiredAST[4]=false
    RequiredAST[5]=false
    RequiredAST[6]=false
    RequiredAST[7]=false
    RequiredAST[8]=false
    RequiredAST[9]=false
    RequiredAST[10]=false
    RequiredAST[11]=false
    RequiredAST[12]=false
    RequiredAST[13]=false
    RequiredAST[14]=false
    RequiredAST[15]=false
    RequiredAST[16]=false
    RequiredAST[17]=false
    RequiredAST[18]=false
    RequiredAST[19]=false
    RequiredAST[20]=false
    RequiredAST[21]=false
    RequiredAST[22]=true
    RequiredAST[23]=false
    RequiredAST[24]=false
    RequiredAST[25]=false
    RequiredAST[26]=false
    RequiredAST[27]=false
    RequiredAST[28]=false
    RequiredAST[29]=false
    RequiredAST[30]=false
    RequiredAST[31]=false
    RequiredAST[32]=false
    RequiredAST[33]=false
    RequiredAST[34]=false
    RequiredAST[35]=false
    RequiredAST[36]=false
    RequiredAST[37]=false
    RequiredAST[38]=true
    RequiredAST[39]=false
    RequiredAST[40]=false
    RequiredAST[41]=false
    RequiredAST[42]=false
    RequiredAST[43]=false
    RequiredAST[44]=false
    RequiredAST[45]=false
    RequiredAST[46]=false
    RequiredAST[47]=false
    RequiredAST[48]=false
    RequiredAST[49]=false
    RequiredAST[50]=false
    RequiredAST[51]=false
    RequiredAST[52]=false
    RequiredAST[53]=false
    RequiredAST[54]=false
    RequiredAST[55]=false
    RequiredAST[56]=false
    RequiredAST[57]=false
    RequiredAST[58]=false
    RequiredAST[59]=false
    RequiredAST[60]=false
    RequiredAST[61]=false
    RequiredAST[62]=false
    RequiredAST[63]=false
    RequiredAST[64]=false
    RequiredAST[65]=false
    RequiredAST[66]=false
    RequiredAST[67]=true
    RequiredAST[68]=false
    RequiredAST[69]=true
    RequiredAST[70]=true
    RequiredAST[71]=false
    RequiredAST[72]=false
    RequiredAST[73]=false
    RequiredAST[74]=false
    RequiredAST[75]=false
    RequiredAST[76]=false
    RequiredAST[77]=false
    RequiredAST[78]=false
    RequiredAST[79]=false
    RequiredAST[80]=false
    RequiredAST[81]=false
    RequiredAST[82]=false
    RequiredAST[83]=false
    RequiredAST[84]=false
    RequiredAST[85]=false
    RequiredAST[86]=false
    RequiredAST[87]=false
    RequiredAST[88]=false
    RequiredAST[89]=false
    RequiredAST[90]=false
    RequiredAST[91]=false
    RequiredAST[92]=false
    RequiredAST[93]=false
    RequiredAST[94]=false
    RequiredAST[95]=false
    RequiredAST[96]=false
    RequiredAST[97]=false
    RequiredAST[98]=false
    RequiredAST[99]=false
    RequiredAST[100]=false
    RequiredAST[101]=false
    RequiredAST[102]=false
    RequiredAST[103]=false
    RequiredAST[104]=false
    RequiredAST[105]=false
    RequiredAST[106]=false
    RequiredAST[107]=false
    RequiredAST[108]=true
    RequiredAST[109]=false
    RequiredAST[110]=false
    RequiredAST[111]=false
    RequiredAST[112]=false
    RequiredAST[113]=false
    RequiredAST[114]=false
    RequiredAST[115]=false
    RequiredAST[116]=false
    RequiredAST[117]=false
    RequiredAST[118]=false
    RequiredAST[119]=false
    RequiredAST[120]=false
    RequiredAST[121]=false
    RequiredAST[122]=false
    RequiredAST[123]=false
    RequiredAST[124]=false
    RequiredAST[125]=false
    RequiredAST[126]=false
    RequiredAST[127]=false
    RequiredAST[128]=false
    RequiredAST[129]=false
    RequiredAST[130]=false
    RequiredAST[131]=false
    RequiredAST[132]=false
    RequiredAST[133]=false
    RequiredAST[134]=false
    RequiredAST[135]=false
    RequiredAST[136]=false
    RequiredAST[137]=false
    RequiredAST[138]=false
    RequiredAST[139]=false
    RequiredAST[140]=false
    RequiredAST[141]=false
    RequiredAST[142]=false
    RequiredAST[143]=false
    RequiredAST[144]=false
    RequiredAST[145]=false
    RequiredAST[146]=false
    RequiredAST[147]=false
    RequiredAST[148]=false
    RequiredAST[149]=false
    RequiredAST[150]=false
    RequiredAST[151]=false
    RequiredAST[152]=false
    RequiredAST[153]=false
    RequiredAST[154]=false
    RequiredAST[155]=false
    RequiredAST[156]=false
    RequiredAST[157]=false
    RequiredAST[158]=false
    RequiredAST[159]=false
    RequiredAST[160]=false
    RequiredAST[161]=false
    RequiredAST[162]=false
    RequiredAST[163]=false
    RequiredAST[164]=false
    RequiredAST[165]=false
    RequiredAST[166]=false
    RequiredAST[167]=false
    RequiredAST[168]=false
    RequiredAST[169]=false
    RequiredAST[170]=false
    RequiredAST[171]=false
    RequiredAST[172]=false
    RequiredAST[173]=false
    RequiredAST[174]=false
    RequiredAST[175]=false
    RequiredAST[176]=false
    RequiredAST[177]=false
    RequiredAST[178]=false
    RequiredAST[179]=false
    RequiredAST[180]=false
    RequiredAST[181]=false
    RequiredAST[182]=false
    RequiredAST[183]=false
    RequiredAST[184]=false
    RequiredAST[185]=false
    RequiredAST[186]=false
    RequiredAST[187]=false
    RequiredAST[188]=false
    RequiredAST[189]=false
    RequiredAST[190]=false
    RequiredAST[191]=false
    RequiredAST[192]=false
    RequiredAST[193]=false
    RequiredAST[194]=false
    RequiredAST[195]=false
    RequiredAST[196]=false
    RequiredAST[197]=false
    RequiredAST[198]=false
    RequiredAST[199]=false
    RequiredAST[200]=false
    RequiredAST[201]=false
    RequiredAST[202]=false
    RequiredAST[203]=false
    RequiredAST[204]=false
    RequiredAST[205]=false
    RequiredAST[206]=false
    RequiredAST[207]=false
    RequiredAST[208]=false
    // Reference: AudioComponent'Default__AdvPawn_Sentinel_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bCanBeAffectedByLight=true
    CharacterFootStepType=ECharacterFootStepType.CFST_Sentinel
    DefaultHealth=30000.0000000
    MinTimeBetweenHits=2.0000000
    PawnActionClasses=/* Array type was not detected. */
    SpawnAnims=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_Sentinel_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_Sentinel_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_Sentinel_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Sentinel_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Sentinel_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Sentinel_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_Sentinel_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_Sentinel_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_Sentinel_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_Sentinel_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Sentinel_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_Sentinel_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_Sentinel_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_Sentinel_Base.FaceAudioComponent'
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