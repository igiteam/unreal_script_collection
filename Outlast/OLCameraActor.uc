class OLCameraActor extends CameraActor
	placeable
	native;

cpptext
{
	virtual FVector GetViewLocation();
	virtual FRotator GetViewRotation();

	virtual void GetViewPointForMatineePreview(APawn* previewPawn, FVector& out_Loc, FRotator& out_Rot);
}

/**
 * Returns camera's Point of View.
 * Called by Camera.uc class. Subclass and postprocess to add any effects.
 */
native function NativeGetCameraView(out TPOV OutPOV);
simulated function GetCameraView(float DeltaTime, out TPOV OutPOV)
{
	NativeGetCameraView(OutPOV);
}

defaultproperties
{
	bMatchPawnCamera=true
	PawnPreviewClass=class'OLHero'
	bConstrainAspectRatio=false
}


