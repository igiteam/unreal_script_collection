class SeqAct_R6StreamTemplate extends SeqAct_Latent
    native
    hidecategories(Object);

var() array< class<Inventory> > m_arrInventoryDataToStream;
var() array<R6EquipmentTemplate> m_arrTemplatesToStream;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Stream",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Streaming Finished",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Stream Templates"
    ObjCategory="Streaming"
}