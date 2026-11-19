class SkyPawnBase extends GamePawn
    abstract
    native
    nativereplication
    config(Game);

const NumFootstepComps = 4;

enum ESkyWeaponHand
{
    SKY_HAND_Right,                 // 0
    SKY_HAND_Left,                  // 1
    SKY_HAND_Centered,              // 2
    SKY_HAND_Hidden,                // 3
    SKY_HAND_MAX                    // 4
};

struct native ViewShakeInfo
{
    var() Vector OffsetMag;
    var() Vector OffsetRate;
    var() float OffsetTime;
    var() Vector RotMag;
    var() Vector RotRate;
    var() float RotTime;
    var() float minTime;
    var float StartTime;

    structdefaultproperties
    {
        OffsetMag=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        OffsetRate=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        OffsetTime=0.0000000
        RotMag=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RotRate=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RotTime=0.0000000
        minTime=0.0000000
        StartTime=0.0000000
    }
};

struct native BloodEffectInfo
{
    var() float Health;
    var() ParticleSystem BloodTemplate;

    structdefaultproperties
    {
        Health=0.0000000
        BloodTemplate=none
    }
};

struct native TakeHitInfo
{
    var int Damage;
    var Vector HitLocation;
    var Vector Momentum;
    var class<DamageType> DamageType;
    var name HitBone;
    var float DeathImpulse;
    var float FloatingImpulse;
    var float LaunchingImpulse;
    var ParticleSystem BloodTemplate;

    structdefaultproperties
    {
        Damage=0
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DamageType=none
        HitBone="None"
        DeathImpulse=0.0000000
        FloatingImpulse=0.0000000
        LaunchingImpulse=0.0000000
        BloodTemplate=none
    }
};

struct native FootIKInfo
{
    var() name FootBoneName;
    var() name FootControlName;
    var SkelControlFootPlacement Control;

    structdefaultproperties
    {
        FootBoneName="None"
        FootControlName="None"
        Control=none
    }
};

struct native CachedFootPlacementLineCheck
{
    var transient Vector LastStart;
    var transient Vector LastEnd;
    var transient Vector LastHitLocation;
    var transient Vector LastHitNormal;
    var transient float LastHitTime;
    var transient bool LastResult;

    structdefaultproperties
    {
        LastStart=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LastEnd=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LastHitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LastHitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LastHitTime=0.0000000
        LastResult=false
    }
};

struct native SkyDrivenWeaponPawnInfo
{
    var SkyGameVehicle BaseVehicle;
    var byte SeatIndex;
    var PlayerReplicationInfo PRI;

    structdefaultproperties
    {
        BaseVehicle=none
        SeatIndex=0
        PRI=none
    }
};

var bool bSpawnDone;
var bool bSpawnIn;
var bool bIsTyping;
var bool bDodging;
var bool bNoJumpAdjust;
var(Health) bool bIsInvulnerable;
var bool bIsInvisible;
var repnotify bool bFeigningDeath;
var bool bPlayingFeignDeathRecovery;
var bool bForcedFeignDeath;
var(TechPoints) bool bCollectingTechPoints;
var(Effects) bool bNoBloodEffects;
var bool bBlendOutTakeHitPhysics;
var(FootPlacement) bool bEnableFootPlacement;
var bool bFirstFootPlacementUpdateDone;
var bool bNotifyStopFalling;
var bool bReceivedValidTeam;
var transient bool bWasInAntiGrav;
var(Ragdoll) float RagdollThresholdVelocity;
var(Ragdoll) float PhysicsTakeHitMomentumThreshold;
var float FeignDeathBodyAtRestSpeed;
var float FeignDeathPhysicsBlendOutSpeed;
var float FeignDeathKillTime;
var float FeignDeathStartTime;
var float FeignDeathRecoveryStartTime;
var(Ragdoll) float RagdollRecoveryTime;
var(Lighting) export editinline LightEnvironmentComponent LightEnvironment;
var int MaxLeanRoll;
var SkyPawnBase.ESkyWeaponHand WeaponHand;
var repnotify byte WeaponOverlayFlags;
var(Sounds) SkyPawnSoundGroupBase SoundGroup;
var(Sounds) array<SkyPawnSoundGroupBase> PossibleSoundGroups;
var int curFootstep;
var export editinline AudioComponent FootstepComponent[4];
var editinline class<SkyEmitter> BloodEmitterClass;
var deprecated ParticleSystem BloodEmitterTemplate;
var(Effects) array<BloodEffectInfo> BloodEmitterTemplates;
var(Ragdoll) PhysicsAsset RagdollPhysicsAsset;
var(Ragdoll) PhysicsAsset TakeHitPhysicsAsset;
var(Ragdoll) PhysicsAsset DeathPhysicsAsset;
var deprecated float ImpulseScale;
var repnotify TakeHitInfo LastTakeHitInfo;
var float LastTakeHitTimeout;
var(Ragdoll) float TakeHitPhysicsBlendOutSpeed;
var(SkyPawn) name WeaponBone;
var name HeadBone;
var protected export editinline AudioComponent PawnAmbientSound;
var protected repnotify SoundCue AmbientSoundCue;
var float BodyMatFadeDuration;
var float RemainingBodyMatDuration;
var repnotify float ClientBodyMatDuration;
var LinearColor BodyMatColor;
var LinearColor CurrentBodyMatColor;
var LinearColor SpawnProtectionColor;
var name DamageParameterName;
var protected array<MaterialInstanceConstant> BodyMaterialInstances;
var protected repnotify MaterialInterface OverlayMaterialInstance;
var protected export editinline SkeletalMeshComponent OverlayMesh;
var float LastPainSound;
var float RagdollLifespan;
var(FootPlacement) array<FootIKInfo> FootIKData;
var(FootPlacement) float FootIKDisplacementSpeed;
var float BaseTranslationOffset;
var float CrouchTranslationOffset;
var float OldLocationZ;
var const float ZSmoothingRate;
var(FootPlacement) float MaxFootPlacementDistSquared;
var float ZTranslationFromMesh;
var transient float FootPlacementCheckUsePrevResultDeltaDist;
var transient int MaxCachedFootPlacementChecks;
var transient int CurrentCachedFootPlacementCheckNum;
var transient int CurrentCachedFootPlacementCheckIndex;
var transient array<CachedFootPlacementLineCheck> CachedFootPlacementChecks;
var float CustomGravityScaling;
var repnotify Material ReplicatedBodyMaterial;
var repnotify SkyDrivenWeaponPawnInfo DrivenWeaponPawn;
var SkyDrivenWeaponPawnInfo LastDrivenWeaponPawn;
var SkyClientSideWeaponPawn ClientSideWeaponPawn;
var float FootDisplacement;

replication
{
    // Pos:0x000
    if(bNetDirty
        AmbientSoundCue, BodyMatColor, 
        ClientBodyMatDuration, CustomGravityScaling, 
        OverlayMaterialInstance, ReplicatedBodyMaterial, 
        WeaponOverlayFlags, bFeigningDeath, 
        bIsTyping;

    // Pos:0x006
    if(bNetDirty && WorldInfo.TimeSeconds < LastTakeHitTimeout
        LastTakeHitInfo;

    // Pos:0x027
    if(!bNetOwner
        DrivenWeaponPawn;
}

// Export USkyPawnBase::execGetBoundingCylinder(FFrame&, void* const)
native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight);

event StoppedFalling()
{
    CustomGravityScaling = 1.0000000;
    bNotifyStopFalling = false;
    //return;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    super(Pawn).FellOutOfWorld(dmgType);
    //return;    
}

// Export USkyPawnBase::execIsInvisible(FFrame&, void* const)
native function bool IsInvisible();

function bool PoweredUp()
{
    return (DamageScaling > float(1)) || bIsInvulnerable;
    //return ReturnValue;    
}

function bool InCombat()
{
    return ((WorldInfo.TimeSeconds - LastPainSound) < float(1)) && !PhysicsVolume.bPainCausing;
    //return ReturnValue;    
}

simulated function SetHUDLocation(Vector NewHUDLocation)
{
    //return;    
}

exec function togglefeet()
{
    bEnableFootPlacement = !bEnableFootPlacement;
    //return;    
}

event SetWalking(bool bNewIsWalking)
{
    //return;    
}

simulated function ClearBodyMatColor()
{
    RemainingBodyMatDuration = 0.0000000;
    ClientBodyMatDuration = 0.0000000;
    BodyMatFadeDuration = 0.0000000;
    //return;    
}

simulated function SetBodyMatColor(LinearColor NewBodyMatColor, float NewOverlayDuration)
{
    RemainingBodyMatDuration = NewOverlayDuration;
    ClientBodyMatDuration = RemainingBodyMatDuration;
    BodyMatFadeDuration = 0.5000000 * RemainingBodyMatDuration;
    BodyMatColor = NewBodyMatColor;
    CurrentBodyMatColor = BodyMatColor;
    CurrentBodyMatColor.R += float(1);
    VerifyBodyMaterialInstance();
    //return;    
}

simulated event SetSkin(Material NewMaterial)
{
    local int I;

    ReplicatedBodyMaterial = NewMaterial;
    // End:0x100
    if(VerifyBodyMaterialInstance())
    {
        // End:0x46
        if(SkyWeapon(Weapon) != none)
        {
            SkyWeapon(Weapon).SetSkin(NewMaterial);
        }
        // End:0xAD
        if(NewMaterial == none)
        {
            I = 0;
            J0x58:

            // End:0xAA [Loop If]
            if(I < Mesh.SkeletalMesh.Materials.Length)
            {
                Mesh.SetMaterial(I, BodyMaterialInstances[I]);
                I++;
                // [Loop Continue]
                goto J0x58;
            }            
        }
        else
        {
            I = 0;
            J0xB4:

            // End:0x100 [Loop If]
            if(I < Mesh.SkeletalMesh.Materials.Length)
            {
                Mesh.SetMaterial(I, NewMaterial);
                I++;
                // [Loop Continue]
                goto J0xB4;
            }
        }
    }
    //return;    
}

simulated function bool VerifyBodyMaterialInstance()
{
    local int I;

    // End:0xBA
    if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh != none) && BodyMaterialInstances.Length < Mesh.GetNumElements())
    {
        BodyMaterialInstances.Length = Mesh.GetNumElements();
        I = 0;
        J0x6A:

        // End:0xBA [Loop If]
        if(I < BodyMaterialInstances.Length)
        {
            // End:0xB0
            if(BodyMaterialInstances[I] == none)
            {
                BodyMaterialInstances[I] = Mesh.CreateAndSetMaterialInstanceConstant(I);
            }
            I++;
            // [Loop Continue]
            goto J0x6A;
        }
    }
    return BodyMaterialInstances.Length > 0;
    //return ReturnValue;    
}

simulated function NotifyTeamChanged()
{
    // End:0x29
    if(!bReceivedValidTeam)
    {
        SetTeamColor();
        bReceivedValidTeam = (GetTeam()) != none;
    }
    //return;    
}

simulated function SetTeamColor()
{
    //return;    
}

simulated function PostBeginPlay()
{
    local int I;

    super(Pawn).PostBeginPlay();
    // End:0xC5
    if(Mesh != none)
    {
        BaseTranslationOffset = Mesh.Translation.Z + ZTranslationFromMesh;
        CrouchTranslationOffset = (Mesh.Translation.Z + CylinderComponent.CollisionHeight) - CrouchHeight;
        OverlayMesh.SetSkeletalMesh(Mesh.SkeletalMesh);
        OverlayMesh.AnimSets = Mesh.AnimSets;
        OverlayMesh.SetParentAnimComponent(Mesh);
    }
    // End:0x128
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x128
        if(int(Class'SkyPlayerControllerBase'.default.PawnShadowMode) == int(0))
        {
            // End:0x128
            if(Mesh != none)
            {
                Mesh.CastShadow = false;
                Mesh.bCastDynamicShadow = false;
            }
        }
    }
    // End:0x148
    if(PossibleSoundGroups.Length > 0)
    {
        SoundGroup = PossibleSoundGroups[Rand(PossibleSoundGroups.Length)];
    }
    I = 0;
    J0x14F:

    // End:0x22C [Loop If]
    if(I < FootIKData.Length)
    {
        FootIKData[I].Control = SkelControlFootPlacement(Mesh.FindSkelControl(FootIKData[I].FootControlName));
        // End:0x200
        if((FootIKData[I].Control == none) || Mesh.MatchRefBone(FootIKData[I].FootBoneName) == -1)
        {
            FootIKData.Remove(I--, 1);
            // [Explicit Continue]
            goto J0x222;
        }
        FootIKData[I].Control.SetSkelControlActive(false);
        J0x222:

        ++I;
        // [Loop Continue]
        goto J0x14F;
    }
    //return;    
}

function SpawnDefaultController()
{
    local SkyGame Game;
    local SkyBotControllerBase Bot;

    super(Pawn).SpawnDefaultController();
    Game = SkyGame(WorldInfo.Game);
    Bot = SkyBotControllerBase(Controller);
    // End:0x77
    if((Game != none) && Bot != none)
    {
        Game.InitializeBot(Bot, Game.GetBotTeam(1), none);
    }
    //return;    
}

simulated function TurnOff()
{
    super(Pawn).TurnOff();
    PawnAmbientSound.Stop();
    //return;    
}

event EncroachedBy(Actor Other)
{
    local SkyPawnBase P;

    P = SkyPawnBase(Other);
    // End:0x60
    if((P == none) || !P.IsInState('FeigningDeath') && int(P.Physics) != int(10))
    {
        super(Pawn).EncroachedBy(Other);
    }
    //return;    
}

function JumpOffPawn()
{
    super(Pawn).JumpOffPawn();
    bNoJumpAdjust = true;
    // End:0x37
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).SetFall();
    }
    //return;    
}

event Falling()
{
    // End:0x29
    if(SkyAIController(Controller) != none)
    {
        SkyAIController(Controller).SetFall();
    }
    //return;    
}

event AddVelocity(Vector NewVelocity, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local bool bRagdoll;

    // End:0xD8
    if(!bIgnoreForces && !IsZero(NewVelocity))
    {
        // End:0xAB
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x92
            if(Vehicle(Base) != none)
            {
                // End:0x8F
                if((((int(Physics) == int(1)) && DrivenVehicle == none) && Vehicle(Base) != none) && VSize(Base.Velocity) > GroundSpeed)
                {
                    bRagdoll = true;
                }                
            }
            else
            {
                // End:0xAB
                if(VSize(NewVelocity) >= RagdollThresholdVelocity)
                {
                    bRagdoll = true;
                }
            }
        }
        super(Pawn).AddVelocity(NewVelocity, HitLocation, DamageType, HitInfo);
        // End:0xD8
        if(bRagdoll)
        {
            ForceRagdoll();
        }
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x25
    if(super(Pawn).Died(Killer, DamageType, HitLocation))
    {
        SetAmbientSound(none);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function StartFire(byte FireModeNum)
{
    // End:0x16
    if(bFeigningDeath)
    {
        FeignDeath();        
    }
    else
    {
        super(Pawn).StartFire(FireModeNum);
    }
    //return;    
}

function bool StopFiring()
{
    // End:0x24
    if(Weapon != none)
    {
        StopFire(Weapon.CurrentFireMode);
    }
    return StopWeaponFiring();
    //return ReturnValue;    
}

function bool StopWeaponFiring()
{
    local int I;
    local bool bResult;
    local SkyWeapon SkyWeap;

    SkyWeap = SkyWeapon(Weapon);
    // End:0xBB
    if(SkyWeap != none)
    {
        // End:0xB3
        if(Weapon.IsFiring())
        {
            SkyWeap.ClientEndFire(0);
            SkyWeap.ClientEndFire(1);
            SkyWeap.ServerStopFire(0);
            SkyWeap.ServerStopFire(1);
            // End:0xB3
            if(SkyPlayerController(Controller) != none)
            {
                SkyPlayerController(Controller).ClientStopZoom();
            }
        }
        bResult = true;
    }
    I = 0;
    J0xC2:

    // End:0x120 [Loop If]
    if(I < InvManager.PendingFire.Length)
    {
        // End:0x116
        if(InvManager.PendingFire[I] > 0)
        {
            bResult = true;
            InvManager.PendingFire[I] = 0;
        }
        I++;
        // [Loop Continue]
        goto J0xC2;
    }
    return bResult;
    //return ReturnValue;    
}

function byte ChooseFireMode()
{
    // End:0x2A
    if(SkyWeapon(Weapon) != none)
    {
        return SkyWeapon(Weapon).BestMode();
    }
    return 0;
    //return ReturnValue;    
}

function bool RecommendLongRangedAttack()
{
    // End:0x2A
    if(SkyWeapon(Weapon) != none)
    {
        return SkyWeapon(Weapon).RecommendLongRangedAttack();
    }
    return false;
    //return ReturnValue;    
}

function float RangedAttackTime()
{
    // End:0x2A
    if(SkyWeapon(Weapon) != none)
    {
        return SkyWeapon(Weapon).RangedAttackTime();
    }
    return 0.0000000;
    //return ReturnValue;    
}

simulated function float GetEyeHeight()
{
    // End:0x14
    if(!IsLocallyControlled())
    {
        return BaseEyeHeight;        
    }
    else
    {
        return EyeHeight;
    }
    //return ReturnValue;    
}

simulated function SetWeaponVisibility(bool bWeaponVisible)
{
    local SkyWeapon Weap;

    Weap = SkyWeapon(Weapon);
    // End:0x35
    if(Weap != none)
    {
        Weap.ChangeVisibility(bWeaponVisible);
    }
    //return;    
}

simulated function SetWeaponAttachmentVisibility(bool bAttachmentVisible)
{
    //return;    
}

simulated event SetMeshVisibility(bool bVisible)
{
    local SkyCarriedObject Flag;

    // End:0x23
    if(Mesh != none)
    {
        Mesh.SetOwnerNoSee(!bVisible);
    }
    SetOverlayVisibility(bVisible);
    SetWeaponVisibility(!bVisible);
    // End:0x65
    foreach BasedActors(Class'SkyCarriedObject', Flag)
    {
        HoldGameObject(Flag);        
    }    
    //return;    
}

event DeactivateSpawnProtection()
{
    //return;    
}

simulated event StartDriving(Vehicle V)
{
    local SkyWeaponPawn WeaponPawn;

    super(Pawn).StartDriving(V);
    DeactivateSpawnProtection();
    SetWeaponVisibility(false);
    SetTeamColor();
    // End:0xE7
    if(int(Role) == int(ROLE_Authority))
    {
        WeaponPawn = SkyWeaponPawn(V);
        // End:0xE7
        if(((WeaponPawn != none) && WeaponPawn.MyVehicle != none) && WeaponPawn.MySeatIndex != -1)
        {
            DrivenWeaponPawn.BaseVehicle = WeaponPawn.MyVehicle;
            DrivenWeaponPawn.SeatIndex = byte(WeaponPawn.MySeatIndex);
            DrivenWeaponPawn.PRI = PlayerReplicationInfo;
            bNetDirty = true;
        }
    }
    //return;    
}

simulated event StopDriving(Vehicle V)
{
    local SkyDrivenWeaponPawnInfo EmptyWeaponPawnInfo;

    // End:0x20
    if(Mesh != none)
    {
        Mesh.SetLightEnvironment(LightEnvironment);
    }
    // End:0x63
    if(((int(Role) < int(ROLE_Authority)) && DrivenWeaponPawn.BaseVehicle != none) && !IsLocallyControlled())
    {
        DrivenVehicle = ClientSideWeaponPawn;        
    }
    else
    {
        // End:0xC1
        if(((int(Role) == int(ROLE_Authority)) && PlayerController(Controller) != none) && SkyVehicle(V) != none)
        {
            SkyVehicle(V).PlayerStartTime = WorldInfo.TimeSeconds + float(12);
        }
        super(Pawn).StopDriving(V);
        SetWeaponVisibility(IsFirstPerson());
        bIgnoreForces = ((SkyGame(WorldInfo.Game) != none) && SkyGame(WorldInfo.Game).bDemoMode) && PlayerController(Controller) != none;
        // End:0x14F
        if(int(Role) == int(ROLE_Authority))
        {
            DrivenWeaponPawn = EmptyWeaponPawnInfo;
        }
    }
    //return;    
}

function SetHand(SkyPawnBase.ESkyWeaponHand NewWeaponHand)
{
    WeaponHand = NewWeaponHand;
    //return;    
}

simulated event HoldGameObject(SkyCarriedObject SkyGameObj)
{
    // End:0x5F
    if(IsFirstPerson())
    {
        SkyGameObj.SetBase(self);
        SkyGameObj.SetRelativeRotation(SkyGameObj.GameObjRot1P);
        SkyGameObj.SetRelativeLocation(SkyGameObj.GameObjOffset1P);        
    }
    else
    {
        // End:0xA2
        if(SkyGameObj.GameObjBone3P != 'None')
        {
            SkyGameObj.SetBase(self,, Mesh, SkyGameObj.GameObjBone3P);            
        }
        else
        {
            SkyGameObj.SetBase(self);
        }
        SkyGameObj.SetRelativeRotation(SkyGameObj.GameObjRot3P);
        SkyGameObj.SetRelativeLocation(SkyGameObj.GameObjOffset3P);
    }
    //return;    
}

function bool GiveHealth(int HealAmount, int HealMax)
{
    // End:0x2A
    if(Health < HealMax)
    {
        Health = Min(HealMax, Health + HealAmount);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function string GetDebugName()
{
    // End:0x0E
    if(PlayerReplicationInfo != none)
    {
        return "";
    }
    return GetItemName(string(self));
    //return ReturnValue;    
}

simulated function name GetMaterialBelowFeet()
{
    local Vector HitLocation, HitNormal, TraceStart;
    local TraceHitInfo HitInfo;
    local SkyPhysicalMaterialProperty PhysicalProperty;

    TraceStart = Location - ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000));
    Trace(HitLocation, HitNormal, TraceStart - vect(0.0000000, 0.0000000, 32.0000000), TraceStart, true,, HitInfo);
    // End:0xB4
    if(HitInfo.PhysMaterial != none)
    {
        PhysicalProperty = SkyPhysicalMaterialProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(Class'SkyPhysicalMaterialProperty'));
        // End:0xB4
        if(PhysicalProperty != none)
        {
            return PhysicalProperty.MaterialType;
        }
    }
    return 'None';
    //return ReturnValue;    
}

event PlayLandingSound()
{
    PlaySound(SoundGroup.GetLandSound(GetMaterialBelowFeet()));
    //return;    
}

simulated event Destroyed()
{
    local int I;

    super(Pawn).Destroyed();
    I = 0;
    J0x0D:

    // End:0x52 [Loop If]
    if(I < Attached.Length)
    {
        // End:0x48
        if(Attached[I] != none)
        {
            Attached[I].PawnBaseDied();
        }
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

function AddDefaultInventory()
{
    //return;    
}

function PlayDyingSound()
{
    SoundGroup.PlayDyingSound(self);
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local int I, J;
    local editinline PrimitiveComponent P;
    local string S;
    local float XL, YL;

    super(Pawn).DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x39
    if(!HUD.ShouldDisplayDebug('Component'))
    {
        return;
    }
    HUD.Canvas.SetDrawColor(255, 255, 128, 255);
    I = 0;
    J0x62:

    // End:0x402 [Loop If]
    if(I < Mesh.Attachments.Length)
    {
        HUD.Canvas.SetPos(4.0000000, out_YPos);
        S = "" $ string(Mesh.Attachments[I].Component);
        HUD.Canvas.StrLen(S, XL, YL);
        J = Len(S);
        J0x102:

        // End:0x17F [Loop If]
        if((XL > (HUD.Canvas.ClipX * 0.5000000)) && J > 10)
        {
            J--;
            S = Right(S, J);
            HUD.Canvas.StrLen(S, XL, YL);
            // [Loop Continue]
            goto J0x102;
        }
        HUD.Canvas.DrawText(((("Attachment" @ string(I)) @ " = ") @ string(Mesh.Attachments[I].BoneName)) @ S);
        out_YPos += out_YL;
        P = PrimitiveComponent(Mesh.Attachments[I].Component);
        // End:0x3F8
        if(P != none)
        {
            HUD.Canvas.SetPos(24.0000000, out_YPos);
            HUD.Canvas.DrawText(((("Component = " @ string(P.Owner)) @ string(P.HiddenGame)) @ string(P.bOnlyOwnerSee)) @ string(P.bOwnerNoSee));
            out_YPos += out_YL;
            S = "" $ string(P);
            HUD.Canvas.StrLen(S, XL, YL);
            J = Len(S);
            J0x318:

            // End:0x395 [Loop If]
            if((XL > (HUD.Canvas.ClipX * 0.5000000)) && J > 10)
            {
                J--;
                S = Right(S, J);
                HUD.Canvas.StrLen(S, XL, YL);
                // [Loop Continue]
                goto J0x318;
            }
            HUD.Canvas.SetPos(24.0000000, out_YPos);
            HUD.Canvas.DrawText("Component = " @ S);
            out_YPos += out_YL;
        }
        I++;
        // [Loop Continue]
        goto J0x62;
    }
    out_YPos += (out_YL * float(2));
    HUD.Canvas.SetPos(24.0000000, out_YPos);
    HUD.Canvas.DrawText("Driven Vehicle = " @ string(DrivenVehicle));
    out_YPos += out_YL;
    //return;    
}

simulated function SetAmbientSound(SoundCue NewAmbientSound)
{
    // End:0x64
    if(NewAmbientSound != PawnAmbientSound.SoundCue)
    {
        AmbientSoundCue = NewAmbientSound;
        PawnAmbientSound.Stop();
        PawnAmbientSound.SoundCue = NewAmbientSound;
        // End:0x64
        if(NewAmbientSound != none)
        {
            PawnAmbientSound.Play();
        }
    }
    //return;    
}

simulated function SoundCue GetAmbientSound()
{
    return AmbientSoundCue;
    //return ReturnValue;    
}

simulated function SetOverlayMaterial(MaterialInterface NewOverlay)
{
    local int I;

    // End:0x1B
    if(int(Role) == int(ROLE_Authority))
    {
        OverlayMaterialInstance = NewOverlay;
    }
    // End:0x9C
    if(NewOverlay != none)
    {
        I = 0;
        J0x2D:

        // End:0x79 [Loop If]
        if(I < OverlayMesh.SkeletalMesh.Materials.Length)
        {
            OverlayMesh.SetMaterial(I, OverlayMaterialInstance);
            I++;
            // [Loop Continue]
            goto J0x2D;
        }
        // End:0x99
        if(!OverlayMesh.bAttached)
        {
            AttachComponent(OverlayMesh);
        }        
    }
    else
    {
        // End:0xAF
        if(OverlayMesh.bAttached)
        {
        }
    }
    //return;    
}

simulated function MaterialInterface GetOverlayMaterial()
{
    return OverlayMaterialInstance;
    //return ReturnValue;    
}

function SetWeaponOverlayFlag(byte FlagToSet)
{
    ApplyWeaponOverlayFlags(byte(int(WeaponOverlayFlags) | (1 << int(FlagToSet))));
    //return;    
}

function ClearWeaponOverlayFlag(byte FlagToClear)
{
    ApplyWeaponOverlayFlags(byte(int(WeaponOverlayFlags) & (255 ^ (1 << int(FlagToClear)))));
    //return;    
}

simulated function ApplyWeaponOverlayFlags(byte NewFlags)
{
    // End:0x1B
    if(int(Role) == int(ROLE_Authority))
    {
        WeaponOverlayFlags = NewFlags;
    }
    //return;    
}

simulated event StartFeignDeathRecoveryAnim()
{
    local SkyWeapon SkyWeap;

    TermRagdoll();
    SkyWeap = SkyWeapon(Weapon);
    // End:0x39
    if(SkyWeap != none)
    {
        SkyWeap.PlayWeaponEquip();
    }
    Mesh.EnablePhysics(SkyPawnBase(ObjectArchetype).Mesh.PhysicsAsset, 0.0000000);
    Mesh.SetComponentRBFixed(true);
    Mesh.bUpdateKinematicBonesFromAnimation = true;
    Mesh.bUpdateJointsFromAnimation = false;
    //return;    
}

function FeignDeathTimeoutTimer()
{
    Health = 0;
    Died(LastHitBy, Class'Engine.DmgType_Suicided', Owner.Location);
    //return;    
}

function FeignDeathDelayTimer()
{
    local float Dist;
    local NavigationPoint BestAnchor;
    local Actor.EPhysics myPrevPhysics;

    // End:0x109
    if(VSize(Velocity) < FeignDeathBodyAtRestSpeed)
    {
        // End:0x106
        if((WorldInfo.TimeSeconds - FeignDeathStartTime) > RagdollRecoveryTime)
        {
            ClearTimer('FeignDeathDelayTimer');
            ClearTimer('FeignDeathTimeoutTimer');
            // End:0xD7
            if(bWasInAntiGrav)
            {
                ResetReachCache();
                myPrevPhysics = Physics;
                SetPhysics(1);
                BestAnchor = GetBestAnchor(self, Location, true, false, Dist);
                SetPhysics(myPrevPhysics);
                // End:0xAC
                if(BestAnchor == none)
                {
                    FeignDeathTimeoutTimer();
                    return;
                }
                // End:0xD7
                if(SkyBot(Controller) != none)
                {
                    SkyBot(Controller).Freeze(false);
                }
            }
            bWasInAntiGrav = false;
            // End:0x106
            if(bFeigningDeath && bForcedFeignDeath)
            {
                bFeigningDeath = false;
                PlayFeignDeath();
            }
        }        
    }
    else
    {
        FeignDeathStartTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

simulated event PlayFeignDeath(optional bool bDontResetPhysicsOnGetup)
{
    //return;    
}

reliable server function ServerFeignDeath()
{
    // End:0x6F
    if((((int(Role) == int(ROLE_Authority)) && !WorldInfo.GRI.bMatchIsOver) && !IsTimerActive('FeignDeathDelayTimer')) && !bPlayingFeignDeathRecovery)
    {
        bFeigningDeath = !bFeigningDeath;
        PlayFeignDeath();
    }
    //return;    
}

simulated exec function FeignDeath()
{
    ServerFeignDeath();
    //return;    
}

function ForceRagdoll()
{
    bFeigningDeath = true;
    bForcedFeignDeath = true;
    PlayFeignDeath();
    // End:0x46
    if(SkyBot(Controller) != none)
    {
        SkyBot(Controller).Freeze(true);
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x96
    if((VarName == 'Controller') && Controller != none)
    {
        // End:0x93
        if(SkyWeapon(Weapon) != none)
        {
            SkyWeapon(Weapon).ClientEndFire(0);
            SkyWeapon(Weapon).ClientEndFire(1);
            // End:0x93
            if(!Weapon.HasAnyAmmo())
            {
                Weapon.WeaponEmpty();
            }
        }        
    }
    else
    {
        // End:0xC0
        if(VarName == 'ClientBodyMatDuration')
        {
            SetBodyMatColor(BodyMatColor, ClientBodyMatDuration);            
        }
        else
        {
            // End:0xE5
            if(VarName == 'AmbientSoundCue')
            {
                SetAmbientSound(AmbientSoundCue);                
            }
            else
            {
                // End:0x10A
                if(VarName == 'ReplicatedBodyMaterial')
                {
                    SetSkin(ReplicatedBodyMaterial);                    
                }
                else
                {
                    // End:0x12F
                    if(VarName == 'OverlayMaterialInstance')
                    {
                        SetOverlayMaterial(OverlayMaterialInstance);                        
                    }
                    else
                    {
                        // End:0x150
                        if(VarName == 'bFeigningDeath')
                        {
                            PlayFeignDeath();                            
                        }
                        else
                        {
                            // End:0x175
                            if(VarName == 'WeaponOverlayFlags')
                            {
                                ApplyWeaponOverlayFlags(WeaponOverlayFlags);                                
                            }
                            else
                            {
                                // End:0x195
                                if(VarName == 'LastTakeHitInfo')
                                {
                                    PlayTakeHitEffects();                                    
                                }
                                else
                                {
                                    // End:0x357
                                    if(VarName == 'DrivenWeaponPawn')
                                    {
                                        // End:0x2D3
                                        if((DrivenWeaponPawn.BaseVehicle != LastDrivenWeaponPawn.BaseVehicle) || int(DrivenWeaponPawn.SeatIndex) != int(LastDrivenWeaponPawn.SeatIndex))
                                        {
                                            // End:0x2A8
                                            if(DrivenWeaponPawn.BaseVehicle != none)
                                            {
                                                // End:0x254
                                                if((ClientSideWeaponPawn == none) || ClientSideWeaponPawn.bDeleteMe)
                                                {
                                                    ClientSideWeaponPawn = Spawn(Class'SkyClientSideWeaponPawn', DrivenWeaponPawn.BaseVehicle);
                                                }
                                                ClientSideWeaponPawn.MyVehicle = DrivenWeaponPawn.BaseVehicle;
                                                ClientSideWeaponPawn.MySeatIndex = int(DrivenWeaponPawn.SeatIndex);
                                                StartDriving(ClientSideWeaponPawn);                                                
                                            }
                                            else
                                            {
                                                // End:0x2D3
                                                if((ClientSideWeaponPawn != none) && ClientSideWeaponPawn == DrivenVehicle)
                                                {
                                                    StopDriving(ClientSideWeaponPawn);
                                                }
                                            }
                                        }
                                        // End:0x349
                                        if(((ClientSideWeaponPawn != none) && ClientSideWeaponPawn == DrivenVehicle) && ClientSideWeaponPawn.PlayerReplicationInfo != DrivenWeaponPawn.PRI)
                                        {
                                            ClientSideWeaponPawn.PlayerReplicationInfo = DrivenWeaponPawn.PRI;
                                            ClientSideWeaponPawn.NotifyTeamChanged();
                                        }
                                        LastDrivenWeaponPawn = DrivenWeaponPawn;                                        
                                    }
                                    else
                                    {
                                        super(Pawn).ReplicatedEvent(VarName);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

// Export USkyPawnBase::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

simulated function WeaponChanged(SkyWeaponBase NewWeapon)
{
    //return;    
}

simulated event WeaponAttachmentChanged()
{
    //return;    
}

// Export USkyPawnBase::execPlayHit(FFrame&, void* const)
native function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyPawnBase::execPlayTakeHitEffects(FFrame&, void* const)
native simulated function PlayTakeHitEffects();

simulated event TakeHitBlendedOut()
{
    Mesh.EnablePhysics(SkyPawnBase(ObjectArchetype).Mesh.PhysicsAsset, 0.0000000);
    Mesh.SetComponentRBFixed(true);
    Mesh.bUpdateKinematicBonesFromAnimation = true;
    Mesh.bUpdateJointsFromAnimation = false;
    //return;    
}

simulated function SwitchWeapon(byte NewGroup)
{
    // End:0x2E
    if(SkyInventoryManager(InvManager) != none)
    {
        SkyInventoryManager(InvManager).SwitchWeapon(NewGroup);
    }
    //return;    
}

function TakeDrowningDamage()
{
    //return;    
}

simulated function SetOverlayVisibility(bool bVisible)
{
    OverlayMesh.SetOwnerNoSee(!bVisible);
    //return;    
}

simulated function SetOverlayHidden(bool bIsHidden)
{
    OverlayMesh.SetHidden(bIsHidden);
    //return;    
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    // End:0xE7
    if(Abs(RigidCollisionData.ContactInfos[0].ContactNormal.Z) > 0.5000000)
    {
        Velocity = Mesh.GetRootBodyInstance().PreviousVelocity;
        TakeFallingDamage(RigidCollisionData.ContactInfos[0].ContactNormal);
        Velocity.Z = 0.0000000;
        Mesh.SetRBLinearVelocity(Velocity, false);
        Mesh.GetRootBodyInstance().PreviousVelocity = Velocity;
        Mesh.GetRootBodyInstance().Velocity = Velocity;
    }
    //return;    
}

function OnExitVehicle(SkySeqAct_ExitVehicle Action)
{
    // End:0x20
    if(DrivenVehicle != none)
    {
        DrivenVehicle.DriverLeave(true);
    }
    //return;    
}

function OnInfiniteAmmo(SkySeqAct_InfiniteAmmo Action)
{
    local SkyInventoryManager SkyInvManager;

    SkyInvManager = SkyInventoryManager(InvManager);
    // End:0x3C
    if(SkyInvManager != none)
    {
        SkyInvManager.bInfiniteAmmo = Action.bInfiniteAmmo;
    }
    //return;    
}

state FeigningDeath
{
    event bool EncroachingOn(Actor Other)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool CanThrowWeapon()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event BeginState(name PreviousStateName)
    {
        local SkyWeapon SkyWeap;

        bCanPickupInventory = false;
        StopFiring();
        bNoWeaponFiring = true;
        SkyWeap = SkyWeapon(Weapon);
        // End:0x49
        if(SkyWeap != none)
        {
            SkyWeap.PlayWeaponPutDown();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x72
        if(NextStateName != 'Dying')
        {
            bNoWeaponFiring = default.bNoWeaponFiring;
            bCanPickupInventory = default.bCanPickupInventory;
            global.SetMovementPhysics();
            bForcedFeignDeath = false;
            bPlayingFeignDeathRecovery = false;
            // End:0x72
            if(SkyBot(Controller) != none)
            {
                SkyBot(Controller).Freeze(false);
            }
        }
        //return;        
    }
    stop;    
}

simulated state Dying
{
    ignores OnAnimEnd, BreathTimer, StartFeignDeathRecoveryAnim, ForceRagdoll, FellOutOfWorld, FeignDeath, 
	    ServerFeignDeath;
    stop;    
}
