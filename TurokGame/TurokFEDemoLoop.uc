class TurokFEDemoLoop extends TurokUISceneController
    native;

var bool exitOnNextTick;
var @NULL mMovieImage;
var @NULL mMovieTexture;

// Export UTurokFEDemoLoop::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

// Export UTurokFEDemoLoop::execEndDemoLoop(FFrame&, void* const)
native function EndDemoLoop();

event SCInitialized()
{
    exitOnNextTick = false;
    //return;    
}

event SCCleanUpOnExit()
{
    SceneClient = none;
    //return;    
}

defaultproperties
{
    SceneName="TurokFEBootFlow.DemoLoop"
}