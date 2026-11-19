class SeqAct_ToggleHUD extends SequenceAction
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Show",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Hide",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Player',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Toggle HUD"
    ObjCategory="Toggle"
}