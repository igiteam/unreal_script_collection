class SkyVehicleSimBase extends SVehicleSimBase
    native
    config(Game);

var(Debug) config Color MajorDebugColor;
var(Debug) config Color MinorDebugColor;
var(Debug) config Color NoBGTextDebugColor;
var(Debug) config Color BGTextDebugColor;

// Export USkyVehicleSimBase::execDisplayDebug(FFrame&, void* const)
native function DisplayDebug(SkyVehicle Vehicle, HUD HUD, out float out_XPos, out float out_YL, out float out_YPos);
