//=============================================================================
class BluffInteraction extends Input
	within GameViewportClient
	transient
	config(Input)
	native
	inherits(FExec);


enum BluffPerformance
{
	BP_Player_Success,
	BP_Player_Failure,

	BP_Enemy_Success,
	BP_Enemy_Failure,
};

var int missingButton;
var Array<Texture2D> ButtonSprites;
var Texture2D MissingButtonSprite;

var Texture2D PromptIcon;

var int buttonSelection;

var float alpha;
var float alphaMax;

var float timer;
var float bluffTimer;
var float defaultBluffTimer;

var SoundCue HeartbeatSound;
var float heartbeatSoundTimer;
var float soundTimer;
var float minigameTimer;

var Array<int> ButtonIndices;

var TPPlayerController	BluffPlayer;
var TPWehrmachtAIController	BluffOpponent; //make this less type-dependent eventually

var bool bMiniGameOnly;

const AngleConvert = 0.0000958738;	// 2*PI/65536





//var int faceSelection;
// var rotator timerRotation;
//var float promptTimeout;
//var Array<int> ExpressionIndices;
//var Array<ExpressionInfo> Expressions;
//var float LeftAxisX;
//var float LeftAxisY;
//var float LeftAxisAngle;
//65536 / 60
//struct native ExpressionInfo
//{
	//var Texture2D Tex;
	//var eBluffExpression Expression; //do not put enum first in a native struct - known issue
	//var int arrowRotation;

//};

//var Array<Texture2D> Arrows;
//var Texture2D Circle;
//var Texture2D RedBG;


//////////////////////////////////////////////////////////
//hud placement stuff - let's use the UI system instead eventually


//these should be adjusted depending on screen resolution...



//`define RIGHT_EDGE_PERCENT 0.15f
//`define TOP_EDGE_PERCENT 0.05f





































struct native posInfo
{
	var float x,y,w,h;
	var float sx,sy,sw,sh;
	var int desiredRot;
};

//var Array<posInfo> ArrowPositions;
//var Array<posInfo> ArrowScaledPositions;


//////////////////////////////////////////////////////////

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native function ClearPressedKeys( );


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

event NotifyPerformanceFinished(BluffPerformance Perf)
{
}

function bool IsActive()
{
	if( IsInState('InActive') )
	{
		return false;
	}
	return true;

}


//Called by player to initiate the bluff prompt
function EnablePrompt(TPPlayerController player, TPWehrmachtAIController Opponent)
{
}

//Called by player to cancel the bluff prompt
function CancelPrompt()
{
	BluffOpponent.OnBluffCancelled();
}

// Called through kismet to go straight into the mini game
function EnableMiniGame(TPPlayerController player)
{

}

function PostRender(Canvas Canvas)
{
}


//function BluffPrompt(TPPlayerController player)
//{
//}

//function CancelBluffPrompt()
//{
//}

//function ForceBluff(TPPlayerController player)
//{
//}


function RandomizeFaces()
{
//	local int n,j,k,len,temp;
//
//	len = ExpressionIndices.Length;
//
//	for(n=0; n<5; n++)
//	{
//		j=Rand(len);
//		k=Rand(len);
//
//		temp = ExpressionIndices[j];
//		ExpressionIndices[j] = ExpressionIndices[k];
//		ExpressionIndices[k] = temp;
//	}

}

function RandomizeButtons()
{
    local int i, n, len, temp;

    len = ButtonIndices.Length;

    // randomize buttons
    for(i=0; i<len; i++)
    {
        n=Rand(len);

        temp = ButtonIndices[n];
        ButtonIndices[n] = ButtonIndices[i];
        ButtonIndices[i] = temp;
    }

    // Get the missing button
    missingButton = SetMissingButton();
}

// Set the missing button to some random number
function int SetMissingButton()
{
    local int tempMissingButton, len;

    len = ButtonIndices.Length;

    tempMissingButton = Rand(len);
    return tempMissingButton;
}

state Inactive
{
	simulated event BeginState(name PreviousStateName)
	{
		bMiniGameOnly = false;
        BluffPlayer = None;
		ClearPressedKeys();
	}

	function EndState(name NextStateName)
	{
	}
	function PushedState()
	{
	}
	function PoppedState()
	{
	}

//	function ForceBluff(TPPlayerController player)
//	{
//		`log("I'm forcing a bluff!");
//        BluffPlayer = player;
//		GotoState('Active');
//	}

//	function BluffPrompt(TPPlayerController player)
//	{
//        if(player != None)
//		{
//			BluffPlayer = player;
//			GotoState('Prompt');
//		}
//	}

    function EnableMiniGame(TPPlayerController player)
    {
        // Jump straight into the mini-game
		if(player != None)
		{
			BluffPlayer = player;
			GotoState('Active');
		}
    }

	function EnablePrompt(TPPlayerController player, TPWehrmachtAIController Opponent)
	{
		if(player != None)
		{
			BluffPlayer = player;
			BluffOpponent = Opponent;
			GotoState('Prompt');
		}
	}
}

state Prompt
{
	simulated event BeginState(name PreviousStateName)
	{
		timer = 0.f;

		BluffOpponent.OnBluffPrompt(self, BluffPlayer);

	}
	function EndState(name NextStateName)
	{
	}
	function PushedState()
	{
	}
	function PoppedState()
	{
	}


	function EnablePrompt(TPPlayerController player, TPWehrmachtAIController Opponent)
	{
		if(player != None && Opponent != BluffOpponent)
		{
			//we're switching opponents
			BluffPlayer = player;
			BluffOpponent = Opponent;
			GotoState('Prompt');
		}

	}

	event Tick(float DeltaTime)
	{
		timer += DeltaTime; //this will be affected by timescale; maybe we want real clock time?
//		if(timer > promptTimeout)
//		{
//			BluffPlayer.CancelBluff();
//			GotoState('Inactive');
//		}
	}

//	function CancelBluffPrompt() //obsolete
//	{
//		GotoState('Inactive');
//	}

	function CancelPrompt()
	{
		BluffOpponent.OnBluffCancelled();

		GotoState('Inactive');
	}


	function PostRender(Canvas Canvas)
	{
		local float ratioX, ratioY;
		local vector promptWorldPos, promptScreenPos;

		ratioX = Canvas.SizeX / 1024.0;
		ratioY = Canvas.SizeY / 768.0;

		Canvas.SetDrawColor(255, 255, 255, 255); //this affects the textures too

		Canvas.Font = class'Engine'.Static.GetSmallFont();

//		Canvas.SetPos(10, 10);
//		Canvas.SetPos( (Canvas.SizeX * (1.f-`RIGHT_EDGE_PERCENT)), (Canvas.SizeY * `TOP_EDGE_PERCENT));
//		Canvas.DrawText("Player="$BluffPlayer.Uniform @ "Opponent="$BluffOpponent.Uniform);

//		Canvas.SetPos(10, 25 );
//		Canvas.DrawText("Press Enter / A to Bluff.");


//		Canvas.SetOrigin( (Canvas.SizeX * `RIGHT_EDGE_PERCENT) - `HUD_W, Canvas.SizeY * `TOP_EDGE_PERCENT );
//
//		Canvas.SetPos( `PROMPT_X, `PROMPT_Y );
//		Canvas.DrawTile( PromptIcon, PromptIcon.SizeX* `HUD_SCALE, PromptIcon.SizeY * `HUD_SCALE, 0, 0, PromptIcon.SizeX, PromptIcon.SizeY );
//

		//reset the origin
		Canvas.SetOrigin( 0, 0 );



		promptWorldPos = BluffOpponent.Pawn.Location;
		promptWorldPos.Z += BluffOpponent.Pawn.GetCollisionHeight() + (10*ratioY);
		promptScreenPos = Canvas.Project( promptWorldPos );
		if( promptScreenPos.Z > 0 && promptScreenPos.Z < 1 )
		{
			Canvas.SetPos( promptScreenPos.X, promptScreenPos.Y );
			Canvas.DrawTile( PromptIcon, PromptIcon.SizeX* ratioX * 0.5, PromptIcon.SizeY * ratioY * 0.5, 0, 0, PromptIcon.SizeX, PromptIcon.SizeY );
		}

	}

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( Event == IE_Pressed )
		{
			//if(Key == 'Enter' || Key == 'XboxTypeS_A')
			if(Key == 'B' || Key == 'XboxTypeS_B')
			{
				//moved these to player's bluff state begin
			    //BluffPlayer.ClearBluffAttempts();
				//BluffPlayer.EvaluateUniform();
                GotoState('Active');
			}
		}

		return false; //do not absorb input
	}


}


function PositionActors()
{
	local vector playerToOpponent;

	playerToOpponent = Normal( BluffOpponent.Pawn.Location - BluffPlayer.Pawn.Location);

	//make them face each other
	BluffPlayer.Pawn.SetRotation( rotator(playerToOpponent) );
	BluffOpponent.Pawn.SetRotation( rotator(playerToOpponent) + rot(0,32768,0) );


}

state Active
{
	simulated event BeginState(name PreviousStateName)
	{
        //`log("Bluff is Active!");
        //faceSelection = 0;
		timer = 0.f;
        alpha = alphaMax;
		//timer thing will start at top minus (bluffTimeout) seconds and rotate clockwise back to the top.
		//timerRotation.Yaw = 16384 - (`DEGREES_PER_SEC * bluffTimeout);

        //RandomizeFaces();
        // Instead of randomizing faces randomize the button list
        RandomizeButtons();


		//signal the player to enter bluff state - clear velocity, etc.
		BluffPlayer.EnterBluff(self);

        if( !bMiniGameOnly )
		{
            BluffOpponent.EnterBluff(self);
		    PositionActors();
		}

	}

	simulated event EndState(name NextStateName)
	{
		//BluffPlayer.BluffExpression( Expressions[ ExpressionIndices[faceSelection] ].Expression )

        // Check to see if button was a success and check to see if another round has to be satisfied
        //BluffPlayer.SelectedButtonResponse( MissingButtonCheck(buttonSelection) );


	}
	function PushedState()
	{
	}
	function PoppedState()
	{
	}


	event Tick(float DeltaTime)
	{
        local float deltaHeartbeatTimer;

        timer += DeltaTime; //this will be affected by timescale; maybe we want real clock time?
        soundTimer += DeltaTime;
        minigameTimer += DeltaTime;
        if(BluffPlayer.bluffAttempts > 0 && minigameTimer > 0)
            deltaHeartbeatTimer = heartbeatSoundTimer - (heartbeatSoundTimer/( (bluffTimer * BluffPlayer.bluffAttempts )/ minigameTimer) );
        if(deltaHeartbeatTimer < 0.4)
            deltaHeartbeatTimer = 0.4;

        // sound timer for the heartbeat cue
        if(soundTimer > deltaHeartbeatTimer)
        {
            if(IsInState('Active'))
                BluffPlayer.Pawn.PlaySound(HeartbeatSound);
            soundTimer=0;
        }
        // set the new alpha to make the buttons fade
        alpha = alphaMax - (alphaMax /(bluffTimer / timer));

		if(timer > bluffTimer)
		{
			//time's up
			alpha = 0;
            //GotoState('Inactive');
            GotoState('BluffResult');

		}

		// Adjust the alpha of the buttons from here i suppose
		//timerRotation.Yaw += `DEGREES_PER_SEC * DeltaTime;
	}



	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		//`log("bluff key=" @ Key);

		if( Event == IE_Pressed )
		{
            if(Key == 'XboxTypeS_A')
            {
                buttonSelection = 0;
                //GotoState('Inactive');
				GotoState('BluffResult');
            }
            else if(Key == 'XboxTypeS_B')
            {
                buttonSelection = 1;
                //GotoState('Inactive');
				GotoState('BluffResult');
            }
            else if(Key == 'XboxTypeS_X')
            {
                buttonSelection = 2;
                //GotoState('Inactive');
				GotoState('BluffResult');
            }
            else if(Key == 'XboxTypeS_Y')
            {
                buttonSelection = 3;
                //GotoState('Inactive');
				GotoState('BluffResult');
            }
//			if(Key == 'Up')
//			{
//				faceSelection = 0;
//			}
//			else if(Key == 'Down')
//			{
//				faceSelection = 2;
//			}
//			else if(Key == 'Left')
//			{
//				faceSelection = 3;
//			}
//			else if(Key == 'Right')
//			{
//				faceSelection = 1;
//			}
//			else if(Key == 'Enter' || Key == 'XboxTypeS_A')
//			{
//				GotoState('Inactive');
//			}

		}

		//absorb all input by returning true
		return true;
	}

//  DESlin - I don't need axis input in Bluff 2.0
//	event bool InputAxis(int ControllerId,name Key,float Delta,float DeltaTime)
//	{
//		if(Key=='XboxTypeS_LeftX')
//			LeftAxisX = Delta;
//		if(Key=='XboxTypeS_LeftY')
//			LeftAxisY = Delta;
//
//		LeftAxisAngle = atan( LeftAxisY, LeftAxisX )/AngleConvert;
//		if(LeftAxisAngle < 0)
//			LeftAxisAngle += 65536;
//
//
//		if( (Key=='XboxTypeS_LeftX' || Key=='XboxTypeS_LeftY') &&  (Delta > 0.5 || Delta < -0.5) )
//		{
//			if(LeftAxisAngle >=0 && LeftAxisAngle <16384)
//			{
//				//topleft quadrant
//				faceSelection = 1;
//			}
//			else if(LeftAxisAngle >=16385 && LeftAxisAngle<32768)
//			{
//				//topright quadrant
//				faceSelection = 0;
//			}
//			else if(LeftAxisAngle >=32769 && LeftAxisAngle<49152)
//			{
//				//bottomright quadrant
//				faceSelection = 2;
//			}
//			else
//			{
//				//bottomleft quadrant
//				faceSelection = 3;
//			}
//		}


//		if(Delta > 0.5 || Delta < -0.5)
//		{
//			if(Key=='XboxTypeS_LeftX')
//			{
//				if(Delta < 0.0) //Left
//					faceSelection = 3;
//				else
//					faceSelection = 1;
//			}
//			else if(Key=='XboxTypeS_LeftY')
//			{
//				if(Delta < 0.0) //Up
//					faceSelection = 0;
//				else
//					faceSelection = 2;
//			}
//		}

		//absorb
//		return true;
//	}


	function PostRender(Canvas Canvas)
	{
	    local int i;
//		local float x,y,w,h;
//
//		local Vector v0,v1,v2,v3;
//		local Vector2D p0,p1,p2, offset;


//		local rotator arrowRotation;

		Canvas.SetDrawColor(255, 255, 255, 255); //this affects the textures too

		Canvas.Font = class'Engine'.Static.GetSmallFont();

		Canvas.SetPos( 10, 10);
		Canvas.DrawText("Bluff System 2.0", true);

//		Canvas.SetPos( 10, 20);
//		Canvas.DrawText("faceSelection:" @ faceSelection @ "time:" @ timer, true);

		//Position the whole thing
		Canvas.SetOrigin( Canvas.SizeX/2 - 2*ButtonSprites[0].SizeX, Canvas.SizeY * 0.70 );
		Canvas.SetDrawColor(255,255,255, alpha);

        // Draw the button textures
        for(i=0; i < ButtonIndices.Length; i++)
        {
            Canvas.SetPos(ButtonSprites[i].SizeX * i,0);

            if(ButtonIndices[i] == missingButton)
            {
                Canvas.DrawTile(MissingButtonSprite,
                                MissingButtonSprite.SizeX*0.7,
                                MissingButtonSprite.SizeY*0.7,
                                0,
                                0,
                                MissingButtonSprite.SizeX,
                                MissingButtonSprite.SizeY);
            }
            else
            {
                Canvas.DrawTile(ButtonSprites[ButtonIndices[i]],
                                ButtonSprites[ButtonIndices[i]].SizeX*0.7,
                                ButtonSprites[ButtonIndices[i]].SizeY*0.7,
                                0,
                                0,
                                ButtonSprites[ButtonIndices[i]].SizeX,
                                ButtonSprites[ButtonIndices[i]].SizeY);
            }
        }

//		for(i=0; i<4; i++)
//		{
//			if( faceSelection == i )
//			{
//				x=ArrowPositions[i].sx;
//				y=ArrowPositions[i].sy;
//				w=ArrowPositions[i].sw;
//				h=ArrowPositions[i].sh;
//			}
//			else
//			{
//				x=ArrowPositions[i].x;
//				y=ArrowPositions[i].y;
//				w=ArrowPositions[i].w;
//				h=ArrowPositions[i].h;
//			}
  //
//  		x += (ArrowPositions[i].w/2);
//			y += (ArrowPositions[i].h/2);
//
//			v1.x = -w/2;			v1.y = -h/2;
//			v0.x =  w/2;			v0.y = -h/2;
//
//			v3.x = -w/2;			v3.y = h/2;
//			v2.x =  w/2;			v2.y = h/2;
//
//			arrowRotation.Yaw = -16384 + ArrowPositions[i].desiredRot - Expressions[ ExpressionIndices[i] ].arrowRotation;
//
//			v0 = v0 >> arrowRotation;
//			v1 = v1 >> arrowRotation;
//			v2 = v2 >> arrowRotation;
//			v3 = v3 >> arrowRotation;


//			p0.x = v0.x + x; p0.y = v0.y + y;
//			p1.x = v1.x + x; p1.y = v1.y + y;
//			p2.x = v2.x + x; p2.y = v2.y + y;
//			Canvas.DrawTriangle( Arrows[ ExpressionIndices[i] ], p0, 0, 0, p1, 0, 1, p2, 1, 0 );

//			p0.x = v1.x + x; p0.y = v1.y + y;
//			p1.x = v2.x + x; p1.y = v2.y + y;
//			p2.x = v3.x + x; p2.y = v3.y + y;
//			Canvas.DrawTriangle( Arrows[ ExpressionIndices[i] ], p0, 0, 1, p1, 1, 0, p2, 1, 1 );


//			Canvas.SetPos( x, y );
//			Canvas.DrawTile( Arrows[i], w, h, 0, 0, Arrows[i].SizeX, Arrows[i].SizeY );

//		}



//		Canvas.SetPos( `CIRCLE_X, `CIRCLE_Y );
//		Canvas.DrawTile( Circle, Circle.SizeX*`HUD_SCALE, Circle.SizeY*`HUD_SCALE, 0, 0, Circle.SizeX, Circle.SizeY );





//		Canvas.SetPos( `FACE_X, `FACE_Y );
//		Canvas.DrawTile(	Expressions[ ExpressionIndices[faceSelection] ].Tex,
//							Expressions[ ExpressionIndices[faceSelection] ].Tex.SizeX*`HUD_SCALE,
//							Expressions[ ExpressionIndices[faceSelection] ].Tex.SizeY*`HUD_SCALE,
//							0,
//							0,
//							Expressions[ ExpressionIndices[faceSelection] ].Tex.SizeX,
//							Expressions[ ExpressionIndices[faceSelection] ].Tex.SizeY );





//		Canvas.SetPos( `DEBUG_FACE_X, `DEBUG_FACE_Y );
//		switch(Expressions[ ExpressionIndices[faceSelection] ].Expression)
//		{
//			case Expression_Surprise:
//				Canvas.DrawText("Surprise");
//				break;
//			case Expression_Contempt:
//				Canvas.DrawText("Contempt");
//				break;
//			case Expression_Respect:
//				Canvas.DrawText("Respect");
//				break;
//			case Expression_Cowering:
//				Canvas.DrawText("Cowering");
//				break;
//		}






//		Non-rotating bg
//		Canvas.SetPos( `BG_X, `BG_Y );
//		Canvas.DrawTile( RedBG, RedBG.SizeX, RedBG.SizeY, 0, 0, RedBG.SizeX, RedBG.SizeY );


//		offset.x = `BG_X + `BG_W/2;
//		offset.y = `BG_Y + `BG_H/2;

/*
	1    0
	------
	|\   |
	| \  |
	|  \ |
	|   \|
    ------
    3    2
*/
//		v1.x = -`BG_W/2;			v1.y = -`BG_H/2;
//		v0.x =  `BG_W/2;			v0.y = -`BG_H/2;
//
//		v3.x = -`BG_W/2;			v3.y = `BG_H/2;
//		v2.x =  `BG_W/2;			v2.y = `BG_H/2;
//
//		v0 = v0 >> timerRotation;
//		v1 = v1 >> timerRotation;
//		v2 = v2 >> timerRotation;
//		v3 = v3 >> timerRotation;


//		p0.x = v0.x + offset.x; p0.y = v0.y + offset.y;
//		p1.x = v1.x + offset.x; p1.y = v1.y + offset.y;
//		p2.x = v2.x + offset.x; p2.y = v2.y + offset.y;
//		Canvas.DrawTriangle( RedBG, p0, 0, 0, p1, 0, 1, p2, 1, 0 );

//		p0.x = v1.x + offset.x; p0.y = v1.y + offset.y;
//		p1.x = v2.x + offset.x; p1.y = v2.y + offset.y;
//		p2.x = v3.x + offset.x; p2.y = v3.y + offset.y;
//		Canvas.DrawTriangle( RedBG, p0, 0, 1, p1, 1, 0, p2, 1, 1 );



		//reset the origin
		Canvas.SetOrigin( 0, 0 );

	}




	event bool InputChar(int ControllerId,string Unicode)
	{
		//absorb
		return true;
	}


}

state BluffResult
{
	simulated event BeginState(name PreviousStateName)
	{
		SelectedButtonResponse( MissingButtonCheck(buttonSelection) );
	}

    function SelectedButtonResponse(bool bOutcome)
    {

        // Plays another round of the mini game if there are BluffAttempts available
        if(bOutcome && BluffPlayer.bluffAttempts > 0)
        {
			;
			BluffPlayer.bluffAttempts--;

			GotoState('Active');

			return;
        }

        if(bOutcome)
		{
			;
            // Go to successful outcome
			minigameTimer = 0;
            bluffTimer = defaultBluffTimer;
			GotoState('BluffSuccess');
        }
		else
		{
			;
			// Go to failed response
			minigameTimer = 0;
            bluffTimer = defaultBluffTimer;
			GotoState('BluffFailure');
        }

    }

}

state BluffSuccess
{
	simulated event BeginState(name PrevStateName)
	{
		if( bMiniGameOnly )
		{
            BluffPlayer.ExitBluff();
		    BluffPlayer.Pawn.TriggerEventClass( class'SeqEvent_BluffResponse', BluffPlayer, 0);
		    GotoState('Inactive');
		}
		else
		{
            BluffPlayer.StartBluffPerformance(BP_Player_Success);
		    BluffOpponent.StartBluffPerformance(BP_Enemy_Success);
		}
	}

	event NotifyPerformanceFinished(BluffPerformance perf)
	{
		//Send opponent event which triggers kismet here
		BluffOpponent.OnBluffSuccess(BluffPlayer);


		BluffPlayer.ExitBluff();
		BluffOpponent.ExitBluff();

		GotoState('Inactive');
	}
}

state BluffFailure
{
	simulated event BeginState(name PrevStateName)
	{
		if( bMiniGameOnly )
		{
            BluffPlayer.ExitBluff();
		    BluffPlayer.Pawn.TriggerEventClass( class'SeqEvent_BluffResponse', BluffPlayer, 1);
		    GotoState('Inactive');
		}
		else
		{
            BluffPlayer.StartBluffPerformance(BP_Player_Failure);
		    BluffOpponent.StartBluffPerformance(BP_Enemy_Failure);
		}
	}

	event NotifyPerformanceFinished(BluffPerformance perf)
	{
		//Send opponent event which triggers kismet here
		BluffOpponent.OnBluffFailure(BluffPlayer);


		BluffPlayer.ExitBluff();
		BluffOpponent.ExitBluff();

		GotoState('Inactive');
	}

}

function bool MissingButtonCheck(int selectedMissingButton)
{
    // Success!!!
    if( missingButton == selectedMissingButton )
        return true;
    // Failure!!! You suck!
    else
        return false;
}


/**
 * Called when the Interaction is added to the GameViewportClient's Interactions array.
 */
function Initialized()
{
    // Set the bluff timer per round
    bluffTimer = defaultBluffTimer;
    GotoState('Inactive');

    Super.Initialized();
//UIController.SceneClient.InitializeScene(BluffScene);

//	ArrowPositions.Insert(0,4);

//	ArrowPositions[0].x = `ARROW_LEFT_X;
//	ArrowPositions[0].y = `ARROW_TOP_Y;
//	ArrowPositions[0].w = `ARROW_W;
//	ArrowPositions[0].h = `ARROW_H;

//	ArrowPositions[0].sx = `ARROW_LEFT_X	- `ARROW_SCALE_X;
//	ArrowPositions[0].sy = `ARROW_TOP_Y		- `ARROW_SCALE_Y;
//	ArrowPositions[0].sw = `ARROW_W			+ `ARROW_SCALE_X;
//	ArrowPositions[0].sh = `ARROW_H			+ `ARROW_SCALE_Y;

//	ArrowPositions[0].desiredRot = 57354;


//	ArrowPositions[1].x = `ARROW_RIGHT_X;
//	ArrowPositions[1].y = `ARROW_TOP_Y;
//	ArrowPositions[1].w = `ARROW_W;
//	ArrowPositions[1].h = `ARROW_H;

//	ArrowPositions[1].sx = `ARROW_RIGHT_X	;
//	ArrowPositions[1].sy = `ARROW_TOP_Y		- `ARROW_SCALE_Y;
//	ArrowPositions[1].sw = `ARROW_W			+ `ARROW_SCALE_X;
//	ArrowPositions[1].sh = `ARROW_H			+ `ARROW_SCALE_Y;

//	ArrowPositions[1].desiredRot = 8192;


//	ArrowPositions[2].x = `ARROW_LEFT_X;
//	ArrowPositions[2].y = `ARROW_BOTTOM_Y;
//	ArrowPositions[2].w = `ARROW_W;
//	ArrowPositions[2].h = `ARROW_H;

//	ArrowPositions[2].sx = `ARROW_LEFT_X	- `ARROW_SCALE_X;
//	ArrowPositions[2].sy = `ARROW_BOTTOM_Y	;
//	ArrowPositions[2].sw = `ARROW_W			+ `ARROW_SCALE_X;
//	ArrowPositions[2].sh = `ARROW_H			+ `ARROW_SCALE_Y;

//	ArrowPositions[2].desiredRot = 40960;


//	ArrowPositions[3].x = `ARROW_RIGHT_X;
//	ArrowPositions[3].y = `ARROW_BOTTOM_Y;
//	ArrowPositions[3].w = `ARROW_W;
//	ArrowPositions[3].h = `ARROW_H;

//	ArrowPositions[3].sx = `ARROW_RIGHT_X	;
//	ArrowPositions[3].sy = `ARROW_BOTTOM_Y	;
//	ArrowPositions[3].sw = `ARROW_W			+ `ARROW_SCALE_X;
//	ArrowPositions[3].sh = `ARROW_H			+ `ARROW_SCALE_Y;

//	ArrowPositions[3].desiredRot = 24576;
}

exec function SetBluffTimer(float val)
{
	defaultBluffTimer = val;
	bluffTimer = defaultBluffTimer;
}

function NotifyGameSessionEnded()
{
    BluffPlayer = None;
    BluffOpponent = None;

	GotoState('Inactive');

	super.NotifyGameSessionEnded();
}

