class EvilDmgType_Base extends DamageType
    abstract;

var LinearColor DamageBodyMatColor;
var float DamageOverlayTime;
var float DeathOverlayTime;
var float XRayEffectTime;
var bool bCausesBlood;
var bool bLocationalHit;
var bool bAlwaysGibs;
var bool bNeverGibs;
var bool bCanDoPartialGibs;
var bool bDirectDamage;
var bool bSeversHead;
var bool bCauseConvulsions;
var bool bUseTearOffMomentum;
var bool bThrowRagdoll;
var bool bLeaveBodyEffect;
var bool bBulletHit;
var bool bVehicleHit;
var bool bSelfDestructDamage;
var() bool bUseDamageBasedDeathEffects;
var bool bSpecialDeathCamera;
var bool bCanPlayDeathAnim;
var(DeathAnim) bool bAnimateHipsForDeathAnim;
var bool bComplainFriendlyFire;
var bool bOverrideHitEffectColor;
var bool bHeadGibCamera;
var bool bCausesBloodSplatterDecals;
var bool bDontHurtInstigator;
var bool bIsLightDmgType;
var bool bIsFireDmgType;
var float GibPerterbation;
var int GibThreshold;
var int MinAccumulateDamageThreshold;
var int AlwaysGibDamageThreshold;
var float PhysicsTakeHitMomentumThreshold;
var class<EvilWeap_Base> DamageWeaponClass;
var int DamageWeaponFireMode;
var ParticleSystem GibTrail;
var protected class<UDKEmitCameraEffect> DeathCameraEffectVictim;
var protected class<UDKEmitCameraEffect> DeathCameraEffectInstigator;
var(DeathAnim) name DeathAnim;
var(DeathAnim) float DeathAnimRate;
var(DeathAnim) float MotorDecayTime;
var(DeathAnim) float StopAnimAfterDamageInterval;
var array<CameraAnim> DamageCameraAnim;
var float NodeDamageScaling;
var name KillStatsName;
var name DeathStatsName;
var name SuicideStatsName;
var int RewardCount;
var class<UTLocalMessage> RewardAnnouncementClass;
var int RewardAnnouncementSwitch;
var name RewardEvent;
var int CustomTauntIndex;
var LinearColor HitEffectColor;
var() const localized string DeathString;
var() const localized string FemaleSuicide;
var() const localized string MaleSuicide;
var const EvilTypes.EImpactTypeBallistic ImpactTypeBallisticID;
var const EvilTypes.EImpactTypeExplosion ImpactTypeExplosionID;
var() const localized string SuicideString1;
var() const localized string SuicideString2;
var() const localized string SuicideString3;
var() const localized string SuicideString4;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    return default.DeathString;
    //return ReturnValue;    
}

static function string SuicideMessage(PlayerReplicationInfo Victim)
{
    local int SuicideStringIndex;
    local string SelectedSuicideString;

    SuicideStringIndex = Rand(4);
    switch(SuicideStringIndex)
    {
        // End:0x3B
        case 0:
            SelectedSuicideString = default.SuicideString1;
            // End:0x8E
            break;
        // End:0x55
        case 1:
            SelectedSuicideString = default.SuicideString2;
            // End:0x8E
            break;
        // End:0x70
        case 2:
            SelectedSuicideString = default.SuicideString3;
            // End:0x8E
            break;
        // End:0x8B
        case 3:
            SelectedSuicideString = default.SuicideString4;
            // End:0x8E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return SelectedSuicideString;
    //return ReturnValue;    
}

static function SpawnHitEffect(Pawn P, float Damage, Vector Momentum, name BoneName, Vector HitLocation)
{
    //return;    
}

static function float GetHitEffectDuration(Pawn P, float Damage)
{
    return 0.5000000;
    //return ReturnValue;    
}

static function int IncrementKills(EvilPlayerReplicationInfo KillerPRI)
{
    local int KillCount;

    KillCount = KillerPRI.IncrementKillStat(GetStatsName('Kills'));
    // End:0x116
    if((KillCount == default.RewardCount) && UTPlayerController(KillerPRI.Owner) != none)
    {
        UTPlayerController(KillerPRI.Owner).ReceiveLocalizedMessage(default.RewardAnnouncementClass, default.RewardAnnouncementSwitch);
        // End:0xEE
        if(default.RewardEvent == 'None')
        {            
        }
        else
        {
            KillerPRI.IncrementEventStat(default.RewardEvent);
        }
    }
    return KillCount;
    //return ReturnValue;    
}

static function IncrementDeaths(EvilPlayerReplicationInfo KilledPRI)
{
    KilledPRI.IncrementDeathStat(GetStatsName('Deaths'));
    //return;    
}

static function IncrementSuicides(EvilPlayerReplicationInfo KilledPRI)
{
    KilledPRI.IncrementSuicideStat(GetStatsName('SUICIDES'));
    //return;    
}

static function name GetStatsName(name StatType)
{
    switch(StatType)
    {
        // End:0x4D
        case 'Kills':
            // End:0x43
            if(default.KillStatsName != 'None')
            {
                return default.KillStatsName;                
            }
            else
            {
                return 'KILLS_ENVIRONMENT';
            }
        // End:0x87
        case 'Deaths':
            // End:0x7D
            if(default.DeathStatsName != 'None')
            {
                return default.DeathStatsName;                
            }
            else
            {
                return 'DEATHS_ENVIRONMENT';
            }
        // End:0xC1
        case 'SUICIDES':
            // End:0xB7
            if(default.SuicideStatsName != 'None')
            {
                return default.SuicideStatsName;                
            }
            else
            {
                return 'SUICIDES_ENVIRONMENT';
            }
        // End:0xFFFF
        default:
            return 'BAD_STAT';
            break;
    }
    //return ReturnValue;    
}

static function ScoreKill(EvilPlayerReplicationInfo KillerPRI, EvilPlayerReplicationInfo KilledPRI, Pawn KilledPawn)
{
    // End:0x3C
    if(KillerPRI == KilledPRI)
    {
        // End:0x39
        if(KillerPRI != none)
        {
            IncrementSuicides(KillerPRI);
        }        
    }
    else
    {
        // End:0x5E
        if(KillerPRI != none)
        {
            IncrementKills(KillerPRI);
        }
        // End:0x80
        if(KilledPRI != none)
        {
            IncrementDeaths(KilledPRI);
        }
    }
    //return;    
}

static function PawnTornOff(UTPawn DeadPawn)
{
    //return;    
}

static function SpawnGibEffects(EvilGib Gib)
{
    local editinline ParticleSystemComponent Effect;

    // End:0x7F
    if(default.GibTrail != none)
    {
        Effect = new (Gib) Class'UTParticleSystemComponent';
        Effect.SetTemplate(default.GibTrail);
        Gib.AttachComponent(Effect);
    }
    //return;    
}

static function bool ShouldGib(UTPawn DeadPawn)
{
    // End:0x3B
    if(DeadPawn.WorldInfo.IsConsoleBuild(3))
    {
        return true;
    }
    return !default.bNeverGibs && (default.bAlwaysGibs || DeadPawn.AccumulateDamage > float(default.AlwaysGibDamageThreshold)) || (DeadPawn.Health < default.GibThreshold) && DeadPawn.AccumulateDamage > float(default.MinAccumulateDamageThreshold);
    //return ReturnValue;    
}

static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, Vector Momentum)
{
    //return;    
}

static function DoCustomDamageEffects(UTPawn ThePawn, class<EvilDmgType_Base> TheDamageType, const out TraceHitInfo HitInfo, Vector HitLocation)
{
    //return;    
}

static function CreateDeathSkeleton(UTPawn ThePawn, class<EvilDmgType_Base> TheDamageType, const out TraceHitInfo HitInfo, Vector HitLocation)
{
    local array<Attachment> PreviousAttachments;
    local int Idx;
    local editinline SkeletalMeshComponent PawnMesh;
    local Vector Impulse, ShotDir;
    local MaterialInstanceTimeVarying MITV_BurnOut;
    local class<EvilFamilyInfoBase> FamilyInfo;

    FamilyInfo = ThePawn.GetFamilyInfo();
    // End:0x4F
    if(FamilyInfo.default.DeathMeshSkelMesh == none)
    {
        return;
    }
    PawnMesh = ThePawn.Mesh;
    ShotDir = Normal(ThePawn.TearOffMomentum);
    PreviousAttachments = PawnMesh.Attachments;
    ThePawn.SetCollisionSize(1.0000000, 1.0000000);
    ThePawn.CylinderComponent.SetTraceBlocking(false, false);
    PawnMesh.SetSkeletalMesh(FamilyInfo.default.DeathMeshSkelMesh, true);
    // End:0x1D7
    if(FamilyInfo.default.DeathMeshPhysAsset != none)
    {
        PawnMesh.SetPhysicsAsset(ThePawn.static.GetFamilyInfo().default.DeathMeshPhysAsset);
    }
    Idx = 0;
    J0x1E2:

    // End:0x2F7 [Loop If]
    if(Idx < FamilyInfo.default.SkeletonBurnOutMaterials.Length)
    {
        MITV_BurnOut = new (PawnMesh.Outer) Class'Engine.MaterialInstanceTimeVarying';
        MITV_BurnOut.SetParent(FamilyInfo.default.SkeletonBurnOutMaterials[Idx]);
        PawnMesh.SetMaterial(Idx, MITV_BurnOut);
        MITV_BurnOut.SetScalarStartTime('BurnAmount', 1.0000000);
        ++Idx;
        // [Loop Continue]
        goto J0x1E2;
    }
    // End:0x38B
    if(PawnMesh.PhysicsAssetInstance != none)
    {
        PawnMesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
        PawnMesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(false, false);        
    }
    Idx = 0;
    J0x396:

    // End:0x499 [Loop If]
    if(Idx < PreviousAttachments.Length)
    {
        PawnMesh.AttachComponent(PreviousAttachments[Idx].Component, PreviousAttachments[Idx].BoneName, PreviousAttachments[Idx].RelativeLocation, PreviousAttachments[Idx].RelativeRotation, PreviousAttachments[Idx].RelativeScale);
        ++Idx;
        // [Loop Continue]
        goto J0x396;
    }
    Idx = 0;
    J0x4A4:

    // End:0x539 [Loop If]
    if(Idx < FamilyInfo.default.DeathMeshNumMaterialsToSetResident)
    {
        FamilyInfo.default.DeathMeshSkelMesh.Materials[Idx].SetForceMipLevelsToBeResident(false, false, 10.0000000);
        ++Idx;
        // [Loop Continue]
        goto J0x4A4;
    }
    Impulse = ShotDir * float(Min(int(TheDamageType.default.KDamageImpulse), 10));
    BoneBreaker(ThePawn, PawnMesh, Impulse, HitLocation, HitInfo.BoneName);
    //return;    
}

static function BoneBreaker(UTPawn ThePawn, SkeletalMeshComponent TheMesh, Vector Impulse, Vector HitLocation, name BoneName)
{
    local int NumBonesToPossiblyBreak, ConstraintIndex;

    NumBonesToPossiblyBreak = ThePawn.static.GetFamilyInfo().default.DeathMeshBreakableJoints.Length;
    // End:0x16E
    if(NumBonesToPossiblyBreak > 0)
    {
        BoneName = ThePawn.static.GetFamilyInfo().default.DeathMeshBreakableJoints[Rand(NumBonesToPossiblyBreak)];
        ConstraintIndex = TheMesh.FindConstraintIndex(BoneName);
        // End:0x16E
        if(ConstraintIndex != -1)
        {
            TheMesh.PhysicsAssetInstance.Constraints[ConstraintIndex].TermConstraint();
            TheMesh.AddImpulse(Impulse, HitLocation, BoneName);            
        }
    }
    //return;    
}

static function CreateDeathGoreChunks(UTPawn ThePawn, class<EvilDmgType_Base> TheDamageType, const out TraceHitInfo HitInfo, Vector HitLocation)
{
    local int I;
    local bool bSpawnHighDetail;
    local EvilGib TheGib;
    local GibInfo GibInfo;

    // End:0x140
    if((ThePawn.static.GetFamilyInfo().default.GibExplosionTemplate != none) && ThePawn.EffectIsRelevant(ThePawn.Location, false, 7000.0000000))
    {
        ThePawn.WorldInfo.MyEmitterPool.SpawnEmitter(ThePawn.static.GetFamilyInfo().default.GibExplosionTemplate, ThePawn.Location, ThePawn.Rotation);
    }
    bSpawnHighDetail = !ThePawn.WorldInfo.bDropDetail && (ThePawn.WorldInfo.TimeSeconds - ThePawn.LastRenderTime) < float(1);
    I = 0;
    J0x1E9:

    // End:0x347 [Loop If]
    if(I < ThePawn.CurrCharClassInfo.default.Gibs.Length)
    {
        GibInfo = ThePawn.CurrCharClassInfo.default.Gibs[I];
        // End:0x339
        if(bSpawnHighDetail || !GibInfo.bHighDetailOnly)
        {
            TheGib = ThePawn.SpawnGib(GibInfo.GibClass, GibInfo.BoneName, TheDamageType, HitLocation, true);
            // End:0x339
            if(TheGib != none)
            {
                SpawnExtraGibEffects(TheGib);
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x1E9;
    }
    ThePawn.bGibbed = true;
    //return;    
}

static simulated function SpawnExtraGibEffects(EvilGib TheGib)
{
    //return;    
}

static simulated function DrawKillIcon(Canvas Canvas, float ScreenX, float ScreenY, float HUDScaleX, float HUDScaleY)
{
    // End:0x5B
    if(default.DamageWeaponClass != none)
    {
        default.DamageWeaponClass.static.DrawKillIcon(Canvas, ScreenX, ScreenY, HUDScaleX, HUDScaleY);
    }
    //return;    
}

static simulated function CalcDeathCamera(UTPawn P, float DeltaTime, out Vector CameraLocation, out Rotator CameraRotation, out float CameraFOV)
{
    //return;    
}

static simulated function class<UDKEmitCameraEffect> GetDeathCameraEffectInstigator(UTPawn UTP)
{
    return default.DeathCameraEffectInstigator;
    //return ReturnValue;    
}

static simulated function class<UDKEmitCameraEffect> GetDeathCameraEffectVictim(UTPawn UTP)
{
    return default.DeathCameraEffectVictim;
    //return ReturnValue;    
}

defaultproperties
{
    DamageBodyMatColor=(R=10.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    DamageOverlayTime=0.1000000
    DeathOverlayTime=0.1000000
    bLocationalHit=true
    bDirectDamage=true
    bAnimateHipsForDeathAnim=true
    bComplainFriendlyFire=true
    bHeadGibCamera=true
    bCausesBloodSplatterDecals=true
    GibPerterbation=0.0600000
    GibThreshold=-50
    MinAccumulateDamageThreshold=50
    AlwaysGibDamageThreshold=150
    PhysicsTakeHitMomentumThreshold=250.0000000
    DeathAnimRate=1.0000000
    NodeDamageScaling=1.0000000
    KillStatsName="KILLS_ENVIRONMENT"
    DeathStatsName="DEATHS_ENVIRONMENT"
    SuicideStatsName="SUICIDES_ENVIRONMENT"
    RewardAnnouncementClass=Class'EvilWeaponRewardMessage'
    CustomTauntIndex=-1
    HitEffectColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    DeathString="`k <img src='skull'> `o"
    SuicideString1="`o <img src='skull'>"
    SuicideString2="`o <img src='skull'>"
    SuicideString3="`o <img src='skull'>"
    SuicideString4="`o <img src='skull'>"
    bExtraMomentumZ=false
    bCausesFracture=true
    KDamageImpulse=0.0000000
    RadialDamageImpulse=750.0000000
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0 class=Class'Engine.ForceFeedbackWaveform'
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__EvilDmgType_Base.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1 class=Class'Engine.ForceFeedbackWaveform'
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}