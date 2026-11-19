class R6CheatManager extends CheatManager within PlayerController
    native
    config(Game);

enum EEditOffset
{
    EDITOFFSET_None,                // 0
    EDITOFFSET_FPTransition,        // 1
    EDITOFFSET_FPRotation,          // 2
    EDITOFFSET_DebugCameraTranslation,// 3
    EDITOFFSET_LookPitchLimit,      // 4
    EDITOFFSET_LookYawLimit,        // 5
    EDITOFFSET_LookDamping,         // 6
    EDITOFFSET_LookPivot,           // 7
    EDITOFFSET_MAX                  // 8
};

struct SAISound
{
    var Actor m_pSourceActor;
    var Vector m_vSourceLocation;
    var float m_fRadius;
    var float m_fDisplayedCurrentRadius;
    var float m_fDisplayTime;
    var Actor.AIEventType m_eEventType;

    structdefaultproperties
    {
        m_pSourceActor=none
        m_vSourceLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fRadius=0.0000000
        m_fDisplayedCurrentRadius=0.0000000
        m_fDisplayTime=0.0000000
        m_eEventType=0
    }
};

var bool m_bTeamGodTeam;
var bool m_bGodAll;
var bool m_bGodHostage;
var bool m_bIsNoFellOutOfWorldRainbow;
var config bool m_bStartInGod;
var config bool m_bStartInGodTeam;
var bool m_bDebugInterpCurve;
var bool m_bDebugGamepad;
var bool m_bDebugLookAtInfo;
var bool m_bDebugOrderAtInfo;
var bool m_bShowHealthState;
var bool m_bShowArmorInfo;
var bool m_bDebugThrow;
var bool m_bAssignGadget;
var bool m_bDebugRapelling;
var bool m_bDebugWeaponInfo;
var bool m_bDebugInventoryInfo;
var bool m_bDebugAutoAim;
var bool m_bDebugAllAutoAim;
var bool m_bDebugAdhesion;
var bool m_bDebugTagging;
var bool m_bDebugDistance;
var bool m_bDebugExplosion;
var bool m_bVisualEffectsDisabled;
var bool m_bLitValues;
var bool m_bDebugRecoil;
var bool m_bLockAimRotation;
var bool m_bDisablePlayerLookAt;
var bool m_bUnlimitedAmmoToggle;
var bool m_bDebugMoveAnim;
var bool m_bDebugVehicles;
var bool m_bOcclusion;
var bool m_bHorizontalAiming;
var bool m_bCOMBalance;
var bool m_bDebugNavMeshFromPlayer;
var bool m_bDisableCloseMovementSystem;
var bool m_bTrackAISounds;
var bool m_bDrawReticleCenter;
var bool m_bMassiveDbgOutput;
var SInterpParamsPtr m_currentInterpParams;
var string m_szCurrentInterpName;
var int m_iCurrentSelectedWeapon;
var int m_iCurrentSelectedGadget;
var int m_iCurrentSelectedCharacter;
var array<string> m_asWeapons;
var array<string> m_asGadgets;
var array<string> m_asCharacters;
var float m_fShakeStrength;
var float m_fPropEditModif;
var PlayerController m_pFreeCamController;
var R6CheatManager.EEditOffset m_eEditOffsetMode;
var float m_fFPMeshTranslationModifier;
var int m_iFPMeshRotationModifier;
var float m_fCameraTranslationModifier;
var int m_iLookLimitModifier;
var float m_fLookModifier;
var int m_iPawnIdx;
var int m_iMaxPawnIdx;
var int m_iCurrentPawnCycleState;
var int m_iTeamIdx;
var int m_iMaxTeamIdx;
var Controller m_ControllerIterCamera;
var array<SAISound> m_AISounds;

// Export UR6CheatManager::execPauseMakeStep(FFrame&, void* const)
native final function PauseMakeStep();

// Export UR6CheatManager::execSetCurrentInterpCurve(FFrame&, void* const)
native final function SetCurrentInterpCurve(string szMode);

// Export UR6CheatManager::execReloadConfigFiles(FFrame&, void* const)
native final function ReloadConfigFiles();

// Export UR6CheatManager::execIncrEdProp(FFrame&, void* const)
native final function IncrEdProp();

// Export UR6CheatManager::execDecrEdProp(FFrame&, void* const)
native final function DecrEdProp();

// Export UR6CheatManager::execGetEditablePropertyName(FFrame&, void* const)
native final function string GetEditablePropertyName();

// Export UR6CheatManager::execGetEditablePropertyValue(FFrame&, void* const)
native final function float GetEditablePropertyValue();

// Export UR6CheatManager::execToggleNETTraffic(FFrame&, void* const)
native exec function ToggleNETTraffic();

// Export UR6CheatManager::execLogTeamMembersInformation(FFrame&, void* const)
native final function LogTeamMembersInformation();

// Export UR6CheatManager::execAddExperience(FFrame&, void* const)
native exec function AddExperience(int iExperience, optional int iControllerId);

// Export UR6CheatManager::execNativeCheatCycleAttachment(FFrame&, void* const)
native function NativeCheatCycleAttachment(Pawn pPawn);

exec function DebugRainbow()
{
    local R6RainbowManager R6Rainbow;

    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.m_bDebugGfxSenseAmbush = !R6Rainbow.m_bDebugGfxSenseAmbush;
    return;
}

exec function EnableAIThread()
{
    R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.m_bMTRequest = !R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.m_bMTRequest;
    // End:0xD5
    if(R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.m_bMTRequest)
    {
        Outer.ClientMessage("AI Thread is on.");        
    }
    else
    {
        Outer.ClientMessage("AI Thread is off.");
    }
    return;
}

exec function EnableRainbow()
{
    local R6RainbowManager R6Rainbow;

    KillAll(Class'R6RainbowPawn');
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.m_bTeamSpawned = false;
    R6Rainbow.SpawnRainbowAroundPlayer();
    return;
}

exec function RainbowStack()
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: Stack");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(33, 9);
    return;
}

exec function RainbowRegroup()
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: Regroup");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(1, 9);
    return;
}

exec function RainbowMoveTo()
{
    local R6RainbowManager R6Rainbow;
    local R6PlayerController r6PC;

    LogInternal("Rainbow Team: MoveTo");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    r6PC = R6PlayerController(R6Rainbow.m_pawnTeamLeader.Controller);
    R6Rainbow.SendTeamCommunicateMessage(2, 11, r6PC.m_LookAtInfo.m_vCollision);
    return;
}

exec function RainbowHold()
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: Hold");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(3, 10);
    return;
}

exec function RainbowFormation()
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: Formation");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(16, 9);
    return;
}

exec function RainbowOpenDoor()
{
    local R6RainbowManager R6Rainbow;
    local R6PlayerController r6PC;
    local Actor actorLookAt;

    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    r6PC = R6PlayerController(R6Rainbow.m_pawnTeamLeader.Controller);
    actorLookAt = r6PC.m_LookAtInfo.m_ActorCollision;
    LogInternal("Rainbow Team: OpenDoor");
    R6Rainbow.SendTeamCommunicateMessage(7, 16,, actorLookAt);
    return;
}

exec function RainbowBreachDoor()
{
    local R6RainbowManager R6Rainbow;
    local R6PlayerController r6PC;
    local Actor actorLookAt;

    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    r6PC = R6PlayerController(R6Rainbow.m_pawnTeamLeader.Controller);
    actorLookAt = r6PC.m_LookAtInfo.m_ActorCollision;
    LogInternal("Rainbow Team: BreachDoor");
    R6Rainbow.SendTeamCommunicateMessage(18, 16,, actorLookAt);
    return;
}

exec function RainbowClear()
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: Clear");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(11, 19);
    return;
}

exec function RainbowFragClear()
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: Frag Clear");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(13, 16);
    return;
}

exec function RainbowFragDoor()
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: Frag Door");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(19, 16);
    return;
}

exec function RainbowDetonateCharge()
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: DetonateCharge");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(25, 16);
    return;
}

exec function RainbowScopeDoor()
{
    local R6RainbowManager R6Rainbow;
    local R6PlayerController r6PC;
    local Actor actorLookAt;

    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    r6PC = R6PlayerController(R6Rainbow.m_pawnTeamLeader.Controller);
    actorLookAt = r6PC.m_LookAtInfo.m_ActorCollision;
    LogInternal("Rainbow Team: ScopeDoor");
    R6Rainbow.SendTeamCommunicateMessage(26, 16,, actorLookAt);
    return;
}

exec function RainbowStopScope()
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: StopScope");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(27, 16);
    return;
}

exec function RainbowAdjustScope(int iAmount)
{
    local R6RainbowManager R6Rainbow;

    LogInternal("Rainbow Team: AdjustScope");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.SendTeamCommunicateMessage(28, 16,,, iAmount);
    return;
}

exec function HostageFollow()
{
    local R6HostageManager R6Hostage;
    local R6RainbowManager R6Rainbow;
    local R6PlayerController r6PC;
    local Actor actorLookAt;

    LogInternal("Rainbow Team: FollowMe");
    R6Hostage = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pHostageManager;
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    r6PC = R6PlayerController(R6Rainbow.m_pawnTeamLeader.Controller);
    actorLookAt = r6PC.m_LookAtInfo.m_ActorCollision;
    // End:0xED
    if(actorLookAt.IsA('R6RainbowPawn'))
    {
        R6Hostage.SendTeamCommunicateMessage(4, 9,, actorLookAt);
    }
    return;
}

exec function WhereIsThis()
{
    local R6RainbowManager R6Rainbow;
    local R6PlayerController r6PC;

    LogInternal("The Player is looking at co-ordinates:");
    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    r6PC = R6PlayerController(R6Rainbow.m_pawnTeamLeader.Controller);
    LogInternal(string(r6PC.m_LookAtInfo.m_vCollision));
    return;
}

exec function IgniteTarget()
{
    local Vector HitLocation, HitNormal, StartTrace, EndTrace;
    local Actor other;
    local TraceHitInfo HitInfo;

    R6PlayerController(Outer.Pawn.Controller).CalculateFireDirectionWithReticle(StartTrace, EndTrace, false);
    EndTrace = StartTrace + (EndTrace * 10000.0000000);
    other = Outer.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo);
    // End:0xAE
    if(other != none)
    {
        Outer.WorldInfo.StartNewFire(HitLocation);
    }
    return;
}

exec function TeamPawnDebug()
{
    local R6TeamManager aTeam;
    local int iTeamMemberIdx;
    local R6Pawn aPawn;
    local bool bDone;
    local int iCurrentIdx;

    // End:0x50
    if(m_iMaxTeamIdx == 0)
    {
        m_iMaxTeamIdx = 0;
        m_iTeamIdx = 0;
        // End:0x3A
        foreach Outer.DynamicActors(Class'R6TeamManager', aTeam)
        {
            m_iMaxTeamIdx++;            
        }        
        // End:0x4D
        if(m_iMaxTeamIdx > 0)
        {
            TeamPawnDebug();
        }        
    }
    else
    {
        bDone = false;
        iCurrentIdx = 0;
        // End:0x7F
        if(m_iTeamIdx > m_iMaxTeamIdx)
        {
            m_iTeamIdx = 0;
            TeamPawnDebug();            
        }
        else
        {
            // End:0x19A
            foreach Outer.DynamicActors(Class'R6TeamManager', aTeam)
            {
                // End:0x13D
                if(!bDone && iCurrentIdx == m_iTeamIdx)
                {
                    LogInternal("Displaying Team: " $ string(aTeam.Name));
                    bDone = true;
                    iTeamMemberIdx = 0;
                    J0xEC:

                    // End:0x13A [Loop If]
                    if(iTeamMemberIdx < aTeam.m_aTeamMember.Length)
                    {
                        aPawn = aTeam.m_aTeamMember[iTeamMemberIdx];
                        aPawn.bRenderDebug = true;
                        iTeamMemberIdx++;
                        // [Loop Continue]
                        goto J0xEC;
                    }                    
                }
                else
                {
                    iTeamMemberIdx = 0;
                    J0x144:

                    // End:0x192 [Loop If]
                    if(iTeamMemberIdx < aTeam.m_aTeamMember.Length)
                    {
                        aPawn = aTeam.m_aTeamMember[iTeamMemberIdx];
                        aPawn.bRenderDebug = false;
                        iTeamMemberIdx++;
                        // [Loop Continue]
                        goto J0x144;
                    }
                }
                iCurrentIdx++;                
            }            
            m_iTeamIdx++;
        }
    }
    return;
}

exec function RBDebug()
{
    local R6Pawn aPawn;
    local R6RainbowPawn aRBPawn;

    Outer.ConsoleCommand("show Debug");
    // End:0x8C
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aRBPawn = R6RainbowPawn(aPawn);
        // End:0x7A
        if(aRBPawn != none)
        {
            aPawn.bRenderDebug = !aPawn.bRenderDebug;
            // End:0x8B
            continue;
        }
        aPawn.bRenderDebug = false;        
    }    
    return;
}

exec function ShowClosestDebug()
{
    local Pawn closest;
    local R6Pawn aPawn;

    closest = ClosestReticulePawn();
    // End:0x38
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.bRenderDebug = false;        
    }    
    aPawn = R6Pawn(closest);
    // End:0x75
    if(aPawn != none)
    {
        aPawn.bRenderDebug = !aPawn.bRenderDebug;
    }
    return;
}

exec function LDDebug()
{
    local R6Pawn aPawn;

    Outer.ConsoleCommand("show Debug");
    // End:0x5D
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bLDDebug = !aPawn.m_bLDDebug;        
    }    
    return;
}

exec function PawnDebug()
{
    local R6Pawn aPawn;
    local int iCurrentIdx, iCurrentMax;
    local bool bUpdateCount;

    bUpdateCount = true;
    iCurrentMax = 0;
    // End:0x59
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        // End:0x58
        if(!aPawn.IsHumanControlled() && aPawn.IsAlive())
        {
            iCurrentMax++;
        }        
    }    
    // End:0xB9
    if(m_iCurrentPawnCycleState == 0)
    {
        LogInternal("Show All Pawn Debug");        
        Outer.ConsoleCommand("show Debug");
        m_iCurrentPawnCycleState = 1;
        m_iPawnIdx = 0;
        bUpdateCount = false;        
    }
    else
    {
        // End:0xED
        if(m_iCurrentPawnCycleState == 1)
        {
            LogInternal("Cycle Pawn Debug");
            m_iCurrentPawnCycleState = 2;
            bUpdateCount = true;            
        }
        else
        {
            // End:0x159
            if(m_iCurrentPawnCycleState == 2)
            {
                // End:0x159
                if(m_iPawnIdx >= iCurrentMax)
                {
                    LogInternal("Hide All Pawn Debug");                    
                    Outer.ConsoleCommand("show Debug");
                    m_iCurrentPawnCycleState = 0;
                    m_iPawnIdx = 0;
                    bUpdateCount = false;
                }
            }
        }
    }
    iCurrentIdx = 0;
    // End:0x210
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        // End:0x20F
        if(!aPawn.IsHumanControlled() && aPawn.IsAlive())
        {
            // End:0x1C1
            if(m_iCurrentPawnCycleState == 0)
            {
                aPawn.bRenderDebug = false;                
            }
            else
            {
                // End:0x1E0
                if(m_iCurrentPawnCycleState == 1)
                {
                    aPawn.bRenderDebug = true;                    
                }
                else
                {
                    // End:0x208
                    if(m_iCurrentPawnCycleState == 2)
                    {
                        aPawn.bRenderDebug = iCurrentIdx == m_iPawnIdx;
                    }
                }
            }
            iCurrentIdx++;
        }        
    }    
    // End:0x24D
    if(bUpdateCount)
    {
        LogInternal((("Cycle Debug: " $ string(m_iPawnIdx)) $ " / ") $ string(iCurrentMax));
        m_iPawnIdx++;
    }
    return;
}

exec function DebugCoverSeg()
{
    local R6TeamManager aTeamManager;

    aTeamManager = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    aTeamManager.m_bRenderDebug = !aTeamManager.m_bRenderDebug;
    return;
}

exec function DebugFocus()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderFocus = !aPawn.m_bRenderFocus;        
    }    
    return;
}

exec function DebugFOV()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderFOV = !aPawn.m_bRenderFOV;        
    }    
    return;
}

exec function DebugGunFOV()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderGunFOV = !aPawn.m_bRenderGunFOV;        
    }    
    return;
}

exec function DebugGrenade()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderGrenade = !aPawn.m_bRenderGrenade;        
    }    
    return;
}

exec function DebugRotation()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderRotation = !aPawn.m_bRenderRotation;        
    }    
    return;
}

exec function DebugNeutralPerception()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderNeutralPerception = !aPawn.m_bRenderNeutralPerception;        
    }    
    return;
}

exec function DebugDialogs()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderDialogs = !aPawn.m_bRenderDialogs;        
    }    
    return;
}

exec function DebugBullet()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderBulletTrace = !aPawn.m_bRenderBulletTrace;        
    }    
    return;
}

exec function CivilPawnDebug()
{
    local R6CivilPawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6CivilPawn', aPawn)
    {
        aPawn.m_bCivilDebug = !aPawn.m_bCivilDebug;        
    }    
    return;
}

exec function HideSelf()
{
    Outer.Pawn.bHidden = !Outer.Pawn.bHidden;
    return;
}

exec function DebugDoor()
{
    local R6InteractiveDoorRotating aDoor;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6InteractiveDoorRotating', aDoor)
    {
        aDoor.m_bRenderDebug = !aDoor.m_bRenderDebug;        
    }    
    return;
}

exec function DebugTakeCoverTransition()
{
    // End:0x63
    if(Outer.Pawn != none)
    {
        R6Pawn(Outer.Pawn).m_CoverManager.m_bDebugTakeCoverTransition = !R6Pawn(Outer.Pawn).m_CoverManager.m_bDebugTakeCoverTransition;
    }
    return;
}

exec function DebugPawnTakeCoverTransition()
{
    TogglePawnTakeCover(false, true, false);
    return;
}

exec function DebugTakeCoverLimits()
{
    // End:0x63
    if(Outer.Pawn != none)
    {
        R6Pawn(Outer.Pawn).m_CoverManager.m_bDebugTakeCoverLimits = !R6Pawn(Outer.Pawn).m_CoverManager.m_bDebugTakeCoverLimits;
    }
    return;
}

exec function DebugPawnTakeCoverLimits()
{
    TogglePawnTakeCover(false, false, true);
    return;
}

exec function DebugTakeCover()
{
    // End:0x63
    if(Outer.Pawn != none)
    {
        R6Pawn(Outer.Pawn).m_CoverManager.m_bDebugTakeCover = !R6Pawn(Outer.Pawn).m_CoverManager.m_bDebugTakeCover;
    }
    return;
}

exec function DebugPawnTakeCover()
{
    TogglePawnTakeCover(true, false, false);
    return;
}

function TogglePawnTakeCover(bool bStatus, bool bTransition, bool bLimits)
{
    local R6Pawn CurrentPawn, ClosestPawn, PlayerPawn;
    local float ThisDistance, ClosestPawnDistance;

    PlayerPawn = R6Pawn(Outer.Pawn);
    ClosestPawn = none;
    ClosestPawnDistance = 10000000.0000000;
    // End:0xA1
    foreach Outer.DynamicActors(Class'R6Pawn', CurrentPawn)
    {
        ThisDistance = VSize(CurrentPawn.Location - PlayerPawn.Location);
        // End:0xA0
        if((ThisDistance < ClosestPawnDistance) && CurrentPawn != PlayerPawn)
        {
            ClosestPawn = CurrentPawn;
            ClosestPawnDistance = ThisDistance;
        }        
    }    
    // End:0x161
    if(ClosestPawn != none)
    {
        // End:0xE9
        if(bStatus)
        {
            ClosestPawn.m_CoverManager.m_bDebugTakeCover = !ClosestPawn.m_CoverManager.m_bDebugTakeCover;
        }
        // End:0x125
        if(bTransition)
        {
            ClosestPawn.m_CoverManager.m_bDebugTakeCoverTransition = !ClosestPawn.m_CoverManager.m_bDebugTakeCoverTransition;
        }
        // End:0x161
        if(bLimits)
        {
            ClosestPawn.m_CoverManager.m_bDebugTakeCoverLimits = !ClosestPawn.m_CoverManager.m_bDebugTakeCoverLimits;
        }
    }
    return;
}

exec function DebugWeaponInfo()
{
    m_bDebugWeaponInfo = !m_bDebugWeaponInfo;
    return;
}

exec function DebugRapelling()
{
    m_bDebugRapelling = !m_bDebugRapelling;
    return;
}

exec function DebugInvInfo()
{
    m_bDebugInventoryInfo = !m_bDebugInventoryInfo;
    return;
}

exec function DebugAutoAim()
{
    m_bDebugAutoAim = !m_bDebugAutoAim;
    return;
}

exec function DebugAllAutoAim()
{
    local Controller Ctrl;
    local R6PlayerController r6PC;

    m_bDebugAllAutoAim = !m_bDebugAllAutoAim;
    // End:0x85
    foreach Outer.WorldInfo.AllControllers(Class'Engine.Controller', Ctrl)
    {
        r6PC = R6PlayerController(Ctrl);
        // End:0x84
        if((r6PC != none) && r6PC.m_R6CheatManager != none)
        {
            r6PC.m_R6CheatManager.m_bDebugAutoAim = m_bDebugAllAutoAim;
        }        
    }    
    return;
}

exec function DebugAdhesion()
{
    m_bDebugAdhesion = !m_bDebugAdhesion;
    return;
}

exec function DebugTagging()
{
    m_bDebugTagging = !m_bDebugTagging;
    return;
}

exec function DebugDistance()
{
    m_bDebugDistance = !m_bDebugDistance;
    return;
}

exec function DebugNavMeshFromPlayer()
{
    m_bDebugNavMeshFromPlayer = !m_bDebugNavMeshFromPlayer;
    return;
}

exec function DebugExplosion()
{
    m_bDebugExplosion = !m_bDebugExplosion;
    return;
}

exec function DebugInterpCurve(string szMode)
{
    SetCurrentInterpCurve(szMode);
    return;
}

exec function DebugGamepad()
{
    m_bDebugGamepad = !m_bDebugGamepad;
    LogInternal("DebugGamepad() set at" @ string(m_bDebugGamepad));
    return;
}

exec function UseGamePad()
{
    Outer.GetGameManager().m_bUseGamePad = !Outer.GetGameManager().m_bUseGamePad;
    // End:0x75
    if(Outer.GetGameManager().IsUsingGamePad())
    {
        LogInternal("INPUTS : Now using gamepad");        
    }
    else
    {
        LogInternal("INPUTS : Now using mouse and keyboard");
    }
    return;
}

exec function ToggleSplitView()
{
    Outer.GetGameManager().m_SplitscreenMgr.m_bSplitscreenVertical = !Outer.GetGameManager().m_SplitscreenMgr.m_bSplitscreenVertical;
    return;
}

exec function DebugLookAtInfo()
{
    m_bDebugLookAtInfo = !m_bDebugLookAtInfo;
    LogInternal("DebugLookAtInfo set at" @ string(m_bDebugLookAtInfo));
    return;
}

exec function DebugOrderAtInfo()
{
    m_bDebugOrderAtInfo = !m_bDebugOrderAtInfo;
    LogInternal("DebugOrderAtInfo set at" @ string(m_bDebugOrderAtInfo));
    return;
}

exec function EmptyAmmo()
{
    // End:0x4A
    if(R6Pawn(Outer.Pawn).m_R6Weapon != none)
    {
        R6Pawn(Outer.Pawn).m_R6Weapon.SetAmmunition(0);
    }
    return;
}

exec event FullAmmo()
{
    Outer.ServerFullAmmoCheat();
    return;
}

exec function UnlimitedAmmo()
{
    local R6InventoryManager invMng;
    local R6Weapon Weapon;
    local int I;

    // End:0x3A
    if((int(Outer.WorldInfo.NetMode) != int(NM_Standalone)) || Outer.Pawn == none)
    {
        return;
    }
    m_bUnlimitedAmmoToggle = !m_bUnlimitedAmmoToggle;
    invMng = R6InventoryManager(Outer.Pawn.InvManager);
    // End:0xF3
    if(invMng != none)
    {
        I = 0;
        J0x7D:

        // End:0xF3 [Loop If]
        if(I < invMng.m_inventorySlots.Length)
        {
            Weapon = R6Weapon(invMng.m_inventorySlots[I].m_item);
            // End:0xE9
            if(Weapon != none)
            {
                Weapon.GetConfigVals().m_bUnlimitedAmmo = m_bUnlimitedAmmoToggle;
            }
            I++;
            // [Loop Continue]
            goto J0x7D;
        }
    }
    LogInternal("UnlimitedAmmo set at" @ string(m_bUnlimitedAmmoToggle));
    return;
}

exec function FAmmo()
{
    FullAmmo();
    return;
}

exec function UAmmo()
{
    UnlimitedAmmo();
    return;
}

exec event NoReload()
{
    local R6InventoryManager invMng;
    local R6Weapon Weapon;
    local int I;

    // End:0x3A
    if((int(Outer.WorldInfo.NetMode) != int(NM_Standalone)) || Outer.Pawn == none)
    {
        return;
    }
    invMng = R6InventoryManager(Outer.Pawn.InvManager);
    // End:0xD8
    if(invMng != none)
    {
        I = 0;
        J0x6E:

        // End:0xD8 [Loop If]
        if(I < invMng.m_inventorySlots.Length)
        {
            Weapon = R6Weapon(invMng.m_inventorySlots[I].m_item);
            // End:0xCE
            if(Weapon != none)
            {
                Weapon.m_iNbAmmoInWeapon = 9999999;
            }
            I++;
            // [Loop Continue]
            goto J0x6E;
        }
    }
    LogInternal("No reload cheat activated");
    return;
}

exec function CheatCycleWeaponUp()
{
    local R6Pawn pR6Pawn;

    pR6Pawn = R6Pawn(Outer.Pawn);
    // End:0x3D
    if((pR6Pawn != none) && !pR6Pawn.CanSwitchWeapon())
    {
        return;
    }
    m_iCurrentSelectedWeapon++;
    // End:0x5B
    if(m_iCurrentSelectedWeapon >= m_asWeapons.Length)
    {
        m_iCurrentSelectedWeapon = 0;
    }
    CheatSetWeapon();
    return;
}

exec function CheatCycleWeaponDown()
{
    local R6Pawn pR6Pawn;

    pR6Pawn = R6Pawn(Outer.Pawn);
    // End:0x3D
    if((pR6Pawn != none) && !pR6Pawn.CanSwitchWeapon())
    {
        return;
    }
    m_iCurrentSelectedWeapon--;
    // End:0x5E
    if(m_iCurrentSelectedWeapon < 0)
    {
        m_iCurrentSelectedWeapon = m_asWeapons.Length - 1;
    }
    CheatSetWeapon();
    return;
}

exec function CheatCycleCharacterUp()
{
    m_iCurrentSelectedCharacter++;
    // End:0x1E
    if(m_iCurrentSelectedCharacter >= m_asCharacters.Length)
    {
        m_iCurrentSelectedCharacter = 0;
    }
    CheatSetCharacter();
    return;
}

exec function CheatCycleCharacterDown()
{
    m_iCurrentSelectedCharacter--;
    // End:0x21
    if(m_iCurrentSelectedCharacter < 0)
    {
        m_iCurrentSelectedCharacter = m_asCharacters.Length - 1;
    }
    CheatSetCharacter();
    return;
}

exec function CheatCycleGadgetUp()
{
    m_iCurrentSelectedGadget++;
    // End:0x22
    if(m_iCurrentSelectedGadget >= m_asGadgets.Length)
    {
        m_iCurrentSelectedGadget = -1;
    }
    CheatSetGadget();
    return;
}

exec function CheatCycleGadgetDown()
{
    m_iCurrentSelectedGadget--;
    // End:0x25
    if(m_iCurrentSelectedGadget < -1)
    {
        m_iCurrentSelectedGadget = m_asGadgets.Length - 1;
    }
    CheatSetGadget();
    return;
}

exec function CheatSetGadget()
{
    local R6InventoryManager IM;
    local class<R6Gadget> GadgetClass;
    local int iSlot;
    local R6Gadget OldGadget;

    // End:0x1B5
    if((m_iCurrentSelectedGadget != -1) && R6Pawn(Outer.Pawn).m_pUsedGadget == none)
    {
        IM = R6InventoryManager(Outer.Pawn.InvManager);
        GadgetClass = class<R6Gadget>(DynamicLoadObject(m_asGadgets[m_iCurrentSelectedGadget], Class'Core.Class'));
        iSlot = IM.m_iGadgetIndex;
        // End:0x173
        if(IM.m_inventorySlots[iSlot].CanContain(GadgetClass))
        {
            OldGadget = R6Gadget(IM.m_inventorySlots[iSlot].m_item);
            IM.RemoveFromInventory(OldGadget);
            OldGadget.Destroy();
            // End:0x147
            if(IM.CreateInventoryInSlot(GadgetClass, iSlot) != none)
            {
                IM.m_inventorySlots[iSlot].m_item.SetCount(9999);
            }
            R6PlayerController(Outer.Pawn.Controller).GadgetSelect(1);            
        }
        else
        {
            LogInternal((("Item " $ m_asGadgets[m_iCurrentSelectedGadget]) $ " cannot be contained on slot ") $ string(iSlot));
        }
    }
    return;
}

exec function CheatSetWeapon()
{
    local int iSlot;
    local R6InventoryManager IM;
    local class<Weapon> weapClass;
    local R6Weapon OldWeapon;

    // End:0x1FC
    if(m_iCurrentSelectedWeapon != -1)
    {
        IM = R6InventoryManager(Outer.Pawn.InvManager);
        iSlot = IM.m_iActiveWeapon;
        weapClass = class<Weapon>(DynamicLoadObject(m_asWeapons[m_iCurrentSelectedWeapon], Class'Core.Class'));
        LogInternal((((("###CheatSetWeapon Pawn:" @ string(Outer.Pawn)) @ "Weapon:") @ string(weapClass)) @ "Slot:") @ string(iSlot),, 64);
        // End:0x1BA
        if(IM.m_inventorySlots[iSlot].CanContain(weapClass))
        {
            OldWeapon = R6Pawn(Outer.Pawn).m_R6Weapon;
            IM.RemoveFromInventory(OldWeapon);
            // End:0x1B7
            if(IM.CreateInventoryInSlot(weapClass, iSlot) != none)
            {
                IM.m_inventorySlots[iSlot].m_item.SetCount(9999);
                IM.SetCurrentWeaponIndex(iSlot, false, true);
                R6Weapon(IM.m_inventorySlots[iSlot].m_item).ResetAnim();
                OldWeapon.Destroy();
            }            
        }
        else
        {
            LogInternal((("Item " $ m_asWeapons[m_iCurrentSelectedWeapon]) $ " cannot be contained on slot ") $ string(iSlot));
        }
    }
    return;
}

exec function CheatSetCharacter()
{
    local R6PlayerController pPC;
    local class<R6Character> CharClass;

    pPC = R6PlayerController(Outer.Pawn.Controller);
    // End:0x6F
    if(pPC != none)
    {
        CharClass = class<R6Character>(DynamicLoadObject(m_asCharacters[m_iCurrentSelectedCharacter], Class'Core.Class'));
        // End:0x6F
        if(CharClass != none)
        {
            pPC.PossessNewPawnClass(CharClass);
        }
    }
    return;
}

exec function CheatCycleAttachment()
{
    NativeCheatCycleAttachment(Outer.Pawn);
    return;
}

exec function MakeStep()
{
    // End:0x39
    if(Outer.GetGameManager().IsPaused())
    {
        Outer.GetGameManager().CheatStep(true);
    }
    return;
}

exec function CheatPause()
{
    Outer.GetGameManager().CheatPauseGame();
    return;
}

exec function PauseSB()
{
    Outer.GetGameManager().PauseSB();
    return;
}

exec function StepSB()
{
    Outer.GetGameManager().StepSB();
    return;
}

exec function DrawDebug()
{
    Outer.m_bDrawDebug = !Outer.m_bDrawDebug;
    return;
}

exec event Stealth()
{
    Outer.Pawn.m_bStealth = !Outer.Pawn.m_bStealth;
    return;
}

exec function Gwi()
{
    Stealth();
    Outer.GetMiscConfig().m_fInteractDistance = 10000.0000000;
    DebugWeaponInfo();
    Occlusion(false);
    return;
}

exec event GodTeam()
{
    local R6RainbowPawn CurrentPawn;

    m_bTeamGodTeam = !m_bTeamGodTeam;
    // End:0x4D
    if(m_bTeamGodTeam)
    {
        Outer.ClientMessage("Rainbow AI Team is on God Mode");        
    }
    else
    {
        Outer.ClientMessage("Rainbow AI Team is off God Mode");
    }
    // End:0xED
    foreach Outer.DynamicActors(Class'R6RainbowPawn', CurrentPawn)
    {
        // End:0xEC
        if((CurrentPawn.Controller != none) && CurrentPawn.Controller.bIsPlayer == false)
        {
            CurrentPawn.Controller.bGodMode = m_bTeamGodTeam;
        }        
    }    
    return;
}

exec function GodAll()
{
    local R6Pawn CurrentPawn;

    m_bGodAll = !m_bGodAll;
    // End:0x48
    if(m_bGodAll)
    {
        Outer.ClientMessage("All pawns are on God Mode");        
    }
    else
    {
        Outer.ClientMessage("All pawns are off God Mode");
    }
    // End:0xC3
    foreach Outer.DynamicActors(Class'R6Pawn', CurrentPawn)
    {
        // End:0xC2
        if(CurrentPawn.Controller != none)
        {
            CurrentPawn.Controller.bGodMode = m_bGodAll;
        }        
    }    
    return;
}

exec function GodHostage()
{
    local R6HostagePawn CurrentPawn;

    m_bGodHostage = !m_bGodHostage;
    // End:0x4B
    if(m_bGodHostage)
    {
        Outer.ClientMessage("All hostages are on God Mode");        
    }
    else
    {
        Outer.ClientMessage("All hostages are off God Mode");
    }
    // End:0xC9
    foreach Outer.DynamicActors(Class'R6HostagePawn', CurrentPawn)
    {
        // End:0xC8
        if(CurrentPawn.Controller != none)
        {
            CurrentPawn.Controller.bGodMode = m_bGodHostage;
        }        
    }    
    return;
}

exec function GodAllPlayers(bool bGod)
{
    local PlayerController PC;
    local bool bChange;

    // End:0x8C
    foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        bChange = (bGod && !PC.bGodMode) || !bGod && PC.bGodMode;
        // End:0x8B
        if(bChange)
        {
            PC.CheatManager.God();
        }        
    }    
    return;
}

exec event NoFellOutOfWorld()
{
    local R6RainbowPawn CurrentPawn;

    m_bIsNoFellOutOfWorldRainbow = !m_bIsNoFellOutOfWorldRainbow;
    // End:0x55
    if(m_bIsNoFellOutOfWorldRainbow)
    {
        Outer.ClientMessage("Rainbow AI Team is on NoFellOutOfWorld");        
    }
    else
    {
        Outer.ClientMessage("Rainbow AI Team is off NoFellOutOfWorld");
    }
    // End:0xFD
    foreach Outer.DynamicActors(Class'R6RainbowPawn', CurrentPawn)
    {
        // End:0xFC
        if((CurrentPawn.Controller != none) && CurrentPawn.Controller.bIsPlayer == false)
        {
            CurrentPawn.Controller.m_bIsNoFellOutOfWorld = m_bIsNoFellOutOfWorldRainbow;
        }        
    }    
    return;
}

exec function ToggleObjectivesDisplay()
{
    R6GameInfo(Outer.WorldInfo.Game).m_ObjectiveManager.m_bDrawDebug = !R6GameInfo(Outer.WorldInfo.Game).m_ObjectiveManager.m_bDrawDebug;
    return;
}

exec function DrawShot()
{
    local R6Weapon aWeapon;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Weapon', aWeapon)
    {
        aWeapon.m_bDrawShot = !aWeapon.m_bDrawShot;        
    }    
    return;
}

exec function ReloadConfig()
{
    ReloadConfigFiles();
    return;
}

function Pawn ClosestReticulePawn()
{
    local int I;
    local float fBestDist;
    local Pawn aPawn;
    local float fCurrentDist;

    I = 0;
    J0x07:

    // End:0x120 [Loop If]
    if(I < Outer.GetGameManager().m_VisiblePawns.Length)
    {
        // End:0x116
        if((Outer.GetGameManager().m_VisiblePawns[I] != none) && Outer.GetGameManager().m_VisiblePawns[I] != Outer.Pawn)
        {
            fCurrentDist = VSize(Outer.GetGameManager().m_VisiblePawns[I].Location - Outer.Pawn.Location);
            // End:0x116
            if((fBestDist == float(0)) || fCurrentDist < fBestDist)
            {
                aPawn = Outer.GetGameManager().m_VisiblePawns[I];
                fBestDist = fCurrentDist;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return aPawn;
    return;
}

exec function KillAllButOne(name PawnName)
{
    local Pawn closest;
    local R6Pawn aPawn;

    // End:0xAA
    if(Len(string(PawnName)) != 0)
    {
        // End:0xA6
        foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
        {
            // End:0xA5
            if(aPawn.Name != PawnName)
            {
                aPawn.TakeDamage(aPawn.Health, aPawn.Health, aPawn.Controller, aPawn.Location, aPawn.Location, vect(0.0000000, 0.0000000, 1.0000000), none);
            }            
        }                
    }
    else
    {
        closest = ClosestReticulePawn();
        // End:0x15F
        foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
        {
            // End:0x15E
            if((aPawn != Outer.Pawn) && aPawn != closest)
            {
                aPawn.TakeDamage(aPawn.Health, aPawn.Health, aPawn.Controller, aPawn.Location, aPawn.Location, vect(0.0000000, 0.0000000, 1.0000000), none);
            }            
        }        
    }
    return;
}

exec function HurtTeam()
{
    local R6Pawn aPawn;

    // End:0x9B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        // End:0x9A
        if(aPawn != Outer.Pawn)
        {
            aPawn.TakeDamage(aPawn.Health / 2, aPawn.Health, aPawn.Controller, aPawn.Location, aPawn.Location, vect(0.0000000, 0.0000000, 1.0000000), none);
        }        
    }    
    return;
}

exec function KillPawns()
{
    CleanPawn();
    return;
}

exec function CleanPawn()
{
    local R6Pawn aPawn;
    local R6SpawnPoint aSP;
    local R6Wave aWave;

    // End:0x97
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        // End:0x96
        if(aPawn != Outer.Pawn)
        {
            aPawn.TakeDamage(aPawn.Health, aPawn.Health, aPawn.Controller, aPawn.Location, aPawn.Location, vect(0.0000000, 0.0000000, 1.0000000), none);
        }        
    }    
    // End:0xC3
    foreach Outer.DynamicActors(Class'R6Wave', aWave)
    {
        aWave.m_bUsed = true;        
    }    
    // End:0xFD
    foreach Outer.DynamicActors(Class'R6SpawnPoint', aSP)
    {
        aSP.m_bToSpawn = aSP.m_bStartAtLaunch;        
    }    
    return;
}

exec function KillAllRainbow()
{
    local R6Pawn CurrentPawn;
    local R6RainbowManager R6Rainbow;
    local int I;

    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    I = 0;
    J0x3B:

    // End:0xF1 [Loop If]
    if(I < R6Rainbow.m_aTeamMember.Length)
    {
        CurrentPawn = R6Rainbow.m_aTeamMember[I];
        // End:0xE7
        if(CurrentPawn.m_pAI != none)
        {
            CurrentPawn.TakeDamage(CurrentPawn.Health, CurrentPawn.Health, CurrentPawn.Controller, CurrentPawn.Location, CurrentPawn.Location, vect(0.0000000, 0.0000000, 1.0000000), none);
        }
        I++;
        // [Loop Continue]
        goto J0x3B;
    }
    return;
}

exec function KillAllTerros()
{
    local R6Pawn aPawn;

    // End:0xE6
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        // End:0xE5
        if(aPawn != Outer.Pawn)
        {
            // End:0xE5
            if(((int(aPawn.m_eAlliance) != int(1)) && int(aPawn.m_eAlliance) != int(2)) && int(aPawn.m_eAlliance) != int(3))
            {
                aPawn.TakeDamage(aPawn.Health, aPawn.Health, aPawn.Controller, aPawn.Location, aPawn.Location, vect(0.0000000, 0.0000000, 1.0000000), none);
            }
        }        
    }    
    return;
}

exec function ZombifyTerros()
{
    local R6TerroManager pTerroMgr;

    // End:0x2C
    foreach Outer.DynamicActors(Class'R6TerroManager', pTerroMgr)
    {
        pTerroMgr.SetTacticEntireTeam(1, false);        
    }    
    return;
}

exec function UnzombifyTerros()
{
    local R6TerroManager pTerroMgr;

    // End:0x2C
    foreach Outer.DynamicActors(Class'R6TerroManager', pTerroMgr)
    {
        pTerroMgr.SetTacticEntireTeam(5, false);        
    }    
    return;
}

exec function FreeCivilians()
{
    local R6CivilManager pCivilMgr;

    // End:0x2E
    foreach Outer.DynamicActors(Class'R6CivilManager', pCivilMgr)
    {
        pCivilMgr.FreeCiviliansInZone(-1);        
    }    
    return;
}

exec function FreeHostages()
{
    local R6HostageManager pHostageMgr;

    // End:0x2E
    foreach Outer.DynamicActors(Class'R6HostageManager', pHostageMgr)
    {
        pHostageMgr.FreeHostagesInZone(-1);        
    }    
    return;
}

exec function SelectOne(name PawnName)
{
    local R6Pawn aPawn;
    local Pawn closest;

    // End:0xB6
    if(Len(string(PawnName)) != 0)
    {
        // End:0xB2
        foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
        {
            // End:0x7A
            if(aPawn.Name != PawnName)
            {
                aPawn.bRenderDebug = false;
                // End:0x77
                if(R6CivilPawn(aPawn) != none)
                {
                    R6CivilPawn(aPawn).m_bCivilDebug = false;
                }
                // End:0xB1
                continue;
            }
            aPawn.bRenderDebug = true;
            // End:0xB1
            if(R6CivilPawn(aPawn) != none)
            {
                R6CivilPawn(aPawn).m_bCivilDebug = true;
            }            
        }                
    }
    else
    {
        closest = ClosestReticulePawn();
        // End:0x177
        foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
        {
            // End:0x13F
            if((aPawn != Outer.Pawn) && aPawn != closest)
            {
                aPawn.bRenderDebug = false;
                // End:0x13C
                if(R6CivilPawn(aPawn) != none)
                {
                    R6CivilPawn(aPawn).m_bCivilDebug = false;
                }
                // End:0x176
                continue;
            }
            aPawn.bRenderDebug = true;
            // End:0x176
            if(R6CivilPawn(aPawn) != none)
            {
                R6CivilPawn(aPawn).m_bCivilDebug = true;
            }            
        }        
    }
    return;
}

exec function ToggleVFX()
{
    m_bVisualEffectsDisabled = !m_bVisualEffectsDisabled;
    return;
}

exec function DisableCamEffects()
{
    R6Camera(Outer.PlayerCamera).m_bDisableEffects = !R6Camera(Outer.PlayerCamera).m_bDisableEffects;
    return;
}

exec function ShakeCamera(class<DamageType> DamageType)
{
    R6Camera(Outer.PlayerCamera).Shake(DamageType, 1.0000000);
    return;
}

exec function DebugRecoil()
{
    m_bDebugRecoil = !m_bDebugRecoil;
    return;
}

exec function DebugVehicles()
{
    m_bDebugVehicles = !m_bDebugVehicles;
    return;
}

exec function SetCamMode(string NewCamMode)
{
    local R6GameEnums.EDebugCameraModes eNewCamMode;

    // End:0x2D
    if((NewCamMode ~= "THIRD") || NewCamMode ~= "3RD")
    {
        eNewCamMode = 1;        
    }
    else
    {
        // End:0x62
        if((NewCamMode ~= "THIRDFREE") || NewCamMode ~= "3RDFREE")
        {
            eNewCamMode = 2;            
        }
        else
        {
            // End:0x7F
            if(NewCamMode ~= "FOLLOW")
            {
                eNewCamMode = 3;                
            }
            else
            {
                // End:0x9B
                if(NewCamMode ~= "FIXED")
                {
                    eNewCamMode = 4;                    
                }
                else
                {
                    // End:0xBB
                    if(NewCamMode ~= "OVERWORLD")
                    {
                        eNewCamMode = 5;                        
                    }
                    else
                    {
                        eNewCamMode = 0;
                    }
                }
            }
        }
    }
    R6Camera(Outer.PlayerCamera).ForceCameraMode(eNewCamMode);
    LogInternal("Force camera mode to" @ string(GetEnum(Enum'R6GameEnums.EDebugCameraModes', int(eNewCamMode))));
    return;
}

function string GetVisibilityString(int iVisibility)
{
    local string szVisibility;

    switch(iVisibility)
    {
        // End:0x1D
        case 0:
            szVisibility = "Disable";
            // End:0xB4
            break;
        // End:0x38
        case 1:
            szVisibility = "First Person";
            // End:0xB4
            break;
        // End:0x54
        case 2:
            szVisibility = "Third Person";
            // End:0xB4
            break;
        // End:0x76
        case 4:
            szVisibility = "Scope Third Person";
            // End:0xB4
            break;
        // End:0x97
        case 8:
            szVisibility = "Over The Shoulder";
            // End:0xB4
            break;
        // End:0xB1
        case 16:
            szVisibility = "Helicopter";
            // End:0xB4
            break;
        // End:0xFFFF
        default:
            break;
    }
    return szVisibility;
    return;
}

exec function CycleVisibility()
{
    // End:0x43
    if(R6Pawn(Outer.Pawn).m_iForceComponentsVisibility == 0)
    {
        R6Pawn(Outer.Pawn).m_iForceComponentsVisibility = 1;        
    }
    else
    {
        R6Pawn(Outer.Pawn).m_iForceComponentsVisibility = R6Pawn(Outer.Pawn).m_iForceComponentsVisibility << 1;
        // End:0xC0
        if(R6Pawn(Outer.Pawn).m_iForceComponentsVisibility > 16)
        {
            R6Pawn(Outer.Pawn).m_iForceComponentsVisibility = 0;
        }
    }
    LogInternal("CycleVisibility" @ (GetVisibilityString(R6Pawn(Outer.Pawn).m_iForceComponentsVisibility)));
    return;
}

exec function ForceThirdPerson()
{
    // End:0x44
    if(R6Pawn(Outer.Pawn).m_iForceComponentsVisibility == 2)
    {
        R6Pawn(Outer.Pawn).m_iForceComponentsVisibility = 0;        
    }
    else
    {
        R6Pawn(Outer.Pawn).m_iForceComponentsVisibility = 2;
    }
    LogInternal("ForceThirdPerson" @ (GetVisibilityString(R6Pawn(Outer.Pawn).m_iForceComponentsVisibility)));
    return;
}

exec function ForceFirstPerson()
{
    // End:0x43
    if(R6Pawn(Outer.Pawn).m_iForceComponentsVisibility == 1)
    {
        R6Pawn(Outer.Pawn).m_iForceComponentsVisibility = 0;        
    }
    else
    {
        R6Pawn(Outer.Pawn).m_iForceComponentsVisibility = 1;
    }
    LogInternal("ForceFirstPerson" @ (GetVisibilityString(R6Pawn(Outer.Pawn).m_iForceComponentsVisibility)));
    return;
}

exec function HideAll()
{
    Outer.Pawn.bHidden = !Outer.Pawn.bHidden;
    return;
}

exec function CycleCamMode()
{
    local R6Camera Cam;

    Cam = R6Camera(Outer.PlayerCamera);
    // End:0x77
    if(Cam != none)
    {
        // End:0x65
        if(int(Cam.m_eForceCameraMode) < int(5))
        {
            Cam.ForceCameraMode(byte(int(Cam.m_eForceCameraMode) + 1));            
        }
        else
        {
            Cam.ForceCameraMode(0);
        }
    }
    LogInternal("CycleCamMode to" @ string(GetEnum(Enum'R6GameEnums.ECameraMode', int(Cam.m_eForceCameraMode))));
    return;
}

exec function IncreaseEditableProp()
{
    IncrEdProp();
    return;
}

exec function DecreaseEditableProp()
{
    DecrEdProp();
    return;
}

exec function EditablePropertyModifier(float fModif)
{
    m_fPropEditModif = fModif;
    return;
}

exec function DebugMoveAnim()
{
    m_bDebugMoveAnim = !m_bDebugMoveAnim;
    LogInternal("DebugMoveAnim set at" @ string(m_bDebugMoveAnim));
    return;
}

exec function SetColRadius(float fNewRadius)
{
    Outer.Pawn.SetCollisionSize(fNewRadius, Outer.Pawn.GetCollisionHeight());
    return;
}

exec function SetColHeight(float fNewHeight)
{
    Outer.Pawn.SetCollisionSize(Outer.Pawn.GetCollisionRadius(), fNewHeight);
    return;
}

function CycleTestAnimNode(AnimNode pNode)
{
    local R6AnimNodeBlendTestDebug pTestNode;
    local R6AnimNodeSubTrees pSubTree;
    local AnimNodeBlendBase pBlendNode;
    local int I;

    pBlendNode = AnimNodeBlendBase(pNode);
    // End:0x92
    if(pBlendNode != none)
    {
        pTestNode = R6AnimNodeBlendTestDebug(pBlendNode);
        // End:0x45
        if(pTestNode != none)
        {
            pTestNode.CycleAnim();
        }
        I = 0;
        J0x4C:

        // End:0x8F [Loop If]
        if(I < pBlendNode.Children.Length)
        {
            CycleTestAnimNode(pBlendNode.Children[I].Anim);
            I++;
            // [Loop Continue]
            goto J0x4C;
        }        
    }
    else
    {
        pSubTree = R6AnimNodeSubTrees(pNode);
        // End:0x179
        if(pSubTree != none)
        {
            // End:0xE0
            if(pSubTree.m_NormalAnimTreeInfo.m_AnimTree != none)
            {
                CycleTestAnimNode(pSubTree.m_NormalAnimTreeInfo.m_AnimTree);
            }
            // End:0x113
            if(pSubTree.m_TakeCoverAnimTreeInfo.m_AnimTree != none)
            {
                CycleTestAnimNode(pSubTree.m_TakeCoverAnimTreeInfo.m_AnimTree);
            }
            // End:0x146
            if(pSubTree.m_RappelAnimTreeInfo.m_AnimTree != none)
            {
                CycleTestAnimNode(pSubTree.m_RappelAnimTreeInfo.m_AnimTree);
            }
            // End:0x179
            if(pSubTree.m_FastRopeAnimTreeInfo.m_AnimTree != none)
            {
                CycleTestAnimNode(pSubTree.m_FastRopeAnimTreeInfo.m_AnimTree);
            }
        }
    }
    return;
}

exec function CycleTestAnim()
{
    local editinline SkeletalMeshComponent pSkel;
    local AnimNodeBlendBase pBlendNode;
    local int I;

    I = 0;
    J0x07:

    // End:0x96 [Loop If]
    if(I < Outer.Pawn.Components.Length)
    {
        pSkel = SkeletalMeshComponent(Outer.Pawn.Components[I]);
        // End:0x8C
        if(pSkel != none)
        {
            pBlendNode = AnimNodeBlendBase(pSkel.Animations);
            // End:0x8C
            if(pBlendNode != none)
            {
                CycleTestAnimNode(pBlendNode);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

exec function ResetGameLevel()
{
    Outer.GetGameManager().ResetGameLevel();
    return;
}

exec function AlgoDbg(string AlgoType)
{
    // End:0xC4
    if(AlgoType == "adv")
    {
        // End:0x87
        if(R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.m_bStartDebugGfx_adv)
        {
            R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.m_bStartDebugGfx_adv = false;            
        }
        else
        {
            R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.m_bStartDebugGfx_adv = true;
        }        
    }
    else
    {
        // End:0x13C
        if(R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.m_bStartDebugGfx)
        {
            R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.m_bStartDebugGfx = false;            
        }
        else
        {
            R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.m_bStartDebugGfx = true;
        }
    }
    return;
}

exec function ShowDynCollision(name PawnName)
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderCollisionBox = !aPawn.m_bRenderCollisionBox;        
    }    
    return;
}

exec function ShowPathFollowing(name PawnName)
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bRenderPathFollowing = !aPawn.m_bRenderPathFollowing;        
    }    
    return;
}

exec function CloseMvtSys()
{
    m_bDisableCloseMovementSystem = !m_bDisableCloseMovementSystem;
    // End:0x4F
    if(m_bDisableCloseMovementSystem)
    {
        Outer.ClientMessage("Close movement system is now OFF");        
    }
    else
    {
        Outer.ClientMessage("Close movement system is now ON");
    }
    return;
}

exec function MoveToEndFacing()
{
    Outer.GetAIConfig().m_bUseEndFacingInMoveTo = !Outer.GetAIConfig().m_bUseEndFacingInMoveTo;
    // End:0x81
    if(Outer.GetAIConfig().m_bUseEndFacingInMoveTo)
    {
        Outer.ClientMessage("MoveToEndFacing is now ON");        
    }
    else
    {
        Outer.ClientMessage("MoveToEndFacing is now OFF");
    }
    return;
}

exec function ShowFocusPoints()
{
    local R6RainbowManager R6Rainbow;

    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.m_bShowRiskPoints = !R6Rainbow.m_bShowRiskPoints;
    return;
}

exec function ShowCoverResults()
{
    local R6RainbowManager R6Rainbow;

    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    R6Rainbow.ToggleShowCoverResults();
    return;
}

exec function StartAlgo(name PawnName, string algoName)
{
    local R6AIController pctrl;
    local R6Pawn aPawn;
    local Pawn closest;

    LogInternal("STARTALGO");
    // End:0x70
    if(Len(string(PawnName)) != 0)
    {
        // End:0x6C
        foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
        {
            // End:0x6B
            if(aPawn.Name == PawnName)
            {
                pctrl = R6AIController(aPawn.Controller);
                // End:0x6C
                break;
            }            
        }                
    }
    else
    {
        closest = ClosestReticulePawn();
        aPawn = R6Pawn(closest);
        // End:0xB1
        if(aPawn != none)
        {
            pctrl = R6AIController(aPawn.Controller);
        }
    }
    R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIServiceManager.LaunchAlgo(algoName, pctrl);
    return;
}

exec function DamagePlayer(int iDamage)
{
    // End:0x8B
    if(Outer.Pawn != none)
    {
        Outer.Pawn.TakeDamage(iDamage, iDamage, Outer.Pawn.Controller, Outer.Pawn.Location, Outer.Pawn.Location, vect(0.0000000, 0.0000000, 1.0000000), none);
    }
    return;
}

exec function HealPlayer(int iHeal)
{
    local R6Pawn pPawn;

    pPawn = R6Pawn(Outer.Pawn);
    // End:0x51
    if(pPawn != none)
    {
        pPawn.HealDamage(iHeal, Outer.Pawn.Controller, none);
    }
    return;
}

exec function ToggleMagmaHud()
{
    local R6PlayerController PlayerCtrl;

    PlayerCtrl = R6PlayerController(Outer.Pawn.Controller);
    PlayerCtrl.m_MagmaInteraction.ShowHud(!PlayerCtrl.m_MagmaInteraction.IsHudDisplayed());
    return;
}

exec function ToggleTerroristIcons()
{
    local R6PlayerController PlayerCtrl;

    PlayerCtrl = R6PlayerController(Outer.Pawn.Controller);
    PlayerCtrl.m_MagmaInteraction.ToggleTerroristIcons();
    return;
}

// Export UR6CheatManager::execToggle3DHud(FFrame&, void* const)
native exec function Toggle3DHud();

exec function ToggleMagmaUI()
{
    local R6MagmaInteraction pUI;

    pUI = Outer.GetGameManager().GetBaseMenu();
    pUI.m_bVisible = !pUI.m_bVisible;
    return;
}

exec function ShowKismetDebug()
{
    // End:0x42
    if(Outer.WorldInfo.GetGameSequence() != none)
    {
        Outer.WorldInfo.GetGameSequence().super(R6CheatManager).ShowKismetDebug();
    }
    return;
}

exec function ForceFireFightColorGel()
{
    Outer.GetGameManager().ToggleForceFireFightColorGel();
    return;
}

exec function DisableFireFightColorGel()
{
    Outer.GetGameManager().ToggleFireFightColorGel();
    return;
}

exec function ChangePawnSize(float fScale)
{
    local R6Pawn aPawn;

    // End:0x9D
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.CylinderComponent.SetSize(aPawn.default.CylinderComponent.CollisionHeight * fScale, aPawn.default.CylinderComponent.CollisionRadius * fScale);
        aPawn.SetDrawScale(fScale);
        aPawn.SetLocation(aPawn.Location);        
    }    
    return;
}

exec function ShowBone(name PawnName)
{
    local R6Pawn aPawn;

    // End:0x23D
    if(Len(string(PawnName)) != 0)
    {
        // End:0x13B
        if(PawnName == 'All')
        {
            // End:0x137
            foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
            {
                // End:0x136
                if(aPawn.Name == PawnName)
                {
                    // End:0xD1
                    if(aPawn.Mesh.bDisplayBones != 0)
                    {
                        aPawn.Mesh.bDisplayBones = 0;
                        // End:0xCE
                        if((R6Character(aPawn) != none) && R6Character(aPawn).m_FPMesh != none)
                        {
                            R6Character(aPawn).m_FPMesh.bDisplayBones = 0;
                        }                        
                    }
                    else
                    {
                        aPawn.Mesh.bDisplayBones = 1;
                        // End:0x133
                        if((R6Character(aPawn) != none) && R6Character(aPawn).m_FPMesh != none)
                        {
                            R6Character(aPawn).m_FPMesh.bDisplayBones = 1;
                        }
                    }
                    // End:0x137
                    break;
                }                
            }                        
        }
        else
        {
            // End:0x239
            foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
            {
                // End:0x1D6
                if(aPawn.Mesh.bDisplayBones != 0)
                {
                    aPawn.Mesh.bDisplayBones = 0;
                    // End:0x1D3
                    if((R6Character(aPawn) != none) && R6Character(aPawn).m_FPMesh != none)
                    {
                        R6Character(aPawn).m_FPMesh.bDisplayBones = 0;
                    }
                    // End:0x238
                    continue;
                }
                aPawn.Mesh.bDisplayBones = 1;
                // End:0x238
                if((R6Character(aPawn) != none) && R6Character(aPawn).m_FPMesh != none)
                {
                    R6Character(aPawn).m_FPMesh.bDisplayBones = 1;
                }                
            }            
        }        
    }
    else
    {
        // End:0x2E3
        if(Outer.Pawn.Mesh.bDisplayBones != 0)
        {
            Outer.Pawn.Mesh.bDisplayBones = 0;
            // End:0x2E0
            if((R6Character(Outer.Pawn) != none) && R6Character(aPawn).m_FPMesh != none)
            {
                R6Character(Outer.Pawn).m_FPMesh.bDisplayBones = 0;
            }            
        }
        else
        {
            Outer.Pawn.Mesh.bDisplayBones = 1;
            // End:0x360
            if((R6Character(Outer.Pawn) != none) && R6Character(aPawn).m_FPMesh != none)
            {
                R6Character(Outer.Pawn).m_FPMesh.bDisplayBones = 1;
            }
        }
    }
    return;
}

exec function Occlusion(bool bTurnOn)
{
    m_bOcclusion = bTurnOn;    
    Outer.ConsoleCommand("SET D3DRENDERDEVICE DISABLEOCCLUSION " $ string(!m_bOcclusion));
    Outer.ClientMessage("Occlusion set to " $ string(bTurnOn));
    return;
}

exec function ToggleAiming()
{
    m_bHorizontalAiming = !m_bHorizontalAiming;
    return;
}

exec function ToggleCOM()
{
    m_bCOMBalance = !m_bCOMBalance;
    return;
}

exec function EditFPTranslation()
{
    // End:0x1B
    if(int(m_eEditOffsetMode) == int(1))
    {
        m_eEditOffsetMode = 0;        
    }
    else
    {
        m_eEditOffsetMode = 1;
    }
    return;
}

exec function EditFPRotation()
{
    // End:0x1B
    if(int(m_eEditOffsetMode) == int(2))
    {
        m_eEditOffsetMode = 0;        
    }
    else
    {
        m_eEditOffsetMode = 2;
    }
    return;
}

exec function EditCameraTranslation()
{
    // End:0x1B
    if(int(m_eEditOffsetMode) == int(3))
    {
        m_eEditOffsetMode = 0;        
    }
    else
    {
        m_eEditOffsetMode = 3;
    }
    return;
}

exec function EditLookMovement()
{
    local int iEditOffsetMode;

    // End:0x46
    if((int(m_eEditOffsetMode) >= int(4)) && int(m_eEditOffsetMode) < int(7))
    {
        iEditOffsetMode = int(m_eEditOffsetMode);
        iEditOffsetMode++;
        m_eEditOffsetMode = byte(iEditOffsetMode);        
    }
    else
    {
        // End:0x61
        if(int(m_eEditOffsetMode) == int(7))
        {
            m_eEditOffsetMode = 0;            
        }
        else
        {
            m_eEditOffsetMode = 4;
        }
    }
    return;
}

exec function IncreaseEditOffsetModifier(float fModifier)
{
    switch(m_eEditOffsetMode)
    {
        // End:0x1B
        case 1:
            m_fFPMeshTranslationModifier += fModifier;
            // End:0x88
            break;
        // End:0x37
        case 2:
            m_iFPMeshRotationModifier += int(fModifier * float(10));
            // End:0x88
            break;
        // End:0x4B
        case 3:
            m_fCameraTranslationModifier += fModifier;
            // End:0x88
            break;
        // End:0x50
        case 4:
        // End:0x6C
        case 5:
            m_iLookLimitModifier += int(fModifier * float(10));
            // End:0x88
            break;
        // End:0x71
        case 6:
        // End:0x85
        case 7:
            m_fLookModifier += fModifier;
            // End:0x88
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

exec function SetEditOffsetModifier(float fModifier)
{
    switch(m_eEditOffsetMode)
    {
        // End:0x1A
        case 1:
            m_fFPMeshTranslationModifier = fModifier;
            // End:0x77
            break;
        // End:0x2F
        case 2:
            m_iFPMeshRotationModifier = int(fModifier);
            // End:0x77
            break;
        // End:0x42
        case 3:
            m_fCameraTranslationModifier = fModifier;
            // End:0x77
            break;
        // End:0x47
        case 4:
        // End:0x5C
        case 5:
            m_iLookLimitModifier = int(fModifier);
            // End:0x77
            break;
        // End:0x61
        case 6:
        // End:0x74
        case 7:
            m_fLookModifier = fModifier;
            // End:0x77
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

exec function IncreaseEditOffset(int iAxis, float iMod)
{
    local R6Camera Cam;
    local R6Pawn PlayerPawn;
    local R6Weapon PawnWeapon;
    local R6Shield pShield;

    PlayerPawn = R6Pawn(Outer.Pawn);
    PawnWeapon = R6Pawn(Outer.Pawn).m_R6Weapon;
    pShield = R6Shield(PawnWeapon);
    // End:0x5BD
    if(int(m_eEditOffsetMode) == int(1))
    {
        // End:0x5BA
        if((PlayerPawn != none) && PawnWeapon != none)
        {
            // End:0x236
            if(iAxis == 0)
            {
                // End:0x208
                if(PlayerPawn.IsScoping())
                {
                    switch(PawnWeapon.m_eScopeType)
                    {
                        // End:0x12C
                        case 1:
                            // End:0xFE
                            if((pShield != none) && pShield.m_FireableWeapon != none)
                            {
                                pShield.m_FireableWeapon.GetConfigVals().m_vIronSightsShieldFPMeshTranslation.X += (m_fFPMeshTranslationModifier * iMod);                                
                            }
                            else
                            {
                                PawnWeapon.GetConfigVals().m_vIronSightsFPMeshTranslation.X += (m_fFPMeshTranslationModifier * iMod);
                            }
                            // End:0x205
                            break;
                        // End:0x15F
                        case 2:
                            PawnWeapon.GetConfigVals().m_vReflexSightsFPMeshTranslation.X += (m_fFPMeshTranslationModifier * iMod);
                            // End:0x205
                            break;
                        // End:0x192
                        case 3:
                            PawnWeapon.GetConfigVals().m_vRifleScopeFPMeshTranslation.X += (m_fFPMeshTranslationModifier * iMod);
                            // End:0x205
                            break;
                        // End:0x1C5
                        case 4:
                            PawnWeapon.GetConfigVals().m_vACOGScopeFPMeshTranslation.X += (m_fFPMeshTranslationModifier * iMod);
                            // End:0x205
                            break;
                        // End:0x1CA
                        case 5:
                        // End:0x1CF
                        case 6:
                        // End:0x202
                        case 7:
                            PawnWeapon.GetConfigVals().m_vSniperScopeFPMeshTranslation.X += (m_fFPMeshTranslationModifier * iMod);
                            // End:0x205
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }                    
                }
                else
                {
                    PawnWeapon.GetConfigVals().m_vFirstPersonMeshTranslation.X += (m_fFPMeshTranslationModifier * iMod);
                }                
            }
            else
            {
                // End:0x3F9
                if(iAxis == 1)
                {
                    // End:0x3CB
                    if(PlayerPawn.IsScoping())
                    {
                        switch(PawnWeapon.m_eScopeType)
                        {
                            // End:0x2EF
                            case 1:
                                // End:0x2C1
                                if((pShield != none) && pShield.m_FireableWeapon != none)
                                {
                                    pShield.m_FireableWeapon.GetConfigVals().m_vIronSightsShieldFPMeshTranslation.Y += (m_fFPMeshTranslationModifier * iMod);                                    
                                }
                                else
                                {
                                    PawnWeapon.GetConfigVals().m_vIronSightsFPMeshTranslation.Y += (m_fFPMeshTranslationModifier * iMod);
                                }
                                // End:0x3C8
                                break;
                            // End:0x322
                            case 2:
                                PawnWeapon.GetConfigVals().m_vReflexSightsFPMeshTranslation.Y += (m_fFPMeshTranslationModifier * iMod);
                                // End:0x3C8
                                break;
                            // End:0x355
                            case 3:
                                PawnWeapon.GetConfigVals().m_vRifleScopeFPMeshTranslation.Y += (m_fFPMeshTranslationModifier * iMod);
                                // End:0x3C8
                                break;
                            // End:0x388
                            case 4:
                                PawnWeapon.GetConfigVals().m_vACOGScopeFPMeshTranslation.Y += (m_fFPMeshTranslationModifier * iMod);
                                // End:0x3C8
                                break;
                            // End:0x38D
                            case 5:
                            // End:0x392
                            case 6:
                            // End:0x3C5
                            case 7:
                                PawnWeapon.GetConfigVals().m_vSniperScopeFPMeshTranslation.Y += (m_fFPMeshTranslationModifier * iMod);
                                // End:0x3C8
                                break;
                            // End:0xFFFF
                            default:
                                break;
                        }                        
                    }
                    else
                    {
                        PawnWeapon.GetConfigVals().m_vFirstPersonMeshTranslation.Y += (m_fFPMeshTranslationModifier * iMod);
                    }                    
                }
                else
                {
                    // End:0x5BA
                    if(iAxis == 2)
                    {
                        // End:0x58F
                        if(PlayerPawn.IsScoping())
                        {
                            switch(PawnWeapon.m_eScopeType)
                            {
                                // End:0x4B3
                                case 1:
                                    // End:0x485
                                    if((pShield != none) && pShield.m_FireableWeapon != none)
                                    {
                                        pShield.m_FireableWeapon.GetConfigVals().m_vIronSightsShieldFPMeshTranslation.Z += (m_fFPMeshTranslationModifier * iMod);                                        
                                    }
                                    else
                                    {
                                        PawnWeapon.GetConfigVals().m_vIronSightsFPMeshTranslation.Z += (m_fFPMeshTranslationModifier * iMod);
                                    }
                                    // End:0x58C
                                    break;
                                // End:0x4E6
                                case 2:
                                    PawnWeapon.GetConfigVals().m_vReflexSightsFPMeshTranslation.Z += (m_fFPMeshTranslationModifier * iMod);
                                    // End:0x58C
                                    break;
                                // End:0x519
                                case 3:
                                    PawnWeapon.GetConfigVals().m_vRifleScopeFPMeshTranslation.Z += (m_fFPMeshTranslationModifier * iMod);
                                    // End:0x58C
                                    break;
                                // End:0x54C
                                case 4:
                                    PawnWeapon.GetConfigVals().m_vACOGScopeFPMeshTranslation.Z += (m_fFPMeshTranslationModifier * iMod);
                                    // End:0x58C
                                    break;
                                // End:0x551
                                case 5:
                                // End:0x556
                                case 6:
                                // End:0x589
                                case 7:
                                    PawnWeapon.GetConfigVals().m_vSniperScopeFPMeshTranslation.Z += (m_fFPMeshTranslationModifier * iMod);
                                    // End:0x58C
                                    break;
                                // End:0xFFFF
                                default:
                                    break;
                            }                            
                        }
                        else
                        {
                            PawnWeapon.GetConfigVals().m_vFirstPersonMeshTranslation.Z += (m_fFPMeshTranslationModifier * iMod);
                        }
                    }
                }
            }
        }        
    }
    else
    {
        // End:0xB83
        if(int(m_eEditOffsetMode) == int(2))
        {
            // End:0xB80
            if((PlayerPawn != none) && PawnWeapon != none)
            {
                // End:0x7C4
                if(iAxis == 0)
                {
                    // End:0x792
                    if(PlayerPawn.IsScoping())
                    {
                        switch(PawnWeapon.m_eScopeType)
                        {
                            // End:0x6A6
                            case 1:
                                // End:0x674
                                if((pShield != none) && pShield.m_FireableWeapon != none)
                                {
                                    pShield.m_FireableWeapon.GetConfigVals().m_rIronSightsFPMeshRotation.Pitch += int(float(m_iFPMeshRotationModifier) * iMod);                                    
                                }
                                else
                                {
                                    PawnWeapon.GetConfigVals().m_rIronSightsFPMeshRotation.Pitch += int(float(m_iFPMeshRotationModifier) * iMod);
                                }
                                // End:0x78F
                                break;
                            // End:0x6DD
                            case 2:
                                PawnWeapon.GetConfigVals().m_rReflexSightsFPMeshRotation.Pitch += int(float(m_iFPMeshRotationModifier) * iMod);
                                // End:0x78F
                                break;
                            // End:0x714
                            case 3:
                                PawnWeapon.GetConfigVals().m_rRifleScopeFPMeshRotation.Pitch += int(float(m_iFPMeshRotationModifier) * iMod);
                                // End:0x78F
                                break;
                            // End:0x74B
                            case 4:
                                PawnWeapon.GetConfigVals().m_rACOGScopeFPMeshRotation.Pitch += int(float(m_iFPMeshRotationModifier) * iMod);
                                // End:0x78F
                                break;
                            // End:0x750
                            case 5:
                            // End:0x755
                            case 6:
                            // End:0x78C
                            case 7:
                                PawnWeapon.GetConfigVals().m_rSniperScopeFPMeshRotation.Pitch += int(float(m_iFPMeshRotationModifier) * iMod);
                                // End:0x78F
                                break;
                            // End:0xFFFF
                            default:
                                break;
                        }                        
                    }
                    else
                    {
                        PawnWeapon.GetConfigVals().m_rFirstPersonMeshRotation.Pitch += int(float(m_iFPMeshRotationModifier) * iMod);
                    }                    
                }
                else
                {
                    // End:0x9A3
                    if(iAxis == 1)
                    {
                        // End:0x971
                        if(PlayerPawn.IsScoping())
                        {
                            switch(PawnWeapon.m_eScopeType)
                            {
                                // End:0x885
                                case 1:
                                    // End:0x853
                                    if((pShield != none) && pShield.m_FireableWeapon != none)
                                    {
                                        pShield.m_FireableWeapon.GetConfigVals().m_rIronSightsFPMeshRotation.Yaw += int(float(m_iFPMeshRotationModifier) * iMod);                                        
                                    }
                                    else
                                    {
                                        PawnWeapon.GetConfigVals().m_rIronSightsFPMeshRotation.Yaw += int(float(m_iFPMeshRotationModifier) * iMod);
                                    }
                                    // End:0x96E
                                    break;
                                // End:0x8BC
                                case 2:
                                    PawnWeapon.GetConfigVals().m_rReflexSightsFPMeshRotation.Yaw += int(float(m_iFPMeshRotationModifier) * iMod);
                                    // End:0x96E
                                    break;
                                // End:0x8F3
                                case 3:
                                    PawnWeapon.GetConfigVals().m_rRifleScopeFPMeshRotation.Yaw += int(float(m_iFPMeshRotationModifier) * iMod);
                                    // End:0x96E
                                    break;
                                // End:0x92A
                                case 4:
                                    PawnWeapon.GetConfigVals().m_rACOGScopeFPMeshRotation.Yaw += int(float(m_iFPMeshRotationModifier) * iMod);
                                    // End:0x96E
                                    break;
                                // End:0x92F
                                case 5:
                                // End:0x934
                                case 6:
                                // End:0x96B
                                case 7:
                                    PawnWeapon.GetConfigVals().m_rSniperScopeFPMeshRotation.Yaw += int(float(m_iFPMeshRotationModifier) * iMod);
                                    // End:0x96E
                                    break;
                                // End:0xFFFF
                                default:
                                    break;
                            }                            
                        }
                        else
                        {
                            PawnWeapon.GetConfigVals().m_rFirstPersonMeshRotation.Yaw += int(float(m_iFPMeshRotationModifier) * iMod);
                        }                        
                    }
                    else
                    {
                        // End:0xB80
                        if(iAxis == 2)
                        {
                            // End:0xB51
                            if(PlayerPawn.IsScoping())
                            {
                                switch(PawnWeapon.m_eScopeType)
                                {
                                    // End:0xA65
                                    case 1:
                                        // End:0xA33
                                        if((pShield != none) && pShield.m_FireableWeapon != none)
                                        {
                                            pShield.m_FireableWeapon.GetConfigVals().m_rIronSightsFPMeshRotation.Roll += int(float(m_iFPMeshRotationModifier) * iMod);                                            
                                        }
                                        else
                                        {
                                            PawnWeapon.GetConfigVals().m_rIronSightsFPMeshRotation.Roll += int(float(m_iFPMeshRotationModifier) * iMod);
                                        }
                                        // End:0xB4E
                                        break;
                                    // End:0xA9C
                                    case 2:
                                        PawnWeapon.GetConfigVals().m_rReflexSightsFPMeshRotation.Roll += int(float(m_iFPMeshRotationModifier) * iMod);
                                        // End:0xB4E
                                        break;
                                    // End:0xAD3
                                    case 3:
                                        PawnWeapon.GetConfigVals().m_rRifleScopeFPMeshRotation.Roll += int(float(m_iFPMeshRotationModifier) * iMod);
                                        // End:0xB4E
                                        break;
                                    // End:0xB0A
                                    case 4:
                                        PawnWeapon.GetConfigVals().m_rACOGScopeFPMeshRotation.Roll += int(float(m_iFPMeshRotationModifier) * iMod);
                                        // End:0xB4E
                                        break;
                                    // End:0xB0F
                                    case 5:
                                    // End:0xB14
                                    case 6:
                                    // End:0xB4B
                                    case 7:
                                        PawnWeapon.GetConfigVals().m_rSniperScopeFPMeshRotation.Roll += int(float(m_iFPMeshRotationModifier) * iMod);
                                        // End:0xB4E
                                        break;
                                    // End:0xFFFF
                                    default:
                                        break;
                                }                                
                            }
                            else
                            {
                                PawnWeapon.GetConfigVals().m_rFirstPersonMeshRotation.Roll += int(float(m_iFPMeshRotationModifier) * iMod);
                            }
                        }
                    }
                }
            }            
        }
        else
        {
            // End:0xC45
            if(int(m_eEditOffsetMode) == int(3))
            {
                Cam = R6Camera(Outer.PlayerCamera);
                // End:0xC42
                if(Cam != none)
                {
                    // End:0xBE6
                    if(iAxis == 0)
                    {
                        Cam.m_vDebugCamOffset.X += (m_fCameraTranslationModifier * iMod);                        
                    }
                    else
                    {
                        // End:0xC15
                        if(iAxis == 1)
                        {
                            Cam.m_vDebugCamOffset.Y += (m_fCameraTranslationModifier * iMod);                            
                        }
                        else
                        {
                            // End:0xC42
                            if(iAxis == 2)
                            {
                                Cam.m_vDebugCamOffset.Z += (m_fCameraTranslationModifier * iMod);
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0x1049
                if((int(m_eEditOffsetMode) >= int(4)) && int(m_eEditOffsetMode) <= int(7))
                {
                    // End:0x1049
                    if((PlayerPawn != none) && PawnWeapon != none)
                    {
                        // End:0xE43
                        if(iAxis == 0)
                        {
                            // End:0xD71
                            if(!PawnWeapon.IsScoping())
                            {
                                switch(m_eEditOffsetMode)
                                {
                                    // End:0xCD8
                                    case 4:
                                        PawnWeapon.GetConfigVals().m_iMinPitchLook += int(float(m_iLookLimitModifier) * iMod);
                                        // End:0xD6E
                                        break;
                                    // End:0xD0A
                                    case 5:
                                        PawnWeapon.GetConfigVals().m_iMinYawLook += int(float(m_iLookLimitModifier) * iMod);
                                        // End:0xD6E
                                        break;
                                    // End:0xD38
                                    case 6:
                                        PawnWeapon.GetConfigVals().m_fLookRecoveryDampFactor += (m_fLookModifier * iMod);
                                        // End:0xD6E
                                        break;
                                    // End:0xD6B
                                    case 7:
                                        PawnWeapon.GetConfigVals().m_vLookPivotOffset.X += (m_fLookModifier * iMod);
                                        // End:0xD6E
                                        break;
                                    // End:0xFFFF
                                    default:
                                        break;
                                }                                
                            }
                            else
                            {
                                switch(m_eEditOffsetMode)
                                {
                                    // End:0xDAA
                                    case 4:
                                        PawnWeapon.GetConfigVals().m_iScopeMinPitchLook += int(float(m_iLookLimitModifier) * iMod);
                                        // End:0xE40
                                        break;
                                    // End:0xDDC
                                    case 5:
                                        PawnWeapon.GetConfigVals().m_iScopeMinYawLook += int(float(m_iLookLimitModifier) * iMod);
                                        // End:0xE40
                                        break;
                                    // End:0xE0A
                                    case 6:
                                        PawnWeapon.GetConfigVals().m_fScopeLookRecoveryDampFactor += (m_fLookModifier * iMod);
                                        // End:0xE40
                                        break;
                                    // End:0xE3D
                                    case 7:
                                        PawnWeapon.GetConfigVals().m_vScopeLookPivotOffset.X += (m_fLookModifier * iMod);
                                        // End:0xE40
                                        break;
                                    // End:0xFFFF
                                    default:
                                        break;
                                }
                            }                            
                        }
                        else
                        {
                            // End:0xFAB
                            if(iAxis == 1)
                            {
                                // End:0xF07
                                if(!PawnWeapon.IsScoping())
                                {
                                    switch(m_eEditOffsetMode)
                                    {
                                        // End:0xE9C
                                        case 4:
                                            PawnWeapon.GetConfigVals().m_iMaxPitchLook += int(float(m_iLookLimitModifier) * iMod);
                                            // End:0xF04
                                            break;
                                        // End:0xECE
                                        case 5:
                                            PawnWeapon.GetConfigVals().m_iMaxYawLook += int(float(m_iLookLimitModifier) * iMod);
                                            // End:0xF04
                                            break;
                                        // End:0xF01
                                        case 7:
                                            PawnWeapon.GetConfigVals().m_vLookPivotOffset.Y += (m_fLookModifier * iMod);
                                            // End:0xF04
                                            break;
                                        // End:0xFFFF
                                        default:
                                            break;
                                    }                                    
                                }
                                else
                                {
                                    switch(m_eEditOffsetMode)
                                    {
                                        // End:0xF40
                                        case 4:
                                            PawnWeapon.GetConfigVals().m_iScopeMaxPitchLook += int(float(m_iLookLimitModifier) * iMod);
                                            // End:0xFA8
                                            break;
                                        // End:0xF72
                                        case 5:
                                            PawnWeapon.GetConfigVals().m_iScopeMaxYawLook += int(float(m_iLookLimitModifier) * iMod);
                                            // End:0xFA8
                                            break;
                                        // End:0xFA5
                                        case 7:
                                            PawnWeapon.GetConfigVals().m_vScopeLookPivotOffset.Y += (m_fLookModifier * iMod);
                                            // End:0xFA8
                                            break;
                                        // End:0xFFFF
                                        default:
                                            break;
                                    }
                                }                                
                            }
                            else
                            {
                                // End:0x1049
                                if(iAxis == 2)
                                {
                                    // End:0x100C
                                    if(!PawnWeapon.IsScoping())
                                    {
                                        switch(m_eEditOffsetMode)
                                        {
                                            // End:0x1006
                                            case 7:
                                                PawnWeapon.GetConfigVals().m_vLookPivotOffset.Z += (m_fLookModifier * iMod);
                                                // End:0x1009
                                                break;
                                            // End:0xFFFF
                                            default:
                                                break;
                                        }                                        
                                    }
                                    else
                                    {
                                        switch(m_eEditOffsetMode)
                                        {
                                            // End:0x1046
                                            case 7:
                                                PawnWeapon.GetConfigVals().m_vScopeLookPivotOffset.Z += (m_fLookModifier * iMod);
                                                // End:0x1049
                                                break;
                                            // End:0xFFFF
                                            default:
                                                break;
                                        }
                                    }
                                }
                                else
                                {
                                }
                            }
                        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0xE43! */
                    }
                }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0xC45! */
            }
        }
        return;
    }
}

exec function SetEditOffset(int iAxis, float fValue)
{
    local R6Camera Cam;
    local R6Pawn PlayerPawn;
    local R6Weapon PawnWeapon;

    PlayerPawn = R6Pawn(Outer.Pawn);
    PawnWeapon = R6Pawn(Outer.Pawn).m_R6Weapon;
    // End:0x415
    if(int(m_eEditOffsetMode) == int(1))
    {
        // End:0x412
        if((PlayerPawn != none) && PawnWeapon != none)
        {
            // End:0x19E
            if(iAxis == 0)
            {
                // End:0x178
                if(PlayerPawn.IsScoping())
                {
                    switch(PawnWeapon.m_eScopeType)
                    {
                        // End:0xBC
                        case 1:
                            PawnWeapon.GetConfigVals().m_vIronSightsFPMeshTranslation.X = fValue;
                            // End:0x175
                            break;
                        // End:0xE7
                        case 2:
                            PawnWeapon.GetConfigVals().m_vReflexSightsFPMeshTranslation.X = fValue;
                            // End:0x175
                            break;
                        // End:0x112
                        case 3:
                            PawnWeapon.GetConfigVals().m_vRifleScopeFPMeshTranslation.X = fValue;
                            // End:0x175
                            break;
                        // End:0x13D
                        case 4:
                            PawnWeapon.GetConfigVals().m_vACOGScopeFPMeshTranslation.X = fValue;
                            // End:0x175
                            break;
                        // End:0x142
                        case 5:
                        // End:0x147
                        case 6:
                        // End:0x172
                        case 7:
                            PawnWeapon.GetConfigVals().m_vSniperScopeFPMeshTranslation.X = fValue;
                            // End:0x175
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }                    
                }
                else
                {
                    PawnWeapon.GetConfigVals().m_vFirstPersonMeshTranslation.X = fValue;
                }                
            }
            else
            {
                // End:0x2D9
                if(iAxis == 1)
                {
                    // End:0x2B3
                    if(PlayerPawn.IsScoping())
                    {
                        switch(PawnWeapon.m_eScopeType)
                        {
                            // End:0x1F7
                            case 1:
                                PawnWeapon.GetConfigVals().m_vIronSightsFPMeshTranslation.Y = fValue;
                                // End:0x2B0
                                break;
                            // End:0x222
                            case 2:
                                PawnWeapon.GetConfigVals().m_vReflexSightsFPMeshTranslation.Y = fValue;
                                // End:0x2B0
                                break;
                            // End:0x24D
                            case 3:
                                PawnWeapon.GetConfigVals().m_vRifleScopeFPMeshTranslation.Y = fValue;
                                // End:0x2B0
                                break;
                            // End:0x278
                            case 4:
                                PawnWeapon.GetConfigVals().m_vACOGScopeFPMeshTranslation.Y = fValue;
                                // End:0x2B0
                                break;
                            // End:0x27D
                            case 5:
                            // End:0x282
                            case 6:
                            // End:0x2AD
                            case 7:
                                PawnWeapon.GetConfigVals().m_vSniperScopeFPMeshTranslation.Y = fValue;
                                // End:0x2B0
                                break;
                            // End:0xFFFF
                            default:
                                break;
                        }                        
                    }
                    else
                    {
                        PawnWeapon.GetConfigVals().m_vFirstPersonMeshTranslation.Y = fValue;
                    }                    
                }
                else
                {
                    // End:0x412
                    if(iAxis == 2)
                    {
                        // End:0x3EF
                        if(PlayerPawn.IsScoping())
                        {
                            switch(PawnWeapon.m_eScopeType)
                            {
                                // End:0x333
                                case 1:
                                    PawnWeapon.GetConfigVals().m_vIronSightsFPMeshTranslation.Z = fValue;
                                    // End:0x3EC
                                    break;
                                // End:0x35E
                                case 2:
                                    PawnWeapon.GetConfigVals().m_vReflexSightsFPMeshTranslation.Z = fValue;
                                    // End:0x3EC
                                    break;
                                // End:0x389
                                case 3:
                                    PawnWeapon.GetConfigVals().m_vRifleScopeFPMeshTranslation.Z = fValue;
                                    // End:0x3EC
                                    break;
                                // End:0x3B4
                                case 4:
                                    PawnWeapon.GetConfigVals().m_vACOGScopeFPMeshTranslation.Z = fValue;
                                    // End:0x3EC
                                    break;
                                // End:0x3B9
                                case 5:
                                // End:0x3BE
                                case 6:
                                // End:0x3E9
                                case 7:
                                    PawnWeapon.GetConfigVals().m_vSniperScopeFPMeshTranslation.Z = fValue;
                                    // End:0x3EC
                                    break;
                                // End:0xFFFF
                                default:
                                    break;
                            }                            
                        }
                        else
                        {
                            PawnWeapon.GetConfigVals().m_vFirstPersonMeshTranslation.Z = fValue;
                        }
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x813
        if(int(m_eEditOffsetMode) == int(2))
        {
            // End:0x810
            if((PlayerPawn != none) && PawnWeapon != none)
            {
                // End:0x584
                if(iAxis == 0)
                {
                    // End:0x55C
                    if(PlayerPawn.IsScoping())
                    {
                        switch(PawnWeapon.m_eScopeType)
                        {
                            // End:0x498
                            case 1:
                                PawnWeapon.GetConfigVals().m_rIronSightsFPMeshRotation.Pitch = int(fValue);
                                // End:0x559
                                break;
                            // End:0x4C5
                            case 2:
                                PawnWeapon.GetConfigVals().m_rReflexSightsFPMeshRotation.Pitch = int(fValue);
                                // End:0x559
                                break;
                            // End:0x4F2
                            case 3:
                                PawnWeapon.GetConfigVals().m_rRifleScopeFPMeshRotation.Pitch = int(fValue);
                                // End:0x559
                                break;
                            // End:0x51F
                            case 4:
                                PawnWeapon.GetConfigVals().m_rACOGScopeFPMeshRotation.Pitch = int(fValue);
                                // End:0x559
                                break;
                            // End:0x524
                            case 5:
                            // End:0x529
                            case 6:
                            // End:0x556
                            case 7:
                                PawnWeapon.GetConfigVals().m_rSniperScopeFPMeshRotation.Pitch = int(fValue);
                                // End:0x559
                                break;
                            // End:0xFFFF
                            default:
                                break;
                        }                        
                    }
                    else
                    {
                        PawnWeapon.GetConfigVals().m_rFirstPersonMeshRotation.Pitch = int(fValue);
                    }                    
                }
                else
                {
                    // End:0x6CB
                    if(iAxis == 1)
                    {
                        // End:0x6A3
                        if(PlayerPawn.IsScoping())
                        {
                            switch(PawnWeapon.m_eScopeType)
                            {
                                // End:0x5DF
                                case 1:
                                    PawnWeapon.GetConfigVals().m_rIronSightsFPMeshRotation.Yaw = int(fValue);
                                    // End:0x6A0
                                    break;
                                // End:0x60C
                                case 2:
                                    PawnWeapon.GetConfigVals().m_rReflexSightsFPMeshRotation.Yaw = int(fValue);
                                    // End:0x6A0
                                    break;
                                // End:0x639
                                case 3:
                                    PawnWeapon.GetConfigVals().m_rRifleScopeFPMeshRotation.Yaw = int(fValue);
                                    // End:0x6A0
                                    break;
                                // End:0x666
                                case 4:
                                    PawnWeapon.GetConfigVals().m_rACOGScopeFPMeshRotation.Yaw = int(fValue);
                                    // End:0x6A0
                                    break;
                                // End:0x66B
                                case 5:
                                // End:0x670
                                case 6:
                                // End:0x69D
                                case 7:
                                    PawnWeapon.GetConfigVals().m_rSniperScopeFPMeshRotation.Yaw = int(fValue);
                                    // End:0x6A0
                                    break;
                                // End:0xFFFF
                                default:
                                    break;
                            }                            
                        }
                        else
                        {
                            PawnWeapon.GetConfigVals().m_rFirstPersonMeshRotation.Yaw = int(fValue);
                        }                        
                    }
                    else
                    {
                        // End:0x810
                        if(iAxis == 2)
                        {
                            // End:0x7EB
                            if(PlayerPawn.IsScoping())
                            {
                                switch(PawnWeapon.m_eScopeType)
                                {
                                    // End:0x727
                                    case 1:
                                        PawnWeapon.GetConfigVals().m_rIronSightsFPMeshRotation.Roll = int(fValue);
                                        // End:0x7E8
                                        break;
                                    // End:0x754
                                    case 2:
                                        PawnWeapon.GetConfigVals().m_rReflexSightsFPMeshRotation.Roll = int(fValue);
                                        // End:0x7E8
                                        break;
                                    // End:0x781
                                    case 3:
                                        PawnWeapon.GetConfigVals().m_rRifleScopeFPMeshRotation.Roll = int(fValue);
                                        // End:0x7E8
                                        break;
                                    // End:0x7AE
                                    case 4:
                                        PawnWeapon.GetConfigVals().m_rACOGScopeFPMeshRotation.Roll = int(fValue);
                                        // End:0x7E8
                                        break;
                                    // End:0x7B3
                                    case 5:
                                    // End:0x7B8
                                    case 6:
                                    // End:0x7E5
                                    case 7:
                                        PawnWeapon.GetConfigVals().m_rSniperScopeFPMeshRotation.Roll = int(fValue);
                                        // End:0x7E8
                                        break;
                                    // End:0xFFFF
                                    default:
                                        break;
                                }                                
                            }
                            else
                            {
                                PawnWeapon.GetConfigVals().m_rFirstPersonMeshRotation.Roll = int(fValue);
                            }
                        }
                    }
                }
            }            
        }
        else
        {
            // End:0x8BD
            if(int(m_eEditOffsetMode) == int(3))
            {
                Cam = R6Camera(Outer.PlayerCamera);
                // End:0x8BA
                if(Cam != none)
                {
                    // End:0x86E
                    if(iAxis == 0)
                    {
                        Cam.m_vDebugCamOffset.X = fValue;                        
                    }
                    else
                    {
                        // End:0x895
                        if(iAxis == 1)
                        {
                            Cam.m_vDebugCamOffset.Y = fValue;                            
                        }
                        else
                        {
                            // End:0x8BA
                            if(iAxis == 2)
                            {
                                Cam.m_vDebugCamOffset.Z = fValue;
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0xC31
                if((int(m_eEditOffsetMode) >= int(4)) && int(m_eEditOffsetMode) <= int(7))
                {
                    // End:0xC31
                    if((PlayerPawn != none) && PawnWeapon != none)
                    {
                        // End:0xA73
                        if(iAxis == 0)
                        {
                            // End:0x9C5
                            if(!PawnWeapon.IsScoping())
                            {
                                switch(m_eEditOffsetMode)
                                {
                                    // End:0x946
                                    case 4:
                                        PawnWeapon.GetConfigVals().m_iMinPitchLook = int(fValue);
                                        // End:0x9C2
                                        break;
                                    // End:0x96E
                                    case 5:
                                        PawnWeapon.GetConfigVals().m_iMinYawLook = int(fValue);
                                        // End:0x9C2
                                        break;
                                    // End:0x994
                                    case 6:
                                        PawnWeapon.GetConfigVals().m_fLookRecoveryDampFactor = fValue;
                                        // End:0x9C2
                                        break;
                                    // End:0x9BF
                                    case 7:
                                        PawnWeapon.GetConfigVals().m_vLookPivotOffset.X = fValue;
                                        // End:0x9C2
                                        break;
                                    // End:0xFFFF
                                    default:
                                        break;
                                }                                
                            }
                            else
                            {
                                switch(m_eEditOffsetMode)
                                {
                                    // End:0x9F4
                                    case 4:
                                        PawnWeapon.GetConfigVals().m_iScopeMinPitchLook = int(fValue);
                                        // End:0xA70
                                        break;
                                    // End:0xA1C
                                    case 5:
                                        PawnWeapon.GetConfigVals().m_iScopeMinYawLook = int(fValue);
                                        // End:0xA70
                                        break;
                                    // End:0xA42
                                    case 6:
                                        PawnWeapon.GetConfigVals().m_fScopeLookRecoveryDampFactor = fValue;
                                        // End:0xA70
                                        break;
                                    // End:0xA6D
                                    case 7:
                                        PawnWeapon.GetConfigVals().m_vScopeLookPivotOffset.X = fValue;
                                        // End:0xA70
                                        break;
                                    // End:0xFFFF
                                    default:
                                        break;
                                }
                            }                            
                        }
                        else
                        {
                            // End:0xBA3
                            if(iAxis == 1)
                            {
                                // End:0xB1B
                                if(!PawnWeapon.IsScoping())
                                {
                                    switch(m_eEditOffsetMode)
                                    {
                                        // End:0xAC2
                                        case 4:
                                            PawnWeapon.GetConfigVals().m_iMaxPitchLook = int(fValue);
                                            // End:0xB18
                                            break;
                                        // End:0xAEA
                                        case 5:
                                            PawnWeapon.GetConfigVals().m_iMaxYawLook = int(fValue);
                                            // End:0xB18
                                            break;
                                        // End:0xB15
                                        case 7:
                                            PawnWeapon.GetConfigVals().m_vLookPivotOffset.Y = fValue;
                                            // End:0xB18
                                            break;
                                        // End:0xFFFF
                                        default:
                                            break;
                                    }                                    
                                }
                                else
                                {
                                    switch(m_eEditOffsetMode)
                                    {
                                        // End:0xB4A
                                        case 4:
                                            PawnWeapon.GetConfigVals().m_iScopeMaxPitchLook = int(fValue);
                                            // End:0xBA0
                                            break;
                                        // End:0xB72
                                        case 5:
                                            PawnWeapon.GetConfigVals().m_iScopeMaxYawLook = int(fValue);
                                            // End:0xBA0
                                            break;
                                        // End:0xB9D
                                        case 7:
                                            PawnWeapon.GetConfigVals().m_vScopeLookPivotOffset.Y = fValue;
                                            // End:0xBA0
                                            break;
                                        // End:0xFFFF
                                        default:
                                            break;
                                    }
                                }                                
                            }
                            else
                            {
                                // End:0xC31
                                if(iAxis == 2)
                                {
                                    // End:0xBFC
                                    if(!PawnWeapon.IsScoping())
                                    {
                                        switch(m_eEditOffsetMode)
                                        {
                                            // End:0xBF6
                                            case 7:
                                                PawnWeapon.GetConfigVals().m_vLookPivotOffset.Z = fValue;
                                                // End:0xBF9
                                                break;
                                            // End:0xFFFF
                                            default:
                                                break;
                                        }                                        
                                    }
                                    else
                                    {
                                        switch(m_eEditOffsetMode)
                                        {
                                            // End:0xC2E
                                            case 7:
                                                PawnWeapon.GetConfigVals().m_vScopeLookPivotOffset.Z = fValue;
                                                // End:0xC31
                                                break;
                                            // End:0xFFFF
                                            default:
                                                break;
                                        }
                                    }
                                }
                                else
                                {
                                }
                            }
                        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0xA73! */
                    }
                }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x8BD! */
            }
        }
        return;
    }
}

exec function ReloadCameraTree()
{
    R6Camera(Outer.PlayerCamera).ReReadTree();
    return;
}

exec function TestTakeCoverCam()
{
    // End:0x108
    if(R6Camera(Outer.PlayerCamera) != none)
    {
        // End:0xB2
        if(R6Camera(Outer.PlayerCamera).m_pTreeTemplate == R6Camera(Outer.PlayerCamera).default.m_pTreeTemplate)
        {
            R6Camera(Outer.PlayerCamera).m_pTreeTemplate = R6CameraTree(DynamicLoadObject("TestTakeCoverCameraTrees.PlayerCameraTree", Class'R6CameraTree'));            
        }
        else
        {
            R6Camera(Outer.PlayerCamera).m_pTreeTemplate = R6Camera(Outer.PlayerCamera).default.m_pTreeTemplate;
        }
        R6Camera(Outer.PlayerCamera).ReReadTree();
    }
    return;
}

exec function SetAr43()
{
    local R6Camera Camera;

    Camera = R6Camera(Outer.PlayerCamera);
    Camera.m_bUseOverride = true;
    Camera.m_bOverrideConstrainAspectRatio = true;
    Camera.m_fOverrideConstrainedAspectRatio = 4.0000000 / 3.0000000;
    return;
}

exec function SetAr169()
{
    local R6Camera Camera;

    Camera = R6Camera(Outer.PlayerCamera);
    Camera.m_bUseOverride = true;
    Camera.m_bOverrideConstrainAspectRatio = true;
    Camera.m_fOverrideConstrainedAspectRatio = 16.0000000 / 9.0000000;
    return;
}

exec function SetArDefault()
{
    local R6Camera Camera;

    Camera = R6Camera(Outer.PlayerCamera);
    Camera.m_bUseOverride = false;
    return;
}

exec function SetMentalStateIdle(name PawnName, int iState)
{
    local R6Pawn aPawn;

    // End:0xA0
    if(Len(string(PawnName)) != 0)
    {
        // End:0x9F
        foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
        {
            // End:0x9E
            if(aPawn.Name == PawnName)
            {
                // End:0x5F
                if(iState == 0)
                {
                    aPawn.m_eCurrentMentalStateIdle = 0;                    
                }
                else
                {
                    // End:0x7E
                    if(iState == 1)
                    {
                        aPawn.m_eCurrentMentalStateIdle = 1;                        
                    }
                    else
                    {
                        // End:0x9B
                        if(iState == 2)
                        {
                            aPawn.m_eCurrentMentalStateIdle = 2;
                        }
                    }
                }
                // End:0x9F
                break;
            }            
        }        
    }
    return;
}

exec function SetMentalStateTransition(name PawnName, int iState)
{
    local R6Pawn aPawn;

    // End:0xA0
    if(Len(string(PawnName)) != 0)
    {
        // End:0x9F
        foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
        {
            // End:0x9E
            if(aPawn.Name == PawnName)
            {
                // End:0x5F
                if(iState == 0)
                {
                    aPawn.m_eCurrentMentalStateTransition = 0;                    
                }
                else
                {
                    // End:0x7E
                    if(iState == 1)
                    {
                        aPawn.m_eCurrentMentalStateTransition = 1;                        
                    }
                    else
                    {
                        // End:0x9B
                        if(iState == 2)
                        {
                            aPawn.m_eCurrentMentalStateTransition = 2;
                        }
                    }
                }
                // End:0x9F
                break;
            }            
        }        
    }
    return;
}

exec function DisableAnim()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bForceNoAnim = !aPawn.m_bForceNoAnim;        
    }    
    return;
}

exec function ActivateTickAnimOpt()
{
    local R6Pawn aPawn;

    // End:0x3B
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        aPawn.m_bTickAnimOptActive = !aPawn.m_bTickAnimOptActive;        
    }    
    return;
}

exec function ToggleFriendlyFire()
{
    // End:0x49
    if(R6MultiPlayerGame(Outer.WorldInfo.Game) != none)
    {
        R6MultiPlayerGame(Outer.WorldInfo.Game).ToggleFF();
    }
    return;
}

exec function ToggleLaunch()
{
    // End:0x71
    if(R6MultiPlayerGame(Outer.WorldInfo.Game) != none)
    {
        R6MultiPlayerGame(Outer.WorldInfo.Game).m_bHACKLaunchRestrictions = !R6MultiPlayerGame(Outer.WorldInfo.Game).m_bHACKLaunchRestrictions;
    }
    return;
}

exec function LogMultiplayerGameInfo()
{
    local R6GameReplicationInfo myGRI;

    myGRI = R6GameReplicationInfo(Outer.WorldInfo.GRI);
    LogInternal("========================");
    LogInternal("Multiplayer informations");
    LogInternal("-----");
    LogInternal("m_bTeamGame=" @ string(myGRI.m_bTeamGame));
    LogInternal("m_iTimeLimitSeconds=" @ string(myGRI.m_iTimeLimitSeconds));
    LogInternal("ElapsedTime" @ string(myGRI.ElapsedTime));
    LogInternal("RemainingTime" @ string(myGRI.RemainingTime));
    LogInternal("m_iTimeMatchStarting=" @ string(myGRI.m_iTimeMatchStarting));
    LogInternal("m_eCurrentGameMode=" @ string(myGRI.m_eCurrentGameMode));
    LogInternal("m_eCurrentGameType=" @ string(myGRI.m_eCurrentGameType));
    LogInternal("m_eCurrentGameStatus=" @ string(myGRI.m_eCurrentGameStatus));
    LogInternal("m_iRounds=" @ string(myGRI.m_iRounds));
    LogInternal("m_iCurrentRound=" @ string(myGRI.m_iCurrentRound));
    LogInternal("m_bAllowRespawn=" @ string(myGRI.m_bAllowRespawn));
    LogInternal("m_bAllowTeamRespawn=" @ string(myGRI.m_bAllowTeamRespawn));
    LogInternal("m_bAllowTeamKillerPenalty=" @ string(myGRI.m_bAllowTeamKillerPenalty));
    LogInternal("m_bAllowIncapacitation=" @ string(myGRI.m_bAllowIncapacitation));
    LogInternal("m_iTimeBetweenRound=" @ string(myGRI.m_iTimeBetweenRound));
    LogInternal("m_bBalanceTeams=" @ string(myGRI.m_bBalanceTeams));
    LogInternal("m_bFriendlyFire=" @ string(myGRI.m_bFriendlyFire));
    LogInternal("m_bDedicatedServer=" @ string(myGRI.m_bDedicatedServer));
    LogInternal("m_byMaxPlayers=" @ string(myGRI.m_byMaxPlayers));
    LogInternal("m_fstrMapList=" @ myGRI.m_fstrMapList);
    LogInternal("m_bPunkBuster=" @ string(myGRI.m_bPunkBuster));
    LogInternal("-----");
    return;
}

exec function LogTeamMembers()
{
    LogTeamMembersInformation();
    return;
}

exec function ServerListen(optional int iMode)
{
    StartServer(true, "TestMultiplayer", iMode);
    return;
}

exec function ServerDedicated(optional int iMode)
{
    StartServer(false, "TestMultiplayer", iMode);
    return;
}

exec function ServerListenMap(string MapName, optional int iMode)
{
    StartServer(true, MapName, iMode);
    return;
}

exec function ServerDedicatedMap(string MapName, optional int iMode)
{
    StartServer(false, MapName, iMode);
    return;
}

exec function StartServer(bool bListen, string MapName, int iMode)
{
    local string strCommand;
    local R6EngineEnums.EGameMode eMode;

    // End:0x1D
    if(!bListen)
    {
        strCommand = "SERVER ";        
    }
    else
    {
        strCommand = "START ";
    }
    // End:0x4C
    if(MapName != "")
    {        
        strCommand $= MapName;        
    }
    else
    {        
        strCommand $= "TestMultiplayer";
    }
    // End:0x89
    if(bListen)
    {        
        strCommand $= "?LISTEN";
    }    
    strCommand $= "?GAME=";
    // End:0xB4
    if(iMode == 1)
    {
        eMode = 2;        
    }
    else
    {
        // End:0xCB
        if(iMode == 2)
        {
            eMode = 4;            
        }
        else
        {
            // End:0xE2
            if(iMode == 3)
            {
                eMode = 1;                
            }
            else
            {
                // End:0xF9
                if(iMode == 4)
                {
                    eMode = 6;                    
                }
                else
                {
                    // End:0x110
                    if(iMode == 5)
                    {
                        eMode = 18;                        
                    }
                    else
                    {
                        // End:0x127
                        if(iMode == 6)
                        {
                            eMode = 8;                            
                        }
                        else
                        {
                            // End:0x13E
                            if(iMode == 7)
                            {
                                eMode = 7;                                
                            }
                            else
                            {
                                eMode = 13;
                            }
                        }
                    }
                }
            }
        }
    }    
    strCommand $= Outer.GetGameManager().FindGameModeClass(eMode, false);    
    Outer.ConsoleCommand(strCommand, true);
    return;
}

// Export UR6CheatManager::execSetInvertControllers(FFrame&, void* const)
native exec function SetInvertControllers(bool bInvert);

exec function ToggleCyclePawns()
{
    local R6Camera Cam;
    local R6Pawn pPawn;

    // End:0x2C
    if((Outer.PlayerCamera == none) || Outer.Pawn == none)
    {
        return;
    }
    pPawn = R6Pawn(Outer.Pawn);
    // End:0x85
    if(pPawn.Controller.IsInState('PlayerOnTransition') || pPawn.Controller.IsInState('PlayerOnMoveTransition'))
    {
        return;
    }
    Cam = R6Camera(Outer.PlayerCamera);
    Cam.m_bCycleMode = !Cam.m_bCycleMode;
    // End:0x124
    if(Cam.m_bCycleMode)
    {
        pPawn.Controller.GotoState('CheatCyclePawns');
        // End:0x11A
        if(m_ControllerIterCamera != none)
        {
            Cam.SetViewTarget(m_ControllerIterCamera.Pawn);            
        }
        else
        {
            NextPawnCameraLookAt();
        }        
    }
    else
    {
        Cam.SetViewTarget(pPawn);
        R6PlayerController(pPawn.Controller).ReturnFromInteractState();
    }
    return;
}

exec function NextPawnCameraLookAt()
{
    local R6Camera Cam;

    // End:0x2C
    if((Outer.PlayerCamera == none) || Outer.Pawn == none)
    {
        return;
    }
    Cam = R6Camera(Outer.PlayerCamera);
    // End:0x6D
    if(!Cam.m_bCycleMode)
    {
        SetCamMode("THIRDFREE");
        return;
    }
    // End:0x8C
    if(m_ControllerIterCamera != none)
    {
        m_ControllerIterCamera = m_ControllerIterCamera.NextController;
    }
    // End:0xB4
    if(m_ControllerIterCamera == none)
    {
        m_ControllerIterCamera = Outer.WorldInfo.ControllerList;
    }
    J0xB4:

    // End:0xEC [Loop If]
    if((m_ControllerIterCamera != none) && m_ControllerIterCamera.Pawn == none)
    {
        m_ControllerIterCamera = m_ControllerIterCamera.NextController;
        // [Loop Continue]
        goto J0xB4;
    }
    // End:0x12F
    if((m_ControllerIterCamera != none) && m_ControllerIterCamera.Pawn != none)
    {
        Cam.SetViewTarget(m_ControllerIterCamera.Pawn);        
    }
    else
    {
        ToggleCyclePawns();
    }
    return;
}

exec function PrevPawnCameraLookAt()
{
    local Controller ControllerIter, LastGood;
    local R6Camera Cam;

    // End:0x2C
    if((Outer.PlayerCamera == none) || Outer.Pawn == none)
    {
        return;
    }
    Cam = R6Camera(Outer.PlayerCamera);
    // End:0x69
    if(!Cam.m_bCycleMode)
    {
        SetCamMode("THIRD");
        return;
    }
    // End:0x91
    if(m_ControllerIterCamera == Outer.WorldInfo.ControllerList)
    {
        m_ControllerIterCamera = none;
    }
    // End:0xFC
    foreach Outer.WorldInfo.AllControllers(Class'Engine.Controller', ControllerIter)
    {
        // End:0xD5
        if(ControllerIter.Pawn != none)
        {
            LastGood = ControllerIter;
        }
        // End:0xFB
        if(ControllerIter.NextController == m_ControllerIterCamera)
        {
            m_ControllerIterCamera = LastGood;
            // End:0xFC
            break;
        }        
    }    
    // End:0x1E0
    if((m_ControllerIterCamera != none) && m_ControllerIterCamera.Pawn == none)
    {
        LogInternal("Didn't find a good one");
        m_ControllerIterCamera = none;
        // End:0x1DF
        foreach Outer.WorldInfo.AllControllers(Class'Engine.Controller', ControllerIter)
        {
            // End:0x1A1
            if(ControllerIter.Pawn != none)
            {
                LogInternal("This is good " $ string(ControllerIter));
                LastGood = ControllerIter;
            }
            // End:0x1DE
            if(ControllerIter.NextController == m_ControllerIterCamera)
            {
                LogInternal("Setting " $ string(LastGood));
                m_ControllerIterCamera = LastGood;
                // End:0x1DF
                break;
            }            
        }        
    }
    // End:0x223
    if((m_ControllerIterCamera != none) && m_ControllerIterCamera.Pawn != none)
    {
        Cam.SetViewTarget(m_ControllerIterCamera.Pawn);        
    }
    else
    {
        ToggleCyclePawns();
    }
    return;
}

exec function LockAimRotation()
{
    m_bLockAimRotation = !m_bLockAimRotation;
    LogInternal("LockAimRotation" @ string(m_bLockAimRotation));
    return;
}

exec function ToggleShowHealthState()
{
    m_bShowHealthState = !m_bShowHealthState;
    return;
}

exec function ToggleShowArmorInfo()
{
    m_bShowArmorInfo = !m_bShowArmorInfo;
    return;
}

// Export UR6CheatManager::execFreeCamSet(FFrame&, void* const)
native final function FreeCamSet(PlayerController pController, bool bEnable);

exec function FreeCam()
{
    local R6Pawn pPawn, pCameraPawn;
    local PlayerController pController;

    pPawn = R6Pawn(Outer.Pawn);
    pController = PlayerController(Outer.Pawn.Controller);
    // End:0xEE
    if(m_pFreeCamController != none)
    {
        FreeCamSet(pController, false);
        m_pFreeCamController.Pawn.Destroy();
        m_pFreeCamController.myHUD.Destroy();
        m_pFreeCamController.Destroy();
        m_pFreeCamController = none;
        Outer.bCheatFlying = false;
        R6Pawn(Outer.Pawn).m_iForceComponentsVisibility = 0;
        Outer.ClientMessage("Free Camera Mode Disabled");        
    }
    else
    {
        FreeCamSet(pController, true);
        pCameraPawn = Outer.__NFUN_278__(Class'R6Pawn',,, pPawn.Location, pPawn.Rotation, none, true);
        m_pFreeCamController.SpawnDefaultHUD();
        m_pFreeCamController.Possess(pCameraPawn, false);
        m_pFreeCamController.GotoState('PlayerFlying');
        pCameraPawn.CheatGhost();
        pCameraPawn.SetPhysics(4);
        pCameraPawn.m_bStealth = true;
        R6Pawn(Outer.Pawn).m_iForceComponentsVisibility = 2;
        Outer.bCheatFlying = true;
        m_pFreeCamController.ClientMessage("Free Camera Mode Enabled");
    }
    return;
}

exec function FreeCamMovePlayer()
{
    local LocalPlayer pPlayer;
    local PlayerController pController;

    // End:0xE0
    if(m_pFreeCamController != none)
    {
        pController = PlayerController(Outer.Pawn.Controller);
        // End:0xE0
        if(pController != none)
        {
            pPlayer = LocalPlayer(pController.Player);
            // End:0xA3
            if(pPlayer.m_pRedirectInput != none)
            {
                pPlayer.m_pRedirectInput = none;
                m_pFreeCamController.ClientMessage("Camera Movement Enabled");                
            }
            else
            {
                pPlayer.m_pRedirectInput = pController;
                m_pFreeCamController.ClientMessage("Pawn Movement Enabled");
            }
        }
    }
    return;
}

exec function ShowNMPortal()
{
    Outer.ConsoleCommand("show Debug");    
    Outer.ConsoleCommand("show Navmesh");
    Outer.WorldInfo.super(R6CheatManager).ShowNMPortal();
    return;
}

exec function TogglePlayerLookAt()
{
    // End:0x3D
    if(m_bDisablePlayerLookAt)
    {
        Outer.ClientMessage("Player LookAt Enabled");
        m_bDisablePlayerLookAt = false;        
    }
    else
    {
        Outer.ClientMessage("Player LookAt Disabled");
        m_bDisablePlayerLookAt = true;
    }
    return;
}

exec function SwitchMood()
{
    local R6Pawn aPawn;
    local Pawn closest;
    local R6AIController pAI;

    closest = ClosestReticulePawn();
    // End:0x88
    foreach Outer.DynamicActors(Class'R6Pawn', aPawn)
    {
        // End:0x87
        if((aPawn != Outer.Pawn) && aPawn == closest)
        {
            // End:0x87
            if(R6RainbowPawn(aPawn) != none)
            {
                pAI = R6AIController(aPawn.Controller);
                pAI.DEBUG_SwitchMood();
            }
        }        
    }    
    return;
}

exec function CheatMoreTime()
{
    local R6GameReplicationInfo myGRI;

    myGRI = R6GameReplicationInfo(Outer.WorldInfo.GRI);
    // End:0x42
    if(myGRI != none)
    {
        myGRI.RemainingTime += 1200;
    }
    return;
}

// Export UR6CheatManager::execDebugAnimTreePool(FFrame&, void* const)
native exec function DebugAnimTreePool();

// Export UR6CheatManager::execDebugEmitterPool(FFrame&, void* const)
native exec function DebugEmitterPool();

// Export UR6CheatManager::execLimitEmitterPool(FFrame&, void* const)
native exec function LimitEmitterPool(int iLimit);

// Export UR6CheatManager::execDebugAudioComponentPool(FFrame&, void* const)
native exec function DebugAudioComponentPool();

exec function DebugThrow()
{
    m_bDebugThrow = !m_bDebugThrow;
    return;
}

exec function ToggleRainbowBloodStains()
{
    local R6RainbowManager R6Rainbow;

    R6Rainbow = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pRainbowAIManager;
    // End:0x80
    if(R6Rainbow.m_bAllowBloodStains)
    {
        R6Rainbow.m_bAllowBloodStains = false;
        LogInternal("Blood Stains On Rainbow DISABLED");        
    }
    else
    {
        R6Rainbow.m_bAllowBloodStains = true;
        LogInternal("Blood Stains On Rainbow ENABLED");
    }
    return;
}

exec function DebugLit()
{
    m_bLitValues = !m_bLitValues;
    return;
}

exec function DebugSounds()
{
    m_bTrackAISounds = !m_bTrackAISounds;
    // End:0x22
    if(!m_bTrackAISounds)
    {
        m_AISounds.Length = 0;
    }
    return;
}

exec function DebugTHP()
{
    local R6TerroHuntManager TerroHuntManager;

    TerroHuntManager = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pTerroHuntManager;
    TerroHuntManager.m_bTHPDebug = !TerroHuntManager.m_bTHPDebug;
    return;
}

exec function DebugPAM()
{
    local R6AIPawnActivationManager AIPawnActivationManager;

    AIPawnActivationManager = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIPawnActivationManager;
    AIPawnActivationManager.m_bDebugPAM = !AIPawnActivationManager.m_bDebugPAM;
    return;
}

exec function TogglePAM()
{
    local R6AIPawnActivationManager AIPawnActivationManager;

    AIPawnActivationManager = R6GameInfo(Outer.WorldInfo.Game).m_pAIInfo.m_pAIPawnActivationManager;
    AIPawnActivationManager.m_bIsActivated = !AIPawnActivationManager.m_bIsActivated;
    return;
}

// Export UR6CheatManager::execTakeCoverDOF(FFrame&, void* const)
native exec function TakeCoverDOF();

exec function CheatCycleMenuPawnAnim()
{
    local R6MenuPawn pR6MenuPawn;

    pR6MenuPawn = R6MenuPawn(Outer.Pawn);
    // End:0x59
    if(pR6MenuPawn != none)
    {
        pR6MenuPawn.m_iDebugAnimations++;
        // End:0x59
        if(pR6MenuPawn.m_iDebugAnimations > 3)
        {
            pR6MenuPawn.m_iDebugAnimations = 0;
        }
    }
    return;
}

exec function SetDifficultyLevel(int I)
{
    Outer.GetGameManager().SetGameDifficulty(byte(I));
    LogInternal("SetDifficultyLevel" @ string(GetEnum(Enum'Engine.R6EngineEnums.EGameDifficulty', I)));
    return;
}

// Export UR6CheatManager::execToggleTutorial(FFrame&, void* const)
native exec function ToggleTutorial();

// Export UR6CheatManager::execSetRumble(FFrame&, void* const)
native exec function SetRumble(int iSample, int eLeftFunction, int iLeftAmplitude, int eRightFunction, int iRightAmplitude, float fDuration, string Type);

exec function DrawReticleCenter()
{
    m_bDrawReticleCenter = !m_bDrawReticleCenter;
    return;
}

exec function ToggleMassiveDebug()
{
    m_bMassiveDbgOutput = !m_bMassiveDbgOutput;
    return;
}

exec function TeleportToActor(string szActorName)
{
    local Actor aActor;

    // End:0x5B
    foreach Outer.AllActors(Class'Engine.Actor', aActor)
    {
        // End:0x5A
        if(aActor.Name == name(szActorName))
        {
            Outer.ViewTarget.SetLocation(aActor.Location);            
            return;
        }        
    }    
    return;
}

defaultproperties
{
    m_bOcclusion=true
    m_bCOMBalance=true
    m_iCurrentSelectedWeapon=-1
    m_iCurrentSelectedGadget=-1
    m_asWeapons[0]="R6Game.R6Pistol92FS"
    m_asWeapons[1]="R6Game.R6PistolDesertEagle"
    m_asWeapons[2]="R6Game.R6PistolGlock18"
    m_asWeapons[3]="R6Game.R6PistolMK23"
    m_asWeapons[4]="R6Game.R6PistolRagingBull"
    m_asWeapons[5]="R6Game.R6PistolUSP40"
    m_asWeapons[6]="R6Game.R6AssaultM8"
    m_asWeapons[7]="R6Game.R6AssaultG36C"
    m_asWeapons[8]="R6Game.R6AssaultMTAR21"
    m_asWeapons[9]="R6Game.R6AssaultFamas"
    m_asWeapons[10]="R6Game.R6AssaultAK47"
    m_asWeapons[11]="R6Game.R6AssaultSCARHCQC"
    m_asWeapons[12]="R6Game.R6AssaultAUGA3"
    m_asWeapons[13]="R6Game.R6AssaultG3KA4"
    m_asWeapons[14]="R6Game.R6Assault552Commando"
    m_asWeapons[15]="R6Game.R6SniperPSG1"
    m_asWeapons[16]="R6Game.R6SniperM40A1"
    m_asWeapons[17]="R6Game.R6SniperSV98"
    m_asWeapons[18]="R6Game.R6SniperScoutTactical"
    m_asWeapons[19]="R6Game.R6ShotgunM3"
    m_asWeapons[20]="R6Game.R6ShotgunSpas12"
    m_asWeapons[21]="R6Game.R6Shotgun870MCS"
    m_asWeapons[22]="R6Game.R6ShotgunXM26LSS"
    m_asWeapons[23]="R6Game.R6LMGMK46"
    m_asWeapons[24]="R6Game.R6LMG21E"
    m_asWeapons[25]="R6Game.R6LMGM249SPW"
    m_asWeapons[26]="R6Game.R6LMGMG36"
    m_asWeapons[27]="R6Game.R6SubMP5N"
    m_asWeapons[28]="R6Game.R6SubMP7A1"
    m_asWeapons[29]="R6Game.R6SubUMP45"
    m_asWeapons[30]="R6Game.R6SubP90"
    m_asWeapons[31]="R6Game.R6SubMP9"
    m_asWeapons[32]="R6Game.R6SubMAC11"
    m_asWeapons[33]="R6Game.R6Shield"
    m_asGadgets[0]="R6Game.R6GadgetGrenadeFlashbang"
    m_asGadgets[1]="R6Game.R6GadgetGrenadeFrag"
    m_asGadgets[2]="R6Game.R6GadgetGrenadeIncendiary"
    m_asGadgets[3]="R6Game.R6GadgetGrenadeSmoke"
    m_asGadgets[4]="R6Game.R6GadgetGrenadeTearGas"
    m_asGadgets[5]="R6Game.R6GadgetExplosiveBreaching"
    m_asGadgets[6]="R6Game.R6GadgetExplosiveDemolition"
    m_asGadgets[7]="R6Game.R6GadgetMotionSensor"
    m_asGadgets[8]="R6Game.R6GadgetGasMask"
    m_asGadgets[9]="R6Game.R6GasMaskSF10"
    m_asCharacters[0]="R6Game.R6RainbowPawn"
    m_asCharacters[1]="R6Game.R6RainbowPawnBrody"
    m_asCharacters[2]="R6Game.R6RainbowPawnGabriel"
    m_asCharacters[3]="R6Game.R6RainbowPawnJoanna"
    m_asCharacters[4]="R6Game.R6RainbowPawnJung"
    m_asCharacters[5]="R6Game.R6RainbowPawnKan"
    m_asCharacters[6]="R6Game.R6RainbowPawnMichael"
    m_asCharacters[7]="R6Game.R6TerroristPawn"
    m_asCharacters[8]="R6Game.R6TerroristMex"
    m_asCharacters[9]="R6Game.R6TerroristRussian"
    m_asCharacters[10]="R6Game.R6CivilPawn"
    m_asCharacters[11]="R6Game.R6HostagePawn"
    m_fShakeStrength=1.0000000
    m_fPropEditModif=1.0000000
    m_fFPMeshTranslationModifier=0.5000000
    m_iFPMeshRotationModifier=50
    m_fCameraTranslationModifier=5.0000000
    m_iLookLimitModifier=50
    m_fLookModifier=0.5000000
}