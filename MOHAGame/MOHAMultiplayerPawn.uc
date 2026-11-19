class MOHAMultiplayerPawn extends MOHAPlayerPawn
    native
    nativereplication
    config(Game)
    hidecategories(Navigation);

const SIMULATED_VELOCITY_BUFFER_MAX = 8;
const iMaxRecentPos = 50;
const iHitVerificationForgiveness = 500;
const fMaxPropTime = 0.05f;
const fPropScalar = 8.f;

enum EDamageType
{
    DAMAGETYPE_BULLET,              // 0
    DAMAGETYPE_EXPLOSION,           // 1
    DAMAGETYPE_MELEE,               // 2
    DAMAGETYPE_MAX                  // 3
};

enum ELeanState
{
    LEANSTATE_NONE,                 // 0
    LEANSTATE_LEFT,                 // 1
    LEANSTATE_RIGHT,                // 2
    LEANSTATE_PEEK,                 // 3
    LEANSTATE_MAX                   // 4
};

enum ELadderState
{
    LADDERSTATE_LERP,               // 0
    LADDERSTATE_ENTER_LOWER,        // 1
    LADDERSTATE_ENTER_UPPER,        // 2
    LADDERSTATE_ONLADDER,           // 3
    LADDERSTATE_EXIT_LOWER,         // 4
    LADDERSTATE_EXIT_UPPER,         // 5
    LADDERSTATE_NONE,               // 6
    LADDERSTATE_MAX                 // 7
};

enum EFakeJumpState
{
    FAKEJUMPSTATE_NONE,             // 0
    FAKEJUMPSTATE_START,            // 1
    FAKEJUMPSTATE_IDLE,             // 2
    FAKEJUMPSTATE_END,              // 3
    FAKEJUMPSTATE_MAX               // 4
};

struct native PawnFiringInfo
{
    var bool bFiring;
    var bool bAltFireMode;
    var bool bInGrenadeMode;
    var bool bForceMelee;

    structdefaultproperties
    {
        bFiring=false
        bAltFireMode=false
        bInGrenadeMode=false
        bForceMelee=false
    }
};

struct native PawnHealthInfo
{
    var int Health;
    var int LastHitBoneID;
    var Vector LastHitFromLocation;
    var MOHAPawn.EHitLocation LastHitLocation;
    var MOHAMultiplayerPawn.EDamageType LastDamageType;

    structdefaultproperties
    {
        Health=0
        LastHitBoneID=0
        LastHitFromLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LastHitLocation=0
        LastDamageType=0
    }
};

struct native PawnMPObjectiveInfo
{
    var int m_iMPObjectiveType;

    structdefaultproperties
    {
        m_iMPObjectiveType=0
    }
};

struct native RecentLocation
{
    var float m_fTimestamp;
    var Vector m_vLocation;

    structdefaultproperties
    {
        m_fTimestamp=0.0000000
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native GearMeshInfoMP
{
    var SkeletalMesh Mesh;

    structdefaultproperties
    {
        Mesh=none
    }
};

struct native HeadMeshInfoMP
{
    var float Freq;
    var SkeletalMesh Mesh;

    structdefaultproperties
    {
        Freq=0.0000000
        Mesh=none
    }
};

var PawnFiringInfo m_oFiringInfo;
var PawnHealthInfo m_oHealthInfo;
var PawnMPObjectiveInfo m_oMPObjective;
var bool bNoRagdoll;
var bool bLocalPawnDying;
var bool CachedExplosiveFullDamage;
var bool bForceReplicateWeaponFire;
var bool bForceMeleeReplication;
var SkelControlSingleBone ThirdPersonHipControl;
var(Game) config float ConsoleParachuteDamageReductionScale;
var(Game) config float PCParachuteDamageReductionScale;
var(Game) config float NonReducedParachuteDamageDistance;
var(Game) config float FullyReducedParachuteDamageDistance;
var(Game) config float FallingDamageScalar;
var(Game) config float MPMaxFallSpeed;
var(Game) config int GrenadeReserveCount;
var repnotify MOHAIncludeClass.EWeaponType CurrentWeapon;
var repnotify byte LeanState;
var repnotify MOHAMultiplayerPawn.EFakeJumpState FakeJumpState;
var byte m_iVelocitySimulationDataIndex;
var repnotify MOHAPlayerPawn.EPlayerActivity eCurrentUpperBodyActivity;
var repnotify MOHAPlayerPawn.EPlayerActivity eCurrentLowerBodyActivity;
var repnotify MOHAMultiplayerPawn.ELadderState LadderState;
var int PlayerID;
var Rotator RemoteRotation;
var int RemoteBlendedViewPitch;
var Vector m_vVelocitySimulationData[8];
var Vector m_vLocationSimulationError;
var Vector LastHitByLocation;
var int numParachutes;
var const array<Texture2D> AlliesIcon;
var const array<Texture2D> AxisIcon;
var const array<SoundCue> AlliedDamageSounds;
var const array<SoundCue> AxisDamageSounds;
var const SoundCue DefaultTakeDamageSound;
var array<SoundCue> StanceChangeSounds3rdPerson;
var Weapon WeaponSimulation;
var SoundCue ParachuteLandingSound;
var SoundCue ParachuteLandingSoundNPC;
var(Game) config float PawnLifeTimeAfterDeath;
var(Game) config float RespawnWaitTimeNotAirborne;
var(Game) config float RespawnWaitTimeAxis;
var(Game) config float RespawnWaitTimeAllied;
var(Game) config float LookAtKillerTime;
var AnimTree DeathAnimTree;
var array<RecentLocation> m_aRecentLocations;
var int m_iRecentLocationPos;
var float fIdleTurnRate;
var float CachedExplosiveMomentum;
var Vector CachedExplosiveOrigin;
var float CachedExplosiveRadius;
var MOHAMPLadder OnLadderMP;
var float fLadderViewYawRange;
var float fLadderViewPitchRange;
var float LadderBasePosition;
var int LastLadderAnimRung;
var float LastLadderAnimOffset;
var Vector LadderLerpToPosition;
var Rotator LadderLerpToRotation;
var Vector LadderBottom;
var Vector LadderTop;
var float LadderCurrentRung;
var float LadderRungDistance;
var Vector LadderTopExitOffset;
var config float LadderLerpMoveSpeed;
var config float LadderLerpTurnSpeed;
var config float LadderJumpVelocity;
var float StanceChangeTime;
var float StanceChangePeekTime;
var(Wearables) config array<config HeadMeshInfoMP> RandomHeadMeshes;
var(Wearables) config GearMeshInfo GearInfo;

replication
{
    // Pos:0x000
    if(!bNetOwner
        RemoteRotation, m_oFiringInfo;

    // Pos:0x008
    if(bNetDirty
        CurrentWeapon, m_oHealthInfo;

    // Pos:0x00E
    if(bNetDirty && !bNetOwner
        LeanState, eCurrentLowerBodyActivity, 
        eCurrentUpperBodyActivity;

    // Pos:0x021
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        FakeJumpState, LadderBasePosition, 
        LadderState;

    // Pos:0x039
    if(bNetInitial
        PlayerID;

    // Pos:0x03F
    if(bNetDirty && !bNetOwner
        m_oMPObjective;
}

// Export UMOHAMultiplayerPawn::execGetTeamIndex(FFrame&, void* const)
native simulated function int GetTeamIndex();

// Export UMOHAMultiplayerPawn::execGetWeaponUpgradeLevel(FFrame&, void* const)
native simulated function int GetWeaponUpgradeLevel();

// Export UMOHAMultiplayerPawn::execNativeTick(FFrame&, void* const)
native simulated function NativeTick(float DeltaTime);

// Export UMOHAMultiplayerPawn::execUpdateIronsightsLean(FFrame&, void* const)
native simulated function UpdateIronsightsLean(float fDeltaTime);

// Export UMOHAMultiplayerPawn::execUpdateIronsightsPeek(FFrame&, void* const)
native simulated function UpdateIronsightsPeek(float fDeltaTime);

// Export UMOHAMultiplayerPawn::execUpdateLeanState(FFrame&, void* const)
native simulated function UpdateLeanState(MOHAMultiplayerPawn.ELeanState newLean, bool On);

// Export UMOHAMultiplayerPawn::execCheckLeanState(FFrame&, void* const)
native simulated function bool CheckLeanState(MOHAMultiplayerPawn.ELeanState lstate);

// Export UMOHAMultiplayerPawn::execNativeDrawHUD(FFrame&, void* const)
native simulated function NativeDrawHUD(HUD H);

// Export UMOHAMultiplayerPawn::execIronsightsControlEnabled(FFrame&, void* const)
native simulated function bool IronsightsControlEnabled();

// Export UMOHAMultiplayerPawn::execGetIronsightsPeekHeight(FFrame&, void* const)
native simulated function float GetIronsightsPeekHeight();

// Export UMOHAMultiplayerPawn::execChangeStance(FFrame&, void* const)
native simulated function ChangeStance();

simulated function ClientSetCurrentWeapon()
{
    //return;    
}

simulated function AddSelfToBeadList()
{
    local PlayerController PlayerController;

    // End:0x56
    foreach LocalPlayerControllers(PlayerController)
    {
        // End:0x55
        if((PlayerController != none) && MOHAHUD_MP(PlayerController.myHUD) != none)
        {
            MOHAHUD_MP(PlayerController.myHUD).UpdateCompassTeam();
        }        
    }    
    //return;    
}

simulated function AssignHeadMesh()
{
    local int I;
    local float rand_num;

    rand_num = FRand();
    I = 0;
    J0x0F:

    // End:0x87 [Loop If]
    if(I < RandomHeadMeshes.Length)
    {
        rand_num -= RandomHeadMeshes[I].Freq;
        // End:0x7D
        if((rand_num <= 0.0000000) || (I + 1) == RandomHeadMeshes.Length)
        {
            HeadSkeletalMesh = RandomHeadMeshes[I].Mesh;
            // [Explicit Break]
            goto J0x87;
        }
        I++;
        // [Loop Continue]
        goto J0x0F;
    }
    J0x87:

    //return;    
}

simulated function AssignGearMesh()
{
    GearSkeletalMesh = GearInfo.Mesh;
    //return;    
}

simulated function PreBeginPlay()
{
    super(MOHAPawn).PreBeginPlay();
    BodySkeletalMesh = default.Mesh.SkeletalMesh;
    AssignHeadMesh();
    AssignGearMesh();
    SetCompositeMesh();
    AttachComponent(Mesh);
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    bLocalPawnDying = false;
    SetTimer(0.2500000, false, 'AddSelfToBeadList');
    InitFeetData();
    //return;    
}

simulated event SimulateInventoryManager()
{
    // End:0x58
    if((InvManager == none) && InventoryManagerClass != none)
    {
        InvManager = __NFUN_278__(InventoryManagerClass, self);
        // End:0x3A
        if(InvManager == none)
        {            
        }
        else
        {
            InvManager.SetupFor(self);
            AddDefaultInventory();
        }
    }
    //return;    
}

simulated event TornOff()
{
    super(Pawn).TornOff();
    CurrentWeaponAttachmentClass = none;
    WeaponAttachmentChanged();
    OwnerChangeVisibleMesh(false);
    //return;    
}

simulated exec function RenderBody(bool bShow)
{
    // End:0x1C
    if((GetTeamIndex()) == 0)
    {
        super.RenderBody(bShow);
    }
    //return;    
}

simulated event int GetWeaponType()
{
    // End:0x25
    if(CurrentWeaponAttachmentClass != none)
    {
        return int(CurrentWeaponAttachmentClass.default.WeaponClass.default.WeaponType);
    }
    return 0;
    //return ReturnValue;    
}

simulated event int GetWeaponClass()
{
    // End:0x25
    if(CurrentWeaponAttachmentClass != none)
    {
        return int(CurrentWeaponAttachmentClass.default.WeaponClass.default.WeaponClass);
    }
    return 0;
    //return ReturnValue;    
}

// Export UMOHAMultiplayerPawn::execGetWeaponMode(FFrame&, void* const)
native simulated function int GetWeaponMode();

simulated event SimulateFlashLocation()
{
    local Vector HitNormal, StartTrace, EndTrace;
    local Actor HitActor;
    local TraceHitInfo HitInfo;

    // End:0x9B
    if((CurrentWeaponAttachmentClass != none) && (WeaponSimulation == none) || WeaponSimulation.Class != CurrentWeaponAttachmentClass.default.WeaponClass)
    {
        // End:0x52
        if(WeaponSimulation != none)
        {
            WeaponSimulation.Destroy();
        }
        WeaponSimulation = __NFUN_278__(CurrentWeaponAttachmentClass.default.WeaponClass, self);
        WeaponSimulation.GivenTo(self, true);
        WeaponSimulation.GotoState('WeaponSimulation');
    }
    // End:0x10F
    if(bIronsightsActive)
    {
        // End:0xCD
        if(int(CurrentActivity) == int(21))
        {
            EALASmallArms(WeaponSimulation).IronsightsState = 1;            
        }
        else
        {
            // End:0xF6
            if(int(CurrentActivity) == int(22))
            {
                EALASmallArms(WeaponSimulation).IronsightsState = 2;                
            }
            else
            {
                EALASmallArms(WeaponSimulation).IronsightsState = 3;
            }
        }        
    }
    else
    {
        EALASmallArms(WeaponSimulation).IronsightsState = 0;
    }
    StartTrace = GetWeaponStartTraceLocation(WeaponSimulation);
    EndTrace = StartTrace + (Vector(WeaponSimulation.GetAdjustedAim(StartTrace)) * WeaponSimulation.GetTraceRange());
    HitActor = Trace(FlashLocation, HitNormal, EndTrace, StartTrace, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 1);
    // End:0x1BD
    if(HitActor == none)
    {
        FlashLocation = EndTrace;
    }
    //return;    
}

function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local float DamagerDistance, ParachuteDamageReductionScale, PlatformSpecificDamageReductionScale, LerpValue;

    // End:0x10A
    if(int(Physics) == int(11))
    {
        // End:0x31
        if(WorldInfo.IsConsoleBuild())
        {
            PlatformSpecificDamageReductionScale = ConsoleParachuteDamageReductionScale;            
        }
        else
        {
            PlatformSpecificDamageReductionScale = PCParachuteDamageReductionScale;
        }
        // End:0x5E
        if(InstigatedBy.Pawn == none)
        {
            DamagerDistance = 0.0000000;            
        }
        else
        {
            DamagerDistance = VSize(InstigatedBy.Pawn.Location - Location);
        }
        // End:0xA1
        if(DamagerDistance <= NonReducedParachuteDamageDistance)
        {
            ParachuteDamageReductionScale = 1.0000000;            
        }
        else
        {
            // End:0xBE
            if(DamagerDistance >= FullyReducedParachuteDamageDistance)
            {
                ParachuteDamageReductionScale = PlatformSpecificDamageReductionScale;                
            }
            else
            {
                LerpValue = (DamagerDistance - NonReducedParachuteDamageDistance) / (FullyReducedParachuteDamageDistance - NonReducedParachuteDamageDistance);
                ParachuteDamageReductionScale = 1.0000000 - (LerpValue * (1.0000000 - PlatformSpecificDamageReductionScale));
            }
        }
        inDamage *= ParachuteDamageReductionScale;
    }
    // End:0x12C
    if(MOHAMultiplayerGameInfo(WorldInfo.Game).bFriendlyFireEnabled)
    {
        return;
    }
    // End:0x13D
    if(InstigatedBy == Controller)
    {
        return;
    }
    // End:0x178
    if(MOHAPlayerReplicationInfo(InstigatedBy.PlayerReplicationInfo).Team.TeamIndex == (GetTeamIndex()))
    {
        inDamage = 0;
    }
    //return;    
}

simulated event Texture2D GetRankIcon(MOHAIncludeClass.MilitaryRank Rank, int TeamIndex)
{
    local Texture2D RankIcon;

    // End:0x0F
    if(int(Rank) < 0)
    {
        return none;
    }
    // End:0x21
    if(int(Rank) > int(19))
    {
        return none;
    }
    // End:0x42
    if(TeamIndex == 0)
    {
        RankIcon = AlliesIcon[int(Rank)];        
    }
    else
    {
        RankIcon = AxisIcon[int(Rank)];
    }
    return RankIcon;
    //return ReturnValue;    
}

simulated event string GetDebugInfo()
{
    local string Text;

    Text $= ("Current Activity: " $ string(CurrentActivity));    
    Text $= ("\nCurrent Upper Body Activity: " $ string(eCurrentUpperBodyActivity));    
    Text $= ("\nCurrent Lower Body Activity: " $ string(eCurrentLowerBodyActivity));    
    Text $= ("\nMesh Adjust : " $ string(bMeshAdj_DynamicDisable));
    return Text;
    //return ReturnValue;    
}

simulated function DrawHUD(HUD H)
{
    NativeDrawHUD(H);
    // End:0x32
    if(InvManager != none)
    {
        InvManager.DrawHUD(H);
    }
    //return;    
}

simulated event IndicateDamage()
{
    local PlayerController PC;
    local MOHAHUD HUD;

    PC = PlayerController(Controller);
    // End:0x77
    if(PC != none)
    {
        HUD = MOHAHUD(PC.myHUD);
        // End:0x77
        if(HUD != none)
        {
            // End:0x77
            if(LastHitByLocation != vect(0.0000000, 0.0000000, 0.0000000))
            {
                HUD.NotifyHitIndicator(Rotator(LastHitByLocation - Location));
            }
        }
    }
    //return;    
}

simulated function Rotator GetViewRotation()
{
    // End:0x13
    if(IsLocallyControlled())
    {
        return super.GetViewRotation();        
    }
    else
    {
        // End:0x30
        if(Controller != none)
        {
            return Controller.Rotation;            
        }
        else
        {
            return Rotation;
        }
    }
    //return ReturnValue;    
}

simulated function AttachNewWeaponMesh(Weapon NewWeapon)
{
    // End:0x14
    if(IsLocallyControlled())
    {
        super.AttachNewWeaponMesh(NewWeapon);
    }
    //return;    
}

simulated function WeaponAttachmentChanged()
{
    // End:0x09
    if(bVerboseLogging)
    {
    }
    // End:0x10C
    if((CurrentWeaponAttachment == none) || CurrentWeaponAttachment.Class != CurrentWeaponAttachmentClass)
    {
        // End:0x73
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.DetachFrom(Mesh);
            // End:0x73
            if(CurrentWeaponAttachment.DestroyWhenDetatched())
            {
                CurrentWeaponAttachment.Destroy();
            }
        }
        // End:0xA5
        if(CurrentWeaponAttachmentClass != none)
        {
            CurrentWeaponAttachment = __NFUN_278__(CurrentWeaponAttachmentClass, self);
            CurrentWeaponAttachment.Instigator = self;            
        }
        else
        {
            CurrentWeaponAttachment = none;
        }
        // End:0x10C
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.AttachTo(self);
            // End:0x10C
            if((IsAirdropActivity(CurrentActivity)) && CurrentWeaponAttachment.ThirdPersonMesh != none)
            {
                CurrentWeaponAttachment.ThirdPersonMesh.SetOnlyOwnerSee(true);
            }
        }
    }
    // End:0x164
    if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.IsA('SmallArmsAttachment'))
    {
        SmallArmsAttachment(CurrentWeaponAttachment).bUseShellProjectiles = SmallArmsAttachment(CurrentWeaponAttachment).bUseShellProjectiles && IsHumanControlled();
    }
    // End:0x1B1
    if(IsLocallyControlled())
    {
        // End:0x1B1
        if((none != Weapon) && CurrentWeaponAttachment != none)
        {
            EALAWeapon(Weapon).AttachmentChanged(CurrentWeaponAttachment);
            AttachNewWeaponMesh(Weapon);
        }
    }
    //return;    
}

function SetCurrentWeaponEnum()
{
    CurrentWeapon = ((CurrentWeaponAttachmentClass != none) ? CurrentWeaponAttachmentClass.default.WeaponClass.default.WeaponType : 0);
    //return;    
}

function SetCurrentStance(MOHAPlayerPawn.EPlayerStance eNextStance)
{
    super.SetCurrentStance(eNextStance);
    // End:0x41
    if((int(eNextStance) == int(0)) || int(eNextStance) == int(1))
    {
        StanceChangeTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

simulated function SetWeaponClass(class<WeaponAttachment> AttachmentClass)
{
    super(MOHAPawn).SetWeaponClass(AttachmentClass);
    SetCurrentWeaponEnum();
    //return;    
}

simulated function bool IsAirdropActivity(MOHAPlayerPawn.EPlayerActivity activity)
{
    switch(activity)
    {
        // End:0x0C
        case 35:
        // End:0x11
        case 36:
        // End:0x16
        case 37:
        // End:0x1B
        case 38:
        // End:0x20
        case 39:
        // End:0x25
        case 40:
        // End:0x2A
        case 41:
        // End:0x31
        case 43:
            return true;
        // End:0x36
        case 42:
        // End:0xFFFF
        default:
            return false;
            break;
    }
    //return ReturnValue;    
}

simulated event bool ShouldForceRelevant()
{
    // End:0x28
    if((IsAirdropActivity(CurrentActivity)) || IsAirdropActivity(LastActivity))
    {
        return true;
    }
    // End:0x37
    if(int(LeanState) != 0)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event ReplicatedEvent(name VarName)
{
    local MOHAPlayerPawn.EPlayerActivity tempActivity;

    // End:0x45
    if(((int(WorldInfo.NetMode) == int(NM_Client)) && FPArms != none) && !IsLocallyControlled())
    {
        DetachComponent(FPArms);
        FPArms = none;
    }
    // End:0x65
    if(VarName == 'CurrentWeapon')
    {
        ClientSetCurrentWeapon();        
    }
    else
    {
        // End:0x137
        if(((VarName == 'FakeJumpState') && int(WorldInfo.NetMode) == int(NM_Client)) && !IsLocallyControlled())
        {
            switch(FakeJumpState)
            {
                // End:0xD0
                case 1:
                    SetActivity(26);
                    PlayFootstep(6);
                    bMeshAdj_DynamicDisable = true;
                    // End:0x134
                    break;
                // End:0xEC
                case 2:
                    SetActivity(27);
                    bMeshAdj_DynamicDisable = true;
                    // End:0x134
                    break;
                // End:0x115
                case 3:
                    SetActivity(28);
                    PlayFootstep(7);
                    bMeshAdj_DynamicDisable = false;
                    // End:0x134
                    break;
                // End:0x131
                case 0:
                    SetActivity(1);
                    bMeshAdj_DynamicDisable = false;
                    // End:0x134
                    break;
                // End:0xFFFF
                default:
                    break;
            }            
        }
        else
        {
            // End:0x24F
            if((VarName == 'LadderState') && int(WorldInfo.NetMode) == int(NM_Client))
            {
                // End:0x17B
                if(IsLocallyControlled())
                {
                    LadderStateChange();                    
                }
                else
                {
                    // End:0x1DB
                    if(CurrentWeaponAttachment != none)
                    {
                        // End:0x1C7
                        if((int(LadderState) == int(6)) || int(LadderState) == int(0))
                        {
                            bMeshAdj_DynamicDisable = false;
                            CurrentWeaponAttachment.Hide(false);                            
                        }
                        else
                        {
                            CurrentWeaponAttachment.Hide(true);
                        }
                    }
                    // End:0x1F8
                    if(int(LadderState) == int(1))
                    {
                        EnterClosestLadderBottom();                        
                    }
                    else
                    {
                        // End:0x215
                        if(int(LadderState) == int(2))
                        {
                            EnterClosestLadderTop();                            
                        }
                        else
                        {
                            // End:0x232
                            if(int(LadderState) == int(4))
                            {
                                ExitClosestLadderBottom();                                
                            }
                            else
                            {
                                // End:0x24C
                                if(int(LadderState) == int(5))
                                {
                                    ExitClosestLadderTop();
                                }
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0x427
                if((VarName == 'CurrentActivity') && !IsLocallyControlled())
                {
                    // End:0x289
                    if(int(LastActivity) == int(42))
                    {
                        killParachute();
                    }
                    // End:0x329
                    if((AirdropParachuteMesh != none) && !IsAirdropActivity(CurrentActivity))
                    {
                        // End:0x2E4
                        if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.ThirdPersonMesh != none)
                        {
                            CurrentWeaponAttachment.ThirdPersonMesh.SetOnlyOwnerSee(false);
                        }
                        // End:0x326
                        if(AirdropParachuteMesh != none)
                        {
                            PlayLandingSound();
                            AirdropParachuteMesh.PlayChuteLandingAnimation();
                            AirdropParachuteMesh.HitGround();
                            AirdropParachuteMesh = none;
                        }                        
                    }
                    else
                    {
                        // End:0x368
                        if(((IsAirdropActivity(CurrentActivity)) && !IsAirdropActivity(LastActivity)) && AirdropParachuteMesh == none)
                        {
                            InitializeAirdropState();
                        }
                    }
                    // End:0x3B3
                    if((int(WorldInfo.NetMode) == int(NM_Client)) && !IsLocallyControlled())
                    {
                        tempActivity = CurrentActivity;
                        CurrentActivity = LastActivity;
                        SetActivity(tempActivity);
                    }
                    // End:0x3D7
                    if(int(CurrentActivity) == int(25))
                    {
                        StanceChangeTime = WorldInfo.TimeSeconds;
                    }
                    // End:0x419
                    if(((int(CurrentActivity) == int(12)) && int(LastActivity) != int(12)) && CurrentWeaponAttachment != none)
                    {
                        CurrentWeaponAttachment.Rechamber();
                    }
                    PlaybackLength = 0.0000000;                    
                }
                else
                {
                    super(Pawn).ReplicatedEvent(VarName);
                }
            }
        }
    }
    //return;    
}

function SetFlashLocation(Weapon Who, byte FireModeNum, Vector NewLoc)
{
    bForceReplicateWeaponFire = true;
    super(Pawn).SetFlashLocation(Who, FireModeNum, NewLoc);
    //return;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int LastHealth;

    LastHealth = Health;
    LastHitDamageType = DamageType;
    // End:0x7F
    if(LastHitDamageType != none)
    {
        // End:0x48
        if(ClassIsChildOf(LastHitDamageType, Class'MOHAExplosiveDamageType'))
        {
            m_oHealthInfo.LastDamageType = 1;            
        }
        else
        {
            // End:0x6D
            if(ClassIsChildOf(LastHitDamageType, Class'MOHAMeleeDamageType'))
            {
                m_oHealthInfo.LastDamageType = 2;                
            }
            else
            {
                m_oHealthInfo.LastDamageType = 0;
            }
        }
    }
    // End:0xA1
    if(IsLocallyControlled())
    {
        PlayDefaultTakeDamageSound(m_oHealthInfo.LastDamageType);
    }
    // End:0xC4
    if(int(Role) == int(ROLE_Authority))
    {
        LastHitByLocation = vect(0.0000000, 0.0000000, 0.0000000);
    }
    // End:0x174
    if(InstigatedBy != none)
    {
        // End:0x174
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x101
            if(DamageCauser != none)
            {
                LastHitByLocation = DamageCauser.Location;                
            }
            else
            {
                // End:0x132
                if(InstigatedBy.Pawn != none)
                {
                    LastHitByLocation = InstigatedBy.Pawn.Location;
                }
            }
            // End:0x15F
            if(LastHitByLocation == vect(0.0000000, 0.0000000, 0.0000000))
            {
                LastHitByLocation.Z += 0.0100000;
            }
            m_oHealthInfo.LastHitFromLocation = LastHitByLocation;
        }
    }
    m_oHealthInfo.LastHitBoneID = Mesh.MatchRefBone(HitInfo.BoneName);
    // End:0x1AB
    if(DebugBoneDamage)
    {
    }
    m_oHealthInfo.LastHitLocation = 3;
    AdjustDamageForHitBone(Damage, HitInfo, m_oHealthInfo.LastHitLocation);
    super(MOHAPawn).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x258
    if(Damage > 0)
    {
        // End:0x258
        if(Health > 0)
        {
            // End:0x258
            if((HealthManager != none) && LastHealth > Health)
            {
                HealthManager.GotHurt(LastHealth, Health);
            }
        }
    }
    // End:0x297
    if(WorldInfo.Game != none)
    {
        MOHAMultiplayerGameInfo(WorldInfo.Game).MarkAssistDamage(InstigatedBy, Controller);
    }
    // End:0x2A0
    if(DebugBoneDamage)
    {
    }
    // End:0x2D0
    if((IsGrenadeDamage(DamageCauser)) || int(m_oHealthInfo.LastDamageType) == int(2))
    {
        return;
    }
    // End:0x2F8
    if(MOHAMultiplayerController(InstigatedBy) != none)
    {
        MOHAMultiplayerController(InstigatedBy).AddHit();
    }
    //return;    
}

simulated event CheckPurpleHeart()
{
    MOHAMultiplayerController(Controller).ServerCheckPurpleHeart();
    //return;    
}

simulated function bool IsGrenadeDamage(Actor DamageCauser)
{
    return false;
    //return ReturnValue;    
}

simulated event CallTakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser)
{
    TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser);
    //return;    
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser)
{
    // End:0x64
    if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
    {
        CachedExplosiveMomentum = Momentum;
        CachedExplosiveOrigin = HurtOrigin;
        CachedExplosiveRadius = DamageRadius * 2.2000000;
        CachedExplosiveFullDamage = bFullDamage;
        LastHitDamageType = DamageType;
        SetTimer(0.2500000, false, 'GrenadeImpulseExpires');
    }
    PlayDamageSound(DamageType, false);
    super(Actor).TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser);
    //return;    
}

simulated function GrenadeImpulseExpires()
{
    // End:0x17
    if(float(0) != CachedExplosiveMomentum)
    {
        AddGrenadeForceImpulse();
    }
    CachedExplosiveMomentum = 0.0000000;
    //return;    
}

simulated function AddGrenadeForceImpulse()
{
    // End:0x1D
    if(float(0) != CachedExplosiveMomentum)
    {
        ClearTimer('GrenadeImpulseExpires');
    }
    MOHARagdollSkelComponent(Mesh).AddRagdollRadialImpulse(CachedExplosiveOrigin, CachedExplosiveMomentum, LastHitDamageType, CachedExplosiveRadius, !CachedExplosiveFullDamage);
    //return;    
}

simulated function InitializeAirdropState()
{
    CreateParachute(true);
    // End:0x45
    if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.ThirdPersonMesh != none)
    {
        CurrentWeaponAttachment.ThirdPersonMesh.SetOnlyOwnerSee(true);
    }
    super(MOHAPawn).InitializeAirdropState();
    //return;    
}

simulated function TriggerAirDrop_LandingEvent()
{
    AirDrop_LandingEvent();
    //return;    
}

simulated function PlayLandingSound()
{
    // End:0x1B
    if(IsLocallyControlled())
    {
        PlaySound(ParachuteLandingSound, true);        
    }
    else
    {
        PlaySound(ParachuteLandingSoundNPC, true);
    }
    //return;    
}

event AirDrop_LandingEvent()
{
    super.AirDrop_LandingEvent();
    PlayLandingSound();
    //return;    
}

simulated function CheckLowerbodyActivity(MOHAPlayerPawn.EPlayerActivity PlayerActivity)
{
    local MOHAPlayerPawn.EAnimLocomotionState eLocomotionState;

    // End:0x12
    if(int(Physics) == int(9))
    {
        return;
    }
    // End:0x9A
    if(int(eCurrentLowerBodyActivity) == int(PlayerActivity))
    {
        eLocomotionState = GetLocomotionState();
        // End:0x9A
        if(int(eLocomotionState) != int(0))
        {
            switch(eCurrentStance)
            {
                // End:0x5C
                case 2:
                    eCurrentLowerBodyActivity = 4;
                    // End:0x9A
                    break;
                // End:0x6C
                case 1:
                    eCurrentLowerBodyActivity = 3;
                    // End:0x9A
                    break;
                // End:0x71
                case 0:
                // End:0xFFFF
                default:
                    // End:0x8F
                    if(int(eLocomotionState) == int(1))
                    {
                        eCurrentLowerBodyActivity = 1;                        
                    }
                    else
                    {
                        eCurrentLowerBodyActivity = 2;
                    }
                    // End:0x9A
                    break;
                    break;
            }
        }
    }
    //return;    
}

event bool AnimNotifyHurtRadius(Vector HurtOrigin, float DamageAmount, float DamageRadius, float DamageMomentum, class<DamageType> DamageType, bool bDrawDebugSphere)
{
    local MOHAMultiplayerController mpc;

    // End:0x24
    if(bDrawDebugSphere)
    {
        DrawDebugSphere(HurtOrigin, DamageRadius, 16, 0, 0, byte(255), true);
    }
    mpc = MOHAMultiplayerController(Controller);
    mpc.ServerHurtRadius(DamageAmount, DamageRadius, DamageType, DamageMomentum, HurtOrigin);
    return true;
    //return ReturnValue;    
}

simulated event ForceMeleeAnim()
{
    SetActivity(11);
    //return;    
}

simulated function FindActivityNode()
{
    // End:0x59
    if(FPArms != none)
    {
        ActivityNode = MOHAAnimNodePlayerActivity(FPArms.Animations.FindAnimNode('MOHAAnimNodePlayerActivities'));
        // DebugMode: 0
        assert(ActivityNode != none);
        ActivityNode.SetChildBlendNodeActivities();        
    }
    else
    {
        // End:0xB4
        if(MOHASkeletalMeshComponent(Mesh) != none)
        {
            ActivityNode = MOHAAnimNodePlayerActivity(Mesh.Animations.FindAnimNode('MOHAAnimNodeUpperBodyActivity'));
            // DebugMode: 0
            assert(ActivityNode != none);
            ActivityNode.SetChildBlendNodeActivities();
        }
    }
    //return;    
}

event OnDoneLanding()
{
    super.OnDoneLanding();
    killParachute();
    //return;    
}

simulated function bool InFreeCam()
{
    local PlayerController PC;

    PC = PlayerController(Controller);
    // End:0x5A
    if(((PC != none) && PC.PlayerCamera != none) && PC.PlayerCamera.CameraStyle == 'Spectator')
    {
        return true;
    }
    return super(Pawn).InFreeCam();
    //return ReturnValue;    
}

simulated function killParachute()
{
    // End:0x1E
    if(AirdropParachuteMesh != none)
    {
        AirdropParachuteMesh.Destroy();
        AirdropParachuteMesh = none;
    }
    //return;    
}

function ServerSetLandingType(MOHAPlayerPawn.EAirDropLandingType INeLandingType)
{
    eLandingType = INeLandingType;
    //return;    
}

simulated function bool CalcThirdPersonCam(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector CamStart, HitLocation, HitNormal, CamDir;

    CamStart = Location;
    CamStart.Z += ((0.5000000 * (GetCollisionHeight())) + Mesh.Translation.Z);
    CamDir = (Vector(out_CamRot) * (GetCollisionRadius())) * CurrentCameraScale;
    // End:0xAD
    if(CurrentCameraScale < CameraScale)
    {
        CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + ((float(5) * FMax(CameraScale - CurrentCameraScale, 0.3000000)) * fDeltaTime));        
    }
    else
    {
        // End:0xF0
        if(CurrentCameraScale > CameraScale)
        {
            CurrentCameraScale = FMax(CameraScale, CurrentCameraScale - ((float(5) * FMax(CameraScale - CurrentCameraScale, 0.3000000)) * fDeltaTime));
        }
    }
    // End:0x131
    if(CamDir.Z > (GetCollisionHeight()))
    {
        CamDir *= Square(Cos(float(out_CamRot.Pitch) * 0.0000959));
    }
    out_CamLoc = CamStart - CamDir;
    // End:0x17B
    if(Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12.0000000, 12.0000000, 12.0000000)) != none)
    {
        out_CamLoc = HitLocation;
    }
    return true;
    //return ReturnValue;    
}

event Weapon_RaiseWeaponEvent()
{
    // End:0x48
    if(IsLocallyControlled())
    {
        // End:0x48
        if((Controller != none) && Controller.IsA('MOHAMultiplayerController'))
        {
            // End:0x48
            if(Controller.IsInState('PlayingITPCinematic'))
            {
                return;
            }
        }
    }
    super.Weapon_RaiseWeaponEvent();
    //return;    
}

event MPObjective_Raise()
{
    GotoState('MPObjectiveRaise');
    //return;    
}

event MPObjective_Idle()
{
    GotoState('MPObjectiveChargeIdle');
    //return;    
}

event MPObjective_Lower()
{
    GotoState('MPObjectiveLower');
    //return;    
}

simulated function EndMPObjectiveRaise()
{
    //return;    
}

function ReportLandingType(MOHAPlayerPawn.EAirDropLandingType landingType)
{
    switch(landingType)
    {
        // End:0x33
        case 0:
            ClientMessage("AIRDROP_LANDING_PERFECT");
            // End:0x177
            break;
        // End:0x64
        case 1:
            ClientMessage("AIRDROP_LANDING_HARD_FORWARD");
            // End:0x177
            break;
        // End:0x92
        case 2:
            ClientMessage("AIRDROP_LANDING_HARD_BACK");
            // End:0x177
            break;
        // End:0xC0
        case 3:
            ClientMessage("AIRDROP_LANDING_HARD_LEFT");
            // End:0x177
            break;
        // End:0xEF
        case 4:
            ClientMessage("AIRDROP_LANDING_HARD_RIGHT");
            // End:0x177
            break;
        // End:0x11A
        case 5:
            ClientMessage("AIRDROP_LANDING_FLARED");
            // End:0x177
            break;
        // End:0x146
        case 6:
            ClientMessage("AIRDROP_LANDING_GREASED");
            // End:0x177
            break;
        // End:0xFFFF
        default:
            ClientMessage("UNKNOWN Landing type specified");
            // End:0x177
            break;
            break;
    }
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    SetHealth(0);
    LifeSpan = PawnLifeTimeAfterDeath;
    // End:0x42
    if((Normal(Velocity) Dot Normal(Vector(Rotation))) > 0.5000000)
    {
        VelocityMagAtDeath = VSize(Velocity);        
    }
    else
    {
        VelocityMagAtDeath = 0.0000000;
    }
    Mesh.SetAnimTreeTemplate(DeathAnimTree);
    Mesh.Animations.PlayAnim(false, 1.0000000, 0.0000000);
    SetActivity(33);
    PlaybackLength = 0.0000000;
    bMeshAdj_DynamicDisable = true;
    SetTimer(LifeSpan, false, 'SetUnSpectatable');
    // End:0x10E
    if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.ThirdPersonMesh != none)
    {
        CurrentWeaponAttachment.ThirdPersonMesh.SetOwnerNoSee(true);
        CurrentWeaponAttachment.ThirdPersonMesh.SetOnlyOwnerSee(true);
    }
    // End:0x136
    if(Weapon != none)
    {
        FPArms.DetachComponent(Weapon.Mesh);
    }
    // End:0x151
    if(FPArms != none)
    {
        FPArms.SetHidden(true);
    }
    PlayDamageSound(DamageType, true);
    DetachComponent(FPArms);
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
    GotoState('Dying');
    //return;    
}

simulated function PlayDamageSound(class<DamageType> DamageType, optional bool bFatal)
{
    local SoundCue Cue;
    local MOHAIncludeClass.EDamageSoundType SoundType;

    // End:0x1D
    if((true == IsLocallyControlled()) || true == bLocalPawnDying)
    {
        return;
    }
    // End:0x38
    if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
    {
        SoundType = 3;        
    }
    else
    {
        // End:0x53
        if(ClassIsChildOf(DamageType, Class'Engine.DmgType_Fell'))
        {
            SoundType = 2;            
        }
        else
        {
            // End:0x6A
            if(bFatal == true)
            {
                SoundType = 1;                
            }
            else
            {
                // End:0x9B
                if((int(WorldInfo.NetMode) == int(NM_Client)) || Health > 0)
                {
                    SoundType = 0;                    
                }
                else
                {
                    return;
                }
            }
        }
    }
    // End:0xC5
    if(0 == int(GetTeamNum()))
    {
        Cue = AlliedDamageSounds[int(SoundType)];        
    }
    else
    {
        Cue = AxisDamageSounds[int(SoundType)];
    }
    // End:0xF2
    if(none != Cue)
    {
        PlaySound(Cue, true);
    }
    //return;    
}

simulated event PlayImpactEffects(MOHAPhysicalMaterialProperty.EImpactType ImpactType, name BoneName)
{
    // End:0x0B
    if(IsLocallyControlled())
    {
        return;
    }
    // End:0x31
    if(BoneName == 'None')
    {
        PlayFootstep(ImpactType);        
    }
    else
    {
        PlayFootstep(ImpactType, Mesh.GetBoneLocation(BoneName));
    }
    //return;    
}

simulated function BodyFallSml()
{
    // End:0x0E
    if(true == IsLocallyControlled())
    {
        return;
    }
    PlayFootstep(14);
    //return;    
}

simulated function BodyFallMed()
{
    // End:0x0E
    if(true == IsLocallyControlled())
    {
        return;
    }
    PlayFootstep(15);
    //return;    
}

simulated function BodyFallHard()
{
    // End:0x0E
    if(true == IsLocallyControlled())
    {
        return;
    }
    PlayFootstep(16);
    //return;    
}

simulated function HandThump()
{
    // End:0x0E
    if(true == IsLocallyControlled())
    {
        return;
    }
    PlayFootstep(17);
    //return;    
}

simulated function LegThump()
{
    // End:0x0E
    if(false == IsLocallyControlled())
    {
        return;
    }
    PlayFootstep(18);
    //return;    
}

simulated function HelmetThump()
{
    // End:0x0E
    if(false == IsLocallyControlled())
    {
        return;
    }
    PlayFootstep(19);
    //return;    
}

simulated function bool AllowAimBlend()
{
    switch(LadderState)
    {
        // End:0x0C
        case 1:
        // End:0x11
        case 2:
        // End:0x16
        case 3:
        // End:0x1B
        case 4:
        // End:0x22
        case 5:
            return false;
        // End:0xFFFF
        default:
            return true;
            break;
    }
    //return ReturnValue;    
}

simulated event Vector GetAimVec()
{
    local Vector AimDirection;

    AimDirection.Y = float(NormalizeRotAxis(RemoteBlendedViewPitch)) / 16384.0000000;
    AimDirection.X = 0.0000000;
    AimDirection.Y = ((AllowAimBlend()) ? FClamp(AimDirection.Y, -1.0000000, 1.0000000) : 0.0000000);
    AimDirection.Z = 0.0000000;
    return AimDirection;
    //return ReturnValue;    
}

simulated function MOHAPlayerPawn.EAnimLocomotionState GetLocomotionState()
{
    local float fSpeed, fSprintThreshold;

    fSpeed = VSize(Velocity);
    fSprintThreshold = (GroundSpeed * (GetWeaponSpeedMultiplier())) * 0.6000000;
    // End:0x6F
    if(((bForceIdleAnim || fSpeed == 0.0000000) || int(Physics) != int(1)) || int(LastActivity) == int(25))
    {
        return 0;        
    }
    else
    {
        // End:0x93
        if((fSpeed > fSprintThreshold) && IsSprintEnabled())
        {
            return 2;            
        }
        else
        {
            return 1;
        }
    }
    //return ReturnValue;    
}

event Player_JumpEvent()
{
    // End:0x15
    if(IsTimerActive('ProgressJumpClear'))
    {
        return;
    }
    // End:0x27
    if(IsLocallyControlled())
    {
        super.Player_JumpEvent();        
    }
    else
    {
        StartAnimatedJump();
        DoJump(true);
    }
    //return;    
}

function ProgressJumpIdle()
{
    FakeJumpState = 2;
    //return;    
}

function ProgressJumpClear()
{
    FakeJumpState = 0;
    //return;    
}

simulated event PlayDefaultTakeDamageSound(MOHAMultiplayerPawn.EDamageType dtype)
{
    switch(dtype)
    {
        // End:0x1E
        case 2:
            PlaySound(MeleeImpactPC, true);
            // End:0x3B
            break;
        // End:0x35
        case 0:
            PlaySound(DefaultTakeDamageSound, true);
            // End:0x3B
            break;
        // End:0xFFFF
        default:
            // End:0x3B
            break;
            break;
    }
    return;
    //return;    
}

simulated event PlayDefaultTakeDamageSoundNPC(MOHAMultiplayerPawn.EDamageType dtype)
{
    switch(dtype)
    {
        // End:0x1E
        case 2:
            PlaySound(MeleeImpactNPC, true);
            // End:0x24
            break;
        // End:0xFFFF
        default:
            // End:0x24
            break;
            break;
    }
    //return;    
}

function StartProceduralJump()
{
    super.StartProceduralJump();
    // End:0x43
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        FakeJumpState = 1;
        bMeshAdj_DynamicDisable = true;
        SetTimer(fJumpStartAnimTime, false, 'ProgressJumpIdle');
    }
    //return;    
}

function EndProceduralJump()
{
    super.EndProceduralJump();
    // End:0x4F
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        // End:0x37
        if(int(FakeJumpState) != int(0))
        {
            FakeJumpState = 3;
        }
        bMeshAdj_DynamicDisable = false;
        ClearTimer('ProgressJumpIdle');
    }
    SetTimer(fJumpEndHardAnimTime, false, 'ProgressJumpClear');
    //return;    
}

function StartAnimatedJump()
{
    super.StartAnimatedJump();
    bMeshAdj_DynamicDisable = true;
    //return;    
}

simulated function SetActivity(MOHAPlayerPawn.EPlayerActivity NextActivity)
{
    super.SetActivity(NextActivity);
    UpdateMPActivities(NextActivity);
    //return;    
}

simulated function float GetActivityBlendTime(MOHAPlayerPawn.EPlayerActivity NextActivity)
{
    // End:0x17
    if(FPArms != none)
    {
        return super.GetActivityBlendTime(NextActivity);
    }
    // End:0x3F
    if((int(NextActivity) == int(40)) || int(NextActivity) == int(38))
    {
        return 0.7500000;
    }
    // End:0x67
    if((int(NextActivity) == int(25)) || int(LastActivity) == int(25))
    {
        return 0.4000000;
    }
    // End:0x8F
    if((int(LastActivity) == int(27)) && int(NextActivity) == int(28))
    {
        return 0.0000000;
    }
    // End:0xB7
    if((int(LastActivity) == int(27)) && int(NextActivity) == int(29))
    {
        return 0.0000000;
    }
    // End:0xDF
    if((int(LastActivity) == int(26)) && int(NextActivity) == int(27))
    {
        return 0.3000000;
    }
    // End:0x107
    if((int(LastActivity) == int(0)) && int(NextActivity) == int(11))
    {
        return 0.2000000;
    }
    // End:0x12F
    if((int(LastActivity) == int(11)) && int(NextActivity) == int(0))
    {
        return 0.1000000;
    }
    // End:0x157
    if((int(LastActivity) == int(0)) && int(NextActivity) == int(7))
    {
        return 0.0000000;
    }
    // End:0x17F
    if((int(LastActivity) == int(19)) && int(NextActivity) == int(20))
    {
        return 0.1000000;
    }
    // End:0x1A7
    if((int(LastActivity) == int(20)) && int(NextActivity) == int(19))
    {
        return 0.1000000;
    }
    // End:0x1CF
    if((int(LastActivity) == int(0)) && int(NextActivity) == int(7))
    {
        return 0.0000000;
    }
    // End:0x1F7
    if((int(NextActivity) == int(7)) || int(NextActivity) == int(24))
    {
        return 0.1000000;
    }
    // End:0x21F
    if((int(NextActivity) == int(8)) && int(LastActivity) == int(8))
    {
        return 0.1000000;
    }
    // End:0x247
    if((int(NextActivity) == int(17)) && int(LastActivity) == int(14))
    {
        return 0.0000000;
    }
    // End:0x25D
    if(int(NextActivity) == int(35))
    {
        return 0.0000000;
    }
    // End:0x285
    if((int(NextActivity) == int(27)) && int(LastActivity) == int(54))
    {
        return 0.0000000;
    }
    // End:0x2AD
    if((int(NextActivity) == int(52)) || int(NextActivity) == int(50))
    {
        return 0.0000000;
    }
    // End:0x2D5
    if((int(NextActivity) == int(51)) || int(NextActivity) == int(53))
    {
        return 0.0000000;
    }
    return fDefaultActivityBlendTime;
    //return ReturnValue;    
}

simulated function SendActivitySetNotifications()
{
    // End:0x14
    if(FPArms != none)
    {
        super.SendActivitySetNotifications();        
    }
    else
    {
        // End:0x46
        if(MOHASkeletalMeshComponent(Mesh) != none)
        {
            MOHASkeletalMeshComponent(Mesh).fActivitySetTime = WorldInfo.RealTimeSeconds;
        }
    }
    //return;    
}

simulated function UpdateMPActivities(MOHAPlayerPawn.EPlayerActivity NextActivity)
{
    local MOHAPlayerPawn.EAnimLocomotionState eLocomotionState;

    switch(NextActivity)
    {
        // End:0x0C
        case 7:
        // End:0x11
        case 13:
        // End:0x16
        case 14:
        // End:0x1B
        case 15:
        // End:0x20
        case 16:
        // End:0x25
        case 17:
        // End:0x2A
        case 18:
        // End:0x2F
        case 21:
        // End:0x34
        case 22:
        // End:0x39
        case 23:
        // End:0x3E
        case 24:
        // End:0x43
        case 44:
        // End:0x56
        case 45:
            eCurrentUpperBodyActivity = NextActivity;
            // End:0x260
            break;
        // End:0x10D
        case 0:
            eCurrentUpperBodyActivity = NextActivity;
            // End:0x10A
            if(!(int(eCurrentLowerBodyActivity) == int(26)) || int(eCurrentLowerBodyActivity) == int(27))
            {
                eLocomotionState = GetLocomotionState();
                // End:0xB5
                if(int(eLocomotionState) == int(0))
                {
                    eCurrentLowerBodyActivity = 0;                    
                }
                else
                {
                    switch(eCurrentStance)
                    {
                        // End:0xCC
                        case 2:
                            eCurrentLowerBodyActivity = 4;
                            // End:0x10A
                            break;
                        // End:0xDC
                        case 1:
                            eCurrentLowerBodyActivity = 3;
                            // End:0x10A
                            break;
                        // End:0xE1
                        case 0:
                        // End:0xFFFF
                        default:
                            // End:0xFF
                            if(int(eLocomotionState) == int(1))
                            {
                                eCurrentLowerBodyActivity = 1;                                
                            }
                            else
                            {
                                eCurrentLowerBodyActivity = 2;
                            }
                            // End:0x10A
                            break;
                            break;
                    }
                }
            }
            // End:0x260
            break;
        // End:0x112
        case 1:
        // End:0x117
        case 2:
        // End:0x11C
        case 3:
        // End:0x121
        case 26:
        // End:0x126
        case 27:
        // End:0x12B
        case 28:
        // End:0x130
        case 29:
        // End:0x135
        case 4:
        // End:0x13A
        case 5:
        // End:0x13F
        case 6:
        // End:0x144
        case 30:
        // End:0x149
        case 31:
        // End:0x14E
        case 32:
        // End:0x153
        case 33:
        // End:0x158
        case 34:
        // End:0x15D
        case 35:
        // End:0x162
        case 36:
        // End:0x167
        case 37:
        // End:0x16C
        case 38:
        // End:0x171
        case 39:
        // End:0x176
        case 40:
        // End:0x17B
        case 41:
        // End:0x180
        case 42:
        // End:0x185
        case 43:
        // End:0x18A
        case 46:
        // End:0x18F
        case 47:
        // End:0x194
        case 48:
        // End:0x199
        case 49:
        // End:0x19E
        case 50:
        // End:0x1A3
        case 51:
        // End:0x1A8
        case 52:
        // End:0x1AD
        case 53:
        // End:0x1CB
        case 54:
            eCurrentUpperBodyActivity = NextActivity;
            eCurrentLowerBodyActivity = NextActivity;
            // End:0x260
            break;
        // End:0x1D0
        case 11:
        // End:0x1D5
        case 25:
        // End:0x1DA
        case 12:
        // End:0x1DF
        case 8:
        // End:0x1E4
        case 9:
        // End:0x1E9
        case 10:
        // End:0x1EE
        case 19:
        // End:0x25A
        case 20:
            eLocomotionState = GetLocomotionState();
            // End:0x24C
            if(((int(WorldInfo.NetMode) != int(NM_Client)) && int(eLocomotionState) == int(0)) && 1.0000000 > Abs(fIdleTurnRate))
            {
                eCurrentLowerBodyActivity = NextActivity;
            }
            eCurrentUpperBodyActivity = NextActivity;
            // End:0x260
            break;
        // End:0xFFFF
        default:
            // End:0x260
            break;
            break;
    }
    //return;    
}

simulated function UpwardStanceChangeRequest(optional bool bTwoStanceChange = false)
{
    // End:0x10
    if(bLockStanceHeight)
    {
        return;
    }
    // End:0x2B
    if(int(eCurrentStance) == int(1))
    {
        eDesiredStance = 0;        
    }
    else
    {
        // End:0x50
        if(int(eCurrentStance) == int(2))
        {
            eDesiredStance = ((bTwoStanceChange) ? 0 : 1);
        }
    }
    //return;    
}

simulated function DownwardStanceChangeRequest(optional bool bTwoStanceChange = false)
{
    // End:0x10
    if(bLockStanceHeight)
    {
        return;
    }
    // End:0x28
    if(int(eCurrentStance) == int(0))
    {
        eDesiredStance = 1;
    }
    //return;    
}

simulated function PlayStanceChangeSound()
{
    // End:0x32
    if(IsLocallyControlled())
    {
        PlaySound(StanceChangeSounds[int(GetStanceChangeType(eCurrentStance, eDesiredStance))], true);        
    }
    else
    {
        PlaySound(StanceChangeSounds3rdPerson[int(GetStanceChangeType(eCurrentStance, eDesiredStance))], true);
    }
    //return;    
}

simulated function Vector GetBoneLocation(name BoneName)
{
    // End:0x39
    if(IsLocallyControlled())
    {
        return ((FPArms != none) ? FPArms.super(SkeletalMeshComponent).GetBoneLocation(BoneName) : vect(0.0000000, 0.0000000, 0.0000000));
    }
    return ((Mesh != none) ? Mesh.super(SkeletalMeshComponent).GetBoneLocation(BoneName) : vect(0.0000000, 0.0000000, 0.0000000));
    //return ReturnValue;    
}

simulated function Rotator GetBoneRotation(name BoneName)
{
    // End:0x3F
    if(IsLocallyControlled())
    {
        return ((FPArms != none) ? QuatToRotator(FPArms.GetBoneQuaternion(BoneName)) : rot(0, 0, 0));
    }
    return ((Mesh != none) ? QuatToRotator(Mesh.GetBoneQuaternion(BoneName)) : rot(0, 0, 0));
    //return ReturnValue;    
}

simulated event Player_StanceChangeEvent()
{
    // End:0x42
    if(!IsLocallyControlled())
    {
        PlayStanceChangeSound();
        StanceChangeTime = WorldInfo.TimeSeconds;
        eCurrentStance = eDesiredStance;
        UpdateSkelControls();        
    }
    else
    {
        super.Player_StanceChangeEvent();
    }
    //return;    
}

simulated function AddDefaultInventory()
{
    local int I;
    local string MPInvClassName;
    local class<Inventory> MPInvClass;
    local class<EALAAmmoInventoryClass> AmmoClass;
    local array<AmmoInfo> AmmoList;
    local EALAWeapon W;
    local MOHAInventoryManager MOHAInvManager;

    MOHAInvManager = MOHAInventoryManager(InvManager);
    AmmoList = ((WorldInfo.AmmoLoadout.Length > 0) ? WorldInfo.AmmoLoadout : DefaultAmmoLoadout);
    I = 0;
    J0x47:

    // End:0xFC [Loop If]
    if(I < AmmoList.Length)
    {
        // End:0xF2
        if(ClassIsChildOf(AmmoList[I].AmmoClass, Class'EALAAmmoInventoryClass'))
        {
            AmmoClass = class<EALAAmmoInventoryClass>(AmmoList[I].AmmoClass);
            MOHAInvManager.SetMaxAmmoCount(AmmoClass, AmmoList[I].MaxReserveAmmo);
            MOHAInvManager.AddReserveAmmo(AmmoClass, AmmoList[I].StartingReserveAmmo);
        }
        I++;
        // [Loop Continue]
        goto J0x47;
    }
    I = 0;
    J0x103:

    // End:0x208 [Loop If]
    if(I < DefaultWeaponLoadout.Length)
    {
        // End:0x1BD
        if(Right(PathName(DefaultWeaponLoadout[I].WeaponClass), 2) != "MP")
        {
            MPInvClassName = PathName(DefaultWeaponLoadout[I].WeaponClass) $ "MP";
            MPInvClass = class<Inventory>(DynamicLoadObject(MPInvClassName, Class'Core.Class'));
            // End:0x1BD
            if(MPInvClass != none)
            {
                W = EALAWeapon(AddInv(MPInvClass, I > 0));
                PreUpgrade(W);
                // [Explicit Continue]
                goto J0x1FE;
            }
        }
        W = EALAWeapon(AddInv(DefaultWeaponLoadout[I].WeaponClass, I > 0));
        PreUpgrade(W);
        J0x1FE:

        I++;
        // [Loop Continue]
        goto J0x103;
    }
    MOHAInvManager.SetupWeaponPointers();
    //return;    
}

simulated function PreUpgrade(EALAWeapon W)
{
    local int UpgradeLevel, I;

    // End:0x1A
    if((W == none) || WeaponUpgradeManager == none)
    {
        return;
    }
    UpgradeLevel = GetUpgradeStatus(int(W.WeaponClass));
    I = 0;
    J0x41:

    // End:0x85 [Loop If]
    if(I <= UpgradeLevel)
    {
        WeaponUpgradeManager.PreUpgrade(W.WeaponType, I, W);
        I++;
        // [Loop Continue]
        goto J0x41;
    }
    //return;    
}

simulated function PreDamage_ImpartHitMomentum(Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Controller InstigatedBy)
{
    super(MOHAPawn).PreDamage_ImpartHitMomentum(HitLocation, Momentum, DamageType, HitInfo, InstigatedBy);
    PlayDamageSound(DamageType, false);
    //return;    
}

simulated function Inventory AddInv(class<Inventory> InvType, bool bDoNotActivate)
{
    local Inventory I;

    I = FindInventoryType(InvType);
    // End:0x34
    if(I == none)
    {
        I = CreateInventory(InvType, bDoNotActivate);
    }
    return I;
    //return ReturnValue;    
}

function TossWeapon(Weapon Weap, optional Vector TossVel)
{
    local Vector X, Y, Z;
    local Weapon TossWeapon, SecondaryWeapon;
    local EALAGrenade Grenade;

    // End:0x94
    if(Weapon.IsA('EALAGrenade'))
    {
        Grenade = EALAGrenade(Weapon);
        // End:0x94
        if(Grenade.bIsCooking == true)
        {
            Grenade.ThrowStrength = (-0.7500000 * Grenade.ExplosiveSpeed) / (Grenade.MaxExplosiveSpeed - Grenade.ExplosiveSpeed);
            Grenade.ProjectileFire();
        }
    }
    SecondaryWeapon = MOHAInventoryManager(InvManager).SecondaryWeapon;
    // End:0xE5
    if((Weapon != SecondaryWeapon) || SecondaryWeapon == none)
    {
        TossWeapon = MOHAInventoryManager(InvManager).PrimaryWeapon;        
    }
    else
    {
        TossWeapon = SecondaryWeapon;
    }
    // End:0x16F
    if(TossWeapon != none)
    {
        GetPawnAxes(X, Y, Z);
        TossWeapon.DropFrom((Location + ((0.8000000 * CylinderComponent.CollisionRadius) * X)) - ((0.5000000 * CylinderComponent.CollisionRadius) * Y), TossVel,, true);
    }
    //return;    
}

simulated function PossessedBy(Controller C, bool bVehicleTransition)
{
    local MOHAMultiplayerController mpc;
    local int WeaponUpgradeLevel, I;
    local MOHAGameReplicationInfo MGRI;

    super.PossessedBy(C, bVehicleTransition);
    mpc = MOHAMultiplayerController(C);
    MGRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    // End:0x261
    if((mpc != none) && int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        I = 0;
        J0x67:

        // End:0x8D [Loop If]
        if(I <= 8)
        {
            UpdateUpgradeStatus(I, 0);
            I++;
            // [Loop Continue]
            goto J0x67;
        }
        // End:0x202
        if(int(MGRI.UpgradesAllowed) == int(1))
        {
            WeaponUpgradeLevel = Clamp(MOHAPlayerReplicationInfo(mpc.PlayerReplicationInfo).MPStatsWeaponClass[2].UpgradeLevel, 0, 3);
            UpdateUpgradeStatus(2, WeaponUpgradeLevel);
            WeaponUpgradeLevel = Clamp(MOHAPlayerReplicationInfo(mpc.PlayerReplicationInfo).MPStatsWeaponClass[3].UpgradeLevel, 0, 3);
            UpdateUpgradeStatus(3, WeaponUpgradeLevel);
            WeaponUpgradeLevel = Clamp(MOHAPlayerReplicationInfo(mpc.PlayerReplicationInfo).MPStatsWeaponClass[4].UpgradeLevel, 0, 3);
            UpdateUpgradeStatus(4, WeaponUpgradeLevel);
            WeaponUpgradeLevel = Clamp(MOHAPlayerReplicationInfo(mpc.PlayerReplicationInfo).MPStatsWeaponClass[5].UpgradeLevel, 0, 3);
            UpdateUpgradeStatus(5, WeaponUpgradeLevel);
            WeaponUpgradeLevel = Clamp(MOHAPlayerReplicationInfo(mpc.PlayerReplicationInfo).MPStatsWeaponClass[8].UpgradeLevel, 0, 3);
            UpdateUpgradeStatus(8, WeaponUpgradeLevel);            
        }
        else
        {
            // End:0x261
            if(int(MGRI.UpgradesAllowed) == int(2))
            {
                UpdateUpgradeStatus(2, 3);
                UpdateUpgradeStatus(3, 3);
                UpdateUpgradeStatus(4, 3);
                UpdateUpgradeStatus(5, 3);
                UpdateUpgradeStatus(8, 3);
            }
        }
    }
    // End:0x27E
    if(!IsLocallyControlled())
    {
        DetachComponent(FPArms);
        FPArms = none;
    }
    //return;    
}

simulated function bool LadderJump()
{
    //return ReturnValue;    
}

simulated function ClimbLadder(LadderVolume L)
{
    //return;    
}

simulated function bool CanBreakOut()
{
    return true;
    //return ReturnValue;    
}

simulated function bool CanGrabLadder()
{
    return ((bCanClimbLadders && Controller != none) && int(Physics) == int(1)) && (int(CurrentActivity) == int(0)) || int(CurrentActivity) == int(1);
    //return ReturnValue;    
}

simulated function GetLadderEntryStartPosition(out Vector pos)
{
    // End:0x57
    if(Abs(Location.Z - LadderTop.Z) > Abs(Location.Z - LadderBottom.Z))
    {
        pos = LadderBottom;        
    }
    else
    {
        pos = LadderTop + (Vector(OnLadderMP.Rotation) * LadderTopExitOffset.X);
    }
    LadderCurrentRung = (pos.Z - LadderBasePosition) / LadderRungDistance;
    //return;    
}

// Export UMOHAMultiplayerPawn::execGetClosestLadder(FFrame&, void* const)
native function MOHAMPLadder GetClosestLadder();

simulated function EnterClosestLadderBottom()
{
    local MOHAMPLadder lad;
    local Vector pos;

    lad = GetClosestLadder();
    // End:0x77
    if(lad != none)
    {
        pos = lad.Location;
        pos.Z += (GetCollisionHeight());
        SetLocation(pos);
        SetRotation(lad.Rotation);
        SetActivity(51);
        bMeshAdj_DynamicDisable = true;
    }
    //return;    
}

simulated function EnterClosestLadderTop()
{
    local MOHAMPLadder lad;
    local Vector pos;

    lad = GetClosestLadder();
    // End:0x98
    if(lad != none)
    {
        pos = lad.Location;
        pos.Z += (((GetCollisionHeight()) + lad.LadderHeight) - LadderTopExitOffset.Z);
        SetLocation(pos);
        SetRotation(lad.Rotation);
        SetActivity(50);
        bMeshAdj_DynamicDisable = true;
    }
    //return;    
}

simulated function ExitClosestLadderBottom()
{
    local MOHAMPLadder lad;
    local Vector pos;

    lad = GetClosestLadder();
    // End:0x77
    if(lad != none)
    {
        pos = lad.Location;
        pos.Z += (GetCollisionHeight());
        SetLocation(pos);
        SetRotation(lad.Rotation);
        SetActivity(53);
        bMeshAdj_DynamicDisable = false;
    }
    //return;    
}

simulated function ExitClosestLadderTop()
{
    local MOHAMPLadder lad;
    local Vector pos;

    lad = GetClosestLadder();
    // End:0xAF
    if(lad != none)
    {
        pos = lad.Location;
        pos.Z += ((GetCollisionHeight()) + lad.LadderHeight);
        pos += (Vector(lad.Rotation) * LadderTopExitOffset.X);
        SetLocation(pos);
        SetRotation(lad.Rotation);
        SetActivity(52);
        bMeshAdj_DynamicDisable = false;
    }
    //return;    
}

simulated function ClimbLadderMP(MOHAMPLadder L)
{
    OnLadderMP = L;
    // End:0x2A
    if((OnLadderMP == none) || int(Physics) == int(2))
    {
        return;
    }
    LadderBottom = OnLadderMP.Location;
    LadderBottom.Z += (GetCollisionHeight());
    LadderTop = LadderBottom;
    LadderTop.Z += OnLadderMP.LadderHeight;
    GotoState('EnterLadderLowerWeapon');
    //return;    
}

function LadderStateChange()
{
    //return;    
}

simulated function CleanUpLadder()
{
    SetPhysics(2);
    OnLadderMP = none;
    SetActivity(20);
    PlaybackLength = 0.5000000;
    HideWeapon(true);
    // End:0x49
    if(FPArms != none)
    {
        FPArms.SetHidden(false);
    }
    // End:0x68
    if(CurrentWeaponAttachment != none)
    {
        CurrentWeaponAttachment.Hide(false);
    }
    SetWeaponDisabled(false);
    LadderState = 6;
    bMeshAdj_DynamicDisable = false;
    ActivityDoneEvent();
    GotoState('Idle');
    //return;    
}

simulated event float GetLadderAnimPosition()
{
    local float pos, Offset;

    // End:0xD5
    if(int(LadderState) == int(3))
    {
        pos = (Location.Z - LadderBasePosition) / LadderRungDistance;
        Offset = pos - float(int(pos));
        // End:0xB7
        if((IsLocallyControlled() == false) && int(pos * float(2)) != LastLadderAnimRung)
        {
            PlayImpact(12, Location - (vect(0.0000000, 0.0000000, 1.0000000) * (GetCollisionHeight())), vect(0.0000000, 0.0000000, 1.0000000), none, Class'MOHAMPLadder'.default.PhysMaterial);
        }
        LastLadderAnimRung = int(pos * float(2));
        LastLadderAnimOffset = Offset;
    }
    return LastLadderAnimOffset;
    //return ReturnValue;    
}

event bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local MOHAMPInventoryManager mpInvMgr;
    local MOHAMultiplayerPawn f_killerPawn;

    mpInvMgr = MOHAMPInventoryManager(InvManager);
    // End:0x50
    if((mpInvMgr != none) && Killer != none)
    {
        mpInvMgr.DropAmmoPickup(self);
        mpInvMgr.DropMedkit(self);
    }
    f_killerPawn = MOHAMultiplayerPawn(MOHAMultiplayerController(Killer).Pawn);
    // End:0x99
    if(f_killerPawn != none)
    {
        MOHAMultiplayerController(Controller).ClientSetKillerPawn(f_killerPawn);        
    }
    else
    {
        // End:0xCC
        if(IsLocallyControlled())
        {
            MOHAMultiplayerController(Controller).KillerPawn = MOHAMultiplayerController(Killer).CachedPawnForKillerPawn;            
        }
        else
        {
            MOHAMultiplayerController(Controller).ClientSetKillerPawnFromPlayerID(MOHAMultiplayerController(Killer).PlayerReplicationInfo.PlayerID);
        }
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

simulated function Destroyed()
{
    // End:0x1E
    if(WeaponSimulation != none)
    {
        WeaponSimulation.Destroy();
        WeaponSimulation = none;
    }
    // End:0x3C
    if(InvManager != none)
    {
        InvManager.Destroy();
        InvManager = none;
    }
    super(MOHAPawn).Destroyed();
    //return;    
}

simulated function PostDamage_ImpartHitMomentum(Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional int AdjustedDamage, optional Controller InstigatedBy)
{
    //return;    
}

// Export UMOHAMultiplayerPawn::execVerifyClientClaim(FFrame&, void* const)
native function bool VerifyClientClaim(const out ClaimHitInfo Hit);

state Melee
{
    simulated function BeginState(name PreviousStateName)
    {
        bForceMeleeReplication = true;
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        CheckLowerbodyActivity(11);
        //return;        
    }
    stop;    
}

state StanceChange
{
    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        CheckLowerbodyActivity(25);
        //return;        
    }
    stop;    
}

state LowerWeapon
{
    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        CheckLowerbodyActivity(19);
        //return;        
    }
    stop;    
}

state RaiseWeapon
{
    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        CheckLowerbodyActivity(20);
        //return;        
    }
    stop;    
}

state Reload
{
    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        CheckLowerbodyActivity(8);
        //return;        
    }
    stop;    
}

state Reload_In
{
    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        CheckLowerbodyActivity(9);
        //return;        
    }
    stop;    
}

state Reload_Out
{
    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        CheckLowerbodyActivity(10);
        //return;        
    }
    stop;    
}

state Rechamber
{
    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        CheckLowerbodyActivity(12);
        //return;        
    }
    stop;    
}

state AirDropDeployChute
{
    event EncroachedBy(Actor Other)
    {
        //return;        
    }

    simulated function LoadDefaultAnimTreeAndSet()
    {
        FindActivityNode();
        InitSkeletalControls();
        //return;        
    }
    stop;    
}

state AirDropControlledFall
{
    event ActivityDoneEvent()
    {
        //return;        
    }

    event AirDrop_MeleeEvent()
    {
        // End:0x43
        if((int(WorldInfo.NetMode) == int(NM_Client)) && MOHAMultiplayerController(Controller) != none)
        {
            MOHAMultiplayerController(Controller).ServerMeleeKick();
        }
        super.AirDrop_MeleeEvent();
        //return;        
    }

    simulated function UpdateAirdropLook(float DeltaTime)
    {
        // End:0x0D
        if(!IsLocallyControlled())
        {
            return;
        }
        super.UpdateAirdropLook(DeltaTime);
        //return;        
    }
    stop;    
}

state AirDropLanded
{
    function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        // End:0x3A
        if(InstigatedBy != none)
        {
            global.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        ViewPitchMin = -16000.0000000;
        //return;        
    }

    event ActivityDoneEvent()
    {
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        CheckLowerbodyActivity(42);
        //return;        
    }
    stop;    
}

simulated state AirDropLanding
{
    event ActivityDoneEvent()
    {
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local MOHAMultiplayerController PlayerController;
        local Rotator vRotation;

        vRotation = QuatToRotator(AirdropViewCache);
        vRotation.Roll = 0;
        SetRotation(vRotation);
        PlayerController = MOHAMultiplayerController(Controller);
        // End:0x56
        if(PlayerController != none)
        {
            PlayerController.SetRotation(vRotation);
        }
        eLandingType = 6;
        ActivateLandedEvents();
        SetActivity(41);
        SetTimer(0.1000000, false, 'AirDropLandingDone');
        Airdrop_BG_Loop.Stop();
        StopWindVolumeSound();
        EnableRadialBlur(false);
        // End:0xCA
        if(AirdropParachuteMesh != none)
        {
            AirdropParachuteMesh.HitGround();
        }
        Mesh.RootMotionMode = 3;
        // End:0xF1
        if(IsLocallyControlled())
        {
            killParachute();            
        }
        else
        {
            AirdropParachuteMesh.PlayChuteLandingAnimation();
            AirdropParachuteMesh.HitGround();
            AirdropParachuteMesh = none;
        }
        //return;        
    }

    function ServerSetLandingType(MOHAPlayerPawn.EAirDropLandingType INeLandingType)
    {
        eLandingType = INeLandingType;
        PostLandingTypeDetermination();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        Mesh.RootMotionMode = 2;
        // End:0x76
        if(Weapon != none)
        {
            HideWeapon(true);
            // End:0x76
            if(Weapon.Mesh != none)
            {
                Weapon.Mesh.SetOwnerNoSee(Weapon.Mesh.default.bOwnerNoSee);
            }
        }
        // End:0xB0
        if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.ThirdPersonMesh != none)
        {
            CurrentWeaponAttachment.ThirdPersonMesh.SetOnlyOwnerSee(false);
        }
        //return;        
    }
    stop;    
}

state MultiplayerInThePlane
{
    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        // End:0x25
        if(Weapon != none)
        {
            HideWeapon(false);
        }
        // End:0x5D
        if(CurrentWeaponAttachment != none)
        {
            // End:0x5D
            if(CurrentWeaponAttachment.ThirdPersonMesh != none)
            {
                CurrentWeaponAttachment.ThirdPersonMesh.SetOnlyOwnerSee(true);
            }
        }
        //return;        
    }

    simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        super(Pawn).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        //return;        
    }
    stop;    
}

state MPObjectiveRaise
{
    simulated function BeginState(name PreviousStateName)
    {
        SetActivity(47);
        PlaybackLength = 0.6600000;
        SetTimer(PlaybackLength, false, 'EndMPObjectiveRaise');
        //return;        
    }

    simulated function EndMPObjectiveRaise()
    {
        MPObjective_Idle();
        //return;        
    }
    stop;    
}

state MPObjectiveChargeIdle
{
    simulated function BeginState(name PreviousStateName)
    {
        SetActivity(48);
        PlaybackLength = 0.0000000;
        //return;        
    }

    simulated function bool IsDemoCharging()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state MPObjectiveLower
{
    simulated function BeginState(name PreviousStateName)
    {
        SetActivity(49);
        PlaybackLength = 1.0000000;
        ActivityDoneEvent();
        //return;        
    }
    stop;    
}

state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I;
        local PlayerController PlayerController;

        killParachute();
        // End:0x3A
        if(IsLocallyControlled())
        {
            MOHAMPInventoryManager(InvManager).PlayerPawnDied();
            ShellShockMixSelect.DeActivate();
        }
        bLocalPawnDying = IsLocallyControlled();
        // End:0x6E
        if((LastHitDamageType != none) && ClassIsChildOf(LastHitDamageType, Class'MOHAExplosiveDamageType'))
        {
            AddGrenadeForceImpulse();
        }
        // End:0x83
        if(int(Physics) != int(10))
        {
            SetPhysics(2);
        }
        // End:0xCD
        foreach LocalPlayerControllers(PlayerController)
        {
            // End:0xCC
            if(MOHAHUD_MP(PlayerController.myHUD) != none)
            {
                MOHAHUD_MP(PlayerController.myHUD).RemoveCompassBead(self);
            }            
        }        
        SetCollision(false, false, true);
        // End:0xF3
        if(none != Controller)
        {
            Controller.PawnDied(self);
        }
        I = 0;
        J0xFA:

        // End:0x13E [Loop If]
        if(I < Attached.Length)
        {
            // End:0x134
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0xFA;
        }
        GoTerminalRagdoll();
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function GoTerminalRagdoll()
    {
        // End:0x78
        if(!bNoRagdoll)
        {
            // End:0x5D
            if(RagdollThrowActivated || (class<MOHADamageType>(LastHitDamageType) != none) && class<MOHADamageType>(LastHitDamageType).default.bKillShouldCauseLimpRagdoll)
            {
                MOHARagdollSkelComponent(Mesh).GoTerminalRagdoll(1);                
            }
            else
            {
                MOHARagdollSkelComponent(Mesh).GoTerminalRagdoll(2);
            }
        }
        //return;        
    }

    simulated function NotifyDeathRagdoll()
    {
        // End:0x26
        if(!bNoRagdoll)
        {
            MOHARagdollSkelComponent(Mesh).GoTerminalRagdoll(1);
        }
        //return;        
    }

    simulated function NotifyLocoRagdollLimp()
    {
        // End:0x26
        if(!bNoRagdoll)
        {
            MOHARagdollSkelComponent(Mesh).GoTerminalRagdoll(1, false);
        }
        //return;        
    }
    stop;    
}

state EnterLadderLowerWeapon
{
    function LadderStateChange()
    {
        // End:0x21
        if(int(LadderState) == int(1))
        {
            GotoState('EnterLadderAnimBottom');            
        }
        else
        {
            // End:0x42
            if(int(LadderState) == int(2))
            {
                GotoState('EnterLadderAnimTop');                
            }
            else
            {
                // End:0x57
                if(int(LadderState) == int(0))
                {
                    return;                    
                }
                else
                {
                    // End:0x78
                    if(int(LadderState) == int(3))
                    {
                        GotoState('LadderClimb');                        
                    }
                    else
                    {
                        // End:0xA0
                        if(MOHAMultiplayerController(Controller) != none)
                        {
                            MOHAMultiplayerController(Controller).ExitLadder();
                        }
                    }
                }
            }
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetActivity(19);
        SetCurrentStance(0);
        SetPhysics(9);
        PlaybackLength = 0.2500000;
        SetWeaponDisabled(true);
        LadderBasePosition = LadderBottom.Z;
        GetLadderEntryStartPosition(LadderLerpToPosition);
        LadderLerpToRotation = OnLadderMP.Rotation;
        LadderLerpToRotation.Pitch = Rotation.Pitch;
        LadderState = 0;
        bMeshAdj_DynamicDisable = true;
        Controller.GotoState('LadderLerp');
        //return;        
    }

    simulated function GetLadderEntryStartPosition(out Vector pos)
    {
        // End:0x57
        if(Abs(Location.Z - LadderTop.Z) > Abs(Location.Z - LadderBottom.Z))
        {
            pos = LadderBottom;            
        }
        else
        {
            pos = LadderTop + (Vector(OnLadderMP.Rotation) * LadderTopExitOffset.X);
        }
        LadderCurrentRung = (pos.Z - LadderBasePosition) / LadderRungDistance;
        //return;        
    }

    event bool EncroachingOn(Actor Other)
    {
        CleanUpLadder();
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state LadderTransitionAnim
{
    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        GetActorEyesViewPoint(out_CamLoc, out_CamRot);
        return true;
        //return ReturnValue;        
    }

    simulated function bool CanBreakOut()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetPhysics(9);
        Controller.GotoState('LadderLerp');
        SetTimer(PlaybackLength, false, 'LeaveState');
        //return;        
    }

    simulated function EndState(name PreviousStateName)
    {
        ClearTimer('LeaveState');
        //return;        
    }

    simulated function LeaveState()
    {
        local Rotator tRot;
        local Vector tVec;

        GetActorEyesViewPoint(tVec, tRot);
        tRot.Roll = 0;
        Controller.SetRotation(tRot);
        SetRotation(tRot);
        //return;        
    }
    stop;    
}

state EnterLadderAnimBottom extends LadderTransitionAnim
{
    simulated function BeginState(name PreviousStateName)
    {
        SetActivity(51);
        PlaybackLength = 0.1500000;
        HideWeapon(false);
        // End:0x41
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.Hide(true);
        }
        // End:0x5C
        if(FPArms != none)
        {
            FPArms.SetHidden(true);
        }
        LadderState = 1;
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function LeaveState()
    {
        super.LeaveState();
        GotoState('LadderClimb');
        //return;        
    }
    stop;    
}

state EnterLadderAnimTop extends LadderTransitionAnim
{
    simulated function BeginState(name PreviousStateName)
    {
        local Vector pos;

        pos = LadderTop;
        pos.Z -= LadderTopExitOffset.Z;
        SetLocation(pos);
        SetRotation(OnLadderMP.Rotation);
        FaceRotation(OnLadderMP.Rotation, 0.0000000);
        SetActivity(50);
        PlaybackLength = 0.5000000;
        HideWeapon(false);
        // End:0xA2
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.Hide(true);
        }
        // End:0xBD
        if(FPArms != none)
        {
            FPArms.SetHidden(true);
        }
        LadderState = 2;
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function LeaveState()
    {
        super.LeaveState();
        GotoState('LadderClimb');
        //return;        
    }
    stop;    
}

state ExitLadderTop extends LadderTransitionAnim
{
    simulated function BeginState(name PreviousStateName)
    {
        SetActivity(52);
        PlaybackLength = 0.5000000;
        SetRotation(OnLadderMP.Rotation);
        FaceRotation(OnLadderMP.Rotation, 0.0000000);
        LadderState = 5;
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function LeaveState()
    {
        super.LeaveState();
        // End:0x2E
        if(MOHAMultiplayerController(Controller) != none)
        {
            MOHAMultiplayerController(Controller).ExitLadder();
        }
        //return;        
    }
    stop;    
}

state ExitLadderBottom extends LadderTransitionAnim
{
    simulated function BeginState(name PreviousStateName)
    {
        SetActivity(53);
        PlaybackLength = 0.1500000;
        LadderState = 4;
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function LeaveState()
    {
        super.LeaveState();
        // End:0x2E
        if(MOHAMultiplayerController(Controller) != none)
        {
            MOHAMultiplayerController(Controller).ExitLadder();
        }
        //return;        
    }
    stop;    
}

state LadderClimb
{
    event bool EncroachingOn(Actor Other)
    {
        return true;
        //return ReturnValue;        
    }

    simulated function bool LadderJump()
    {
        local Vector jump_velocity;

        // End:0x12
        if(int(Role) != int(ROLE_Authority))
        {
            return false;
        }
        // End:0x3A
        if(MOHAMultiplayerController(Controller) != none)
        {
            MOHAMultiplayerController(Controller).ExitLadder();
        }
        GotoState('Idle');
        jump_velocity = Vector(Controller.Rotation);
        Velocity = jump_velocity * LadderJumpVelocity;
        PlayFootstep(6);
        return true;
        //return ReturnValue;        
    }

    simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        local Vector tLoc;
        local Rotator tRot;

        out_ViewRotation += out_DeltaRot;
        GetActorEyesViewPoint(tLoc, tRot);
        tRot.Pitch = 0;
        out_ViewRotation = MOHAPlayerController(Controller).LimitViewRotationPitchAndYaw(out_ViewRotation - tRot, -fLadderViewPitchRange, fLadderViewPitchRange, -fLadderViewYawRange, fLadderViewYawRange) + tRot;
        SetViewRotation(out_ViewRotation);
        //return;        
    }

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        GetActorEyesViewPoint(out_CamLoc, out_CamRot);
        out_CamRot = Controller.Rotation;
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local Vector tPos;
        local Rotator Rot;

        LastLadderAnimOffset = 0.0000000;
        LastLadderAnimRung = 0;
        SetActivity(54);
        SetPhysics(9);
        Controller.GotoState('PlayerClimbing');
        tPos = LadderBottom;
        tPos.Z = Location.Z;
        SetLocation(tPos);
        Rot = OnLadderMP.Rotation;
        Rot.Pitch = Controller.Rotation.Pitch;
        Controller.SetRotation(Rot);
        SetRotation(OnLadderMP.Rotation);
        LadderState = 3;
        //return;        
    }

    function LadderStateChange()
    {
        // End:0x21
        if(int(LadderState) == int(4))
        {
            GotoState('ExitLadderBottom');            
        }
        else
        {
            // End:0x42
            if(int(LadderState) == int(5))
            {
                GotoState('ExitLadderTop');                
            }
            else
            {
                // End:0x57
                if(int(LadderState) == int(3))
                {
                    return;                    
                }
                else
                {
                    // End:0x7F
                    if(MOHAMultiplayerController(Controller) != none)
                    {
                        MOHAMultiplayerController(Controller).ExitLadder();
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    m_oHealthInfo=(Health=100,LastHitBoneID=0,LastHitFromLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),LastHitLocation=0,LastDamageType=0)
    ConsoleParachuteDamageReductionScale=1.0000000
    PCParachuteDamageReductionScale=0.3500000
    NonReducedParachuteDamageDistance=1250.0000000
    FullyReducedParachuteDamageDistance=3000.0000000
    FallingDamageScalar=0.5000000
    MPMaxFallSpeed=1435.0000000
    PlayerID=-1
    PawnLifeTimeAfterDeath=10.0000000
    RespawnWaitTimeNotAirborne=5.0000000
    RespawnWaitTimeAxis=5.0000000
    RespawnWaitTimeAllied=4.5000000
    LookAtKillerTime=2.0000000
    fLadderViewYawRange=10000.0000000
    fLadderViewPitchRange=16000.0000000
    LadderRungDistance=128.0000000
    LadderTopExitOffset=(X=128.0000000,Y=0.0000000,Z=250.3800000)
    LadderLerpMoveSpeed=300.0000000
    LadderLerpTurnSpeed=3.0000000
    LadderJumpVelocity=-300.0000000
    StanceCollisionHeights[1]=65.0000000
    DefaultHealthSettings[0]=100.0000000
    DefaultHealthSettings[1]=100.0000000
    DefaultHealthSettings[2]=100.0000000
    fImmuneTimeAfterDamageSettings[0]=0.0000000
    fImmuneTimeAfterDamageSettings[1]=0.0000000
    fIronsightsMaxRoll=1000.0000000
    fIronsightsMaxLean=45.0000000
    fIronsightsLeanRestoreForce=7.0000000
    fIronsightsHeightRestoreForce=7.0000000
    fIronsightsPeekScale=0.5000000
    // Reference: AudioComponent'Default__MOHAMultiplayerPawn.ShellShockSoundComponent'
    begin object name=ShellShockSoundComponent
    end object
    ShellShockSound=ShellShockSoundComponent
    // Reference: AudioComponent'Default__MOHAMultiplayerPawn.NonRealtimeAudio'
    begin object name=NonRealtimeAudio
    end object
    NonRealtimeAudio=NonRealtimeAudio
    // Reference: MOHASkeletalMeshComponent'Default__MOHAMultiplayerPawn.FPMeshComponent0'
    begin object name=FPMeshComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAMultiplayerPawn.MyLightEnvironment'
    end object
    FPArms=FPMeshComponent0
    eLandingType=8
    // Reference: WhizComponent'Default__MOHAMultiplayerPawn.whiz'
    begin object name=whiz
    end object
    whiz=whiz
    // Reference: CylinderComponent'Default__MOHAMultiplayerPawn.LeanCollisionCylinder'
    begin object name=LeanCollisionCylinder
        BlockZeroExtent=false
    end object
    LeanCollisionComponent=LeanCollisionCylinder
    // Reference: AudioComponent'Default__MOHAMultiplayerPawn.AirdropBGSound'
    begin object name=AirdropBGSound
    end object
    Airdrop_BG_Loop=AirdropBGSound
    // Reference: AudioComponent'Default__MOHAMultiplayerPawn.AirdropWindSound'
    begin object name=AirdropWindSound
    end object
    Airdrop_WindVolumeLoop=AirdropWindSound
    AirdropLookUpDownOffset=0.0000000
    // Reference: MOHASkeletalMeshComponent'Default__MOHAMultiplayerPawn.clipMesh'
    begin object name=clipMesh
    end object
    ITPClipMesh=clipMesh
    // Reference: MOHAWeaponUpgradeManager'Default__MOHAMultiplayerPawn.UpgradeManager'
    begin object name=UpgradeManager
    end object
    WeaponUpgradeManager=UpgradeManager
    // Reference: MOHAAirdropComponent'Default__MOHAMultiplayerPawn.MyAirdropComponent'
    begin object name=MyAirdropComponent
        AirdropParachuteOpenSoundCue=SoundCue'Aud_GCm_FakeWAV.Airdrop.respawn'
    end object
    AirdropComponent=MyAirdropComponent
    bSpectatable=true
    bMeshAdj_Enabled=true
    // Reference: AxonScriptEventObserverComponent'Default__MOHAMultiplayerPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAMultiplayerPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    FootGroundPos_StepDownMax=-35.0000000
    MeshAdj_BlendWeight=1.0000000
    BoneDamageTuning[0]=(BoneName="LeftFoot",DamageModifier=0.5000000,DamageLocation=5)
    BoneDamageTuning[1]=(BoneName="LeftUpLeg",DamageModifier=0.7000000,DamageLocation=5)
    BoneDamageTuning[2]=(BoneName="RightFoot",DamageModifier=0.5000000,DamageLocation=6)
    BoneDamageTuning[3]=(BoneName="RightUpLeg",DamageModifier=0.7000000,DamageLocation=6)
    BoneDamageTuning[4]=(BoneName="Hips",DamageModifier=1.0000000,DamageLocation=4)
    BoneDamageTuning[5]=(BoneName="LeftHand",DamageModifier=1.0000000,DamageLocation=2)
    BoneDamageTuning[6]=(BoneName="LeftArm",DamageModifier=1.0000000,DamageLocation=2)
    BoneDamageTuning[7]=(BoneName="RightHand",DamageModifier=1.0000000,DamageLocation=1)
    BoneDamageTuning[8]=(BoneName="RightArm",DamageModifier=1.0000000,DamageLocation=1)
    BoneDamageTuning[9]=(BoneName="Spine",DamageModifier=1.0000000,DamageLocation=3)
    BoneDamageTuning[10]=(BoneName="Neck",DamageModifier=6.0000000,DamageLocation=0)
    MaxStepHeight=36.0000000
    MaxJumpHeight=112.0000000
    WalkableFloorZ=0.5000000
    bCanCrouch=true
    SightRadius=10000.0000000
    GroundSpeed=460.0000000
    AirSpeed=460.0000000
    BaseEyeHeight=75.0000000
    EyeHeight=75.0000000
    Health=100
    Mesh=FPMeshComponent0
    // Reference: MOHACylinderComponent'Default__MOHAMultiplayerPawn.MOHACollisionCylinder'
    begin object name=MOHACollisionCylinder class=Class'MOHACylinderComponent'
        CustomCollisionRadius=40.0000000
        CollisionHeight=96.0000000
        CollisionRadius=40.0000000
        CollideActors=true
        BlockZeroExtent=false
    end object
    CylinderComponent=MOHACollisionCylinder
    ViewPitchMin=-16000.0000000
    InventoryManagerClass=Class'MOHAMPInventoryManager'
    // Reference: ArrowComponent'Default__MOHAMultiplayerPawn.Arrow'
    begin object name=Arrow
    end object
    Components[0]=Arrow
    Components[1]=MyLightEnvironment
    Components[2]=AxonObserver0
    Components[3]=FPMeshComponent0
    Components[4]=MyAirdropComponent
    Components[5]=whiz
    Components[6]=UpgradeManager
    Components[7]=LeanCollisionCylinder
    Components[8]=AirdropBGSound
    Components[9]=ShellShockSoundComponent
    Components[10]=AirdropWindSound
    Components[11]=NonRealtimeAudio
    Components[12]=MOHACollisionCylinder
    bNetInitialRotation=true
    fRadiusDamageInterpolationExponent=1.0000000
    CollisionComponent=MOHACollisionCylinder
}