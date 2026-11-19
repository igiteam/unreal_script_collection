//
// Allows level desigers to unlock bonuses
//
class SeqAct_UnlockBonus extends SequenceAction
	dependson(TPProfileSettings)
	native;

var() eZeroBasedBonus	BonusID;
var() bool bUnlockAllBonuses;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

