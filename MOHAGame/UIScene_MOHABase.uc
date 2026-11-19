class UIScene_MOHABase extends UIScene
    abstract
    native
    hidecategories(Object,UIRoot,Object);

event SetupLabels()
{
    //return;    
}

// Export UUIScene_MOHABase::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

defaultproperties
{
    // Reference: UIComp_Event'Default__UIScene_MOHABase.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}