class SeqAct_BroadcastCCStimulus extends SequenceAction
    native
    hidecategories(Object);

var() CCStimulus Stimulus;
var() CCChannelAudio.ENationality OnlyNationality;
var() array<Volume> Volumes;
var() float Radius;
var() bool bAllActorsInMap;

defaultproperties
{
    Radius=100.0000000
    InputLinks[0]=(LinkDesc="Broadcast",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Broadcast Volume",LinkVar="None",PropertyName="Volumes",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Broadcast Radius",LinkVar="None",PropertyName="Radius",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Bool',LinkedVariables=none,LinkDesc="All Actors In Map",LinkVar="None",PropertyName="bAllActorsInMap",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Broadcast CC/AID Stimulus"
    ObjCategory="MOHA CC/AID"
}