//***********************************************************************
// Class:		 SPPerformance
// Description:  Spark class that lets animators choose a series of
//				 animations to play depending upon parameters they
//				 specify.
// Created By:   John Lawrie, Spark Unlimited 2005
//***********************************************************************
class TPPerformance extends AnimNodeSequence
	native;

//
// This enum specified what action to do after the asset is finished.
//
enum ExitAction
{
	Through,
	Branch,
	Restart,
	End
};

//
// This structure groups information about rotation and translation for each animation.
//
struct native RotTransInfo
{
	var()	ERootBoneAxis		TranslateX;
	var()	ERootBoneAxis		TranslateY;
	var()	ERootBoneAxis		TranslateZ;
	var()	ERootRotationOption		RotationYaw;
	var()	ERootRotationOption		RotationPitch;
	var()	ERootRotationOption		RotationRoll;
};

//
// If we wish to override the default animation for a specific character class,
// fill out one of these structures.
//
struct native PerformanceAnimInfo
{
	var()	class<TPPawn>	class;				//	Character class.
	var()	name			animation;			//	Animation we play.
	var()	RotTransInfo	rotTransExtract;	//	Rotation and Translation flags.
};

//
// In the event that a branch option is chosen, this struct contains the list
// of all states we can branch to along with the percentage chance that we will
// choose each branch.
//
struct native PerformanceBranchInfo
{
	var()	string	label;		//	The label we could branch to.
	var()	int		percent;	//	The percentage chance we will take this branch.
};

//
// This struct contains information about which animation to play, how many
// times to play it, the percentage chance to play it, and what to do
// afterwards
//
struct native PerformaceState
{
	var()	string						label;
	var()	name						animation;
	var()	array<PerformanceAnimInfo>	animations;
	var()	RotTransInfo				rotTransExtract;
	var()	int							percent;
	var()	int							minLoopCount;
	var()	int							maxLoopCount;
	var()	ExitAction					exitAction;

	var()	array<PerformanceBranchInfo>	branchInfo;
	
	structdefaultproperties
	{
		rotTransExtract=(TranslateX=RBA_Translate, TranslateY=RBA_Translate, TranslateZ=RBA_Translate, RotationYaw=RRO_Extract, RotationPitch=RRO_Default, RotationRoll=RRO_Default)
	}
};

struct native PerformanceInfo
{
	//var()	class<TPPawn>			class;			//	Alternate character class.
	var	class<TPPawn>			class;			//	Alternate character class.
	var()	int						interPNodeID;	//	ID used to synchronize this PNode with another.
	var()   array<string>           Conditions;		//  List of conditions that must be met through LogicModifiers for this performance to execute
	var()	string					description;	//	Just a friendly name for this performance.
	var()	array<PerformaceState>	states;			//	Array of all states.

	structdefaultproperties
	{
		interPNodeID=-1;
	}
};

var()	array<PerformanceInfo>	performances;		//	The list of all performances
var()	string					nodeDisplayName;	//	The name displayed above node in anim tree.
var()	bool					changeToValidate;	//	Just change this to run the validation routine.

//
// Variables to help animators copy data.
//
var()	transient	int		copyPerformanceFrom;	//	The performance we want to copy from.
var()	transient	int		copyPerformanceTo;		//	The performance we want to copy to.
var()	transient	bool	copyPerformanceExecute;	//	Change this in the editor to copy the states.

//
// Variables to keep track of the progress used in the cpp file.
//
var	transient	bool	running;			//	Have we started playing any animations?
var	transient	bool	hitEnd;				//	Have we encountered the end of the sequence?
var	transient	int		currState;			//	Index into the assets array we are referencing.
var	transient	int		loopsToDo;			//	How many times we should play this animation.
var	transient	int		completedLoops;		//	How many animations have played for the current state.
var transient	int		interPNodeID;		//	ID used to sync up this PNode with other PNodes.

//***********************************************************************
// Native Functions
//***********************************************************************

native final function SetInterPNodeID( int ID );



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
// Default Properties
//***********************************************************************
