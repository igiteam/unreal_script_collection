//=============================================================================
// SASPatrolPoint.uc
//
// Points used by NPCs to move between when patrolling. SASPatrolPoints are 
// not navigation points so nav points are still required to move between 
// patrol points. Patrol points can have multiple links to other points and
// pick the next point at random.
//=============================================================================

class SASPatrolPoint extends Keypoint;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Variables

var() float								mWeighting;				// Weighting of likelyhood of this point being picked over others (0.0->1.0) 
var() bool								mbFaceDirection;		// Patroller should face direction of patrol point when reached 
var() float								mIdleProbability;		// Probability of NPC idling at this node (0.0->1.0)
var() Range								mIdleTime;				// Min/Max idle time
var() name								mIdleAnim;				// Name of an animation to play while idling
var() bool								mbIdleLoopAnim;			//
var() edfindable SASScriptedSequence	mScript;				// Scripted sequence for owner pawn to use on reaching this point					
var() bool								mbScriptPlayOnlyOnce;	// Indicates if attached scirpt should only be played once
var() float								mScriptMinTimeBetweenPlaying;	// Min time between successive playing of script
var() edfindable array<SASPatrolPoint>	mLinks;					// An array of points we link to

var int									mNumLinks;				// Num patrol points linked to
var SASTerroristController				mOwner;					// Current owner of point		
var bool								mbScriptPlayed;			// Script has been played at least once
var float								mLastScriptPlayTime;	// Last level time script was played.


//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
//
event PreBeginPlay()
{
	CheckLinks();
}


///////////////////////////////////////////////////////////////////////////////
// CheckLinks
//
// Check validity of points we link to.
function CheckLinks()
{
	local int	i;

	// Remove empty links
	for ( i = 0; i < mLinks.Length; ++i )
	{
		if ( mLinks[i] == None )
		{
			LogHuman( "SASPatrolPoint.CheckLinks: Patrol point "$Name$"  contains empty link elements." );
			mLinks.Remove( i, 1 );
			i--;
		}
	}

	// Remove links that point to self
	for ( i = 0; i < mLinks.Length; ++i )
	{
		if ( mLinks[i] == self )
		{
			LogHuman( "SASPatrolPoint.CheckLinks: Patrol point "$Name$" links to itself" );
			mLinks.Remove( i, 1 );
			i--;
		}
	}

	mNumLinks = mLinks.Length;
	if ( mNumLinks == 0 )
	{
		LogHuman( "SASPatrolPoint.CheckLinks: Patrol point "$Name$" links to nothing" );
	}
}


///////////////////////////////////////////////////////////////////////////////
// OwnerGetNextPoint
//
// Called by patrolling terrorist asking for a new patrol point to move to.
// Next point is picked at random from mLinks array though will not
// select the previous point visited unless its the only one available and
// will not select point currently owned by another NPC. 
// Returns the selected point. 
function SASPatrolPoint OwnerGetNextPoint()
{
	local int				i;
	local float				totLinkWeightings;
	local int				numAvailableLinks;
	local float				val, accum;
	local SASPatrolPoint	next;

	if ( mNumLinks > 0 )
	{
		// Add up point selection weighting of all available points 
		numAvailableLinks = 0;
		for ( i = 0; i < mNumLinks; ++i )
		{
			if ( OwnerCanMoveToLinkedPoint( i ) )
			{
				totLinkWeightings += mLinks[i].mWeighting;
				numAvailableLinks++;
			}
		}

		// If no free points available, check the previously visited point for availability. 
		// If thats also taken then return self to indicate nothing currently available.
		if ( numAvailableLinks == 0 )
		{
			if ( (mOwner.mPrevPatrolPoint != None) && (mOwner.mPrevPatrolPoint.mOwner == None) )
			{
				next = mOwner.mPrevPatrolPoint;
			}
			else
			{
				next = self;
			}
		}
		else
		{
			// Pick a weighted-random point
			val = FRand() * totLinkWeightings;
			accum = 0.0;
			for ( i = 0; i < mNumLinks; ++i )
			{
				if ( OwnerCanMoveToLinkedPoint ( i ) )
				{
					accum += mLinks[i].mWeighting;
					if ( val <= accum )
					{
						next = mLinks[i];
						break;
					}
				}
			}
 
			if ( next == None )
			{
				// Pick first available
				for ( i = 0; i < mNumLinks; ++i )
				{
					if ( OwnerCanMoveToLinkedPoint( i ) )
					{
						next = mLinks[i];
						break;
					}
				}
			}
		}
	}

	return next;
}


///////////////////////////////////////////////////////////////////////////////
// Acquire
//
function bool Acquire(
	SASTerroristController	aNewOwner )
{
	if ( mOwner != None )
	{
		return false;
	}

	if ( aNewOwner == None )
	{
		return false;
	}

	mOwner = aNewOwner;
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// Relinquish
//
function Relinquish(
	SASTerroristController	aRelinquisher )
{
	if ( aRelinquisher != mOwner)
	{
		Warn( "Non-owner terrorist controller "$aRelinquisher$" tryed to relinquish patrol point." );
		return;
	}

	mOwner = None;
}


///////////////////////////////////////////////////////////////////////////////
// OwnerCanMoveToLinkedPoint
//
function bool OwnerCanMoveToLinkedPoint(
	int aLinkIdx )
{
	if ( (mOwner == None ) || (aLinkIdx >= mNumLinks) )
	{
		return false;
	}

	if ( (mLinks[aLinkIdx].mOwner == None) 
		&& (mLinks[aLinkIdx] != mOwner.mPrevPatrolPoint) )	// Don't include previously visited point
	{
		return true;
	}

	return false;
}
 

///////////////////////////////////////////////////////////////////////////////
// GetIdleTime
//
// Returns the time for an NPC to idle at this point.
//::function float GetIdleTime()
//::{
//::	// Don't idle if we have zero idle probability
//::	if ( mIdleProbability == 0.0 )
//::	{
//::		return 0.0;
//::	}
//::
//::	// Randomly choose to idle depending on idle probability
//::	if ( (mIdleProbability == 1.0) || (FRand() < mIdleProbability) )
//::	{
//::		// Chose random idle time
//::		return RandRange( mIdleTime.Min, mIdleTime.Max );
//::	}
//::
//::	return 0.0;
//::}


///////////////////////////////////////////////////////////////////////////////
// ReachedPlayScriptOn
//
// Plays the patrol point's script on its owner if it can.
// Returns True if script is played.
function bool ReachedPlayScript()
{
	// Can't play script if no script or controller to play script on
	if ( (mScript == None) || (mOwner == None) )
	{
		return false;
	}

	// Can't play script if it has already been played AND
	//		1) script can only be played once OR
	//		2) time since last played is less than allowed min time between playing.
	if ( (mbScriptPlayed 
		&& (mbScriptPlayOnlyOnce
			|| ((Level.TimeSeconds - mLastScriptPlayTime) < mScriptMinTimeBetweenPlaying))) )
	{
		return false;
	}

	mScript.RunScriptOnAIController( mOwner );
	mbScriptPlayed = true;
	mLastScriptPlayTime = Level.TimeSeconds;

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// ReachedGetIdleTime
//
function float ReachedGetIdleTime()
{
	// Don't idle if we have zero idle probability
	if ( mIdleProbability == 0.0 )
	{
		return 0.0;
	}

	// Randomly choose to idle depending on idle probability
	if ( (mIdleProbability == 1.0) || (FRand() < mIdleProbability) )
	{
		// Chose random idle time
		return RandRange( mIdleTime.Min, mIdleTime.Max );
	}

	return 0.0;
}


//-----------------------------------------------------------------------------
// States


//-----------------------------------------------------------------------------
// Default properties





// Decompiled with UE Explorer.
defaultproperties
{
    mWeighting=0.5000000
    mIdleProbability=1.0000000
    mIdleTime=(Min=2.0000000,Max=4.0000000)
    Texture=Texture'Engine.S_Teleport'
}