//==================================================
// The ZombieDoor class is an extended Mover
// Has ability to rotate away from instigator
//==================================================
class ZombieDoor extends Mover
	native
	placeable;
	
const CloseKey = 0;
const OpenFrontKey = 1;
const OpenBackKey = 2;

var(ZombieRotatingDoor) int OpenRotation;	// the rotation offset from the base rotation.  how much this door will be open (use Unreal degrees.. 90 = 16384)
var() float TimeToOpen;						// time in seconds that door takes to open/close
var() float TimeBeforeClose;				// time in seconds that door stays open
var() bool ShowMessage;						// tells whether or not to show the 'use' message for use door
var() localized string Message;				// message to show

// door type
var() EZombieDoorType ZombieDoorType;

var(ZombieLockedDoor) EZombieDoorType	TypeWhenUnlocked;			// door type after the door is triggered ( used for unlocking )
var(ZombieLockedDoor) bool				bUnlockable;				// is this door unlockable
var(ZombieLockedDoor) name				TagWhenUnlocked;			// Overwrites the Events->Tag when this door is unlocked
var(ZombieLockedDoor) string			MessageWhenUnlocked;		// Door message when it's unlocked
var(ZombieLockedDoor) bool				ShowMessageWhenUnlocked;	// flag for showing message when unlocked

var() float TriggerOffset;				// offset of trigger from door pivot along door orientation vector
var() float TriggerVerticalOffset;		// offset of trigger from door pivot along the UP vector
var() float TriggerHeight;				// height of trigger
var() float TriggerRadius;				// radius of trigger
var(MoverSounds) sound LockedSound;		// sound to play when the a locked door is trigger
var() bool	bAutoClose;					// determine if this door will auto close (only for use door)
var() bool	bNPCAutoUse;				// determine if NPCs will automatically use
var() bool	bNPCIgnoreDoorState;		// NPCs will open this door no matter what state
var() bool	bCloseOnDeadBodies;			

// internal variables used for updating
var float openTime;						// internal for programmer readability
var float resetTime;					// internal for programmer readability
var vector doorNormal;					// simplified, normalized vector that defines the 'front' of the door
var Vector doorVector;					// used in setup
var ZombieDoorTrigger doorTrigger;		// the door trigger for auto, use & locked door

var bool bBlocked;

var EDoorState DoorState;

function BaseStarted();
function BaseFinished();

function PostBeginPlay ( ) 
{
	Super.PostBeginPlay ( );
	
	SetUpDoor ( );
	
	SetUpTrigger ( );
}

function SetUpDoor ( ) 
{
	// local variables
	local Vector		rotVector;	// vector defining the rotation axis
	local Rotator		tempRot;	// temporary rotator used to set up keyframes
					
	KeyNum = CloseKey;
	
	// copy editor vars to programmer versions
	openTime = TimeToOpen;
	resetTime = TimeBeforeClose;

	// set up tempRot
	tempRot.Pitch = 0;
	tempRot.Roll = 0;
	tempRot.Yaw = openRotation;
				
	// set up the closed keyframe
	KeyPos[CloseKey] = Location - Location;
	KeyRot[CloseKey] = Rotation - Rotation;
	
	// set up opened from keyframes
	KeyPos[OpenFrontKey] = Location - Location;
	KeyRot[OpenFrontKey] = tempRot;
	
	// set up opened back keyframes
	KeyPos[OpenBackKey] = Location - Location;
	KeyRot[OpenBackKey] = tempRot * -1;
	
	doorVector.X = 1;
	doorVector.Y = 0;
	doorVector.Z = 0;

	if ( DrawScale3D.X < 0 || DrawScale < 0 )
		doorVector.X = -1;
	
	doorVector = Normal( doorVector >> Self.Rotation );
	
	// set up the rotation vector
	rotVector.X = 0;
	rotVector.Y = 0;
	rotVector.Z = 0;
	
	// door vector drops the z
	doorVector.Z = 0;
	// rotVector points up the z
	rotVector.Z = 1;
		
	// now determine the door normal based on the doorVector and the rotation vector
	doorNormal = Normal ( doorVector Cross rotVector );	
}

function SetUpTrigger ( ) 
{
	local vector TempLoc;
	
	// create the door trigger
	if ( doorTrigger == None )
	{
		doorTrigger = spawn ( class'ZombieDoorTrigger', self );
	}
	
	// set up location
	TempLoc = Location + (triggerOffset * doorVector);
	TempLoc.Z += triggerVerticalOffset;
	doorTrigger.SetLocation( TempLoc );
	
	// set up collision
	doorTrigger.SetCollisionSize( triggerRadius, triggerHeight );
	
	// link it up with the door
	doorTrigger.SetDoor( self );
	
	// set up the trigger state based on the type of door
	if ( ZombieDoorType == ZDT_AUTODOOR ) 
	{		
		doorTrigger.SetTriggerState ( DTS_TOUCH, ShowMessage, Message );
	} 
	else if ( ZombieDoorType == ZDT_USEDOOR ) 
	{		
		doorTrigger.SetTriggerState ( DTS_USE, ShowMessage, Message );		
	} 
	else if ( ZombieDoorType == ZDT_LOCKEDDOOR ) 
	{		
		doorTrigger.SetTriggerState ( DTS_LOCKED, ShowMessage, Message );				
	} 
	else if ( ZombieDoorType == ZDT_TRIGGERDOOR ) 
	{	
		doorTrigger.SetTriggerState ( DTS_DISABLED, ShowMessage, Message );
	}	
}

event bool EncroachingOn ( Actor Other )
{
	//log ( Self.Name@"EncroachingOn"@Other );
	if ( Pawn ( Other ) != None && ZombieDoorType != ZDT_TriggerDoor )
	{
		if ( DoorState == DS_CLOSING )
		{
			OpenDoor ( Other, Instigator );
		}
	}

	return true;
}

simulated event KeyFrameReached ( ) 
{
	local ZombieBipedPawn toucher;

	if ( DoorState == DS_OPENING ) 
	{	
		if ( ZombieSlidingDoor ( Self ) == None )
		{
			SetCollision ( true, true, true );
		}
		
		DoorState = DS_OPEN;
		AmbientSound = None;
		
		if ( OpenedSound != None )
			PlaySound( OpenedSound, SLOT_Misc, SoundVolume / 255.0, false, SoundRadius, SoundPitch / 64.0, false );
			
		if ( OpenedEvent != 'None' )
			TriggerEvent ( OpenedEvent, self, Instigator );

		if ( bAutoClose )
		{
			// start trying to close it
			SetTimer ( resetTime, false );
		}
	} 
	else if ( DoorState == DS_CLOSING ) 
	{	
		if ( ZombieSlidingDoor ( Self ) == None )
		{
			SetCollision ( true, true, true );
		}
		
		DoorState = DS_CLOSED;
		AmbientSound = None;
		
		if ( ClosedSound != None )
			PlaySound( ClosedSound, SLOT_Misc, SoundVolume / 255.0, false, SoundRadius, SoundPitch / 64.0, false );
		
		if ( ClosedEvent != 'None' )	
			TriggerEvent ( ClosedEvent, self, Instigator );

		doorTrigger.DoorClosed ( );

		//if there is an AI touching the door when it is closed then open it
		foreach TouchingActors ( class 'ZombieBipedPawn', toucher )
		{
			if( toucher.Health > 0 && !toucher.IsHumanControlled( ) )
			{
				OpenDoor( None, toucher );
				break;
			}
		}
	}
}

function BlockDoor ( ) 
{
	bBlocked = true;
}

function UnBlockDoor ( ) 
{
	bBlocked = false;
}

function StartOpening ( ) 
{
	local Vector instiVector;
	local float dotResult;

	// get the vector from the instigator to the door object
	instiVector = Location - Instigator.Location;
	
	// simplify the vector
	instiVector.Z = 0;
		
	// normalize the vector
	instiVector = Normal ( instiVector );
	
	// get the dot product
	dotResult = doorNormal Dot instiVector;
	
	// determine if we are in front or behind the door
	if ( dotResult >= 0 ) 
	{		
		InterpolateTo ( OpenBackKey, openTime );
	} 
	else 
	{	
		InterpolateTo ( OpenFrontKey, openTime );
	}
}

function OpenDoor ( Actor Other, Pawn EventInstigator ) 
{
	// if it's closed, we want to open it		
	if ( DoorState == DS_CLOSED || DoorState == DS_CLOSING ) 
	{	
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if ( SavedTrigger != None )
			SavedTrigger.BeginEvent ( );

		if ( OpeningSound != None ) 
			PlaySound( OpeningSound, SLOT_Misc, SoundVolume / 255.0, false, SoundRadius, SoundPitch / 64.0, false );
		
		if ( OpeningEvent != 'None' )	
			TriggerEvent ( OpeningEvent, self, Instigator );
			
		AmbientSound = MoveAmbientSound;

		// set the state to opening
		DoorState = DS_OPENING;
		
		if ( ZombieSlidingDoor ( Self ) == None )
		{
			// make it non solid
			SetCollision ( true, false, false );
		}

		doorTrigger.DoorOpening ( );
		
		// figure out which way to open and then open
		StartOpening ( );
	}
}

function CloseDoor ( ) 
{
	local ZombieBipedPawn toucher;
	// if it's open, we want to close it
	if ( DoorState == DS_OPEN || DoorState == DS_OPENING ) 
	{
		foreach TouchingActors ( class 'ZombieBipedPawn', toucher )
		{
			if( toucher.Health > 0 )
				return;
		}

		DoorState = DS_CLOSING;

		if ( ZombieSlidingDoor ( Self ) == None )
		{
			SetCollision ( true, false, false );
		}

		if ( ClosingSound != None )
			PlaySound( ClosingSound, SLOT_Misc, SoundVolume / 255.0, false, SoundRadius, SoundPitch / 64.0, false );
			
		if ( ClosingEvent != 'None' )
			TriggerEvent ( ClosingEvent, self, Instigator );
			
		AmbientSound = MoveAmbientSound;

		InterpolateTo ( CloseKey, openTime );
	}
}

function TryDoor ( ) 
{
	// play locked door sound
	if ( LockedSound != None )
		PlaySound( LockedSound, SLOT_Misc, SoundVolume / 255.0, false, SoundRadius, SoundPitch / 64.0, false );
}

function Trigger ( Actor Other, Pawn EventInstigator ) 
{
	if ( ZombieDoorType == ZDT_LOCKEDDOOR ) 
	{	
		// check to see if we can unlock this door
		if ( bUnlockable ) 
		{		
			// set the door type
			ZombieDoorType = TypeWhenUnlocked;
			
			// copy the new tag
			if (TagWhenUnlocked != 'None')
			{
				Tag = TagWhenUnlocked;
			}
			
			if ( ZombieDoorType == ZDT_AUTODOOR )				
				doorTrigger.SetTriggerState ( DTS_TOUCH, ShowMessageWhenUnlocked, MessageWhenUnlocked );
			else if ( ZombieDoorType == ZDT_USEDOOR )
				doorTrigger.SetTriggerState ( DTS_USE, ShowMessageWhenUnlocked, MessageWhenUnlocked );
			else if ( ZombieDoorType == ZDT_TRIGGERDOOR )
				doorTrigger.SetTriggerState ( DTS_DISABLED, ShowMessageWhenUnlocked, MessageWhenUnlocked );	
			else if ( ZombieDoorType == ZDT_UNLOCKINGDOOR )
				doorTrigger.SettriggerState ( DTS_UNLOCKING, ShowMessageWhenUnlocked, MessageWhenUnlocked );
		}
		
	} 
	else if ( ZombieDoorType == ZDT_TRIGGERDOOR ) 
	{	
		if ( DoorState == DS_CLOSED || DoorState == DS_CLOSING )
		{
			// open it
			OpenDoor ( Other, EventInstigator );
		}
		else if ( DoorState == DS_OPEN || DoorState == DS_OPENING )
		{
			CloseDoor ( );
		}
	}
}

function UnTrigger ( Actor Other, Pawn EventInstigator ) 
{
	if ( ZombieDoorType == ZDT_TRIGGERDOOR ) 
	{		
		CloseDoor ( );
	}
}

function Timer ( ) 
{
	// if open try to close
	if ( DoorState == DS_OPEN )
	{
		// quick check just to make sure
		if ( bBlocked ) 
		{			
			// loop around
			SetTimer ( 0.1, false );			
		} 
		else 
		{	
			// close the door
			CloseDoor ( );
		}
	}	
}

// whee
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// default properties

// Decompiled with UE Explorer.
defaultproperties
{
    OpenRotation=16384
    TimeToOpen=0.5000000
    TimeBeforeClose=5.0000000
    Message="Press <action=use> to open door"
    ZombieDoorType=1
    MessageWhenUnlocked="Press <action=use> to open door"
    TriggerOffset=20.0000000
    TriggerVerticalOffset=40.0000000
    TriggerHeight=80.0000000
    TriggerRadius=80.0000000
    bNPCAutoUse=true
    bNPCIgnoreDoorState=true
    InitialState="None"
    Texture=Texture'Engine.S_WhiteCircle'
    SoundRadius=256.0000000
    bBlockKarma=true
    bPathColliding=false
}