//=============================================================================
// SASEntryPoint.uc
//
//=============================================================================

class SASEntryPoint extends Door
	placeable
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const AVLINK_Behind								= 0;
const AVLINK_InFront							= 1;
const AVLINK_MaxLinks							= 2;		// Max number of assault volume the EP links to.

const DEFAULT_FATAL_FUNNEL_RADIUS				= 96.0;		// Default radius of fatal funnel for EPs linked to doors
const MAX_STACKUP_POINTS						= 2;
const STACKUP_DEFAULT_FACING_ANGLE_FROM_WALL	= 24576;	// 135deg
const STACKUP_POINT_DIST_THRESHOLD				= 48.0;

const SOUND_PROP_ATTENUATION_MAX				= 0.25; 

//-----------------------------------------------------------------------------
// Enums

enum EStackUpConfig
{
	STACKUP_None,
	STACKUP_Left,
	STACKUP_Right
};
//-----------------------------------------------------------------------------
// Structs

// Struct ot define a path-finding reach spec between 2 EPs. Used by 
// higher level assault vol -> assault vol path-finding.
struct native EPReachSpec
{
	var SASEntryPoint	End;					// Other EP with path to.
	var float			PathDist;				// Min path distance to End EP.
	var float			SoundPropagationDist;	// Sound propagation effective distance between EPs.
};


struct native StackUpParams
{
	// Editable params.
	var() EStackUpConfig	eConfig;
	var() bool				bAutoAdjust;
	var() eKnightsAnim		mKnightsMoveAnim;
	var() Vector			Positions[MAX_STACKUP_POINTS];
	var() int				FacingAngles[MAX_STACKUP_POINTS];
	var() int				NumPoints;
	var() float				DistFromWall;
	var() float				FirstPointDistFromEP;
	var() float				PointSpacing;
};

struct native AssaultRoute
{
	var array<SASDominationPoint>	DPList;
};

//-----------------------------------------------------------------------------
// Member Vars

var() StackUpParams				mStackUpParams[AVLINK_MaxLinks];	// Assaulting stack up data for either side of EP.	
var () Vector					mBreachPosition [AVLINK_MaxLinks];	// Position taken up by guy blowing door off it's hinges
var() const float				mFatalFunnelRadius;					// Fatal funnel radius - 0.0 for no fatal funnel. 
var() const float				mAssaultRadius;						// EP room assaulting radius (if player within this rad, room assault trigggered).
var() bool						mbEPVolForceCreate;					// If true then an EP volume will be created even if the EP is not attached to a door.
var() bool						mbEPVolDontCreate;					// If true then an EP volume will not be created even if the EP has a door, it will also delete an existing attached EP vol.

var const SASEntryPoint			mNextEntryPoint;					// Ptr to next EP in linked list of EPs in the level.
var() const editconst array<EPReachSpec>	mReachSpecs;			// EP->EP reach specs for path-finding (seperate array per AV side).
var() const SASEntryPointVolume	mLinkedEPVol;
var const int					mFirstReachSpecInFront;				// Index into mReachSpecs array of first ReachSpec in AV in front of EP (specs are ordered with behind specs first).
var const SASAssaultVolume		mAssaultVolLinks[AVLINK_MaxLinks];	// The assault volumes this entry point links to.
var const int					mOtherAVClosestReachSpecIdx;
var SASDominationPoint			mDPLinks [4];						// Two pairs of DPs relating to each assault volume
var const bool					mbLinksToPathEndAV;					// Flag set during path-finding to indicate EP links to goal AV.
var() editconst AssaultRoute	mAssaultRoutes[4];

// Pathfinding vars
var const SASEntryPoint			mNextEPOnRoute;						// Ptr to next EP on route if this EP is in last path found.
var const bool					mbSoundPropagationNodeRejected;		// Flags that node has been checked during sound propagation path-finding and has been rejected as a potention propagation path.

//-----------------------------------------------------------------------------
// Native Functions

native(756) final function bool IsLinkedToAssaultVolume( 
	SASAssaultVolume	aAV );

native(757) final function SASAssaultVolume GetOtherAssaultVolume( 
	SASAssaultVolume	aAV );

native(758) final function bool GetStackUpLocation(
	int			aStackUpSide,
	int			aStackUpSlot,
	out Vector	aStackUpLoc );

native(759) final function bool GetStackUpRotation(
	int			aStackUpSide,
	int			aStackUpSlot,
	out Rotator	aStackUpRot );


//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

function PostBeginPlay()
{
	local int side;
	local int slot;

	Super.PostBeginPlay();

	// Make sure stack up parameters have sensible data values.
	for ( side = 0; side < AVLINK_MaxLinks; ++side )
	{
		// Can't have more points than MAX_STACKUP_POINTS
		mStackUpParams[side].NumPoints = Min( mStackUpParams[side].NumPoints, MAX_STACKUP_POINTS );

		// If any of our slots have a zero vector position, cut off the array at this point.
		for ( slot = 0; slot < mStackUpParams[side].NumPoints; ++slot )
		{
			if ( mStackUpParams[side].Positions[slot] == vect(0,0,0) )
			{
				mStackUpParams[side].NumPoints = slot;
				break;
			}
		}

		// If now have no points on this side, update the stackup config to 'None'
		if ( mStackUpParams[side].NumPoints == 0 )
		{
			mStackUpParams[side].eConfig = STACKUP_None;
		}
	}

	if ( MyDoor == None )
	{
		bBlocked = false;
	}
	else
	{
		// Block EPs associated with locked doors.
		if ( (SASDoorMover( MyDoor ) != None) && SASDoorMover( MyDoor ).mbLocked )
		{
			bBlocked = true;
		}
	}

	memRegister ();
}


//-----------------------------------------------------------------------------
function drawEPOverlay (SASHud aHUD)
{
	local Color colour;

	colour = class'Canvas'.Static.MakeColor (64, 128, 255);

	aHUD.Draw3DCylinder (Location, vect (0, 0, 1), mAssaultRadius, 6, 8, colour);

	// Stack up positions
	if (mStackupParams [0].Positions [0] != Vect (0, 0, 0))
	{
		aHUD.Draw3DCylinder (mStackupParams [0].Positions [0], vect (0, 0, 1), 16, 40, 8, colour);
	} // if
	if (mStackupParams [0].Positions [1] != Vect (0, 0, 0))
	{
		aHUD.Draw3DCylinder (mStackupParams [0].Positions [1], vect (0, 0, 1), 16, 40, 8, colour);
	} // if
	if (mStackupParams [1].Positions [0] != Vect (0, 0, 0))
	{
		aHUD.Draw3DCylinder (mStackupParams [1].Positions [0], vect (0, 0, 1), 16, 40, 8, colour);
	} // if
	if (mStackupParams [1].Positions [1] != Vect (0, 0, 0))
	{
		aHUD.Draw3DCylinder (mStackupParams [1].Positions [1], vect (0, 0, 1), 16, 40, 8, colour);
	} // if

	// Breach positions
	colour = class'Canvas'.Static.MakeColor (255, 255, 0);
	if (mBreachPosition [0] != Vect (0, 0, 0))
	{
		aHUD.Draw3DCylinder (mBreachPosition [0], vect (0, 0, 1), 16, 40, 8, colour);
	} // if
	if (mBreachPosition [1] != Vect (0, 0, 0))
	{
		aHUD.Draw3DCylinder (mBreachPosition [1], vect (0, 0, 1), 16, 40, 8, colour);
	} // if
} // drawEPOverlay

//-----------------------------------------------------------------------------
function bool hasValidStackup ()
{
	if (mStackupParams [0].Positions [0] == Vect (0, 0, 0))
	{
		return false;
	} // if
	else
	{
		return true;
	} // else
} // if

//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mStackUpParams[0]=(eConfig=0,bAutoAdjust=true,mKnightsMoveAnim=0,Positions=(X=0.0000000,Y=0.0000000,Z=0.0000000),Positions[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000),FacingAngles=0,FacingAngles[1]=0,NumPoints=4,DistFromWall=18.0000000,FirstPointDistFromEP=48.0000000,PointSpacing=40.0000000)
    mStackUpParams[1]=(eConfig=0,bAutoAdjust=true,mKnightsMoveAnim=0,Positions=(X=0.0000000,Y=0.0000000,Z=0.0000000),Positions[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000),FacingAngles=0,FacingAngles[1]=0,NumPoints=4,DistFromWall=18.0000000,FirstPointDistFromEP=48.0000000,PointSpacing=40.0000000)
    mAssaultRadius=100.0000000
    mOtherAVClosestReachSpecIdx=-1
    mbEntryPoint=true
    Texture=Texture'EditorTx.S_EntryPoint'
    CollisionRadius=48.0000000
    bCollideWhenPlacing=false
}