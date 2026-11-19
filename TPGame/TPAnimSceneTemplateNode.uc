class TPAnimSceneTemplateNode extends TPAnimNodeBlendList
	native
	hidecategories(Object);


//***********************************************************************
// Structures
//***********************************************************************
struct native SceneAnimStruct
{
	var Name sceneAnimName;
	var int  playCount;
};
 

//***********************************************************************
// Variable Declaration
//***********************************************************************
var bool m_bPlayNewScene;				// used to track if we are supposed to start a new scene
var SceneAnimStruct m_newScene;			// information about the new scene to play
var SceneAnimStruct m_currentScene;		// information about the current scene playing
var SeqAct_PlaySceneAnimation m_seqAct;	// the sequenceaction that requested that we play




//***********************************************************************
// CPP Text
//***********************************************************************
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


//***********************************************************************
// Function Declarations
//***********************************************************************
native noexport function PlayNewScene(Name animName, int playCount, SeqAct_PlaySceneAnimation pSeqAct, float desiredBlendTime);
native function AnimNodeSequence GetActiveChild();
native noexport function Stop();


//***********************************************************************
// Events
//***********************************************************************

//-----------------------------------------------------------------------
// Event:  OnInit
//-----------------------------------------------------------------------
event OnInit()
{
	// ensure that they didn't change the name of this node (it's special)
	NodeName='SceneTemplateNode';
	super.OnInit();
}



//***********************************************************************
// Default Properties
//***********************************************************************
