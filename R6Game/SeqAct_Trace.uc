class SeqAct_Trace extends SequenceAction
    native
    hidecategories(Object);

var() bool bTraceActors;
var() bool bTraceWorld;
var() Vector TraceExtent;
var() Vector StartOffset;
var() Vector EndOffset;
var() editconst Object HitObject;
var() editconst float Distance;

defaultproperties
{
    bTraceWorld=true
    OutputLinks[0]=(Links=none,LinkDesc="Not Obstructed",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Obstructed",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Start",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="End",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="HitObject",LinkVar="None",PropertyName="HitObject",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[3]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Distance",LinkVar="None",PropertyName="Distance",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Trace"
    ObjCategory="Level"
}