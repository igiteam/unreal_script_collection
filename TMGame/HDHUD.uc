//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDHUD extends TMHUD
native(HDGame);

var bool bHeavyInjury;
var TMVehicle CurrentVeh;


// font
var Font HUDFont;
var () Color FontColor;

var() Font ChineseFont;

//GFx Hud
var   HDGFxExitMenu   ExitMenuMoive;
var   HDGFxHUD  myGFxHUD;

// icon texture
var const Texture2D GameHudIconTexture;
var const Texture2D WeaponHudIconTexture;

//Countdown
var   float     CountdownTime;
var   bool      bCtdOnlySeconds;
var   bool      bCountdown;
var   vector2d  CtdLocation;
var   vector2d  CtdScale;


simulated event PostBeginPlay()
{
	super.PostBeginPlay();
}


exec function ShowExitMenu()
{
	// Toggle ExitMmenu
	ToggleExitMenu();
}

function ToggleExitMenu(optional bool bPauseGame = true)
{

	if ( ExitMenuMoive != none && ExitMenuMoive.bMovieIsOpen )
	{
		if(!PlayerOwner.IsDead())
			ExitMenuMoive.PlayCloseAnimation();
	}
	else
	{
		//CloseOtherMenus();
		if (ExitMenuMoive == None)
		{
			ExitMenuMoive = new class'HDGFxExitMenu';   //EM class
			ExitMenuMoive.MovieInfo = SwfMovie'HD_FrontEnd.HD_GFx_ExitMenu';
			ExitMenuMoive.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
			ExitMenuMoive.SetTimingMode(TM_Real);
		}
		ExitMenuMoive.Start();
		ExitMenuMoive.AddFocusIgnoreKey('Escape');
	}
}

function CompleteExitMenuClose()
{
		ExitMenuMoive.Close(false);// Keep the Pause Menu loaded in memory for reuse.
		PlayerOwner.SetPause(false);
}

function DrawGFxHUD()
{
		if (myGFxHUD == None)
		{
			myGFxHUD = new class'HDGFxHUD';   //EM class
			myGFxHUD.MovieInfo = SwfMovie'TM_HUD.TM_UI_Hud';
			myGFxHUD.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
		}
		myGFxHUD.Start();
}

function DrawHandshoot()
{
 if(myGFxHUD != none )
 {
	if ( myGFxHUD.bHeadShotOpen )
	{
		myGFxHUD.HeadShotPlayReplay();
	}
	else
	{
		myGFxHUD.HeadShotInit();
	}
 }
}

function DrawMGun(float TopOverload,float CurrOverload,optional bool  bOverload)
{

 if(myGFxHUD != none )
 {
  if(myGFxHUD.bMGunOpen)
  {
  myGFxHUD.MGunUpdata(TopOverload,CurrOverload,bOverload);
  }
  else
  {
  myGFxHUD.MGunInit();
  }
 }

}
function CloseMGun()
{
 if(myGFxHUD != none && myGFxHUD.bMGunOpen)
 {
  myGFxHUD.MGunClose();
 }

}
/**
 * The Main Draw loop for the hud.  Gets called before any messaging.  Should be subclassed
 */
function DrawHUD()
{
	Super.DrawHUD();
}

/**
 * This function is called to draw the hud while the game is still in progress.  You should only draw items here
 * that are always displayed.  If you want to draw something that is displayed only when the player is alive
 * use DrawLivingHud().
 */
function DrawGameHud()
{
	Super.DrawGameHud();

	if(TMPlayerOwner.IsDead())
		myGFxHUD.SetHealthInfo(0);

	DisplayCountdown();
}

/**
 * PostRender is the main draw loop.
 */
event PostRender()
{
	local HDMapInfo MI;

	Super.PostRender();
	if(!bShowHud) //Hack, show Subtitle even if not show hud
	{
		MI = HDMapInfo( WorldInfo.GetMapInfo() );
		if ( MI != none )
		{
			MI.SetTaskTip(10000.0);
		}
		DisplayKismetMessages();
	}
	else
	{
		DrawGFxHUD();//Init GFxHUD
	}

	if(myGFxHUD!=None)
		myGFxHUD.SetVisible(bShowHUD);
}

/**
 * Called from various functions.  It allows the hud to track when a hit is scored
 * and display any indicators.
 *
 * @Param   HitLoc      - The location to which the hit came at
 * @Param   Damage      - How much damage was done
 * @Param   DamageType  - Type of damage
 */
function DisplayHit(vector HitLoc, int Damage, class<DamageType> damageType)
{
	local Vector Loc;
	local Rotator Rot;
	local float DirOfHit_L;
	local vector AxisX, AxisY, AxisZ;
	local vector ShotDirection;
	local bool bIsInFront;
	local vector2D  AngularDist;
	local float PositionInQuadrant;
	local float Multiplier;
	local float DamageIntensity;
	local class<TMDamageType> TMDamage;
	local Pawn P;
	local HDPawn HDP;
	local LinearColor DestColor;

	if(TMPlayerOwner.bCinematicMode)
		return;

	if(PawnOwner != None && PawnOwner.Health > 0)
	{
		DamageIntensity = PawnOwner.InGodMode() ? 0.5 : float(Damage) / (100.0 + float(PawnOwner.Health));
	}
	else
	{
		//DamageIntensity = FMax(0.2, 0.02*float(Damage));
		ClearHitEffect();

		return;
	}

	//???????
	TMDamage = class<TMDamageType>(DamageType);
	if ( TMDamage == none || TMDamage.default.bLocationalHit )
	{
		// Figure out the directional based on the victims current view
		PlayerOwner.GetPlayerViewPoint(Loc, Rot);
		GetAxes(Rot, AxisX, AxisY, AxisZ);

		ShotDirection = Normal(HitLoc - Loc);
		bIsInFront = GetAngularDistance( AngularDist, ShotDirection, AxisX, AxisY, AxisZ);
		GetAngularDegreesFromRadians(AngularDist);

		Multiplier = 0.26f / 90.f;
		PositionInQuadrant = Abs(AngularDist.X) * Multiplier;

		// 0 - .25  UpperRight
		// .25 - .50 LowerRight
		// .50 - .75 LowerLeft
		// .75 - 1 UpperLeft
		if( bIsInFront )
		{
			DirOfHit_L = (AngularDist.X > 0) ? PositionInQuadrant : -1*PositionInQuadrant;
		}
		else
		{
			DirOfHit_L = (AngularDist.X > 0) ? 0.52+PositionInQuadrant : 0.52-PositionInQuadrant;
		}

		// Cause a damage indicator to appear
		DirOfHit_L = -1 * DirOfHit_L;
		FlashDamage(DirOfHit_L);
	}
	else
	{
		FlashDamage(0.1);
		FlashDamage(0.9);
	}

	// If the owner on the hoverboard, check against the owner health rather than vehicle health
	if (TGTurret(PawnOwner) != None)
	{
		P = TGTurret(PawnOwner).Driver;
	}
	else
	{
		P = PawnOwner;
	}

	if (DamageIntensity > 0 && HitEffect != None)
	{
		DamageIntensity = FClamp(DamageIntensity, 0.2, 1.0);
		if( P == None || P.Health <= 0 )
		{
			// long effect duration if killed by this damage
			HitEffectFadeTime = PlayerOwner.MinRespawnDelay * 2.0;
		}
		else
		{
			HitEffectFadeTime = default.HitEffectFadeTime * DamageIntensity;
		}

		HitEffectIntensity = 1.0;//default.HitEffectIntensity * DamageIntensity;
		//TMDamage = class<TMDamageType>(DamageType);
		//MaxHitEffectColor = /*(TMDamage != None && TMDamage.default.bOverrideHitEffectColor) ? TMDamage.default.HitEffectColor :*/ default.MaxHitEffectColor;

		HitEffectMaterialInstance.GetVectorParameterValue('HitColor', DestColor);
		DestColor.A = HitEffectIntensity;
		HitEffectMaterialInstance.SetVectorParameterValue('HitColor', DestColor);

		HitEffect.bShowInGame = true;
		bFadeOutHitEffect = true;

		if( TGGameSP_Base(WorldInfo.Game) != none )
		{
			HDP = HDPawn(P);
			if(HDP != none && HDP.Health <= 30)  //????
			{
				if(HDP.PlayerHeartRateAudio != none)
				{
					HDP.PlayerHeartRateAudio.Play();
				}

				bHeavyInjury = true;
			}
		}
	}
}

/**
 * Update Damage always needs to be called
 */
function UpdateDamage()
{
	local int i;
	local float HitAmount, Injury;
	local LinearColor HitColor, EyeColor;
	local HDPawn HDP;
	local TGTurret TGT;

	for (i=0; i<MaxNoOfIndicators; i++)
	{
		if (DamageData[i].FadeTime > 0)
		{
			DamageData[i].FadeValue += ( 0 - DamageData[i].FadeValue) * (RenderDelta / DamageData[i].FadeTime);
			DamageData[i].FadeTime -= RenderDelta;
			DamageData[i].MatConstant.SetScalarParameterValue(FadeParamName,DamageData[i].FadeValue);
		}
	}

	// Update the color/fading on the full screen distortion
	if(bFadeOutHitEffect)
	{
		HitEffectMaterialInstance.GetVectorParameterValue('HitColor', HitColor);
		HitAmount = HitColor.A - HitEffectIntensity * (RenderDelta / HitEffectFadeTime);

		if(HitAmount <= 0.0)
		{
			bFadeOutHitEffect = false;
			HitAmount = 0.0;
		}

		HitColor.A = HitAmount;
		HitEffectMaterialInstance.SetVectorParameterValue('HitColor', HitColor);
	}

	if(bHeavyInjury)
	{
		TGT = TGTurret(PawnOwner);
		HDP = (TGT != none && TGT.Driver != none) ? HDPawn(TGT.Driver) : HDPawn(PawnOwner);
		if(HDP != none)
		{
			Injury =  FClamp( 1.0 - float(HDP.Health) / HDP.DefaultHealth, 0, 1.0 );

			HitEffectMaterialInstance.GetVectorParameterValue('EyeColor', EyeColor);
			EyeColor.A = Injury;
			HitEffectMaterialInstance.SetVectorParameterValue('EyeColor', EyeColor);

			HDP.PlayerHeartRateAudio.SetFloatParameter(name("HeartRate"), Injury);

			if(HDP.Health == HDP.DefaultHealth || HDP.Health <= 0)
			{
				bHeavyInjury = false;
				HDP.PlayerHeartRateAudio.Stop();
			}
		}
	 }

	 if(HitEffect.bShowInGame && !bFadeOutHitEffect && !bHeavyInjury)
	 {
		 HitEffect.bShowInGame = false;
	 }

}

function ClearHitEffect()
{
	 local TGTurret TGT;
	 local HDPawn HDP;

	 HitEffect.bShowInGame = false;
	 bHeavyInjury = false;
	 bFadeOutHitEffect = false;

	 TGT = TGTurret(PawnOwner);
	 HDP = (TGT != none && TGT.Driver != none) ? HDPawn(TGT.Driver) : HDPawn(PawnOwner);
	 if(HDP != none)
		 HDP.PlayerHeartRateAudio.Stop();
}

//---------------------------------------------------------
// overwrite function
//---------------------------------------------------------
function DisplayScoring(){}
function DisplayClock() {}
function DisplayMap()
{
local HDMapInfo MI;

MI = HDMapInfo( WorldInfo.GetMapInfo() );
	if ( MI != none )
	{
	MI.DrawTaskTip();
	}
}

// display weapon
function DisplayWeapon()
{
	DisplayGFxWeapon();  //temp USE gfx
}

function DisplayGFxWeapon()
{
	local HDWeapon Weapon;
	local HDWeap_TurretBase TurretWeapon;
	local HDWeap_Grenade Grenade;
	local HDInventoryManager InvManager;
	local int AmmoBulletCount, GrenadeCount ;
	local float ClipBulletMax,ClipBulletCount;
	local string WeaponName;
//    local GFxObject.ASColorTransform Cxform;
	local int index;
	//Draw By GFxHUD
	if( PawnOwner != none )
	{
		Weapon = HDWeapon(PawnOwner.Weapon);
		if( Weapon != none )
		{
			InvManager = HDInventoryManager(Weapon.InvManager);
			Grenade = HDWeap_Grenade(Weapon);
			if ( Grenade != none && InvManager != none  )
			{
				Weapon = HDWeapon(InvManager.PreviousWeapon);
			}
				// Figure Bullet out if we should be pulsing
				WeaponName      = Weapon.PickupMessage;
				AmmoBulletCount = Weapon.AmmoBulletCount[Weapon.CurrentFireModeType];
				ClipBulletCount = Weapon.ClipBulletCount[Weapon.CurrentFireModeType];
				ClipBulletMax   = Weapon.default.ClipBulletCount[Weapon.CurrentFireModeType];
				myGFxHUD.SetWeaponInfo(AmmoBulletCount,ClipBulletCount,ClipBulletMax,WeaponName);
				for ( index = 0; index < InvManager.GrenadeWeapons.Length; ++index )
				{
					Grenade = InvManager.GrenadeWeapons[index];
					if ( Grenade != none )
					{
					   GrenadeCount = Grenade.AmmoBulletCount[0];
					   myGFxHUD.GrenadeCountText[index].SetText(GrenadeCount);
					}
					else
					{
					myGFxHUD.GrenadeCountText[index].SetText(0);
					}
				}

		}
		else
		{
			myGFxHUD.SetWeaponInfo(0,0,0,"");
		}
		if(HDTurret_Base(PawnOwner)!= None )
		{
		 TurretWeapon = HDWeap_TurretBase(PawnOwner.Weapon);
		 if( TurretWeapon.OverloadPerBullet > 0)
		 {
		  DrawMGun(TurretWeapon.TopOverload,TurretWeapon.CurrOverload,TurretWeapon.bOverload);
		  myGFxHUD.SetWeaponInfo(0,0,0,"??");
		 }
		}
		else if(myGFxHUD.bMGunOpen)
		{
		 CloseMGun();
		}
	}
}

function DrawLivingHud()
{

	// Pawn Doll
	if ( TMPawnOwner != none )  //bShowDoll &&
	{
		DisplayPawnDoll();
	}

	// display weapon
	// Manage the weapon.  NOTE: Vehicle weapons are managed by the vehicle
	// since they are integrated in to the vehicle health bar
	if( PawnOwner != none )
	{
		if ( bShowAmmo )
		{
			DisplayWeapon();
		}
	}
}

function DisplayPawnDoll()
{
	  local int Health;
	  local HDPawn_MP HDMP;

	  if(CurrentVeh != none)
	   Health = (CurrentVeh.Health/CurrentVeh.MaxHealth)*100.0;
	  else
	   Health = TMPawnOwner.Health;
	  myGFxHUD.SetHealthInfo(Health);
	   //Temp for Boss
	  foreach WorldInfo.AllPawns(class'HDPawn_MP', HDMP)
		{
		  if(HDMP.Health > 105)
		  {
			myGFxHud.SetBossHelth(HDMP.Health);
		  }
		}

}

function DisplayHealthGFx()
{
	  local int Health;

	  Health = TMPawnOwner.Health;
	  myGFxHUD.SetHealthInfo(Health);
}

//Given a input command of the form GBA_ and its mapping store that in a lookup for future use
function DrawDynamicTip(Canvas Cvs, PlayerController PC, string Command, string Tips, bool bDrawIcon, float X, float Y, TextureCoordinates iconTexcoord, float ResScale, optional Texture2D IconTexture = default.WeaponHudIconTexture, optional float Alpha=1.0, optional string commonStr = "???")
{
	local float Left, Down, XL,YL;
	local float ScaleX, ScaleY;
	local float WholeWidth;
	local string MappingStr; //String of key mapping
	local font OrgFont, BindFont;
	local string Key;

	//Catchall for spectators who don't need tooltips
	if (PC.PlayerReplicationInfo.bOnlySpectator || LastTimeTooltipDrawn == WorldInfo.TimeSeconds)
	{
		return;
	}

	//Only draw one tooltip per frame
	LastTimeTooltipDrawn = WorldInfo.TimeSeconds;

	OrgFont = Cvs.Font;

	//Get the fully localized version of the key binding
	TMPlayerController(PC).BoundEventsStringDataStore.GetStringWithFieldName(Command, MappingStr);
	if (MappingStr == "")
	{
	   ;
	   return;
	}

	TranslateBindToFont(MappingStr, BindFont, Key);

	if ( BindFont != none )
	{
		//These values might be negative (for flipping textures)
		ScaleX = abs(iconTexcoord.UL);
		ScaleY = abs(iconTexcoord.VL);
		Cvs.DrawColor = default.RedColor;
		Cvs.DrawColor.A = Alpha * 255;

		//Find the size of the string to be draw
		Cvs.Font = BindFont;
		Cvs.StrLen(Key, XL,YL);

		//Figure the offset from center for the left side
		WholeWidth = XL + (ScaleX * ResScale) + (default.ToolTipSepCoords.UL * ResScale);
		Left = X - (WholeWidth * 0.5);
		Down = Y + YL;

		//Center and draw the key binding string
		Cvs.SetPos(Left, Y - (YL * 0.5));
		Cvs.DrawText(Key, true, , , TextRenderInfo);

		// draw dynimac string
		Left += XL;
		Cvs.SetPos(Left, Y - (default.ToolTipSepCoords.VL * ResScale * 0.5));
		Cvs.Font = ChineseFont;
		Cvs.StrLen(commonStr$Tips, XL,YL);
		Cvs.DrawColor = default.WhiteColor;
		Cvs.SetPos(Left, Y - (YL * 0.5));
		Cvs.DrawText(commonStr$Tips, true, , , TextRenderInfo);

		// draw icon
		if ( bDrawIcon )
		{
			Cvs.SetPos(Left, Down );
			Cvs.DrawTile( IconTexture,ScaleX * ResScale, ScaleY * ResScale, iconTexcoord.U, iconTexcoord.V, iconTexcoord.UL, iconTexcoord.VL );
		}

	}

	Cvs.Font = OrgFont;
}

final function DisplayCountdown()
{
	local string TimeString, msString;
	local int s, ms;

	if(CountdownTime > -1.f)
	{
		CountdownTime = FMax(CountdownTime, 0.f);

		if(bCtdOnlySeconds)
		{
		   TimeString = string( FCeil(CountdownTime) );
		}
		else
		{
			s = int(CountdownTime);
			ms = int( (CountdownTime - s) * 1000 );
			if(ms > 99)
				msString = string(ms);
			else if(ms > 9)
				msString = "0"$string(ms);
			else
				msString = "00"$string(ms);

			TimeString = FormatTime(s) $ ":" $ msString;
		}

		Canvas.Font = GetFontSizeIndex(2);
		Canvas.DrawColor = WhiteColor;
		Canvas.SetPos(CtdLocation.X, CtdLocation.Y);
		Canvas.DrawText(TimeString, true, CtdScale.X, CtdScale.Y);

		if(CountdownTime == 0.f && bCountdown)
		{
		   CountdownTime = -1.f;
		}
	}
}

