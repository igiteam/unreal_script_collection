//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSeqAct_WaitMatch extends SequenceAction;

event Activated()
{
	HDBaseGame(GetWorldInfo().Game).bKismetWaitToStartMatch = InputLinks[0].bHasImpulse;
}


