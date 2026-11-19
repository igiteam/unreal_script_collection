class SeqAct_ToggleDoor extends SequenceAction;

enum eOpenDirection
{
	OPEN_IN,
	OPEN_OUT,
};

var () eOpenDirection OpenDirection;
var () bool bOverrideLock;
