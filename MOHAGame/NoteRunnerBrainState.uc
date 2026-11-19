class NoteRunnerBrainState extends AxonControllerBrainState;

var export editinline MOHAGotoService GotoService;
var float DesiredSpeed;
var Note MyNote;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    GotoState('MoveToPoint');
    //return;    
}

state MoveToPoint extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        local Note P, furthest;
        local float dist, maxdist;

        maxdist = 0.0000000;
        // End:0x95
        foreach Controller.AllActors(Class'Engine.Note', P)
        {
            // End:0x94
            if(P.Text != "claimed")
            {
                dist = VSize(Controller.Pawn.Location - P.Location);
                // End:0x94
                if(dist > maxdist)
                {
                    maxdist = dist;
                    furthest = P;
                }
            }            
        }        
        // End:0x102
        if(furthest != none)
        {
            MyNote = furthest;
            MyNote.Text = "claimed";
            GotoService.SubstateGotoOIR(arrived, MyNote.Location,, 'Aim',, DesiredSpeed);
        }
        //return;        
    }

    function arrived()
    {
        MyNote.Text = "";
        // End:0x38
        if(GotoService.GetMoveFailed())
        {
            GotoState('MoveToPoint',, true);            
        }
        else
        {
            GotoState('wait');
        }
        //return;        
    }
    stop;    
}

state wait extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(1.0000000, TimerDone);
        //return;        
    }

    function TimerDone()
    {
        GotoState('MoveToPoint');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHAGotoService'Default__NoteRunnerBrainState.GotoFNCService0'
    begin object name=GotoFNCService0 class=Class'MOHAGotoService'
    end object
    GotoService=GotoFNCService0
    DesiredSpeed=1000.0000000
    EventServices=/* Array type was not detected. */
}