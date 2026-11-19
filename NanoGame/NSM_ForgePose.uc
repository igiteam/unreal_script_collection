//debug test class
class NSM_ForgePose extends NanoSpecialMove
	config(Pawn);

var() config array<Name> PoseList;
var() int PoseIdx;
var() int DesiredIdx;

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );
	ExtractSpecialMoveFlags( MyNP.SpecialMoveFlags );

	PoseIdx     = -1;
	DesiredIdx  = -1;
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.FullBodySlot.StopCustomAnim(0.f);
}

simulated function Tick(float DeltaTime)
{
	Super.Tick( DeltaTime );

	if( PoseIdx != DesiredIdx )
	{
		PoseIdx = DesiredIdx;
		if( PoseIdx < 0 || PoseIdx >= PoseList.Length )
		{
			PoseIdx     = -1;
			DesiredIdx  = -1;
			MyNP.EndSpecialMove();

			NanoPC(MyNP.Controller).ClientMessage( "Pose: None" );
		}
		else
		{
			NanoPC(MyNP.Controller).ClientMessage( "Pose:"@PoseList[PoseIdx] );
			MyNP.FullBodySlot.PlayCustomAnim( PoseList[PoseIdx], GetSpeedModifier(), 0.f, -1.f, TRUE, TRUE );
		}
	}
}

defaultproperties
{
	PoseIdx=-1
	DesiredIdx=-1
}
