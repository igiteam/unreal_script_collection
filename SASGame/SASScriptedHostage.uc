class SASScriptedHostage extends SASHostage
	native;

event PreBeginPlay()
{
	// Skip SASHostage.PreBeginPlay
	Super(SASPawn).PreBeginPlay();

	mSide = SIDE_None;

	// Sanity check that mPawnType var is set correctly.
	if ( mPawnType != PAWN_Scripted )
	{
		Warn( "SASScriptedHostage with pawn type != PAWN_Scripted!!!" );
		mPawnType = PAWN_Scripted;
	}
}



// Decompiled with UE Explorer.
defaultproperties
{
    mSide=0
    mPawnType=8
    HearingThreshold=0.0000000
    SightRadius=0.0000000
    PeripheralVision=1.0000000
    ControllerClass=Class'SASScriptedController'
}