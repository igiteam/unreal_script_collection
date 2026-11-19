class OLAIContextualVOAsset extends Object
	native(AI);

enum EVOContext
{
	EVOC_Undefined,
	EVOC_LostTarget,
	EVOC_PatrolToInvestigate,
	EVOC_SwitchToChase,
	EVOC_SwitchToChaseMultiple,
	EVOC_ChaseToInvestigate,
	EVOC_Spawned,
};

struct native VOMapping
{
	var() EVOContext VOContext;
	var() array<AkEvent> Events;
};

var() array<VOMapping> Mappings;

defaultproperties
{
}