class SkySeqAct_GiveInventoryByArch extends SequenceAction;

var() array<Inventory> InvArchetypeList;
var() string InvArchetypeString;
var() int InvSlot;
var() bool bClearExisting;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}
