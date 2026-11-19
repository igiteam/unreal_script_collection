//-----------------------------------------------------------------------------
// SASBoobyTrapMgr.uc
//
//-----------------------------------------------------------------------------

class SASBoobyTrapMgr extends ReplicationInfo
	native
	hidecategories(Actor,Advanced,Collision,Events,Force,Karma,LightColor,Lighting,Sound,Movement,Display);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

const MAX_DEVICES = 16;

//-----------------------------------------------------------------------------
// variables
//
var SASBoobyTrapDevice	mDevices[MAX_DEVICES];			// Head of linked list of devices.
var int					mNumDevices;

replication
{
	reliable if ( bNetDirty && ( Role == ROLE_Authority ) )
		mDevices,
		mNumDevices;
}

//-----------------------------------------------------------------------------
// Init
//
event PreBeginPlay ()
{
	local SASBoobyTrapDevice	device;

	foreach AllActors( class'SASBoobyTrapDevice', device )
	{
		RegisterDevice ( device );
	}
}

//-----------------------------------------------------------------------------
// RegisterDevice
//
// add it into the list
function RegisterDevice ( SASBoobyTrapDevice aDevice )
{
	local int i;

	if ( mNumDevices == MAX_DEVICES )
	{
		LogHuman( "More than max ("$MAX_DEVICES$") booby traps in level." );
		return;
	}

	for ( i = 0; i < mNumDevices; i++ )
	{
		if ( mDevices[i] == aDevice )
		{
			return;
		}
	}
	mDevices[mNumDevices] = aDevice;
	mNumDevices++;
}


//-----------------------------------------------------------------------------
// UnregisterDevice
//
function UnregisterDevice ( SASBoobyTrapDevice aDevice )
{
	local int i;

	for ( i = 0; i < mNumDevices; i++ )
	{
		if ( mDevices[i] == aDevice )
		{
			mDevices[i] = None;

			if ( i < mNumDevices-1 )
			{
				mDevices[i] = mDevices[mNumDevices-1];
			}
			mNumDevices--;
			break;
		}
	}
}


//------------------------------------------------------------------------------
//
//
function EventTriggered ( Name aEvent )
{
	local int					i;
	local SASBoobyTrapDevice	device;

	for ( i = 0; i < mNumDevices; i++ )
	{
		device = mDevices[i];

		if ( ( device.mEventName == aEvent ) && device.mbArmed )
		{
			device.Explode();
			UnregisterDevice( device );
		}
	}
}

//------------------------------------------------------------------------------
// defaultproperties 
//

// Decompiled with UE Explorer.
defaultproperties
{
    RemoteRole=1
}