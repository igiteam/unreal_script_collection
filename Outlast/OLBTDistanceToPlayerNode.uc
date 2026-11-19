class OLBTDistanceToPlayerNode extends OLBTIfNode;

var() float Distance;

enum EBTComparison
{
	BTC_LessThan,
	BTC_LessThanOrEqual,
	BTC_GreaterThan,
	BTC_GreaterThanOrEqual,
};

var() EBTComparison Comparison;

defaultproperties
{
	TaskType=class'OLBTDistanceToPlayerTask'
}