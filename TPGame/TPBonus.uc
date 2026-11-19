class TPBonus extends Object
	native;

enum BonusID
{
	CoolBonus,
	SuperCoolBonus,
	MaxBonus
};

struct native BonusInfo
{
	var		String	BonusName;
};

var	array<BonusInfo>	BonusStatus;

native function	int	ProcessBonus( String args );
native function int GetUserID();


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)



