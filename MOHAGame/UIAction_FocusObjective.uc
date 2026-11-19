class UIAction_FocusObjective extends UIAction
    hidecategories(Object);

event Activated()
{
    local UIScene_Objectives objectiveScene;

    objectiveScene = UIScene_Objectives(GetOwnerScene());
    // End:0x3A
    if(objectiveScene != none)
    {
        objectiveScene.SetFocusedObjective(UILabelButton(GetOwner()));
    }
    //return;    
}

defaultproperties
{
    ObjName="Focus Objective"
}