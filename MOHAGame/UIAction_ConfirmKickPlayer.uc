class UIAction_ConfirmKickPlayer extends UIAction
    hidecategories(Object);

event Activated()
{
    local UIScene_MPScoreboard localScene;

    localScene = UIScene_MPScoreboard(GetOwnerScene());
    // End:0x2F
    if(localScene != none)
    {
        localScene.ConfirmKickPlayer();
    }
    //return;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Confirm Kick Player"
}