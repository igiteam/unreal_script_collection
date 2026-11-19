class TurokSeqAct_AIScriptedIdle extends SequenceAction
    hidecategories(Object);

var() bool mbUseTimeDuration;
var(Ignore) bool mIgnoreSight;
var(Ignore) bool mIgnoreHearing;
var(Ignore) bool mIgnoreDamage;
var() bool mTargetableByAI;
var() float mTimeDuration;

defaultproperties
{
    mIgnoreSight=true
    mIgnoreHearing=true
    mIgnoreDamage=true
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Look At",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="AI Scripted Idle"
    ObjCategory="Turok AI"
}