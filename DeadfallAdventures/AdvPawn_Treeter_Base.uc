class AdvPawn_Treeter_Base extends AdvPawn_Mummy_Base
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
var() ADVTreeterSpawner_Base TreeterSpawner;
var export editinline AudioComponent HeartAudioComponent;
var array<MaterialInstanceConstant> HeartDissolveMICs;
var EvilPawnClothAssetInterface HeartClothAsset;
var bool bWasDirectHittedByProjectile;

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

simulated function PostAttachedClothComponent(EvilPawnClothAssetInterface clothAsset)
{
    super.PostAttachedClothComponent(clothAsset);
    // End:0x49
    if(clothAsset.IsHeart())
    {
        HeartClothAsset = clothAsset;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x2E
    if(bHasShield)
    {
        bShouldWalkFast = true;
        EquipShield(none);
    }
    Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, Mesh);
    //return;    
}

simulated function AddMICsToArray(MeshComponent MC)
{
    local int I;
    local editinline MeshComponent Child;
    local MaterialInterface MI;
    local MaterialInstanceConstant MIC;

    // End:0x75
    if(MC.IsA('SkeletalMeshComponent'))
    {
        // End:0x74
        foreach SkeletalMeshComponent(MC).AttachedComponents(Class'Engine.MeshComponent', Child)
        {
            AddMICsToArray(Child);            
        }        
    }
    I = 0;
    J0x80:

    // End:0x1FC [Loop If]
    if(I < 1)
    {
        MI = MC.GetMaterial(I);
        // End:0x127
        if((MaterialInstanceConstant(MI) != none) && MI.GetPackageName() == 'Transient')
        {
            MIC = MaterialInstanceConstant(MI);            
        }
        else
        {
            MIC = MC.CreateAndSetMaterialInstanceConstant(I);
        }
        // End:0x1EE
        if(MIC != none)
        {
            // End:0x1D8
            if(NotEqual_InterfaceInterface(EvilPawnClothAssetInterface(MC), EvilPawnClothAssetInterface(none)) && EvilPawnClothAssetInterface(MC).IsHeart())
            {
                HeartDissolveMICs.AddItem(MIC);                                
            }
            else
            {
                DissolveMICs.AddItem(MIC);                
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x80;
    }
    //return;    
}

function bool ShouldPlayFullBodyHit(class<DamageType> DamageType, optional Controller EventInstigator)
{
    return false;
    //return ReturnValue;    
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

function DirectHitByProjectile()
{
    super(EvilPawn).DirectHitByProjectile();
    bWasDirectHittedByProjectile = true;
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local EvilPawnClothAssetInterface clothAsset;

    // End:0x7A
    if((DamageType == Class'AdvDmgType_Leuchpistol') && bWasDirectHittedByProjectile)
    {
        bWasDirectHittedByProjectile = false;
        HitInfo.HitComponent = PrimitiveComponent(HeartClothAsset.GetObject());
    }
    super(AdvPawn).TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    clothAsset = EvilPawnClothAssetInterface(HitInfo.HitComponent);
    // End:0x1A0
    if((NotEqual_InterfaceInterface(clothAsset, EvilPawnClothAssetInterface(none)) && clothAsset.IsHeart()) && clothAsset.GetHealth() <= 0)
    {
        TakeDamage(Health, EventInstigator, HitLocation, Momentum, DamageType,, DamageCauser);
    }
    //return;    
}

simulated function DoSpecialClothActionOnRagdoll(EvilTypes.EClothAssetSpecialActionOnRagdoll Action, EvilPawnClothAssetInterface clothComponent)
{
    // End:0x14
    if(int(Action) == int(3))
    {
    }
    //return;    
}

simulated function DoSpecialClothActionOnZeroHealth(EvilTypes.EClothAssetSpecialActionOnZeroHealth Action, EvilPawnClothAssetInterface clothComponent)
{
    // End:0x14
    if(int(Action) == int(5))
    {
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
    // End:0x151
    if(bHasShield && int(Action) == int(1))
    {
        // End:0x151
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
                // End:0x151
                if(!bStrafing)
                {
                    bForceMoveMode = true;
                    MoveModeToEnforce = 1;
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
    // End:0x119
    if(bInLightCone && bBeamActive)
    {
        // End:0x116
        if(HasShield())
        {
            ForceLimitedMoveMode(1);
        }        
    }
    else
    {
        ForceLimitedMoveMode(6);
    }
    // End:0x346
    if((bInLightCone != bOnLightInfluenceFromFlashLight) || !IsBurning())
    {
        bOnLightInfluenceFromFlashLight = bInLightCone;
        // End:0x1D9
        if(bBeamActive && bInLightCone)
        {
            // End:0x1CC
            if(bOnLightInfluenceFromFlashLight && MyAdvAI != none)
            {
                MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
            }
            StartInLightEffects();            
        }
        else
        {
            // End:0x203
            if(!bOnLightInfluenceFromFlashLight || !bBeamActive)
            {
                StopInLightEffects();
            }
            // End:0x343
            if(bOnLightInfluenceFromFlashLight)
            {
                // End:0x273
                if(LightDissolvePSC == none)
                {
                    LightDissolvePSC = new (self) Class'Engine.ParticleSystemComponent';
                    AttachComponent(LightDissolvePSC);
                    LightDissolvePSC.SetActorParameter('BoneSocketActor', self);
                }
                // End:0x2E6
                if(LightDissolvePSC.Template == LightDissolvePS)
                {
                    LightDissolvePSC.DeactivateSystem();
                    LightDissolvePSC.SetTemplate(LightDissolveWeakPS);
                }
                LightDissolvePSC.ActivateSystem();
                // End:0x343
                if(MyAdvAI != none)
                {
                    MyAdvAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
                }
            }
        }        
    }
    else
    {
        // End:0x36E
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

function CheckGetUpFromAnimation()
{
    super(EvilPawn).CheckGetUpFromAnimation();
    // End:0x38
    if(TreeterSpawner != none)
    {
        TreeterSpawner.OpenSpawner();
    }
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    super.PlayDying(DamageType, HitLoc);
    //return;    
}

simulated function ParticleSystem OverrideHitImpactEffect()
{
    return none;
    //return ReturnValue;    
}

simulated function SetupHitImpactEffect(ParticleSystemComponent PartComp)
{
    //return;    
}

simulated function bool IsValidHitComponent(PrimitiveComponent Comp)
{
    return NotEqual_InterfaceInterface(EvilPawnClothAssetInterface(Comp), EvilPawnClothAssetInterface(none)) && EvilPawnClothAssetInterface(Comp).IsHeart();
    //return ReturnValue;    
}

simulated state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        HeartAudioComponent.Stop();
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        local MaterialInstanceConstant MIC;
        local float DissolveAmount;

        global.Tick(DeltaTime);
        LightDissolveAlpha = FInterpTo(LightDissolveAlpha, 1.0000000, DeltaTime, 0.6000000);
        DissolveAmount = FClamp(1.7500000 - ((WorldInfo.TimeSeconds - DeathTime) / (TimeToBodyDisappear * 0.3000000)), 0.0000000, 1.0000000);
        // End:0xF4
        if(DissolveAmount <= 0.0000000)
        {
            // End:0xF2
            if(!Mesh.HiddenGame)
            {
                Mesh.SetHidden(true);
            }
            return;
        }
        // End:0x17E
        foreach HeartDissolveMICs(MIC)
        {
            MIC.SetScalarParameterValue('DissolveAmount', (DissolveAmount * 0.5700000) ** 0.7500000);
            MIC.SetScalarParameterValue('DissolveLight', Abs(LightDissolveAlpha));            
        }        
        // End:0x1FB
        foreach DissolveMICs(MIC)
        {
            MIC.SetScalarParameterValue('DissolveAmount', DissolveAmount);
            MIC.SetScalarParameterValue('DissolveLight', Abs(LightDissolveAlpha));            
        }        
        //return;        
    }
    stop;    
}

defaultproperties
{
    AnimDefArchetypeAfterLostShield=EvilAnimDef'AnimDefs.AnimDef_AztecMummy'
    // Reference: AudioComponent'Default__AdvPawn_Treeter_Base.HeartAudioComponent0'
    begin object name=HeartAudioComponent0 class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'a_Treeter_CUE.Movement.a_HeartBeat'
        bAutoPlay=true
    end object
    HeartAudioComponent=HeartAudioComponent0
    bBerserkerMode=true
    FireBurnEffectPS=ParticleSystem'ps_Mummy.Effects.ps_ch_BurningMummy'
    LightDamageTime=1.5000000
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Treeter_Base.WPawnSkeletalMeshComponent_Skeleton'
    begin object name=WPawnSkeletalMeshComponent_Skeleton
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_Treeter_Base.MyLightEnvironment'
    end object
    SkeletonMesh=WPawnSkeletalMeshComponent_Skeleton
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Treeter_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_Treeter_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_Treeter_Base.WPawnSkeletalMeshComponent'
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
    RequiredAST[22]=false
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
    RequiredAST[69]=false
    RequiredAST[70]=false
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
    // Reference: AudioComponent'Default__AdvPawn_Treeter_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bCanBeKnockedDown=false
    CharacterFootStepType=ECharacterFootStepType.CFST_Treeter
    DodgeChanceByDamage=1.0000000
    DodgeDelayByDamage=2.0000000
    DefaultHealth=800.0000000
    PawnActionClasses=/* Array type was not detected. */
    LayAnims=/* Array type was not detected. */
    WakeAnims=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_Treeter_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_Treeter_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_Treeter_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Treeter_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Treeter_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Treeter_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_Treeter_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_Treeter_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_Treeter_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_Treeter_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Treeter_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        bUpdateSkelWhenNotRendered=false
        bTickAnimNodesWhenNotRendered=false
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_Treeter_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_Treeter_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_Treeter_Base.FaceAudioComponent'
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
    Components[11]=HeartAudioComponent0
    CollisionComponent=CollisionCylinder
}