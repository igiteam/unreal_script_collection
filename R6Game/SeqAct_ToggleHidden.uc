class SeqAct_ToggleHidden extends SeqAct_Toggle
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Hide",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="UnHide",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Toggle Hidden"
}