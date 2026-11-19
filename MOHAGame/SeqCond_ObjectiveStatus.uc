class SeqCond_ObjectiveStatus extends SequenceCondition
    hidecategories(Object);

var() int ObjectiveNumber;
var() EALAObjective.EObjectiveType Type;

function Activated()
{
    local EALAObjective Objective;
    local MOHAObjectiveManager LocalObjectiveManager;
    local MOHAGameInfo GI;

    GI = MOHAGameInfo(GetWorldInfo().Game);
    LocalObjectiveManager = GI.GlobalObjectiveManager;
    // End:0x76
    if((int(Type) == int(0)) && ObjectiveNumber < LocalObjectiveManager.PrimaryObjectives.Length)
    {
        Objective = LocalObjectiveManager.PrimaryObjectives[ObjectiveNumber];        
    }
    else
    {
        // End:0xBE
        if((int(Type) == int(1)) && ObjectiveNumber < LocalObjectiveManager.OptionalObjectives.Length)
        {
            Objective = LocalObjectiveManager.OptionalObjectives[ObjectiveNumber];            
        }
        else
        {
            return;
        }
    }
    // End:0xF0
    if(int(Objective.ObjectiveStatus) == int(2))
    {
        OutputLinks[0].bHasImpulse = true;        
    }
    else
    {
        // End:0x120
        if(int(Objective.ObjectiveStatus) == int(1))
        {
            OutputLinks[1].bHasImpulse = true;            
        }
        else
        {
            // End:0x14E
            if(int(Objective.ObjectiveStatus) == int(3))
            {
                OutputLinks[2].bHasImpulse = true;
            }
        }
    }
    SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = Objective.LogDisplayString;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Completed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Pending",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="Objective Status"
}