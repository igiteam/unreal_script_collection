class TestPlayerController extends ConsolePandoraPlayerController
    config(Game);

state Dead
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        ServerRestartPlayer();
        //return;        
    }
    stop;    
}
