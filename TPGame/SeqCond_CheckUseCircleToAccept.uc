class SeqCond_CheckUseCircleToAccept extends SequenceCondition;

event Activated()
{	
	if (GetWorldInfo().UseCircleToAccept())
		OutputLinks[0].bHasImpulse = true;
	else
		OutputLinks[1].bHasImpulse = true;

	super.Activated();
}

