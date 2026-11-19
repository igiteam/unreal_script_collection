class JamiePlayerController extends UTPlayerController;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	//////SetCameraMode('ThirdPerson');
	SetBehindView(true);
}


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__JamiePlayerController.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__JamiePlayerController.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    PostProcessModifier=(ColorGradingLUT=none)
    // Reference: CylinderComponent'Default__JamiePlayerController.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UTGame.Default__UTPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}