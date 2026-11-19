class SeqAct_R6InteractWithDoor extends SeqAct_Latent
    native
    hidecategories(Object);

var bool m_bIsOpening;
var bool m_bIsClosing;
var bool m_bIsBreaching;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Open",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Close",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Opened",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Closed",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Door",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    ObjName="Interact with Door"
    ObjCategory="Door"
}