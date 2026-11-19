class SeqAct_CameraLookAt extends SequenceAction
    hidecategories(Object);

var() bool bAffectCamera;
var() bool bAlwaysFocus;
var() bool bAdjustCamera;
var() bool bIgnoreTrace;
var() bool bAffectHead;
var() Vector2D InterpSpeedRange;
var() Vector2D InFocusFOV;
var() name FocusBoneName;

defaultproperties
{
    bAffectCamera=true
    InterpSpeedRange=(X=0.0000000,Y=0.0000000)
    InFocusFOV=(X=0.0000000,Y=0.0000000)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Focus",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Look At"
    ObjCategory="Camera"
}