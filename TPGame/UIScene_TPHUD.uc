class UIScene_TPHUD extends UIScene_BaseHudScene;

var UILabel AmmoCount;
var UILabel GrenadeCount;

var UIImage AmmoBar;
var UIImage StandingIcon;
var UIImage CrouchingIcon;
var UIImage SprintingIcon;
var UIImage FullHUD;

var TPPlayerController myTPC;
var TPHUD myTPHUD;

var float CurrentAmmoBarPct;

var float AmmoBarDefaultWidth;
var float AmmoBarDefaultUL;
var float AmmoBarPct;
var TextureCoordinates AmmoBarTextureCoords;

var bool bHUDOptionOn;
var bool bFadeWhenInactive;
var() float ShowHUDTime;
var float CurrShowHUDTime;

var WorldInfo myWorldInfo;

enum eStanceIcon
{
	StanceIcon_None,
	StanceIcon_Standing,
	StanceIcon_Crouching,
	StanceIcon_Sprinting
};

var eStanceIcon CurrStanceIcon;

struct WeapImgStruct
{
	var UIImage Image;
	var name ImageName;
	var name WeapClassName;
};

var array<WeapImgStruct> PriWeapImages;
var TPWeapon CurrPriWeapon;
var name CurrPriWeapClass;
var int CurrPriWeapIndex;

var array<WeapImgStruct> SecWeapImages;
var TPWeapon CurrSecWeapon;
var name CurrSecWeapClass;
var int CurrSecWeapIndex;
var float OldHeight;

var() float ShowObjectiveTime;

event InitScene()
{
	local LocalPlayer LocPlayer;
	local int i;

	super.InitScene();

	AmmoCount = UILabel(FindChild('AmmoCount', true));
	GrenadeCount = UILabel(FindChild('GrenadeCount', true));

	AmmoBar = UIImage(FindChild('bullets_notfired', true));
	StandingIcon = UIImage(FindChild('standing_icon', true));
	CrouchingIcon = UIImage(FindChild('crouch_icon', true));
	SprintingIcon = UIImage(FindChild('sprinting_icon', true));
	FullHUD = UIImage(FindChild('WeaponHUD', true));

	for (i = 0; i < PriWeapImages.Length; i++)
	{
		PriWeapImages[i].Image = UIImage(FindChild(PriWeapImages[i].ImageName, true));
		PriWeapImages[i].Image.ImageComponent.Fade(1.0f, 0.0f, 0.1f);
	}

	for (i = 0; i < SecWeapImages.Length; i++)
	{
		SecWeapImages[i].Image = UIImage(FindChild(SecWeapImages[i].ImageName, true));
		SecWeapImages[i].Image.ImageComponent.Fade(1.0f, 0.0f, 0.1f);
		SecWeapImages[i].Image.ImageComponent.SetColor(MakeLinearColor(1.0f, 1.0f, 1.0f, 1.0f));
	}

	CrouchingIcon.ImageComponent.Fade(1.0f, 0.0f, 0.1f);
	SprintingIcon.ImageComponent.Fade(1.0f, 0.0f, 0.1f);
	
	AmmoBarDefaultWidth = AmmoBar.GetPosition(UIFACE_Right);
	AmmoBarTextureCoords = AmmoBar.ImageComponent.StyleCustomization.Coordinates;
	AmmoBarDefaultUL = AmmoBar.ImageComponent.StyleCustomization.Coordinates.UL;

	//`log("AmmoBarDefaultWidth is"@AmmoBarDefaultWidth);
	//`log("AmmoBarDefaultUL is"@AmmoBarDefaultUL);

	LocPlayer = GetPlayerOwner();
	myWorldInfo = GetWorldInfo();

	if (LocPlayer != None && LocPlayer.Actor != None)
	{
		myTPC = TPPlayerController(LocPlayer.Actor);
		myTPHUD = TPHUD(myTPC.myHUD);
	}

	SetVisibility(false);
	
	//`log("myTPC is"@myTPC);
}

function UpdateBottomDock()
{
	// Bottom docking seems to be jacked so screw it
	if (CurrentViewportSize.Y != OldHeight)
	{
		OldHeight = CurrentViewportSize.Y;
		;
		FullHUD.SetPosition(OldHeight - 150.0f, UIFACE_Top);
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	//This is kind of ridiculous but what're you gonna do
	if (myWorldInfo.Pauser == None && myTPC != None && myTPHUD != None && myTPC.Pawn != None && myTPHUD.bShowHud && 
		!myTPHUD.bFadeInScreen && bHUDOptionOn &&  PlayerPawn(myTPC.Pawn) != None && !PlayerPawn(myTPC.Pawn).bIsAimDownSight && 
		myTPC.Pawn.Weapon != None && ((bFadeWhenInactive && (CurrShowHUDTime > 0.0f)) || (!bFadeWhenInactive)))
	{
		//`log("Setting Visibility to true!");
		SetVisibility(true);

		UpdateAmmoCount();
		UpdateGrenadeCount();
		UpdateStanceIcon();
		UpdatePriWeaponImages();
		UpdateSecWeaponImages();
	}
	else
	{
		if ( IsVisible() && FadeDestination != 0.0f) 
		{
			//`log("Setting Visibility to false!");
			SetVisibility(false);
		}
	}

	if (myWorldInfo.Pauser == None)
	{
		UpdateBottomDock();
		if (CurrShowHUDTime > 0.0f)
		{
			CurrShowHUDTime -= DeltaTime;
		}

		if (AmmoBar.ImageComponent.FadeType == EFT_Pulsing)
		{
			FadeInHUD();
		}
	}
}

simulated function UpdateAmmoCount()
{
	local TPWeapon CurrentWeapon;
    local string s;
    
    CurrentWeapon = TPWeapon(myTPC.Pawn.Weapon);
    
    if(CurrentWeapon == none || AmmoCount == None)
	{
		AmmoCount.SetValue("0/0");
		UpdateAmmoBar(0.0f, true);
		return;
	}
	
	if (CurrentWeapon.IsA('Grenade_Persistent'))
		CurrentWeapon = TPWeapon(myTPC.PrevWeaponOnGrenade);

	if (CurrentWeapon != none)
	{
		// Update the LCD
		if (myTPC.GetLCDManager() != none)
			myTPC.GetLCDManager().UpdateWeaponInfo(CurrentWeapon);

		s = (CurrentWeapon.AmmoInMagazine @ "/"@ CurrentWeapon.AmmoCount);
		AmmoCount.SetValue(s);
		UpdateAmmoBar(float(CurrentWeapon.AmmoInMagazine)/CurrentWeapon.MagazineSize, CurrentWeapon.AmmoCount == 0);
	}
	else
	{
		AmmoCount.SetValue("0/0");
		UpdateAmmoBar(0.0f, true);
	}
}

simulated function UpdateAmmoBar(float NewPct, bool bLastMagazine)
{
	local UIComp_DrawImage TempComp;
	local UIComp_DrawString TempStringComp;

	if (NewPct == AmmoBarPct)
		return;

	TempComp = AmmoBar.ImageComponent;
	TempStringComp = AmmoCount.StringRenderComponent;

	//`log("Updating Ammo Bar for new pct"@NewPct);
	if (NewPct == 0.0f)
	{
		AmmoBarTextureCoords.UL = 0;
		AmmoBar.SetPosition(0.0f, UIFACE_Right);
		TempComp.SetCoordinates(AmmoBarTextureCoords);
		if (TempComp.FadeType != EFT_Pulsing)
		{
			TempComp.Pulse(1.0f, 0.0f, 5.0f);
			
			if (bLastMagazine)
			{
				TempComp.SetColor(MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f));
				TempStringComp.Pulse(1.0f, 0.0f, 5.0f);
				TempStringComp.SetColor(MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f));
			}
		}
	}
	else
	{
		AmmoBar.SetPosition(NewPct*AmmoBarDefaultWidth, UIFACE_Right);
		AmmoBarTextureCoords.UL = NewPct*AmmoBarDefaultUL;
		TempComp.SetCoordinates(AmmoBarTextureCoords);
		if (NewPct > 0.35f && TempComp.FadeType == EFT_Pulsing)
		{
			TempComp.Fade(0.0f, 1.0f, 0.0f);
			TempComp.SetColor(MakeLinearColor(1.0f, 1.0f, 1.0f, 1.0f));
			TempStringComp.Fade(0.0f, 1.0f, 0.0f);
			TempStringComp.SetColor(MakeLinearColor(1.0f, 1.0f, 1.0f, 1.0f));
		}
		else if (NewPct < 0.35f && TempComp.FadeType != EFT_Pulsing)
		{
			TempComp.Pulse(1.0f, 0.0f, 5.0f);
			if (bLastMagazine)
			{
				TempComp.SetColor(MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f));
				TempStringComp.Pulse(1.0f, 0.0f, 5.0f);
				TempStringComp.SetColor(MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f));
			}
		}
	}

	AmmoBarPct = NewPct;
}

simulated function UpdateGrenadeCount()
{
	local PlayerPawn myPawn;
	local Grenade_Persistent Item;

	myPawn = PlayerPawn(myTPC.Pawn);
	if (myPawn != None)
	{
		Item = TPInventoryManager(myPawn.InvManager).CurrentGrenade;
	}

	if( Item == None )
	{
		GrenadeCount.SetValue("0");
	}
	else
	{
		GrenadeCount.SetValue(string(Item.GetTotalAmmo()));
	}
}

simulated function UpdateStanceIcon()
{
	local PlayerPawn myPawn;
	local eStanceIcon NewStanceIcon;

	myPawn = PlayerPawn(myTPC.Pawn);

	if (myPawn.bIsCrouched)
		NewStanceIcon = StanceIcon_Crouching;
	else if (myTPC.bSprint)
		NewStanceIcon = StanceIcon_Sprinting;
	else
		NewStanceIcon = StanceIcon_Standing;

	if (NewStanceIcon != CurrStanceIcon)
	{
		if (NewStanceIcon == StanceIcon_Crouching)
		{
			CrouchingIcon.ImageComponent.Fade(0.0f, 1.0f, 0.5f);

			StandingIcon.ImageComponent.Fade(1.0f, 0.0f, 0.5f);
			
			SprintingIcon.ImageComponent.Fade(0.0f, 0.0f, 0.0f); //KMM totally turn off this one
		}
		else if (NewStanceIcon == StanceIcon_Sprinting)
		{
			SprintingIcon.ImageComponent.Fade(0.0f, 1.0f, 0.5f);

			StandingIcon.ImageComponent.Fade(1.0f, 0.0f, 0.5f);
			
			CrouchingIcon.ImageComponent.Fade(0.0f, 0.0f, 0.0f); //KMM totally turn off this one
			
		}
		else
		{
			StandingIcon.ImageComponent.Fade(0.0f, 1.0f, 0.5f);
			
			if (CurrStanceIcon == StanceIcon_Crouching)
			{
				CrouchingIcon.ImageComponent.Fade(1.0f, 0.0f, 0.5f);
				SprintingIcon.ImageComponent.Fade(0.0f, 0.0f, 0.0f); //KMM totally turn off this one
				
			}
			else if (CurrStanceIcon == StanceIcon_Sprinting)
			{
				SprintingIcon.ImageComponent.Fade(1.0f, 0.0f, 0.5f);
				CrouchingIcon.ImageComponent.Fade(0.0f, 0.0f, 0.0f); //KMM totally turn off this one
			}
		}

		CurrStanceIcon = NewStanceIcon;
	}
}

simulated function FadeInHUD()
{
	CurrShowHUDTime = ShowHUDTime;
	//`log("HUD is active!"@self);
}

simulated function UpdatePriWeaponImages()
{
	local name NewPriWeapClass;
	local int i;
	local TPWeapon CurrentWeapon, NextWeapon;
    
	NewPriWeapClass = '';

	if( myTPC != None && myTPC.Pawn != None && myTPC.Pawn.Weapon != None && TPWeapon(myTPC.Pawn.Weapon) != None)
	{
		CurrentWeapon = TPWeapon(myTPC.Pawn.Weapon);

		if (CurrentWeapon.IsA('Grenade_Persistent'))
		{
			CurrentWeapon = TPWeapon(myTPC.PrevWeaponOnGrenade);
			if (CurrentWeapon == None)
			{
				NextWeapon = TPWeapon(TPInventoryManager(myTPC.Pawn.InvManager).GetNextWeapon());
				myTPC.PrevWeaponOnGrenade = NextWeapon;
				CurrentWeapon = NextWeapon;
				;
			}
		}

		if (CurrentWeapon != CurrPriWeapon && !CurrentWeapon.IsA('Grenade_Persistent'))
		{
			for (i = 0; i < PriWeapImages.Length; i++)
			{
				if (CurrentWeapon.IsA(PriWeapImages[i].WeapClassName))
				{
					NewPriWeapClass = PriWeapImages[i].WeapClassName;
					break;
				}
			}

			if (NewPriWeapClass != CurrPriWeapClass && NewPriWeapClass != '')
			{
				if (CurrPriWeapIndex != -1)
				{
					PriWeapImages[CurrPriWeapIndex].Image.ImageComponent.Fade(1.0f, 0.0f, 0.5f);
				}

				CurrPriWeapIndex = i;

				PriWeapImages[CurrPriWeapIndex].Image.ImageComponent.Fade(0.0f, 1.0f, 0.5f);

				CurrPriWeapClass = NewPriWeapClass;
				CurrPriWeapon = CurrentWeapon;
			}
		}
	}
}

simulated function UpdateSecWeaponImages()
{
	local name NewSecWeapClass;
	local int i;
	local TPWeapon NextWeapon;
	local PlayerPawn myPawn;

	myPawn = PlayerPawn(myTPC.Pawn);
    
	NewSecWeapClass = '';
	NextWeapon = TPWeapon(TPInventoryManager(myPawn.InvManager).GetNextWeapon());

	if (NextWeapon != None && NextWeapon != CurrSecWeapon && !NextWeapon.IsA('Grenade_Persistent'))
	{
		for (i = 0; i < SecWeapImages.Length; i++)
		{
			if (NextWeapon.IsA(SecWeapImages[i].WeapClassName))
			{
				NewSecWeapClass = SecWeapImages[i].WeapClassName;
				break;
			}
		}

		if (NewSecWeapClass != CurrSecWeapClass && NewSecWeapClass != '')
		{
			if (CurrSecWeapIndex != -1)
			{
				SecWeapImages[CurrSecWeapIndex].Image.ImageComponent.Fade(1.0f, 0.0f, 0.5f);
			}

			CurrSecWeapIndex = i;

			SecWeapImages[CurrSecWeapIndex].Image.ImageComponent.Fade(0.0f, 1.0f, 0.5f);

			if ((NextWeapon.AmmoCount + NextWeapon.AmmoInMagazine) != 0)
				SecWeapImages[CurrSecWeapIndex].Image.ImageComponent.SetColor(MakeLinearColor(1.0f, 1.0f, 1.0f, 1.0f));
			else
				SecWeapImages[CurrSecWeapIndex].Image.ImageComponent.SetColor(MakeLinearColor(1.0f, 0.0f, 0.0f, 1.0f));

			CurrSecWeapClass = NewSecWeapClass;
			CurrSecWeapon = NextWeapon;
		}
	}
	else if (NextWeapon == None)
	{
		if (CurrSecWeapIndex != -1)
		{
			SecWeapImages[CurrSecWeapIndex].Image.ImageComponent.Fade(1.0f, 0.0f, 0.5f);
		}
		CurrSecWeapIndex = -1;
		CurrSecWeapClass = '';
		CurrSecWeapon = None;
	}
}

