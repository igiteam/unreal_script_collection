class DamageImpactModifier extends Object
    native;

var() array<DmgModEntry> DmgTable;

// Export UDamageImpactModifier::execGetDamageModifierForClass(FFrame&, void* const)
native function float GetDamageModifierForClass(Class cls);
