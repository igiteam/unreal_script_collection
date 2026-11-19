//=============================================================================
// SASDominationPoint.uc
//
// Represent a point of domination in a room for squad members to attack from.
//=============================================================================

class SASDominationPoint extends SASAIMapObj
	placeable
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Member Vars

var(TacticalPoint) float		mArcOfDomination;	// Angle either side of DP rotation over which point dominates
var(TacticalPoint) float		mWaitTimeOnClear;
var(TacticalPoint) eDPLookAngle	mLookAngle;		
 
var bool						mbCleared;

// Debug only
var	int							mHighlight;


//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// FindAttachedEP
//
// Finds any EP that this DP is attached to.
native(755) final function SASEntryPoint FindFirstAttachedEP();


//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DrawDebug
//
function DrawDebug(
	HUD aHUD )
{
	local vector	dir;
	local rotator	rotn;
	local Color		lineCol;
	local SASGRI	gri;

	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( mbCleared )
	{
		if (mOwner != None)
		{
			lineCol = class'Canvas'.Static.MakeColor(64,64,255);
		} // if
		else
		{
			lineCol = class'Canvas'.Static.MakeColor(64,255,255);
		} // else
	} // if
	else
	{
		if (mOwner != None)
		{
			lineCol = class'Canvas'.Static.MakeColor(255,32,32);
		} // if
		else
		{
			lineCol = class'Canvas'.Static.MakeColor(255,128,64);
		} // else
	} // else

	if( mHighlight != 0 )
	{
		mHighlight = mHighlight - 1;
		lineCol = class'Canvas'.Static.MakeColor(255,192,192);
	}

	rotn = Rotation;
	rotn.Roll = 0.0;
	rotn.Pitch = 0.0;
	
	rotn.Yaw -= mArcOfDomination;
	dir = Vector(rotn);
	aHUD.Draw3DLine (Location, Location + (dir*CollisionRadius), lineCol);

	rotn.Yaw += 2*mArcOfDomination;
	dir = Vector(rotn);
	aHUD.Draw3DLine (Location, Location + (dir*CollisionRadius), lineCol);


	// pink to player
	if ( mOwner != None )
	{
		lineCol = class'Canvas'.Static.MakeColor(255,128,128);
		aHUD.Draw3DLine (Location, mOwner.Location, lineCol);
	}

	// white to wingman
	if( mOwner != None 
		&& mOwner.Controller != None
		&& SASSoldierController(mOwner.Controller) != None )
	{
		if ( SASSoldierController ( mOwner.Controller ).mbIsWingman )
		{
			lineCol = class'Canvas'.Static.MakeColor(192,255,192);
			aHUD.Draw3DLine (Location, mOwner.Location, lineCol);
		}
		else
		{
			lineCol = class'Canvas'.Static.MakeColor(192,192,192);
			aHUD.Draw3DLine (Location, mOwner.Location, lineCol);
		}
	}
}


//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mArcOfDomination=8192.0000000
    mWaitTimeOnClear=3.0000000
    Texture=Texture'EditorTx.S_DominationPoint'
    CollisionRadius=20.0000000
}