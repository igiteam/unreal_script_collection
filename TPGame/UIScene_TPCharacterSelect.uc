class UIScene_TPCharacterSelect extends UIScene_BaseFrontEnd
	config(Game);

//enum eConnectionType
//{
//	CT_HOST,
//	CT_CLIENT,
//};
//var int ConnectionType;

var int CurrentSide;
var int CurrentPartisan;
var int CurrentNazi;

var int CurrentNaziWeapon;
var int CurrentPartisanWeapon;

var UILabel CharacterLabel;
var UILabel LoadoutLabel;
var UIImage TeamLogo;
var UILabel ToggleTeamLabel;
var UILabel BackLabel;
var UILabel WeaponDescLabel;
var UICheckbox DefaultDMCheckbox;

var Texture	AlliedImage;
var Texture	AxisImage;

//var StaticMesh AlliedMesh;
//var StaticMesh AxisMesh;

var config array<string> WeaponList;	// A local version of the WeaponList so we know which weapons are available in MP

//var UIScene SearchingScene;
//var UIScene HostSettings;
//var UIScene ConnectionDialog;

//var TPUIMeshWidget CharacterMesh, CharacterFGMesh, WeaponMesh, wTeamBannerMesh;
var UIImage wCharacterImage, wWeaponImage, wBackgroundImage, wTeamBannerImage;

// 0 - Partisan, 1 - Nazi
var int DMMeshCharacter;
var int DMWeap;

var bool bTeamGame;

var localized string ToggleTeamPC, ToggleTeam360, ToggleTeamPS3;
var localized string BackPC, Back360, BackPS3, BackPS3Circle;

// Weapon Descriptions
var localized string AmmoCountString;
var localized string FireRateString;
var localized string MagazineSizeString;
var localized string HitDamageString;

var EGameStatus PrevGameStatus;

event InitScene()
{
	local TPGameReplicationInfo GRI;

	GRI = TPGameReplicationInfo(GetWorldInfo().WorldInfo.GRI);
	if (GRI != none)
		PrevGameStatus = GRI.GameStatus;

	myTPC = GetPC();

	myTPC.ShowCrosshair(true);

	// If this is an online game, and we are in the lobby, we will need to know if this is a team game or a non-team game for loadout purposes
	if (GetWorldInfo().NetMode != NM_Standalone)
	{
		TPHUD(GetPC().myHUD).bShowHud = false;
		bTeamGame = GetPC().WorldInfo.GRI.GameClass.default.bTeamGame;
	}
	// In a standalone game, load our defaults from an .ini file	
	if (GetWorldInfo().NetMode == NM_Standalone)
	{
		CurrentPartisan = GetPC().ProfileSettings.GetAlliedMesh();
		CurrentNazi = GetPC().ProfileSettings.GetAxisMesh();
	}
	// In a multiplayer game, load our defaults from the replicated connection info that we send and receive back from the server
	else
	{
		CurrentPartisan	= GetPC().connectInfo.AllyMesh;
		CurrentNazi		= GetPC().connectInfo.AxisMesh;
	}

	//CharacterMesh = TPUIMeshWidget( FindChild( name( "Character" ), true ) );
	//CharacterFGMesh = TPUIMeshWidget( FindChild( name( "CharacterFG" ), true ) );
	//WeaponMesh = TPUIMeshWidget( FindChild( name( "Weapon" ), true ) );
	wCharacterImage = UIImage(FindChild(name("Character"), true ) );
	wWeaponImage = UIImage(FindChild(name("Weapon"), true ) );
	wBackgroundImage = UIImage(FindChild(name("Background"), true ) );
	//wTeamBannerMesh = UIImage(FindChild(name("Banner"), true ) );

	WeaponDescLabel = UILabel(FindChild( name( "WeaponDesc" ), true ) );
	WeaponDescLabel.SetValue("");

	// Same as above but for weapons...
	if (GetWorldInfo().NetMode == NM_Standalone)
	{
		CurrentPartisanWeapon = GetPC().ProfileSettings.GetAlliedWeapon();
		CurrentNaziWeapon = GetPC().ProfileSettings.GetAxisWeapon();
	}
	else
	{
		CurrentPartisanWeapon	= GetPC().connectInfo.AllyWeap;
		CurrentNaziWeapon		= GetPC().connectInfo.AxisWeap;
	}

	super.InitScene();

	// same as above but for DM
	if (GetWorldInfo().NetMode == NM_Standalone)
	{
		DMMeshCharacter		= GetPC().ProfileSettings.GetDMMesh();
		DMWeap				= GetPC().ProfileSettings.GetDMWeapon();
	}
	else
	{
		DMMeshCharacter		= GetPC().connectInfo.DMMesh;
		DMWeap				= GetPC().connectInfo.DMWeap;
	}

	// Initalize the Labels
	CharacterLabel = UILabel( FindChild( name( "CharacterLabel" ), true ) );
	LoadoutLabel = UILabel( FindChild( name( "LoadoutLabel" ), true ) );

	DefaultDMCheckbox = UICheckbox( FindChild( name( "DMCheckbox" ), true ) );
	
	//TeamLogo = UIImage( FindChild( name( "TeamLogo" ), true ) );
	
	//wTeamBannerMesh = TPUIMeshWidget( FindChild( name( "BGMEsh" ), true ) );

	BackLabel = UILabel( FindChild( name( "BackLabel" ), true ) );
	ToggleTeamLabel = UILabel( FindChild( name( "ToggleTeam" ), true ) );
	ToggleTeamLabel.SetVisibility(bTeamGame && GetWorldInfo().NetMode == NM_Standalone);

	if (GetWorldInfo().IsConsoleBuild())
	{
		if (GetWorldInfo().IsPS3Build())
		{
			if (!GetWorldInfo().UseCircleToAccept())
				BackLabel.SetDatastoreBinding(BackPS3);
			else
				BackLabel.SetDatastoreBinding(BackPS3Circle);

			ToggleTeamLabel.SetDatastoreBinding(ToggleTeamPS3);
		}
		else
		{
			BackLabel.SetDatastoreBinding(Back360);
			ToggleTeamLabel.SetDatastoreBinding(ToggleTeam360);
		}
	}
	else
	{
		if ( !myTPC.PlayerInput.bUsingGamepad)
		{
			BackLabel.SetDatastoreBinding(BackPC);
			ToggleTeamLabel.SetDatastoreBinding(ToggleTeamPC);
		}
		else
		{
			BackLabel.SetDatastoreBinding(Back360);
			ToggleTeamLabel.SetDatastoreBinding(ToggleTeam360);
		}
	}
	
	if (bTeamGame)
	{
		SetWeapon(0,CurrentPartisanWeapon);
		SetWeapon(1,CurrentNaziWeapon);

		if (GetPC().PlayerReplicationInfo.Team != none && GetPC().PlayerReplicationInfo.Team.TeamIndex != 255)
		{
			CurrentSide = GetPC().PlayerReplicationInfo.Team.TeamIndex;
		}
		
		if (CurrentSide == 0)
		{
			FillLoadoutLabel(CurrentPartisanWeapon);
			CharacterLabel.SetValue("  "$GetPC().PartisanList[CurrentPartisan].DisplayName);

			wBackgroundImage.SetValue(AlliedImage);
			//wTeamBannerMesh.Mesh.SetStaticMesh(AlliedMesh);
			SetMesh(0,GetPC().PartisanList[CurrentPartisan].CharacterClass);
		}
		else
		{
			FillLoadoutLabel(CurrentNaziWeapon);
			CharacterLabel.SetValue("  "$GetPC().NaziList[CurrentNazi].DisplayName);
			wBackgroundImage.SetValue(AxisImage);
			//wTeamBannerMesh.Mesh.SetStaticMesh(AxisMesh);
			SetMesh(1,GetPC().NaziList[CurrentNazi].CharacterClass);
		}
	}
	else
	{
		SetWeapon(0,DMWeap);
	
		if (DMMeshCharacter < GetPC().PartisanList.Length)
		{
			FillLoadoutLabel(DMWeap);
			CharacterLabel.SetValue("  "$GetPC().PartisanList[DMMeshCharacter].DisplayName);
			wBackgroundImage.SetValue(AlliedImage);
			//wTeamBannerMesh.Mesh.SetStaticMesh(AlliedMesh);
			SetMesh(0,GetPC().PartisanList[DMMeshCharacter].CharacterClass);
		}
		else
		{
			FillLoadoutLabel(DMWeap);
			CharacterLabel.SetValue("  "$GetPC().NaziList[DMMeshCharacter-GetPC().PartisanList.Length].DisplayName);
			wBackgroundImage.SetValue(AxisImage);
			//wTeamBannerMesh.Mesh.SetStaticMesh(AxisMesh);
			SetMesh(0,GetPC().NaziList[DMMeshCharacter-GetPC().PartisanList.Length].CharacterClass);
		}
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	local TPGameReplicationInfo GRI;
	
	GRI = TPGameReplicationInfo(WorldInfo.GRI);

	if (GRI != none && (GRI.GameStatus != GS_Lobby && GRI.GameStatus != GS_GameInProgress ))
	{
		TPHUD(TPPlayerController(GetPlayerOwner(0).Actor).myHUD).bShowHud = true;
		;
		if (PreviousMenuScene != none)
			PreviousMenuScene.Restore();

		SceneClient.CloseScene(self);
		return;
	}

	super.UpdateScene(DeltaTime, WorldInfo);
}

function FillLoadoutLabel(int ClassType)
{
	//local FireIntervalStarCount;
	//local DamageStarCount;

	local class<TPWeapon> WeaponClass;
	//local SkeletalMeshComponent SMC;
	local string WeaponDescription;
	local string FireRateStarCountStr, HitDamageStarCountStr;
	local int i, StarCount;
	//local float Percentage;
	
	// The weaponlist must be accessed internally through our config var, not through the gameInfo as that is not present while in MP as a client
	WeaponClass = class<TPWeapon>(FindObject(WeaponList[ClassType], class'Class'));
	
	/*Percentage = (WeaponClass.default.FireInterval[0]/1.4) * 100;

	StarCount = Percentage / 20;
	StarCount -= 5;
	if (StarCount <= 0)
		StarCount = 1;*/

	switch (WeaponClass.default.WeapID)
	{
	case 'MP50':
		StarCount = 4;
		break;
	case 'G47':
		StarCount = 3;
		break;
	case 'G47Sniper':
		StarCount = 2;
		break;
	case 'Thompson':
		StarCount = 5;
		break;
	case 'M1':
		StarCount = 3;
		break;
	case 'M14':
		StarCount = 4;
		break;
	case 'FG44':
		StarCount = 4;
		break;
	case 'Henry':
		StarCount = 1;
		break;
	}

	for (i = 0; i < StarCount; i++)
		FireRateStarCountStr $= "?";

	/*Percentage = (WeaponClass.default.InstantHitDamage[0]/120.5) * 100;

	StarCount = Percentage / 20;
	
	if (StarCount == 0)
		StarCount = 1;*/

	switch (WeaponClass.default.WeapID)
	{
	case 'MP50':
		StarCount = 2;
		break;
	case 'G47':
		StarCount = 4;
		break;
	case 'G47Sniper':
		StarCount = 5;
		break;
	case 'Thompson':
		StarCount = 2;
		break;
	case 'M1':
		StarCount = 4;
		break;
	case 'M14':
		StarCount = 3;
		break;
	case 'FG44':
		StarCount = 3;
		break;
	case 'Henry':
		StarCount = 5;
		break;
	}

	for (i = 0; i < StarCount; i++)
		HitDamageStarCountStr $= "?";

	LoadoutLabel.SetValue("  "$WeaponClass.default.WeapName);
	wWeaponImage.SetValue(WeaponClass.default.WeaponImage);
	//SMC = SkeletalMeshComponent(WeaponClass.default.Mesh);
	//WeaponMesh.SkeletalMeshComp.SetSkeletalMesh(SMC.SkeletalMesh);

	WeaponDescription = AmmoCountString$"  "$string(WeaponClass.default.AmmoCount)$"\n";
	WeaponDescription $= MagazineSizeString$"  "$string(WeaponClass.default.MagazineSize)$"\n";
	WeaponDescription $= FireRateString$"  "$FireRateStarCountStr$"\n";//string(WeaponClass.default.FireInterval[0])
	WeaponDescription $= HitDamageString$"  "$HitDamageStarCountStr$"\n";//string(int(WeaponClass.default.InstantHitDamage[0]))
	
	WeaponDescLabel.SetDatastoreBinding(WeaponDescription);
}

function SetWeapon(int Id, int ClassType)
{
	local class<TPWeapon> WeaponClass;
	//local SkeletalMeshComponent SMC;
	local string WeaponDescription;
	local string FireRateStarCountStr, HitDamageStarCountStr;
	local int i, StarCount;
	//local float Percentage;

	// The weaponlist must be accessed internally through our config var, not through the gameInfo as that is not present while in MP as a client
	WeaponClass = class<TPWeapon>(FindObject(WeaponList[ClassType], class'Class'));
	
	/*Percentage = (WeaponClass.default.FireInterval[0]/1.4) * 100;

	StarCount = Percentage / 20;
	StarCount -= 5;
	if (StarCount <= 0)
		StarCount = 1;*/

	switch (WeaponClass.default.WeapID)
	{
	case 'MP50':
		StarCount = 4;
		break;
	case 'G47':
		StarCount = 3;
		break;
	case 'G47Sniper':
		StarCount = 2;
		break;
	case 'Thompson':
		StarCount = 5;
		break;
	case 'M1':
		StarCount = 3;
		break;
	case 'M14':
		StarCount = 4;
		break;
	case 'FG44':
		StarCount = 4;
		break;
	case 'Henry':
		StarCount = 1;
		break;
	}

	for (i = 0; i < StarCount; i++)
		FireRateStarCountStr $= "?";

	/*Percentage = (WeaponClass.default.InstantHitDamage[0]/120.5) * 100;

	StarCount = Percentage / 20;
	
	if (StarCount == 0)
		StarCount = 1;*/

	switch (WeaponClass.default.WeapID)
	{
	case 'MP50':
		StarCount = 2;
		break;
	case 'G47':
		StarCount = 4;
		break;
	case 'G47Sniper':
		StarCount = 5;
		break;
	case 'Thompson':
		StarCount = 2;
		break;
	case 'M1':
		StarCount = 4;
		break;
	case 'M14':
		StarCount = 3;
		break;
	case 'FG44':
		StarCount = 3;
		break;
	case 'Henry':
		StarCount = 5;
		break;
	}

	for (i = 0; i < StarCount; i++)
		HitDamageStarCountStr $= "?";

	LoadoutLabel.SetValue("  "$WeaponClass.default.WeapName);
	wWeaponImage.SetValue(WeaponClass.default.WeaponImage);
	//SMC = SkeletalMeshComponent(WeaponClass.default.Mesh);
	//WeaponMesh.SkeletalMeshComp.SetSkeletalMesh(SMC.SkeletalMesh);

	WeaponDescription = AmmoCountString$"  "$string(WeaponClass.default.AmmoCount)$"\n";
	WeaponDescription $= MagazineSizeString$"  "$string(WeaponClass.default.MagazineSize)$"\n";
	WeaponDescription $= FireRateString$"  "$FireRateStarCountStr$"\n";//string(WeaponClass.default.FireInterval[0])
	WeaponDescription $= HitDamageString$"  "$HitDamageStarCountStr$"\n";//string(int(WeaponClass.default.InstantHitDamage[0]))
	WeaponDescLabel.SetDatastoreBinding(WeaponDescription);
}

function SetMesh(int Id, string CharacterName)
{
	local class<TPPawn> PClass;
	if (Len(CharacterName) > 0)
	{
		PClass = class<TPPawn>(FindObject("TPGame."$CharacterName, class'class'));
		if (PClass == none)
			PClass = class<TPPawn>(FindObject("TPGameContent."$CharacterName, class'class'));
		if (PClass != none)
		{
			wCharacterImage.SetValue(PClass.default.CharacterImage);
			//CharacterMesh.SkeletalMeshComp.SetSkeletalMesh(PClass.default.Mesh.SkeletalMesh);
			//CharacterFGMesh.SkeletalMeshComp.SetSkeletalMesh(PClass.default.Mesh.SkeletalMesh);
			
			//if (GetPC().WorldInfo.NetMode != NM_Standalone)
			//	GetPC().SetSkeletalMesh(PClass);
		}
	}
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	//local UIScene OpenedScene;

	if ( ((!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left') || (EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left')) && EventParms.EventType == IE_Pressed )
	{
		PlayUISound('NavigateLeft');

		// DM Settings
		if (!bTeamGame)
		{
			if (CurrentSelectedIndex == 0)
			{
				DMMeshCharacter--;

				if (DMMeshCharacter < 0)
				{
					DMMeshCharacter = GetPC().PartisanList.Length + GetPC().NaziList.Length - 1;
				}
				
				if (DMMeshCharacter < GetPC().PartisanList.Length)
				{
					//wTeamBannerMesh.Mesh.SetStaticMesh(AlliedMesh);
					//TeamLogo.SetValue(AlliedImage);
					wBackgroundImage.SetValue(AlliedImage);
					SetMesh(0,GetPC().PartisanList[DMMeshCharacter].CharacterClass);
					CharacterLabel.SetValue("  "$GetPC().PartisanList[DMMeshCharacter].DisplayName);
				}
				else
				{
					//wTeamBannerMesh.Mesh.SetStaticMesh(AxisMesh);
					//TeamLogo.SetValue(AxisImage);
					wBackgroundImage.SetValue(AxisImage);
					SetMesh(0,GetPC().NaziList[DMMeshCharacter-GetPC().PartisanList.Length].CharacterClass);
					CharacterLabel.SetValue("  "$GetPC().NaziList[DMMeshCharacter-GetPC().PartisanList.Length].DisplayName);
				}
				
				//GetPC().connectInfo.DMMesh = DMMeshCharacter;
			}
			else if (CurrentSelectedIndex == 1)
			{
				DMWeap--;
				if (DMWeap < 0)
				{
					DMWeap = WeaponList.Length-1;
				}
				
				//GetPC().connectInfo.DMWeap = DMWeap;
				
				SetWeapon(0,DMWeap);
			}
			return true;
		}
		
		// Team DM Settings
		switch (CurrentSide)
		{
			// Partisan
		case 0:
			if (CurrentSelectedIndex == 0)
			{
				CurrentPartisan--;

				if (CurrentPartisan < 0)
					CurrentPartisan = GetPC().PartisanList.Length - 1;

				SetMesh(0,GetPC().PartisanList[CurrentPartisan].CharacterClass);
				
				CharacterLabel.SetValue("  "$GetPC().PartisanList[CurrentPartisan].DisplayName);
				
				//GetPC().connectInfo.AllyMesh = CurrentPartisan;
			}
			else if (CurrentSelectedIndex == 1)
			{
				CurrentPartisanWeapon--;
				if (CurrentPartisanWeapon < 0)
				{
					CurrentPartisanWeapon = WeaponList.Length-1;
				}
					

				if (GetWorldInfo().NetMode == NM_Standalone)
				{
					GetPC().UpdateURL("AllyWeap", string(CurrentPartisanWeapon), true);
					GetPC().SaveConfig();
				}
				else
				{
					//GetPC().connectInfo.AllyWeap = CurrentPartisanWeapon;
				}
				SetWeapon(0,CurrentPartisanWeapon);
			}
			else if (CurrentSelectedIndex == 2)
			{

			}

			break;
			// Nazi
		case 1:
			if (CurrentSelectedIndex == 0)
			{
				CurrentNazi--;
				if (CurrentNazi < 0)
					CurrentNazi = GetPC().NaziList.Length - 1;

				SetMesh(1,GetPC().NaziList[CurrentNazi].CharacterClass);

				CharacterLabel.SetValue("  "$GetPC().NaziList[CurrentNazi].DisplayName);

				//GetPC().connectInfo.AxisMesh = CurrentNazi;
			}
			else if (CurrentSelectedIndex == 1)
			{
				CurrentNaziWeapon--;
				if (CurrentNaziWeapon < 0)
				{
					CurrentNaziWeapon = WeaponList.Length-1;
				}
					
				//GetPC().connectInfo.AxisWeap = CurrentNaziWeapon;

				SetWeapon(1,CurrentNaziWeapon);
			}
			else if (CurrentSelectedIndex == 2)
			{

			}
			break;

		}
		return true;
	}
	if ( ((!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right') || (EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right')) && EventParms.EventType == IE_Pressed )
	{
		PlayUISound('NavigateRight');

		// DM Settings
		if (!bTeamGame)
		{
			if (CurrentSelectedIndex == 0)
			{
				DMMeshCharacter++;

				if (DMMeshCharacter >= GetPC().PartisanList.Length+GetPC().NaziList.Length)
				{
					DMMeshCharacter = 0;
				}
				
				if (DMMeshCharacter >= GetPC().PartisanList.Length)
				{
					SetMesh(0,GetPC().NaziList[DMMeshCharacter-GetPC().PartisanList.Length].CharacterClass);
					CharacterLabel.SetValue("  "$GetPC().NaziList[DMMeshCharacter-GetPC().PartisanList.Length].DisplayName);
					//wTeamBannerMesh.Mesh.SetStaticMesh(AxisMesh);
					wBackgroundImage.SetValue(AxisImage);
				}
				else
				{
					SetMesh(0,GetPC().PartisanList[DMMeshCharacter].CharacterClass);
					CharacterLabel.SetValue("  "$GetPC().PartisanList[DMMeshCharacter].DisplayName);
					//wTeamBannerMesh.Mesh.SetStaticMesh(AlliedMesh);
					wBackgroundImage.SetValue(AlliedImage);
				}
				
				//GetPC().connectInfo.DMMesh = DMMeshCharacter;
			}
			else if (CurrentSelectedIndex == 1)
			{
				DMWeap++;
				if (DMWeap >= WeaponList.Length)
				{
					DMWeap = 0;
				}
					
				//GetPC().connectInfo.DMWeap = DMWeap;

				SetWeapon(0,DMWeap);
			}
			return true;
		}

		// Team DM
		switch (CurrentSide)
		{
			// Partisan
		case 0:
			if (CurrentSelectedIndex == 0)
			{
				CurrentPartisan++;

				if (CurrentPartisan >= GetPC().PartisanList.Length)
					CurrentPartisan = 0;

				SetMesh(0,GetPC().PartisanList[CurrentPartisan].CharacterClass);

				CharacterLabel.SetValue("  "$GetPC().PartisanList[CurrentPartisan].DisplayName);

				//GetPC().connectInfo.AllyMesh = CurrentPartisan;
			}
			else if (CurrentSelectedIndex == 1)
			{
				CurrentPartisanWeapon++;

				if (CurrentPartisanWeapon >= WeaponList.Length)
					CurrentPartisanWeapon = 0;

				//GetPC().connectInfo.AllyWeap = CurrentPartisanWeapon;
				
				SetWeapon(0,CurrentPartisanWeapon);
			}
			else if (CurrentSelectedIndex == 2)
			{
				if (DefaultDMCheckbox.IsChecked())
				{
					DMMeshCharacter = 1;
					DefaultDMCheckbox.SetValue(false);
				}
				else
				{
					DMMeshCharacter = 0;
					DefaultDMCheckbox.SetValue(true);
				}
			}
			break;
			// Nazi
		case 1:
			if (CurrentSelectedIndex == 0)
			{
				CurrentNazi++;
				if (CurrentNazi >= GetPC().NaziList.Length)
					CurrentNazi = 0;

				SetMesh(1,GetPC().NaziList[CurrentNazi].CharacterClass);

				CharacterLabel.SetValue("  "$GetPC().NaziList[CurrentNazi].DisplayName);

				//GetPC().connectInfo.AxisMesh = CurrentNazi;
			}
			else if (CurrentSelectedIndex == 1)
			{	
				CurrentNaziWeapon++;

				if (CurrentNaziWeapon >= WeaponList.Length)
					CurrentNaziWeapon = 0;

				//GetPC().connectInfo.AxisWeap = CurrentNaziWeapon;
				
				SetWeapon(1,CurrentNaziWeapon);
			}
			else if (CurrentSelectedIndex == 2)
			{
				if (DefaultDMCheckbox.IsChecked())
				{
					DMMeshCharacter = 0;
					DefaultDMCheckbox.SetValue(false);
				}
				else
				{
					DMMeshCharacter = 1;
					DefaultDMCheckbox.SetValue(true);
				}
			}

			break;

		}
		return true;
	}

	/*if ( bTeamGame && ((!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Space') || EventParms.InputKeyName == 'XboxTypeS_Y') && EventParms.EventType == IE_Released )
	{
		PlayUISound('Clicked');
		ActivateRemoteEvent('ChangeCharacterFocus');
		CurrentSide++;
		if (CurrentSide > 1)
			CurrentSide = 0;

		if (CurrentSide == 0)
		{
			if (DMMeshCharacter == 0)
				DefaultDMCheckbox.SetValue(true);
			else
				DefaultDMCheckbox.SetValue(false);

			FillLoadoutLabel(CurrentPartisanWeapon);
			CharacterLabel.SetValue("  "$GetPC().PartisanList[CurrentPartisan].DisplayName);
			TeamLogo.SetValue(AlliedImage);
			wTeamBannerMesh.Mesh.SetStaticMesh(AlliedMesh);
			SetMesh(0,GetPC().PartisanList[CurrentPartisan].CharacterClass);
		}
		else
		{			
			if (DMMeshCharacter == 1)
				DefaultDMCheckbox.SetValue(true);
			else
				DefaultDMCheckbox.SetValue(false);

			FillLoadoutLabel(CurrentNaziWeapon);
			CharacterLabel.SetValue("  "$GetPC().NaziList[CurrentNazi].DisplayName);
			TeamLogo.SetValue(AxisImage);
			wTeamBannerMesh.Mesh.SetStaticMesh(AxisMesh);
			SetMesh(1,GetPC().NaziList[CurrentNazi].CharacterClass);
		}
		return true;
	}*/
	// Go Back
	if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Enter') || EventParms.InputKeyName == 'XboxTypeS_A' ) && EventParms.EventType == IE_Released )
	{
		if (!GetWorldInfo().UseCircleToAccept())
			HandleAccept();
		else
			HandleBack();
		
		return true;
	}
	if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Escape') || EventParms.InputKeyName == 'XboxTypeS_B' ) && EventParms.EventType == IE_Released )
	{
		if (GetWorldInfo().UseCircleToAccept())
			HandleAccept();
		else
			HandleBack();

		return true;
	}

	return super.CustomInputKey(EventParms);
}

event HandleAccept()
{
	PlayUISound('SceneClosed');
		
	if (GetPC().WorldInfo.NetMode != NM_Standalone)
	{
		GetPC().connectInfo.AllyMesh = CurrentPartisan;
		GetPC().connectInfo.AxisMesh = CurrentNazi;

		GetPC().connectInfo.AllyWeap = CurrentPartisanWeapon;
		GetPC().connectInfo.AxisWeap = CurrentNaziWeapon;

		GetPC().connectInfo.DMMesh = DMMeshCharacter;
		GetPC().connectInfo.DMWeap = DMWeap;

		// Send upwards the Loadout settings
		GetPC().ServerChangeConnectionInfo(	GetPC().connectInfo.AxisMesh, GetPC().connectInfo.AxisWeap, GetPC().connectInfo.AllyMesh, 
											GetPC().connectInfo.AllyWeap, GetPC().connectInfo.DMMesh, GetPC().connectInfo.DMWeap		);

		// Setup hud if it needs to.
		if (TPGameReplicationInfo(GetPC().WorldInfo.GRI).GameStatus == GS_PostGame)
			TPHUD(GetPC().myHUD).bShowHud = false;
		else if (TPGameReplicationInfo(GetPC().WorldInfo.GRI).GameStatus >= GS_PreGame)
		{
			TPHUD(GetPC().myHUD).bShowHud = true;

			// If we arrived in the game when it already has begun then call restart on us.
			if (GetPC().IsInState('PlayerWaiting'))
				GetPC().ServerRestartPlayer();
		}
		else
			TPHUD(GetPC().myHUD).bShowHud = false;

		if (PreviousMenuScene != none)
			PreviousMenuScene.Restore();

		SceneClient.CloseScene(self);
	}
	else
	{
		DisplayMessageBox("<Strings:TPGame.UIScene_TPCharacterSelect.SaveTitle>", "<Strings:TPGame.UIScene_TPCharacterSelect.SaveMessage>");
	}
}

event HandleBack()
{
	PlayUISound('SceneClosed');
		
	if (GetPC().WorldInfo.NetMode != NM_Standalone)
	{
		// Setup hud if it needs to.
		if (TPGameReplicationInfo(GetPC().WorldInfo.GRI).GameStatus == GS_PostGame)
			TPHUD(GetPC().myHUD).bShowHud = false;
		else if (TPGameReplicationInfo(GetPC().WorldInfo.GRI).GameStatus >= GS_PreGame)
		{
			TPHUD(GetPC().myHUD).bShowHud = true;

			// If we arrived in the game when it already has begun then call restart on us.
			if (GetPC().IsInState('PlayerWaiting'))
				GetPC().ServerRestartPlayer();
		}
		else
			TPHUD(GetPC().myHUD).bShowHud = false;

		if (PreviousMenuScene != none)
			PreviousMenuScene.Restore();
	}

	SceneClient.CloseScene(self);
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (bReturnValue)
	{
		GetPC().ProfileSettings.SetAlliedMesh(CurrentPartisan);
		GetPC().ProfileSettings.SetAxisMesh(CurrentNazi);
		GetPC().ProfileSettings.SetAlliedWeapon(CurrentPartisanWeapon);
		GetPC().ProfileSettings.SetAxisWeapon(CurrentNaziWeapon);
		GetPC().ProfileSettings.SetDMMesh(DMMeshCharacter);
		GetPC().ProfileSettings.SetDMWeapon(DMWeap);
		GetPC().WriteProfile(true);
		SceneClient.CloseScene(self);
	}
}

event SceneDeactivated()
{
	;	
	Super.SceneDeactivated();
}

function NotifyGameSessionEnded()
{
	;
	Super.NotifyGameSessionEnded();
}

function CleanUp()
{
	GetPC().ClientForceGarbageCollection();
	GetPC().ShowCrosshair(true);

	;

	super.CleanUp();
}

