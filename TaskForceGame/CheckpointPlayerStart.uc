class CheckpointPlayerStart extends PlayerStart;

var() int CheckpointNumber;

event Trigger( Actor Other, Pawn EventInstigator )
{
	Level.DefaultMapInfo.SetCheckpoint(CheckpointNumber);
}
