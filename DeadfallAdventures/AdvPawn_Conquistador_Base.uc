class AdvPawn_Conquistador_Base extends AdvPawn_Armed_Base
    abstract
    config(Pawn)
    hidecategories(Navigation)
    implements(AdvLightAffection_interface);

const AddNextHitTime = 0.3;

var repnotify bool bBerserkerMode;
var repnotify transient bool bInFlashlightCone;
var repnotify transient bool bFlashlightBeamActive;
var repnotify bool bReplicateDyingEffects;
var config float BerserkerDamageScalingNormal;
var config float BerserkerDamageScalingEasy;
var config float BerserkerDamageScalingHard;
var float BerserkerDamageScaling;
var ParticleSystem LightHitParticle;
var array<MaterialInstanceConstant> DissolveMICs;
var ParticleSystem FireBurnEffectPS;
var ParticleSystem LightDissolvePS;
var ParticleSystem LightDissolveWeakPS;
var ParticleSystem DeathDissolvePS;
var ParticleSystem DarknessGonePS;
var export editinline ParticleSystemComponent LightDissolvePSC;
var transient float LightDissolveAlpha;
var() config float LightDissolveAccumRate;
var() config float LightDissolveReductionRate;
var() config float LightDissolveMultiplier;
var transient array<AdvInventoryItem_Torch> Flashlights;
var config float LightDamageTime;
var EvilTouchPickUp_AmmoBase BatteryPickupTemplate;
var() export editinline SkeletalMeshComponent SkeletonMesh;
var() array<MaterialInterface> SkeletonMaterials;
var() ParticleSystem SkeletonFalldownEffect;
var() ParticleSystem SkeletonHitEffect;
var() float SkeletonMaterialDissolve;
var array< class<Inventory> > WeaponClassList;
var array< class<EvilDmgType_Base> > VulnerableDmgTypeList;
var float NotVulnerableDmgScale;
var EvilTypesNative.EMoveMode DefaultMoveMode;
var const int StatId;
var config float SurvivalGivenDamageMod;

replication
{
    // Pos:0x000
    if(bNetDirty && !bNetOwner || bDemoRecording
        bBerserkerMode, bFlashlightBeamActive, 
        bInFlashlightCone, bReplicateDyingEffects;
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x2D
        case 'bBerserkerMode':
            SetBerserkerMode(false);
            // End:0x99
            break;
        // End:0x39
        case 'bInFlashlightCone':
        // End:0x67
        case 'bFlashlightBeamActive':
            SetLightAffectionFromFlashLight(bInFlashlightCone, bFlashlightBeamActive);
            // End:0x99
            break;
        // End:0x80
        case 'bReplicateDyingEffects':
            ClientPlayDying();
            // End:0x99
            break;
        // End:0xFFFF
        default:
            super(AdvPawn).ReplicatedEvent(VarName);
            // End:0x99
            break;
            break;
    }
    //return;    
}

function bool AddFlashlight(AdvInventoryItem_Torch addTorch)
{
    // End:0x38
    if(Flashlights.Find(addTorch) == )
    {        
        Flashlights.AddItem(addTorch);        
        return true;
    }
    return false;
    //return ReturnValue;    
}

function RemoveFlashlight(AdvInventoryItem_Torch removeTorch)
{
    Flashlights.RemoveItem(removeTorch);    
    //return;    
}

function bool IsUnderBeamEffect()
{
    local AdvInventoryItem_Torch torch;

    // End:0x3D
    foreach Flashlights(torch)
    {
        // End:0x3C
        if(torch.IsFlashLightBeamActive())
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

function bool CanEngageCharge()
{
    return (((AST_GetAnimCount(114)) > 0) && super(EvilPawn).CanEngageCharge()) && bBerserkerMode;
    //return ReturnValue;    
}

function InitDefaultHealth()
{
    Health = 1000;
    HealthMax = 1000;
    //return;    
}

function SetAimingAnimNodes(bool bRunMode, optional bool bForceOff)
{
    //return;    
}

simulated function StartReload()
{
    //return;    
}

simulated function PostBeginPlay()
{
    local editinline StaticMeshComponent SMC;

    super.PostBeginPlay();
    // End:0x3D
    foreach ComponentList(Class'Engine.StaticMeshComponent', SMC)
    {
        AddMICsToArray(SMC);        
    }    
    //return;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);
    SetupSkeletonMeshAnim();
    OverrideMeshMaterials();
    //return;    
}

simulated function CreatePawnMaterials()
{
    super(EvilPawn).CreatePawnMaterials();
    AddMICsToArray(Mesh);
    //return;    
}

simulated function SetupSkeletonMeshAnim()
{
    local MaterialInterface Mat;
    local int I;

    SkeletonMesh.AnimSets = Mesh.AnimSets;
    SkeletonMesh.SetParentAnimComponent(Mesh);
    // End:0xEF
    if(SkeletonMaterials.Length > 0)
    {
        // End:0xEE
        foreach SkeletonMaterials(Mat, I)
        {
            SkeletonMesh.SetMaterial(I, Mat);
            SkeletonMesh.CreateAndSetMaterialInstanceConstant(I);            
        }        
    }
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
    // End:0x1AC
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
    }
    // End:0x3CD
    if((bInLightCone != bOnLightInfluenceFromFlashLight) || !IsBurning())
    {
        bOnLightInfluenceFromFlashLight = bInLightCone;
        // End:0x260
        if(bBeamActive && bInLightCone)
        {
            // End:0x253
            if(bOnLightInfluenceFromFlashLight && MyAdvAI != none)
            {
                MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
            }
            StartInLightEffects();            
        }
        else
        {
            // End:0x28A
            if(!bOnLightInfluenceFromFlashLight || !bBeamActive)
            {
                StopInLightEffects();
            }
            // End:0x3CA
            if(bOnLightInfluenceFromFlashLight)
            {
                // End:0x2FA
                if(LightDissolvePSC == none)
                {
                    LightDissolvePSC = new (self) Class'Engine.ParticleSystemComponent';
                    AttachComponent(LightDissolvePSC);
                    LightDissolvePSC.SetActorParameter('BoneSocketActor', self);
                }
                // End:0x36D
                if(LightDissolvePSC.Template == LightDissolvePS)
                {
                    LightDissolvePSC.DeactivateSystem();
                    LightDissolvePSC.SetTemplate(LightDissolveWeakPS);
                }
                LightDissolvePSC.ActivateSystem();
                // End:0x3CA
                if(MyAdvAI != none)
                {
                    MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
                }
            }
        }        
    }
    else
    {
        // End:0x406
        if(((IsBurning()) && !bBeamActive) && !bOnLightInfluenceFromVolume)
        {
            StopInLightEffects();
        }
    }
    bFlashlightBeamActive = bBeamActive;
    bInFlashlightCone = bInLightCone;
    bForceNetUpdate = true;
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

simulated function bool CheckBerserkerMode(optional bool bStartBurning = true)
{
    // End:0xBF
    if(!bBerserkerMode && int(WorldInfo.NetMode) != int(NM_Client))
    {
        // End:0xBF
        if(((float(Health) <= (float(HealthMax) * 0.1000000)) || Health == 1) && bCanBeAffectedByLight)
        {
            SetBerserkerMode(bStartBurning);
            Health = int(DefaultHealth);
            HealthMax = int(DefaultHealth);
        }
    }
    return bBerserkerMode;
    //return ReturnValue;    
}

simulated function SetBerserkerMode(optional bool bStartBurning = true)
{
    local editinline ParticleSystemComponent PSC;
    local MaterialInstanceConstant MIC;

    bCanBeAffectedByLight = false;
    bOnLightInfluenceFromVolume = false;
    bOnLightInfluenceFromFlashLight = false;
    StopBurning();
    BurnEffectPS = FireBurnEffectPS;
    // End:0x73
    if(bStartBurning)
    {
        Burn(-1.0000000, 3.0000000, 1.0000000, true, true, false, false);        
    }
    else
    {
        PSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(DarknessGonePS);
        AttachComponent(PSC);
        PSC.SetActorParameter('BoneSocketActor', self);
        PSC.ActivateSystem();
        ClearTimer('LightDissolve_T');
        LightDissolveAlpha = Abs(LightDissolveAlpha);
        DarknessGoneDissolve_T();
        SetTimer(0.0300000, true, 'DarknessGoneDissolve_T');
        // End:0x1BF
        foreach DissolveMICs(MIC)
        {
            MIC.SetScalarParameterValue('Mortal', 1.0000000);            
        }        
    }
    ForceLimitedMoveMode(6);
    CustomTimeDilation = 1.0000000;
    DropClothesOnRagdoll(Class'EvilGame.EvilDmgType_Light', vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), false);
    bForceMoveMode = false;
    RequestDefaultMovementMode();
    // End:0x29B
    if(MyEvilAI != none)
    {
        MyEvilAI.AbortMovingOnEnemyCloseAndVisible(((MyEvilAI.Enemy != none) ? EvilPawn(MyEvilAI.Enemy) : none));
    }
    StartScream();
    bBerserkerMode = true;
    bForceNetUpdate = true;
    SetLightAffectionFromVolume(false);
    //return;    
}

simulated function StartScream()
{
    // End:0x6C
    if((AST_GetAnimCount(86)) > 0)
    {
        // End:0x52
        if(IsTimerActive('Suicide') && int(PawnAction) == 1)
        {
            SetTimer(0.1000000, false, 'StartScream');            
        }
        else
        {
            DoPawnAction(54,,, PackRandomAnimInfo(86));
        }
    }
    //return;    
}

simulated function StartInLightEffects()
{
    CustomTimeDilation = 0.7000000;
    // End:0x114
    if(LightDissolvePS != none)
    {
        // End:0x81
        if(LightDissolvePSC == none)
        {
            LightDissolvePSC = new (self) Class'Engine.ParticleSystemComponent';
            AttachComponent(LightDissolvePSC);
            LightDissolvePSC.SetActorParameter('BoneSocketActor', self);
        }
        // End:0xF4
        if(LightDissolvePSC.Template == LightDissolveWeakPS)
        {
            LightDissolvePSC.DeactivateSystem();
            LightDissolvePSC.SetTemplate(LightDissolvePS);
        }
        LightDissolvePSC.ActivateSystem();
    }
    BurnBlackMaterialAmount = default.BurnBlackMaterialAmount * 0.1500000;
    // End:0x156
    if(LightDissolveAlpha < 0.0000000)
    {
        LightDissolveAlpha = -LightDissolveAlpha;
    }
    SetTimer(0.0300000, true, 'LightDissolve_T');
    //return;    
}

simulated function StopInLightEffects()
{
    CustomTimeDilation = 1.0000000;
    // End:0x3D
    if(LightDissolvePSC != none)
    {
        LightDissolvePSC.DeactivateSystem();
    }
    BurnBlackMaterialAmount = default.BurnBlackMaterialAmount;
    // End:0x93
    if((LightDissolveAlpha > 0.0000000) && !IsTimerActive('DarknessGoneDissolve_T'))
    {
        LightDissolveAlpha = -LightDissolveAlpha;
    }
    //return;    
}

simulated function LightDissolve_T()
{
    local MaterialInstanceConstant MIC;
    local float Damage;
    local AdvInventoryItem_Torch torch;

    // End:0x37
    if(bBerserkerMode && LightDissolveAlpha > 0.0000000)
    {
        LightDissolveAlpha = -LightDissolveAlpha;
    }
    // End:0x8D
    if(LightDissolveAlpha >= 0.0000000)
    {
        LightDissolveAlpha = FMin(((bBerserkerMode) ? 1.0000000 : 0.5000000), LightDissolveAlpha + (0.0300000 * LightDissolveAccumRate));        
    }
    else
    {
        // End:0xE9
        if((Health > 0) && Abs(LightDissolveAlpha) <= 0.2500000)
        {
            LightDissolveAlpha = FMin(0.0000000, LightDissolveAlpha + ((0.0300000 * LightDissolveReductionRate) * 0.1000000));            
        }
        else
        {
            LightDissolveAlpha = FMin(0.0000000, LightDissolveAlpha + (0.0300000 * LightDissolveReductionRate));
        }
        // End:0x154
        if(LightDissolveAlpha == 0.0000000)
        {
            ClearTimer(GetFuncName());
            // End:0x154
            if(bBerserkerMode)
            {
                StopInLightEffects();
            }
        }
    }
    // End:0x1AA
    foreach DissolveMICs(MIC)
    {
        MIC.SetScalarParameterValue('DissolveLight', Abs(LightDissolveAlpha) * LightDissolveMultiplier);        
    }    
    // End:0x32E
    if(!CheckBerserkerMode(false))
    {
        // End:0x2F6
        if(bFlashlightBeamActive)
        {
            Damage = (((float(HealthMax) * 0.0300000) / LightDamageTime) * ((float(Flashlights.Length) * 0.7000000) + 0.3000000)) * ((HasShield()) ? 0.2000000 : 1.0000000);
            // End:0x259
            if(Damage >= float(Health))
            {
                Damage = 0.0000000;
                Health = 1;
            }
            // End:0x2E8
            foreach Flashlights(torch)
            {
                TakeDamage(int(Damage / float(Flashlights.Length)), torch.Instigator.Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Light',, self);                
            }            
            DoBurnBlackMaterialChange();            
        }
        else
        {
            Health = int(FMax(float(Health), (1.0000000 - Abs(LightDissolveAlpha)) * float(HealthMax)));
        }
    }
    //return;    
}

simulated function DoBurnBlackMaterialChange()
{
    super(EvilPawn).DoBurnBlackMaterialChange();
    // End:0x2C
    if(BurnBlackMaterialValue > 0.5000000)
    {
        BurnBlackMaterialValue = 0.5000000;
    }
    //return;    
}

simulated function DarknessGoneDissolve_T()
{
    local MaterialInstanceConstant MIC;

    // End:0x64
    if(LightDissolveAlpha >= 0.0000000)
    {
        LightDissolveAlpha = FInterpTo(LightDissolveAlpha, 1.3000000, 0.0300000, 3.0000000);
        // End:0x61
        if(LightDissolveAlpha > 1.2000000)
        {
            LightDissolveAlpha = -1.3000000;
        }        
    }
    else
    {
        LightDissolveAlpha = FInterpTo(LightDissolveAlpha, -1.0000000, 0.0300000, 3.0000000);
        // End:0xC7
        if(LightDissolveAlpha ~= -1.0000000)
        {
            LightDissolveAlpha = 1.0000000;
            ClearTimer(GetFuncName());
        }
    }
    // End:0x11D
    foreach DissolveMICs(MIC)
    {
        MIC.SetScalarParameterValue('DissolveLight', Abs(LightDissolveAlpha) * LightDissolveMultiplier);        
    }    
    //return;    
}

simulated function ParticleSystem OverrideHitImpactEffect()
{
    // End:0x1C
    if(!IsAliveAndWell())
    {
        return SkeletonHitEffect;        
    }
    else
    {
        // End:0x4D
        if(bBerserkerMode || Abs(LightDissolveAlpha) > 0.0000000)
        {
            return LightHitParticle;            
        }
        else
        {
            return none;
        }
    }
    //return ReturnValue;    
}

simulated function SetupHitImpactEffect(ParticleSystemComponent PartComp)
{
    local editinline ParticleSystemComponent PSC;
    local float HitPower;

    // End:0x2E
    if(bBerserkerMode && IsAliveAndWell())
    {
        HitPower = 13.0000000;        
    }
    else
    {
        HitPower = (((Abs(LightDissolveAlpha) * float(Health)) / float(HealthMax)) * 10.0000000) + FMin(3.0000000, Abs(LightDissolveAlpha) * 3.0000000);
    }
    // End:0x18E
    if(HitPower > 0.0000000)
    {
        // End:0xD4
        if(PartComp.Template == LightHitParticle)
        {
            PSC = PartComp;            
        }
        else
        {
            PSC = WorldInfo.MyEmitterPool.SpawnEmitter(LightHitParticle, PartComp.GetPosition(), PartComp.GetRotation());
        }
        PSC.SetFloatParameter('Power', HitPower);
    }
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    SkeletonMesh.bUpdateSkelWhenNotRendered = true;
    super(EvilPawn).PlayDying(DamageType, HitLoc);
    bReplicateDyingEffects = true;
    bForceNetUpdate = true;
    ClientPlayDying();
    //return;    
}

simulated function ClientPlayDying()
{
    local editinline ParticleSystemComponent PSC;

    // End:0x74
    if(DeathDissolvePS != none)
    {
        PSC = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(DeathDissolvePS);
    }
    // End:0xDF
    if(PSC != none)
    {
        AttachComponent(PSC);
        PSC.SetActorParameter('BoneSocketActor', self);
        PSC.ActivateSystem();
    }
    // End:0x101
    if(int(Role) != int(ROLE_Authority))
    {
        GotoState('Dying');
    }
    //return;    
}

simulated function MaterialInterface GetTopmostParentMaterial(MaterialInstance MI)
{
    // End:0x5F
    if(MaterialInstance(MI.Parent) != none)
    {
        return GetTopmostParentMaterial(MaterialInstance(MI.Parent));
    }
    return MI.Parent;
    //return ReturnValue;    
}

simulated function AddMICsToArray(MeshComponent MC)
{
    local int I;
    local editinline MeshComponent Child;
    local MaterialInterface MI;
    local MaterialInstanceConstant MIC;

    // End:0x3F
    if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.Mesh == MC)
    {
        return;
    }
    // End:0xB4
    if(MC.IsA('SkeletalMeshComponent'))
    {
        // End:0xB3
        foreach SkeletalMeshComponent(MC).AttachedComponents(Class'Engine.MeshComponent', Child)
        {
            AddMICsToArray(Child);            
        }        
    }
    I = 0;
    J0xBF:

    // End:0x1E9 [Loop If]
    if(I < MC.GetNumElements())
    {
        MI = MC.GetMaterial(I);
        // End:0x184
        if((MaterialInstanceConstant(MI) != none) && MI.GetPackageName() == 'Transient')
        {
            MIC = MaterialInstanceConstant(MI);            
        }
        else
        {
            MIC = MC.CreateAndSetMaterialInstanceConstant(I);
        }
        // End:0x1DB
        if(MIC != none)
        {
            DissolveMICs.AddItem(MIC);            
        }
        ++I;
        // [Loop Continue]
        goto J0xBF;
    }
    //return;    
}

function bool ShouldPlayDodge()
{
    return super.ShouldPlayDodge() && !IsBurning();
    //return ReturnValue;    
}

function bool IsBurning()
{
    return super(EvilPawn).IsBurning() || IsTimerActive('LightDissolve_T');
    //return ReturnValue;    
}

function HideMesh()
{
    Mesh.SetHidden(true);
    //return;    
}

simulated function SkeletonMaterialDissolve_T()
{
    local MaterialInterface Mat;
    local MaterialInstanceConstant mit;

    SkeletonMaterialDissolve -= 0.1000000;
    // End:0xE9
    if(SkeletonMaterialDissolve > 0.0000000)
    {
        // End:0xD2
        if(SkeletonMesh.Materials.Length > 0)
        {
            // End:0xD1
            foreach SkeletonMesh.Materials(Mat)
            {
                mit = MaterialInstanceConstant(Mat);
                // End:0xD0
                if(mit != none)
                {
                    mit.SetScalarParameterValue('DissolveAmount', SkeletonMaterialDissolve);
                }                
            }            
        }
        SetTimer(0.1000000, false, GetFuncName());        
    }
    else
    {
        SkeletonMesh.SetHidden(true);
        // End:0x140
        if(IsInState('Dying') && IsTimerActive())
        {
            ClearTimer();
            Timer();
        }
    }
    //return;    
}

function RecomputeNextHitTime()
{
    NextHitTime = WorldInfo.TimeSeconds + (0.3000000 * FMin(2.0000000, GetHitsPerSec()));
    //return;    
}

simulated function OnDeathAnimBodyRest()
{
    // End:0x93
    if(SkeletonFalldownEffect != none)
    {
        WorldInfo.MyEmitterPool.SpawnEmitter(SkeletonFalldownEffect, Location, Rotation, self);
        SetTimer(FMax(TimeToBodyDisappear, 0.1000000), false, 'SkeletonMaterialDissolve_T');
        SetTimer(1.0000000, false, 'HideMesh');
    }
    super(AdvPawn).OnDeathAnimBodyRest();
    //return;    
}

function bool HasRangedAttack()
{
    return (Weapon != none) && !bBerserkerMode;
    //return ReturnValue;    
}

simulated function bool IsInBerserkerMode()
{
    return bBerserkerMode;
    //return ReturnValue;    
}

function bool CanAim()
{
    return false;
    //return ReturnValue;    
}

simulated function ThrowInventory(Inventory Inv, optional Vector ForceVelocity, optional bool bAlternateWeapon)
{
    local Vector Loc, TossVel;
    local Rotator Rot;
    local Vector X, Y, Z;

    GetAxes(Rotation, X, Y, Z);
    Mesh.GetSocketWorldLocationAndRotation(((bAlternateWeapon) ? WeaponSocket2 : WeaponSocket), Loc, Rot, 0);
    // End:0xAC
    if(ForceVelocity != vect(0.0000000, 0.0000000, 0.0000000))
    {
        TossVel = ForceVelocity;        
    }
    else
    {
        TossVel = Normal(Vector(Rot));
    }
    Inv.DropFrom(Loc, TossVel);
    //return;    
}

function DoMeleeAttackDamage()
{
    local EvilWeap_Melee_Base Wpn;

    // End:0x2AA
    if((int(PawnAction) == 5) || int(PawnAction) == 7)
    {
        Wpn = EvilWeap_Melee_Base(MeleeWeapon);
        // End:0x6D
        if(Wpn == none)
        {
            Wpn = EvilWeap_Melee_Base(Weapon);
        }
        // End:0x90
        if(Wpn == none)
        {
            Wpn = FindMeleeWeapon();
        }
        // End:0x2AA
        if(Wpn != none)
        {
            // End:0xB8
            if(CurrentMeleeWeaponAttachmentClass == none)
            {
                WeaponMeleeAttachmentChanged();
            }
            // End:0x177
            if((((Controller == none) || Controller.Enemy == none) || AdvPlayerPawn(Controller.Enemy) == none) || AdvPlayerPawn(Controller.Enemy).GetPlayerController() == none)
            {
                BerserkerDamageScaling = BerserkerDamageScalingNormal;                
            }
            else
            {
                switch(AdvPlayerPawn(Controller.Enemy).GetPlayerController().GetFightDifficultyLevel())
                {
                    // End:0x1EF
                    case 0:
                        BerserkerDamageScaling = BerserkerDamageScalingEasy;
                        // End:0x240
                        break;
                    // End:0x20A
                    case 1:
                        BerserkerDamageScaling = BerserkerDamageScalingNormal;
                        // End:0x240
                        break;
                    // End:0x20F
                    case 2:
                    // End:0x22A
                    case 3:
                        BerserkerDamageScaling = BerserkerDamageScalingHard;
                        // End:0x240
                        break;
                    // End:0xFFFF
                    default:
                        BerserkerDamageScaling = BerserkerDamageScalingNormal;
                        break;
                }
            }
            Wpn.DoMeleeDamage(((bBerserkerMode) ? DamageScaling * BerserkerDamageScaling : DamageScaling), Controller.Enemy);
        }
    }
    //return;    
}

function float SurvivalGivenDamageModifier()
{
    return super(EvilPawn).SurvivalGivenDamageModifier() * SurvivalGivenDamageMod;
    //return ReturnValue;    
}

simulated state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SkeletonMesh.SetHidden(false);
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        local MaterialInstanceConstant MIC;
        local float DissolveAmount;

        global.Tick(DeltaTime);
        LightDissolveAlpha = FInterpTo(LightDissolveAlpha, 0.0000000, DeltaTime, 16.0000000);
        DissolveAmount = FMax(0.0000000, 1.0000000 - ((WorldInfo.TimeSeconds - DeathTime) / (TimeToBodyDisappear * 0.3000000)));
        // End:0xCF
        if(DissolveAmount <= 0.0000000)
        {
            // End:0xCD
            if(!Mesh.HiddenGame)
            {
            }
            return;
        }
        // End:0x118
        foreach DissolveMICs(MIC)
        {
            MIC.SetScalarParameterValue('DissolveAmount', DissolveAmount);            
        }        
        //return;        
    }

    event Timer()
    {
        // End:0x4B
        if(Mesh.HiddenGame && SkeletonMesh.HiddenGame)
        {
            Destroy();
            return;
        }
        super.Timer();
        //return;        
    }
    stop;    
}

defaultproperties
{
    LightHitParticle=ParticleSystem'ps_Mummy.Effects.ps_ch_InLightHit'
    FireBurnEffectPS=ParticleSystem'ps_Mummy.Effects.ps_ch_BurningMummy'
    LightDissolvePS=ParticleSystem'ps_Mummy.Effects.ps_ch_MummyOnLight'
    LightDissolveWeakPS=ParticleSystem'ps_Mummy.Effects.ps_ch_MummyOnWeakLight'
    DeathDissolvePS=ParticleSystem'ps_Mummy.Effects.ps_ch_MummyDying'
    DarknessGonePS=ParticleSystem'ps_Mummy.Effects.ps_ch_MummyMortal'
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Conquistador_Base.WPawnSkeletalMeshComponent_Skeleton'
    begin object name=WPawnSkeletalMeshComponent_Skeleton class=Class'Engine.SkeletalMeshComponent'
        MinDistFactorForKinematicUpdate=0.2000000
        bUpdateSkelWhenNotRendered=false
        bIgnoreControllersWhenNotRendered=true
        bPerBoneMotionBlur=true
        bOverrideAttachmentOwnerVisibility=true
        bChartDistanceFactor=true
        bCacheAnimSequenceNodes=false
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_Conquistador_Base.MyLightEnvironment'
        RBChannel=ERBCollisionChannel.RBCC_Untitled3
        RBDominanceGroup=20
        HiddenGame=true
        bOwnerNoSee=true
        bUseOnePassLightingOnTranslucency=true
        BlockRigidBody=true
        RBCollideWithChannels=(Untitled3=true)
    end object
    SkeletonMesh=WPawnSkeletalMeshComponent_Skeleton
    SkeletonMaterialDissolve=1.0000000
    VulnerableDmgTypeList[0]=Class'AdvDmgType_Crushed'
    VulnerableDmgTypeList[1]=Class'AdvDmgType_MG34'
    VulnerableDmgTypeList[2]=Class'AdvDmgType_Leuchpistol'
    VulnerableDmgTypeList[3]=Class'AdvDmgType_Grenade'
    VulnerableDmgTypeList[4]=Class'AdvDmgType_TrapLight'
    VulnerableDmgTypeList[5]=Class'AdvDmgType_TrapCrushed'
    VulnerableDmgTypeList[6]=Class'AdvDmgType_TrapSpear'
    VulnerableDmgTypeList[7]=Class'AdvDmgType_TrapBolt'
    VulnerableDmgTypeList[8]=Class'AdvDmgType_MummyHands_perk'
    VulnerableDmgTypeList[9]=Class'AdvDmgType_MG34_perk'
    VulnerableDmgTypeList[10]=Class'AdvDmgType_PZB38_perk'
    NotVulnerableDmgScale=0.2500000
    DefaultMoveMode=EMoveMode.None
    bCanDoFinisher=true
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Conquistador_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_Conquistador_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_Conquistador_Base.WPawnSkeletalMeshComponent'
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
    RequiredAST[41]=true
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
    // Reference: AudioComponent'Default__AdvPawn_Conquistador_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
        SoundCue=SoundCue'a_AztecMummy_CUE.a_MummyFry'
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bLightInfluenceEnabled=true
    TimeToBodyDisappear=12.0000000
    PawnActionClasses=/* Array type was not detected. */
    SpawnAnims=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_Conquistador_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_Conquistador_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_Conquistador_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Conquistador_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Conquistador_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Conquistador_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_Conquistador_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_Conquistador_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_Conquistador_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_Conquistador_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bIsWalking=true
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Conquistador_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_Conquistador_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_Conquistador_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_Conquistador_Base.FaceAudioComponent'
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
    RotationRate=(Pitch=40000,Yaw=40000,Roll=40000)
}