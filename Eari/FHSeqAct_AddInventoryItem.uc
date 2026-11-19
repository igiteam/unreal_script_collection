// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class FHSeqAct_AddInventoryItem extends SequenceAction;

/** Descriptive name for item (e.g. Iron Bastard Sword) */
var() string itemName;

/** Category name for item (e.g., 1-Hand Blade Weapons) */
var() string itemCategory;

/** Number of Items */
var() int    itemQuantity;

event Activated()
	{
	}


// Decompiled with UE Explorer.
defaultproperties
{
    ItemName="Inventory_Item_Name"
    itemCategory="Inventory_Category_Name"
    itemQuantity=1
    HandlerName="AddInventoryItem"
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Name",LinkVar="None",PropertyName="ItemName",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Category",LinkVar="None",PropertyName="itemCategory",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Add Item to Player Inventory"
    ObjCategory="Forever Hunted"
}