class SeqAct_PersistentLog extends SeqAct_Latent
	native;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// Variable Declaration
//***********************************************************************

/** Should this message be drawn on the screen as well as placed in the log? */
var() bool bOutputToScreen;

/** Should ObjComment be included in the log? */
var() bool bIncludeObjComment;

var string logString;

//***********************************************************************
// CPP Text
//***********************************************************************


//***********************************************************************
// Default Properties
//***********************************************************************
