class TurokSeqAct_AIScriptedAnim extends SeqAct_Latent
    hidecategories(Object);

var() name mAnimName;
var() name mExitAnimName;
var() bool mMoveToAnimActionRef;
var() bool mShouldAvoidPawns;
var() bool mShouldPushPlayer;
var() bool mbUseTimeDuration;
var(Ignore) bool mIgnoreSight;
var(Ignore) bool mIgnoreHearing;
var(Ignore) bool mIgnoreDamage;
var(Ignore) bool mIgnoreFlares;
var(Ignore) bool mAllowMauling;
var() bool mTargetableByAI;
var() bool mDisablePhysics;
var() byte mScriptedSteerType;
var() float mTimeDuration;
var() @NULL mGraphSet;

defaultproperties
{
    mShouldAvoidPawns=true
    mIgnoreSight=true
    mIgnoreHearing=true
    mIgnoreDamage=true
    mIgnoreFlares=true
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Anim Started",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="AnimActionRef",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjClassVersion=3
    ObjName="AI Scripted Anim"
    ObjCategory="Turok AI"
}