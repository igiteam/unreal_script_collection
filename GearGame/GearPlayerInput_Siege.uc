/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Siege specific player input processing
 */

class GearPlayerInput_Siege extends GearPlayerInput within GearPC_Siege;

protected function AdjustControlBasis( Rotator OldBasis, Rotator NewBasis, out float NewRight, out float NewUp )
{
	local Vector Controls;

	Controls.X	= NewRight;
	Controls.Y	= NewUp;

	Controls = Controls >> Normalize(OldBasis - NewBasis);

	NewRight	= Controls.X;
	NewUp		= Controls.Y;
}

function PostProcessInput(float DeltaTime)
{
	local GearPawn_LocustTickerBase Ticker;
	Ticker = GearPawn_LocustTickerBase(MyGearPawn);
	// force ticker control to be controller-relative rather than pawn-relative
	if ( (Ticker != None) && Ticker.bLockRotation && Ticker.bExplode )
	{
		AdjustControlBasis(Ticker.Rotation, Rotation, aStrafe, aForward);
	}

	super.PostProcessInput(DeltaTime);
}

function HandleButtonInput_LeftTrigger(bool bPressed, optional bool bDblClickMove)
{
	local GearPawn_LocustCorpserLarvaUndergroundBase Corpser;
	Corpser = GearPawn_LocustCorpserLarvaUndergroundBase(MyGearPawn);

	if (Corpser != None)
	{
		if (bPressed)
		{
			Corpser.ServerShieldCorpser(0.f);
			Corpser.ShieldCorpser(0.f);
		}
		else
		{
			Corpser.ServerUnShieldCorpser();
			Corpser.UnShieldCorpser();
		}
	}
	else
	{
		Super.HandleButtonInput_LeftTrigger(bPressed, bDblClickMove);
	}
}


/**
 * Play a sound when the player clicks the left stick
 *
 * @param bIsPressed whether the stick is pressed or released
 * @param bDblClickMove whether it was a dbl click event
 */
function HandleButtonInput_LeftStickButton(bool bIsPressed,optional bool bDblClickMove)
{
	if (bIsPressed && GearPawn_LocustWretchBase(MyGearPawn) == None)
	{
		// Have the server yell for us
		ServerPlayAttackYell();
	}
	Super.HandleButtonInput_LeftStickButton(bIsPressed,bDblClickMove);
}

function HandleButtonInput_A(bool bPressed, optional bool bDblClickMove)
{
	local GearPawn_LocustTickerBase Ticker;
	Ticker = GearPawn_LocustTickerBase(MyGearPawn);

	if (Ticker != None)
	{
		if (bPressed)
		{
			Ticker.TryToCharge();
		}
	}
	else
	{
		Super.HandleButtonInput_A(bPressed, bDblClickMove);
	}
}

function HandleButtonInput_X(bool bPressed, optional bool bDblClickMove)
{
	local GearPawn_LocustWretchBase Wretch;
	local GearPawn_LocustBoomerBase Boomer;
	local GearPawn_LocustTickerBase Ticker;

	// for wretches, so wretch scream
	Wretch = GearPawn_LocustWretchBase(MyGearPawn);
	if (Wretch != None)
	{
		if (bPressed)
		{
			Wretch.PlayAttackYell();
		}
	}
	else
	{
		// for boomers, laugh
		Boomer = GearPawn_LocustBoomerBase(MyGearPawn);
		if (Boomer != None)
		{
			Boomer.PlayAttackChuckle();
		}
		else
		{
			Ticker = GearPawn_LocustTickerBase(MyGearPawn);
			if (Ticker != None)
			{
				if (bPressed && !ClientUse())
				{
					Ticker.ForceChatterSound();
				}
			}
			else
			{
				// fall back to normal handling
				Super.HandleButtonInput_X(bPressed, bDblClickMove);
			}
		}
	}
}

function HandleButtonInput_B(bool bPressed, optional bool bDblClickMove)
{
	local GearPawn_LocustCorpserLarvaUndergroundBase Corpser;

	Corpser = GearPawn_LocustCorpserLarvaUndergroundBase(MyGearPawn);
	// for minicorpser, do melee attack
	if (Corpser != None)
	{
		if (bPressed)
		{
			Corpser.BeastModeStompAttack();
		}
	}
	else
	{
		// fall back to normal handling
		Super.HandleButtonInput_B(bPressed, bDblClickMove);
	}
}

function HandleButtonInput_RightTrigger(bool bPressed, optional bool bDblClickMove)
{
	local GearPawn_LocustCorpserLarvaUndergroundBase Corpser;

	Corpser = GearPawn_LocustCorpserLarvaUndergroundBase(MyGearPawn);
	// for minicorpser, do melee attack
	if (Corpser != None)
	{
		if (bPressed)
		{
			Corpser.BeastModeStompAttack();
		}
	}
	else
	{
		// fall back to normal handling
		Super.HandleButtonInput_RightTrigger(bPressed, bDblClickMove);
	}
}



