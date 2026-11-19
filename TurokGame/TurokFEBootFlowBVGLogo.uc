class TurokFEBootFlowBVGLogo extends TurokUISceneController
    native;

var float Timer;
var @NULL Movie;
var @NULL mMovieTexture;

// Export UTurokFEBootFlowBVGLogo::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event SCCleanUpOnExit()
{
    SceneClient = none;
    //return;    
}

defaultproperties
{
    SceneName="TurokFEBootFlow.BVGVideo"
}