class GTFOActivationService extends AxonFSMService;

var int SuppressionLevel;
var float EgressRadius;
var Vector vDestPoint;
var export editinline AxonPointService PointService;
var Vector BlockingEntLoc;
var Vector BlockedEntLoc;
var Rotator BlockedEntRot;
var float ArcDegrees;
var float DegreesPerCanGo;
var int NumCanGoChecks;
var int ForceActivate;
var Actor BlockedEnt;
var MOHAScriptAIController Controller;

function StartFSMService()
{
    ForceActivate = 0;
    GotoState('WaitForStimulus');
    //return;    
}

function RegisterUnBlockingConstraints()
{
    local Vector vDir, vCompPt;

    PointService.ClearPointConstraints(mInstanceID);
    PointService.PushPointClaimedConstraint(EgressRadius, mInstanceID);
    vDir = Normal(AxonControllerBrainState(owningBrainState).GetBotLocation() - BlockedEntLoc);
    vCompPt = (vDir * EgressRadius) * 3.0000000;
    PointService.PushPointDistanceEnvelopeConstraint(0.0000000, EgressRadius * 2.5000000, 0.0000000, EgressRadius * 2.5000000, vCompPt, 0.0000000, true, mInstanceID);
    //return;    
}

state WaitForStimulus extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationStimulus('GTFO', 'GTFO', GetOutOfTheWay, SuppressionLevel, 'Spine1');
        //return;        
    }

    function GetOutOfTheWay()
    {
        local StimulusSenderSubscription send;
        local StimulusListenerSubscription lis;
        local PlayerController PC;
        local Rotator dontcare;

        owningBrainState.GetCallbackParamListener('Listener', lis);
        owningBrainState.GetCallbackParamSender('Sender', send);
        BlockedEnt = send.Owner.Owner;
        ForceActivate = 0;
        send.Owner.GetStimuliSenderParamInt('GTFO2', 'ForceActivate', ForceActivate);
        // End:0x11B
        if(ForceActivate == 0)
        {
            PC = PlayerController(BlockedEnt);
            // End:0x11B
            if(((PC == none) || PC.Pawn == none) || (VSizeSq(PC.Pawn.Acceleration) < 0.0500000) && Abs(PC.PlayerInput.RawJoyUp) <= 0.0500000)
            {
                return;
            }
        }
        BlockedEntLoc = Controller(BlockedEnt).Pawn.Location;
        lis.Owner.GetListenerPosition(lis, BlockingEntLoc, dontcare);
        GotoState('FindUnBlockingPoint');
        //return;        
    }
    stop;    
}

state Waiting extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonSubstateTimer(5.0000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('WaitForStimulus');
        //return;        
    }
    stop;    
}

state FindUnBlockingPoint extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        // End:0x22
        if(!FindClosePoint())
        {
            GotoState('TraversalFindUnBlockingPoint');
            return;            
        }
        else
        {
            Finish();
        }
        //return;        
    }

    function bool FindClosePoint()
    {
        local int I;
        local AxonControllerBrainState cbs;
        local Vector vTestPos;
        local Rotator collisionrot, addRot, temprot;
        local int yawIncrement, numits;

        cbs = AxonControllerBrainState(owningBrainState);
        BlockedEntLoc.Z = BlockingEntLoc.Z;
        // End:0x8E
        if((Controller.Pawn != none) && VSizeSq(Controller.Pawn.Velocity) > 100.0000000)
        {
            collisionrot = Rotator(Controller.Pawn.Velocity);            
        }
        else
        {
            collisionrot = Rotator(BlockingEntLoc - BlockedEntLoc);
        }
        collisionrot.Pitch = 0;
        collisionrot.Roll = 0;
        addRot.Yaw = int((ArcDegrees / float(2)) * 182.0000000);
        numits = int(ArcDegrees / DegreesPerCanGo);
        // End:0x129
        if((float(numits) % float(2)) == float(0))
        {
            addRot.Yaw *= float(-1);
        }
        yawIncrement = int(DegreesPerCanGo * 182.0000000);
        I = numits;
        J0x148:

        // End:0x1F2 [Loop If]
        if(I >= 0)
        {
            vTestPos = BlockingEntLoc + (Vector(collisionrot + addRot) * EgressRadius);
            // End:0x1A9
            if(cbs.Controller.PathableCanGo(BlockingEntLoc, vTestPos))
            {
                vDestPoint = vTestPos;
                return true;
            }
            temprot.Yaw = int(float(yawIncrement * I) * (float(-1) ** float(I)));
            addRot += temprot;
            I--;
            // [Loop Continue]
            goto J0x148;
        }
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state TraversalFindUnBlockingPoint extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        local AxonControllerBrainState cbs;

        cbs = AxonControllerBrainState(owningBrainState);
        PointService.RegisterAxonActivationFindPoint(1, 250, cbs.GetBotLocation(), FoundPoint, SuppressionLevel, mInstanceID);
        RegisterUnBlockingConstraints();
        //return;        
    }

    function FoundPoint()
    {
        PointService.OnFindPointCallBack();
        // End:0x3F
        if(PointService.GetNumNodesFound() <= 0)
        {
            GotoState('Waiting');
            return;            
        }
        else
        {
            vDestPoint = PointService.GetNode(0);
            Finish();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    EgressRadius=150.0000000
    ArcDegrees=200.0000000
    DegreesPerCanGo=20.0000000
    NumCanGoChecks=5
    mInstanceID="GTFOAcivation"
}