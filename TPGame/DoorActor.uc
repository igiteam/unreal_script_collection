class DoorActor extends UseButton
				hidecategories(UseButton)
				placeable
				native;

enum eDoorOpenType
{
	DOT_Rotating,
	DOT_Sliding,
};

enum eDoorTranslationType
{
	DTT_Left,
	DTT_Right,
	DTT_Up,
	DTT_Down,
	DTT_Forward,
	DTT_Back,
};

var (Audio) SoundCue LockSound;
var (Audio) SoundCue UnLockSound;
var (Audio) SoundCue LockedSound;
var (Audio) SoundCue OpenSound;
var (Audio) SoundCue CloseSound;
var (Audio) SoundCue ClosingSound;
var (Audio) SoundCue OpeningSound;
var (Audio) bool bStopSoundsWithDoor;

var () bool bStopOnEncroach;
var () bool bLocked;
var () bool bNeedKey;
var () string LockedMessage;
var () float StayOpenTime;

var () eDoorOpenType DoorType;

var (SlidingDoor) float RateOfTranslation;
var (SlidingDoor) float MaxTranslation;
var (SlidingDoor) eDoorTranslationType TranslationType;

var (RotatingDoor) float RateOfRotation;
var (RotatingDoor) float MaxInternalAngle;
var (RotatingDoor) float MaxExternalAngle;
var float MaxInAngleInDegrees;
var float MaxExAngleInDegrees;

// Internal Variables
var vector InitialLocation;
var rotator InitialRotation;
var bool OpenedIn;
var bool OpenedOut;
var bool bIsClosing;

var ArrowComponent RotationArrow, TranslationArrow;
var AudioComponent LockSoundComponent;
var AudioComponent UnLockSoundComponent;
var AudioComponent LockedSoundComponent;
var AudioComponent OpenSoundComponent;
var AudioComponent OpeningSoundComponent;
var AudioComponent CloseSoundComponent;
var AudioComponent ClosingSoundComponent;

var() float DontCloseOnPlayerDistance;

//////// need to make doors work with Kynapse PathObjects ////////
/** internal variable keeping a pointer on the Kynapse entity */
var private pointer KynapseEntity;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

replication
{
	if (bNetInitial && Role == Role_Authority)
		InitialRotation, InitialLocation, RateOfTranslation, MaxTranslation, TranslationType, DoorType, StayOpenTime;
	if( bNetDirty && Role == ROLE_Authority )
		OpenedIn, OpenedOut, bIsClosing, bLocked, bNeedKey, bStopOnEncroach;
}

final native function InitKynapseEntity(string EntityDefintionName);
final native function DestroyKynapseEntity();
/* not used any more
final native function OpenKynapseDoor();
*/
/* not used any more
final native function CloseKynapseDoor();
*/
final native function UnlinkAllLinkedKynapseEdges();
final native function LinkAllIntersectingKynapseEdges();

// move this stuff out to DoorPathObject::OpenDoor & DoorPathObject::CloseDoor
final native function CalcKynapseOBB();
//////////////////////////////////////////////////////////////////

function PreBeginPlay()
{
	Super.PreBeginPlay();
	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		InitKynapseEntity("KynapseDoorPathObjectDefinition");
	}
}

//-----------------------------------------------------------------------
// Function: PostBeginPlay    
// Description:	
//-----------------------------------------------------------------------
simulated function PostBeginPlay()
{
	InitialRotation = Rotation;
	InitialLocation = Location;

	MaxInAngleInDegrees = MaxInternalAngle;
	MaxExAngleInDegrees = MaxExternalAngle;
	MaxInternalAngle = MaxInternalAngle*65536.0f/360.0f;
	MaxExternalAngle = MaxExternalAngle*65536.0f/360.0f;

	// Assign Sounds	
	if (LockSound != none)
	{
		LockSoundComponent.SoundCue = LockSound;
		AttachComponent(LockSoundComponent);
	}
	if (UnLockSound != none)
	{
		UnLockSoundComponent.SoundCue = UnLockSound;
		AttachComponent(UnLockSoundComponent);
	}
	if (LockedSound != none)
	{
		LockedSoundComponent.SoundCue = LockedSound;
		AttachComponent(LockedSoundComponent);
	}
	if (OpenSound != none)
	{
		OpenSoundComponent.SoundCue = OpenSound;
		AttachComponent(OpenSoundComponent);
	}
	if (OpeningSound != none)
	{
		OpeningSoundComponent.SoundCue = OpeningSound;
		AttachComponent(OpeningSoundComponent);
	}
	if (CloseSound != none)
	{
		CloseSoundComponent.SoundCue = CloseSound;
		AttachComponent(CloseSoundComponent);
	}
	if (ClosingSound != none)
	{
		ClosingSoundComponent.SoundCue = ClosingSound;
		AttachComponent(ClosingSoundComponent);
	}

}

// this kills them quicker than FinishDestroy
simulated function Destroyed()
{
	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		DestroyKynapseEntity();
	}
	Super.Destroyed();
}

function OnToggleDoor(SeqAct_ToggleDoor inAction)
{
	if (!bLocked || inAction.bOverrideLock)
	{
		if (inAction.InputLinks[0].bHasImpulse)
		{
			switch(inAction.OpenDirection)
			{
			case OPEN_IN:
				OpenedIn = true;
				GotoState('Opening');
				break;
			case OPEN_OUT:
				OpenedOut = true;
				GotoState('Opening');
				break;
			}
		}
		else if (inAction.InputLinks[1].bHasImpulse)
		{
			GotoState('Closing');
		}
		else if (inAction.InputLinks[2].bHasImpulse)
		{
			if (bIsClosing || !IsInState('Opening'))
			{
				switch(inAction.OpenDirection)
				{
				case OPEN_IN:
					OpenedIn = true;
					GotoState('Opening');
					break;
				case OPEN_OUT:
					OpenedOut = true;
					GotoState('Opening');
					break;
				}
			}
			else
				GotoState('Closing');
				
		}
	}
}

function OnOpenDoor(SeqAct_OpenDoor inAction)
{
	local vector X, Y, Z;
	local Pawn InstigatorPawn;
	
	InstigatorPawn = Pawn(inAction.Instigator);

	if (inAction.InputLinks[2].bHasImpulse)
	{
		if (!bLocked)
			LockSoundComponent.Play();
		bLocked = true;
	}
	else if (inAction.InputLinks[3].bHasImpulse)
	{
		if (bLocked)
			UnLockSoundComponent.Play();
		bLocked = false;
	}		

	if (inAction.InputLinks[1].bHasImpulse)
	{
		GotoState('Closing');
		return;
	}

	if (!bLocked)
	{
		if (inAction.InputLinks[0].bHasImpulse)
		{
			GetAxes(Rotation, X, Y, Z);
								
			switch(inAction.OpenDirection)
			{
				case OPEN_BOTH:
					if (inAction.Instigator == None || Normal(Location-inAction.Instigator.Location) dot Y > 0)
					{
						if (inAction.bForceLockIn)
						{
							if (!LockedSoundComponent.bWasPlaying && (!OpenedOut && !OpenedIn))
								LockedSoundComponent.Play();
							if (InstigatorPawn != none)
								InstigatorPawn.ClientMessage(LockedMessage);
						}
						else
						{
							if (!OpenedIn)
								OpenSoundComponent.Play();
							OpenedIn = true;
						}
					}
					else
					{
						if (inAction.bForceLockOut)
						{
							if (!LockedSoundComponent.bWasPlaying && (!OpenedOut && !OpenedIn))
								LockedSoundComponent.Play();
							if (InstigatorPawn != none)
								InstigatorPawn.ClientMessage(LockedMessage);
						}
						else
						{
							if (!OpenedOut)
								OpenSoundComponent.Play();

							OpenedOut = true;
						}
					}
				break;
				case OPEN_IN:
					if (inAction.bForceLockOut)
					{
						if (!LockedSoundComponent.bWasPlaying && (!OpenedOut && !OpenedIn))
							LockedSoundComponent.Play();
						if (InstigatorPawn != none)
							InstigatorPawn.ClientMessage(LockedMessage);
					}
					else
					{
						if (inAction.Instigator == None || Normal(Location-inAction.Instigator.Location) dot Y > 0)
						{
							if (!OpenedIn)
								OpenSoundComponent.Play();
							OpenedIn = true;
						}
					}
				break;
				case OPEN_OUT:
					if (inAction.bForceLockIn)
					{
						if (!LockedSoundComponent.bWasPlaying && (!OpenedOut && !OpenedIn))
							LockedSoundComponent.Play();
						if (InstigatorPawn != none)
							InstigatorPawn.ClientMessage(LockedMessage);
					}
					else
					{
						if (inAction.Instigator == None || Normal(Location-inAction.Instigator.Location) dot Y < 0)
						{
							if (!OpenedOut)
								OpenSoundComponent.Play();

							OpenedOut = true;
						}
					}
				break;
			}
			
			if (!IsInState('Opening'))
				GotoState('Opening');
			else
				GotoState('Closing');
		}
	}
	else
	{
		if (!LockedSoundComponent.bWasPlaying)
			LockedSoundComponent.Play();
		if (InstigatorPawn != none)
			InstigatorPawn.ClientMessage(LockedMessage);
	}
}

function Timer()
{
	GotoState('Closing');
}

simulated event bool EncroachingOn( actor Other )
{
	return bStopOnEncroach;
}

simulated state Opening
{

	simulated event BeginState(Name PreviousStateName)
	{
		UnlinkAllLinkedKynapseEdges();

		bIsClosing = false;
		ClosingSoundComponent.Stop();
		OpeningSoundComponent.Play();
	}
	
	simulated function Tick(float dt)
	{
		local rotator NewRotation, FinalRotation;
		local vector NewLocation, FinalLocation;
		local float Rate;

		CalcKynapseOBB(); // try to save some cpu time
		
		switch(DoorType)
		{
		case DOT_Rotating:

			if (OpenedIn)
			{
				NewRotation = InitialRotation;
				NewRotation.Yaw = InitialRotation.Yaw + MaxInternalAngle;
				FinalRotation = NewRotation;
				Rate = (RateOfRotation / MaxInAngleInDegrees) * 4;
				NewRotation = RLerp(  Rotation, NewRotation, Rate * dt, true);
				SetRotation(NewRotation);
			}
			if (OpenedOut)
			{
				NewRotation = InitialRotation;
				NewRotation.Yaw = InitialRotation.Yaw - MaxInternalAngle;
				FinalRotation = NewRotation;
				Rate = (RateOfRotation / MaxExAngleInDegrees) * 4;
				NewRotation = RLerp(  Rotation, NewRotation, Rate * dt, true);
				SetRotation(NewRotation);
			}
			if (Abs(FinalRotation.Yaw - NewRotation.Yaw) < 100)
			{
				/* debug door logs
				`log("door: FinalRotation=" @ FinalRotation @ "NewRotation=" @ NewRotation);
				`log("door: StayOpenTime=" @ StayOpenTime);
				`log("door: name=" @ name);
				*/

				if (bStopSoundsWithDoor)
					OpeningSoundComponent.Stop();
				
				// completely opened
				LinkAllIntersectingKynapseEdges();
				
				if (StayOpenTime > 0)
				{
					SetTimer(StayOpenTime, false);
					//GotoState(''); // move outside if block to stop repeat calls to unlock/lock edges
				}
				GotoState(''); // move outside if block to stop repeat calls to unlock/lock edges
			}
			break;
		case DOT_Sliding:
				
			switch (TranslationType)
			{
			case DTT_Left:
				NewLocation = InitialLocation + ((vect(1,0,0) * MaxTranslation) >> Rotation);
				break;
			case DTT_Right:
				NewLocation = InitialLocation - ((vect(1,0,0) * MaxTranslation) >> Rotation);
				break;
			case DTT_Up:
				NewLocation = InitialLocation + ((vect(0,0,1) * MaxTranslation) >> Rotation);
				break;
			case DTT_Down:
				NewLocation = InitialLocation - ((vect(0,0,1) * MaxTranslation) >> Rotation);
				break;
			case DTT_Forward:
				NewLocation = InitialLocation - ((vect(0,1,0) * MaxTranslation) >> Rotation);
				break;
			case DTT_Back:
				NewLocation = InitialLocation + ((vect(0,1,0) * MaxTranslation) >> Rotation);
				break;
			}

			Rate = (RateOfTranslation / MaxTranslation) * 4;
			FinalLocation = NewLocation;
			NewLocation = VLerp(Location, NewLocation, Rate * dt);
			
			SetLocation(NewLocation);
		
			if (VSize(NewLocation - FinalLocation) < 1)
			{
				/* debug door logs
				`log("door: newlocation=" @ NewLocation @ "FinalLocation=" @ FinalLocation);
				`log("door: StayOpenTime=" @ StayOpenTime);
				`log("door: name=" @ name);
				*/

				if (bStopSoundsWithDoor)
					OpeningSoundComponent.Stop();
					
				// completely opened
				LinkAllIntersectingKynapseEdges();
				
				if (StayOpenTime > 0)
				{
					SetTimer(StayOpenTime, false);
					//GotoState(''); // move outside if block to stop repeat calls to unlock/lock edges
				}
				GotoState(''); // move outside if block to stop repeat calls to unlock/lock edges
			}
			break;
		}
	}
}

simulated state Closing
{
		

	simulated event BeginState(Name PreviousStateName)
	{
		local PlayerController PC;
		local TPPlayerController TPC;
		local bool bDelayClose;

		UnlinkAllLinkedKynapseEdges();

		bDelayClose = false;

		foreach LocalPlayerControllers(class'PlayerController', PC)
		{
			TPC = TPPlayerController(PC);
			if (TPC != None)
			{
				//`log("Distance to door"@self@Vsize(Location - TPC.Pawn.Location));
				if (Vsize(Location - TPC.Pawn.Location) < DontCloseOnPlayerDistance)
					bDelayClose = true;
			}
		}

		if (bDelayClose)
		{
			//`log("Delaying close");
			SetTimer(1.0f, false);
			GotoState('');
		}
		bIsClosing = true;
		OpeningSoundComponent.Stop();
		ClosingSoundComponent.Play();
	}

	simulated function Tick(float dt)
	{
		local rotator NewRotation;
		local vector NewLocation;
		local float Rate;

		CalcKynapseOBB(); // try to save some cpu time

		switch(DoorType)
		{
		case DOT_Rotating:
			
			if (OpenedIn)
				Rate = (RateOfRotation / MaxInAngleInDegrees) * 4;
			else
				Rate = (RateOfRotation / MaxExAngleInDegrees) * 4;
			
			NewRotation = InitialRotation;
			NewRotation = RLerp(  Rotation, NewRotation, Rate * dt, true);
			SetRotation(NewRotation);
			
			if (Abs(InitialRotation.Yaw - NewRotation.Yaw) < 100)
			{
				if (bStopSoundsWithDoor)
					ClosingSoundComponent.Stop();
				
				// completely closed
				LinkAllIntersectingKynapseEdges();
				
				CloseSoundComponent.Play();
				OpenedIn = false;
				OpenedOut = false;
				GotoState('');
			}
			break;
		case DOT_Sliding:

			Rate = (RateOfTranslation / MaxTranslation) * 4;
			
			NewLocation = InitialLocation;
			NewLocation = VLerp(Location, NewLocation, Rate * dt);
			SetLocation(NewLocation);
			
			OpenedOut = false;
			OpenedIn = false;
			
			if (VSize(NewLocation - InitialLocation) < 1)
			{
				if (bStopSoundsWithDoor)
					ClosingSoundComponent.Stop();

				// completely closed
				LinkAllIntersectingKynapseEdges();
				
				CloseSoundComponent.Play();
				GotoState('');
			}
			break;

		}
	}
}

