//=============================================================================
class CheatMenuInteraction extends Interaction
	within GameViewportClient
	transient
	config(Input)
	dependson(TPTuneData);









#linenumber 8




struct ButtonData
{
	var Texture2D Icon;
	var string CheatName;
	var bool bIsActive;
};

var array<ButtonData> CheatButtonList;
var TPPlayerController TPC;
var Pawn m_thePawn;
var config array<string> WeaponList;
var bool m_bIsActive;
var bool LeftStickPressed, RightStickPressed, LeftShoulderPressed, RightShoulderPressed, Button_A_Pressed, Button_Y_Pressed;
var Canvas MyCanvas;
var bool bIdiotModeActive;

enum CheatEnum
{
	C_GOD_MODE,
	C_CYCLE_AI_INFO,
	C_WALK_GHOST,
	C_ALL_WEAPONS,
	C_PLAYERS_ONLY,
	C_COUNT
};

enum AIModeEnum
{
	AIM_PLAYERINFO,
	AIM_GRAPH,
	AIM_ENTITIES,
	AIM_COVER_SLOTS,
	AIM_PAWN_AI1,
	AIM_PAWN_AI2,
	AIM_PAWN_ANIMS,
	AIM_PAWN_ANIMSDEEP,
	AIM_PAWN_ROT,
	AIM_LOF_LINES,
	AIM_GREN_LINE,
	AIM_JUST_HITPOINTS,
	AIM_NONE,
	AIM_COUNT
};
var int AIMode;
var array<string> AIModeNames;

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

function PostRender(Canvas Canvas)
{
}

state Inactive
{
	simulated event BeginState(name PreviousStateName)
	{
       m_bIsActive = false;
	   
		LeftStickPressed = false;
		RightStickPressed = false;
		LeftShoulderPressed = false;
		RightShoulderPressed = false;
	}

	event Tick (float DeltaTime)
    {

    }

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if (TPC != None && (TPC.bIsDemoMode || !TPC.bEnableCheats))
			return false;

		if (event == IE_Pressed)
		{
			if (Key == 'XboxTypeS_RightThumbstick')
				RightStickPressed = true;
			else if (Key == 'XboxTypeS_LeftThumbstick')
				LeftStickPressed = true; 
			else if (Key == 'XboxTypeS_LeftShoulder')
				LeftShoulderPressed = true;
			else if (Key == 'XboxTypeS_RightShoulder')
				RightShoulderPressed = true;
			else if (Key == 'XboxTypeS_A')
				Button_A_Pressed = true;
			else if (Key == 'XboxTypeS_Y')
				Button_Y_Pressed = true;
		}
		else if (event == IE_Released)
		{
			if (Key == 'XboxTypeS_RightThumbstick')
				RightStickPressed = false;
			else if (Key == 'XboxTypeS_LeftThumbstick')
				LeftStickPressed = false; 
			else if (Key == 'XboxTypeS_LeftShoulder')
				LeftShoulderPressed = false;
			else if (Key == 'XboxTypeS_RightShoulder')
				RightShoulderPressed = false;
			else if (Key == 'XboxTypeS_A')
				Button_A_Pressed = false;
			else if (Key == 'XboxTypeS_Y')
				Button_Y_Pressed = false;
		}

		if (RightStickPressed && LeftStickPressed && RightShoulderPressed && LeftShoulderPressed)
		{
			GotoState('Active');
		}
// 		else if( LeftShoulderPressed && Button_Y_Pressed )
// 		{
// 			//screenshot
// 			if( TPC != None )
// 			{
// 				`log("screenshot!");
// 				//TPC.ClientMessage("Screenshot");
// 				
// 				if ( TPC.WorldInfo.NetMode == NM_Standalone )
// 				{
// 					TPC.ConsoleCommand("shot");
// 					return true;
// 				}
// 					
// 				
// 				
// 			}
// 		}	
		
			
		//absorb all input by returning true
		return false;
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
		TPC.MPCheat();
        m_bIsActive = true;
		LeftStickPressed = false;
		RightStickPressed = false;
		LeftShoulderPressed = false;
		RightShoulderPressed = false;
		CheatButtonList[C_GOD_MODE].bIsActive = TPC.bGodMode;

		//CheatButtonList[1].bIsActive = TPGameInfo(TPC.WorldInfo.Game).bKynapseEnabled && TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.GetDebugFlag(TPD_SHOWKYGRAPH);

		//SetTimer(0.25, true, 'ShowIdiotAlert');

	}

	//function ShowIdiotAlert()
	//{
	//	MyCanvas.SetOrigin( 0, 0 );
	//	if (bIdiotModeActive)
	//		MyCanvas.SetDrawColor(255, 255, 255, 255); 
	//	else
	//		MyCanvas.SetDrawColor(255, 255, 255, 0); 

	//	MyCanvas.Font = class'Engine'.Static.GetMediumFont();
	//	
	//	MyCanvas.SetPos(MyCanvas.SizeX-0.35, MyCanvas.SizeY-0.2);
	//	MyCanvas.DrawText("Normal Input Disabled");


	//}
	simulated event EndState(name NextStateName)
	{

	}

	event Tick(float DeltaTime)
	{
		local TPCheatManager TPCM;
		CheatButtonList[C_GOD_MODE].bIsActive = (TPC.bGodMode) ? true : false;
		TPCM = TPCheatManager(TPC.CheatManager); //Cast<TPCheatManager>(TPC.CheatManager);
		if (TPCM != None)
		{
			CheatButtonList[C_PLAYERS_ONLY].bIsActive = TPCM.GetPlayersOnly();
		}
    }

	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		if( event == IE_Pressed )
		{
			// Toggle Kynapse graph on/off
			if(Key == 'XboxTypeS_A')
			{
				// only light up cheat when ai mode is not none
				AIMode = (AIMode + 1) % AIM_COUNT;
				CheatButtonList[C_CYCLE_AI_INFO].bIsActive = AIMode != AIM_NONE;

				// need to clear this stuff out so it doesn't all pile up
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYGRAPH, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYAIMESH, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYPATHS, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYENTITIES, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYOBSTACLES, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWCOVERSLOTS, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNAI1, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNAI2, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNANIMS, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNANIMSDEEP, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNROT, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPLAYERINFO, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWGRENDATA, FALSE);
				TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWJUSTHITPOINTS, FALSE);

				class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayCanFireAtTargetFromPointAimRays = false;
				class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayGrenadeThrowArcs = false;
				class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayHitPoints = false;

				if (TPGameInfo(TPC.WorldInfo.Game).bKynapseEnabled)
				{
					switch (AIMode)
					{
					case AIM_GRAPH:
						TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYGRAPH, TRUE);
						break;
					case AIM_ENTITIES:
						TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYAIMESH, TRUE);
						TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYPATHS, TRUE);
						TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYENTITIES, TRUE);
						TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWKYOBSTACLES, TRUE);
						break;
					}
				}
				switch (AIMode)
				{
				case AIM_COVER_SLOTS:
					TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWCOVERSLOTS, TRUE);
					break;
				case AIM_PAWN_AI1:
					TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNAI1, TRUE);
					break;
				case AIM_PAWN_AI2:
					TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNAI2, TRUE);
					break;
				case AIM_PAWN_ANIMS:
					TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNANIMS, TRUE);
					break;
				case AIM_PAWN_ANIMSDEEP:
					TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNANIMSDEEP, TRUE);
					break;
				case AIM_PAWN_ROT:
					TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPAWNROT, TRUE);
					break;
				case AIM_PLAYERINFO:
					TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWPLAYERINFO, TRUE);
					break;
				case AIM_LOF_LINES:
					class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayCanFireAtTargetFromPointAimRays = true;
					break;
				case AIM_GREN_LINE:
					TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWGRENDATA, TRUE);
					class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayGrenadeThrowArcs = true;
					break;
				case AIM_JUST_HITPOINTS:
					TPGameReplicationInfo(TPC.WorldInfo.GRI).DebugInfo.SetDebugFlag(TPD_SHOWJUSTHITPOINTS, TRUE);
					class'TPTuneManager'.static.Get().GetTuneData().DebugDrawData.m_bDisplayHitPoints = true;
					break;
				}
				return true;
			}
			// God Mode
			else if(Key == 'XboxTypeS_B')
			{
				CheatButtonList[C_GOD_MODE].bIsActive = !CheatButtonList[C_GOD_MODE].bIsActive;
				TPC.CheatManager.God();
				return true;
			}
			//  Walk or Ghost
			else if (Key == 'XboxTypeS_X')
			{				
				if (TPC.bCheatFlying)
                    TPC.CheatManager.Walk();
				else
					TPC.CheatManager.Ghost();
				return true;
			}
			// All Weapons
			else if (Key == 'XboxTypeS_Y')
			{
				GiveWeapons();
				return true;
			}
			// players only
			else if (Key == 'XboxTypeS_RightShoulder')
			{
				TPC.CheatManager.PlayersOnly();
				return true;
			}
			else if(Key == 'XboxTypeS_Back')
			{
    			GotoState('Inactive');
				return true;
			}
			else if (Key == 'XboxTypeS_DPad_Up')
			{
				TPC.PerformanceBooster();
			}
		}



		//absorb all input by returning true
		return false;
	}

	function PostRender(Canvas Canvas)
	{
		local int i;
		local float ratioX, ratioY;
		
		// Super Hack variables 
		local float XWidth, YHeight;
		// End Super Hack variables

		MyCanvas = Canvas;
		Canvas.SetOrigin( 0, 0 );
        Canvas.SetDrawColor(255, 255, 255, 255); //this affects the textures too

		Canvas.Font = class'Engine'.Static.GetSmallFont();
		
		ratioX = Canvas.SizeX / 1024.0;
		ratioY = Canvas.SizeY / 768.0;

		for (i = 0 ; i < C_COUNT; i++)
		{
			if (CheatButtonList[i].bIsActive)
				Canvas.SetDrawColor(255,255,255,255);
			else
				Canvas.SetDrawColor(128,128,128,128);

			Canvas.SetPos(50*ratioX, ((CheatButtonList[i].Icon.SizeY * i) + 70)*ratioY);
			Canvas.DrawTile( CheatButtonList[i].Icon, CheatButtonList[i].Icon.SizeX*ratioX, CheatButtonList[i].Icon.SizeY*ratioY, 0, 0, CheatButtonList[i].Icon.SizeX, CheatButtonList[i].Icon.SizeY );
			Canvas.SetPos( (50+CheatButtonList[i].Icon.SizeX+15)*ratioX, ((CheatButtonList[i].Icon.SizeY * i) + 70 + (CheatButtonList[i].Icon.SizeY*0.25))*ratioY);
			switch (i)
			{
			case C_WALK_GHOST:
				if (TPC.bCheatFlying)
				{
					Canvas.SetDrawColor(128,128,128,128);
					Canvas.TextSize("Walk ", XWidth, YHeight);
					Canvas.DrawText("Walk");
					Canvas.SetDrawColor(255,255,255,255);
					Canvas.SetPos(((50+CheatButtonList[i].Icon.SizeX+15)*ratioX) + XWidth, ((CheatButtonList[i].Icon.SizeY * i) + 70 + (CheatButtonList[i].Icon.SizeY*0.25))*ratioY);
					Canvas.DrawText("/");
					Canvas.TextSize("Walk / ", XWidth, YHeight);
					Canvas.SetPos(((50+CheatButtonList[i].Icon.SizeX+15)*ratioX) + XWidth, ((CheatButtonList[i].Icon.SizeY * i) + 70 + (CheatButtonList[i].Icon.SizeY*0.25))*ratioY);
					Canvas.DrawText("Ghost");
				}
				else
				{					
					Canvas.SetDrawColor(255,255,255,255);
					Canvas.TextSize("Walk ", XWidth, YHeight);
					Canvas.DrawText("Walk");
					Canvas.SetPos(((50+CheatButtonList[i].Icon.SizeX+15)*ratioX) + XWidth, ((CheatButtonList[i].Icon.SizeY * i) + 70 + (CheatButtonList[i].Icon.SizeY*0.25))*ratioY);
					Canvas.DrawText("/");
					Canvas.TextSize("Walk / ", XWidth, YHeight);
					Canvas.SetPos(((50+CheatButtonList[i].Icon.SizeX+15)*ratioX) + XWidth, ((CheatButtonList[i].Icon.SizeY * i) + 70 + (CheatButtonList[i].Icon.SizeY*0.25))*ratioY);
					Canvas.SetDrawColor(128,128,128,128);
					Canvas.DrawText("Ghost");
				}
				break;
			case C_CYCLE_AI_INFO:
				Canvas.DrawText(CheatButtonList[i].CheatName $ " " $ AIModeNames[AIMode]);
				break;
			default:
				Canvas.DrawText(CheatButtonList[i].CheatName);
			}
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
	GotoState('Inactive');

	Super.Initialized();
}

function GetPlayerController(TPPlayerController PlayerController)
{
    TPC = PlayerController;
    m_thePawn = TPC.Pawn; 
}

function GiveWeapons()
{
	local int i;
	local TPWeapon AWeapon;

	if( TPInventoryManager(TPC.Pawn.InvManager).MaxWeapons < WeaponList.length )
		TPInventoryManager(TPC.Pawn.InvManager).MaxWeapons = WeaponList.length;

	for (i = 0; i < WeaponList.length; i++)
	{
        AWeapon = TPWeapon(TPC.CheatManager.GiveWeapon(WeaponList[i]));

		if ( AWeapon.IsAGrenade() )
			AWeapon.MakeGrenadeUnlimited();

		if ( !AWeapon.IsAGrenade() )
			AWeapon.MakeWeaponUnlimited();

		AWeapon.AmmoInMagazine = AWeapon.MagazineSize;
	}
}

function NotifyGameSessionEnded()
{
	m_thePawn = None;
    TPC = none;
	super.NotifyGameSessionEnded();
}



