class OLBTIsInBehaviorStateTask extends OLBTIfTask;

event bool Condition()
{
	local OLBTIsInBehaviorStateNode InBSNode;

	InBSNode = OLBTIsInBehaviorStateNode(Node);

	return Owner.BehaviorState == InBSNode.BehaviorState;
}

defaultproperties
{
}