class CustomPerformanceBrainState extends AxonControllerBrainState;

var FixedFireOIRImpl FFImpl;
var export editinline AxonAnimService AnimService;
var export editinline LODStatusScriptEvent LODStatusEvent;
var export editinline MOHAGotoService GotoService;
var array<Vector> newPointPositions;
var float fPointDirectionMaxDistance;
var float fRunToPointDist;
var Vector vLookAheadPos;
var name CCPerformance;

function RegisterActivationEvents()
{
    RegisterAxonActivationNamedScriptEventListener('PerformancePoint', ActivationEventTripped, 12);
    //return;    
}

function ActivationEventTripped()
{
    // End:0x28
    if(!GetCallbackParamName('CCStimulus', CCPerformance))
    {
        CCPerformance = 'None';
    }
    FFImpl = MOHAAIPawn(GetBot()).FFImpl;
    newPointPositions.Length = 0;
    Class'MOHASquad'.static.PopPositionsForPerformance(self, newPointPositions);
    // End:0xB9
    if(newPointPositions.Length == 0)
    {
        newPointPositions[0] = Controller.Pawn.Location + (float(512) * Vector(Controller.Pawn.Rotation));        
    }
    else
    {
        ClampPointDirectionsToDistance();
        RemoveDuplicatePointDirections();
    }
    ActivateBrain();
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(12);
    Controller.bPerformingCustomPerformance = true;
    // End:0x3C
    if(!TryRuntoPoint())
    {
        GotoState('Point');
    }
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function StandardFinish()
{
    Controller.bPerformingCustomPerformance = false;
    FFImpl.ResetPointTarget();
    super(AxonBrainState).StandardFinish();
    //return;    
}

function bool TryRuntoPoint()
{
    // End:0x27
    if(FindRunaheadPoint(fRunToPointDist, vLookAheadPos))
    {
        GotoState('RunToPoint');
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ContainsPointDirection(int Direction, array<int> existingDirections)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < existingDirections.Length)
    {
        // End:0x2E
        if(existingDirections[I] == Direction)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function RemoveDuplicatePointDirections()
{
    local array<int> pointDirection;
    local int I, newPointDirection;

    // End:0x0E
    if(newPointPositions.Length == 1)
    {
        return;
    }
    pointDirection[0] = FFImpl.GetQuadrantFromPoint(newPointPositions[newPointPositions.Length - 1]);
    I = newPointPositions.Length - 2;
    J0x48:

    // End:0xD8 [Loop If]
    if(I >= 0)
    {
        newPointDirection = FFImpl.GetQuadrantFromPoint(newPointPositions[I]);
        // End:0xBC
        if(ContainsPointDirection(newPointDirection, pointDirection))
        {
            newPointPositions[I] = newPointPositions[newPointPositions.Length - 1];
            newPointPositions.Length = newPointPositions.Length - 1;
            // [Explicit Continue]
            goto J0xCE;
        }
        pointDirection[pointDirection.Length] = newPointDirection;
        J0xCE:

        I--;
        // [Loop Continue]
        goto J0x48;
    }
    //return;    
}

function ClampPointDirectionsToDistance()
{
    local Vector vForwardNormalized, vProjected;
    local int I;
    local float fVectorSize;

    // End:0x11
    if(fPointDirectionMaxDistance == 0.0000000)
    {
        return;
    }
    vForwardNormalized = Vector(Controller.Pawn.Rotation);
    I = 0;
    J0x37:

    // End:0xD1 [Loop If]
    if(I < newPointPositions.Length)
    {
        vProjected = vForwardNormalized * (vForwardNormalized Dot (newPointPositions[I] - Controller.Pawn.Location));
        fVectorSize = VSize(vProjected);
        // End:0xC7
        if(fVectorSize > fPointDirectionMaxDistance)
        {
            newPointPositions[I] = newPointPositions[I] + ((fPointDirectionMaxDistance - fVectorSize) * vForwardNormalized);
        }
        I++;
        // [Loop Continue]
        goto J0x37;
    }
    //return;    
}

state RunToPoint extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        GotoService.SubstateGotoOIR(ArriveAtFixedFire, vLookAheadPos,, 'Aim',, Controller.fMoveSpeed);
        //return;        
    }

    function ArriveAtFixedFire()
    {
        GotoState('Point');
        //return;        
    }
    stop;    
}

state Point extends AxonBaseBookshelfState
{
    event ChildBeginState(name PreviousStateName)
    {
        // End:0x3D
        if(CCPerformance != 'None')
        {
            Controller.SendCCStimulus(string(CCPerformance));
            CCPerformance = 'None';
        }
        FFImpl.SetPointTarget(newPointPositions[newPointPositions.Length - 1]);
        MOHAAIPawn(GetBot()).UpdateFixedFireOIR(GetBotLocation());
        AnimService.RegisterAnimationEvent('Point', AnimDone, FFImpl);
        LODStatusEvent.RegisterLODStatusChangeEvent(Controller, WentToSleep);
        //return;        
    }

    function WentToSleep()
    {
        FinishBrain();
        //return;        
    }

    function AnimDone()
    {
        newPointPositions.Length = newPointPositions.Length - 1;
        // End:0x29
        if(newPointPositions.Length == 0)
        {
            FinishBrain();            
        }
        else
        {
            GotoState('Point',, true);
        }
        //return;        
    }

    function ChildEndState(name NextStateName)
    {
        FFImpl.ResetPointTarget();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonAnimService'Default__CustomPerformanceBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: LODStatusScriptEvent'Default__CustomPerformanceBrainState.LODStatusEvent0'
    begin object name=LODStatusEvent0 class=Class'LODStatusScriptEvent'
    end object
    LODStatusEvent=LODStatusEvent0
    // Reference: MOHAGotoService'Default__CustomPerformanceBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    fPointDirectionMaxDistance=1500.0000000
    fRunToPointDist=500.0000000
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}