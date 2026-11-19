class FHSeqVar_InventoryItem extends SeqVar_Object;

/** Descriptive name for item (e.g. Iron Bastard Sword) */
var() string itemName;

/** Category name for item (e.g., 1-Hand Blade Weapons) */
var() string itemCategory;

/** Number of items */
var() int    itemQuantity;


// Decompiled with UE Explorer.
defaultproperties
{
    ItemName="Inventory_Item_Name"
    itemCategory="Inventory_Category_Name"
    itemQuantity=1
    ObjName="Item to Add to Player Inventory"
    ObjCategory="Forever Hunted"
}