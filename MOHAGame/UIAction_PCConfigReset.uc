class UIAction_PCConfigReset extends UIAction
    hidecategories(Object);

event Activated()
{
    local UIScene_PCConfig Scene;

    Scene = UIScene_PCConfig(GetOwnerScene());
    // End:0x2F
    if(Scene != none)
    {
        Scene.ResetKeyboardBindings();
    }
    //return;    
}

defaultproperties
{
    ObjName="Reset Keyboard Bindings"
}