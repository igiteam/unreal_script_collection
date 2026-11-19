class OLBTDistanceToPlayerTask extends OLBTIfTask;

event bool Condition()
{
	local bool bResult;
	local OLBTDistanceToPlayerNode DTPNode;
	local float DistanceSquared;

	DTPNode = OLBTDistanceToPlayerNode(Node);

	bResult = false;
	if (DTPNode != None && Owner.TargetPlayer != None)
	{
		DistanceSquared = VSizeSq(Owner.EnemyPawn.Location - Owner.TargetPlayer.Location);

		switch (DTPNode.Comparison)
		{
		case BTC_LessThan:
			bResult = DistanceSquared < DTPNode.Distance * DTPNode.Distance;
			break;
		case BTC_LessThanOrEqual:
			bResult = DistanceSquared <= DTPNode.Distance * DTPNode.Distance;
			break;
		case BTC_GreaterThan:
			bResult = DistanceSquared > DTPNode.Distance * DTPNode.Distance;
			break;
		case BTC_GreaterThanOrEqual:
			bResult = DistanceSquared >= DTPNode.Distance * DTPNode.Distance;
			break;
		}
	}

	return bResult;
}

defaultproperties
{
}