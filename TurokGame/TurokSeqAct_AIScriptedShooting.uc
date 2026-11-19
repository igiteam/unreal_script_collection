class TurokSeqAct_AIScriptedShooting extends SeqAct_Latent
    native
    hidecategories(Object);

enum ScriptedFireMode
{
    SFM_UsePrimaryFireMode,         // 0
    SFM_UseSecondaryFireMode,       // 1
    SFM_MAX                         // 2
};

enum ScriptedCountingType
{
    SCT_CountIndividualShots,       // 0
    SCT_CountBursts,                // 1
    SCT_MAX                         // 2
};

var() byte mFiringMode;
var() byte mCountingMode;
var() bool mFireUntilTargetDead;
var() bool mForcePerfectAccuracy;
var(Ignore) bool mIgnoreSight;
var(Ignore) bool mIgnoreHearing;
var(Ignore) bool mIgnoreDamage;
var() bool mTargetableByAI;
var bool mActivatedThisFrame;
var() float mTimeBetweenShots;
var() int mNumShots;
var() float mBurstLength;

defaultproperties
{
    mIgnoreSight=true
    mIgnoreHearing=true
    mIgnoreDamage=true
    mTimeBetweenShots=1.5000000
    mNumShots=1
    mBurstLength=1.0000000
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Enemy",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="AI Scripted Shooting"
    ObjCategory="Turok AI"
}