class PKAIController extends EvilAIController
    config(AI)
    hidecategories(Navigation);

var PKPawn MyPKPawn;
var(PKAI) config bool bGuardStill;
var(PKAI) bool bRotate180AfterEndWalking;
var(PKAI) config bool bUseGuardAngleRandom;
var(PKAI) bool bAlwaysSee;
var(PKAI) bool bFirstTimeSee;
var(PKAI) config bool ContinousAttack;
var bool bDisableEscapeWhenTooClose;
var(PKAI) bool bChangePosOrEscapeInProgress;
var(PKAI) config bool bWalkAreaWhenAttack;
var(PKAI) config bool bWalkAreaRandom;
var(PKAI) config bool bDontRunWhenHunt;
var(PKAI) config bool bDontCareAboutOrientationDuringAttack;
var(PKAI) config bool bDontRotateWhenShooting;
var(PKAI) bool bConfused;
var() config bool bResetFocusAfterMove;
var(PKAI) config float StopAfterWalkingChance;
var(PKAI) config float StopAfterWalkingTimeMin;
var(PKAI) config float StopAfterWalkingTimeMax;
var(PKAI) config float GuardChangeRotationDelayMin;
var(PKAI) config float GuardChangeRotationDelayMax;
var(PKAI) config float GuardAngleMax;
var(PKAI) config float GuardRange;
var(PKAI) config float DefaultFarAttackPriority;
var(PKAI) config float DefaultNearAttackPriority;
var(PKAI) float FarAttackPriority;
var(PKAI) config float EnemyMinDistance_Melee;
var(PKAI) config float EnemyAngleEpsilon_Melee;
var(PKAI) config float DelayBetweenAttacks;
var(PKAI) config float EscapeTime;
var(PKAI) config float EscapeTimeWhenTooCloseToPlayer;
var(PKAI) float ActualEscapeTime;
var(PKAI) config float ChanceOfEscapeAfterFire;
var(PKAI) float LastMeleeHitTime;
var(PKAI) float LastMeleeMissedTime;
var(PKAI) int WalkAreaPointIndex;
var(PKAI) float DelayToHunt;
var(PKAI) float DelayBeforeHunt;
var(PKAI) config float ChangePosAfterFireChance;
var(PKAI) config float ChangePosAfterFireDistance;
var(PKAI) config float MinDelayBetweenThrow;
var(PKAI) config float ThrowRangeMax;
var(PKAI) config float ThrowRangeMin;
var(PKAI) PKWalkArea WalkArea;
var(PKAI) int FastSpinUpThreshold;
var(PKAI) float LastJumpTime;
var(PKAI) config float MinDelayBetweenJumps;
var(PKAI) config float MinJumpRange;
var(PKAI) config float MaxJumpRange;
var(PKAI) config float JumpDistanceMinus;
var(PKAI) config float ConfusedDamageScaling;
var(PKAI) config float ConfusedAttackSpeedScaling;
var(PKAI) config float ConfusedMovementSpeedScaling;
var(PKAI) config float ConfusedHealthScaling;
var float NoEnemyTime;
var Vector ActualThrowLocation;
var int DestructibleBumpCount;
var int PawnBumpCount;
var EvilPawn LastBumpedPawn;
var float LastFailedChargeTime;
var() float TimeBetweenFailedCharges;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    bAILogging = true;
    bAILogToWindow = false;
    MyPKPawn = PKPawn(NewPawn);
    SetTimer(1.0000000, true, 'CheckFlocking');
    //return;    
}

event UnPossess()
{
    super.UnPossess();
    MyPKPawn = none;
    //return;    
}

function CheckFlocking()
{
    local PKPawn P;
    local Vector DirToOtherPawn, AdjustDir;

    // End:0x204
    if(InLatentExecution(503))
    {
        // End:0x203
        foreach Pawn.VisibleActors(Class'PKPawn', P, 200.0000000)
        {
            // End:0x6B
            if(P.bAdjustingVelocity)
            {
                continue;                
            }
            DirToOtherPawn = Normal(Pawn.Location - P.Location);
            // End:0x202
            if((Normal(Pawn.Velocity) Dot DirToOtherPawn) > 0.6000000)
            {
                AdjustDir = -Normal(DirToOtherPawn - ProjectOnTo(DirToOtherPawn, Vector(Pawn.Rotation)));
                AdjustDir = AdjustDir + (Normal(P.Velocity) * 0.5000000);
                // End:0x1CD
                if(NavigationHandle.PointCheck(Pawn.Location + (AdjustDir * float(120)), vect(20.0000000, 20.0000000, 150.0000000)))
                {
                    continue;                    
                }
                P.SetAdjustMoveVelocity(AdjustDir, 1.2000000, 100.0000000);
                // End:0x203
                break;
            }            
        }        
    }
    SetTimer(RandRange(1.0000000, 3.0000000), true, 'CheckFlocking');
    //return;    
}

function CheckEnemyInfo()
{
    // End:0x4C
    if((EnemyInfoList.Length > 0) && GetEnemyInfo().Rating > 0.0000000)
    {
        NoEnemyTime = 0.0000000;        
    }
    else
    {
        NoEnemyTime += 0.5000000;
    }
    // End:0x124
    if(MyPKPawn.IsTimerActive('KillCapturedEnemy', MyPKPawn) && NoEnemyTime >= RandRange(1.5000000, 2.0000000))
    {
        MyPKPawn.ClearTimer('KillCapturedEnemy', MyPKPawn);
        MyPKPawn.SetTimer(RandRange(0.1000000, 0.2000000), false, 'KillCapturedEnemy', MyPKPawn);
    }
    //return;    
}

function NotifyPawnFrozen(bool bFrozen)
{
    // End:0x4F
    if(bFrozen)
    {
        // End:0x3F
        if(InLatentExecution(503) || InLatentExecution(501))
        {
            bPreparingMove = true;
        }
        DisableAI(false, true, false);        
    }
    else
    {
        bPreparingMove = false;
        EnableAI();
    }
    //return;    
}

function float GetBaseEnemyRating(Pawn EnemyP, float Distance)
{
    return super.GetBaseEnemyRating(EnemyP, Distance) * ((NavigationHandle.PointReachable(EnemyP.Location)) ? 1.0000000 : 0.5000000);
    //return ReturnValue;    
}

function bool ShouldStopOnMoveToGoalPause()
{
    // End:0x24
    if(MyPKPawn.bIsFrozen)
    {
        return false;
    }
    return super.ShouldStopOnMoveToGoalPause();
    //return ReturnValue;    
}

function float GetPawnSpotChance(Pawn Seen)
{
    return ((!IsFriendlyPawn(Seen)) ? super.GetPawnSpotChance(Seen) : 0.0000000);
    //return ReturnValue;    
}

function bool CanHearPawn(Pawn Heard, float Loudness, name NoiseType)
{
    return !IsFriendlyPawn(Heard) && super.CanHearPawn(Heard, Loudness, NoiseType);
    //return ReturnValue;    
}

function int AddFriend(Pawn InFriend)
{
    return -1;
    //return ReturnValue;    
}

function int GetAIFriendInfoIdx(Pawn InFriend)
{
    return -1;
    //return ReturnValue;    
}

function UpdateFriendlyCharacterInfo(Pawn P, EvilAIController.EPerceptionType Pt, name EventName, int PawnListIndex)
{
    //return;    
}

function UpdateFriendInfo(int FriendIdx, Pawn InFriend, Vector InViewLocation, optional EvilTypes.ESoundSetType InHearMeType)
{
    //return;    
}

function bool ShouldReturnToIdle()
{
    return false;
    //return ReturnValue;    
}

function bool CanMeleeAttack()
{
    return super.CanMeleeAttack() && (MyPKPawn.AST_GetAnimCount(38) > 0) || MyPKPawn.AST_GetAnimCount(39) > 0;
    //return ReturnValue;    
}

function NotifyConfused()
{
    local EvilAnim_AST ASTAnimNode;

    // End:0x236
    if(!bConfused)
    {
        RevalidateEnemies();
        AutoAcquireEnemy();
        MyPKPawn.Health = int(float(MyPKPawn.HealthMax) * ConfusedHealthScaling);
        MyPKPawn.ChangeSpeedModifier(ConfusedMovementSpeedScaling);
        // End:0x236
        if(((MyPKPawn.MoveModeNode != none) && MyPKPawn.MoveModeNode.Children.Length > int(MyPKPawn.CurrentMoveMode)) && MyPKPawn.MoveModeNode.Children[int(MyPKPawn.CurrentMoveMode)].Anim != none)
        {
            ASTAnimNode = EvilAnim_AST(MyPKPawn.MoveModeNode.Children[int(MyPKPawn.CurrentMoveMode)].Anim);
            // End:0x236
            if(ASTAnimNode != none)
            {
                ASTAnimNode.Rate = ConfusedMovementSpeedScaling;
            }
        }
    }
    bConfused = true;
    //return;    
}

function NotifyUnconfused()
{
    local AnimBlendChild AnimBlendNode;

    // End:0x116
    if(bConfused)
    {
        RevalidateEnemies();
        AutoAcquireEnemy();
        MyPKPawn.ChangeSpeedModifier(MyPKPawn.default.MovementSpeedModifier);
        // End:0x115
        foreach MyPKPawn.MoveModeNode.Children(AnimBlendNode)
        {
            EvilAnim_AST(AnimBlendNode.Anim).Rate = EvilAnim_AST(AnimBlendNode.Anim).default.Rate;            
        }        
    }
    bConfused = false;
    //return;    
}

function NotifyStartBurn(float InTotalTime, float InDamageInterval, float InDamageAmount)
{
    //return;    
}

function NotifyDoMeleeDamageHit()
{
    super.NotifyDoMeleeDamageHit();
    LastMeleeHitTime = WorldInfo.TimeSeconds;
    //return;    
}

function NotifyDoMeleeDamageMissed()
{
    super.NotifyDoMeleeDamageMissed();
    LastMeleeMissedTime = WorldInfo.TimeSeconds;
    //return;    
}

function Vector GetRandomLocation(float Radius, optional bool bOverrideStartLocation, optional Vector StartLocation)
{
    local array<Vector> Position;

    // End:0x54
    if(Radius < (Pawn.GetCollisionRadius() * float(2)))
    {
        return Pawn.Location;
    }
    Class'Engine.NavigationHandle'.static.GetValidPositionsForBox(((bOverrideStartLocation) ? StartLocation : Pawn.Location), Radius, Pawn.GetCollisionExtent(), false, Position, 5, FMax(0.0000000, Radius - Pawn.GetCollisionRadius()), vect(30.0000000, 30.0000000, 30.0000000));
    // End:0x145
    if(Position.Length > 0)
    {
        return Position[Rand(Position.Length)];        
    }
    else
    {
        return Pawn.Location;
    }
    //return ReturnValue;    
}

function Vector GetThrowLocation()
{
    return ActualThrowLocation;
    //return ReturnValue;    
}

function PrepareJumpAttack()
{
    // End:0x2E
    if(MyPKPawn != none)
    {
        MyPKPawn.PrepareJumpAttack();
    }
    //return;    
}

function Vector GetJumpVelocity()
{
    local Vector Vel, RealEnd;

    // End:0xD2
    if(HasValidEnemy())
    {
        RealEnd = GetEnemyInfo().KnownLocation - (Normal(GetEnemyInfo().KnownLocation - MyPKPawn.Location) * JumpDistanceMinus);
        MyPKPawn.SuggestJumpVelocity(Vel, RealEnd, MyPKPawn.Location, true);
    }
    return Vel;
    //return ReturnValue;    
}

function StartJumpAttack()
{
    // End:0x2E
    if(MyPKPawn != none)
    {
        MyPKPawn.StartJumpAttack();
    }
    //return;    
}

function PrepareFarAttack()
{
    // End:0x2E
    if(MyPKPawn != none)
    {
        MyPKPawn.PrepareFarAttack();
    }
    //return;    
}

function ScreamAttack()
{
    // End:0x2E
    if(MyPKPawn != none)
    {
        MyPKPawn.ScreamAttack();
    }
    //return;    
}

function TickFire(float DeltaTime)
{
    //return;    
}

function bool IsFiring()
{
    return (int(MyPKPawn.PawnAction) == 11) || MyPKPawn.IsFiring();
    //return ReturnValue;    
}

function PKAICmd_Base_UtilitySelectedCmd GetActivePKAction()
{
    local PKAIcmd_Base_UtilActionSelector Cmd;

    Cmd = GetActivePKSelector();
    // End:0x43
    if(Cmd != none)
    {
        return Cmd.GetActivePKAction();
    }
    return none;
    //return ReturnValue;    
}

function bool ShouldDeactivateActivePKAction()
{
    local PKAICmd_Base_UtilitySelectedCmd Cmd;

    Cmd = GetActivePKAction();
    // End:0x46
    if(Cmd != none)
    {
        return Cmd.ShouldDeactivate();        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function PKAIcmd_Base_UtilActionSelector GetActivePKSelector()
{
    return PKAIcmd_Base_UtilActionSelector(CommandList);
    //return ReturnValue;    
}

function bool IsFriendly(Controller TestController)
{
    return super.IsFriendly(TestController);
    //return ReturnValue;    
}

function Vector GetThrowExtent()
{
    return vect(5.0000000, 5.0000000, 5.0000000);
    //return ReturnValue;    
}

function bool SelectTarget()
{
    // End:0x20
    if(SelectEnemy())
    {
        ShotTarget = Enemy;
    }
    return ShotTarget != none;
    //return ReturnValue;    
}

function bool ClearFireLine()
{
    local bool bResult;

    bResult = HasValidEnemy();
    // End:0x27F
    if(bResult)
    {
        // End:0x27F
        if(((MyPKPawn.Weapon != none) && !ClearFireLineToActor(Enemy, MyPKPawn.GetRightWeaponTraceForShootLocation(), true,,,,, int(MyPKPawn.RequestedAimZone) == int(2), Enemy.Mesh.GetBoneLocation(MyPKPawn.HeadBone, 0))) || (MyPKPawn.WeaponLeft != none) && !ClearFireLineToActor(Enemy, MyPKPawn.GetLeftWeaponTraceForShootLocation(), true,,,,, int(MyPKPawn.RequestedAimZone) == int(2), Enemy.Mesh.GetBoneLocation(MyPKPawn.HeadBone, 0)))
        {
            // End:0x229
            if(int(MyPKPawn.RequestedAimZone) == int(1))
            {
                MyPKPawn.RequestedAimZone = 2;                
            }
            else
            {
                // End:0x273
                if(int(MyPKPawn.RequestedAimZone) == int(2))
                {
                    MyPKPawn.RequestedAimZone = 1;
                }
            }
            bResult = false;
        }
    }
    return bResult;
    //return ReturnValue;    
}

function bool ClearThrowLine()
{
    local bool bResult;
    local Vector ThrowLoc;

    bResult = HasValidEnemy();
    // End:0x105
    if(bResult)
    {
        // End:0xCE
        if(((CanThrowGrenade()) && MyPKPawn.Mesh.GetSocketWorldLocationAndRotation(MyPKPawn.GrenadeSocket, ThrowLoc,, 0)) && ClearSightToActor(Enemy, ThrowLoc, true,,, GetThrowExtent()))
        {
            bResult = true;            
        }
        else
        {
            // End:0xF9
            if((CanThrowAttack()) && ClearFireLine())
            {
                bResult = true;                
            }
            else
            {
                bResult = false;
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

function bool HasValidEnemy()
{
    local bool bResult;
    local AICharacterInfo EnemyInfo;

    bResult = GetCurrentEnemyInfo(EnemyInfo);
    // End:0xB8
    if(bResult)
    {
        bResult = (EnemyInfo.LastSeenTime >= EnemyInfo.LastUpdateTime) && WorldInfo.TimeSeconds < (EnemyInfo.LastUpdateTime + 0.5000000);
    }
    return bResult;
    //return ReturnValue;    
}

function bool IsAttacking()
{
    local PKAICmd_Base_UtilitySelectedCmd Cmd;

    Cmd = GetActivePKAction();
    // End:0x43
    if(Cmd != none)
    {
        return Cmd.IsAttacking();
    }
    return false;
    //return ReturnValue;    
}

function UpdateEnemy(Pawn InEnemy)
{
    local Pawn SavedEnemy;

    SavedEnemy = Enemy;
    super.UpdateEnemy(InEnemy);
    // End:0x47
    if(Enemy != SavedEnemy)
    {
        AbortMoving();
    }
    //return;    
}

function Vector GetClosestToEnemyLocationInWalkArea()
{
    local float BestDistance;
    local PKNavPoint NavPoint;
    local int I, J;

    BestDistance = 99999.0000000;
    // End:0xA5
    foreach WalkArea.NavPointList(NavPoint, I)
    {
        // End:0xA4
        if(VSizeSq(NavPoint.Location - GetEnemyInfo().KnownLocation) < BestDistance)
        {
            J = I;
        }        
    }    
    return WalkArea.NavPointList[J].Location;
    //return ReturnValue;    
}

function Vector GetNextLocationInWalkArea()
{
    // End:0x38
    if(WalkAreaPointIndex >= WalkArea.NavPointList.Length)
    {
        WalkAreaPointIndex = 0;
    }
    return WalkArea.NavPointList[WalkAreaPointIndex++].Location;
    //return ReturnValue;    
}

function Vector GetRandomLocationInWalkArea()
{
    return WalkArea.NavPointList[Rand(WalkArea.NavPointList.Length)].Location;
    //return ReturnValue;    
}

function NotifyBumpLevel(Vector HitLocation, Vector HitNormal)
{
    //return;    
}

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    local EvilDynamicDestructibleObject edo;

    // End:0xDC
    if(EvilPawn(Other) != none)
    {
        // End:0xB5
        if(PawnBumpCount >= (((LastBumpedPawn == EvilPawn(Other)) ? PawnBumpCount : 2) + Rand(4)))
        {
            // End:0xA7
            if(!IsFriendlyPawn(EvilPawn(Other)))
            {
                ProcessStimulus(Pawn(Other), 3);
                PawnBumpCount = 0;                
            }
            else
            {
                PawnBumpCount++;
            }            
        }
        else
        {
            PawnBumpCount++;
        }
        LastBumpedPawn = EvilPawn(Other);
    }
    edo = EvilDynamicDestructibleObject(Other);
    // End:0x24B
    if(((((CanMeleeAttack()) && edo != none) && int(MyPKPawn.PawnAction) == 0) && VSizeSq(edo.Velocity) <= 16.0000000) && (edo.DamageMods.Length <= 0) || edo.DamageMods[0].ExploMod.Damage <= 0.0000000)
    {
        // End:0x23D
        if((DestructibleBumpCount >= (Rand(5) + 5)) && !IsAttacking())
        {
            SetFocalPoint(Other.Location);
            StartMeleeAttack();
        }
        DestructibleBumpCount++;        
    }
    else
    {
        DestructibleBumpCount = 0;
    }
    return false;
    //return ReturnValue;    
}

function bool HasWalkArea()
{
    return (WalkArea != none) && WalkArea.NavPointList.Length > 0;
    //return ReturnValue;    
}

function bool CanFastSpinUp(int YawDelta)
{
    return super.CanFastSpinUp(YawDelta) && YawDelta <= FastSpinUpThreshold;
    //return ReturnValue;    
}

defaultproperties
{
    bUseGuardAngleRandom=true
    bResetFocusAfterMove=true
    StopAfterWalkingChance=1.0000000
    StopAfterWalkingTimeMin=0.5000000
    StopAfterWalkingTimeMax=1.5000000
    GuardChangeRotationDelayMin=0.5000000
    GuardChangeRotationDelayMax=1.0000000
    GuardRange=300.0000000
    DefaultFarAttackPriority=-1.0000000
    FarAttackPriority=0.5100000
    EnemyAngleEpsilon_Melee=0.6000000
    DelayBetweenAttacks=0.1000000
    EscapeTime=2.0000000
    ChanceOfEscapeAfterFire=0.0400000
    MinDelayBetweenThrow=1.0000000
    ThrowRangeMax=2000.0000000
    ThrowRangeMin=200.0000000
    FastSpinUpThreshold=2048
    ConfusedDamageScaling=10.0000000
    ConfusedAttackSpeedScaling=2.0000000
    ConfusedMovementSpeedScaling=1.5000000
    ConfusedHealthScaling=10.0000000
    TimeBetweenFailedCharges=4.0000000
    bNavmeshFailForceDirectMove=true
    TargettedAimEpsilon=0.7000000
    ProjectileAimHeightModifier=0.5000000
    MoveCommand=Class'PKAICmd_MoveToGoal'
    SightRadius=10000.0000000
    // Reference: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    // Archetype: EvilAIReactManager'EvilGame.Default__EvilAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    SightCounterInterval=0.4000000
    NavMeshPath_SearchExtent_Modifier=(X=-5.0000000,Y=-5.0000000,Z=-5.0000000)
}