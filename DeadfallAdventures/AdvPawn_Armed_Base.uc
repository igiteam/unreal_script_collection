class AdvPawn_Armed_Base extends AdvPawn
    config(Pawn)
    hidecategories(Navigation);

var name CustomAimOffsetProfile;
var AnimNodeBlend BlendByBlinded;
var AnimNodeAdditiveBlending HandCorrectionAdditiveBlend;
var AnimNodeSlot TopHalfSlotOverrideFullSlot;
var bool bBlindedByLight;
var float LastBlindByLightTime;
var float BlindAffectionTime;
var() SoundCue BurnStartSound;
var() SoundCue BurnLoopSound;
var() SoundCue BurnEndSound;
var() float FlashAimDotThreshold;
var AdvAnim_SprintRotator SprintRotatorNode;

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
    //return;    
}

function bool IsReadyToRun()
{
    return super(EvilPawn).IsReadyToRun() && IsReloading();
    //return ReturnValue;    
}

function AnimNodeSlot GetTopHalfAnimSlot()
{
    // End:0x21
    if(int(CoverType) != int(0))
    {
        return TopHalfSlotOverrideFullSlot;        
    }
    else
    {
        return super(EvilPawn).GetTopHalfAnimSlot();
    }
    //return ReturnValue;    
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    // End:0x5D
    if(((WeaponLeft != none) && CurrentWeapon == WeaponLeft) && CurrentWeaponLeftAttachment != none)
    {
        return CurrentWeaponLeftAttachment.GetEffectLocation();        
    }
    else
    {
        // End:0x8F
        if(CurrentWeaponAttachment != none)
        {
            return CurrentWeaponAttachment.GetEffectLocation();            
        }
        else
        {
            return self.Location;
        }
    }
    //return ReturnValue;    
}

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector Loc;
    local Rotator Rot;

    // End:0xEE
    if((((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.Mesh != none) && CurrentWeaponAttachment.MuzzleFlashSocket != 'None') && CurrentWeaponAttachment.Mesh.GetSocketWorldLocationAndRotation(CurrentWeaponAttachment.MuzzleFlashSocket, Loc, Rot, 0))
    {
        Rot.Roll = 0;        
    }
    else
    {
        Rot = super(Pawn).GetAdjustedAimFor(W, StartFireLoc);
    }
    return Rot;
    //return ReturnValue;    
}

simulated function OnStartFire()
{
    StartFire(0);
    super(EvilPawn).OnStartFire();
    //return;    
}

simulated function OnStopFire()
{
    StopFire(0);
    EndPawnAction(11);
    super(EvilPawn).OnStopFire();
    // End:0x5B
    if((!IsInCover() && !IsRidingRailCar()) && CanAim())
    {
        StartAim();
    }
    //return;    
}

simulated function StartAim()
{
    super(EvilPawn).StartAim();
    ServerDoPawnAction(10,,, GetAimAnimIndex());
    //return;    
}

simulated function StopAim()
{
    super(EvilPawn).StopAim();
    // End:0x23
    if(IsAiming())
    {
        EndPawnAction(10);
    }
    //return;    
}

simulated function StartShootAttack()
{
    PlaySoundFromArchetypeByChance(7);
    ServerDoPawnAction(11,,, GetShootAnimPackedIndex());
    //return;    
}

function StartMeleeAttack()
{
    super(EvilPawn).StartMeleeAttack();
    // End:0x21
    if(IsAiming())
    {
        StopAim();
    }
    //return;    
}

simulated function StartReload()
{
    // End:0x28
    if(!IsRidingRailCar())
    {
        ServerDoPawnAction(12,,, GetReloadAnimPackedIndex());
    }
    //return;    
}

function ChangeMoveMode(EvilTypesNative.EMoveMode InNewMode, optional float InBlendTime = -1.0000000)
{
    switch(InNewMode)
    {
        // End:0x21
        case 2:
        // End:0x3D
        case 3:
            OnStopFire();
            StopAim();
            // End:0x40
            break;
        // End:0xFFFF
        default:
            break;
    }
    super(EvilPawn).ChangeMoveMode(InNewMode, InBlendTime);
    //return;    
}

function bool CanSlowDown(EvilAICmd_MoveToGoal MTG)
{
    local float DistanceSq, Radius;
    local Pawn Other;

    // End:0xEF
    if(((((bMovingToCover || !bCanSlowDown) || MyEvilAI == none) || MTG == none) || int(CurrentMoveMode) != int(2)) || (MTG.MoveGoalIsValid() && EvilNavPoint(MTG.MoveGoal) != none) && !EvilNavPoint(MTG.MoveGoal).bCanSlowDown)
    {
        return false;
    }
    DistanceSq = VSizeSq(MTG.GetMoveGoalLocation() - Location);
    Other = Pawn(MTG.MoveGoal);
    Radius = SlowDownDistance;
    // End:0x277
    if(Other != none)
    {
        Radius += (MeleeRange + Other.GetCollisionRadius());
        Radius += (((MyEvilAI.Master != none) && MyEvilAI.Master == Other.Controller) ? MTG.SavedGoalDistance - MTG.ReachedDestinatonThresholdAdjust : DestinationOffset + (GetCollisionRadius()));        
    }
    else
    {
        Radius += (DestinationOffset + (GetCollisionRadius()));
    }
    return (DistanceSq < (Radius * Radius)) && DistanceSq > ((Radius - 10.0000000) * (Radius - 10.0000000));
    //return ReturnValue;    
}

function bool ShouldPlayFullBodyHit(class<DamageType> DamageType, optional Controller EventInstigator)
{
    return super(EvilPawn).ShouldPlayFullBodyHit(DamageType, EventInstigator);
    //return ReturnValue;    
}

function bool ShouldPlayDodge()
{
    return false;
    //return ReturnValue;    
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);
    // End:0xDB
    if(SkelComp == Mesh)
    {
        BlendByBlinded = AnimNodeBlend(Mesh.FindAnimNode('BlendByBlinded'));
        HandCorrectionAdditiveBlend = AnimNodeAdditiveBlending(Mesh.FindAnimNode('HandCorrectionAdditiveBlend'));
        TopHalfSlotOverrideFullSlot = AnimNodeSlot(Mesh.FindAnimNode('TopHalfSlotOverrideFullSlot'));
    }
    // End:0x12B
    if((CustomAimOffsetProfile != 'None') && EvilAimNode != none)
    {
        EvilAimNode.SetActiveProfileByName(CustomAimOffsetProfile);
    }
    //return;    
}

simulated function TestLightAffection(optional bool bOnlySetTimer)
{
    // End:0xA1
    if(!bOnLightInfluenceFromFlashLight && bBlindedByLight)
    {
        // End:0x3B
        if(!bOnlySetTimer)
        {
            SetLightAffectionFromFlashLight(false, false);
        }
        ClearTimer(GetFuncName());
        SetTimer(FMax(0.0000000, (LastBlindByLightTime + BlindAffectionTime) - WorldInfo.TimeSeconds) + 0.1000000, false, GetFuncName());
    }
    //return;    
}

simulated function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    local float FlashAimDot;

    super(EvilPawn).SetLightAffectionFromFlashLight(bInLightCone, bBeamActive);
    // End:0x2D8
    if(bCanBeAffectedByLight && BlendByBlinded != none)
    {
        FlashAimDot = ((IsZero(FlashSourceLocation)) ? 1.0000000 : Normal(FlashSourceLocation - Location) Dot Normal(Vector(Rotation)));
        // End:0x180
        if((bInLightCone && !bBlindedByLight) && FlashAimDot > FlashAimDotThreshold)
        {
            LastBlindByLightTime = WorldInfo.TimeSeconds;
            bBlindedByLight = true;
            bDisableIK = !IsInCover();
            SetHandIKEnabled(false);
            OnIKStatusUpdate();
            BlendByBlinded.SetBlendTarget(1.0000000, 0.4000000);
            // End:0x17D
            if(HandCorrectionAdditiveBlend != none)
            {
                HandCorrectionAdditiveBlend.SetBlendTarget(0.0000000, 0.2500000);
            }            
        }
        else
        {
            // End:0x2CD
            if((((LastBlindByLightTime + BlindAffectionTime) < WorldInfo.TimeSeconds) || !bInLightCone && (LastBlindByLightTime + (BlindAffectionTime * 0.2000000)) < WorldInfo.TimeSeconds) || FlashAimDot < FMax(FlashAimDotThreshold - 0.2500000, -1.0000000))
            {
                bDisableIK = false;
                SetHandIKEnabled(true);
                OnIKStatusUpdate();
                BlendByBlinded.SetBlendTarget(0.0000000, 0.4000000);
                // End:0x2B2
                if(HandCorrectionAdditiveBlend != none)
                {
                    HandCorrectionAdditiveBlend.SetBlendTarget(1.0000000, 0.2500000);
                }
                // End:0x2CD
                if(!bInLightCone)
                {
                    bBlindedByLight = false;
                }
            }
            TestLightAffection(true);
        }
    }
    //return;    
}

simulated function Burn(float InTotalTime, float InDamageInterval, float InDamageAmount, optional bool bMaterialsBlackEffects = true, optional bool bMaterialsDotEffects = true, optional bool bResetActualBlackMaterialValue = true, optional bool bResetActualDotsMaterialValue = true)
{
    super(EvilPawn).Burn(InTotalTime, InDamageInterval, InDamageAmount, bMaterialsBlackEffects, bMaterialsDotEffects, bResetActualBlackMaterialValue, bResetActualDotsMaterialValue);
    // End:0x102
    if((SizzleSoundComponent.SoundCue != BurnStartSound) && SizzleSoundComponent.SoundCue != BurnLoopSound)
    {
        SizzleSoundComponent.SoundCue = BurnStartSound;
        SizzleSoundComponent.Play();
    }
    //return;    
}

simulated function SizzleAudioFinished(AudioComponent AC)
{
    super.SizzleAudioFinished(AC);
    // End:0x18C
    if((AC != none) && !AC.bIsFlushing)
    {
        // End:0x119
        if(IsBurning())
        {
            // End:0xCB
            if(AC.SoundCue == BurnStartSound)
            {
                AC.SoundCue = BurnLoopSound;
                AC.Play();                
            }
            else
            {
                // End:0x116
                if(AC.SoundCue == BurnLoopSound)
                {
                    AC.Play();
                }
            }            
        }
        else
        {
            // End:0x18C
            if(AC.SoundCue != BurnEndSound)
            {
                AC.SoundCue = BurnEndSound;
                AC.Play();
            }
        }
    }
    //return;    
}

simulated function StopBurning()
{
    super(EvilPawn).StopBurning();
    // End:0x7D
    if(SizzleSoundComponent.SoundCue != BurnEndSound)
    {
        SizzleSoundComponent.SoundCue = BurnEndSound;
        SizzleSoundComponent.Play();
    }
    //return;    
}

function bool ShouldPlayHitOnTopHalfOnly()
{
    return super(EvilPawn).ShouldPlayHitOnTopHalfOnly() || (int(CoverType) != int(0)) && bThrowingGrenade;
    //return ReturnValue;    
}

simulated event CacheAnimNodes()
{
    super.CacheAnimNodes();
    SprintRotatorNode = AdvAnim_SprintRotator(Mesh.FindAnimNode('SprintRotator'));
    //return;    
}

simulated function ClearAnimNodes()
{
    super.ClearAnimNodes();
    SprintRotatorNode = none;
    //return;    
}

function MoveModeChanged(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    local Vector Direction;
    local float Speed;
    local Rotator Rot;

    super(EvilPawn).MoveModeChanged(InNewMode, InOldMode);
    // End:0x172
    if(((int(InNewMode) == int(0)) && MyEvilAI != none) && int(MyEvilAI.CurrentBehaviorMode) == int(1))
    {
        Speed = VSize(Velocity);
        // End:0x172
        if(Speed > SprintRotatorNode.SpeedThreshold)
        {
            Direction = Velocity / Speed;
            Rot = Rotator(Direction);
            Rot.Pitch = 0;
            Rot.Roll = 0;
            SetRotation(Rot);
            // End:0x172
            if(TurnInPlaceNode != none)
            {
                TurnInPlaceNode.LastPawnYaw = Rot.Yaw;
            }
        }
    }
    //return;    
}

defaultproperties
{
    BlindAffectionTime=3.5000000
    FlashAimDotThreshold=0.7500000
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Armed_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_Armed_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_Armed_Base.WPawnSkeletalMeshComponent'
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
    RequiredAST[15]=true
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
    RequiredAST[44]=true
    RequiredAST[45]=true
    RequiredAST[46]=true
    RequiredAST[47]=true
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
    SlowDownDistance=195.0000000
    // Reference: AudioComponent'Default__AdvPawn_Armed_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    GrenadeDropChance=0.3000000
    bCanBeAffectedByLight=true
    bShouldPlayDeathAnimationToRagdoll=true
    PawnActionClasses=/* Array type was not detected. */
    GrenadeAmmo=3
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_Armed_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_Armed_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_Armed_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Armed_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_Armed_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Armed_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_Armed_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_Armed_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_Armed_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_Armed_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bCanMantle=true
    // Reference: SkeletalMeshComponent'Default__AdvPawn_Armed_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_Armed_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_Armed_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_Armed_Base.FaceAudioComponent'
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
    CollisionComponent=CollisionCylinder
}