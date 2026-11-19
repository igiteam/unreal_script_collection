class TurokFEPauseOptionsController extends TurokFEPauseOptionsOverlay
    native;

const NUM_CONTROLLER_TEXTURES = 4;

enum eControllerConfigurations
{
    CONTROLLER_CONFIG_1,            // 0
    CONTROLLER_CONFIG_2,            // 1
    CONTROLLER_CONFIG_3,            // 2
    CONTROLLER_CONFIG_MAX           // 3
};

enum eControllerConfigTypes
{
    CONTROLLER_CONFIG_TYPE_RUNNING_AND_KILLING,// 0
    CONTROLLER_CONFIG_TYPE_DRIVING_WHILE_KILLING,// 1
    CONTROLLER_CONFIG_TYPE_MAX      // 2
};

var @NULL Driving[4];
var @NULL Shooting[4];
var @NULL m_Controller00;
var @NULL m_Controller01;
var @NULL m_Controller10;
var bool bBlockInput;
var int SelectedConfig;
var int SelectedSubConfig[2];
var @NULL mFEAudio;

// Export UTurokFEPauseOptionsController::execSetShootingArtNative(FFrame&, void* const)
native function SetShootingArtNative();

function SetShootingArt()
{
    SetShootingArtNative();
    //return;    
}

// Export UTurokFEPauseOptionsController::execSetDrivingArtNative(FFrame&, void* const)
native function SetDrivingArtNative();

function SetDrivingArt()
{
    SetDrivingArtNative();
    //return;    
}

// Export UTurokFEPauseOptionsController::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEPauseOptionsController::execGoBackScene(FFrame&, void* const)
native function GoBackScene();

event SCInitialized()
{
    local class<Class> FEAudioClass;

    FEAudioClass = class<TurokFEAudio>(DynamicLoadObject("TurokEngine.TurokFEAudio", Class'Core.Class'));
    // End:0x4C
    if(FEAudioClass != none)
    {
        mFEAudio = new (self) FEAudioClass;
    }
    //return;    
}

function SetShootingConfig()
{
    SetShootingConfigNative();
    //return;    
}

// Export UTurokFEPauseOptionsController::execSetShootingConfigNative(FFrame&, void* const)
native function SetShootingConfigNative();

function SetDrivingConfig()
{
    SetDrivingConfigNative();
    //return;    
}

// Export UTurokFEPauseOptionsController::execSetDrivingConfigNative(FFrame&, void* const)
native function SetDrivingConfigNative();

event SCCleanUpOnExit()
{
    mFEAudio = none;
    SceneClient = none;
    //return;    
}

event bool SCInputKey_OptionsController(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = true;
    // End:0x74
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x2B
            case 'XboxTypeS_B':
            // End:0x37
            case 'MouseXButton1':
            // End:0x43
            case 'Escape':
            // End:0x71
            case 'BackSpace':
                mFEAudio.PlayFESound(5);
                CloseMenu();
                // End:0x74
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return EatInput;
        //return ReturnValue;        
    }
}

function IntroComplete()
{
    bBlockInput = false;
    //return;    
}

defaultproperties
{
    SceneName="TurokFEPauseMenuFlow.ControllerMenu.PauseController"
}