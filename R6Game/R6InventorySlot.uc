class R6InventorySlot extends Object
    native;

var class<Inventory> m_acceptedClass;
var Inventory m_item;
var bool m_bCanBeChanged;

// Export UR6InventorySlot::execCanContain(FFrame&, void* const)
native function bool CanContain(class<Inventory> pInventoryClass);
