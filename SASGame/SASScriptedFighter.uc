class SASScriptedFighter extends SASFighter
	native;

event PreBeginPlay()
{
	Super.PreBeginPlay();

	mSide = SIDE_None;

	// Sanity check that mPawnType var is set correctly.
	if ( mPawnType != PAWN_Scripted )
	{
		Warn( "SASScriptedFighter with pawn type != PAWN_Scripted!!!" );
		mPawnType = PAWN_Scripted;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    mInventoryWeapons="SASWeapons.HK_MP5_Wpn"
    mPawnType=8
    HearingThreshold=0.0000000
    SightRadius=0.0000000
    PeripheralVision=1.0000000
    ControllerClass=Class'SASScriptedController'
    Mesh=SkeletalMesh'CSas.CS01'
}