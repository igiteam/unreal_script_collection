class SeqAct_R6ToggleIrena extends SequenceAction
    hidecategories(Object);

var() bool m_bToggleAttackable;
var() bool m_bToggleGodMode;

defaultproperties
{
    m_bToggleAttackable=true
    m_bToggleGodMode=true
    InputLinks[0]=(LinkDesc="Make Attackable",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Make Unattackable",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Toggle Irena Properties"
    ObjCategory="Toggle"
}