class TurokSeqAct_ForceMaul extends SequenceAction
    native
    hidecategories(Object);

var @NULL mTurokPawnHumanDefender;
var @NULL mTurokPawnAttacker;
var() bool mbCheckDistanceApartIsOkay;
var() bool mbCheckMaulWillEndOkay;
var() bool mbCheckHumanIsNotInSafeZone;
var() name mOptionalSpecificMaulGraphName;
var() float mRetryTimer;
var transient float mExpiryTimer;

defaultproperties
{
    mbCheckMaulWillEndOkay=true
    mRetryTimer=4.0000000
    bCallHandler=false
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    OutputLinks[0]=(Links=none,LinkDesc="Success",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Human",LinkVar="None",PropertyName="mTurokPawnHumanDefender",bWriteable=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Attacker",LinkVar="None",PropertyName="mTurokPawnAttacker",bWriteable=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjClassVersion=3
    ObjName="Force Maul"
    ObjCategory="Turok AI"
}