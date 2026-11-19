class SeqCond_R6PlayerHasInventory extends SequenceCondition
    native
    hidecategories(Object);

var() array< class<Inventory> > m_InventoryToCheck;

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Has",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Has not",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Pawn",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Has Inventory"
}