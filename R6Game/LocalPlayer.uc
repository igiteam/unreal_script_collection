class LocalPlayer extends Player within Engine
    transient
    native
    config(Engine);

var int ControllerId;
var GameViewportClient ViewportClient;
var Vector2D Origin;
var Vector2D Size;
var const int ViewMode;
var const QWord ShowFlags;
var const QWord m_eR6ShowFlags;
var const bool UseAutomaticBrightness;
var private native const Pointer ViewState;
var const int LODLevel;
var native const array<name> m_PressedKeys;
var native const array<float> m_fPressedKeysTime;
var int m_iJoystickControllerId;
var transient PlayerController m_pRedirectInput;
var transient float m_fDistortionStrength;
var transient float m_fDistortionScale;

// Export ULocalPlayer::execSpawnPlayActor(FFrame&, void* const)
native final function bool SpawnPlayActor(string URL, out string OutError);

// Export ULocalPlayer::execInputKey(FFrame&, void* const)
native final function bool InputKey(int iControllerId, name Key, Object.EInputEvent Event, optional float fAmountDepressed);

defaultproperties
{
    ViewMode=8
    ShowFlags=none
}