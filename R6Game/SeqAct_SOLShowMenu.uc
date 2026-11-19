class SeqAct_SOLShowMenu extends SeqAct_Latent
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Show",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Chose Jung",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Chose Micheal",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Declined",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="Repeat",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Show Decision Menu"
    ObjCategory="SOL"
}