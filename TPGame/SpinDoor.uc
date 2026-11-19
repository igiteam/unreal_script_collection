class SpinDoor extends UseButton
				hidecategories(UseButton)
				placeable;

enum eTurnType
{
	TT_CW,
	TT_CCW,
};

var (Audio) SoundCue LockSound;
var (Audio) SoundCue UnLockSound;
var (Audio) SoundCue TurningSound;
var (Audio) SoundCue LockInPlaceSound;

var () bool bLocked;

var () eTurnType TurnType;

var rotator OriginalRotation;
var () float RateOfRotation;
var float IncrementalTurnAmountDegrees;
var() float IncrementalTurnAmount;

var AudioComponent TurningSoundComponent;
var AudioComponent LockInPlaceSoundComponent;
var AudioComponent UnLockSoundComponent;
var AudioComponent LockSoundComponent;

simulated function PostBeginPlay()
{
	if (TurningSound != none)
	{
		TurningSoundComponent.SoundCue = TurningSound;
		AttachComponent(TurningSoundComponent);
	}
	if (LockInPlaceSound != none)
	{
		LockInPlaceSoundComponent.SoundCue = LockInPlaceSound;
		AttachComponent(LockInPlaceSoundComponent);
	}
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
	OriginalRotation = Rotation;
	IncrementalTurnAmountDegrees = IncrementalTurnAmount;
	IncrementalTurnAmount = IncrementalTurnAmount*65536.0f/360.0f;

}

function OnOpenDoor(SeqAct_OpenDoor inAction)
{
	if (inAction.InputLinks[3].bHasImpulse)
	{
		if (!bLocked)
			LockSoundComponent.Play();
		bLocked = true;
	}
	else if (inAction.InputLinks[4].bHasImpulse)
	{
		if (bLocked)
			UnLockSoundComponent.Play();
		bLocked = false;
	}	
	if (!bLocked)
	{
		GotoState('Rotating');
	}
}

event bool EncroachingOn( actor Other )
{
	return true;
}

state Rotating
{
	event BeginState(Name PreviousStateName)
	{
		TurningSoundComponent.Play();
	}
	event EndState(Name NextStateName)
	{
		LockInPlaceSoundComponent.Stop();
		LockInPlaceSoundComponent.Play();
		TurningSoundComponent.Stop();
	}

	function Tick(float dt)
	{
		local rotator NewRotation;
		local float Rate;

		Rate = (RateOfRotation / IncrementalTurnAmountDegrees) * 4;
			
		switch (TurnType)
		{
		case TT_CW:
			NewRotation = OriginalRotation;
			NewRotation.Yaw = OriginalRotation.Yaw + IncrementalTurnAmount;
			NewRotation = RLerp(  Rotation, NewRotation, Rate*dt, true);
			if (Abs(NewRotation.Yaw - Rotation.Yaw) < 2)
			{
				NewRotation.Yaw = OriginalRotation.Yaw + IncrementalTurnAmount;
				OriginalRotation = NewRotation;
				SetRotation(NewRotation);
				GotoState('');
			}
			SetRotation(NewRotation);
			break;
		case TT_CCW:
			NewRotation = OriginalRotation;
			NewRotation.Yaw = OriginalRotation.Yaw - IncrementalTurnAmount;
			NewRotation = RLerp(  Rotation, NewRotation, Rate*dt, true);
			if (Abs(NewRotation.Yaw - Rotation.Yaw) < 2)
			{
				NewRotation.Yaw = OriginalRotation.Yaw - IncrementalTurnAmount;
				OriginalRotation = NewRotation;
				SetRotation(NewRotation);
				GotoState('');
			}
			SetRotation(NewRotation);
			break;
		}
	}
}

