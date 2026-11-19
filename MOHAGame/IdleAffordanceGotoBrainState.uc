class IdleAffordanceGotoBrainState extends AffordanceGotoBrainState;

var KynapseCoverNode newCoverNode;
var Vector CoverTraversalStart;

function ResumeBrain(AxonBrainState usurperState)
{
    BrainEnded();
    //return;    
}

function ArrivedAtAffordance()
{
    GotoState('RunGetTraversalStart',, true);
    //return;    
}

function RegisterCustomSubstateTransition()
{
    AffordanceService.SubstateCheckArrivedAtAffordance(ArrivedAtAffordance);
    //return;    
}

function PushCustomCoverConstraints()
{
    CoverService.PushWithinLeashCoverConstraint(, instanceID);
    CoverService.PushWithinAffordanceCoverConstraint(,,, true, instanceID);
    CoverService.PushTacticalAffordanceCoverConstraint(, 2000.0000000, 2000.0000000, 5000.0000000, 8000.0000000, instanceID);
    //return;    
}

state RunGetTraversalStart extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        // End:0x47
        if(bRunPositionSet)
        {
            GotoService.SubstateGotoOIR(Dummy, RunPosition,, 'Aim',, Controller.fMoveSpeed);
        }
        AffordanceService.GetTacticalAffordanceTraversalStart(OnGetTraversalStart);
        //return;        
    }

    function OnGetTraversalStart()
    {
        // End:0x3A
        if(!AffordanceService.GetTacAffTraversalStartResult(CoverTraversalStart))
        {
            CoverTraversalStart = Controller.Pawn.Location;
        }
        // End:0x5D
        if(Controller.bUsesCover)
        {
            GotoState('RunLookForCover');            
        }
        else
        {
            GotoState('RunLookForPoint');
        }
        //return;        
    }
    stop;    
}

state RunLookForPoint
{
    function ChildRegisterPointConstraints()
    {
        PointService.PushBasicAggressorFindCoverPointConstraints(Controller, true, instanceID);
        PointService.PushPointClaimedConstraint(, instanceID);
        //return;        
    }

    function FoundPoint()
    {
        PointService.OnFindPointCallBack();
        // End:0x3F
        if(PointService.GetNumNodesFound() <= 0)
        {
            GotoState('wait');
            return;            
        }
        else
        {
            bRunPositionSet = true;
            RunPosition = PointService.GetNode(0);
            GotoState('PostAffArrivalRunToPoint');
        }
        //return;        
    }
    stop;    
}

state PostAffArrivalRunToPoint extends RunToPoint
{    stop;    
}

state wait
{
    function TimerDone()
    {
        GotoState('RunGetTraversalStart');
        //return;        
    }
    stop;    
}

state RunLookForCover extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        // End:0x4F
        if(bRunPositionSet)
        {
            GotoService.SubstateGotoOIR(Dummy, RunPosition,, 'Aim',, Controller.fMoveSpeed,,,, 'Temp');
        }
        CoverService.SubstateFindCover(20, 250, CoverTraversalStart, FoundCover, instanceID);
        CoverService.ClearCoverConstraints(, instanceID);
        PointService.PushBasicAggressorFindCoverPointConstraints(Controller, true, instanceID);
        PushCustomCoverConstraints();
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        ClearEventMapEntry('Temp');
        //return;        
    }

    function Dummy()
    {
        ClearEventMapEntry('Temp');
        //return;        
    }

    function FoundCover()
    {
        CoverService.OnFindCoverCallback();
        // End:0x3D
        if(CoverService.GetNumNodesFound() <= 0)
        {
            GotoState('RunLookForPoint');            
        }
        else
        {
            newCoverNode = CoverService.GetCoverNode(0);
            GotoState('RunTryClaimCover');
        }
        //return;        
    }
    stop;    
}

state RunTryClaimCover extends ParentState
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
            GotoState('RunLookForCover');            
        }
        else
        {
            GotoState('RunToCover');
        }
        //return;        
    }
    stop;    
}

state LookForCover extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        CoverService.SubstateFindCover(30, 250, CoverTraversalStart, FoundCover, instanceID);
        CoverService.ClearCoverConstraints(, instanceID);
        PushCustomCoverConstraints();
        //return;        
    }

    function FoundCover()
    {
        CoverService.OnFindCoverCallback();
        // End:0x39
        if(CoverService.GetNumNodesFound() <= 0)
        {
            BrainEnded();            
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

state TryClaimCover extends ParentState
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
            GotoState('LookForCover');            
        }
        else
        {
            GotoState('RunToCover');
        }
        //return;        
    }
    stop;    
}

state RunToCover extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        MOHAPawn(Controller.Pawn).DesiredPosture = GotoService.GetDesiredPosture(2);
        GotoService.SubstateGotoOIR(ArrivedAtCover,, newCoverNode, 'Hide',, Controller.fMoveSpeed);
        //return;        
    }

    function ArrivedAtCover()
    {
        // End:0x3E
        if(GotoService.GetMoveFailed())
        {
            CoverService.ClearCover(3000);
            GotoState('LookForCover');
            return;
        }
        GotoState('Hide');
        //return;        
    }
    stop;    
}

state Hide extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        AnimService.RegisterAnimationEvent('Hide', Finish, Controller.GetCurrentCoverNode(),,, Controller.fCoverHideTransitionSpeedMultiplier);
        //return;        
    }

    function Finish()
    {
        BrainEnded();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHACoverService'Default__IdleAffordanceGotoBrainState.CoverService0'
    begin object name=CoverService0
    end object
    CoverService=CoverService0
    // Reference: MOHAGotoService'Default__IdleAffordanceGotoBrainState.GotoFNCService0'
    begin object name=GotoFNCService0
    end object
    GotoService=GotoFNCService0
    // Reference: AxonAnimService'Default__IdleAffordanceGotoBrainState.AnimService0'
    begin object name=AnimService0
    end object
    AnimService=AnimService0
    // Reference: AxonAffordanceService'Default__IdleAffordanceGotoBrainState.AffordanceService0'
    begin object name=AffordanceService0
    end object
    AffordanceService=AffordanceService0
    // Reference: AxonPointService'Default__IdleAffordanceGotoBrainState.PointService0'
    begin object name=PointService0
    end object
    PointService=PointService0
    iSuppressionLevel=4
    instanceID="IdleAffordance"
    EventServices=/* Array type was not detected. */
}