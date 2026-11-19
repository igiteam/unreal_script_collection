class UIAction_PCConfigConfirmRebind extends UIAction
    hidecategories(Object);

event Activated()
{
    local UIScene_PCConfig Scene;

    Scene = UIScene_PCConfig(GetOwnerScene());
    // End:0x2F
    if(Scene != none)
    {
        Scene.ConfirmKeyRebind();
    }
    //return;    
}

defaultproperties
{
    ObjName="Confirm Key Rebind"
}