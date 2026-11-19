class SeqEvent_R6ObjectiveSequenceActivated extends SeqEvent_R6ObjectiveEvent
    native
    hidecategories(Object);

var() string InputLabel;

defaultproperties
{
    InputLabel="In"
    bPlayerOnly=false
    VariableLinks[0]=(ExpectedType=Class'SeqVar_R6Objective',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Objective Block Activated"
    ObjCategory="Objective"
}