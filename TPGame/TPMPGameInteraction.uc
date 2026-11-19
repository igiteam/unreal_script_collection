//=============================================================================
class TPMPGameInteraction extends Input
	deprecated;
	//within GameViewportClient
	//native
	//config(Game)
	//transient
	//inherits(FExec);

//var bool bIsActive;
//var TPPlayerController TPC;
//var Pawn m_thePawn;
//var TPPawn SelectedPawn;
//
//var config array<CharacterInfo> Characters;
//var array<CharacterInfo> PartisanList;
//var array<CharacterInfo> NaziList;
//var array<CharacterInfo> CivilianList;
//var array<string> TeamNames;
//var array<string> PlayerClassTypes;
//var int CharacterIndex;
//var int CurrentMenuItem;
//var int TeamIndex;
//var int PlayerClassType;
//var Texture2D LeftArrowTexture, RightArrowTexture;
//var bool bLeftPressed, bRightPressed;
//var config string TempServerIP;				// This is soooo temporary
//
//`define NATIVE_RES_X 1024.0
//`define NATIVE_RES_Y 768.0
//
//function PostRender(Canvas Canvas)
//{  
//}
//
//state Inactive
//{
//	simulated event BeginState(name PreviousStateName)
//	{
//		bIsActive = false;
//	}
//}
//
//function Toggle()
//{
//    if (bIsActive)
//    	GotoState('Inactive');
//    else
//    	GotoState('Active');
//}
//
//function SetMesh(string CharacterName)
//{
//	local class<TPPawn> PClass;
//	if (Len(CharacterName) > 0)
//	{
//		PClass = class<TPPawn>(DynamicLoadObject("TPGame."$CharacterName, class'class'));
//		if (PClass == none)
//			PClass = class<TPPawn>(DynamicLoadObject("TPGameContent."$CharacterName, class'class'));
//		if (PClass != none)
//			m_thePawn.Mesh.SetSkeletalMesh(PClass.default.Mesh.SkeletalMesh);		
//	}
//}
//
//function SetupCharacterMesh()
//{
//	switch (TeamIndex)
//	{
//	case T_PARTISAN:
//		SetMesh(PartisanList[CharacterIndex].CharacterClass);
//		break;
//	case T_NAZI:
//		SetMesh(NaziList[CharacterIndex].CharacterClass);
//		break;
//	}
//}
//
//function UpdateLoadOut(int ClassType)
//{
//	switch (ClassType)
//	{
//	case PCT_ASSAULT:
//		m_thePawn.InvManager.DiscardInventory();
//		TPC.CheatManager.GiveWeapon("TPGameContent.Thompson");
//		break;
//	case PCT_RIFLEMAN:
//		m_thePawn.InvManager.DiscardInventory();
//		TPC.CheatManager.GiveWeapon("TPGameContent.G47");
//		break;
//	case PCT_SNIPER:
//		m_thePawn.InvManager.DiscardInventory();
//		TPC.CheatManager.GiveWeapon("TPGameContent.G47Sniper");
//		break;
//	case PCT_SUPPORT:
//		m_thePawn.InvManager.DiscardInventory();
//		TPC.CheatManager.GiveWeapon("TPGameContent.MP50");
//		break;
//	case PCT_ANTITANK:
//		m_thePawn.InvManager.DiscardInventory();
//		TPC.CheatManager.GiveWeapon("TPGameContent.PanzerStrike");
//		break;
//	case PCT_MEDIC:
//		m_thePawn.InvManager.DiscardInventory();
//		TPC.CheatManager.GiveWeapon("TPGameContent.MP50");
//		break;
//	}
//	TPC.SetCameraMode('MenuFixed');
//	TPC.ClientSetDPG(false);
//}
//
//state Active
//{
//	simulated event BeginState(name PreviousStateName)
//	{
//	    bIsActive = true;
//	
//		ViewportConsole.GotoState('');
//		TPC.myHUD.bShowHud = false;
//		m_thePawn = TPC.Pawn;
//		SetMesh(Characters[0].CharacterClass);
//		//UpdateLoadOut(0);
//		TPC.SetCameraMode('MenuFixed');
//		TPC.ClientSetDPG(false);
//    	TPC.bIsThirdPerson = false;
//		TPC.TurnOffGogglesIfEnabled();
//		TPC.PlayerCamera.ViewTarget.Target = TPC.Pawn;
//		TPC.PlayerCamera.ViewTarget.POV.Location = TPC.Pawn.Location + (vect(350,0,0) >> TPC.Pawn.Rotation);
//		TPC.PlayerCamera.ViewTarget.POV.Rotation = TPC.Pawn.Rotation+rot(0,32768,0);
//	}
//	simulated event EndState(name NextStateName)
//	{
//		TPC.myHUD.bShowHud = true;
//		TPC.SetCameraMode('1st');
//		/*if (SelectedPawn != none)
//			SelectedPawn.Destroy();*/
//	}
//	
//	event bool InputAxis(int ControllerId,name Key,float Delta,float DeltaTime)
//	{
//		if(Key=='XboxTypeS_LeftX')
//		{
//			return true;
//		}
//		else if(Key=='XboxTypeS_LeftY')
//		{
//			return true;
//		}
//		else if(Key=='XboxTypeS_RightX')
//		{
//			return false;
//		}
//		else if(Key=='XboxTypeS_RightY')
//		{
//			return false;
//		}
//
//		return true;
//	}
//
//	event bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f )
//	{
//		local string SelectedName;
//
//		if( event == IE_Pressed )
//		{
//			if(Key == 'XboxTypeS_DPad_Left')
//			{
//				bLeftPressed = true;
//				switch (CurrentMenuItem)
//				{
//				case MI_TEAM:
//					TeamIndex--;
//					if (TeamIndex < 0)
//						TeamIndex = T_NAZI;
//					CharacterIndex = 0;
//					SetupCharacterMesh();
//					break;
//				case MI_CHARACTER:
//					CharacterIndex--;
//					if (CharacterIndex < 0)
//					{
//						if (TeamIndex == T_PARTISAN)
//							CharacterIndex = PartisanList.Length-1;
//						else if (TeamIndex == T_NAZI)
//							CharacterIndex = NaziList.Length-1;
//					}
//                    SetupCharacterMesh();
//					break;
//				case MI_PLAYERCLASSTYPE:
//					PlayerClassType--;
//					if (PlayerClassType < 0)
//						PlayerClassType = PlayerClassTypes.Length-1;
//					UpdateLoadOut(PlayerClassType);
//
//					break;
//				}
//				
//				return true;
//			}
//            else if(Key == 'XboxTypeS_DPad_Right')
//			{
//				bRightPressed = true;
//				switch (CurrentMenuItem)
//				{
//				case MI_TEAM:
//					TeamIndex++;
//					if (TeamIndex > TeamNames.Length-1)
//						TeamIndex = 0;
//					CharacterIndex = 0;
//					SetupCharacterMesh();
//					break;
//				case MI_CHARACTER:
//					CharacterIndex++;
//					if (TeamIndex == T_PARTISAN)
//					{
//						if (CharacterIndex > PartisanList.Length-1)
//							CharacterIndex = 0;
//					}
//					else if (TeamIndex == T_NAZI)
//					{
//						if (CharacterIndex > NaziList.Length-1)
//							CharacterIndex = 0;
//					}
//                    
//					SetupCharacterMesh();
//					break;
//				case MI_PLAYERCLASSTYPE:
//					PlayerClassType++;
//					if (PlayerClassType > PlayerClassTypes.Length-1)
//						PlayerClassType = 0;
//					UpdateLoadOut(PlayerClassType);
//					break;
//				}
//				return true;
//			}
//			else if(Key == 'XboxTypeS_DPad_Up')
//			{
//				CurrentMenuItem--;
//				if (CurrentMenuItem < 0)
//					CurrentMenuItem = 0;
//			}
//			else if(Key == 'XboxTypeS_DPad_Down')
//			{
//				CurrentMenuItem++;
//				if (CurrentMenuItem > 1)
//					CurrentMenuItem = 1;
//			}
//			else if(Key == 'XboxTypeS_A')
//			{
//				TPC.myHUD.bShowHud = true;
//				TPC.SetCameraMode('1st');
//				switch (TeamIndex)
//				{
//				case T_PARTISAN:
//					SelectedName = PartisanList[CharacterIndex].CharacterClass;
//					break;
//				case T_NAZI:
//					SelectedName = NaziList[CharacterIndex].CharacterClass;
//					break;
//				}
//				TPC.ClientTravel(TempServerIP$"?Character="$SelectedName$"?Team="$TeamIndex$"?SpectatorOnly", TRAVEL_Absolute);
//				Toggle();
//				return true;
//			}
//		}
//		else if (event == IE_Released)
//		{
//			if(Key == 'XboxTypeS_DPad_Left')
//				bLeftPressed = false;
//			else if (Key == 'XboxTypeS_DPad_Right')
//				bRightPressed = false;
//		}
//
//		//absorb all input by returning true
//		return true;
//	}
//
//             	   
//	function PostRender(Canvas Canvas)
//	{
//		local float X, Y;
//		local float XL, YL;
//		local float XT, YT;
//		local float BoxXOffset;
//		local string SelectedName;
//				
//		BoxXOffset = 35;
//		X = 32;
//		Y = 100;
//				
//		Canvas.SetPos(X + BoxXOffset, Y);
//		if (CurrentMenuItem == MI_TEAM)
//			Canvas.SetDrawColor(255,255,255,255);
//		else
//			Canvas.SetDrawColor(255,255,255,128);
//		Canvas.DrawBox(128, 32);
//		Canvas.SetDrawColor(255,255,0,255);
//		switch (TeamIndex)
//		{
//		case T_PARTISAN:
//			SelectedName = PartisanList[CharacterIndex].DisplayName;
//			Canvas.Strlen(TeamNames[T_PARTISAN], XT, YT);
//			Canvas.SetPos(X + BoxXOffset + 64-(XT*0.5), Y + 16 - (YT*0.5));
//            Canvas.DrawText(TeamNames[T_PARTISAN]);
//			break;
//		case T_NAZI:
//			SelectedName = NaziList[CharacterIndex].DisplayName;
//			Canvas.Strlen(TeamNames[T_NAZI], XT, YT);
//			Canvas.SetPos(X + BoxXOffset + 64-(XT*0.5), Y + 16 - (YT*0.5));
//			Canvas.DrawText(TeamNames[T_NAZI]);
//			break;
//		}
//		
//		// Check for Character selected
//		if (CurrentMenuItem == MI_CHARACTER)
//			Canvas.SetDrawColor(255,255,255,255);
//		else
//			Canvas.SetDrawColor(255,255,255,128);
//
//        // Draw the Box and put the Display Name for the character in it
//		Canvas.SetPos(X + BoxXOffset, Y + 45);
//		Canvas.DrawBox(128, 32);
//		Canvas.SetDrawColor(255,255,255,255);
//		Canvas.Strlen(SelectedName, XL, YL);
//		Canvas.SetPos(X + BoxXOffset + 64-(XL*0.5), Y + 45 + 16 - (YL*0.5));
//		Canvas.DrawText(SelectedName);
//
//		// Check for Class Type Selected or not
//		if (CurrentMenuItem == MI_PLAYERCLASSTYPE)
//			Canvas.SetDrawColor(255,255,255,255);
//		else
//			Canvas.SetDrawColor(255,255,255,128);
//
//		// Draw the Box and put the Class Type in it.
//		/*Canvas.SetPos(X + BoxXOffset, Y + 90);
//		Canvas.DrawBox(128, 32);
//		Canvas.SetDrawColor(255,255,255,255);
//		Canvas.Strlen(PlayerClassTypes[PlayerClassType], XT, YT);
//		Canvas.SetPos(X + BoxXOffset + 64-(XT*0.5), Y + 90 + 16 - (YT*0.5));
//		Canvas.DrawText(PlayerClassTypes[PlayerClassType]);*/
//		
//		// Set the Arrows to the correct menu item to change
//		Y = 45 * CurrentMenuItem + Y;
//		if (bLeftPressed)
//			Canvas.SetDrawColor(255,255,255,255);
//		else
//			Canvas.SetDrawColor(175,255,255,255);
//		Canvas.SetPos(X, Y);
//        Canvas.DrawTile(LeftArrowTexture, 32, 32, 0, 0, LeftArrowTexture.SizeX, LeftArrowTexture.SizeY);
//		
//		Canvas.SetPos( X+168, Y);
//		if (bRightPressed)
//			Canvas.SetDrawColor(255,255,255,255);
//		else
//			Canvas.SetDrawColor(175,255,255,255);
//        Canvas.DrawTile(RightArrowTexture, 32, 32, 0, 0, RightArrowTexture.SizeX, RightArrowTexture.SizeY);
//    }
//}
//	
///**
// * Called when the Interaction is added to the GameViewportClient's Interactions array.
// */
//function Initialized()
//{ 
//	local int i;
//	GotoState('Inactive');
//    Super.Initialized();
//
//	for (i = 0; i < Characters.Length; i++)
//	{
//		if (Characters[i].TeamID == T_PARTISAN)
//		{
//			PartisanList[PartisanList.Length] = Characters[i];
//		}
//		else if (Characters[i].TeamID == T_NAZI)
//		{
//			NaziList[NaziList.Length] = Characters[i];
//		}
//	}
//
//}
//
//simulated function GetPlayerController(TPPlayerController PlayerController)
//{
//    TPC = PlayerController;
//    m_thePawn = TPC.Pawn; 
//	//m_thePawn.SetHidden(true);
//}
//
//function NotifyGameSessionEnded()
//{
//	m_thePawn = None;
//	TPC = none;
//    
//	super.NotifyGameSessionEnded();
//}
//
//
//
//defaultproperties
//{
//	TeamNames(T_PARTISAN)="US"
//	TeamNames(T_NAZI)="THEM"
//	PlayerClassTypes(PCT_ASSAULT)="Assault"
//	PlayerClassTypes(PCT_SNIPER)="Sniper"
//	PlayerClassTypes(PCT_RIFLEMAN)="Rifleman"
//	PlayerClassTypes(PCT_SUPPORT)="Support"
//	PlayerClassTypes(PCT_ANTITANK)="Anti-Tank"
//	PlayerClassTypes(PCT_MEDIC)="Medic"
//    LeftArrowTexture=Texture2D'HUD_Materials.Textures.damage_indicator_left'
//    RightArrowTexture=Texture2D'HUD_Materials.Textures.damage_indicator_right'
//}    
//
