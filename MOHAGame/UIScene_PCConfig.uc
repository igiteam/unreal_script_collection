class UIScene_PCConfig extends UIScene_MOHABase
    native
    hidecategories(Object,UIRoot,Object);

var bool ChangedShouldEnqueueModifierStateUpdates;
var UIPanel m_ConfirmBindReplacePanel;
var UILabel m_BackspaceToClearLabel;
var UILabel m_WaitingInputLabel;
var name m_ConfirmBindReplacePanelName;
var name m_BackspaceToClearLabelName;
var name m_WaitingInputLabelName;

// Export UUIScene_PCConfig::execResetKeyboardBindings(FFrame&, void* const)
native function ResetKeyboardBindings();

// Export UUIScene_PCConfig::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

// Export UUIScene_PCConfig::execShowConfirmBindDialog(FFrame&, void* const)
native function bool ShowConfirmBindDialog();

// Export UUIScene_PCConfig::execConfirmKeyRebind(FFrame&, void* const)
native function ConfirmKeyRebind();

// Export UUIScene_PCConfig::execSwapInputModeLabels(FFrame&, void* const)
native function SwapInputModeLabels();

event SetupLabels()
{
    super.SetupLabels();
    m_ConfirmBindReplacePanel = UIPanel(FindChild(m_ConfirmBindReplacePanelName, true));
    m_BackspaceToClearLabel = UILabel(FindChild(m_BackspaceToClearLabelName, true));
    m_WaitingInputLabel = UILabel(FindChild(m_WaitingInputLabelName, true));
    //return;    
}

defaultproperties
{
    m_ConfirmBindReplacePanelName="PanelConfirmBindReplace"
    m_BackspaceToClearLabelName="MoveClearLabel"
    m_WaitingInputLabelName="MoveWaitingKey"
    bPauseGameWhileActive=false
    bSaveSceneValuesOnClose=false
    // Reference: UIComp_Event'Default__UIScene_PCConfig.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}