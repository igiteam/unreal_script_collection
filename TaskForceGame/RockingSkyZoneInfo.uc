//=============================================================================
// RockingSkyZoneInfo.
//=============================================================================
class RockingSkyZoneInfo extends SkyZoneInfo;

var(RockingSkyInfo) float MaxPitchAmount;
var(RockingSkyInfo) float MaxRollAmount;
var(RockingSkyInfo) float MaxYawAmount;
var(RockingSkyInfo) float PitchTotalTime;
var(RockingSkyInfo) float RollTotalTime;
var(RockingSkyInfo) float YawTotalTime;

var(RockingSkyInfo) enum ESkyRockType
{
	ROCKING_WAVE,
	ROCKING_LINEAR,
}MoveType;

var float RockingTotalTime;
var float ThisDeltaTime;

var float PitchSinFreq;
var float RollSinFreq;
var float YawSinFreq;

function PostBeginPlay()
{
	PitchSinFreq = 1 / PitchTotalTime * 2 * PI;
	RollSinFreq = 1 / RollTotalTime * 2 * PI;
	PitchSinFreq = 1 / YawTotalTime * 2 * PI;
}

simulated function Tick(float DeltaTime)
{
	local rotator NewRot;

	Super.Tick(DeltaTime);

	if( MoveType == ROCKING_LINEAR )
	{
		NewRot.Pitch = Rotation.Pitch;
	}
	else  // I am a sine wave
	{
		ThisDeltaTime = Level.TimeSeconds % RollTotalTime;
		NewRot.Roll = MaxRollAmount * Sin( ThisDeltaTime * RollSinFreq );

		ThisDeltaTime = Level.TimeSeconds % PitchTotalTime;
		NewRot.Pitch = MaxPitchAmount * Sin( ThisDeltaTime * PitchSinFreq );

		ThisDeltaTime = Level.TimeSeconds % YawTotalTime;
		NewRot.Yaw = MaxYawAmount * Sin( ThisDeltaTime * YawSinFreq );

	}
	

//	NewRot.Pitch = Rotation.Pitch + 1024 * DeltaTime;
//	NewRot.Roll  = Rotation.Roll;
//	NewRot.Yaw   = Rotation.Yaw;

	SetRotation(NewRot);
}




// Decompiled with UE Explorer.
defaultproperties
{
    bStatic=false
}