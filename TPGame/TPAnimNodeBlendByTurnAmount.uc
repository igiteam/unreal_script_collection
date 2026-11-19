class TPAnimNodeBlendByTurnAmount extends AnimNodeBlendList
	NotPlaceable
	native;



// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//`define	NUM_TURN_ANIMS	9

//var()	const	editconst	float	turnAngles[`NUM_TURN_ANIMS];


enum TurnAction
{
	NotTurning,
	TurningRight,
	TurningLeft,
};

var()	const	float		startTurnAngle;
var				TurnAction	currentTurnAction;

