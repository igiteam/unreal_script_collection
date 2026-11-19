class TurokSeqAct_PlayTransitionGraph extends SequenceAction
    hidecategories(Object);

var() @NULL mGraphSet;
var() name mGraphName;
var() byte mGraphBestFitParams;
var() @NULL mGraphBestFitInput;

defaultproperties
{
    mGraphBestFitInput=(mStartSpeed=0.0000000,mEndSpeed=0.0000000,mStartRelAngle=0.0000000,mEndRelAngle=0.0000000,mStartPhase=0.0000000,mEndPhase=0.0000000,mYaw=0.0000000,mOriginalYaw=0,mContactPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),mSpatialPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),mDistance=0.0000000,mOffsetAngle=0.0000000,mbOffsetAngleRight=true,mStartSpeedTolerance=0.0000000,mEndSpeedTolerance=0.0000000,mRelAngleTolerance=0.0000000,mPhaseTolerance=0.0000000,mDistanceTolerance=0.0000000,mYawTolerance=0.0000000,mStartSpeedMin=0.0000000)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Secondary",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="Play Transition Graph"
    ObjCategory="Turok Gameplay"
}