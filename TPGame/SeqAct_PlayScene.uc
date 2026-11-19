class SeqAct_PlayScene extends SeqAct_Latent
	abstract
	native;


//***********************************************************************
// Variable Declaration
//***********************************************************************

var() bool m_bWaitForSceneToFinish; // wait for anim to finish before continuing 


enum EToggleOptions
{
	ETO_Disable,
	ETO_Enable,
	ETO_LeaveAlone
};

struct native PlaySceneTeleportStruct
{
	var() bool m_bTeleport;
	var() bool m_bPrePivotAdjust;
	var() bool m_bUpdateRotation;
};

struct native PlayScenePhysicsStruct
{
	var() bool 			 m_bSetPhysics;
	var() Actor.EPhysics m_bOverridePhysics;
};

struct native PlaySceneTeleportAndOrientStruct
{
	var() bool   m_bTeleportAndOrient;
	var() bool   m_bUseMayaCoords;
	var() vector m_Position;
	var() vector m_EulerRotation;
};

var() EToggleOptions m_bCollideWorld;
var() EToggleOptions m_bCollideActors;
var() EToggleOptions m_bBlockActors;
var() EToggleOptions m_bPathColliding;
var() EToggleOptions m_bEnableAI;
var() EToggleOptions m_bTargettable;

var() PlaySceneTeleportStruct TeleportInfo;
var() PlaySceneTeleportAndOrientStruct TeleportAndOrientInfo;
var() PlayScenePhysicsStruct  PhysicsInfo;



//***********************************************************************
// CPP Text
//***********************************************************************

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


//***********************************************************************
// Default Properties
//***********************************************************************
