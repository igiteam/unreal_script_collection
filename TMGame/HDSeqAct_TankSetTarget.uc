class HDSeqAct_TankSetTarget extends SequenceAction
	native(HDSequence);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var transient	Actor	AimTarget;
var transient   array<HDPlatform_BaseTankWheels> TankCannon;

/** fire if aimed the target */
var()			bool	bFireImmediately;
var()           float   MinFireInterval;
var()           float   MaxFireInterval;


