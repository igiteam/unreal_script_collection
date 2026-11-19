class TurokFELocalizationTest extends TurokUISceneController
    native;

var @NULL mFEAudio;

// Export UTurokFELocalizationTest::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

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

event SCTick(float DeltaTime)
{
    //return;    
}

event SCCleanUpOnExit()
{
    SceneClient = none;
    mFEAudio = none;
    //return;    
}

event bool SCInputKey(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    local bool EatInput;

    EatInput = true;
    // End:0xAF
    if(int(Event) == int(1))
    {
        switch(Key)
        {
            // End:0x2B
            case 'XboxTypeS_DPad_Up':
            // End:0x3A
            case 'Up':
                // End:0xAF
                break;
            // End:0x46
            case 'XboxTypeS_DPad_Down':
            // End:0x55
            case 'Down':
                // End:0xAF
                break;
            // End:0x61
            case 'XboxTypeS_A':
            // End:0x70
            case 'Enter':
                // End:0xAF
                break;
            // End:0x7C
            case 'XboxTypeS_Back':
            // End:0x88
            case 'Pause':
            // End:0xAC
            case 'Escape':
                SceneClient.GoBackSceneController(0);
                // End:0xAF
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

defaultproperties
{
    SceneName="_UITestPackage.LocalizationTest"
}