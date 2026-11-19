class R6MagmaInteraction extends Interaction
    abstract
    transient
    native;

struct R6PressedButtonInfo
{
    var float fPressedTime;
    var bool bIsPressed;

    structdefaultproperties
    {
        fPressedTime=0.0000000
        bIsPressed=false
    }
};

struct StickInfoMultiArray
{
    var R6PressedButtonInfo Button[6];

    structdefaultproperties
    {
        Button[0]=(fPressedTime=0.0000000,bIsPressed=false)
        Button[1]=(fPressedTime=0.0000000,bIsPressed=false)
        Button[2]=(fPressedTime=0.0000000,bIsPressed=false)
        Button[3]=(fPressedTime=0.0000000,bIsPressed=false)
        Button[4]=(fPressedTime=0.0000000,bIsPressed=false)
        Button[5]=(fPressedTime=0.0000000,bIsPressed=false)
    }
};

var PlayerController Player;
var int m_iControllerId;
var int m_iJoystickControllerId;
var array<string> m_MenuPackages;
var bool m_bVisible;
var bool m_bActive;
var bool m_bBlockInputs;
var bool m_bLoaded;
var bool m_bIgnoreFirstTick;
var bool m_bInvertControllers;
var bool m_bShouldDuplicate;
var float m_fTimeSinceLastInput;
var float m_fDemoTimeSinceLastInput;
var SoundCue m_sndAcceptButton;
var SoundCue m_sndBackButton;
var SoundCue m_sndChangeSelection;
var SoundCue m_sndMenuMusic;
var int m_iLastControllerIdUsed;
var StickInfoMultiArray m_AnalogStickInfo[4];
var Pointer m_pMenusMgr;
var float m_fMouseDeltaX;
var float m_fMouseDeltaY;

// Export UR6MagmaInteraction::execReset(FFrame&, void* const)
native function Reset();

// Export UR6MagmaInteraction::execSetController(FFrame&, void* const)
native function SetController(PlayerController PlayerOwner);

// Export UR6MagmaInteraction::execRemoveFromController(FFrame&, void* const)
native function RemoveFromController();

// Export UR6MagmaInteraction::execIsPauseMenuShown(FFrame&, void* const)
native function bool IsPauseMenuShown();

// Export UR6MagmaInteraction::execShowCreditsMenu(FFrame&, void* const)
native final function ShowCreditsMenu();

// Export UR6MagmaInteraction::execDisplayChatMessage(FFrame&, void* const)
native function DisplayChatMessage(string Msg, bool bTeam);

event GetEnumOrderInString(R6EngineEnums.EOrderId eOrder, out string strName)
{
    strName = "" $ string(eOrder);
    return;
}

defaultproperties
{
    m_MenuPackages[0]=""
    m_bVisible=true
    m_sndAcceptButton=SoundCue'Dare.SFX_Menus.Play_Button_Selection'
    m_sndBackButton=SoundCue'Dare.SFX_Menus.Play_Planning_GoodClick'
    m_sndChangeSelection=SoundCue'Dare.SFX_Menus.Play_Rose_Open'
    m_iLastControllerIdUsed=-1
    m_bEnableUseGamePadOption=true
    m_iDesiredIndex=3
}