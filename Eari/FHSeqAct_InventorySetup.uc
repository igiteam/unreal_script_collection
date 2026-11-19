// extend UIAction if this action should be UI Kismet Action instead of a Level Kismet Action
class FHSeqAct_InventorySetup extends SequenceAction;

/** Add a Category to the Inventory */
var() string categoryName;

/** Number of Collectibles under this Category, 0 indicates a normal inventory category, ie, non-collectible */
var() int    categoryQuantity;

/** Color used for display of items in this category */
var() Color  categoryColor;

/** Font used for display of items in this category */
var() Font   categoryFont;

event Activated()
	{
	}


// Decompiled with UE Explorer.
defaultproperties
{
    CategoryName="CategoryName"
    categoryColor=(R=255,G=255,B=255,A=255)
    HandlerName="AddInventoryCategory"
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Category Name",LinkVar="None",PropertyName="CategoryName",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Category Quantity",LinkVar="None",PropertyName="categoryQuantity",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Inventory Setup"
    ObjCategory="Forever Hunted"
}