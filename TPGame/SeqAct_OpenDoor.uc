class SeqAct_OpenDoor extends SequenceAction;

enum eOpenDirection
{
	OPEN_BOTH,
	OPEN_IN,
	OPEN_OUT,
};

var () eOpenDirection OpenDirection;
var Actor Instigator;
var () bool bForceLockIn;
var () bool bForceLockOut;

