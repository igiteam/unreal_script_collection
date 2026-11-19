class VehicleFeeler extends Actor
						placeable;



// Time to wait till we try to go again


var int WaitCount;
var SoundCue HonkSound;

function Tick(float dt)
{
	local Pawn P;
	local SVehicle V;

	if (Owner == none)
	{
		Destroy();
		return;
	}

	foreach VisibleCollidingActors(class'Pawn', P, 150, Location, true)
		break;

	if (P == none)
	{
		foreach VisibleCollidingActors(class'SVehicle', V, 150*2.0, Location+(vect(500,0,0) >> Owner.Rotation), true)
			break;
	}

	if (Pawn(Owner).Controller != none && !Pawn(Owner).Controller.IsA('PlayerController'))
	{
		if ( (P != none || V != none) && P!=Owner && V!=Owner) //Kelly added these owner tests to fix tank not moving in dcrd1
		{
			Pawn(Owner).Controller.StopLatentExecution();
			if (!Pawn(Owner).Controller.IsInState('Waiting'))
			{
				Pawn(Owner).Controller.GotoState('Stop');
				SetTimer(5.0f, false);
				Disable('Tick');
				return;
			}
		}
		else
		{
			if (!Pawn(Owner).Controller.IsInState('Waiting'))
				Pawn(Owner).Controller.GotoState('Driving','KeepMovin');
		}
	}
}

function Timer()
{
	local Pawn P;
	local SVehicle V;

	foreach VisibleCollidingActors(class'Pawn', P, 150, Location, true)
		break;

	if (P == none)
	{
		foreach VisibleCollidingActors(class'SVehicle', V, 150*2.0, Location+(vect(500,0,0) >> Owner.Rotation), true)
			break;

		if (V == none)
		{
			WaitCount = 0;
			Enable('Tick');
			return;
		}
		else
		{
			SetTimer(5.0f, false);
		}
	}
	else
	{
		SetTimer(5.0f, false);
	}

	if (WaitCount >= 0 && WaitCount < 2)
	{
		// Play Honk
		Owner.PlaySound(HonkSound,,,true,Owner.Location);
	}

	WaitCount++;
}

