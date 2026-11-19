class TurokSeqAct_AIScriptedMove extends SeqAct_Latent
    hidecategories(Object);

var() bool mbLooping;
var() bool mShouldAvoidPawns;
var() bool mShouldPushPlayer;
var(Ignore) bool mIgnoreSight;
var(Ignore) bool mIgnoreHearing;
var(Ignore) bool mIgnoreDamage;
var() bool mTargetableByAI;
var bool mbPursuitParallelPath;
var bool mbPursuitLeadPursuit;
var() float mGoalRadius;
var() byte mScriptedSteerType;
var float mPursuitStartDelayTime;
var float mPursuitDistanceMinimum;
var float mPursuitDistanceMaximum;
var float mPursuitSpeedGainMultiplier;
var float mPursuitSpeedLossMultiplier;
var float mPursuitSpeedMaximum;
var float mPursuitSpeedDeceleration;
var float mPursuitAttackDistance;
var float mPursuitAttackDelayTime;
var float mPursuitAttackProbability;

defaultproperties
{
    mShouldAvoidPawns=true
    mIgnoreSight=true
    mIgnoreHearing=true
    mIgnoreDamage=true
    mGoalRadius=100.0000000
    mPursuitDistanceMinimum=600.0000000
    mPursuitDistanceMaximum=1000.0000000
    mPursuitSpeedGainMultiplier=1.5000000
    mPursuitSpeedLossMultiplier=0.9000000
    mPursuitSpeedMaximum=2.0000000
    mPursuitSpeedDeceleration=1.0000000
    mPursuitAttackDistance=1000.0000000
    mPursuitAttackProbability=1.0000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Goal",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Look At",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjClassVersion=3
    ObjName="AI Scripted Move"
    ObjCategory="Turok AI"
}