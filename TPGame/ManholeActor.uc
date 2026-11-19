class ManholeActor extends UseButton
    hidecategories(UseButton)
	placeable;

var(Audio) SoundCue LockSound;
var(Audio) SoundCue UnlockSound;
var(Audio) SoundCue LockedSound;
var(Audio) SoundCue OpenSound;
var(Audio) SoundCue CloseSound;
var(Audio) SoundCue ClosingSound;
var(Audio) SoundCue OpeningSound;

var() float  RateOfUpTranslation;
var() float  RateOfOverTranslation;
var() float  MaxUpTranslation;
var() float  MaxOverTranslation;
var() bool   bLocked;

var   vector InitialLocation;
var   vector FinalLocation;
var   float  Inverse;
var   float  Rate;
var   name   PendingState;
var   bool   bOpened;
var   vector Dir;



auto state Idle
{
    function OnToggleManhole(SeqAct_ToggleManhole action)
    {
        if (action.InputLinks[3].bHasImpulse)
        {
            bLocked = true;
            PlaySound(LockSound);
        }

        if (action.InputLinks[4].bHasImpulse)
        {
            bLocked = false;
            PlaySound(UnlockSound);
        }

        if (action.InputLinks[0].bHasImpulse)
        {
            if (!bLocked)
            {
                Inverse = 1.0;
                if (!bOpened)
                {
                    bOpened = true;
                    PlaySound(OpeningSound);
                    GoToState('MoveUp');
                }
            }
            else
            {
                PlaySound(LockedSound);
            }
        }

        if (action.InputLinks[1].bHasImpulse)
        {
            if (!bLocked)
            {
                Inverse = -1.0;
                if (bOpened)
                {
                    bOpened = false;
                    PlaySound(ClosingSound);
                    GoToState('MoveOver');
                }
            }
            else
            {
                PlaySound(LockedSound);
            }
        }

        if (action.InputLinks[2].bHasImpulse)
        {
            if (!bLocked)
            {
                Inverse = bOpened? -1.0 : 1.0;
                bOpened = !bOpened;

                if (bOpened)
                {
                    PlaySound(OpeningSound);
                    GoToState('MoveUp');
                }
                else
                {
                    PlaySound(ClosingSound);
                    GoToState('MoveOver');
                }
            }
            else
            {
                PlaySound(LockedSound);
            }
        }
    }
}

state MoveBase
{
    event Tick(float DeltaTime)
    {
        local vector NewLocation;

        NewLocation = VLerp(Location, FinalLocation, Rate * DeltaTime);
        SetLocation(NewLocation);

        if (VSize(NewLocation - FinalLocation) < 1)
		{
            GoToState(PendingState);
		}
    }
}

state MoveUp extends MoveBase
{
    event BeginState(name PrevState)
    {
        if (PrevState == 'Idle')
            PendingState = 'MoveOver';
        else if (PrevState == 'MoveOver')
            PendingState = 'Idle';

        Rate = (RateOfUpTranslation / MaxUpTranslation) * 4;

        InitialLocation = Location;
        FinalLocation   = InitialLocation + (Inverse*vect(0,0,1) * MaxUpTranslation);
    }

    event EndState(name NextState)
    {
        if (Inverse < 0)
            PlaySound(CloseSound);
    }
}

state MoveOver extends MoveBase
{
    event BeginState(name PrevState)
    {
        local vector Dummy;

        if (PrevState == 'MoveUp')
            PendingState = 'Idle';
        else if (PrevState == 'Idle')
            PendingState = 'MoveUp';

        GetAxes(Rotation, Dir, Dummy, Dummy);

        InitialLocation = Location;
        FinalLocation = InitialLocation + (Inverse*Dir * MaxOverTranslation);

        Rate = (RateOfOverTranslation / MaxOverTranslation) * 4;
    }

    event EndState(name NextState)
    {
        if (Inverse > 0)
            PlaySound(OpenSound);
    }
}

