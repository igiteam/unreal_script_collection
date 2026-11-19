class TurokFEControllerPulled extends TurokUIDialog
    native;

var int mControllerId;

// Export UTurokFEControllerPulled::execInitialize(FFrame&, void* const)
native function Initialize(@NULL pScene, @NULL pSceneClient);

// Export UTurokFEControllerPulled::execSetControllerId(FFrame&, void* const)
native function SetControllerId(int ControllerId);

// Export UTurokFEControllerPulled::execTick(FFrame&, void* const)
native function Tick(float elapsed);

// Export UTurokFEControllerPulled::execSetupButtons(FFrame&, void* const)
native function SetupButtons(const float kStretchQuadY, const float kStretchQuadHeight);

defaultproperties
{
    dialogRef=UIScene'TurokFEControllerPulled.ControllerPulled'
    SceneName="TurokFEControllerPulled.ControllerPulled"
}