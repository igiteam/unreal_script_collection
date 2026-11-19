class SeqAct_R6ChopperInstantSetRainbows extends SequenceAction
    native
    hidecategories(Object);

var R6RainbowPawn Logan;
var R6RainbowPawn DemoGuy;
var R6RainbowPawn Hacker;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_R6Logan',LinkedVariables=none,LinkDesc="Logan",LinkVar="None",PropertyName="Logan",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_R6Pawn',LinkedVariables=none,LinkDesc="DemoGuy",LinkVar="None",PropertyName="DemoGuy",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[3]=(ExpectedType=Class'SeqVar_R6Pawn',LinkedVariables=none,LinkDesc="Hacker",LinkVar="None",PropertyName="Hacker",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Instant Set Rainbows"
    ObjCategory="Helicopter"
}