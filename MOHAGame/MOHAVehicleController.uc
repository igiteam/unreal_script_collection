class MOHAVehicleController extends AIController
    native
    hidecategories(Navigation);

enum EVehicleWeaponTargetingMode
{
    WEAPON_TARGETING_NONE,          // 0
    WEAPON_TARGETING_PLAYER_ONLY,   // 1
    WEAPON_TARGETING_ALL_ENEMIES,   // 2
    WEAPON_TARGETING_ALL_ENEMIES_EXCEPT_PLAYER,// 3
    WEAPON_TARGETING_FORCED_KISMET, // 4
    WEAPON_TARGETING_MAX            // 5
};

struct native VehicleWeaponTargetInfo
{
    var Actor WeapTarget;
    var Vector vLastKnownPos;
    var float fLastEnemySearchTime;
    var float fTimeWithoutReachableTarget;
    var float fTimeWithLOS;
    var bool bHasLOS;
    var bool bEngagingEnemy;
    var() MOHAVehicleController.EVehicleWeaponTargetingMode TargetingMode;
    var() bool TargetButDontFire;
    var() bool StopWhenEngagingVisiblePlayer;
    var() bool TurnTowardsPlayerWhenStopped;

    structdefaultproperties
    {
        WeapTarget=none
        vLastKnownPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        fLastEnemySearchTime=0.0000000
        fTimeWithoutReachableTarget=0.0000000
        fTimeWithLOS=0.0000000
        bHasLOS=false
        bEngagingEnemy=false
        TargetingMode=2
        TargetButDontFire=false
        StopWhenEngagingVisiblePlayer=false
        TurnTowardsPlayerWhenStopped=false
    }
};

var array<VehicleWeaponTargetInfo> TargetInfo;
var bool bBraking;
var bool bStopped;
var bool bSteeringTowardsEnemy;
var float fCurrentBrakeTime;
var MOHAVehiclePathPoint nextPoint;
var() float fMaxTimeWithoutReachableTarget;
var() float fMinTimeBetweenEnemySearches;
var() float fMinYawToStartTurning;
var() float fFireWithoutLOSTime;
var() float fReactionTimeToLOS;

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super(Controller).Possess(inPawn, bVehicleTransition);
    TargetInfo.Length = MOHAVehicle(Pawn).GetNumWeapons();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x63
    if((MOHAVehicle(Pawn) != none) && MOHAVehicle(Pawn).Health > 0)
    {
        UpdateWeaponTargets(DeltaTime);
        UpdateLastKnownTargetPositions(DeltaTime);
        EngageEnemies(DeltaTime);
    }
    //return;    
}

simulated event bool ShouldBrakeVehicle()
{
    local bool bStopVehicleToEngagePlayer;
    local int I;

    // End:0x2B
    if((MOHAVehicle(Pawn) != none) && MOHAVehicle(Pawn).bImmobile)
    {
        return true;
    }
    bStopVehicleToEngagePlayer = false;
    I = 0;
    J0x3A:

    // End:0xD0 [Loop If]
    if(I < TargetInfo.Length)
    {
        // End:0xC6
        if(((TargetInfo[I].StopWhenEngagingVisiblePlayer && TargetInfo[I].bHasLOS) && TargetInfo[I].bEngagingEnemy) && MOHAPlayerPawn(TargetInfo[I].WeapTarget) != none)
        {
            bStopVehicleToEngagePlayer = true;
            // [Explicit Break]
            goto J0xD0;
        }
        I++;
        // [Loop Continue]
        goto J0x3A;
    }
    J0xD0:

    return (bBraking || bStopped) || bStopVehicleToEngagePlayer;
    //return ReturnValue;    
}

simulated event bool ShouldSteerTowardsPlayer(out float fRelativeYaw)
{
    local int I;
    local Actor SteeringTarget;
    local Rotator rRotationToTarget;

    // End:0x2B
    if((MOHAVehicle(Pawn) == none) || MOHAVehicle(Pawn).bImmobile)
    {
        return false;
    }
    // End:0xBF
    if((ScriptedMoveTarget == none) || ShouldBrakeVehicle())
    {
        I = 0;
        J0x4C:

        // End:0xBF [Loop If]
        if(I < TargetInfo.Length)
        {
            // End:0xB5
            if(TargetInfo[I].TurnTowardsPlayerWhenStopped && MOHAPlayerPawn(TargetInfo[I].WeapTarget) != none)
            {
                SteeringTarget = TargetInfo[I].WeapTarget;
                // [Explicit Break]
                goto J0xBF;
            }
            I++;
            // [Loop Continue]
            goto J0x4C;
        }
    }
    J0xBF:

    // End:0x182
    if(SteeringTarget != none)
    {
        rRotationToTarget = Rotator(SteeringTarget.Location - Pawn.Location);
        fRelativeYaw = float(NormalizeRotAxis(rRotationToTarget.Yaw - Pawn.Rotation.Yaw));
        // End:0x150
        if(!bSteeringTowardsEnemy && Abs(fRelativeYaw) > fMinYawToStartTurning)
        {
            bSteeringTowardsEnemy = true;            
        }
        else
        {
            // End:0x177
            if(bSteeringTowardsEnemy && Abs(fRelativeYaw) > 300.0000000)
            {
                bSteeringTowardsEnemy = true;                
            }
            else
            {
                bSteeringTowardsEnemy = false;
            }
        }        
    }
    else
    {
        bSteeringTowardsEnemy = false;
    }
    return bSteeringTowardsEnemy;
    //return ReturnValue;    
}

function bool IsWeaponEnabled(int I)
{
    return MOHAVehicle(Pawn).WeaponEnabled(I);
    //return ReturnValue;    
}

function bool GetTurretRootPos(int I, out Vector vTurretRootPos)
{
    return MOHAVehicle(Pawn).GetAimSocketPos(I, vTurretRootPos);
    //return ReturnValue;    
}

function UpdateWeaponTargets(float DeltaTime)
{
    local int I, iNumWeapons;
    local bool bNeedTarget, bTargetDead, bMultipleTargetsPossible, bMaxTimeWithoutReachableTarget;
    local MOHAPlayerController PC;
    local MOHAPlayerPawn PlayerPawn;

    iNumWeapons = MOHAVehicle(Pawn).GetNumWeapons();
    PC = Class'MOHAUtilities'.static.GetLocalPlayerController(self);
    PlayerPawn = ((PC != none) ? MOHAPlayerPawn(PC.Pawn) : none);
    I = 0;
    J0x66:

    // End:0x28F [Loop If]
    if((I < iNumWeapons) && I < TargetInfo.Length)
    {
        // End:0x9E
        if(!IsWeaponEnabled(I))
        {
            // [Explicit Continue]
            goto J0x285;
        }
        bNeedTarget = TargetInfo[I].WeapTarget == none;
        bTargetDead = (Pawn(TargetInfo[I].WeapTarget) != none) && Pawn(TargetInfo[I].WeapTarget).Health <= 0;
        bMultipleTargetsPossible = (int(TargetInfo[I].TargetingMode) == int(2)) || int(TargetInfo[I].TargetingMode) == int(3);
        bMaxTimeWithoutReachableTarget = TargetInfo[I].fTimeWithoutReachableTarget > fMaxTimeWithoutReachableTarget;
        // End:0x1EB
        if((bNeedTarget || bTargetDead) || bMultipleTargetsPossible && bMaxTimeWithoutReachableTarget)
        {
            // End:0x1E8
            if(bTargetDead || (WorldInfo.TimeSeconds - TargetInfo[I].fLastEnemySearchTime) > fMinTimeBetweenEnemySearches)
            {
                ChooseBestTarget(I);
            }
            // [Explicit Continue]
            goto J0x285;
        }
        // End:0x285
        if((((TargetInfo[I].WeapTarget != PlayerPawn) && PlayerPawn != none) && int(TargetInfo[I].TargetingMode) == int(2)) && TargetInfo[I].fLastEnemySearchTime > fMinTimeBetweenEnemySearches)
        {
            // End:0x285
            if(CanTargetEnemy(I, PlayerPawn))
            {
                SetWeaponTarget(I, PlayerPawn);
            }
        }
        J0x285:

        I++;
        // [Loop Continue]
        goto J0x66;
    }
    //return;    
}

function UpdateLastKnownTargetPositions(float DeltaTime)
{
    local int I, iNumWeapons;
    local Vector vTargetFeetLocation, vTurretRootPos;
    local Rotator rRequiredRot;
    local bool bTargetingFeet;

    bTargetingFeet = false;
    iNumWeapons = MOHAVehicle(Pawn).GetNumWeapons();
    I = 0;
    J0x2D:

    // End:0x266 [Loop If]
    if((I < iNumWeapons) && I < TargetInfo.Length)
    {
        TargetInfo[I].bHasLOS = false;
        // End:0x209
        if(((TargetInfo[I].WeapTarget != none) && IsWeaponEnabled(I)) && GetTurretRootPos(I, vTurretRootPos))
        {
            // End:0x17C
            if(GetTargetFeetLocation(TargetInfo[I].WeapTarget, vTargetFeetLocation))
            {
                GetDesiredWeaponRotation(rRequiredRot, vTargetFeetLocation, vTurretRootPos);
                // End:0x17C
                if(MOHAVehicle(Pawn).WeaponSupportsRotation(I, rRequiredRot) && HasVisibilityToTarget(TargetInfo[I].WeapTarget, vTurretRootPos, vTargetFeetLocation))
                {
                    TargetInfo[I].bHasLOS = true;
                    TargetInfo[I].vLastKnownPos = vTargetFeetLocation;
                    bTargetingFeet = true;
                }
            }
            // End:0x209
            if(!bTargetingFeet)
            {
                TargetInfo[I].bHasLOS = LineOfSightTo(TargetInfo[I].WeapTarget, vTurretRootPos);
                // End:0x209
                if(TargetInfo[I].bHasLOS)
                {
                    TargetInfo[I].vLastKnownPos = GetWeaponTargetLocation(TargetInfo[I].WeapTarget);
                }
            }
        }
        // End:0x241
        if(TargetInfo[I].bHasLOS)
        {
            TargetInfo[I].fTimeWithLOS += DeltaTime;
            // [Explicit Continue]
            goto J0x25C;
        }
        TargetInfo[I].fTimeWithLOS = 0.0000000;
        J0x25C:

        I++;
        // [Loop Continue]
        goto J0x2D;
    }
    //return;    
}

function bool HasVisibilityToTarget(Actor MyTarget, Vector vStartPos, Vector vEndPos)
{
    local ImpactInfo RealImpact;

    RealImpact = Class'EALAWeapon'.static.CalcWeaponFireNative(Pawn, vStartPos, vEndPos, vect(5.0000000, 5.0000000, 5.0000000));
    return (RealImpact.HitActor == none) || RealImpact.HitActor == MyTarget;
    //return ReturnValue;    
}

function EngageEnemies(float DeltaTime)
{
    local Vector vTurretRootPos, vWeaponLocation;
    local bool bYawAcquired, bPitchAcquired, bTargetInRange, bStopFiring, bWasEngagingEnemy, bStartEngagingEnemy,
	    bContinueEngagingEnemy;

    local float fCurrentYaw, fCurrentPitch, fMaxEngagementDist;
    local int I, iNumWeapons;
    local Rotator GoalWeaponRotation;

    iNumWeapons = MOHAVehicle(Pawn).GetNumWeapons();
    I = 0;
    J0x25:

    // End:0x406 [Loop If]
    if((I < iNumWeapons) && I < TargetInfo.Length)
    {
        bStopFiring = true;
        bWasEngagingEnemy = TargetInfo[I].bEngagingEnemy;
        TargetInfo[I].bEngagingEnemy = false;
        // End:0x3D6
        if(((TargetInfo[I].WeapTarget != none) && IsWeaponEnabled(I)) && GetTurretRootPos(I, vTurretRootPos))
        {
            fMaxEngagementDist = MOHAVehicle(Pawn).GetWeaponEngagementDist(I, MOHAPlayerPawn(TargetInfo[I].WeapTarget) != none);
            vWeaponLocation = MOHAVehicle(Pawn).GetWeaponLocation(I);
            bTargetInRange = VSizeSq(TargetInfo[I].vLastKnownPos - vWeaponLocation) < (fMaxEngagementDist * fMaxEngagementDist);
            bStartEngagingEnemy = ((!bWasEngagingEnemy && bTargetInRange) && TargetInfo[I].bHasLOS) && TargetInfo[I].fTimeWithLOS > fReactionTimeToLOS;
            bContinueEngagingEnemy = (bWasEngagingEnemy && bTargetInRange) && TargetInfo[I].fTimeWithoutReachableTarget < fFireWithoutLOSTime;
            // End:0x34B
            if(bStartEngagingEnemy || bContinueEngagingEnemy)
            {
                GetDesiredWeaponRotation(GoalWeaponRotation, TargetInfo[I].vLastKnownPos, vTurretRootPos);
                MOHAVehicle(Pawn).UpdateWeaponControls(I, float(GoalWeaponRotation.Yaw), float(GoalWeaponRotation.Pitch), DeltaTime, fCurrentYaw, fCurrentPitch);
                bYawAcquired = Abs(float(GoalWeaponRotation.Yaw) - fCurrentYaw) <= (1.0000000 * 182.0000000);
                bPitchAcquired = Abs(float(GoalWeaponRotation.Pitch) - fCurrentPitch) <= (1.0000000 * 182.0000000);
                // End:0x333
                if((bYawAcquired && bPitchAcquired) && !TargetInfo[I].TargetButDontFire)
                {
                    MOHAVehicle(Pawn).FireWeapon(I);
                    bStopFiring = false;
                }
                TargetInfo[I].bEngagingEnemy = true;
            }
            // End:0x3BB
            if((!TargetInfo[I].bHasLOS || !bTargetInRange) || !MOHAVehicle(Pawn).WeaponSupportsRotation(I, GoalWeaponRotation))
            {
                TargetInfo[I].fTimeWithoutReachableTarget += DeltaTime;                
            }
            else
            {
                TargetInfo[I].fTimeWithoutReachableTarget = 0.0000000;
            }
        }
        // End:0x3FC
        if(bStopFiring)
        {
            MOHAVehicle(Pawn).StopFiringWeapon(I);
        }
        I++;
        // [Loop Continue]
        goto J0x25;
    }
    //return;    
}

function GetDesiredWeaponRotation(out Rotator out_GoalRotation, Vector vTargetPos, Vector vWeaponPos)
{
    local Vector vTurretToTarget_WS, vTurretToTarget_AS;

    vTurretToTarget_WS = vTargetPos - vWeaponPos;
    vTurretToTarget_AS = Class'MOHAUtilities'.static.InverseRotateVector(vTurretToTarget_WS, Pawn.Rotation);
    out_GoalRotation = Rotator(Normal(vTurretToTarget_AS));
    //return;    
}

function Vector GetWeaponTargetLocation(Actor ActorTarget)
{
    local Pawn PawnTarget;

    PawnTarget = Pawn(ActorTarget);
    // End:0x32
    if(PawnTarget != none)
    {
        return PawnTarget.GetPawnViewLocation();        
    }
    else
    {
        return ActorTarget.Location;
    }
    //return ReturnValue;    
}

function bool GetTargetFeetLocation(Actor ActorTarget, out Vector vFeetPosition)
{
    local Pawn PawnTarget;

    PawnTarget = Pawn(ActorTarget);
    // End:0x6B
    if((PawnTarget != none) && PawnTarget.CollisionComponent != none)
    {
        vFeetPosition = PawnTarget.Location - (vect(0.0000000, 0.0000000, 0.9500000) * PawnTarget.GetCollisionHeight());
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool HasLineOfSight(Actor Other, int iWeaponIndex)
{
    local Vector vOrigin;

    // End:0x45
    if((MOHAVehicle(Pawn) != none) && MOHAVehicle(Pawn).GetAimSocketPos(iWeaponIndex, vOrigin))
    {
        return LineOfSightTo(Other, vOrigin);
    }
    return false;
    //return ReturnValue;    
}

function bool CanTargetEnemy(int iWeapon, Pawn TargetPawn)
{
    local Rotator rRequiredRot;
    local Vector vTurretRootPos;

    // End:0x96
    if(((MOHAVehicle(Pawn) != none) && MOHAVehicle(Pawn).GetAimSocketPos(iWeapon, vTurretRootPos)) && HasLineOfSight(TargetPawn, iWeapon))
    {
        GetDesiredWeaponRotation(rRequiredRot, GetWeaponTargetLocation(TargetPawn), vTurretRootPos);
        return MOHAVehicle(Pawn).WeaponSupportsRotation(iWeapon, rRequiredRot);
    }
    return false;
    //return ReturnValue;    
}

function SetWeaponTarget(int iWeaponIndex, Actor EnemyTarget)
{
    // End:0x21
    if(TargetInfo[iWeaponIndex].WeapTarget == EnemyTarget)
    {
        return;
    }
    TargetInfo[iWeaponIndex].WeapTarget = EnemyTarget;
    TargetInfo[iWeaponIndex].bEngagingEnemy = false;
    TargetInfo[iWeaponIndex].fTimeWithoutReachableTarget = 0.0000000;
    TargetInfo[iWeaponIndex].fTimeWithLOS = 0.0000000;
    TargetInfo[iWeaponIndex].fLastEnemySearchTime = WorldInfo.TimeSeconds;
    // End:0xD7
    if((MOHAVehicle(Pawn) != none) && MOHAVehicle(Pawn).bDebugVehicles)
    {
    }
    //return;    
}

function SetTargetingMode(int iWeaponIndex, MOHAVehicleController.EVehicleWeaponTargetingMode WeaponMode, Actor EnemyTarget, bool bStopWhenEngagingVisiblePlayer, bool bDontFire, bool bTurnTowardsPlayerWhenStopped)
{
    TargetInfo[iWeaponIndex].TargetingMode = WeaponMode;
    TargetInfo[iWeaponIndex].TargetButDontFire = bDontFire;
    TargetInfo[iWeaponIndex].StopWhenEngagingVisiblePlayer = bStopWhenEngagingVisiblePlayer;
    TargetInfo[iWeaponIndex].TurnTowardsPlayerWhenStopped = bTurnTowardsPlayerWhenStopped;
    // End:0x99
    if(int(WeaponMode) == int(4))
    {
        SetWeaponTarget(iWeaponIndex, EnemyTarget);        
    }
    else
    {
        ChooseBestTarget(iWeaponIndex);
    }
    //return;    
}

function ChooseBestTarget(int iWeaponIndex)
{
    // End:0x33
    if(int(TargetInfo[iWeaponIndex].TargetingMode) == int(0))
    {
        SetWeaponTarget(iWeaponIndex, none);        
    }
    else
    {
        // End:0x74
        if(int(TargetInfo[iWeaponIndex].TargetingMode) == int(1))
        {
            SetWeaponTarget(iWeaponIndex, GetBestPlayerTarget(iWeaponIndex));            
        }
        else
        {
            // End:0xB6
            if(int(TargetInfo[iWeaponIndex].TargetingMode) == int(2))
            {
                SetWeaponTarget(iWeaponIndex, GetBestEnemyTarget(iWeaponIndex));                
            }
            else
            {
                // End:0xF5
                if(int(TargetInfo[iWeaponIndex].TargetingMode) == int(3))
                {
                    SetWeaponTarget(iWeaponIndex, GetBestEnemyTarget(iWeaponIndex, true));
                }
            }
        }
    }
    //return;    
}

function Actor GetBestPlayerTarget(int iWeaponIndex)
{
    local PlayerController PC;

    // End:0x2A
    foreach LocalPlayerControllers(PC)
    {
        // End:0x29
        if(PC != none)
        {            
            return PC.Pawn;
        }        
    }    
    return none;
    //return ReturnValue;    
}

function Actor GetBestEnemyTarget(int iWeaponIndex, optional bool bExcludePlayer = false)
{
    local float fDist, fScore, fBestScore, fBestBackupScore, fMaxEngagementDist_PC, fMaxEngagementDist_NPC,
	    fMaxEngagementDist;

    local MOHAPawn TargetPawn, BestTarget, BestBackupTarget;
    local Vector vWeaponLocation;
    local MOHAPlayerController PC;

    fBestScore = 0.0000000;
    fBestBackupScore = 0.0000000;
    fMaxEngagementDist_PC = MOHAVehicle(Pawn).GetWeaponEngagementDist(iWeaponIndex, true);
    fMaxEngagementDist_NPC = MOHAVehicle(Pawn).GetWeaponEngagementDist(iWeaponIndex, false);
    vWeaponLocation = MOHAVehicle(Pawn).GetWeaponLocation(iWeaponIndex);
    BestTarget = none;
    BestBackupTarget = none;
    PC = Class'MOHAUtilities'.static.GetLocalPlayerController(self);
    // End:0x139
    if((((!bExcludePlayer && PC != none) && PC.Pawn != none) && VSize(PC.Pawn.Location - vWeaponLocation) < fMaxEngagementDist_PC) && CanTargetEnemy(iWeaponIndex, PC.Pawn))
    {
        return PC.Pawn;
    }
    // End:0x298
    foreach WorldInfo.AllPawns(Class'MOHAPawn', TargetPawn)
    {
        // End:0x297
        if((!TargetPawn.IsA('MOHAMountedGun') && !bExcludePlayer || !TargetPawn.IsA('MOHAPlayerPawn')) && TargetPawn.GetTeamIndex() != int(MOHAVehicle(Pawn).PawnSide))
        {
            fMaxEngagementDist = ((MOHAPlayerPawn(TargetPawn) != none) ? fMaxEngagementDist_PC : fMaxEngagementDist_NPC);
            fDist = VSize(TargetPawn.Location - vWeaponLocation);
            // End:0x297
            if(fDist < fMaxEngagementDist)
            {
                fScore = GetPawnScore(TargetPawn, fDist, fMaxEngagementDist);
                // End:0x272
                if((fScore > fBestScore) && CanTargetEnemy(iWeaponIndex, TargetPawn))
                {
                    fBestScore = fScore;
                    BestTarget = TargetPawn;
                }
                // End:0x297
                if(fScore > fBestBackupScore)
                {
                    fBestBackupScore = fScore;
                    BestBackupTarget = TargetPawn;
                }
            }
        }        
    }    
    return ((BestTarget != none) ? BestTarget : BestBackupTarget);
    //return ReturnValue;    
}

function float GetPawnScore(Pawn TargetPawn, float fDist, float fMaxEngagementDist)
{
    local float fScore;

    // End:0x23
    if(TargetPawn == Vehicle(Pawn).Driver)
    {
        return 0.0000000;
    }
    // End:0x3D
    if(TargetPawn.Health <= 0)
    {
        return 0.0000000;
    }
    fScore = float(Max(int(fMaxEngagementDist - fDist), 0));
    // End:0x79
    if(TargetPawn.IsA('MOHAPlayerPawn'))
    {
        fScore *= 2.0000000;
    }
    return fScore;
    //return ReturnValue;    
}

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
    super.OnAIMoveToActor(Action);
    // End:0x9B
    if(MOHAVehicle(Pawn) != none)
    {
        // End:0x74
        if((MOHAVehiclePathPoint(ScriptedMoveTarget) != none) && MOHAVehiclePathPoint(ScriptedMoveTarget).fMaxVehicleSpeed != 0.0000000)
        {
            MOHAVehicle(Pawn).MaxSpeed = MOHAVehiclePathPoint(ScriptedMoveTarget).fMaxVehicleSpeed;            
        }
        else
        {
            MOHAVehicle(Pawn).MaxSpeed = MOHAVehicle(Pawn).fMaxSpeed;
        }
    }
    //return;    
}

event StopVehicle()
{
    bStopped = true;
    //return;    
}

event BrakeVehicle()
{
    bBraking = true;
    //return;    
}

state ScriptedMove
{Begin:

    bStopped = false;
    J0x08:

    // End:0x184 [Loop If]
    if((((MOHAVehicle(Pawn) != none) && ScriptedMoveTarget != none) && !Pawn.ReachedDestination(ScriptedMoveTarget)) && !MOHAVehicle(Pawn).bImmobile)
    {
        // End:0x105
        if(MoveTarget != none)
        {
            nextPoint = MOHAVehiclePathPoint(MoveTarget);
            // End:0x105
            if(((nextPoint != none) && Pawn.ReachedDestination(MoveTarget)) && nextPoint.bBrake)
            {
                // End:0xDC
                if(nextPoint.fBrakeTime < 0.0000000)
                {
                    fCurrentBrakeTime = 0.0000000;                    
                }
                else
                {
                    fCurrentBrakeTime = nextPoint.fBrakeTime;
                }
                // End:0x105
                if(!bBraking)
                {
                    BrakeVehicle();
                }
            }
        }
        // End:0x123
        if(ActorReachable(ScriptedMoveTarget))
        {
            MoveToward(ScriptedMoveTarget, ScriptedFocus);            
        }
        else
        {
            // End:0x15C
            if((MoveTarget == none) || Pawn.ReachedDestination(MoveTarget))
            {
                MoveTarget = FindPathToward(ScriptedMoveTarget);
            }
            // End:0x17A
            if(MoveTarget != none)
            {
                MoveToward(MoveTarget, ScriptedFocus);                
            }
            else
            {
                ScriptedMoveTarget = none;
            }
        }
        // [Loop Continue]
        goto J0x08;
    }
    // End:0x1B5
    if(MOHAVehiclePathPoint(ScriptedMoveTarget) != none)
    {
        // End:0x1B5
        if(MOHAVehiclePathPoint(ScriptedMoveTarget).bParkHereIfDestination)
        {
            StopVehicle();
        }
    }
    PopState();
    stop;                
}

defaultproperties
{
    fCurrentBrakeTime=5.0000000
    fMaxTimeWithoutReachableTarget=5.0000000
    fMinTimeBetweenEnemySearches=1.0000000
    fMinYawToStartTurning=3640.0000000
    fFireWithoutLOSTime=8.0000000
    fReactionTimeToLOS=1.5000000
    // Reference: SpriteComponent'Default__MOHAVehicleController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}