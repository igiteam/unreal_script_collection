class OLBTWasLastMoveFailedReasonTask extends OLBTIfTask;

event bool Condition()
{
	local OLBTWasLastMoveFailedReasonNode LMFNode;

	LMFNode = OLBTWasLastMoveFailedReasonNode(Node);

	return Owner.LastMoveFailedReason == LMFNode.FailedReason;
}

defaultproperties
{
}