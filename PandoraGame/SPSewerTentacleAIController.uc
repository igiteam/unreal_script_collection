class SPSewerTentacleAIController extends SPAIController
    native;

var SPGameDifficultyTuneTentacle m_TentacleGDTuneData;
var SPTuneDataTentacle m_TentacleTuneData;
var() bool bNoAttack;
var bool bSelfDestruct;
var bool m_bStretchingToEnemy;
var bool m_bAttachingToEnemy;
var bool m_bPullingBack;
var bool m_bStretchingTimedOut;
var bool m_bLoopingDamageSequence;
var bool m_bResetAttack;
var bool m_bRightAttackEnabled;
var bool m_bLeftAttackEnabled;
var bool m_bUpAttackEnabled;
var bool m_bRightAttackOccurred;
var bool m_bLeftAttackOccurred;
var bool m_bUpAttackOccurred;
var bool m_bThrowingAttack;
var bool m_bThrowingAttackBackwards;
var bool m_bCanForwardThrow;
var bool m_bIdleLookOutEnded;
var bool m_bCollisionHitWhileStretching;
var bool m_bIdleRetract;
var SPSewerTentaclePawnPersistent m_SewerTentaclePawn;
var Vector m_ThrowingVecBackwards;
var Vector m_LastKnownValidEnemyLocation;
var SkelControlSingleBone m_BaseBoneCtrl;

// Export USPSewerTentacleAIController::execIsValidEnemyController(FFrame&, void* const)
native function bool IsValidEnemyController(Controller chkController, optional bool bNoListCheck, optional bool bNoPreferredSquadCheck);

function ActivateSkelController()
{
    m_BaseBoneCtrl = SkelControlSingleBone(m_SewerTentaclePawn.Mesh.FindSkelControl('BaseController'));
    // End:0x4A
    if(m_BaseBoneCtrl != none)
    {
        m_BaseBoneCtrl.SetSkelControlActive(true);
    }
    //return;    
}

simulated event SPGameDifficultyTuneTentacle GetTentacleDifficultyData()
{
    // End:0x20
    if(m_TentacleGDTuneData == none)
    {
        m_TentacleGDTuneData = SPGameDifficultyTuneTentacle(GetMyGDData());
    }
    return m_TentacleGDTuneData;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.TentacleGD;
    //return ReturnValue;    
}

simulated event PreBeginPlay()
{
    super(AIController).PreBeginPlay();
    GetTentacleDifficultyData();
    //return;    
}

function StartAction(SPSewerTentaclePawnPersistent.eSewerTentacleActionState actionState, optional bool Reset)
{
    m_SewerTentaclePawn.m_actionState = actionState;
    // End:0x31
    if(Reset)
    {
        m_SewerTentaclePawn.m_bResetAction = true;
    }
    //return;    
}

function SelfDestruct(optional float Time)
{
    SPSewerTentaclePawnPersistent(Pawn).TriggerDesruction();
    //return;    
}

function EnableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    // End:0x21
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    super.EnableAI(bDontResetPhysics, bDontResetSceneAnims);
    //return;    
}

function SoftEnableAI()
{
    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    super.SoftEnableAI();
    //return;    
}

function float GetGooScalerLocation()
{
    return m_TentacleGDTuneData.GooScalerLocation;
    //return ReturnValue;    
}

function KillEnemyPlayer()
{
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    // End:0xAA
    if((pEnemyPawn != none) && SPPawn(pEnemyPawn) != none)
    {
        // End:0xAA
        if((pEnemyPawn.IsA('PlayerPawn') == true) && SPPawn(pEnemyPawn).GetAttachedToTentacle() == true)
        {
            pEnemyPawn.TakeDamageAndProcEffects(10000.0000000, self, pEnemyPawn.Location, Vector(Pawn.Rotation), Class'SPDamageTypeTentacleGrab');
        }
    }
    //return;    
}

function NotifyDying()
{
    // End:0x22
    if(!IsInState('ControllerDying'))
    {
        PushState('ControllerDying');
    }
    //return;    
}

function EvaluateSituation()
{
    local Pawn pEnemyPawn;

    // End:0x15
    if(m_bAIDisabled)
    {
        SoftDisableAI();
        return;
    }
    // End:0xB1
    if((!bNoAttack && CheckForEnemy(,, 1050.0000000)) && m_bResetAttack)
    {
        pEnemyPawn = GetEnemy();
        // End:0x98
        if((pEnemyPawn != none) && SPPawn(pEnemyPawn).GetAttachedToTentacle() == false)
        {
            GotoState('Attack', 'Begin', true, false);            
        }
        else
        {
            GotoState('Idle', 'Begin', true, false);
        }        
    }
    else
    {
        GotoState('Idle', 'Begin', true, false);
    }
    //return;    
}

function bool IsWaterCollision(PrimitiveComponent HitComp)
{
    // End:0x22
    if((HitComp != none) && HitComp.SPBulletTouch)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function UpdateRotationWithEnemyCheck()
{
    Pawn.SetRotation(rot(0, 8192, 0));
    // End:0x3A
    if(CheckForEnemy(true, 1000.0000000))
    {
        EvaluateSituation();
    }
    //return;    
}

function bool ForwardCollisionTest()
{
    local Actor TempHitActor;
    local float ForwardLength;
    local Vector ForwardDirection, NewForwardDirection, HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local Pawn pEnemyPawn;
    local Vector extentBox;

    pEnemyPawn = GetEnemy();
    ForwardLength = VSize(pEnemyPawn.Location - Pawn.Location);
    // End:0x4F
    if(ForwardLength > float(1000 - 100))
    {
        return false;
    }
    ForwardDirection = Normal(pEnemyPawn.Location - Pawn.Location);
    NewForwardDirection = ForwardDirection;
    NewForwardDirection *= (float(1000) - (ForwardLength + 50.0000000));
    ForwardDirection *= 50.0000000;
    ForwardDirection = pEnemyPawn.Location + ForwardDirection;
    NewForwardDirection = ForwardDirection + NewForwardDirection;
    extentBox = vect(20.0000000, 20.0000000, 20.0000000);
    TempHitActor = none;
    TempHitActor = Trace(HitLocation, HitNormal, NewForwardDirection, ForwardDirection, true, extentBox, HitInfo, 10, true);
    // End:0x14B
    if((TempHitActor != none) && !IsWaterCollision(HitInfo.HitComponent))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function int GetPullbackDistanceNode()
{
    local float HitDistance;
    local Vector tipLoc;
    local Rotator tipRot;

    // End:0xF3
    if((GetEnemy()) != none)
    {
        // End:0x80
        if(int(m_SewerTentaclePawn.m_actionState) == int(7))
        {
            // End:0x5F
            if(!Pawn.Mesh.GetSocketWorldLocationAndRotation('TentacleTip', tipLoc, tipRot))
            {
                return 3;
            }
            HitDistance = VSize(Pawn.Location - tipLoc);            
        }
        else
        {
            HitDistance = VSize(GetEnemy().Location - Pawn.Location);
        }
        // End:0xC3
        if(HitDistance > float(800))
        {
            return 1;            
        }
        else
        {
            // End:0xD9
            if(HitDistance > float(735))
            {
                return 1;                
            }
            else
            {
                // End:0xF0
                if(HitDistance > float(400))
                {
                    return 2;                    
                }
                else
                {
                    return 3;
                }
            }
        }
    }
    return 3;
    //return ReturnValue;    
}

function RemoveEnemyFromTentacle()
{
    //return;    
}

function GiveDamageToEnemy()
{
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    // End:0x112
    if(pEnemyPawn != none)
    {
        // End:0x7E
        if(pEnemyPawn.IsA('PlayerPawn') == true)
        {
            pEnemyPawn.TakeDamageAndProcEffects(25.0000000, self, pEnemyPawn.Location, Vector(Pawn.Rotation), Class'PandoraDamageType',, Pawn);            
        }
        else
        {
            pEnemyPawn.TakeDamageAndProcEffects(800.0000000, self, pEnemyPawn.Location, Vector(Pawn.Rotation), Class'PandoraDamageType',, Pawn);
        }
        // End:0x10F
        if((pEnemyPawn == none) || pEnemyPawn.Health <= 0)
        {
            m_SewerTentaclePawn.SetResetAttackFromController();
            GotoState('Idle', 'Begin', true, false);
        }        
    }
    else
    {
        m_SewerTentaclePawn.SetResetAttackFromController();
        GotoState('Idle', 'Begin', true, false);
    }
    //return;    
}

function ThrowEnemy()
{
    local Vector posTentacleTip;
    local Rotator rotTentacleTip;
    local Vector posTentacleMid;
    local Rotator rotTentacleMid;
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    // End:0x139
    if((pEnemyPawn != none) && !pEnemyPawn.IsA('PlayerPawn'))
    {
        // End:0x69
        if(!Pawn.Mesh.GetSocketWorldLocationAndRotation('TentacleTip', posTentacleTip, rotTentacleTip))
        {
        }
        // End:0x9B
        if(!Pawn.Mesh.GetSocketWorldLocationAndRotation('TentacleMid', posTentacleMid, rotTentacleMid))
        {
        }
        pEnemyPawn.DetachObject(true);
        SPPawn(pEnemyPawn).SetThrowDeath(25000.0000000, Normal(posTentacleTip - posTentacleMid));
        pEnemyPawn.TakeDamageAndProcEffects(float(pEnemyPawn.Health + 100), self, pEnemyPawn.Location, Vector(Pawn.Rotation), Class'PandoraDamageType',, Pawn);
        SetEnemy(none);
    }
    //return;    
}

simulated function StartForceFeedBackEffect()
{
    local Pawn pEnemyPawn;
    local PandoraPlayerController PC;

    pEnemyPawn = GetEnemy();
    // End:0x8B
    if((pEnemyPawn != none) && pEnemyPawn.Controller != none)
    {
        PC = PandoraPlayerController(pEnemyPawn.Controller);
        // End:0x8B
        if(PC != none)
        {
            // End:0x8B
            if(m_TentacleGDTuneData.Hit_ForceFeedbackWaveform != none)
            {
                PC.ClientPlayForceFeedbackWaveform(m_TentacleGDTuneData.Hit_ForceFeedbackWaveform);
            }
        }
    }
    //return;    
}

simulated function StopForceFeedBackEffect()
{
    local Pawn pEnemyPawn;
    local PandoraPlayerController PC;

    pEnemyPawn = GetEnemy();
    // End:0x8B
    if((pEnemyPawn != none) && pEnemyPawn.Controller != none)
    {
        PC = PandoraPlayerController(pEnemyPawn.Controller);
        // End:0x8B
        if(PC != none)
        {
            // End:0x8B
            if(m_TentacleGDTuneData.Hit_ForceFeedbackWaveform != none)
            {
                PC.ClientStopForceFeedbackWaveform(m_TentacleGDTuneData.Hit_ForceFeedbackWaveform);
            }
        }
    }
    //return;    
}

simulated function CheckLocationForFailSafeCollisionPlacement()
{
    local Pawn pEnemyPawn;
    local SPPawn spEnemyPawn;
    local Vector spotLoc;

    pEnemyPawn = GetEnemy();
    spEnemyPawn = SPPawn(pEnemyPawn);
    // End:0x8F
    if((spEnemyPawn != none) && spEnemyPawn.GetAttachedToTentacle())
    {
        spotLoc = pEnemyPawn.Location;
        // End:0x8C
        if(pEnemyPawn.FindSpot(pEnemyPawn.GetCollisionExtent(), spotLoc))
        {
            m_LastKnownValidEnemyLocation = spotLoc;
        }        
    }
    else
    {
        ClearTimer('CheckLocationForFailSafeCollisionPlacement');
    }
    //return;    
}

function TimerToExplode()
{
    SelfDestruct();
    //return;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        // End:0x25
        if(m_SewerTentaclePawn == none)
        {
            m_SewerTentaclePawn = SPSewerTentaclePawnPersistent(NewPawn);
            ActivateSkelController();
        }
        super.Possess(NewPawn, bVehicleTransition);
        SetPawnRotationRate(0, 0, 0);
        //return;        
    }
    stop;    
}

state IdleLookOut
{
    function BeginState(name PreviousStateName)
    {
        super(Object).BeginState(PreviousStateName);
        m_bIdleLookOutEnded = false;
        Pawn.Mesh.SetHidden(false);
        ClearEnemy();
        StartAction(1);
        //return;        
    }
    J0x00:
    // End:0x16 [Loop If]
    if(!m_bIdleLookOutEnded)
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    EvaluateSituation();
    stop;                
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        Pawn.Mesh.SetHidden(true);
        StartAction(0);
        ClearEnemy();
        SetTimer(0.1000000, true, 'UpdateRotationWithEnemyCheck');
        //return;        
    }

    function GotoIdleLookOut()
    {
        GotoState('IdleLookOut', 'Begin', true, false);
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('UpdateRotationWithEnemyCheck');
        ClearTimer('GotoIdleLookOut');
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x20
        if(CheckForEnemy(true, 1000.0000000))
        {
            EvaluateSituation();
        }
        //return;        
    }

    function OnHearEnemy(int PlayerIdx)
    {
        // End:0x20
        if(CheckForEnemy(true, 1000.0000000))
        {
            EvaluateSituation();
        }
        //return;        
    }
Begin:

    stop;                
}

state Attack
{
    function BeginState(name PreviousStateName)
    {
        Focus = GetEnemy();
        //return;        
    }

    event ContinuedState()
    {
        // End:0x31
        if(Pawn.Mesh != none)
        {
            Pawn.Mesh.bUpdateAnimTree = true;
        }
        //return;        
    }

    event PoppedState()
    {
        // End:0x31
        if(Pawn.Mesh != none)
        {
            Pawn.Mesh.bUpdateAnimTree = true;
        }
        //return;        
    }

    event EndState(name NextStateName)
    {
        // End:0x31
        if(Pawn.Mesh != none)
        {
            Pawn.Mesh.bUpdateAnimTree = true;
        }
        //return;        
    }

    function OrientToEnemy()
    {
        local Vector toEnemy, enemyLoc;
        local Rotator ViewRotation;

        enemyLoc = GetEnemy().Location;
        enemyLoc.Z -= (GetEnemy().GetCollisionHeight() * 0.5000000);
        toEnemy = enemyLoc - Pawn.Location;
        toEnemy = Normal(toEnemy);
        ViewRotation = Rotator(toEnemy);
        Pawn.SetRotation(ViewRotation);
        //return;        
    }

    function StartStretchingToEnemy()
    {
        // End:0x2D
        if(GetEnemy().IsA('PlayerPawn'))
        {
            StartAction(3);            
        }
        else
        {
            StartAction(2);
        }
        Focus = GetEnemy();
        m_bStretchingTimedOut = false;
        m_bStretchingToEnemy = true;
        m_bLoopingDamageSequence = false;
        m_bAttachingToEnemy = false;
        //return;        
    }

    function StretchToEnemy()
    {
        local Vector posTentacleTip;
        local Rotator rotTentacleTip;
        local float Distance;
        local Actor HitActor;
        local Vector HitLocation, HitNormal, extentBox;
        local TraceHitInfo HitInfo;
        local PlayerPawn pPawn;
        local PlayerController PC;

        // End:0x55
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x54
            if((PandoraPlayerController(PC) != none) && PC.Pawn != none)
            {
                pPawn = PlayerPawn(PC.Pawn);
            }            
        }        
        // End:0x90
        if(Pawn.Mesh.GetSocketWorldLocationAndRotation('TentacleTip', posTentacleTip, rotTentacleTip) == false)
        {
            PopState();
        }
        extentBox = vect(20.0000000, 20.0000000, 20.0000000);
        Distance = VSize(posTentacleTip - GetEnemy().Location);
        // End:0x14F
        if((Distance < float(130)) && !m_bAttachingToEnemy)
        {
            // End:0xF6
            if(ForwardCollisionTest())
            {
                m_bCanForwardThrow = false;
            }
            Pawn.Mesh.bUpdateAnimTree = false;
            m_bAttachingToEnemy = AttachToEnemy();
            m_bPullingBack = true;
            m_bLoopingDamageSequence = true;
            m_bResetAttack = false;
            m_SewerTentaclePawn.NotifyStretchTimedOut();
        }
        // End:0x28A
        if(!m_bAttachingToEnemy && !m_bIdleRetract)
        {
            HitActor = Trace(HitLocation, HitNormal, GetEnemy().Location + (GetEnemy().PrePivot * 0.5000000), posTentacleTip, true, extentBox, HitInfo, 10, true);
            // End:0x221
            if((pPawn != none) && pPawn.m_bTentacleCollisionViewOn)
            {
                DrawDebugLine(GetEnemy().Location + (GetEnemy().PrePivot * 0.5000000), posTentacleTip, 255, 0, 0, true);
            }
            // End:0x26E
            if(((HitActor == none) || HitActor == (GetEnemy())) || IsWaterCollision(HitInfo.HitComponent))
            {
                OrientToEnemy();                
            }
            else
            {
                m_SewerTentaclePawn.NotifyStretchTimedOut();
                m_bCollisionHitWhileStretching = true;
            }
        }
        //return;        
    }

    function bool AttachToEnemy()
    {
        local Vector toEnemy;
        local Rotator ViewRotation;
        local Vector posTentacleTip;
        local Rotator rotTentacleTip;
        local Pawn pEnemyPawn;
        local SPPawn pSPEnemyPawn;

        pEnemyPawn = GetEnemy();
        pSPEnemyPawn = SPPawn(pEnemyPawn);
        // End:0x46
        if((pSPEnemyPawn != none) && pSPEnemyPawn.GetAttachedToTentacle())
        {
            return false;
        }
        // End:0x7B
        if(Pawn.Mesh.GetSocketWorldLocationAndRotation('TentacleTip', posTentacleTip, rotTentacleTip) == false)
        {
            return false;
        }
        // End:0x97
        if(int(pEnemyPawn.Physics) == int(9))
        {
            return false;
        }
        pSPEnemyPawn.SetAttachedToTentacle(true);
        pEnemyPawn.SetCollision(true, true);
        pEnemyPawn.bCollideWorld = true;
        pEnemyPawn.SetPhysics(0);
        toEnemy = Normal(Pawn.Location - pEnemyPawn.Location);
        ViewRotation = Rotator(toEnemy);
        pEnemyPawn.SetRotation(ViewRotation);
        // End:0x155
        if(pEnemyPawn.Controller != none)
        {
            pEnemyPawn.Controller.SetRotation(ViewRotation);
        }
        pSPEnemyPawn.m_bDestroyDestructibleBase = false;
        Pawn.AttachObject(pEnemyPawn, 'TentacleTip', pEnemyPawn.Location, ViewRotation, false, true);
        pEnemyPawn.m_bIgnoreBaseRotation = true;
        pSPEnemyPawn.ForceComponentsToUpdate(true, false);
        StartForceFeedBackEffect();
        SetTimer(0.6500000, false, 'StopForceFeedBackEffect');
        // End:0x229
        if(PlayerPawn(pEnemyPawn) != none)
        {
            PlayerPawn(pEnemyPawn).ShakeCamera(Class'SPDamageTypeTentacleGrab');
            PlaySound(m_SewerTentaclePawn.GrabbedSound, true);
        }
        SetTimer(0.2000000, true, 'CheckLocationForFailSafeCollisionPlacement');
        m_LastKnownValidEnemyLocation = pEnemyPawn.Location;
        return true;
        //return ReturnValue;        
    }

    function CheckBackwardsThrowing()
    {
        local Actor TempHitActor;
        local float BackwardsLength;
        local Vector BackwardsDirection, HitLocation, HitNormal, extentBox;
        local TraceHitInfo HitInfo;

        extentBox = vect(20.0000000, 20.0000000, 20.0000000);
        BackwardsLength = VSize(GetEnemy().Location - m_ThrowingVecBackwards);
        BackwardsLength *= 0.5000000;
        BackwardsDirection = Normal(m_ThrowingVecBackwards - GetEnemy().Location);
        BackwardsDirection = m_ThrowingVecBackwards + (BackwardsDirection * BackwardsLength);
        TempHitActor = none;
        TempHitActor = Trace(HitLocation, HitNormal, m_ThrowingVecBackwards, BackwardsDirection, true, extentBox, HitInfo, 10, true);
        // End:0xE2
        if((TempHitActor == none) || IsWaterCollision(HitInfo.HitComponent))
        {
            m_bThrowingAttackBackwards = true;
        }
        //return;        
    }

    function GetAttackCondition(bool bUseThrowAttack)
    {
        local Actor HitActor, TempHitActor;
        local Vector HitLocation, HitNormal, Right, RightPos, Left, LeftPos,
	        toEnemy, ConstUp, Dir, EDir, UpOriginalPos;

        local float HitDistance;
        local TraceHitInfo HitInfo, TempHitInfo;
        local int randomNum;
        local Vector extentBox;
        local int I;
        local Pawn pEnemyPawn;

        pEnemyPawn = GetEnemy();
        extentBox = vect(20.0000000, 20.0000000, 20.0000000);
        Dir = Normal(SPSewerTentaclePawnPersistent(Pawn).m_CollisionStartLocation - Pawn.Location);
        Dir *= 50.0000000;
        UpOriginalPos = SPSewerTentaclePawnPersistent(Pawn).m_CollisionStartLocation + Dir;
        ConstUp = Normal(SPSewerTentaclePawnPersistent(Pawn).m_CollisionStartLocation - Pawn.Location);
        m_ThrowingVecBackwards = UpOriginalPos;
        // End:0x133
        if(!SPSewerTentaclePawnPersistent(Pawn).m_bGroundTentacle)
        {
            Dir = Normal(Dir);
            EDir = Normal(pEnemyPawn.Location - Pawn.Location);
            // End:0x133
            if((Dir Dot EDir) < 0.7500000)
            {
                SPSewerTentaclePawnPersistent(Pawn).m_AttackState = 4;
                return;
            }
        }
        HitActor = Trace(HitLocation, HitNormal, pEnemyPawn.Location, UpOriginalPos, true,, HitInfo, 10, true);
        // End:0x79D
        if(((HitActor == none) || HitActor == pEnemyPawn) || IsWaterCollision(HitInfo.HitComponent))
        {
            randomNum = Rand(3);
            m_bRightAttackEnabled = false;
            m_bLeftAttackEnabled = false;
            m_bUpAttackEnabled = false;
            m_bRightAttackOccurred = false;
            m_bLeftAttackOccurred = false;
            m_bUpAttackOccurred = false;
            // End:0x1EF
            if(randomNum == 0)
            {
                m_bRightAttackEnabled = true;                
            }
            else
            {
                // End:0x205
                if(randomNum == 1)
                {
                    m_bLeftAttackEnabled = true;                    
                }
                else
                {
                    // End:0x219
                    if(randomNum == 2)
                    {
                        m_bUpAttackEnabled = true;
                    }
                }
            }
            toEnemy = pEnemyPawn.Location - UpOriginalPos;
            toEnemy = Normal(toEnemy);
            Right = ConstUp Cross toEnemy;
            Left = Right * float(-1);
            HitDistance = VSize(pEnemyPawn.Location - Pawn.Location);
            // End:0x77A
            if(HitDistance > float(800))
            {
                I = 0;
                J0x2A8:

                // End:0x77A [Loop If]
                if(I < 4)
                {
                    // End:0x488
                    if((m_bRightAttackEnabled && !m_bRightAttackOccurred) && SPSewerTentaclePawnPersistent(Pawn).m_bGroundTentacle)
                    {
                        RightPos = UpOriginalPos + (Right * float(100));
                        HitActor = Trace(HitLocation, HitNormal, RightPos, UpOriginalPos, true, extentBox, HitInfo, 10, true);
                        // End:0x397
                        if(((HitActor == none) || HitActor == pEnemyPawn) || IsWaterCollision(HitInfo.HitComponent))
                        {
                            TempHitActor = Trace(HitLocation, HitNormal, pEnemyPawn.Location, RightPos, true, extentBox, TempHitInfo, 10, true);
                        }
                        // End:0x432
                        if((((TempHitActor == none) || TempHitActor == pEnemyPawn) || IsWaterCollision(TempHitInfo.HitComponent)) && ((HitActor == none) || HitActor == pEnemyPawn) || IsWaterCollision(HitInfo.HitComponent))
                        {
                            SPSewerTentaclePawnPersistent(Pawn).m_AttackState = 1;
                            CheckBackwardsThrowing();
                            return;
                        }
                        m_bRightAttackEnabled = false;
                        m_bRightAttackOccurred = true;
                        // End:0x465
                        if(!m_bLeftAttackEnabled && !m_bLeftAttackOccurred)
                        {
                            m_bLeftAttackEnabled = true;                            
                        }
                        else
                        {
                            // End:0x485
                            if(!m_bUpAttackEnabled && !m_bUpAttackOccurred)
                            {
                                m_bUpAttackEnabled = true;
                            }
                        }
                        // [Explicit Continue]
                        goto J0x770;
                    }
                    // End:0x65C
                    if((m_bLeftAttackEnabled && !m_bLeftAttackOccurred) && SPSewerTentaclePawnPersistent(Pawn).m_bGroundTentacle)
                    {
                        LeftPos = UpOriginalPos + (Left * float(100));
                        HitActor = Trace(HitLocation, HitNormal, LeftPos, UpOriginalPos, true, extentBox, HitInfo, 10, true);
                        // End:0x56B
                        if(((HitActor == none) || HitActor == pEnemyPawn) || IsWaterCollision(HitInfo.HitComponent))
                        {
                            TempHitActor = Trace(HitLocation, HitNormal, pEnemyPawn.Location, LeftPos, true, extentBox, TempHitInfo, 10, true);
                        }
                        // End:0x606
                        if((((TempHitActor == none) || TempHitActor == pEnemyPawn) || IsWaterCollision(TempHitInfo.HitComponent)) && ((HitActor == none) || HitActor == pEnemyPawn) || IsWaterCollision(HitInfo.HitComponent))
                        {
                            SPSewerTentaclePawnPersistent(Pawn).m_AttackState = 2;
                            CheckBackwardsThrowing();
                            return;
                        }
                        m_bLeftAttackEnabled = false;
                        m_bLeftAttackOccurred = true;
                        // End:0x639
                        if(!m_bRightAttackEnabled && !m_bRightAttackOccurred)
                        {
                            m_bRightAttackEnabled = true;                            
                        }
                        else
                        {
                            // End:0x659
                            if(!m_bUpAttackEnabled && !m_bUpAttackOccurred)
                            {
                                m_bUpAttackEnabled = true;
                            }
                        }
                        // [Explicit Continue]
                        goto J0x770;
                    }
                    // End:0x770
                    if((m_bUpAttackEnabled && !m_bUpAttackOccurred) || !SPSewerTentaclePawnPersistent(Pawn).m_bGroundTentacle)
                    {
                        HitActor = Trace(HitLocation, HitNormal, pEnemyPawn.Location, UpOriginalPos, true,, HitInfo, 10, true);
                        // End:0x71D
                        if(((HitActor == none) || HitActor == pEnemyPawn) || IsWaterCollision(HitInfo.HitComponent))
                        {
                            SPSewerTentaclePawnPersistent(Pawn).m_AttackState = 0;
                            CheckBackwardsThrowing();
                            return;
                        }
                        m_bUpAttackEnabled = false;
                        m_bUpAttackOccurred = true;
                        // End:0x750
                        if(!m_bLeftAttackEnabled && !m_bLeftAttackOccurred)
                        {
                            m_bLeftAttackEnabled = true;
                            // [Explicit Continue]
                            goto J0x770;
                        }
                        // End:0x770
                        if(!m_bRightAttackEnabled && !m_bRightAttackOccurred)
                        {
                            m_bRightAttackEnabled = true;
                        }
                    }
                    J0x770:

                    I++;
                    // [Loop Continue]
                    goto J0x2A8;
                }
            }
            SPSewerTentaclePawnPersistent(Pawn).m_AttackState = 3;
            CheckBackwardsThrowing();
            return;
        }
        SPSewerTentaclePawnPersistent(Pawn).m_AttackState = 4;
        //return;        
    }

    function RemoveEnemyFromTentacle()
    {
        local Pawn pEnemyPawn;
        local Vector spotLoc;

        pEnemyPawn = GetEnemy();
        ClearTimer('CheckLocationForFailSafeCollisionPlacement');
        // End:0x78
        if((pEnemyPawn.Controller != none) && PandoraPlayerController(pEnemyPawn.Controller) != none)
        {
            PandoraPlayerController(pEnemyPawn.Controller).GotoState('ResumePlayerControl');
        }
        // End:0x149
        if((pEnemyPawn != none) && SPPawn(pEnemyPawn) != none)
        {
            pEnemyPawn.DetachObject(true);
            pEnemyPawn.SetPhysics(2);
            pEnemyPawn.m_bIgnoreBaseRotation = false;
            SPPawn(pEnemyPawn).SetAttachedToTentacle(false);
            spotLoc = pEnemyPawn.Location;
            // End:0x136
            if(!pEnemyPawn.FindSpot(pEnemyPawn.GetCollisionExtent(), spotLoc))
            {
                pEnemyPawn.SetLocation(m_LastKnownValidEnemyLocation);                
            }
            else
            {
                pEnemyPawn.SetLocation(spotLoc);
            }
        }
        //return;        
    }
Begin:

    OrientToEnemy();
    m_bThrowingAttack = false;
    m_bThrowingAttackBackwards = false;
    m_bCanForwardThrow = true;
    m_bCollisionHitWhileStretching = false;
    m_bIdleRetract = true;
    // End:0xA4
    if(!GetEnemy().IsA('PlayerPawn'))
    {
        // End:0x96
        if((float(Rand(100)) < m_TentacleGDTuneData.ThrowProbability) || m_TentacleGDTuneData.TryForceThrow)
        {
            GetAttackCondition(true);
            m_bThrowingAttack = true;            
        }
        else
        {
            GetAttackCondition(false);
        }        
    }
    else
    {
        GetAttackCondition(false);
    }
    // End:0x10A
    if(int(SPSewerTentaclePawnPersistent(Pawn).m_AttackState) == int(4))
    {
        SPSewerTentaclePawnPersistent(Pawn).SetResetAttackFromController();
        StartAction(0);
        GotoState('Idle', 'Begin', true, false);
    }
    Pawn.Mesh.SetHidden(false);
    StartStretchingToEnemy();
    J0x12F:

    // End:0x15A [Loop If]
    if(m_bStretchingToEnemy && !m_bStretchingTimedOut)
    {
        StretchToEnemy();
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x12F;
    }
    Pawn.Mesh.bUpdateAnimTree = true;
    // End:0x256
    if(m_bAttachingToEnemy && !m_bStretchingTimedOut)
    {
        // End:0x219
        if(m_bThrowingAttack && m_bCanForwardThrow || m_bThrowingAttackBackwards)
        {
            // End:0x1E0
            if((float(Rand(100)) < m_TentacleGDTuneData.ThrowForwardPercentage) && m_bCanForwardThrow)
            {
                StartAction(9);                
            }
            else
            {
                // End:0x1F9
                if(m_bThrowingAttackBackwards)
                {
                    StartAction(10);                    
                }
                else
                {
                    StartAction(9);
                }
            }
            m_bStretchingTimedOut = true;
            m_bLoopingDamageSequence = false;            
        }
        else
        {
            // End:0x246
            if(GetEnemy().IsA('PlayerPawn'))
            {
                StartAction(4);                
            }
            else
            {
                StartAction(5);
            }
        }        
    }
    else
    {
        // End:0x27C
        if(m_bStretchingTimedOut && !m_bCollisionHitWhileStretching)
        {
            StartAction(6);            
        }
        else
        {
            // End:0x29D
            if(m_bStretchingTimedOut && m_bCollisionHitWhileStretching)
            {
                StartAction(7);
            }
        }
    }
    J0x29D:

    // End:0x2B1 [Loop If]
    if(m_bPullingBack)
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x29D;
    }
    J0x2B1:

    // End:0x2C5 [Loop If]
    if(m_bLoopingDamageSequence)
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x2B1;
    }
    StartAction(0);
    GotoState('Idle', 'Begin', true, false);
    stop;                
}

state ControllerDying
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function NotifyDied()
    {
        PopState();
        GotoState('WaitingForTheInevitable');
        //return;        
    }
Begin:

    stop;                
}

state WaitingForTheInevitable
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }
    stop;    
}
