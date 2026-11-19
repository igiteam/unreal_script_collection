class SeqAct_EndSceneAnimation extends SequenceAction
	dependson(SeqAct_PlaySceneAnimation);


struct native EndScenePhysicsStruct
{
	var() bool 			 m_bSetPhysics;
	var() Actor.EPhysics m_bOverridePhysics;
};


//***********************************************************************
// Variable Declaration
//***********************************************************************
var() EToggleOptions m_bCollideWorld;
var() EToggleOptions m_bCollideActors;
var() EToggleOptions m_bBlockActors;
var() EToggleOptions m_bPathColliding;
var() EToggleOptions m_bEnableAI;
var() EToggleOptions m_bTargettable;

var() EndScenePhysicsStruct PhysicsInfo;


//***********************************************************************
// CPP Text
//***********************************************************************


//***********************************************************************
// Default Properties
//***********************************************************************
