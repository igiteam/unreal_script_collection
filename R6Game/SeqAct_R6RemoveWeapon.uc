class SeqAct_R6RemoveWeapon extends SeqAct_Latent
    native
    hidecategories(Object);

var() bool InstantSwitch;
var bool m_bIsRemoving;
var bool m_bIsEquipping;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Remove",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Equip",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Removed",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Equipped",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0)
    ObjClassVersion=2
    ObjName="Remove Weapon"
    ObjCategory="Pawn"
}