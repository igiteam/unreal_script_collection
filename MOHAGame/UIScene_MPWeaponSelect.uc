class UIScene_MPWeaponSelect extends UIScene_MPBase
    native
    hidecategories(Object,UIRoot,Object);

var bool m_bCloseScene;

// Export UUIScene_MPWeaponSelect::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

// Export UUIScene_MPWeaponSelect::execHandleInputKey(FFrame&, void* const)
native function bool HandleInputKey(int ControllerId, name Key, Object.EInputEvent Event, float AmountDepressed);

event SetupLabels()
{
    super.SetupLabels();
    __OnInputKey__Delegate = HandleInputKey;
    //return;    
}

defaultproperties
{
    m_RemainingTimeWidgetName="Time"
    m_RemainingTimeTextWidgetName="TimeLeft"
    // Reference: UIComp_Event'Default__UIScene_MPWeaponSelect.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}