class SkyAIController extends AIController
    abstract
    native
    config(AI);

var transient Actor LastDamageCauser;
var(TargetableSockets) int TargetableSocketsPreferenceChannel;
var() bool bIgnoreThreatDecayBonuses;
var(Debug) config bool bAILogging;
var(Debug) config bool bAILogToWindow;
var transient Actor EnemyWithThreatBonusDecay;
var() float EnemyThreatBonusDecayTime;
var transient float EnemyThreatBonusAmount;
var FileLog AILogFile;
var config array<config name> AILogFilter;

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
    // End:0x3C
    if(HUD.ShouldDisplayDebug('SkyLines'))
    {
        Pawn.DisplayDebugSkyLines(HUD);        
    }
    else
    {
        Pawn.FlushSkyLines();
    }
    //return;    
}

event AILog_Internal(coerce string LogText, optional name LogCategory, optional bool bForce)
{
    //return;    
}

event Destroyed()
{
    // End:0x2C
    if(AILogFile != none)
    {
        AILogFile.CloseLog();
        AILogFile.Destroy();
    }
    super(Controller).Destroyed();
    //return;    
}

simulated function SkyBotControllerPilot GetPilotController(AIController C)
{
    local SkyBotControllerPilot ret;

    // End:0x20
    if(SkyBotControllerPilot(C) != none)
    {
        ret = SkyBotControllerPilot(C);
    }
    // End:0x91
    if(((ret == none) && SkyPawn(C.Pawn) != none) && SkyPawn(C.Pawn).StoredRocketPackThrustController != none)
    {
        ret = SkyPawn(C.Pawn).StoredRocketPackThrustController;
    }
    return ret;
    //return ReturnValue;    
}

simulated function EnemyThreatBonusCountDown()
{
    EnemyThreatBonusAmount -= (EnemyThreatBonusDecayTime * 0.2000000);
    // End:0x69
    if(((EnemyThreatBonusAmount <= 0.0000000) || EnemyWithThreatBonusDecay == none) || EnemyWithThreatBonusDecay.bDeleteMe == true)
    {
        EnemyThreatBonusAmount = 0.0000000;
        EnemyWithThreatBonusDecay = none;
        ClearTimer('EnemyThreatBonusCountDown');
    }
    //return;    
}

simulated function OnLockEnemy(SkySeqAct_LockEnemy Action)
{
    local array<Object> objVars;
    local int Idx, num;
    local Actor targ;
    local Controller C;

    // End:0x1F
    if(Action.bClearEnemy)
    {
        ClearLockedEnemy();
        return;
    }
    Action.GetObjectVars(objVars, "Enemy");
    num = objVars.Length;
    Idx = 0;
    J0x4E:

    // End:0xD0 [Loop If]
    if(Idx < num)
    {
        C = Controller(objVars[Idx]);
        // End:0x96
        if(C != none)
        {
            targ = C.Pawn;            
        }
        else
        {
            targ = Actor(objVars[Idx]);
        }
        // End:0xC6
        if(targ != none)
        {
            LockEnemy(targ);
        }
        Idx++;
        // [Loop Continue]
        goto J0x4E;
    }
    //return;    
}

simulated function OnSetSocketPreferenceChannel(SkySeqAct_SetSocketPreferenceChannel Action)
{
    local array<Object> objVars;
    local int Idx, num;
    local Object targ;
    local SkyAIController C;

    Action.GetObjectVars(objVars, "Target");
    num = objVars.Length;
    Idx = 0;
    J0x30:

    // End:0xD3 [Loop If]
    if(Idx < num)
    {
        targ = objVars[Idx];
        // End:0x70
        if(SkyAIController(targ) != none)
        {
            C = SkyAIController(targ);
        }
        // End:0x9F
        if(Pawn(targ) != none)
        {
            C = SkyAIController(Pawn(targ).Controller);
        }
        // End:0xC9
        if(C != none)
        {
            C.TargetableSocketsPreferenceChannel = Action.SocketPreferenceChannel;
        }
        Idx++;
        // [Loop Continue]
        goto J0x30;
    }
    //return;    
}

simulated function ClearLockedEnemy()
{
    //return;    
}

simulated function LockEnemy(Actor newEnemy)
{
    //return;    
}

simulated function HandleEnemySwitchedPawn(Pawn OldPawn, Pawn NewPawn)
{
    // End:0x1A
    if(Enemy == OldPawn)
    {
        Enemy = NewPawn;
    }
    // End:0x34
    if(ScriptedMoveTarget == OldPawn)
    {
        ScriptedMoveTarget = NewPawn;
    }
    // End:0x4E
    if(ScriptedFocus == OldPawn)
    {
        ScriptedFocus = NewPawn;
    }
    // End:0x68
    if(MoveTarget == OldPawn)
    {
        MoveTarget = NewPawn;
    }
    // End:0x82
    if(Focus == OldPawn)
    {
        Focus = NewPawn;
    }
    //return;    
}

function bool CanAttack(Actor Other)
{
    return Pawn.CanAttack(Other);
    //return ReturnValue;    
}

function GetSecondaryThrowableDirSpeed(out Vector AimDir, out Vector ExtraVel)
{
    AimDir = Vector(Rotation);
    ExtraVel = vect(0.0000000, 0.0000000, 0.0000000);
    //return;    
}

simulated event NotifyEnterCoverFinished()
{
    //return;    
}

simulated event NotifyExitCoverFinished()
{
    //return;    
}

simulated function OnGodSight(SkySeqAct_GodSight GSAction)
{
    //return;    
}

function OnAIFreeze(SkySeqAct_AIFreeze FreezeAction)
{
    //return;    
}

simulated function OnIgnorePawn(SkySeqAct_IgnorePawn inAction)
{
    //return;    
}

event AIFactoryMoveTo(Actor destActor, optional bool bMoveInterruptable, optional Actor MoveFocus)
{
    ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', true, none);
    // End:0xAE
    if(destActor != none)
    {
        ScriptedRoute = Route(destActor);
        // End:0x73
        if(ScriptedRoute != none)
        {
            // End:0x4E
            if(ScriptedRoute.RouteList.Length == 0)
            {                
            }
            else
            {
                // End:0x70
                if(!IsInState('ScriptedRouteMove'))
                {
                    PushState('ScriptedRouteMove');
                }
            }            
        }
        else
        {
            ScriptedMoveTarget = destActor;
            // End:0xA0
            if(!IsInState('ScriptedMove'))
            {
                PushState('ScriptedMove');
            }
        }
        ScriptedFocus = MoveFocus;        
    }
    //return;    
}

event PostBeginPlay()
{
    bAILogging = SkyGame(WorldInfo.Game).bAILogging;
    super(Controller).PostBeginPlay();
    //return;    
}

function SetFall()
{
    //return;    
}

simulated function OnAILedges(SkySeqAct_AILedges inAction)
{
    Pawn.bCanWalkOffLedges = inAction.bCanWalkOffLedges;
    Pawn.bStopAtLedges = Pawn.bCanWalkOffLedges;
    Pawn.bAvoidLedges = Pawn.bCanWalkOffLedges;
    //return;    
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    super(Controller).Possess(aPawn, bVehicleTransition);
    //return;    
}

event UnPossess()
{
    super(Controller).UnPossess();
    //return;    
}

function PawnDied(Pawn inPawn)
{
    super(Controller).PawnDied(inPawn);
    //return;    
}

function bool CheckFirePermit(Actor TargetActor)
{
    local SkyGame GameInfo;

    GameInfo = SkyGame(WorldInfo.Game);
    // End:0x6D
    if((GameInfo == none) || !GameInfo.AcquireFirePermit(self, (Pawn(TargetActor) != none) && PlayerController(Pawn(TargetActor).Controller) != none))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

state DEBUGSTATE
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function PushedState()
    {
        //return;        
    }

    function PoppedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    function PausedState()
    {
        //return;        
    }
    stop;    
}
