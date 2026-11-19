class FHSeqVar_InventoryCategory extends SeqVar_Object;

/** Descriptive name for the category (e.g. 1-Hand Blade Weapons) */
var() string categoryName;

/** Number of Collectibles under this Category, 0 indicates a normal inventory category, ie, non-collectible */
var() int    categoryQuantity;

/** Color used for display of items in this category */
var() Color  categoryColor;

/** Font used for display of items in this category */
var() Font   categoryFont;

/** Items in this Category */
var() array <FHSeqVar_InventoryItem> itemList;


// Decompiled with UE Explorer.
defaultproperties
{
    categoryQuantity=1
}