//=============================================================================
class GrappleInteraction extends Input
	within GameViewportClient
	transient
	config(game)
	native
	dependson(AnimNotify_ComboButton)
	inherits(FExec);



var TPPlayerController	GrapplePlayer;
var TPWehrmachtAIController	GrappleOpponent; //make this less type-dependent eventually

var bool bMinigameActive;
var bool bPlayerWinning;
var float MinigameTimer;
var float timer;

// @todo Use AnimNotify class!!!  That would be the correct way...
var transient float DamageTimer;

var float PromptTextBrightness;
var int  PromptTextFlashDir;




//`define MAX_MINIGAMES 99


var config float SurpriseSuccessBaseDamage;
var config float ComboGameBaseDamage;
var config float ComboFailBaseDamage;
var config float DefenseStartBaseDamage;
var config float DefenseGameBaseDamage;
var config float DefenseSuccessBaseDamage;
var config float StruggleFailBaseDamage;
var config float StruggleSuccessBaseDamage;

var int MinigameCount;

var bool bGrappleInitialized;


//Defense Game sector stuff
var int RightAnalogStickSector;
var int LeftAnalogStickSector;

var array<int>RightDefenseSectorMap;
var array<int>LeftDefenseSectorMap;

var int RightStickSectorMapState;
var int LeftStickSectorMapState;






var float RightAxisX;
var float RightAxisY;
var float RightAxisAngle;
var float RightAxisMagnitude;

var float LeftAxisX;
var float LeftAxisY;
var float LeftAxisAngle;
var float LeftAxisMagnitude;

var float RightTriggerValue;
var float LeftTriggerValue;

const OuterRingMin = 0.75;


const AngleConvert = 0.0000958738;	// 2*PI/65536

var Texture2D GrapplePromptIcon;


var Texture2D XBOX_A_Button;
var Texture2D XBOX_B_Button;
var Texture2D XBOX_X_Button;
var Texture2D XBOX_Y_Button;
var Texture2D XBOX_DPad;
var Texture2D XBOX_Joystick;


var Texture2D StruggleBar;
var Texture2D StruggleLeftButton;
var Texture2D StruggleRightButton;
var Texture2D StruggleSuperSuccessButton;
var Texture2D StruggleSuccessButton;
var Texture2D StruggleInactiveButton;


//Struggle game stuff
//horizontal margin from left/right edge of screen to struggle bar


//vertical margin from bottom edge of screen to struggle bar




//width of success box


//width of super success box


//distance (percentage of bar width) past center that the sliders can go







var int StruggleResult;
var int ComboResult;
var bool bComboInitialized;
var vector ComboButtonScreenPos;








var SoundCue SuccessSound;
var SoundCue FailSound;

var int forceComboNum; //for animators to test...

//////////////////////////////////////////////////////////

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)



enum GrapplePerformance
{
	GP_CameraIntro,

	GP_Idle,

    GP_GrappleEnemyEnd,
	GP_DisarmSuccess,
	GP_DisarmFail,

	GP_PlayerAdvantage,
	GP_EnemyAdvantage,

	GP_PlayerDeath,
	GP_EnemyDeath,


	GP_Surprise_PlayerAdvantage,
	GP_Surprise_PlayerDisadvantage,
	GP_Surprise_EnemyAdvantage,
	GP_Surprise_EnemyDisadvantage,

	GP_Struggle_PlayerDisarmsEnemy,
	GP_Struggle_EnemyGetsDisarmed,
	GP_Struggle_PlayerLoop,
	GP_Struggle_EnemyLoop,
	GP_Struggle_PlayerHitsEnemyA,
	GP_Struggle_EnemyTakesHitA,
	GP_Struggle_PlayerHitsEnemyB,
	GP_Struggle_EnemyTakesHitB,
	GP_Struggle_EnemyHitsPlayer,
	GP_Struggle_PlayerTakesHit,
	GP_Struggle_PlayerSuperhit,
	GP_Struggle_EnemySuperhit,
	GP_Struggle_PlayerBreakToNeutral,
	GP_Struggle_EnemyBreakToNeutral,
	GP_Struggle_PlayerTransTo,
	GP_Struggle_EnemyTransTo,

//	GP_Combo_PlayerHitsEnemy,
//	GP_Combo_EnemyTakesHit,

	GP_Combo_PlayerLoopA,
	GP_Combo_EnemyLoopA,
	GP_Combo_PlayerLoopB,
	GP_Combo_EnemyLoopB,
	GP_Combo_PlayerLoopC,
	GP_Combo_EnemyLoopC,
	GP_Combo_PlayerLoopD,
	GP_Combo_EnemyLoopD,
	GP_Combo_PlayerLoopE,
	GP_Combo_EnemyLoopE,
	GP_Combo_PlayerLoopF,
	GP_Combo_EnemyLoopF,

	GP_Combo_PlayerAdvantage,
	GP_Combo_PlayerDisadvantage,
	GP_Combo_EnemyAdvantage,
	GP_Combo_EnemyDisadvantage,

	GP_Combo_PlayerComboFail,
	GP_Combo_EnemyComboFail,


	GP_Defense_PlayerTransition,
	GP_Defense_EnemyTransition,

	GP_Defense_PlayerLoop,
	GP_Defense_EnemyLoop,


	GP_Defense_PlayerHitsEnemy,
	GP_Defense_EnemyTakesHit,
};



struct native LiveCombo
{
	var int buttonID;
	var float alpha;
	var float timer;
	var float fadeInTime;
	var float solidTime;
	var float fadeOutTime;
	var int fadeState;
	var int displayIndex;
	var bool bHit;
};

var array<LiveCombo>LiveComboButtons;



native function bool IsPressed( Name InKey );
native function ClearPressedKeys( );



event NotifyDisarmFinished()
{
}
event NotifyAdvantageFinished()
{
}
event NotifySurpriseFinished()
{
}

event NotifyPerformanceFinished(GrapplePerformance Perf)
{
}

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
function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
{
	return false;
}

/**
 * Provides script-only child classes the opportunity to handle input axis events received from the viewport.
 * This delegate is ONLY called when input is being routed natively from the GameViewportClient
 * (i.e. NOT when unrealscript calls the InputKey native unrealscript function on this Interaction).
 *
 * @param	ControllerId	the controller that generated this input axis event
 * @param	Key				the name of the axis that moved  (KEY_MouseX, KEY_XboxTypeS_LeftX, etc.)
 * @param	Delta			the movement delta for the axis
 * @param	DeltaTime		the time (in seconds) since the last axis update.
 * @param	bGamepad		input came from gamepad (ie xbox controller)
 *
 * @return	return TRUE to indicate that the input event was handled.  if the return value is TRUE, the input event will not
 *			be processed by this Interaction's native code.
 */
function bool InputAxis( int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad )
{
	return false;
}

function bool IsActive()
{
	if( IsInState('InActive') )
	{
		return false;
	}
	return true;

}

function PostRender(Canvas Canvas)
{
}

// Enters a grapple through kismet
function ForceGrapple(TPWehrmachtAIController Opponent, TPPlayerController player, bool bEnemyAttackFirst)
{
	if(player != None)
	{
		GrapplePlayer = player;
		GrappleOpponent = Opponent;
	}

	if(bEnemyAttackFirst)
	{
        GotoState('DefenseGame');
	}
	else
	{
        GotoState('ComboGame');
	}
}

function EnablePrompt(TPPlayerController player, TPWehrmachtAIController Opponent)
{
	if(player != None)
	{
		GrapplePlayer = player;
		GrappleOpponent = Opponent;
		GotoState('Prompt');
	}
}

function CancelPrompt()
{

}

function ComboButton(ComboButtonInfo info)
{
}

function MinigameTimerUp()
{
}


//Utility function to put the characters into their grapple states, if necessary
function StartUpGrapple(optional bool Front = true)
{
	if( bGrappleInitialized==false )
	{
		GrapplePlayer.EnterGrapple(self);
		GrappleOpponent.EnterGrapple(self);

		if( GrappleOpponent != None && GrappleOpponent.Pawn != None && GrappleOpponent.Pawn.Health >=1 )
		{
			PositionActors(Front);
		}

		bGrappleInitialized = true;

	    GrapplePlayer.Pawn.TriggerEventClass( class'SeqEvent_IsPlayerGrappling', GrapplePlayer, 0);
	}
}

//Utility function to shut down the grapple
function ShutDownGrapple()
{

	if( bGrappleInitialized==true )
	{
		//if opponent is not dead, send him an event to consider the player a hostile enemy.
		if( GrappleOpponent.Pawn != None && GrappleOpponent.Pawn.Health > 0 )
		{
			GrappleOpponent.OnGrappleFailure(GrapplePlayer);
            GrappleOpponent.Pawn.Weapon.SetHidden(false);

            GrappleOpponent.StartGrapplePerformance(GP_GrappleEnemyEnd);
		}

		GrapplePlayer.ExitGrapple();
	}

	//Clear the pressed keys - otherwise they are still "pressed" the next time we come in here.
	ClearPressedKeys();

	bGrappleInitialized=false;
}

//Utility function to position the actors
function PositionActors(optional bool Front = true)
{
    local vector Direction;

    if (Front)
    {
        Direction = GrapplePlayer.Pawn.Location - GrappleOpponent.Pawn.Location;
        Direction.Z = 0;
        GrappleOpponent.Pawn.SetRotation (rotator(Direction));
        GrappleOpponent.PreserveRotation();

        GrapplePlayer.Pawn.SetRotation(GrappleOpponent.Pawn.Rotation + rot(0,0x8000,0));
        Direction = GrappleOpponent.Pawn.Location;
        Direction += 135 * (vector(GrappleOpponent.Pawn.Rotation));
        GrapplePlayer.Pawn.SetLocation( Direction );
    }
    else // behind/surprise attack
    {
        Direction = GrappleOpponent.Pawn.Location;
        Direction -= 125 * (vector(GrappleOpponent.Pawn.Rotation));

        GrapplePlayer.Pawn.SetLocation( Direction );
	    GrapplePlayer.Pawn.SetRotation( GrappleOpponent.Pawn.Rotation);
    }
}

function BailOut()
{
	GotoState('GrappleEnd');
}

function CheckHealth ( )
{
    if (GrappleOpponent.Pawn == None || GrappleOpponent.Pawn.Health <= 0)
    {
        GotoState('GrappleEnd');
    }

    if (GrapplePlayer.Pawn.Health <= 0)
    {
        GotoState('GrappleEnd');
    }
}

function TakeDamage (float Damage, bool Player)
{
    if (Player)
    {
        GrapplePlayer.Pawn.TakeDamage(Damage,
            None, GrappleOpponent.Pawn.Location, vect(0,0,0), class'TPDamageTypeGrapple' );
    }
    else
    {
        if (GrappleOpponent.Pawn.Health - Damage <= 0)
        {
            // Slin - disabled this for the demo
            //GrapplePlayer.StealUniform( GrappleOpponent);
            GrappleOpponent.Pawn.Weapon.SetHidden(false);
        }

        GrappleOpponent.Pawn.TakeDamage(Damage,
            None, GrappleOpponent.Pawn.Location, vect(0,0,0), class'TPDamageTypeGrapple' );
    }

    CheckHealth ( );
}

state Inactive
{

	function BeginState(name NextStateName)
	{
		MinigameCount=0;

		bGrappleInitialized = false;
	}

    event Tick (float DeltaTime)
    {

    }
}

//Base tick event
event Tick(float DeltaTime)
{
	local float DilatedTime;
	DilatedTime = DeltaTime * GrapplePlayer.WorldInfo.TimeDilation;

	if( PromptTextFlashDir==0 )
	{
		PromptTextBrightness += 4.f* DilatedTime;
		if( PromptTextBrightness > 1.f )
		{
			PromptTextBrightness = 1.f;
			PromptTextFlashDir = 1;
		}
	}
	else
	{
		PromptTextBrightness -= 4.f* DilatedTime;
		if( PromptTextBrightness < 0.f )
		{
			PromptTextBrightness = 0.f;
			PromptTextFlashDir = 0;
		}

	}
}


state Prompt
{
	function PostRender(Canvas Canvas)
	{
//		local int rgb;
		local float ratioX, ratioY;
		local vector promptWorldPos, promptScreenPos;

        if (GrappleOpponent == None || GrappleOpponent.Pawn == None)
        {
            CancelPrompt( );
            return;
        }

		ratioX = Canvas.SizeX / 1024.0;
		ratioY = Canvas.SizeY / 768.0;


//		rgb = `MIN_TEXT_BRIGHTNESS + (PromptTextBrightness * (`MAX_TEXT_BRIGHTNESS - `MIN_TEXT_BRIGHTNESS ));
//		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );
//
//		Canvas.Font = class'Engine'.Static.GetSmallFont();
//
//		Canvas.SetPos(10, 10);
//		Canvas.DrawText("Press Enter/A to Grapple...");

		Canvas.SetDrawColor( 255, 255, 255, 255 );
		promptWorldPos = GrappleOpponent.Pawn.Location;
		promptWorldPos.Z += GrappleOpponent.Pawn.GetCollisionHeight() + (30*ratioY);
		promptScreenPos = Canvas.Project( promptWorldPos );

		if( promptScreenPos.Z >= 0 && promptScreenPos.Z <= 1 && GrapplePlayer.myHud.bShowHUD )
		{
			Canvas.SetPos( promptScreenPos.X, promptScreenPos.Y );
			Canvas.DrawTile( GrapplePromptIcon, GrapplePromptIcon.SizeX* ratioX * 0.5, GrapplePromptIcon.SizeY * ratioY * 0.5, 0, 0, GrapplePromptIcon.SizeX, GrapplePromptIcon.SizeY );

		}
	}
	function CancelPrompt()
	{
		GotoState('Inactive');
	}

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			if(Key == 'Enter' || Key == 'XboxTypeS_A')
			{
				//GotoState('Active'); //old school

				//GotoState('Intro'); //new school
                if(TPPawn(GrappleOpponent.Pawn).IsPlayingPerformance())
                    TPPawn(GrappleOpponent.Pawn).FinishPerformance();

				DetermineEntryPoint(); //newer school
			}
		}

		return false; //do not absorb input
	}






	function bool EnemyJumpedMe()
	{
		//stub
		return false;
	}

	function bool EnemyIsSurpriseable()
	{
		local vector EnemyDir;
		local vector PlayerToEnemyDir;
		local float fDot;


		//Surprise is always available if player is in disguise
		if( GrapplePlayer.IsDisguised() )
			return true;

		//Surprise is never available if enemy is hostile to the player
// 		if( GrappleOpponent.IsHostile( GrapplePlayer ) )
// 			return false;


		EnemyDir = vector(GrappleOpponent.Pawn.Rotation);

		PlayerToEnemyDir =  Normal(GrapplePlayer.Pawn.Location - GrappleOpponent.Pawn.Location);

		fDot = PlayerToEnemyDir dot EnemyDir;


		//stub
		//return false;
		//return true;

		if( fDot < -0.5 ) //standing behind him
			return true;

		return false;
	}


	function DetermineEntryPoint()
	{
/*
        if (GrappleOpponent.IsInState('Grapple'))
        {
            // Enemy is recovering from previous grapple, i.e. picking
            // up his weapon
            GotoState('StruggleStart');
        }
		else if( EnemyIsSurpriseable() )
		{
			//Enemy was surprised
			GotoState('SurpriseGame');
		}
		else if( GrappleOpponent.IsHostile( GrapplePlayer ) )
		{
			//Enemy was alerted
			GotoState('ComboStart');
		}
		else if( EnemyJumpedMe() )
		{
			//Enemy initiated the grapple
			GotoState('DefenseStart');
		}
		else
		{
			GotoState('ComboStart');
		}
*/

		GotoState( 'GrappleChooseAction' );

	}

    event Tick (float DeltaTime)
    {

    }
}

//Base minigame state - handles common things like timer and generic success/fail events
state GrappleMinigame
{
	simulated event BeginState(name PrevStateName)
	{
		timer=0;

		MinigameCount++;

	}

	simulated event EndState(name NextStateName)
	{
	}

	function Success()
	{
	}
	function Fail()
	{
	}


	function MinigameTimerUp()
	{
	}

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad );

		if( Event == IE_Pressed )
		{


			if(Key == 'S')
			{
				Success();
			}
			else if(Key == 'F')
			{
				Fail();
			}
			else if(Key == 'Escape')
			{
				BailOut();
			}
			else if(Key == 'P')
			{
				GrapplePlayer.Pause();
			}

		}

		return true;
	}

	function bool InputAxis( int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad )
	{
		if(Key == 'XboxTypeS_LeftTriggerAxis')
		{
			LeftTriggerValue = Delta;
		}
		else if(Key == 'XboxTypeS_RightTriggerAxis')
		{
			RightTriggerValue = Delta;
		}
		else if(Key=='XboxTypeS_LeftX')
		{
			LeftAxisX = Delta;
		}
		else if(Key=='XboxTypeS_LeftY')
		{
			/* NOTE I AM NEGATING LEFT Y BECAUSE.. it's flipped... why ? */
			LeftAxisY = -Delta;
		}
		else if(Key=='XboxTypeS_RightX')
		{
			RightAxisX = Delta;
		}
		else if(Key=='XboxTypeS_RightY')
		{
			RightAxisY = Delta;
		}


		return false;
	}

	event Tick(float DeltaTime)
	{
		local float DilatedTime;
		DilatedTime = DeltaTime * GrapplePlayer.WorldInfo.TimeDilation;


		timer += DilatedTime;
		if(timer >= MinigameTimer)
		{
			MinigameTimerUp();
		}


		if( IsPressed( 'XboxTypeS_RightThumbstick' ) && IsPressed( 'XboxTypeS_LeftThumbstick' ) )
		{
            //BailOut();
		}


		super.Tick(DeltaTime);
	}


}

//Base minigame transition state - purpose is to capture input
state GrappleMinigameTransition
{
	function bool InputAxis( int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad )
	{
		return true;
	}
	
	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			if(Key == 'P')
			{
				GrapplePlayer.Pause();
			}
			else if(Key == 'Escape')
			{
				BailOut();
			}

		}

		return true;
	}


	event Tick(float DeltaTime)
	{
		if( IsPressed( 'XboxTypeS_RightThumbstick' ) && IsPressed( 'XboxTypeS_LeftThumbstick' ) )
		{
			BailOut();
		}

		super.Tick(DeltaTime);
	}

}

//Utility function to determine which sector the sticks are in
function GetStickSectors()
{
	RightAxisAngle = atan( RightAxisY, RightAxisX )/AngleConvert;
	if(RightAxisAngle < 0)
		RightAxisAngle += 65536;

	RightAxisMagnitude = sqrt( (RightAxisX*RightAxisX) + (RightAxisY*RightAxisY) );

	RightAnalogStickSector = RightAxisAngle / 32768; //8192;
	if( RightAxisMagnitude < OuterRingMin )
	    RightAnalogStickSector += 2;
    //	RightAnalogStickSector += 8;

	LeftAxisAngle = atan( LeftAxisY, LeftAxisX )/AngleConvert;
	if(LeftAxisAngle < 0)
		LeftAxisAngle += 65536;

	LeftAxisMagnitude = sqrt( (LeftAxisX*LeftAxisX) + (LeftAxisY*LeftAxisY) );

	LeftAnalogStickSector = LeftAxisAngle / 32768; //8192;
	if( LeftAxisMagnitude < OuterRingMin )
	    LeftAnalogStickSector += 2;
    //	LeftAnalogStickSector += 8;


	//`log(self @ "Left sector=" @ LeftAnalogStickSector @ "Right sector=" @ RightAnalogStickSector);
	//`log("Left XY=" @ LeftAxisX @ LeftAxisY @ "RightXY=" @ RightAxisX @ RightAxisY);
}






//************************ - BEGIN SECTION - ****************************
// SURPRISE GAME
//***********************************************************************

state SurpriseGame extends GrappleMinigame
{
/*
	Flash the button for the duration of the timer.  If you press the button in time, success.  If not, fail.
*/
	simulated event BeginState(name PrevStateName)
	{
		if( MinigameCount >= 4&& !GrappleOpponent.bInfiniteGrapple)
		{
			GotoState('GrappleEnd');
			return;
		}


		MinigameTimer=3.0;

		GrapplePlayer.ResetMovement();

		super.BeginState(PrevStateName);
	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;
		local vector buttonWorldPos, buttonScreenPos;
		local float ratioX, ratioY;

		ratioX = Canvas.SizeX / 1024.0;
		ratioY = Canvas.SizeY / 768.0;


		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );
		Canvas.Font = class'Engine'.Static.GetSmallFont();
		Canvas.SetPos(10, 10);
		Canvas.DrawText("SURPRISE: Press Enter/A to Surprise");


		buttonWorldPos = GrappleOpponent.Pawn.Mesh.GetBoneLocation( 'JO_Head' );
		buttonWorldPos.Z += 50 * ratioY;
		buttonScreenPos = Canvas.Project( buttonWorldPos );

		Canvas.SetPos( buttonScreenPos.X, buttonScreenPos.Y);

		//Canvas.SetPos(`SURPRISE_BUTTON_X, `SURPRISE_BUTTON_Y);

		Canvas.DrawTile( XBOX_A_Button, XBOX_A_Button.SizeX*ratioX, XBOX_A_Button.SizeY*ratioY, 0, 0, XBOX_A_Button.SizeX, XBOX_A_Button.SizeY );

	}


	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			if(Key == 'Enter' || Key == 'XboxTypeS_A')
			{
				Success();
			}
		}

		return false;
	}

	function Success()
	{
		GotoState('SurpriseSuccess');

	}
	function Fail()
	{
		GotoState('SurpriseFail');
	}

	function MinigameTimerUp()
	{
        Fail();
	}

}


state SurpriseSuccess extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		GrapplePlayer.Pawn.PlaySound(SuccessSound);

		StartUpGrapple(false);

		//We are disarming and hitting the enemy.
		GrapplePlayer.StartGrapplePerformance(GP_Surprise_PlayerAdvantage);
		GrappleOpponent.StartGrapplePerformance(GP_Surprise_EnemyDisadvantage);

        DamageTimer = 0;

		super.BeginState(PrevStateName);
	}

	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Surprise_PlayerAdvantage || perf==GP_Surprise_EnemyDisadvantage)
		{
			//GrappleOpponent.Pawn.Weapon.PutDownWeapon();
            GrappleOpponent.Pawn.Weapon.SetHidden(true);

			GotoState('StruggleStart');
		}
	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Surprise succeeded...");

	}

    event Tick (float DeltaTime)
    {
        DamageTimer += DeltaTime;

        if (DamageTimer > 0.8f)
        {
            TakeDamage (SurpriseSuccessBaseDamage, false);
            DamageTimer = -99.9f;
        }

        super.Tick (DeltaTime);
    }

}



state SurpriseFail extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		GrapplePlayer.Pawn.PlaySound(FailSound);

		StartUpGrapple();

		GrapplePlayer.StartGrapplePerformance(GP_Surprise_PlayerDisadvantage);
		GrappleOpponent.StartGrapplePerformance(GP_Surprise_EnemyAdvantage);


		super.BeginState(PrevStateName);
	}


	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Surprise_PlayerDisadvantage || perf==GP_Surprise_EnemyAdvantage)
		{
			//GrappleOpponent.Pawn.Weapon.PutDownWeapon();
            GrappleOpponent.Pawn.Weapon.SetHidden(true);

			GotoState('ComboGame');

		}
	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Surprise failed...");

	}

}

//************************ - END SECTION - ****************************
// SURPRISE GAME
//***********************************************************************




//************************ - BEGIN SECTION - ****************************
// STRUGGLE GAME
//***********************************************************************

state StruggleStart extends GrappleMinigameTransition
{


	simulated event BeginState(name PrevStateName)
	{
		if( MinigameCount >= 4&& !GrappleOpponent.bInfiniteGrapple)
		{
			GotoState('GrappleEnd');
			return;
		}


		StartUpGrapple();

		GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerTransTo);
		GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyTransTo);

		super.BeginState(PrevStateName);
	}
	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Struggle_PlayerTransTo || perf==GP_Struggle_EnemyTransTo )
		{
			GotoState('StruggleGame');
		}

	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Transitioning to struggle...");

	}

}

state StruggleGame extends GrappleMinigame
{
	simulated event BeginState(name PrevStateName)
	{
		if( MinigameCount >= 4&& !GrappleOpponent.bInfiniteGrapple)
		{
			GotoState('GrappleEnd');
			return;
		}

		MinigameTimer=4.0;

		StartUpGrapple();

		GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerLoop);
		GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyLoop);

		super.BeginState(PrevStateName);
	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;

		local float leftMinX, leftMaxX, leftSliderX, leftSliderY;
		local float rightMinX, rightMaxX, rightSliderX, rightSliderY;
		local float successMinX, successMaxX;
		local float superSuccessMinX, superSuccessMaxX;


		local float struggleBarX, struggleBarY, struggleBarW, struggleBarH;
		local float ratioX, ratioY;

		local float buttonX, buttonY;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("STRUGGLE: Use Left and Right triggers to adjust sliders.  Or press S to Succeed, F to fail");




		///////////////////////////////////////

		ratioX = Canvas.SizeX / 1024.0;
		ratioY = Canvas.SizeY / 768.0;

		struggleBarW = (StruggleBar.SizeX - (30*2)) * ratioX;
		struggleBarH = StruggleBar.SizeY * ratioY;

		struggleBarX = (30* ratioX);
		struggleBarY = Canvas.SizeY - (50* ratioY) - struggleBarH;



		leftMinX = 0;
		leftMaxX = (struggleBarW/2) + (struggleBarW * 0.2* ratioX );
		leftSliderX = leftMinX + ((leftMaxX - leftMinX) * LeftTriggerValue);
		leftSliderY = 55*ratioY;

		rightMinX = (struggleBarW/2) - (struggleBarW * 0.2* ratioX );
		rightMaxX = struggleBarW;
		rightSliderX = rightMinX + ((rightMaxX - rightMinX) * (1.f-RightTriggerValue) ) - (StruggleRightButton.SizeX * ratioX) ;
		rightSliderY = 55*ratioY;




		successMinX = (struggleBarW/2) - ((215*ratioX) / 2);
		successMaxX = successMinX + (215*ratioX);

		superSuccessMinX = (struggleBarW/2) - ((61*ratioX) / 2);
		superSuccessMaxX = superSuccessMinX + (61*ratioX);


		StruggleResult = 0;
		if( leftSliderX >= successMinX && leftSliderX <= successMaxX )
		{
			//`log("left is in normal range");

			if( leftSliderX >= superSuccessMinX && leftSliderX <= superSuccessMaxX )
			{
				//`log("   left is in super range range");

				if( rightSliderX+((StruggleRightButton.SizeX * ratioX)) >= superSuccessMinX && rightSliderX+((StruggleRightButton.SizeX * ratioX)) <= superSuccessMaxX )
				{
					//`log(self @ "super range!");
					StruggleResult = 2;
				}
				else
				{
					//`log("      but right is not in super range");
				}
			}

			if( StruggleResult==0 )
			{
				if( rightSliderX+((StruggleRightButton.SizeX * ratioX)) >= successMinX && rightSliderX+((StruggleRightButton.SizeX * ratioX)) <= successMaxX )
				{
					//`log(self @ "normal range!");
					StruggleResult = 1;
				}
				else
				{
					//`log("      but right is not in normal range");
				}

			}
		}




		buttonX = (struggleBarW/2) - (StruggleInactiveButton.SizeX/2)*ratioX;
		buttonY = 0*ratioY;



		Canvas.SetOrigin( struggleBarX, struggleBarY );
		Canvas.SetDrawColor(255,255,255,255);

		//draw struggle bar
		Canvas.SetPos( 0, 0);
		Canvas.DrawTile( StruggleBar, struggleBarW, struggleBarH, 0, 0, StruggleBar.SizeX, StruggleBar.SizeY );

		//draw left slider
		Canvas.SetPos( leftSliderX, leftSliderY );
		Canvas.DrawTile( StruggleLeftButton, StruggleLeftButton.SizeX * ratioX, StruggleLeftButton.SizeY * ratioY, 0, 0, StruggleLeftButton.SizeX, StruggleLeftButton.SizeY );

		//draw right slider
		Canvas.SetPos( rightSliderX, rightSliderY );
		Canvas.DrawTile( StruggleRightButton, StruggleRightButton.SizeX * ratioX, StruggleRightButton.SizeY * ratioY, 0, 0, StruggleRightButton.SizeX, StruggleRightButton.SizeY );

		//draw active/inactive button
		Canvas.SetPos( buttonX, buttonY );
		if( StruggleResult == 0 )
			Canvas.DrawTile( StruggleInactiveButton, StruggleInactiveButton.SizeX * ratioX, StruggleInactiveButton.SizeY * ratioY, 0, 0, StruggleInactiveButton.SizeX, StruggleInactiveButton.SizeY );
		else if( StruggleResult == 1 )
			Canvas.DrawTile( StruggleSuccessButton, StruggleSuccessButton.SizeX * ratioX, StruggleSuccessButton.SizeY * ratioY, 0, 0, StruggleSuccessButton.SizeX, StruggleSuccessButton.SizeY );
		else
			Canvas.DrawTile( StruggleSuperSuccessButton, StruggleSuperSuccessButton.SizeX * ratioX, StruggleSuperSuccessButton.SizeY * ratioY, 0, 0, StruggleSuperSuccessButton.SizeX, StruggleSuperSuccessButton.SizeY );


		Canvas.SetOrigin( 0,0 ); //reset

	}

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			if(Key == 'Enter' || Key == 'XboxTypeS_A')
			{
				//Do hit or super hit depending on slider positions HERE
				if( StruggleResult == 1 )
				{
					//normal win
					GotoState('StruggleSuccess');
				}
				else if(StruggleResult == 2 )
				{
					//super win
					GotoState('StruggleWinMove');
				}
				else
				{
					//fail
					GotoState('StruggleFail');
				}

			}
		}

		return false;
	}

	function Success()
	{
		//temp for keyboard input
		GotoState('StruggleSuccess');
	}
	function Fail()
	{
		//temp for keyboard input
		GotoState('StruggleFail');
	}

	function MinigameTimerUp()
	{
		Fail();
	}


	event Tick(float DeltaTime)
	{


		super.Tick(DeltaTime);
	}

}

state StruggleSuccess extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		GrapplePlayer.Pawn.PlaySound(SuccessSound);

        if (rand (2) > 0)
        {
    		GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerHitsEnemyB);
	    	GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyTakesHitB);
        }
        else
        {
    		GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerHitsEnemyA);
	    	GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyTakesHitA);
        }

        DamageTimer = 0;
	}

	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Struggle_PlayerHitsEnemyA || perf==GP_Struggle_EnemyTakesHitA ||
            perf==GP_Struggle_PlayerHitsEnemyB || perf==GP_Struggle_EnemyTakesHitB)
		{
			GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerBreakToNeutral);
			GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyBreakToNeutral);

		}
		else if( perf==GP_Struggle_PlayerBreakToNeutral || perf==GP_Struggle_EnemyBreakToNeutral )
		{
			GotoState('ComboGame');
		}

	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;
		//Canvas.SetDrawColor(255, 255, 255, 255);

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Struggle succeeded...");

	}

    event Tick(float DeltaTime)
    {
        DamageTimer += DeltaTime;
        if (DamageTimer > 0.5f)
        {
            TakeDamage (StruggleSuccessBaseDamage, false);
            DamageTimer = -99.9f;
        }
    }
}

state StruggleWinMove extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		GrapplePlayer.Pawn.PlaySound(SuccessSound);

		//play super success anims here

		if( rand(2) > 0 )
		{
			GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerSuperhit);
			GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemySuperhit);
		}
		else
		{
			GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerAdvantage);
			GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyDisadvantage);

		}

	}

	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Struggle_PlayerSuperhit || perf==GP_Struggle_EnemySuperhit || perf==GP_Combo_PlayerAdvantage || perf==GP_Combo_EnemyDisadvantage)
		{
			//after super success enemy should die.
			KillEnemy();

			GotoState('GrappleEnd');
		}
	}


	function KillEnemy()
	{
        GrappleOpponent.Pawn.Weapon.SetHidden(false);
		//Player takes enemy's uniform if it's better
		// Slin - disabled this for the demo
		//GrapplePlayer.StealUniform( GrappleOpponent);

		//take full damage
		GrappleOpponent.Pawn.TakeDamage( GrappleOpponent.Pawn.Health, None, GrappleOpponent.Pawn.Location, vect(0,0,0), class'TPDamageTypeGrapple' );

	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Struggle super hit succeeded...");

	}

}

state StruggleFail extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		GrapplePlayer.Pawn.PlaySound(FailSound);

		GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerTakesHit);
		GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyHitsPlayer);

        DamageTimer = 0;
	}

	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Struggle_PlayerTakesHit || perf==GP_Struggle_EnemyHitsPlayer)
		{
			GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerBreakToNeutral);
			GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyBreakToNeutral);

		}
		else if( perf==GP_Struggle_PlayerBreakToNeutral || perf==GP_Struggle_EnemyBreakToNeutral )
		{
			GotoState('DefenseStart');
		}
	}


	function PostRender(Canvas Canvas)
	{
		local int rgb;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Struggle failed...");

	}

    event Tick(float DeltaTime)
    {
        DamageTimer += DeltaTime;

        // time of getting punch in animation...will change most likely
        if (DamageTimer > 0.47f)
        {
            TakeDamage (StruggleFailBaseDamage, true);
            DamageTimer = -99.9f; // prevent from entering if statement again
        }
    }
}

//************************ - END SECTION - ****************************
// STRUGGLE GAME
//***********************************************************************



//************************ - BEGIN SECTION - ****************************
// COMBO GAME
//***********************************************************************

state ComboStart extends GrappleMinigameTransition
{

	simulated event BeginState(name PrevStateName)
	{
		if( MinigameCount >= 4&& !GrappleOpponent.bInfiniteGrapple)
		{
			GotoState('GrappleEnd');
			return;
		}

		StartUpGrapple();

		//using the surprise performance as the disarm...
//		GrapplePlayer.StartGrapplePerformance(GP_Surprise_PlayerAdvantage);
//		GrappleOpponent.StartGrapplePerformance(GP_Surprise_EnemyDisadvantage);

		GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerDisarmsEnemy);
		GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyGetsDisarmed);

		super.BeginState(PrevStateName);
	}
	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Struggle_PlayerDisarmsEnemy || perf==GP_Struggle_EnemyGetsDisarmed )
		{
			//GrappleOpponent.Pawn.Weapon.PutDownWeapon();
            GrappleOpponent.Pawn.Weapon.SetHidden(true);

			GotoState('ComboGame');
		}

	}


	function PostRender(Canvas Canvas)
	{
		local int rgb;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Transitioning to Combo...");

	}
}

state ComboGame extends GrappleMinigame
{
	simulated event BeginState(name PrevStateName)
	{
		local int comboNum;

		if( MinigameCount >= 4&& !GrappleOpponent.bInfiniteGrapple)
		{
			GotoState('GrappleEnd');
			return;
		}

		ComboResult = 1; //start in success.. will be set to fail if we miss a button.

		bComboInitialized=false;

		StartUpGrapple();

//        if (rand(2) > 0)
//        {
//		    GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerLoopB);
//		    GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyLoopB);
//        }
//        else
//        {
//		    GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerLoopA);
//		    GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyLoopA);
//        }

//		GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerLoopC);
//		GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyLoopC);

		if( forceComboNum != -1 )
			comboNum = forceComboNum;
		else
			comboNum = rand(6);

		;
		switch(comboNum)
		{
			case 0:
				GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerLoopA);
				GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyLoopA);
				break;
			case 1:
				GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerLoopB);
				GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyLoopB);
				break;
			case 2:
				GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerLoopC);
				GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyLoopC);
				break;
			case 3:
				GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerLoopD);
				GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyLoopD);
				break;
			case 4:
				GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerLoopE);
				GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyLoopE);
				break;
			case 5:
				GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerLoopF);
				GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyLoopF);
				break;
		}

		super.BeginState(PrevStateName);
	}

	simulated event EndState(name NextStateName)
	{
		//make sure all the live buttons are killed
		LiveComboButtons.Length = 0;
	}

	function TestRemainingButtons()
	{
		local int i;

		for(i=0; i<LiveComboButtons.Length; i++)
		{
			if( LiveComboButtons[i].bHit==false)
			{
				//`log(self @ "button" @ LiveComboButtons[i].buttonID @ "registering a FAIL");
				ComboResult = 0;
			}
		}

		//remove them
		LiveComboButtons.Length = 0;


	}

	//This will fire when we get an anim notify
	function ComboButton(ComboButtonInfo info)
	{
//		local int i;
		local int displayIndex;
//		local vector buttonWorldPos;

		//`log(self @ "got the combobutton notify" @ info.ButtonID);


		if( LiveComboButtons.Length < 6)
		{
			displayIndex = LiveComboButtons.Length;

			LiveComboButtons.Insert(0,1);

			LiveComboButtons[0].buttonID = info.ButtonID;
//			LiveComboButtons[0].BoneName = info.BoneName;


			LiveComboButtons[0].alpha = 0.f;
			LiveComboButtons[0].timer = 0.f;
			LiveComboButtons[0].fadeState = 0;

			LiveComboButtons[0].fadeInTime = info.fadeInTime;
			LiveComboButtons[0].solidTime = info.solidTime;
			LiveComboButtons[0].fadeOutTime = info.fadeOutTime;

			LiveComboButtons[0].displayIndex = displayIndex;

			LiveComboButtons[0].bHit = false;


		}

	}


	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			if(Key == 'XboxTypeS_A' || Key == 'XboxTypeS_B' || Key == 'XboxTypeS_X' || Key == 'XboxTypeS_Y')
			{
				ComboButtonCheck(Key);
			}
		}

		return false;
	}

	function ComboButtonCheck(name Key)
	{
		local ComboButtonID button;
		local int i;
		local bool bFound;

		if( Key=='XboxTypeS_A' )
			button = ComboButton_XBOX_A;
		else if( Key=='XboxTypeS_B' )
			button = ComboButton_XBOX_B;
		else if( Key=='XboxTypeS_X' )
			button = ComboButton_XBOX_X;
		else if( Key=='XboxTypeS_Y' )
			button = ComboButton_XBOX_Y;
		else
			return;

		//Are there any live buttons in solid state of this type?
		bFound = false;
		for(i=0; i<LiveComboButtons.Length; i++)
		{
			if( LiveComboButtons[i].buttonID == button && LiveComboButtons[i].alpha > 0.9f&& LiveComboButtons[i].bHit==false)
			{
				GrapplePlayer.Pawn.PlaySound(SuccessSound);

				LiveComboButtons[i].bHit = true;

                TakeDamage (ComboGameBaseDamage, false);

				bFound = true;
				break;
			}
		}

		if( bFound==false )
		{
			GrapplePlayer.Pawn.PlaySound(FailSound);

			;
		}
	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;
		local int i;
		local int alpha;
		local vector buttonWorldPos/*, buttonScreenPos*/;

		local float ratioX, ratioY;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );
		Canvas.Font = class'Engine'.Static.GetSmallFont();
		Canvas.SetPos(10, 10);
		Canvas.DrawText("COMBO: Hit the buttons when they have faded in.  Or press S to Succeed, F to fail");

		ratioX = Canvas.SizeX / 1024.0;
		ratioY = Canvas.SizeY / 768.0;


		for(i=0; i<LiveComboButtons.Length; i++)
		{
//			alpha = 255 * LiveComboButtons[i].timer;
//			if(alpha > 255)
//				alpha = 255;
			alpha = LiveComboButtons[i].alpha * 255;
			Canvas.SetDrawColor(255,255,255, alpha);


			if( bComboInitialized==false )
			{
				//capture the world pos only the first time we render, then use this pos for the rest of the minigame

				buttonWorldPos = GrappleOpponent.Pawn.Mesh.GetBoneLocation( 'JO_Head' );
				buttonWorldPos.Z += 30 * ratioX;
				ComboButtonScreenPos = Canvas.Project( buttonWorldPos );

				bComboInitialized = true;
			}

			//Canvas.SetPos( 10 + (50 * i), 300);

			//buttonWorldPos = GrappleOpponent.Pawn.Mesh.GetBoneLocation( LiveComboButtons[i].BoneName ); //opt use socketname if desired
//			buttonWorldPos = GrappleOpponent.Pawn.Mesh.GetBoneLocation( 'JO_Head' );
//
//			buttonScreenPos = Canvas.Project( buttonWorldPos );
//
//			buttonScreenPos.x += LiveComboButtons[i].displayIndex * 70;

			//Canvas.SetPos( buttonScreenPos.X, buttonScreenPos.Y );

			//using globals
			Canvas.SetPos( ComboButtonScreenPos.X + LiveComboButtons[i].displayIndex * 70 * ratioX, ComboButtonScreenPos.Y );

			switch( LiveComboButtons[i].buttonID )
			{
				case ComboButton_XBOX_A:
					Canvas.DrawTile( XBOX_A_Button, XBOX_A_Button.SizeX*ratioX, XBOX_A_Button.SizeY*ratioY, 0, 0, XBOX_A_Button.SizeX, XBOX_A_Button.SizeY );
					break;
				case ComboButton_XBOX_B:
					Canvas.DrawTile( XBOX_B_Button, XBOX_B_Button.SizeX*ratioX, XBOX_B_Button.SizeY*ratioY, 0, 0, XBOX_B_Button.SizeX, XBOX_B_Button.SizeY );
					break;
				case ComboButton_XBOX_X:
					Canvas.DrawTile( XBOX_X_Button, XBOX_X_Button.SizeX*ratioX, XBOX_X_Button.SizeY*ratioY, 0, 0, XBOX_X_Button.SizeX, XBOX_X_Button.SizeY );
					break;
				case ComboButton_XBOX_Y:
				default:
					Canvas.DrawTile( XBOX_Y_Button, XBOX_Y_Button.SizeX*ratioX, XBOX_Y_Button.SizeY*ratioY, 0, 0, XBOX_Y_Button.SizeX, XBOX_Y_Button.SizeY );
					break;
			}

		}
	}


	event Tick(float DeltaTime)
	{
		local int i;
		local float DilatedTime;

		DilatedTime = DeltaTime * GrapplePlayer.WorldInfo.TimeDilation;

		//`log("tick" @ DeltaTime);

		//process the live buttons
		for(i=0; i<LiveComboButtons.Length; i++)
		{
			//`log("    combo button"  @ i @ "timer=" @ LiveComboButtons[i].timer);


			LiveComboButtons[i].timer += DilatedTime;

			if( LiveComboButtons[i].fadeState == 0)
			{
				//fade in
				LiveComboButtons[i].alpha = LiveComboButtons[i].timer  / LiveComboButtons[i].fadeInTime;


				//clamp the alpha
				if( LiveComboButtons[i].alpha > 1.f )
				{
					LiveComboButtons[i].alpha = 1.f;
				}
				if( LiveComboButtons[i].alpha < 0.f )
				{
					LiveComboButtons[i].alpha = 0.f;
				}

				//check timer
				if( LiveComboButtons[i].timer >= LiveComboButtons[i].fadeInTime )
				{
					LiveComboButtons[i].timer =0.f;
					LiveComboButtons[i].fadeState = 1;
				}

			}
			else if( LiveComboButtons[i].fadeState == 1)
			{
				//solid

				//check timer
				if( LiveComboButtons[i].timer >= LiveComboButtons[i].solidTime )
				{
					LiveComboButtons[i].timer =0.f;
					LiveComboButtons[i].fadeState = 2;
				}

			}
			else if( LiveComboButtons[i].fadeState == 2)
			{
				//fade out
				//LiveComboButtons[i].alpha -= DilatedTime * `COMBO_BUTTON_FADE_SPEED;
				//LiveComboButtons[i].alpha += DilatedTime * LiveComboButtons[i].fadeOutTime;
				LiveComboButtons[i].alpha = 1.f - ( LiveComboButtons[i].timer  / LiveComboButtons[i].fadeOutTime );

				//clamp the alpha
				if( LiveComboButtons[i].alpha > 1.f )
				{
					LiveComboButtons[i].alpha = 1.f;
				}
				if( LiveComboButtons[i].alpha < 0.f )
				{
					LiveComboButtons[i].alpha = 0.f;
				}


				//THIS BUTTON IS ON ITS WAY OUT.  If alpha is past the threshold and it has not been hit, we need to register a fail.
				if( LiveComboButtons[i].alpha < 0.9f&& LiveComboButtons[i].bHit==false)
				{
					//`log(self @ "button" @ LiveComboButtons[i].buttonID @ "registering a FAIL");
					ComboResult = 0;

					GrapplePlayer.Pawn.PlaySound(FailSound);
					LiveComboButtons[i].bHit=true; //set this to flag that we have already played the sound
				}


				//check timer
				if( LiveComboButtons[i].timer >= LiveComboButtons[i].fadeOutTime )
				{
					//remove
					LiveComboButtons.Remove(i--, 1);
				}

				if( ComboResult == 0 )
				{
				    GotoState('OpponentComboBlock');
				    return;
				}

			}


		}


		super.Tick(DeltaTime);
	}


	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
//		if( perf==GP_Combo_PlayerLoopA || perf==GP_Combo_EnemyLoopA ||
//            perf==GP_Combo_PlayerLoopB || perf==GP_Combo_EnemyLoopB)

        if( perf>=GP_Combo_PlayerLoopA && perf<=GP_Combo_EnemyLoopF)
		{
			//check if we succeeded or failed here


			TestRemainingButtons();


			if( ComboResult == 1 )
			{
				//GotoState('ComboSuccess');
				GotoState('StruggleStart');
			}
			else
			{
				GotoState('OpponentComboBlock');
				//GotoState('DefenseStart');
			}
		}

	}


	function Success()
	{
		ComboResult=1;
	}
	function Fail()
	{
		ComboResult=0;
	}

}

//state ComboSuccess extends GrappleMinigameTransition
//{
//	simulated event BeginState(name PrevStateName)
//	{
//		GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerAdvantage);
//		GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyDisadvantage);
//	}
//
//	event NotifyPerformanceFinished(GrapplePerformance perf)
//	{
//		if( perf==GP_Combo_PlayerAdvantage || perf==GP_Combo_EnemyDisadvantage)
//		{
//			GotoState('StruggleStart');
//		}
//
//	}
//
//}

state OpponentComboBlock extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerComboFail);
		GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyComboFail);
	}
	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Combo_PlayerComboFail || perf==GP_Combo_EnemyComboFail)
		{
			GotoState('ComboFail');
		}

	}
}

state ComboFail extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		GrapplePlayer.StartGrapplePerformance(GP_Combo_PlayerDisadvantage);
		GrappleOpponent.StartGrapplePerformance(GP_Combo_EnemyAdvantage);

        DamageTimer = 0;
	}
	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Combo_PlayerDisadvantage || perf==GP_Combo_EnemyAdvantage)
		{
			GotoState('DefenseStart');
		}

	}

    event Tick(float DeltaTime)
    {

        DamageTimer += DeltaTime;

        // Time of receiving punch in animation...will change most likely
        if (DamageTimer > 0.6f)
        {
            TakeDamage (ComboFailBaseDamage, true);
            DamageTimer = -99.9f; // prevent from entering this statement again
        }

    }

}

//************************ - END SECTION - ****************************
// COMBO GAME
//***********************************************************************




//************************ - BEGIN SECTION - ****************************
// DEFENSE GAME
//***********************************************************************


state DefenseStart extends GrappleMinigameTransition
{
	//play the transition into defense game

	simulated event BeginState(name PrevStateName)
	{
		if( MinigameCount >= 4&& !GrappleOpponent.bInfiniteGrapple)
		{
			GotoState('GrappleEnd');
			return;
		}


		StartUpGrapple();

		GrapplePlayer.StartGrapplePerformance(GP_Defense_PlayerTransition);
		GrappleOpponent.StartGrapplePerformance(GP_Defense_EnemyTransition);

        DamageTimer = 0;

		super.BeginState(PrevStateName);
	}
	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Defense_PlayerTransition || perf==GP_Defense_EnemyTransition )
		{
			GotoState('DefenseGame');
		}

	}


	function PostRender(Canvas Canvas)
	{
		local int rgb;
		//Canvas.SetDrawColor(255, 255, 255, 255);

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Transitioning to Defense...");

	}

    event Tick(float DeltaTime)
    {
        DamageTimer += DeltaTime;

        // Time of taking the hit in animation...most likely to change
        if (DamageTimer > 1.4f)
        {
            TakeDamage (DefenseStartBaseDamage, true);
            DamageTimer = -99.9f; // prevent from entering statement again
        }
    }
}

state DefenseGame extends GrappleMinigame
{
	simulated event BeginState(name PrevStateName)
	{
		if( MinigameCount >= 4)
		{
			GotoState('GrappleEnd');
			return;
		}

		MinigameTimer=3.0;

		StartUpGrapple();

		GrapplePlayer.StartGrapplePerformance(GP_Defense_PlayerLoop);
		GrappleOpponent.StartGrapplePerformance(GP_Defense_EnemyLoop);


		//Init the analog stick sector map
		RightDefenseSectorMap.Length=0;
		RightDefenseSectorMap.Insert(0,2);
		RightDefenseSectorMap[0]=0;
		RightDefenseSectorMap[1]=1;
		//RightDefenseSectorMap[2]=4;
		//RightDefenseSectorMap[3]=5;


		LeftDefenseSectorMap.Length=0;
		LeftDefenseSectorMap.Insert(0,2);
		LeftDefenseSectorMap[0]=0;
		LeftDefenseSectorMap[1]=1;
		//LeftDefenseSectorMap[2]=6;
		//LeftDefenseSectorMap[3]=7;

		RightStickSectorMapState = -1;
		LeftStickSectorMapState = -1;

        DamageTimer = 0;

		super.BeginState(PrevStateName);
	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;
		local Vector2D p0,p1,p2;
		local vector v0,v1,v2,v3;
		local float x,y,w,h;
		local float ratioX, ratioY;

		local rotator arrowRotation;

		ratioX = Canvas.SizeX / 1024.0;
		ratioY = Canvas.SizeY / 768.0;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("DEFENSE: Rotate the analog sticks to match the pattern.  Or press S to Succeed, F to fail");


		//Canvas.SetPos(`DEFENSE_BUTTON_X, `DEFENSE_BUTTON_Y);
		//Canvas.DrawTile( XBOX_Joystick, XBOX_Joystick.SizeX, XBOX_Joystick.SizeY, 0, 0, XBOX_Joystick.SizeX, XBOX_Joystick.SizeY );

		w = (XBOX_Joystick.SizeX/2) * ratioX;
		h = (XBOX_Joystick.SizeY/2) * ratioY;


		x = 20+ w;
		y = 40+ h;

		v0.x =  w;
		v0.y = -h;

		v1.x = -w;
		v1.y = -h;

		v2.x =  w;
		v2.y =  h;

		v3.x = -w;
		v3.y =  h;

		arrowRotation.Yaw = -16384;

		v0 = v0 >> arrowRotation;
		v1 = v1 >> arrowRotation;
		v2 = v2 >> arrowRotation;
		v3 = v3 >> arrowRotation;



		p0.x = v0.x + x; p0.y = v0.y + y;
		p1.x = v1.x + x; p1.y = v1.y + y;
		p2.x = v2.x + x; p2.y = v2.y + y;
		//Canvas.DrawTriangle( XBOX_Joystick, p0, 0, 0, p1, 0, 1, p2, 1, 0 );
		Canvas.DrawTriangle( XBOX_Joystick, p0, 1, 0, p1, 1, 1, p2, 0, 0 ); //flipping in x

		p0.x = v1.x + x; p0.y = v1.y + y;
		p1.x = v2.x + x; p1.y = v2.y + y;
		p2.x = v3.x + x; p2.y = v3.y + y;
		//Canvas.DrawTriangle( XBOX_Joystick, p0, 0, 1, p1, 1, 0, p2, 1, 1 );
		Canvas.DrawTriangle( XBOX_Joystick, p0, 1, 1, p1, 0, 0, p2, 0, 1 ); //flipping in x


/*
		p0.x = `DEFENSE_BUTTON_X;
		p0.y = `DEFENSE_BUTTON_Y;

		p1.x = `DEFENSE_BUTTON_X + XBOX_Joystick.SizeX;
		p1.y = `DEFENSE_BUTTON_Y;

		p2.x = `DEFENSE_BUTTON_X;
		p2.y = `DEFENSE_BUTTON_Y + XBOX_Joystick.SizeY;
		Canvas.DrawTriangle( XBOX_Joystick, p0, 0, 0, p1, 1, 0, p2, 0, 1 );



		p0.x = `DEFENSE_BUTTON_X + XBOX_Joystick.SizeX;
		p0.y = `DEFENSE_BUTTON_Y;

		p1.x = `DEFENSE_BUTTON_X;
		p1.y = `DEFENSE_BUTTON_Y + XBOX_Joystick.SizeY;

		p2.x = `DEFENSE_BUTTON_X + XBOX_Joystick.SizeX;
		p2.y = `DEFENSE_BUTTON_Y + XBOX_Joystick.SizeY;

		Canvas.DrawTriangle( XBOX_Joystick, p0, 1, 0, p1, 0, 1, p2, 1, 1 );
*/


		Canvas.SetPos(20+ (XBOX_Joystick.SizeX + 10) * ratioX, 40);
		Canvas.DrawTile( XBOX_Joystick, XBOX_Joystick.SizeX*ratioX, XBOX_Joystick.SizeY*ratioY, 0, 0, XBOX_Joystick.SizeX, XBOX_Joystick.SizeY );


	}
	function Success()
	{
		GotoState('DefenseSuccess');
	}
	function Fail()
	{
		GotoState('DefenseFail');
	}

	event Tick(float DeltaTime)
	{
		local bool bRightCorrect, bLeftCorrect;

        GetStickSectors();
		bLeftCorrect = false;
		bRightCorrect = false;

		if( RightStickSectorMapState<RightDefenseSectorMap.Length-1 && RightAnalogStickSector == RightDefenseSectorMap[ RightStickSectorMapState + 1 ] )
		{
            //advance the state
			RightStickSectorMapState ++;
		}
	//	else if( RightStickSectorMapState >= 0 && RightAnalogStickSector != RightDefenseSectorMap[ RightStickSectorMapState ] )
	//	{
	//		//not in current state or next state.. revert to start
	//		RightStickSectorMapState = -1;
	//	}

		if( RightStickSectorMapState == RightDefenseSectorMap.Length - 1 )
		{
			//`log("Success");
			//RightStickSectorMapState = -1;
			//Success();
			bRightCorrect = true;
		}



		if( LeftStickSectorMapState<LeftDefenseSectorMap.Length-1 && LeftAnalogStickSector == LeftDefenseSectorMap[ LeftStickSectorMapState + 1 ] )
		{
			//advance the state
			LeftStickSectorMapState ++;
		}
	//	else if( LeftStickSectorMapState >= 0 && LeftAnalogStickSector != LeftDefenseSectorMap[ LeftStickSectorMapState ] )
	//	{
	//		//not in current state or next state.. revert to start
	//		LeftStickSectorMapState = -1;
	//	}

		if( LeftStickSectorMapState == LeftDefenseSectorMap.Length - 1)
		{
			bLeftCorrect = true;
            //`log("Success");
			//LeftStickSectorMapState = -1;
			//Success();

		//	if(bRightCorrect)
		//	{
				//both are correct
		//		Success();
		//	}
		}

	   if(bLeftCorrect && bRightCorrect)
	       Success();

        DamageTimer += DeltaTime;
        // time of getting punched in animation...will change most likely
        if (DamageTimer > 0.53f)
        {
            TakeDamage (DefenseGameBaseDamage, true);
            DamageTimer = 0;
        }

		super.Tick(DeltaTime);
	}


	function MinigameTimerUp()
	{
		Fail();
	}

}

state DefenseSuccess extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		GrapplePlayer.Pawn.PlaySound(SuccessSound);

		GrapplePlayer.StartGrapplePerformance(GP_Defense_PlayerHitsEnemy);
		GrappleOpponent.StartGrapplePerformance(GP_Defense_EnemyTakesHit);

        DamageTimer = 0;

		super.BeginState(PrevStateName);
	}

	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		if( perf==GP_Defense_PlayerHitsEnemy || perf==GP_Defense_EnemyTakesHit )
		{
			GotoState('ComboGame');
		}
	}


	function PostRender(Canvas Canvas)
	{
		local int rgb;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Defense succeeded...");

	}

    event Tick (float DeltaTime)
    {
        DamageTimer += DeltaTime;

        if (DamageTimer > 0.93f)
        {
            TakeDamage (DefenseSuccessBaseDamage, false);
            DamageTimer = -99.9f;
        }
    }
}

state DefenseFail extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		GrapplePlayer.Pawn.PlaySound(FailSound);

		if(GrappleOpponent.bInfiniteGrapple)
		   GotoState('ComboGame');
		else
		GotoState('GrappleEnd');
	}
}

//************************ - END SECTION - ****************************
// COMBO GAME
//***********************************************************************



//************************ - BEGIN SECTION - ****************************
// INSTANT DEATH GAME
//***********************************************************************

state GrappleChooseAction extends GrappleMinigameTransition
{
	simulated event BeginState(name PrevStateName)
	{
		StartUpGrapple();

		//
		// Hide both our and our enemies weapon
		//
		GrappleOpponent.Pawn.Weapon.SetHidden(true);
		GrapplePlayer.Pawn.Weapon.SetHidden(true);

		//
		// I'm not sure which animations we are going to use, but for now I'm going to use these
		// disarm animations.
		//
		GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerDisarmsEnemy);
		GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyGetsDisarmed);

		super.BeginState(PrevStateName);
	}

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if ( Event == IE_Pressed )
		{
			if ( Key == 'XboxTypeS_A' )
				GotoState( 'InstantDeathGame' );

			//
			// There is no human shield, so for now just end the grapple
			//
			else if ( Key == 'XboxTypeS_B' )
				GotoState( 'GrappleEnd' );
		}

		return false;
	}

	//
	// When the animations finish, start them over again.  Repeat until the player presses the correct
	// button to either do a kill or a human shiel.
	//
	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
//		GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerDisarmsEnemy);
//		GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemyGetsDisarmed);

		GotoState( 'GrappleEnd' );
	}


	function PostRender(Canvas Canvas)
	{
		local int rgb;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Transitioning to Combo...");
	}
}

state InstantDeathGame extends GrappleMinigame
{
	simulated event BeginState(name PrevStateName)
	{
		bComboInitialized=false;

		StartUpGrapple();

		GrapplePlayer.StartGrapplePerformance(GP_Struggle_PlayerSuperhit);
		GrappleOpponent.StartGrapplePerformance(GP_Struggle_EnemySuperhit);

		super.BeginState(PrevStateName);
	}

	simulated event EndState(name NextStateName)
	{
		//make sure all the live buttons are killed
		LiveComboButtons.Length = 0;
	}


	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			if(Key == 'XboxTypeS_A' || Key == 'XboxTypeS_B' || Key == 'XboxTypeS_X' || Key == 'XboxTypeS_Y')
			{
				ComboButtonCheck(Key);
			}
		}

		return false;
	}

	function ComboButtonCheck(name Key)
	{
		local ComboButtonID button;
		local int i;
		local bool bFound;

		if( Key=='XboxTypeS_A' )
			button = ComboButton_XBOX_A;
		else if( Key=='XboxTypeS_B' )
			button = ComboButton_XBOX_B;
		else if( Key=='XboxTypeS_X' )
			button = ComboButton_XBOX_X;
		else if( Key=='XboxTypeS_Y' )
			button = ComboButton_XBOX_Y;
		else
			return;

		//Are there any live buttons in solid state of this type?
		bFound = false;
		for(i=0; i<LiveComboButtons.Length; i++)
		{
			if( LiveComboButtons[i].buttonID == button && LiveComboButtons[i].alpha > 0.9f&& LiveComboButtons[i].bHit==false)
			{
				GrapplePlayer.Pawn.PlaySound(SuccessSound);

				LiveComboButtons[i].bHit = true;

                TakeDamage (ComboGameBaseDamage, false);

				bFound = true;
				break;
			}
		}

		if( bFound==false )
		{
			GrapplePlayer.Pawn.PlaySound(FailSound);

			;
		}
	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;
		local int i;
		local int alpha;
		local vector buttonWorldPos/*, buttonScreenPos*/;

		local float ratioX, ratioY;

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );
		Canvas.Font = class'Engine'.Static.GetSmallFont();
		Canvas.SetPos(10, 10);
		Canvas.DrawText("COMBO: Hit the buttons when they have faded in.  Or press S to Succeed, F to fail");

		ratioX = Canvas.SizeX / 1024.0;
		ratioY = Canvas.SizeY / 768.0;


		for(i=0; i<LiveComboButtons.Length; i++)
		{
//			alpha = 255 * LiveComboButtons[i].timer;
//			if(alpha > 255)
//				alpha = 255;
			alpha = LiveComboButtons[i].alpha * 255;
			Canvas.SetDrawColor(255,255,255, alpha);


			if( bComboInitialized==false )
			{
				//capture the world pos only the first time we render, then use this pos for the rest of the minigame

				buttonWorldPos = GrappleOpponent.Pawn.Mesh.GetBoneLocation( 'JO_Head' );
				buttonWorldPos.Z += 30 * ratioX;
				ComboButtonScreenPos = Canvas.Project( buttonWorldPos );

				bComboInitialized = true;
			}

			//Canvas.SetPos( 10 + (50 * i), 300);

			//buttonWorldPos = GrappleOpponent.Pawn.Mesh.GetBoneLocation( LiveComboButtons[i].BoneName ); //opt use socketname if desired
//			buttonWorldPos = GrappleOpponent.Pawn.Mesh.GetBoneLocation( 'JO_Head' );
//
//			buttonScreenPos = Canvas.Project( buttonWorldPos );
//
//			buttonScreenPos.x += LiveComboButtons[i].displayIndex * 70;

			//Canvas.SetPos( buttonScreenPos.X, buttonScreenPos.Y );

			//using globals
			Canvas.SetPos( ComboButtonScreenPos.X + LiveComboButtons[i].displayIndex * 70 * ratioX, ComboButtonScreenPos.Y );

			switch( LiveComboButtons[i].buttonID )
			{
				case ComboButton_XBOX_A:
					Canvas.DrawTile( XBOX_A_Button, XBOX_A_Button.SizeX*ratioX, XBOX_A_Button.SizeY*ratioY, 0, 0, XBOX_A_Button.SizeX, XBOX_A_Button.SizeY );
					break;
				case ComboButton_XBOX_B:
					Canvas.DrawTile( XBOX_B_Button, XBOX_B_Button.SizeX*ratioX, XBOX_B_Button.SizeY*ratioY, 0, 0, XBOX_B_Button.SizeX, XBOX_B_Button.SizeY );
					break;
				case ComboButton_XBOX_X:
					Canvas.DrawTile( XBOX_X_Button, XBOX_X_Button.SizeX*ratioX, XBOX_X_Button.SizeY*ratioY, 0, 0, XBOX_X_Button.SizeX, XBOX_X_Button.SizeY );
					break;
				case ComboButton_XBOX_Y:
				default:
					Canvas.DrawTile( XBOX_Y_Button, XBOX_Y_Button.SizeX*ratioX, XBOX_Y_Button.SizeY*ratioY, 0, 0, XBOX_Y_Button.SizeX, XBOX_Y_Button.SizeY );
					break;
			}

		}
	}


	event Tick(float DeltaTime)
	{
		local int i;
		local float DilatedTime;

		DilatedTime = DeltaTime * GrapplePlayer.WorldInfo.TimeDilation;

		//`log("tick" @ DeltaTime);

		//process the live buttons
		for(i=0; i<LiveComboButtons.Length; i++)
		{
			//`log("    combo button"  @ i @ "timer=" @ LiveComboButtons[i].timer);


			LiveComboButtons[i].timer += DilatedTime;

			if( LiveComboButtons[i].fadeState == 0)
			{
				//fade in
				LiveComboButtons[i].alpha = LiveComboButtons[i].timer  / LiveComboButtons[i].fadeInTime;


				//clamp the alpha
				if( LiveComboButtons[i].alpha > 1.f )
				{
					LiveComboButtons[i].alpha = 1.f;
				}
				if( LiveComboButtons[i].alpha < 0.f )
				{
					LiveComboButtons[i].alpha = 0.f;
				}

				//check timer
				if( LiveComboButtons[i].timer >= LiveComboButtons[i].fadeInTime )
				{
					LiveComboButtons[i].timer =0.f;
					LiveComboButtons[i].fadeState = 1;
				}

			}
			else if( LiveComboButtons[i].fadeState == 1)
			{
				//solid

				//check timer
				if( LiveComboButtons[i].timer >= LiveComboButtons[i].solidTime )
				{
					LiveComboButtons[i].timer =0.f;
					LiveComboButtons[i].fadeState = 2;
				}

			}
			else if( LiveComboButtons[i].fadeState == 2)
			{
				//fade out
				//LiveComboButtons[i].alpha -= DilatedTime * `COMBO_BUTTON_FADE_SPEED;
				//LiveComboButtons[i].alpha += DilatedTime * LiveComboButtons[i].fadeOutTime;
				LiveComboButtons[i].alpha = 1.f - ( LiveComboButtons[i].timer  / LiveComboButtons[i].fadeOutTime );

				//clamp the alpha
				if( LiveComboButtons[i].alpha > 1.f )
				{
					LiveComboButtons[i].alpha = 1.f;
				}
				if( LiveComboButtons[i].alpha < 0.f )
				{
					LiveComboButtons[i].alpha = 0.f;
				}


				//THIS BUTTON IS ON ITS WAY OUT.  If alpha is past the threshold and it has not been hit, we need to register a fail.
				if( LiveComboButtons[i].alpha < 0.9f&& LiveComboButtons[i].bHit==false)
				{
					//`log(self @ "button" @ LiveComboButtons[i].buttonID @ "registering a FAIL");
					ComboResult = 0;

					GrapplePlayer.Pawn.PlaySound(FailSound);
					LiveComboButtons[i].bHit=true; //set this to flag that we have already played the sound
				}


				//check timer
				if( LiveComboButtons[i].timer >= LiveComboButtons[i].fadeOutTime )
				{
					//remove
					LiveComboButtons.Remove(i--, 1);
				}

				if( ComboResult == 0 )
				{
				    GotoState('OpponentComboBlock');
				    return;
				}
			}
		}

		super.Tick(DeltaTime);
	}


	event NotifyPerformanceFinished(GrapplePerformance perf)
	{
		//
		// Kill the enemy
		//
        GrappleOpponent.Pawn.Weapon.SetHidden(false);
		GrappleOpponent.Pawn.TakeDamage( GrappleOpponent.Pawn.Health, None, GrappleOpponent.Pawn.Location, vect(0,0,0), class'TPDamageTypeGrapple' );

		GotoState('GrappleEnd');

	}


	function Success()
	{
		ComboResult=1;
	}
	function Fail()
	{
		ComboResult=0;
	}
}

//************************ - END SECTION - ****************************
// INSTANT DEATH GAME
//***********************************************************************




state GrappleEnd
{
	function BeginState(name whatever)
	{
		//
		// Show both our and our enemies weapon
		//
//		GrappleOpponent.Pawn.Weapon.SetHidden(false);
//		GrapplePlayer.Pawn.Weapon.SetHidden(false);

		ShutDownGrapple();
        GoToState ('InActive');
	}
}



////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

//older version of grapple follows:

state Intro
{
	simulated event BeginState(name PreviousStateName)
	{
		GrapplePlayer.EnterGrapple(self);
		GrappleOpponent.EnterGrapple(self);

		PositionActors();

		GrapplePlayer.StartGrapplePerformance(GP_CameraIntro);

		GotoState('DisarmGame');
	}



}

state DisarmGame
{
	simulated event BeginState(name PreviousStateName)
	{
		timer = 0.f;
		MinigameTimer = 1.5f;
		bMinigameActive = true;

	}

	function Fail()
	{
		GotoState('DisarmFailure');
	}


	function Succeed()
	{
		GotoState('DisarmSuccess');
	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;
		//Canvas.SetDrawColor(255, 255, 255, 255);

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Press Enter/A to Disarm!");

	}

	event Tick(float DeltaTime)
	{
		timer += DeltaTime;
		if(timer >= MinigameTimer)
		{
			if( bMinigameActive )
			{
				bMinigameActive = false;
				Fail();
			}
		}

		super.Tick(DeltaTime);
	}


	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			if(Key == 'Enter' || Key == 'XboxTypeS_A')
			{
				if( bMinigameActive )
				{
					bMinigameActive = false;
					Succeed();
				}
			}

		}

		return true; // absorb input
	}


}


state DisarmSuccess
{
	simulated event BeginState(name PreviousStateName)
	{
		GrapplePlayer.StartGrapplePerformance(GP_DisarmSuccess);
		GrappleOpponent.StartGrapplePerformance(GP_DisarmSuccess);

		//Enemy will take damage here

	}

	event NotifyDisarmFinished()
	{
		GotoState('Struggle');

	}


	function PostRender(Canvas Canvas)
	{
		Canvas.SetDrawColor(255, 255, 255, 255);

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Enemy successfully disarmed");

	}


}


state DisarmFailure
{
	simulated event BeginState(name PreviousStateName)
	{
		GrapplePlayer.StartGrapplePerformance(GP_DisarmFail);
		GrappleOpponent.StartGrapplePerformance(GP_DisarmFail);


		//Player will take damage here
	}

	event NotifyDisarmFinished()
	{
		GotoState('Struggle');

	}

	function PostRender(Canvas Canvas)
	{
		Canvas.SetDrawColor(255, 255, 255, 255);

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Failed to disarm");

	}

}


state Struggle
{

	simulated event BeginState(name PreviousStateName)
	{
		timer = 0.f;
		MinigameTimer = 1.0f;
		bMinigameActive = true;

		GrapplePlayer.StartGrapplePerformance(GP_Idle);
		GrappleOpponent.StartGrapplePerformance(GP_Idle);

	}

	function Fail()
	{
		GotoState('PlayerDeath');
	}


	function Succeed()
	{
		GotoState('EnemyDeath');
	}

	function PostRender(Canvas Canvas)
	{
		local int rgb;
		//Canvas.SetDrawColor(255, 255, 255, 255);

		rgb = 80+ (PromptTextBrightness * (255- 80));
		Canvas.SetDrawColor( rgb, rgb, rgb, 255 );

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Press Enter/A to Fight!");

	}

	event Tick(float DeltaTime)
	{
		timer += DeltaTime;
		if(timer >= MinigameTimer)
		{
			if( bMinigameActive )
			{
				bMinigameActive = false;
				Fail();
			}
		}

		super.Tick(DeltaTime);
	}


	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			if(Key == 'Enter' || Key == 'XboxTypeS_A')
			{
				if( bMinigameActive )
				{
					bMinigameActive = false;
					Succeed();
				}
			}

		}

		return true; // absorb input
	}



}

state PlayerDeath
{
	simulated event BeginState(name PreviousStateName)
	{
		GrapplePlayer.StartGrapplePerformance(GP_EnemyAdvantage);
		GrappleOpponent.StartGrapplePerformance(GP_EnemyAdvantage);


	}

	function End()
	{
		GrapplePlayer.ExitGrapple();
		GrappleOpponent.ExitGrapple();

		//Player will take damage/die here
		GrapplePlayer.Pawn.TakeDamage( GrapplePlayer.Pawn.Health * 0.5f, None, GrapplePlayer.Pawn.Location, vect(0,0,0), class'TPDamageTypeGrapple' );


		GotoState('Inactive');
	}


	event NotifyAdvantageFinished()
	{
		End();
	}


	function PostRender(Canvas Canvas)
	{
		Canvas.SetDrawColor(255, 255, 255, 255);

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Grapple failed");

	}

}

state EnemyDeath
{
	simulated event BeginState(name PreviousStateName)
	{
		GrapplePlayer.StartGrapplePerformance(GP_PlayerAdvantage);
		GrappleOpponent.StartGrapplePerformance(GP_PlayerAdvantage);


	}

	function End()
	{
		GrapplePlayer.ExitGrapple();
		GrappleOpponent.ExitGrapple();


		//Player takes enemy's uniform if it's better
		// Slin - disabled this for the demo
        //GrapplePlayer.StealUniform( GrappleOpponent);


		//take full damage
		GrappleOpponent.Pawn.TakeDamage( GrappleOpponent.Pawn.Health, None, GrappleOpponent.Pawn.Location, vect(0,0,0), class'TPDamageTypeGrapple' );


		GotoState('Inactive');
	}

	event NotifyAdvantageFinished()
	{
		End();
	}


	function PostRender(Canvas Canvas)
	{
		Canvas.SetDrawColor(255, 255, 255, 255);

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Grapple successful");

	}

}


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

state Active
{
	simulated event BeginState(name PreviousStateName)
	{
		GrapplePlayer.EnterGrapple(self);
		GrappleOpponent.EnterGrapple(self);

		PositionActors();

		//GotoState('Engage');
		GotoState('Minigame');
	}


	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			//`log("grapple active state key=" @ Key);

			if(Key == 'SpaceBar')
			{
				GrapplePlayer.ExitGrapple();
				GrappleOpponent.ExitGrapple();

				GotoState('InActive');
			}
		}

		return true; // absorb input
	}

	function PostRender(Canvas Canvas)
	{
		Canvas.SetDrawColor(255, 255, 255, 255);

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);
		Canvas.DrawText("Grapple Active");

	}

}



state Minigame extends Active
{
	simulated event BeginState(name PreviousStateName)
	{
		GrappleOpponent.StartGrapplePerformance(GP_DisarmSuccess);
		GrapplePlayer.StartGrapplePerformance(GP_DisarmSuccess);

		bPlayerWinning = false;

		timer = 0.f;
		MinigameTimer = 3.f;

		bMinigameActive = true;
	}

	function PlayAdvantagePerformance()
	{
		if( bPlayerWinning )
		{
			GrappleOpponent.StartGrapplePerformance(GP_PlayerAdvantage);
			GrapplePlayer.StartGrapplePerformance(GP_PlayerAdvantage);
		}
		else
		{
			GrappleOpponent.StartGrapplePerformance(GP_EnemyAdvantage);
			GrapplePlayer.StartGrapplePerformance(GP_EnemyAdvantage);
		}
	}

	event NotifyAdvantageFinished()
	{
		GrapplePlayer.ExitGrapple();
		GrappleOpponent.ExitGrapple();

		GotoState('InActive');

	}

	function PostRender(Canvas Canvas)
	{
		Canvas.SetDrawColor(255, 255, 255, 255);

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos(10, 10);

		if( timer < MinigameTimer )
		{
			Canvas.DrawText("Press A!");
		}
		else if( bPlayerWinning )
		{
			Canvas.DrawText("You win!");
		}
		else
		{
			Canvas.DrawText("You lose!");
		}

	}

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			if(Key == 'A' || Key == 'XboxTypeS_A')
			{
				if( bMinigameActive )
					bPlayerWinning = true;
			}

			else if(Key == 'SpaceBar')
			{
				if( bMinigameActive==false )
				{
					GrapplePlayer.ExitGrapple();
					GrappleOpponent.ExitGrapple();

					GotoState('InActive');
				}

			}
		}

		return true; // absorb input
	}


	event Tick(float DeltaTime)
	{
		timer += DeltaTime;
		if(timer >= MinigameTimer)
		{
			if(bMinigameActive)
			{
				bMinigameActive = false;
				PlayAdvantagePerformance();
			}
		}

		super.Tick(DeltaTime);
	}

}

state Engage extends Active
{
//	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
//	{
//		if( bExpectGameInput==false )
//			return super.InputKey( ControllerId, Key, Event, AmountDepressed );
//	}
//
//	function PostRender(Canvas Canvas)
//	{
//		if( bExpectGameInput == false )
//		{
//			Super.PostRender(Canvas);
//			return;
//		}
//
//		Canvas.SetDrawColor(255, 255, 255, 255);
//
//		Canvas.Font = class'Engine'.Static.GetSmallFont();
//
//		Canvas.SetPos(10, 10);
//		Canvas.DrawText("Minigame");
//
//	}

	event NotifyDisarmFinished()
	{
		//GetAtom();

		GotoState('Grappling');
	}

	simulated event BeginState(name PreviousStateName)
	{
		PositionActors();

		GrappleOpponent.StartGrapplePerformance(GP_DisarmSuccess);

//		TPPawn(GrappleOpponent.Pawn).KickOffSceneAnimation();
//		GetAtom();

		GrapplePlayer.StartGrapplePerformance(GP_DisarmSuccess);

		//Sleep(0.1);

		//SetTimer(1.0f, false, 'StartMinigame');

	}

//	function StartMinigame()
//	{
//		bExpectGameInput = true;
//	}

	function GetAtom()
	{
//		local TPAnimSceneTemplateNode sceneNode;
//		local BoneAtom atom;
//
//
//		sceneNode = TPPawn(GrappleOpponent.Pawn).GetSceneTemplateNode();
//		atom = sceneNode.GetBoneAtomAtTime('JO_Prop', 0.0 );
//
//		`log("got atom loc" @ atom.Translation @ "Pawn loc=" @ GrappleOpponent.Pawn.Location);
//
//
//		GrappleOpponent.DrawDebugCoordinateSystem( atom.Translation+GrappleOpponent.Pawn.Location, QuatToRotator(atom.Rotation), 5.0, true );
//
//		//Note that the atom will be relative to parent bone


		local vector Loc;
		local rotator Rot;
		Loc = GrappleOpponent.Pawn.Mesh.GetBoneLocation('JO_Prop');
		Rot = QuatToRotator(GrappleOpponent.Pawn.Mesh.GetBoneQuaternion('JO_Prop'));

		GrappleOpponent.DrawDebugCoordinateSystem( Loc, Rot, 5.0, true );

		//`log("bone loc="  @ Loc @ "pawn loc=" @ GrappleOpponent.Pawn.Location);

	}
}

state Grappling extends Active
{
//	simulated event BeginState(name PreviousStateName)
//	{
//		GrapplePlayer.StartGrapplePerformance(GP_Advantage);
//		GrappleOpponent.StartGrapplePerformance(GP_Advantage);
//	}

}


/**
 * Called when the Interaction is added to the GameViewportClient's Interactions array.
 */
function Initialized()
{
	GotoState('Inactive');

	Super.Initialized();
}




function NotifyGameSessionEnded()
{
	//clean up here
	GrapplePlayer = None;
	GrappleOpponent = None;

	GotoState('Inactive');

	super.NotifyGameSessionEnded();
}


exec function grapplecombonum(int num)
{
	;
	forceComboNum = num;
}


