class SeqAct_GiveInventory extends SequenceAction
    native
    hidecategories(Object);

var() array< class<Inventory> > InventoryList;
var() bool m_bReplaceEntireInventory;
var() bool m_bKeepCurrentPistol;
var() class<R6Weapon> m_Primary;
var() class<R6Weapon> m_Secondary;
var() class<R6Pistol> m_Pistol;
var() class<R6Gadget> m_Gadget1;
var() int m_Gadget1Ammo;
var() class<R6Gadget> m_Gadget2;
var() int m_Gadget2Ammo;

defaultproperties
{
    m_Gadget1Ammo=5
    m_Gadget2Ammo=5
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Give Inventory"
    ObjCategory="Pawn"
}