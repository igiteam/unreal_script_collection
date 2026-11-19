//=============================================================================
class LevelSelectInteraction extends Interaction
	within GameViewportClient
	transient
	config(Input);


var Array<string> Levels;
var Array<string> Descriptions;
var bool m_bIsActive;
var int m_iSelected;
var float m_fSelectionTimeout;
var Pawn m_thePawn;


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

function PostRender(Canvas Canvas)
{
}


state Inactive
{
	simulated event BeginState(name PreviousStateName)
	{
       m_bIsActive = false;
       m_iSelected = 0;
       m_fSelectionTimeout = -1;
	}




}

function Toggle( PlayerPawn thePawn)
{
    if (m_bIsActive)
    	GotoState('Inactive');
    else
    	GotoState('Active');

    m_thePawn = thePawn;
}


state Active
{
	simulated event BeginState(name PreviousStateName)
	{
        m_bIsActive = true;

	}

	simulated event EndState(name NextStateName)
	{

	}

	event Tick(float DeltaTime)
	{

       if (m_fSelectionTimeout>0)
         m_fSelectionTimeout-=DeltaTime;
	}



	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		//`log("bluff key=" @ Key);

		if( event == IE_Pressed )
		{
			if(Key == 'W' || Key == 'XboxTypes_DPad_Up' || Key == 'Up')
			{
				m_iSelected--;
				return true;
			}
			else if(Key == 'S' || Key == 'XboxTypes_DPad_Down' || Key == 'Down')
			{
				m_iSelected++;
    			return true;
			}
			else if (Key == 'A' || Key == 'D' || Key == 'XboxTypes_DPad_Left' || Key == 'XboxTypes_DPad_Right')
    			return true;
			else if (Key == 'Left' || Key == 'Right')
    			return true;
			else if(Key == 'Enter' || Key == 'XboxTypeS_A')
			{
    			  m_thePawn.ConsoleCommand("open " $ Levels[m_iSelected]);
    			  GotoState('Inactive');
			}
		}



		//absorb all input by returning true
		return false;
	}

	function bool InputAxis( int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad )
	{
	    if (m_fSelectionTimeout>0)
    	    return true;

		if(Delta > 0.5 || Delta < -0.5)
		{
			if(Key=='XboxTypeS_RightX')
			{
				if(Delta < 0.0) //Left
					m_iSelected++;
				else
                    m_iSelected--;

                 m_fSelectionTimeout = 0.4;
			}
			else if(Key=='XboxTypeS_RightY')
			{
				if(Delta < 0.0) //Up
					m_iSelected--;
				else
                    m_iSelected++;
                 m_fSelectionTimeout = 0.4;
			}
		}

		//absorb
		return true;
	}


	function PostRender(Canvas Canvas)
	{
        local int i;
		Canvas.SetDrawColor(128, 128, 128, 128); //this affects the textures too

		Canvas.Font = class'Engine'.Static.GetSmallFont();

        if (m_iSelected<0)
            m_iSelected = Levels.Length -1;

        if (m_iSelected==Levels.Length)
            m_iSelected = 0;

//		Canvas.SetPos( 10, 10);
//		Canvas.DrawText("Bluff System 1.0", true);
//
//		Canvas.SetPos( 10, 20);
//		Canvas.DrawText("faceSelection:" @ faceSelection @ "time:" @ timer, true);



		//Position the whole thing
		Canvas.SetOrigin( (Canvas.SizeX - 300) / 2, (Canvas.SizeY + 20 - 20*Levels.Length) / 2);

		Canvas.SetPos( 0,0 );
        Canvas.DrawRect(  300, 20*Levels.Length+20);
   		Canvas.SetPos( 1,1 );
       	Canvas.SetDrawColor(128, 128, 128, 255);
        Canvas.DrawRect(  298, 18);

        Canvas.SetDrawColor(128, 128, 255, 255);
	    Canvas.SetPos( 1,20 + 20*m_iSelected +1  );
        Canvas.DrawRect(  298, 18);

      	Canvas.SetPos( 2,2 );
      	Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.DrawText("Select level");



		for ( i=0; i<Levels.Length;i++)
		{
            Canvas.SetDrawColor(0, 0, 0, 255);
			Canvas.SetPos( 2+1,20 + 20*i + 3 );
      		Canvas.DrawText(Descriptions[i]);

            Canvas.SetDrawColor(255, 255, 255, 255);
		    Canvas.SetPos( 2,20 + 20*i + 2 );
      		Canvas.DrawText(Descriptions[i]);
		}

		//reset the origin
		Canvas.SetOrigin( 0, 0 );

	}




	event bool InputChar(int ControllerId,string Unicode)
	{
		//absorb
		return true;
	}


}


/**
 * Called when the Interaction is added to the GameViewportClient's Interactions array.
 */
function Initialized()
{
	//UIController.SceneClient.InitializeScene(BluffScene);

	GotoState('Inactive');

	Super.Initialized();
}


function NotifyGameSessionEnded()
{
	m_thePawn = None;

	super.NotifyGameSessionEnded();
}



