
class LCDManager extends Object;

enum eLCDPage
{
	LCD_SPLASH,		
	LCD_MAIN,
	LCD_MPSTATS,
	LCD_MPRANK,
	LCD_LOADING,
};

var LCDInterface LCD;

struct TWeaponInfo
{
	var string ImageSrc;
	var name WeapID;
	var name Image;
};

// Page LCD_MPMAIN and LCD_SPMAIN
var array<TWeaponInfo> WeaponImages;
var TWeaponInfo OldWeaponInfo;
var name WeaponImage;
var name WeaponTitle;
var name WeaponInfoText;
var name GrenadeImage;
var name GrenadeText;

// Page MPSTATS
var name KillsImage;
var name KillsText;
var name PointsImage;
var name PointsText;
var name DeathsImage;
var name DeathsText;
var name TimerText;

// Loading Screen Info
var name LoadingTitleImage;
var name LoadingText;

// PlayerController
var TPPlayerController PC;

function Initialize(TPPlayerController tPC)
{
	PC = tPC;
	LCD = class'GameEngine'.static.GetLCDInterface();

	if (LCD != none)
	{
		LCD.AddNumberOfPages(LCD_LOADING-1);
	}
	
	// Setup the Weapon Icons and Text
	SetupMainPage();
	SetupStatsPage();
	SetupLoadingScreen();
}


function SetupMainPage()
{
	local int i;
	if (LCD != none)
	{
		LCD.ModifyControlsOnPage(LCD_MAIN);

		for (i = 0; i < WeaponImages.Length; i++)
		{
			WeaponImages[i].Image = LCD.AddTexture(WeaponImages[i].ImageSrc);
			LCD.SetVisible(WeaponImages[i].Image, false);
		}
		WeaponTitle =  LCD.AddText(OT_STATIC_TEXT, TS_MEDIUM, LTA_LEFT, 125);
		LCD.SetOrigin(WeaponTitle, 2, 2);
		LCD.SetText(WeaponTitle, "");

		WeaponInfoText = LCD.AddText(OT_STATIC_TEXT, TS_SMALL, LTA_CENTER, 35);
		LCD.SetOrigin(WeaponInfoText, 120, 35);
		LCD.SetText(WeaponInfoText, "");
	}
}

function SetupStatsPage()
{
	if (LCD != none)
	{
		LCD.ModifyControlsOnPage(LCD_MPSTATS);
		
		// Kills
		KillsImage = LCD.AddTexture("kill_icon");
		LCD.SetOrigin(KillsImage, 0, 2);
		KillsText = LCD.AddText(OT_STATIC_TEXT, TS_SMALL, LTA_LEFT, 40);
		LCD.SetOrigin(KillsText, 15, 17);
		LCD.SetText(KillsText, "0");

		// Deaths
		DeathsImage = LCD.AddTexture("death_icon");
		LCD.SetOrigin(DeathsImage, 135, 2);
		DeathsText = LCD.AddText(OT_STATIC_TEXT, TS_SMALL, LTA_LEFT, 10);
		LCD.SetOrigin(DeathsText, 150, 27);
		LCD.SetText(DeathsText, "0");

		// Timer
		TimerText = LCD.AddText(OT_STATIC_TEXT, TS_MEDIUM, LTA_CENTER, 50);
		LCD.SetOrigin(TimerText, 40, 30);
		LCD.SetText(TimerText, "00:00");
	}
}

function SetupLoadingScreen()
{
	if (LCD != none)
	{
		LCD.ModifyControlsOnPage(LCD_LOADING);

		LoadingTitleImage = LCD.AddTexture("LCDLogo");
		LCD.SetOrigin(LoadingTitleImage, 0, 0);

		LoadingText =  LCD.AddText(OT_STATIC_TEXT, TS_MEDIUM, LTA_CENTER, 50);
		LCD.SetOrigin(LoadingText, 40, 18);
		LCD.SetText(LoadingText, "Loading");
	}
}

function UpdateStatsInfo()
{
	if (LCD != none && PC != none && PC.PlayerReplicationInfo != none)
	{
		LCD.ModifyControlsOnPage(LCD_MPSTATS);

		LCD.SetText(KillsText, string(PC.PlayerReplicationInfo.Kills));
		LCD.SetText(DeathsText, string(int(PC.PlayerReplicationInfo.Deaths)));
		LCD.SetText(TimerText, FormatTime(PC.timeRemaining));
	}
}

function UpdateWeaponInfo(TPWeapon W)
{
	if (LCD != none && W != none)
	{
		LCD.ModifyControlsOnPage(LCD_MAIN);
		SetWeaponImage(W);
		LCD.SetText(WeaponInfoText, W.AmmoInMagazine @ "/" @ W.AmmoCount);	
		LCD.SetText(WeaponTitle, W.WeapName);
	}
}

function ShowLoading()
{
	if (LCD != none)
	{
		LCD.ShowPage(LCD_LOADING);
	}
}

function ShowMainDisplay()
{
	if (LCD != none)
	{
		LCD.ShowPage(LCD_MAIN);
	}
}

function ShowSplash()
{
	if (LCD != none)
	{
		LCD.ShowPage(LCD_SPLASH);
	}
}

function string FormatTime( int Seconds )
{
	local int Minutes, Hours;
	local string Result;

	Seconds = int( Abs(Seconds) );

	if( Seconds > 3600 )
    {
        Hours = Seconds / 3600;
        Seconds -= Hours * 3600;
		Result = string(Hours)$":";
	}
	Minutes = Seconds / 60;
    Seconds -= Minutes * 60;

	if ( Minutes < 10 )
	{
		if ( Hours == 0 )
			Result = Result$"0";
		else
			Result = Result$"0";
	}
	Result = Result$Minutes$":";

	if ( Seconds < 10 )
	{
		Result = Result$"0";
	}
	Result = Result$Seconds;

	return Result;
}

function SetWeaponImage(TPWeapon W)
{
	local int i;

	if (LCD != none)
	{
		LCD.ModifyControlsOnPage(LCD_MAIN);

		for (i = 0; i < WeaponImages.Length; i++)
		{
			if (WeaponImages[i].WeapID == W.WeapID )
			{
				if (OldWeaponInfo.Image != '')
					LCD.SetVisible(OldWeaponInfo.Image, false);

				OldWeaponInfo = WeaponImages[i];
				LCD.SetVisible(WeaponImages[i].Image, true);
				break;
			}
		}
	}
}

