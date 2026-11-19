/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMPlayerInput extends PlayerInput within TMPlayerController
	native;

var float LastDuckTime;
var bool  bHoldDuck;
var Actor.EDoubleClickDir ForcedDoubleClick;

var bool  bDisableIput;

//[TJJ ADD: When command shortcut menu is opened, we will filter the keys from 0 to 9.]
var bool bCommandShortcutMenuOpened;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/**
 * Clears any pending inputs
 */
native function ForceFlushOfInput();

simulated exec function Duck()
{
	if ( TMPawn(Pawn)!= none )
	{
		if (bHoldDuck)
		{
			bHoldDuck=false;
			bDuck=0;
			return;
		}

		bDuck=1;

		if ( WorldInfo.TimeSeconds - LastDuckTime < DoubleClickTime )
		{
			bHoldDuck = true;
		}

		LastDuckTime = WorldInfo.TimeSeconds;
	}
}

simulated exec function UnDuck()
{
	if (!bHoldDuck)
	{
		bDuck=0;
	}
}

exec function Jump()
{
	local TMPawn P;

	if (!IsMoveInputIgnored())
	{
		// jump cancels feign death
		P = TMPawn(Pawn);
		if (P != None && P.bFeigningDeath)
		{
			P.FeignDeath();
		}
		else
		{
		 	if (bDuck>0)
		 	{
		 		bDuck = 0;
		 		bHoldDuck = false;
		 	}
			Super.Jump();
		}
	}
}

event PlayerInput( float DeltaTime )
{
	local vector Dir;
	local float Dist, Ang, Leeway, OffAmount;
	local int Quad, CurrentSel, PrevItem, NextItem, CurrentWeaponIndex;
	local TMHud Hud;
	local array<QuickPickCell> Cells;

	HUD = TMHud(MyHud);
	if ( Hud != none && Hud.bShowQuickPick && (Hud.QuickPickDeltaAngle != 0.0) )
	{
		//@warning: assumption of input scale in DefaultInput.ini
		Dir.X = aTurn;
		Dir.Y = aLookup / 0.75;
		// skew the results a little as the input doesn't entirely give us a normal
		// particularly when pressing near a cardinal direction (could get e.g. X=1.0,Y=0.3)
		if (Dir.X >= 0.99)
		{
			Dir.X -= Abs(Dir.Y);
		}
		else if (Dir.X <= -0.99)
		{
			Dir.X += Abs(Dir.Y);
		}
		else if (Dir.Y >= 0.99)
		{
			Dir.Y -= Abs(Dir.X);
		}
		else if (Dir.Y <= -0.99)
		{
			Dir.Y += Abs(Dir.X);
		}

		Dist = VSize(Dir);
		if (Dist > 0.6)
		{
			Ang = (static.GetHeadingAngle(Normal(Dir)) * 57.2957795) + 90;
			Ang += Hud.QuickPickDeltaAngle * 0.5;

			if (Ang < 0)
			{
				Ang = 360 + Ang;
			}

			Quad = int(Abs(Ang) / Hud.QuickPickDeltaAngle);
			// give some more leeway towards retaining current selection
			CurrentSel = Hud.QuickPickCurrentSelection;
			PrevItem = (Quad == 0) ? (Hud.QuickPickNumCells - 1) : (Quad - 1);
			NextItem = (Quad + 1) % Hud.QuickPickNumCells;
			Leeway = Hud.QuickPickDeltaAngle * 0.20;
			OffAmount = Abs(Ang) % Hud.QuickPickDeltaAngle;
			if ( Hud.bQuickPickMadeNewSelection && CurrentSel != -1 && Quad != CurrentSel &&
				(CurrentSel == NextItem || CurrentSel == PrevItem) )
			{
				if (OffAmount < Leeway || OffAmount > Hud.QuickPickDeltaAngle - Leeway)
				{
					Quad = Hud.QuickPickCurrentSelection;
				}
			}
			else
			{
				if (TMPawn(Pawn) != None)
				{
					TMPawn(Pawn).GetQuickPickCells(Hud, Cells, CurrentWeaponIndex);
				}
//				else if (TMVehicleBase(Pawn) != None)
//				{
//					TMVehicleBase(Pawn).GetQuickPickCells(Hud, Cells, CurrentWeaponIndex);
//				}
				if (Cells.length > 0 && Cells[Quad].Icon == None)
				{
					if (Cells[PrevItem].Icon != None && OffAmount < Leeway)
					{
						Quad = PrevItem;
					}
					else if (Cells[NextItem].Icon != None && OffAmount > Hud.QuickPickDeltaAngle - Leeway)
					{
						Quad = NextItem;
					}
				}
			}

			Hud.QuickPick(Quad);
		}

		aLookup = 0.0;
		aTurn = 0.0;
	}

	Super.PlayerInput(Deltatime);
}

/** Will return the BindName based on the BindCommand */
native function String GetTMBindNameFromCommand( String BindCommand );

/**
 * Process an input key event routed through unrealscript from another object. This method is assigned as the value for the
 * OnRecievedNativeInputKey delegate so that native input events are routed to this unrealscript function.
 *
 * @param	ControllerId	the controller that generated this input key event
 * @param	Key				the name of the key which an event occured for (KEY_Up, KEY_Down, etc.)
 * @param	EventType		the type of event which occured (pressed, released, etc.)
 * @param	AmountDepressed	for analog keys, the depression percent.
 *
 * @return	true to consume the key event, false to pass it on.
 */
function bool InputKey(
	int ControllerId,
	name Key,
	EInputEvent Event,
	float AmountDepressed = 1.f,
	bool bGamepad = FALSE )
{
	local int Value;
	local int Gender;
	local int Character;

	if( string( Key ) == "zero" )
	{
		Value = 0;
	}
	else if( string( Key ) == "one" )
	{
		Value = 1;
	}
	else if( string( Key ) == "two" )
	{
		Value = 2;
	}
	else if( string( Key ) == "three" )
	{
		Value = 3;
	}
	else if( string( Key ) == "four" )
	{
		Value = 4;
	}
	else if( string( Key ) == "five" )
	{
		Value = 5;
	}
	else if( string( Key ) == "six" )
	{
		Value = 6;
	}
	else if( string( Key ) == "seven" )
	{
		Value = 7;
	}
	else if( string( Key ) == "eight" )
	{
		Value = 8;
	}
	else if( string( Key ) == "nine" )
	{
		Value = 9;
	}
	else
	{
		return false;
	}

	Character = TMPlayerReplicationInfo( PlayerReplicationInfo ).Character;
	Gender = ( Character > 3 && Character < 8 ) ? 1 : 0;

	if( bCommandShortcutMenuOpened )
	{
		if( Event == IE_Released )
		{
			ServerTeamSayLocalized(
				class'TMCommandShortcut',
				Value + Gender * 10,
				Outer.PlayerReplicationInfo );
			bCommandShortcutMenuOpened = false;
		}

		return true;
	}

	return false;
}


//[ TJJ ADD: Toggle the HUD menu of command shortcut.]
exec function ToggleCommandShortcutMenu()
{
	if( WorldInfo.NetMode != NM_Standalone )
	{
		bCommandShortcutMenuOpened = !bCommandShortcutMenuOpened;
	}
}

/**
 * Called once a frame to allow the interaction to draw to the canvas
 * @param Canvas Canvas object to draw to
 */
event PostRender(Canvas Canvas)
{
	local int i;
	local Color C;

    if( PlayerReplicationInfo.bIsDead )		return;

    Canvas.Font = Font'HDFont.YaHei';

	if( PlayerReplicationInfo != none
	&& PlayerReplicationInfo.Team != none )
	{
		C = PlayerReplicationInfo.Team.TeamColor;
		Canvas.SetDrawColor( C.R, C.G, C.B );
	}

	if( bCommandShortcutMenuOpened )
	{
		for( i = 0; i < 10; ++i )
		{
			if( class'TMCommandShortcut'.Default.Commands[ i ] != "" )
			{
				Canvas.SetPos( Canvas.SizeX - 150.0, 100.0 + i * 20.0 );
				Canvas.DrawText( i $ ": " $ class'TMCommandShortcut'.Default.Commands[ i ] );
			}
		}
	}
}

