//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSeqAct_EndGame extends SequenceAction;

event Activated()
{
    GetWorldInfo().Game.EndGame(PlayerController(Targets[0]).PlayerReplicationInfo, "MatchOver");
}

