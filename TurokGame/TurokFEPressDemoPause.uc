class TurokFEPressDemoPause extends TurokUISceneController
    native;

var @NULL SceneRef;

// Export UTurokFEPressDemoPause::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event SCInitialized()
{
    //return;    
}

function ResumeGame()
{
    CloseMenu();
    //return;    
}

function Restart()
{
    SceneClient.Outer.Outer.ViewportConsole.ConsoleCommand("open l15_00");
    CloseMenu();
    //return;    
}

event SCTick(float DeltaTime)
{
    //return;    
}

event SCCleanUpOnExit()
{
    SceneClient = none;
    //return;    
}

event bool SCInputKey_PressDemoPauseMenu(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    // End:0x58
    if(int(Event) == int(0))
    {
        switch(Key)
        {
            // End:0x23
            case 'XboxTypeS_Start':
            // End:0x3C
            case 'XboxTypeS_A':
                ResumeGame();
                // End:0x58
                break;
            // End:0x55
            case 'XboxTypeS_X':
                Restart();
                // End:0x58
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return true;
        //return ReturnValue;        
    }
}

function CloseMenu()
{
    SceneClient.GoBackSceneController(0);
    //return;    
}

defaultproperties
{
    SceneName="TurokFEPressDemoPause.PauseMenu"
}