//=============================================================================
// IMPORTANT! Do not add any content references here, otherwise it will be globally loaded
// FOREVER

class TPShellInteraction extends Input
	within GameViewportClient
	native
	config(Game)
	transient
    inherits(FExec);
    
var Pawn m_thePawn;
var bool bIsActive;
var int LevelSelect;
var TPPlayerController TPC;
var Array<string> Levels;
var float MaxResultScreenTimer;
var float ResultTimer;
var float alpha;
var float alphaMax;
var float timer;
var float fadeIn;
var bool bDisplayShell;
var config bool bStartupShell;

var MaterialInstanceConstant WinBackgroundMaterialInstance;
var MaterialInstanceConstant LossBackgroundMaterialInstance;
var Material ShellBackGround;
var Material ShellBackGroundWide;
var Material WinBackground;
var Material LossBackground;
var Array<Material> Buttons;

// New Stuff for MapList
var Texture2D MenuTextBG, MenuTextCornerL, MenuTextCornerR, BackgroundHD, Background, QuitOn, QuitOff;

struct native ShellMapInfo
{
	var string Map;
	var string Caption;
	var Texture2D UnImage;
	var Texture2D OverImage;
};

var config array<ShellMapInfo> MapInfoList;

var UIScene TPMainMenu;
var UIScene TPGameOver;

var float TextSizeX, TextSizeY;

var Material CurrentMovieMaterial;
var TextureMovie CurrentMovieTexture;




function PostRender(Canvas Canvas)
{  
}

function InitBackgroundMaterialInstance()
{ 
//     WinBackgroundMaterialInstance = new(Outer) class'MaterialInstanceConstant';
//     WinBackgroundMaterialInstance.SetParent(WinBackground); 
//     WinBackgroundMaterialInstance.SetScalarParameterValue('WinBGAlphaChannel', 0);
//     
//     LossBackgroundMaterialInstance = new(Outer) class'MaterialInstanceConstant';
//     LossBackgroundMaterialInstance.SetParent(LossBackground); 
//     LossBackgroundMaterialInstance.SetScalarParameterValue('LossBGAlphaChannel', 0);
}    

state Inactive
{
	simulated event BeginState(name PreviousStateName)
	{
		bIsActive = false;
        LevelSelect = 0;
	}
}

function Toggle()
{
	if (!IsInState('PlayMovie'))
	{
		if (bIsActive)
	    	GotoState('Inactive');
		else
    		GotoState('Active');
	}
}


simulated event MovieFinished()
{
}

/*state PlayMovie
{
	simulated event BeginState(name PreviousStateName)
	{
		//`log("BEGIN PLAY MOVIE");
		//`log("Duration:"@CurrentMovieTexture.GetDuration());
		CurrentMovieTexture.Stop();
		CurrentMovieTexture.Play();
		TPC.SetTimer(CurrentMovieTexture.GetDuration(), false, 'MovieFinished');
	}

	simulated event EndState(name NextStateName)
	{
		//`log("END PLAY MOVIE");
		CurrentMovieMaterial=None;
		CurrentMovieTexture=None;
	}

	function PostRender(Canvas Canvas)
	{
		Canvas.SetOrigin(-30,-30);
		Canvas.DrawMaterialTile(CurrentMovieMaterial, Canvas.SizeX, Canvas.SizeY, 0.0f, 0.0f, 1.0f, 1.0f);
	}

	simulated event MovieFinished()
	{
		GotoState('Inactive');
	}

	event bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed, bool bGamepad )
	{
		if (event == IE_Released)
		{
			if (Key == 'Escape' || Key == 'XboxTypeS_Start')
			{
				TPC.ClearTimer('MovieFinished');
				//TPC.MovieFinished();
			}
		}

		return true;
	}
}*/

state Active
{
	simulated event BeginState(name PreviousStateName)
	{
	    GotoState('Inactive');   
	}
	simulated event EndState(name NextStateName)
	{
		if (TPC != none)
			TPC.LocalTravel("entry_master.tpm");
	}
	
	/*event bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f )
	{

		local string LevelName;
		if( event == IE_Pressed )
		{
			LevelName = Repl( Locs(TPC.WorldInfo.GetLocalURL()), ".tpm", "" );
			LevelName = Left( LevelName, 12);
			if(Key == 'W' || Key == 'XboxTypes_DPad_Up' || Key == 'Up')
			{
			    LevelSelect--;
			    if(LevelSelect < 0)
			       //LevelSelect = Buttons.Length - 1; 
				   LevelSelect = MapInfoList.Length - 1; 
				return true;
			}
			else if(Key == 'S' || Key == 'XboxTypes_DPad_Down' || Key == 'Down')
			{
				LevelSelect++;
				//if(LevelSelect > Buttons.Length - 1)
				if(LevelSelect > MapInfoList.Length - 1)
			       LevelSelect = 0;
    			return true;
			}
			else if(Key == 'XboxTypeS_B')
			{
				TPC.GetUIController().OpenScene(TPMainMenu, LocalPlayer(TPC.Player));
				GotoState('Inactive');
			}
			else if(Key == 'Enter' || Key == 'XboxTypeS_A')
			{
    			//if(LevelSelect < 3)
				if(LevelSelect < MapInfoList.Length-1)
    			{
                    //m_thePawn.ConsoleCommand("open " $ Levels[LevelSelect]);
					//m_thePawn.ConsoleCommand("open " $ MapNamesList[LevelSelect]);
					//m_thePawn.ConsoleCommand("open " $ Levels[LevelSelect]);
					
					if (TPC != none)
						TPC.LocalTravel(MapInfoList[LevelSelect].Map);
					
					GotoState('Inactive');
    			}
    			else
    			{
    			    m_thePawn.ConsoleCommand("Quit");
    			}
			}
			else if( (Key == 'XboxTypeS_Start' || Key == 'Tab') && LevelName != "shell_master" )
			{
		        TPC.TPExitShell();
		    }
			else if(Key == 'Escape')
			{
				m_thePawn.ConsoleCommand("Quit");
			}
			   
		}

		//absorb all input by returning true
		return true;
	}

             	   
	function PostRender(Canvas Canvas)
	{
	    RenderShell(Canvas);     
    }
    
    function RenderShell(Canvas Canvas)
    {

		local int i;
		local int StartY;
		local float Scale;

		//Canvas.Font = Font'HUD_Materials.Menu.Menu_FontA';//class'Engine'.Static.GetLargeFont();

		Canvas.SetOrigin(0,0);
        Canvas.SetDrawColor( 255, 255, 255, 255 );
        Canvas.SetPos(0,0);

		if (Canvas.SizeX == 1280)
		{
			//Canvas.DrawMaterialTile(ShellBackGroundWide, Canvas.SizeX, Canvas.SizeY,,,0.625f,0.703125f);
			Canvas.DrawRect(2048, 1024, BackgroundHD);
			StartY=320;
			Scale=0.85f;
		}
		else
		{
			//Canvas.DrawMaterialTile(ShellBackGround, Canvas.SizeX, Canvas.SizeY,,,,0.703125f);
			Canvas.DrawRect(Canvas.SizeX, Canvas.SizeY * 1.422f, Background);
			StartY=Canvas.SizeY / 2 - Canvas.SizeY / 8;
			if (Canvas.SizeX <= 640)
				Scale=0.65f;
			else if (Canvas.SizeX <= 800)
				Scale=0.75f;
			else if (Canvas.SizeX <= 1024)
				Scale=0.85f;
			else
				Scale=0.85f;
		}
        
		for (i = 0; i < MapInfoList.Length; i++)
		{
			/*Canvas.SetDrawColor( 255, 255, 255, 255 );
			if (LevelSelect == i)
			{
				Canvas.SetPos(40*ratioX, ((i*(TextSizeY+25))+250)*ratioY);
				Canvas.DrawRect(TextSizeX+(20*ratioX), TextSizeY, MenuTextBG);
				Canvas.SetPos(32*ratioX, ((i*(TextSizeY+25))+250)*ratioY);
				Canvas.DrawRect(8*ratioX, TextSizeY, MenuTextCornerL);
				Canvas.SetPos(TextSizeX+(20*ratioX), ((i*(TextSizeY+25))+250)*ratioY);
				//Canvas.DrawRect(-8*ratioX+50, TextSizeY, MenuTextCornerR);
				//Canvas.SetDrawColor( 0, 0, 0, 255 );
			}
			Canvas.SetPos(50*ratioX, ((i*(TextSizeY+25))+250)*ratioY);
			Canvas.DrawText(MapInfoList[i].Caption);*/

			//Need to draw a header
			/*if (i % 2 == 0 && i < 5)
			{
				Canvas.SetPos(Canvas.SizeX / 2 - 256*Scale, StartY + 55*i*Scale + 20*Scale);
				if (i == 0)
					Canvas.DrawRect(512*Scale, 64*Scale, Texture2D'HUD_Materials.title_nym13');
				else if (i == 2)
					Canvas.DrawRect(512*Scale, 64*Scale, Texture2D'HUD_Materials.title_nybm13');
				else if (i == 4)
					Canvas.DrawRect(512*Scale, 64*Scale, Texture2D'HUD_Materials.title_csm12');
				StartY += 70 * Scale;
			}*/

			Canvas.SetPos(Canvas.SizeX / 2 - 128*Scale, StartY + 55*i*Scale);
			//Canvas.DrawMaterialTile(MapInfoList[i].UnImage, 256, 64);
			if (LevelSelect == i)
				Canvas.DrawRect(256*Scale, 64*Scale, MapInfoList[i].OverImage);
			else
				Canvas.DrawRect(256*Scale, 64*Scale, MapInfoList[i].UnImage);
		}

        //Canvas.SetPos(Canvas.SizeX/8.533,Canvas.SizeX/3.864);
        //Canvas.DrawMaterialTile(Buttons[LevelSelect], Canvas.SizeX/2, Canvas.SizeX/2);
        
        Canvas.SetOrigin(0,0);
       
    }*/
}

// state PlayerVictory
// {
// 	simulated event BeginState(name PreviousStateName)
// 	{
//         timer = 0.f;
//         alpha = 0.f; 
//         TPC.Pause();
//         
// 	}
// 	simulated event EndState(name NextStateName)
// 	{
// 	    TPC.Pause();
// 	}
// 
// 	event Tick(float DeltaTime)
// 	{
// 	    ResultTimer+=DeltaTime;
// 
//         if(alpha <= alphaMax)
//         {
//             timer+=DeltaTime; 
//             alpha = alpha + (alphaMax /(fadeIn / timer));
//         }
//        
// 		if(timer > fadeIn)
// 		{
// 			//time's up
// 			alpha = alphaMax;
// 		}
// 		
//         if(ResultTimer >= MaxResultScreenTimer)      
//         {
//            ResultTimer=0;
//            GotoState('Active');
//         }
// 	}	 
// 	
// 	
// 	function PostRender(Canvas Canvas)
// 	{
// 	    RenderVictoryScreen(Canvas);     
//     }
//     
//     function RenderVictoryScreen(Canvas Canvas)
//     {
//         Canvas.SetOrigin(0,0);
//         Canvas.SetDrawColor( 255, 255, 255, 255);
//         Canvas.SetPos(0,0);
//         
//         WinBackgroundMaterialInstance.SetScalarParameterValue('WinBGAlphaChannel', alpha);      
//         Canvas.DrawMaterialTile(WinBackgroundMaterialInstance, Canvas.SizeX, Canvas.SizeX);
//     }
//     
// 	event bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f )
// 	{
// 
// 		if( event == IE_Pressed )
// 		{
// 			if(Key == 'Enter' || Key == 'XboxTypes_A')
// 			{
// 			    GotoState('Active');
// 				return true;
// 			}   
// 		}
// 
// 		//absorb all input by returning true
// 		return true;
// 	}
// }
// 
// state PlayerFailure
// {
// 	simulated event BeginState(name PreviousStateName)
// 	{
//         timer = 0.f;
//         alpha = 0.f;       
//         TPC.Pause();
// 		TPC.GetUIController().OpenScene(TPGameOver, LocalPlayer(TPC.Player));
// 		GotoState('Inactive');
//   	}
// 	simulated event EndState(name NextStateName)
// 	{
// 	    TPC.Pause();
// 	}
// 
// 	event Tick(float DeltaTime)
// 	{
// 	    ResultTimer+=DeltaTime;
// 
//         if(alpha <= alphaMax)
//         {
//             timer+=DeltaTime; 
//             alpha = alpha + (alphaMax /(fadeIn / timer));
//         }
//        
// 		if(timer > fadeIn)
// 		{
// 			//time's up
// 			alpha = alphaMax;
// 		}
// 		
//         if(ResultTimer >= MaxResultScreenTimer)      
//         {
//            ResultTimer=0;
//            GotoState('Active');
//         }
// 	}
// 	
// 	
// 	function PostRender(Canvas Canvas)
// 	{
// 	    RenderFailureScreen(Canvas);     
//     }
//     
//     function RenderFailureScreen(Canvas Canvas)
//     {
//         Canvas.SetOrigin(0,0);
//         Canvas.SetDrawColor( 255, 255, 255, 255 );
//         Canvas.SetPos(0,0);
//         
//         LossBackgroundMaterialInstance.SetScalarParameterValue('LossBGAlphaChannel', alpha);      
//         Canvas.DrawMaterialTile(LossBackgroundMaterialInstance, Canvas.SizeX, Canvas.SizeX);
//     }
//     
// 	event bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f )
// 	{
// 		if( event == IE_Pressed )
// 		{
// 			if(Key == 'Enter' || Key == 'XboxTypes_A')
// 			{
// 				if (TPC.IsEditorActive())
// 				    GotoState('Active');
// 				else
// 				{
// 					TPC.GetUIController().OpenScene(TPGameOver, LocalPlayer(TPC.Player));
// 					GotoState('Inactive');
// 				
// /*					if (TPC.CheckPointExists())
// 					{
// 						GotoState('Inactive');
// 						TPC.RealLoadLastCheckpoint();
// 					}				
// 					else
// 					{
//   						TPC.ClientTravel("?Restart", TRAVEL_Relative);
// 						GotoState('Inactive');
// 					}*/
// 				}
// 				return true;
// 			}   
// 		}
// 
// 		//absorb all input by returning true
// 		return true;
// 	}
// } 

	
/**
 * Called when the Interaction is added to the GameViewportClient's Interactions array.
 */
function Initialized()
{ 
	InitBackgroundMaterialInstance();
    GotoState('Inactive');
    Super.Initialized();
	MapInfoList.Insert(MapInfoList.Length, 1);
	MapInfoList[MapInfoList.Length-1].Caption="Quit";
	MapInfoList[MapInfoList.Length-1].UnImage=QuitOff;
	MapInfoList[MapInfoList.Length-1].OverImage=QuitOn;
}

simulated function GetPlayerController(TPPlayerController PlayerController)
{
    TPC = PlayerController;
    m_thePawn = TPC.Pawn; 
}

function NotifyGameSessionEnded()
{
	GotoState('Inactive');
	
	m_thePawn = None;
	TPC = none;
    
	super.NotifyGameSessionEnded();
}

