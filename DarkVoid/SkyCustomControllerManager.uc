class SkyCustomControllerManager extends Object
    native;

enum ECustomControllerLayouts
{
    CCL_OnFoot,                     // 0
    CCL_InAir,                      // 1
    CCL_AAGun,                      // 2
    CCL_MAX                         // 3
};

struct native KeyBinding
{
    var() name KeyName;
    var() name ModifierName;

    structdefaultproperties
    {
        KeyName="None"
        ModifierName="None"
    }
};

struct native ControllerAction
{
    var() name ActionName;
    var() name RequiredModifierKey;
    var() bool bOnFoot;
    var() bool bInAir;
    var() bool bAAGun;
    var() bool bFreePlacement;
    var() bool bRequiresHolding;
    var() bool bCanBeOnController;
    var() bool bAcceptsModifiers;

    structdefaultproperties
    {
        ActionName="None"
        RequiredModifierKey="None"
        bOnFoot=true
        bInAir=false
        bAAGun=false
        bFreePlacement=false
        bRequiresHolding=true
        bCanBeOnController=true
        bAcceptsModifiers=false
    }
};

struct native CustomControllerBinding
{
    var() int ActionIndex;
    var() array<KeyBinding> CurrentKeyBindings;

    structdefaultproperties
    {
        ActionIndex=0
        CurrentKeyBindings=none
    }
};

struct native CustomControllerLayout
{
    var() name MinBindingsName;
    var transient SkyInputLayout MinBindings;
    var() array<CustomControllerBinding> Bindings;

    structdefaultproperties
    {
        MinBindingsName="None"
        MinBindings=none
        Bindings=none
    }
};

struct native ArrayOfInts
{
    var() array<int> A;

    structdefaultproperties
    {
        A=none
    }
};

var private native const noexport Pointer VfTable_IUIListElementProvider;
var private native const noexport Pointer VfTable_IUIListElementCellProvider;
var() editinline array<editinline ControllerAction> AllowedBindings;
var() editinline array<editinline CustomControllerLayout> CustomLayouts;
var transient array<name> KeyboardButtons;
var transient array<name> ControllerButtons;
var transient array<ArrayOfInts> BindingCounts;
var transient int PlayerIndex;

// Export USkyCustomControllerManager::execSaveLayout(FFrame&, void* const)
native function SaveLayout(SkyCustomControllerManager.ECustomControllerLayouts layout, optional bool bWriteToSettings);

// Export USkyCustomControllerManager::execPopulateLayout(FFrame&, void* const)
native function PopulateLayout(array<CustomControllerBinding> CustomBindings, SkyInputLayout BaseLayout, SkyInputLayout OutLayout);

event string GetBindingByIndex(SkyCustomControllerManager.ECustomControllerLayouts layout, int Idx)
{
    // End:0x0E
    if(Idx < 0)
    {
        return "";
    }
    // End:0x37
    if(AllowedBindings.Length > Idx)
    {
        return string(AllowedBindings[Idx].ActionName);
    }
    return "";
    //return ReturnValue;    
}

event name GetKeyBoundByIndex(SkyCustomControllerManager.ECustomControllerLayouts layout, int bindIdx, int keyIdx)
{
    // End:0x22
    if((bindIdx < 0) || keyIdx < 0)
    {
        return 'None';
    }
    // End:0xB6
    if((CustomLayouts[int(layout)].Bindings.Length > bindIdx) || CustomLayouts[int(layout)].Bindings[bindIdx].CurrentKeyBindings.Length > keyIdx)
    {
        return CustomLayouts[int(layout)].Bindings[bindIdx].CurrentKeyBindings[keyIdx].KeyName;
    }
    return 'None';
    //return ReturnValue;    
}

event ClearBindings(SkyCustomControllerManager.ECustomControllerLayouts layout, int Idx)
{
    // End:0x0D
    if(Idx < 0)
    {
        return;
    }
    // End:0x85
    if(CustomLayouts[int(layout)].Bindings.Length > Idx)
    {
        CustomLayouts[int(layout)].Bindings[Idx].CurrentKeyBindings.Remove(0, CustomLayouts[int(layout)].Bindings[Idx].CurrentKeyBindings.Length);
    }
    //return;    
}

event AddBinding(SkyCustomControllerManager.ECustomControllerLayouts layout, int Idx, KeyBinding bind)
{
    // End:0x0D
    if(Idx < 0)
    {
        return;
    }
    // End:0x61
    if(CustomLayouts[int(layout)].Bindings.Length > Idx)
    {
        CustomLayouts[int(layout)].Bindings[Idx].CurrentKeyBindings.AddItem(bind);
    }
    //return;    
}

event SetBinding(SkyCustomControllerManager.ECustomControllerLayouts layout, int ControlIdx, int bindIdx, KeyBinding bind)
{
    // End:0x1A
    if((ControlIdx < 0) || bindIdx < 0)
    {
        return;
    }
    // End:0xA8
    if((CustomLayouts[int(layout)].Bindings.Length > ControlIdx) && CustomLayouts[int(layout)].Bindings[ControlIdx].CurrentKeyBindings.Length > bindIdx)
    {
        CustomLayouts[int(layout)].Bindings[ControlIdx].CurrentKeyBindings[bindIdx] = bind;
    }
    //return;    
}
