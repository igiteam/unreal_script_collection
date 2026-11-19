class AdvPawn_MonkMummy_Base extends AdvPawn_Mummy_Base
    abstract
    config(Pawn)
    hidecategories(Navigation);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, Mesh);
    //return;    
}

function EquipRandomInventory()
{
    SwitchWeapon(EvilWeap_Base(CreateInventory(class<Inventory>(DynamicLoadObject("ADVGameContent.AdvWeap_Melee_MummyStaff_NPC", Class'Core.Class')), false)).InventoryGroup);
    InvManager.SwitchToBestWeapon(true);
    //return;    
}

function ThrowWeaponOnRagdoll()
{
    ThrowActiveWeapon();
    //return;    
}

function DoBurnDamageTimer()
{
    // End:0x56
    if(bOnLightInfluenceFromVolume || bOnLightInfluenceFromFlashLight)
    {
        TakeDamage(int(BurningDamageAmount), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Light',, self);        
    }
    else
    {
        TakeDamage(int(BurningDamageAmount), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Fire',, self);
    }
    // End:0x160
    if((float(Health) < (float(HealthMax) * 0.3000000)) && bCanBeAffectedByLight)
    {
        bCanBeAffectedByLight = false;
        bOnLightInfluenceFromVolume = false;
        bOnLightInfluenceFromFlashLight = false;
        StopBurning();
        BurnEffectPS = FireBurnEffectPS;
        Burn(-1.0000000, 3.0000000, 40.0000000,,, false, false);
        CustomTimeDilation = 1.0000000;
        bForceMoveMode = false;
        RequestDefaultMovementMode();
        ServerDoPawnAction(54,,, PackAnimInfo(86, 0));        
    }
    else
    {
        PlayFireHitSound();
    }
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

function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
    local UTPlayerController Hearer;
    local class<EvilDmgType_Base> EvilDamageType;
    local bool HitSoundPlayed;
    local editinline EvilAudioComponent EvilFacialAudioComp;

    EvilDamageType = class<EvilDmgType_Base>(DamageType);
    EvilFacialAudioComp = EvilAudioComponent(FacialAudioComp);
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
    FireBurnEffectPS=ParticleSystem'ps_Mummy.Effects.ps_ch_BurningMummy'
    // Reference: SkeletalMeshComponent'Default__AdvPawn_MonkMummy_Base.WPawnSkeletalMeshComponent_Skeleton'
    begin object name=WPawnSkeletalMeshComponent_Skeleton
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_MonkMummy_Base.MyLightEnvironment'
    end object
    SkeletonMesh=WPawnSkeletalMeshComponent_Skeleton
    // Reference: SkeletalMeshComponent'Default__AdvPawn_MonkMummy_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_MonkMummy_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_MonkMummy_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    // Reference: AudioComponent'Default__AdvPawn_MonkMummy_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    CharacterFootStepType=ECharacterFootStepType.CFST_AztecMummy
    PawnActionClasses=/* Array type was not detected. */
    SpawnAnims=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_MonkMummy_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_MonkMummy_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_MonkMummy_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_MonkMummy_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_MonkMummy_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_MonkMummy_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_MonkMummy_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_MonkMummy_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_MonkMummy_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_MonkMummy_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_MonkMummy_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_MonkMummy_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_MonkMummy_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_MonkMummy_Base.FaceAudioComponent'
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