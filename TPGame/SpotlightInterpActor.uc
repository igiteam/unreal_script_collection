class SpotlightInterpActor extends InterpActor
	native;

var float CurrentScale;
var float DesiredScale;
var MaterialInstanceConstant SpotlightMaterial;

simulated event PostBeginPlay()
{
	//SpotlightMaterial = StaticMeshComponent.CreateMaterialInstance(0); //SPARK MAY CODEDROP
	SpotlightMaterial = StaticMeshComponent.CreateAndSetMaterialInstanceConstant(0);
}

native function ScaleSpotlight(float NewScale);
// {
// 	DesiredScale = NewScale;
// }

function Tick(float DeltaTime)
{
	/*local float ScaleToUse;

	if (abs(CurrentScale - DesiredScale) > 0.02f)
	{
		if (CurrentScale < DesiredScale)
			CurrentScale = CurrentScale + 1.5f * DeltaTime;
		else
			CurrentScale = CurrentScale - 1.5f * DeltaTime;

		if (CurrentScale < 0.3f)
			ScaleToUse = 0.3f;
		else
			ScaleToUse = CurrentScale;

		SpotlightMaterial.SetScalarParameterValue('BeamScale', ScaleToUse);
	}*/

	Super.Tick(DeltaTime);
}

