class CoverWanderBrainState extends AxonControllerBrainState;

var() float waitDuration;
var() float MinWanderDist;
var() float MaxWanderDist;
var Vector vDest;
var Vector StartPoint;
var Vector Destination;
var int StuckCount;
var export editinline AxonPointService PointService;
var export editinline MOHAGotoService GotoService;
var export editinline AxonAnimService AnimService;
var export editinline AxonCoverService CoverService;
var KynapseCoverNode newCoverNode;
var bool bTakeScreenshots;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(15);
    bTakeScreenshots = Controller.ShouldTakeScreenshotsForDebug();
    GotoState('wait');
    //return;    
}

function FinishBrain()
{
    super(AxonBrainState).FinishBrain();
    //return;    
}

function TimerDone()
{
    //return;    
}

function arrived()
{
    //return;    
}

function RegisterActivationEvents()
{
    RegisterAxonActivationTimer(0.0000000, ActivationEventTripped, 15);
    //return;    
}

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

function PlayerController GetPC()
{
    local PlayerController PC;

    // End:0x1F
    foreach Controller.LocalPlayerControllers(PC)
    {        
        return PC;        
    }    
    return none;
    //return ReturnValue;    
}

function IssueConsoleCommand(string Command)
{
    local PlayerController PC;

    PC = GetPC();    
    PC.ConsoleCommand(Command);
    //return;    
}

function TakeScreenshot(string Text)
{
    local Vector vBoom;
    local int I, precision;
    local Rotator rotateBy;
    local PlayerController PC;
    local Rotator rotatePlayer;
    local Vector vHit, vNorm, vStart, vEnd;

    precision = 8;
    rotateBy.Pitch = int(float(45) * 182.0000000);
    rotateBy.Yaw = int((FRand() * 360.0000000) * 182.0000000);
    vBoom = Vector(rotateBy);
    vBoom *= 1000.0000000;
    rotateBy.Pitch = 0;
    rotateBy.Yaw = int(float(360 / precision) * 182.0000000);
    I = 0;
    J0x9F:

    // End:0x211 [Loop If]
    if(I < precision)
    {
        vStart = Controller.Pawn.Location + vBoom;
        vEnd = Controller.Pawn.Location;
        // End:0x1F4
        if(Controller.Trace(vHit, vNorm, vEnd, vStart) == none)
        {
            PC = GetPC();
            // End:0x160
            if(!PC.IsInState('PlayerFlying'))
            {
                PC.CheatManager.Ghost();
            }
            PC.Pawn.SetLocation(vStart);
            rotatePlayer = Rotator(vEnd - vStart);
            rotatePlayer.Pitch = int(-22.5000000 * 182.0000000);
            PC.SetRotation(rotatePlayer);
            PC.UpdateRotation(0.0000000);
            MOHAPlayerController(PC).TakeScreenshotNextFrame(Text);
            return;
        }
        vBoom = vBoom >> rotateBy;
        I++;
        // [Loop Continue]
        goto J0x9F;
    }
    //return;    
}

state wait extends AxonBaseBookshelfState
{
    event ChildBeginState(name PreviousStateName)
    {
        StartPoint = Controller.Pawn.Location;
        RegisterAxonSubstateTimer(waitDuration, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        // End:0x5A
        if(StuckCount > 3)
        {
            Controller.__NFUN_278__(Controller.Pawn.Class,,, Controller.Location);
            Controller.Pawn.Destroy();            
        }
        else
        {
            GotoState('GatherPoints');
        }
        //return;        
    }
    stop;    
}

state GatherPoints extends AxonBaseBookshelfState
{
    event ChildBeginState(name PreviousStateName)
    {
        local Vector startPos;

        startPos = GetBotLocation();
        PointService.SubstateFindPoint(25, 512, startPos, FoundPoints, 'CoverWander');
        PointService.ClearPointConstraints('CoverWander');
        PointService.PushPointClaimedConstraint(100.0000000, 'CoverWander');
        PointService.PushPointDistanceEnvelopeConstraint(MinWanderDist, MaxWanderDist, MinWanderDist * 1.1000000, MaxWanderDist * 0.9000000, GetBotLocation(), 50.0000000,, 'CoverWander');
        //return;        
    }

    function FoundPoints()
    {
        local int I;

        PointService.OnFindPointCallBack();
        // End:0x3C
        if(PointService.GetNumNodesFound() <= 0)
        {
            GotoState('wait');
            return;
        }
        I = Rand(PointService.GetNumNodesFound());
        vDest = PointService.GetNode(I);
        GotoState('FindCover');
        //return;        
    }
    stop;    
}

state FindCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.SubstateFindCover(30, 250, vDest, FoundCover);
        CoverService.ClearCoverConstraints();
        //return;        
    }

    function FoundCover()
    {
        CoverService.OnFindCoverCallback();
        // End:0x3D
        if(CoverService.GetNumNodesFound() <= 0)
        {
            GotoState('wait');            
        }
        else
        {
            newCoverNode = CoverService.GetCoverNode(0);
            GotoState('TryClaimCover');
        }
        //return;        
    }
    stop;    
}

state TryClaimCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.ClaimCover(newCoverNode.GetId(), ClaimResult);
        //return;        
    }

    function ClaimResult()
    {
        // End:0x29
        if(!CoverService.GetClaimResult())
        {
            GotoState('FindCover');            
        }
        else
        {
            GotoState('RunToCover');
        }
        //return;        
    }
    stop;    
}

state RunToCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        Destination = newCoverNode.GetPosition();
        GotoService.SubstateGotoOIR(ArrivedAtCover,, newCoverNode, 'Hide',, 500.0000000);
        //return;        
    }

    function ArrivedAtCover()
    {
        local int bs;
        local Vector lastSubgoal;

        // End:0x114
        if(GotoService.GetMoveFailed())
        {
            // End:0xCA
            if(bTakeScreenshots && GetCallbackParamInt('MOVE_TIMEOUT', bs))
            {
                // End:0x85
                if(GetCallbackParamVector('lastSubgoal', lastSubgoal))
                {
                    Class'Engine.Actor'.static.DrawDebugLine(Controller.Pawn.Location, lastSubgoal, byte(255), byte(255), 0, true);
                }
                TakeScreenshot((("MOVE TIMEOUT GOING FROM" @ string(StartPoint)) @ "TO") @ string(Destination));
                StuckCount++;                
            }
            else
            {
                // End:0xEC
                if(bTakeScreenshots && GetCallbackParamInt('PATH_NOT_FOUND', bs))
                {
                }
            }
            CoverService.ClearCover(1000);
            GotoState('wait');
            return;
        }
        StuckCount = 0;
        GotoState('Hide');
        //return;        
    }
    stop;    
}

state Hide extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Hide', Finish, Controller.GetCurrentCoverNode());
        //return;        
    }

    function Finish()
    {
        local Vector Forward, coverForward;
        local float Epsilon;

        Forward = vect(0.0000000, 0.0000000, 0.0000000) - Vector(Controller.Pawn.Rotation);
        coverForward = Controller.GetCurrentCoverNode().GetCoverDir();
        Epsilon = 0.0500000;
        // End:0x1CB
        if(bTakeScreenshots && Abs(1.0000000 - (coverForward Dot Forward)) > Epsilon)
        {
            Class'Engine.Actor'.static.DrawDebugLine(Controller.GetCurrentCoverNode().GetPosition(), Controller.GetCurrentCoverNode().GetPosition() + (coverForward * 50.0000000), byte(255), 0, 0, true);
            Class'Engine.Actor'.static.DrawDebugLine(Controller.Pawn.Location, Controller.Pawn.Location + (Forward * 50.0000000), 0, byte(255), 0, true);
            TakeScreenshot((((((("NPC IN COVER IS NOT ROTATED CORRECTLY - COVER ROTATION:" @ string(Rotator(coverForward))) @ "PAWN ROTATION:") @ string(Rotator(Forward))) @ "GOING FROM") @ string(StartPoint)) @ "TO") @ string(Destination));
        }
        GotoState('wait');
        //return;        
    }
    stop;    
}

defaultproperties
{
    waitDuration=1.0000000
    MinWanderDist=3000.0000000
    MaxWanderDist=10000.0000000
    // Reference: AxonPointService'Default__CoverWanderBrainState.PointService0'
    begin object name=PointService0 class=Class'EAKynapse.AxonPointService'
    end object
    PointService=PointService0
    // Reference: MOHAGotoService'Default__CoverWanderBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    // Reference: AxonAnimService'Default__CoverWanderBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: MOHACoverService'Default__CoverWanderBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    EventServices=/* Array type was not detected. */
}