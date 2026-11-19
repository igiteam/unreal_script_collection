


class TPHUD extends HUD
	native
	config(Game)
    transient;






struct native DamageInfo
{
    var vector DamageDir;
    var float  Fade;
	var MaterialInstanceConstant MIC;

    structdefaultproperties
    {
        Fade=1.0f
    }
};

struct native GrenadeInfo
{
    var Actor  LiveGrenade;
    var float  Fade;
   	var MaterialInstanceConstant MIC;

    structdefaultproperties
    {
        Fade=1.0f
    }
};


var GrenadeInfo                GrenadeData[5];
var Material				   GrenadeMaterial;

var DamageInfo                 DamageData[15];
var Material				   DamageMaterial;

var Texture2D Reticule[4];
var Texture2D GrapplePromptIcon;
var Texture2D CrossHairDotTex;

var bool bInteractButton;
var bool bPickup;
var bool bUseButton;
var bool bLadderPrompt;
var bool bGrapplePrompt;
var bool bPipePrompt;
var bool bFadeInScreen;
var bool bDrawSniperView;
var float FadeScreenAlpha;
var string FadeInScreenText;
var int    MessageLifetime;   // # of seconds to stay in HUD message queue.
var float AnimDebugOffsetX;
var float AnimDebugOffsetY;
var Texture2D InteractButtonIcon;
var Texture2D PickupButtonIcon;
var Texture2D PickupButtonIconPS3;
var float     PrevSpread;

var MaterialInstanceConstant CompassDialMaterialInstance;
var MaterialInstanceConstant StaminaDialMaterialInstance;
var MaterialInstanceConstant HealthDialMaterialInstance;
var Material CompassDial;
var Material CompassRing;
var Material StaminaRing;
var Material HealthRing;





var Name     PickupText;
//var string   UseButtonText;

//var Texture2D InvMP50;
//var Texture2D InvPistol;
//var Texture2D InvLongRifle;
//var Texture2D InvLittleJoe;
//var Texture2D InvGrenade;
//var Texture2D InvNoWeapon;
var bool      bAllowReticleColorUpdate;
var int       ReticleBGColor;
var int       SelectedGrenade;
var Texture2D GrenadeBracket;
var Texture2D InvUpArrow;
var Texture2D InvDownArrow;

var config float CrosshairSize;
var config float CrosshairScale;
var config float CrosshairDistance;
var config float CrosshairLinearSpeed;
var config float CrosshairDistanceSpeed;
var config float CrosshairBaseSpread;

var config float InteractablesScale;
var config byte  InteractablesAlpha;

var float LerpSpread;


// Weapon Fire Type Texture
var Texture2D WeaponFireTypeTexures[3];
var bool bRenderWeaponFireTypes;
var float WeaponFireTypeAlpha;

var bool bOldShowHud;

// Checkpoint Stuff
var localized String CheckpointReachedString;// Localized text to show when we've hit a checkpoint
var float StartCheckpointStringTime;
var float StartChapterpointStringTime;
var localized String ChapterpointSavedString;// Localized text to show when we've hit a checkpoint
var const float TotalCheckpointDrawTime;

var localized string LoadingString;

/** Enum for HUD colors in Turning Point */
enum ETPHUDColor
{
	eTPHUDCOLOR_WHITE,
	eTPHUDCOLOR_RED,
	eTPHUDCOLOR_BLACK,
	eTPHUDCOLOR_WHITE_DK,
	eTPHUDCOLOR_TEAMRED,
	eTPHUDCOLOR_TEAMBLUE,
	eTPHUDCOLOR_CHATICONRED,
	eTPHUDCOLOR_CHATICONBLUE,
};

/** Values for safezone locations and viewport center */
var float SafeZoneLeft, SafeZoneRight, SafeZoneTop, SafeZoneBottom, SafeZoneFriendlyCenterX, SafeZoneFriendlyCenterY;

var localized string PickupHoldText;





//these should be adjusted depending on screen resolution...

























enum ECrosshairIFF
{
	IFF_Friendly,
	IFF_Foe,
	IFF_Neutral
};

var ECrosshairIFF LastIFF;


struct native HudElementDrawFlags
{
	var() bool bDrawCompass;
	var() bool bDrawInventory;
	var() bool bDrawAmmoCount;
	var() bool bDrawGrenades;
	var() bool bDrawCopyright;
	var() bool bDrawCrosshair;
	var() bool bDrawDamageIndicator;
	
	structdefaultproperties
	{
		bDrawCompass=false
		bDrawInventory=false
		bDrawAmmoCount=false
		bDrawGrenades=false
		bDrawCopyright=true
		bDrawCrosshair=true
		bDrawDamageIndicator=true
	}
	
};

var HudElementDrawFlags DrawFlags;

var string ChangelistString;
var bool bAttemptedToFindChangelistFile;

var Texture2D FallDamageIndicator;
var float FallDamageTotalTime;
var float FallDamageCurrTime;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native noexport function string GetBuildTimestampString();
native noexport function int GetCrosshairIFF(PlayerController PC);

native function INT GetKyEntitiesCurrentCount();
native function INT GetKyEntitiesMaxCount();

native function INT GetEntitiesCurrentCount();
native function INT GetEntitiesHighCount();
native function INT GetEntitiesTotalCount();

native function INT GetEntitiesFailCurrentCount();
native function INT GetEntitiesFailHighCount();
native function INT GetEntitiesFailTotalCount();

native function INT GetObstaclesCurrentCount();
native function INT GetObstaclesHighCount();
native function INT GetObstaclesTotalCount();
/* incorrect information
native function INT GetActionsCount();
native function INT GetActionsHighCount();
native function INT GetActionsTotalCount();
*/

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    InitCompassMaterialInstance();
    InitDamageMaterialInstance();
    InitGrenadeMaterialInstance();
    
    InitConsoleIcons();
}

function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType, optional float LifeTime )
{
	if ( bMessageBeep )
		PlayerOwner.PlayBeepSound();

	if ( (MsgType == 'Say') || (MsgType == 'TeamSay') )
		Msg = "<Fonts:EngineFonts.MediumFont>"$PRI.GetPlayerAlias()$": "$Msg$"<Fonts:/>";

	AddConsoleMessage(Msg,class'LocalMessage',PRI,LifeTime);
}

function SetHUDDrawColor( ETPHUDColor eColor, byte Alpha = 255 )
{
	switch ( eColor )
	{
		case eTPHUDCOLOR_WHITE:
			Canvas.SetDrawColor( 240, 240, 240, Alpha );
			break;

		case eTPHUDCOLOR_RED:
			Canvas.SetDrawColor( 170, 0, 0, Alpha );
			break;

		case eTPHUDCOLOR_BLACK:
			Canvas.SetDrawColor( 0, 0, 0, Alpha );
			break;

		case eTPHUDCOLOR_WHITE_DK:
			Canvas.SetDrawColor( 200, 200, 200, Alpha );
			break;

		case eTPHUDCOLOR_TEAMRED:
			Canvas.SetDrawColor( 205, 22, 22, Alpha );
			break;

		case eTPHUDCOLOR_TEAMBLUE:
			Canvas.SetDrawColor( 139, 255, 255, Alpha );
			break;

		case eTPHUDCOLOR_CHATICONRED:
			Canvas.SetDrawColor( 164, 63, 63, Alpha );
			break;

		case eTPHUDCOLOR_CHATICONBLUE:
			Canvas.SetDrawColor( 170, 192, 205, Alpha );
			break;
	}
}

function InitGrenadeMaterialInstance()
{
   local int i;

    for (i = 0; i < 5; i++)
	{
		GrenadeData[i].MIC = new(self) class'MaterialInstanceConstant';
		if (GrenadeData[i].MIC != none && GrenadeMaterial != none)
		{
			GrenadeData[i].MIC.SetParent(GrenadeMaterial);
		}

	}	
}

function InitDamageMaterialInstance()
{
   local int i;

    for (i = 0; i < 15; i++)
	{
		DamageData[i].MIC = new(self) class'MaterialInstanceConstant';
		if (DamageData[i].MIC != none && DamageMaterial != none)
		{
			DamageData[i].MIC.SetParent(DamageMaterial);
		}

	}	
}

function InitConsoleIcons()
{
	if (WorldInfo.IsPS3Build())
	{
		PickupButtonIcon=PickupButtonIconPS3;
	}
}

function InitCompassMaterialInstance()
{ 
    // set compass mat instance
    CompassDialMaterialInstance = new(Outer) class'MaterialInstanceConstant';
    CompassDialMaterialInstance.SetParent(CompassDial); 
    CompassDialMaterialInstance.SetScalarParameterValue('CompassRotator', 0);
    
    // set stamina mat instance
    StaminaDialMaterialInstance = new(Outer) class'MaterialInstanceConstant';
    StaminaDialMaterialInstance.SetParent(StaminaRing);
    StaminaDialMaterialInstance.SetVectorParameterValue('StaminaFade', MakeLinearColor(0,0,1,1));
    StaminaDialMaterialInstance.SetScalarParameterValue('StaminaRotator',0);
    
    // set health mat instance
    HealthDialMaterialInstance = new(Outer) class'MaterialInstanceConstant';
    HealthDialMaterialInstance.SetParent(HealthRing);
    HealthDialMaterialInstance.SetVectorParameterValue('HealthFade', MakeLinearColor(1,0,0,1));
    HealthDialMaterialInstance.SetScalarParameterValue('HealthRotator',0);
}

// Checkpoint-related Stuff

// Start drawing the text that tells the player that they've hit a checkpoint
final function StartDrawingCheckpointText()
{
	StartCheckpointStringTime = WorldInfo.TimeSeconds;
	PlaySound(SoundCue'S_Interface.Shell_Sounds.Checkpoint_Cue');
}

// Is the checkpointtext currently drawing?
final function bool CheckpointTextIsDrawing()
{
	return
	 ((WorldInfo.TimeSeconds - StartCheckpointStringTime) < TotalCheckpointDrawTime) && (StartCheckpointStringTime > 0);
}

// Start drawing the text that tells the player that they've hit a Chapterpoint
final function StartDrawingChapterpointText()
{
	StartChapterpointStringTime = WorldInfo.TimeSeconds;
}

// Is the Chapterpointtext currently drawing?
final function bool ChapterpointTextIsDrawing()
{
	return
	 ((WorldInfo.TimeSeconds - StartChapterpointStringTime) < TotalCheckpointDrawTime) && (StartChapterpointStringTime > 0);
}

simulated function GetSubtitleSize( out float Width, out float Height )
{
	if ( TPPlayerController(PlayerOwner).IsShowingSubtitles() )
	{
		Canvas.Font = class'Engine'.Static.GetMediumFont();
		Canvas.TextSize( "W", Width, Height );
	}
}

function DrawObjectiveBack(Texture2D Tex, int TU, int TV, int TUL, int TVL, int X, int Y, int XL, int YL)
{
	local float ScaleY;
	ScaleY = float(YL) / float(TVL);

	// left
	Canvas.SetPos(X,Y);
	Canvas.DrawTile(Tex,TUL/2,TVL*ScaleY,TU,TV,TUL/2,TVL);
	// right
	Canvas.SetPos(X+XL-TUL/2,Y);
	Canvas.DrawTile(Tex,TUL/2,TVL*ScaleY,TU+TUL/2,TV,TUL/2,TVL);
	// middle
	Canvas.SetPos(X+TUL/2,Y);
	Canvas.DrawTile(Tex,XL-TUL+1,TVL*ScaleY,TU+TUL/2,TV,1,TVL);
}


/** Draw the text that tells the player that they've hit a checkpoint; returns whether it drawed or not */
final function bool DrawCheckpointText()
{
	local float AlphaPercent, ElapsedTime, FontCalcX, FontCalcY, DrawX, DrawY, SubTitleW, SubTitleH;
	local bool result;

	ElapsedTime = WorldInfo.TimeSeconds - StartCheckpointStringTime;

	if ( CheckpointTextIsDrawing() )
	{
		if ( ElapsedTime > (TotalCheckpointDrawTime - 0.5f) )
		{
			AlphaPercent = (TotalCheckpointDrawTime - ElapsedTime) / 0.5f;
		}
		else
		{
			AlphaPercent = 1.f;
		}

		GetSubtitleSize( SubTitleW, SubTitleH );

		Canvas.Font = class'Engine'.Static.GetMediumFont();
		Canvas.TextSize( CheckpointReachedString, FontCalcX, FontCalcY );
		DrawX = Canvas.ClipX - SafeZoneRight - FontCalcX - 10;
		DrawY = Canvas.ClipY - SafeZoneBottom - FontCalcY - 10;
//		SetHUDDrawColor( eTPHUDCOLOR_BLACK, byte(255.f * AlphaPercent) );
//		DrawObjectiveBack(Texture2D'Warfare_HUD.WarfareHUD_main', 156, 29, 21, 19, DrawX-8, DrawY-2, FontCalcX+16, FontCalcY+4 );

		SetHUDDrawColor( eTPHUDCOLOR_WHITE, byte(255.f * AlphaPercent) );
		Canvas.SetPos( DrawX, DrawY );
		
		//`log(">>>>Checkpoint: orig=" @ Canvas.OrgX @ Canvas.OrgY @ "pos=" @ Canvas.CurX @ Canvas.CurY @ "clip=" @ Canvas.ClipX @ Canvas.ClipY @ "safe=" @ SafeZoneRight @ SafeZoneBottom @ "font=" @ FontCalcX @ FontCalcY);
		
		Canvas.DrawText( CheckpointReachedString );

		result = true;
	}

	ElapsedTime = WorldInfo.TimeSeconds - StartChapterpointStringTime;

	if ( ChapterpointTextIsDrawing() )
	{
		if ( ElapsedTime > (TotalCheckpointDrawTime - 0.5f) )
		{
			AlphaPercent = (TotalCheckpointDrawTime - ElapsedTime) / 0.5f;
		}
		else
		{
			AlphaPercent = 1.f;
		}

		GetSubtitleSize( SubTitleW, SubTitleH );

		Canvas.Font = class'Engine'.Static.GetMediumFont();
		Canvas.TextSize( ChapterpointSavedString, FontCalcX, FontCalcY );
		DrawX = Canvas.ClipX - SafeZoneRight - FontCalcX - 10;
		DrawY = Canvas.ClipY - SafeZoneBottom - FontCalcY - 10;
//		SetHUDDrawColor( eTPHUDCOLOR_BLACK, byte(255.f * AlphaPercent) );
//		DrawObjectiveBack(Texture2D'Warfare_HUD.WarfareHUD_main', 156, 29, 21, 19, DrawX-8, DrawY-2, FontCalcX+16, FontCalcY+4 );

		SetHUDDrawColor( eTPHUDCOLOR_WHITE, byte(255.f * AlphaPercent) );
		Canvas.SetPos( DrawX, DrawY );
		Canvas.DrawText( ChapterpointSavedString );

		result = true;
	}

	return result;
}






function DrawHUD()
{
 	local	float	XL,YL,Y, xPos,yPos, XL2, X;
	local	String	myText;

	local float inputX, inputY, inputW, inputH;

	local TPGameViewportClient VPClient;
	local PlayerPawn myPlayer;

	local vector inputVec;
	local float FontCalcX, FontCalcY;
	local string FullPickupText;

	VPClient = TPGameViewportClient(LocalPlayer(PlayerOwner.Player).ViewportClient);

	xPos = SizeX*(0.95);
	yPos = SizeY*0.05;

	if( DrawFlags.bDrawCopyright && (VPClient == None || (!VPClient.bDisableDiagnosticsAndCopyright && VPClient.ShouldDisplayDiagnostics()) ) )
	{
		myText = "Turning Point";
		Canvas.Font = class'Engine'.Static.GetSmallFont();
		Canvas.StrLen(myText, XL, YL);
		XL+=10;
		Y = YL*1.67;
		Canvas.SetPos( xPos - XL+1, yPos+YL*0.5+1);
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.DrawText(myText, true);

		Canvas.SetPos( xPos - XL, yPos+YL*0.5);
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.DrawText(myText, true);

		Canvas.SetDrawColor(250,250,100,255);
		myText = "2006 (C) Spark Unlimited";
		Canvas.Font = class'Engine'.Static.GetTinyFont();
		Canvas.StrLen(myText, XL, YL);
		XL+=10;
		Canvas.SetPos( xPos - XL, yPos+Y);
		Canvas.DrawText(myText, true);
		
		myText = "Build " @ GetBuildTimestampString();
		//myText = "Game Status:" @ TPGameReplicationInfo(WorldInfo.GRI).GameStatus;
		Canvas.Font = class'Engine'.Static.GetTinyFont();
		Canvas.StrLen(myText, XL, YL);
		XL+=10;
		Canvas.SetPos( xPos - XL, yPos+Y*1.67);
		Canvas.DrawText(myText, true);
	}

	if (TPGameReplicationInfo(WorldInfo.GRI) != none)
	{
		if (TPGameReplicationInfo(WorldInfo.GRI).DebugInfo != none)
		{
			if (TPGameReplicationInfo(WorldInfo.GRI).DebugInfo.GetDebugFlag(TPD_SHOWKYENTITIES))
			{
				myText = "ky.ent.current: " @ GetKyEntitiesCurrentCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 15;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.SetDrawColor(64, 255, 255, 255);
				Canvas.DrawText(myText, true);

				myText = "ky.ent.max: " @ GetKyEntitiesMaxCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 8;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.DrawText(myText, true);

				myText = "ent.current: " @ GetEntitiesCurrentCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 15;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawText(myText, true);

				myText = "ent.high: " @ GetEntitiesHighCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 8;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.DrawText(myText, true);

				myText = "ent.total: " @ GetEntitiesTotalCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 8;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.DrawText(myText, true);

				myText = "ent.fail current: " @ GetEntitiesFailCurrentCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 15;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.SetDrawColor(255, 64, 64, 255);
				Canvas.DrawText(myText, true);

				myText = "ent.fail high: " @ GetEntitiesFailHighCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 8;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.DrawText(myText, true);

				myText = "ent.fail total: " @ GetEntitiesFailTotalCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 8;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.DrawText(myText, true);

			}

			if (TPGameReplicationInfo(WorldInfo.GRI).DebugInfo.GetDebugFlag(TPD_SHOWKYOBSTACLES))
			{
				myText = "obs.current: " @ GetObstaclesCurrentCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 15;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.SetDrawColor(255, 128, 64, 255);
				Canvas.DrawText(myText, true);

				myText = "obs.high: " @ GetObstaclesHighCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 8;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.DrawText(myText, true);

				myText = "obs.total: " @ GetObstaclesTotalCount();
				Canvas.Font = class'Engine'.Static.GetSmallFont();
				Canvas.StrLen(myText, XL, YL);
				XL+=10;
				Y += 8;
				Canvas.SetPos( xPos - XL, yPos+Y*1.67);
				Canvas.DrawText(myText, true);

			}
			
			
			if (TPGameReplicationInfo(WorldInfo.GRI).DebugInfo.GetDebugFlag(TPD_SHOWSTICKY))
			{
				Canvas.Font = class'Engine'.Static.GetTinyFont();
			
				inputX = 10;
				inputY = 30;
			
				myText = "Turncurves enabled=" @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).TurnSpringData.bEnabled @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).LookSpringData.bEnabled ;
				Canvas.SetPos( inputX, inputY);
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawText(myText, true);


				inputX = 10;
				inputY += 15;
				myText = "Friction enabled=" @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).bTargetFrictionEnabled ;
				Canvas.SetPos( inputX, inputY);
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawText(myText, true);

				
				inputX = 10;
				inputY += 15;
				myText = "Adhesion enabled=" @ TPPlayerController(PlayerOwner).bTargetAdhesionEnabled @ "supersticky=" @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).bSuperAdhesionMode;
				Canvas.SetPos( inputX, inputY);
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawText(myText, true);
				
			
				//draw aTurn debug info
				
				myText = "aTurn=" @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).screen_aTurn @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).TurnSpringData.inputAccel @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).TurnSpringData.inputDecel @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).TurnSpringData.handsOffDecel;
			
				inputX = 10;
				inputY += 15;
				//Canvas.StrLen(myText, XL, YL);
				Canvas.SetPos( inputX, inputY);
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawText(myText, true);
				
				
				
				inputX = 10;
				inputY += 15;
				inputH = 10;
				inputW = ( abs(TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).screen_aTurn) * 600) / 1000;
				Canvas.SetPos( inputX, inputY );
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawRect( 600, inputH ); //BG
				
				
				Canvas.SetDrawColor(0,0,0,255);
				Canvas.SetPos( inputX + 1, inputY + 1 );
				Canvas.DrawRect( 600- 2, inputH - 2 ); //BLACK INTERIOR
				
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.SetPos( inputX, inputY );
				Canvas.DrawRect( inputW, inputH ); //DATA
				
				
				
				
				//draw aLookUp debug info
				
				myText = "aLookUp=" @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).screen_aLookUp @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).LookSpringData.inputAccel @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).LookSpringData.inputDecel @ TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).LookSpringData.handsOffDecel;
			
				inputX = 10;
				inputY += 30;
				Canvas.Font = class'Engine'.Static.GetTinyFont();
				//Canvas.StrLen(myText, XL, YL);
				Canvas.SetPos( inputX, inputY);
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawText(myText, true);
				
				
				
				inputX = 10;
				inputY += 15;
				inputH = 10;
				inputW = ( abs(TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).screen_aLookUp) * 600) / 1000;
				Canvas.SetPos( inputX, inputY );
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawRect( 600, inputH ); //BG
				
				
				Canvas.SetDrawColor(0,0,0,255);
				Canvas.SetPos( inputX + 1, inputY + 1 );
				Canvas.DrawRect( 600- 2, inputH - 2 ); //BLACK INTERIOR
				
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.SetPos( inputX, inputY );
				Canvas.DrawRect( inputW, inputH ); //DATA
				
				
				
				
				inputVec.X = abs(TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).screen_aLookUp);
				inputVec.Y = abs(TPPlayerInput(TPPlayerController(PlayerOwner).PlayerInput).screen_aTurn);
				inputY += 15;
				myText = "inputLen = " @ VSize(inputVec);
				Canvas.SetPos( inputX, inputY);
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawText(myText, true);


				inputX = 10;
				inputY += 15;
				inputH = 10;
				inputW = ( VSize(inputVec) * 600) / 1000;
				Canvas.SetPos( inputX, inputY );
				Canvas.SetDrawColor(255, 64, 255, 255);
				Canvas.DrawRect( inputW, inputH ); //DATA

				

			}
			
		}
	}


	//if(PlayerOwner != none && Pawn(PlayerOwner.ViewTarget) != none && !TPPlayerController(PlayerOwner).bIsThirdPerson)
	//{
	//	// Draw Temporary Crosshair
 //       LastIFF = GetCrosshairIFF(PlayerOwner);
	//	switch(LastIFF)
	//	{
	//		case IFF_Friendly:
	//			Canvas.SetDrawColor(0,255,0,255);
	//			break;
	//		case IFF_Foe:
	//			Canvas.SetDrawColor(255,0,0,255);
	//			break;
	//		case IFF_Neutral:
	//			Canvas.SetDrawColor(255,255,255,255);
	//			break;
	//	}

	//	Canvas.SetPos(CenterX - CrosshairSize, CenterY);
	//	Canvas.DrawRect(2*CrosshairSize + 1, 1);

	//	Canvas.SetPos(CenterX, CenterY - CrosshairSize);
	//	Canvas.DrawRect(1, 2*CrosshairSize + 1);
	//}
    





	myPlayer = GetPlayerOwnerPawn();
    
	if(bPickup && PickupButtonIcon != None && myPlayer != None && !myPlayer.bShellShockActive)
    {                                        
		// Hard coded goodness for now...
		
		Canvas.StrLen(PickupText, XL, YL);
		Canvas.StrLen(PickupHoldText, XL2, YL);
		
        
		Canvas.SetOrigin(0, Canvas.SizeY * 0.1f);
        
        Canvas.SetDrawColor(255,255,255,255);
		Canvas.Font = class'Engine'.Static.GetSmallFont();

		if (PlayerOwner.WorldInfo.IsConsoleBuild() || PlayerOwner.PlayerInput.bUsingGamepad)
		{
			Canvas.TextSize(PickupText, FontCalcX, FontCalcY);
			X = Canvas.ClipX - SafeZoneRight - FontCalcX;
			
			Canvas.SetPos( X, (60*0.5f)+-20);
			Canvas.DrawText(PickupText);
			
			X -= 1 + (PickupButtonIcon.SizeX * 0.5f);
			Canvas.SetPos( X, (60*0.5f)- 8 + -20);
			Canvas.DrawTile( PickupButtonIcon,
							 PickupButtonIcon.SizeX * 0.5f, 
							 PickupButtonIcon.SizeY * 0.5f,
							 0, 
							 0, 
							 PickupButtonIcon.SizeX, 
							 PickupButtonIcon.SizeY );
							 
							 

			Canvas.TextSize(PickupHoldText, FontCalcX, FontCalcY);
			X -= 1 + FontCalcX;
			Canvas.SetPos( X, (60*0.5f)+-20);			
			Canvas.DrawText(PickupHoldText);
		}
		else
		{
			FullPickupText = PickupHoldText @ "[" $ TPPlayerController(PlayerOwner).GetNonControllerBinding("Button bReload | OnRelease Reload") $ "]" @ PickupText;
			Canvas.TextSize(FullPickupText, FontCalcX, FontCalcY);
			Canvas.SetPos(Canvas.ClipX - SafeZoneRight - FontCalcX, (60*0.5f)+-20);
			Canvas.DrawText(FullPickupText);
		}
		
		//reset the origin
		Canvas.SetOrigin( 0, 0 );
	}

	//if(bUseButton)
 //   {                                        
	//	// Hard coded goodness for now...
 //       Canvas.SetOrigin( (Canvas.SizeX * `RIGHT_EDGE_PERCENT) - `HUD_W, Canvas.SizeY * `TOP_EDGE_PERCENT );
 //       Canvas.SetDrawColor(255,255,255,255);
	//	Canvas.SetPos( `PROMPT_X, `PROMPT_Y );
	//	Canvas.DrawTile( InteractButtonIcon,
 //                        InteractButtonIcon.SizeX * 0.4f, 
 //                        InteractButtonIcon.SizeY * 0.4f,
 //                        0, 
 //                        0, 
 //                        InteractButtonIcon.SizeX, 
 //                        InteractButtonIcon.SizeY );
 //       Canvas.Font = class'Engine'.Static.GetSmallFont();
 //       Canvas.SetPos( `PROMPT_X + InteractButtonIcon.SizeX* `HUD_SCALE + 5, `PROMPT_Y + 5);
 //       Canvas.DrawText(UseButtonText);

	//	//reset the origin
	//	Canvas.SetOrigin( 0, 0 );
	//}

    if(bInteractButton)
    {                                        
		// Hard coded goodness for now...
        Canvas.SetOrigin( (Canvas.SizeX * 0.9f) - (256*0.5f), Canvas.SizeY * 0.1f);
        Canvas.SetDrawColor(255,255,255,255);
		Canvas.SetPos( (0 *0.5f), (60*0.5f));
		Canvas.DrawTile( InteractButtonIcon,
                         InteractButtonIcon.SizeX* 0.5f, 
                         InteractButtonIcon.SizeY * 0.5f, 
                         0, 
                         0, 
                         InteractButtonIcon.SizeX, 
                         InteractButtonIcon.SizeY );
        Canvas.Font = class'Engine'.Static.GetMediumFont();
        Canvas.SetPos( (0 *0.5f)+ InteractButtonIcon.SizeX* 0.5f+ 5, (60*0.5f)+ 5);
        Canvas.DrawText("Interact");

		//reset the origin
		Canvas.SetOrigin( 0, 0 );
	}
    // Draw Copyright Notice

    // Draw HUD bits
    DrawHUDElements();
    
    
    
    
    
    
	if(bFadeInScreen)
	{
	    FadeInScreen();
	}
	//Do not render anything after the Fade screen.
}

// TODO: make the text fade in as well
function FadeInScreen()
{
	Canvas.SetDrawColor(0,0,0,FadeScreenAlpha);

	Canvas.SetPos(0, 0);
	Canvas.DrawRect(SizeX, SizeY);
	Canvas.SetOrigin(SizeX/8,5 * SizeY/6);
	Canvas.SetPos(0, 0);
    Canvas.Font = class'Engine'.Static.GetMediumFont();
    Canvas.SetDrawColor(255,255,255,FadeScreenAlpha);
    Canvas.DrawText(FadeInScreenText); 
    Canvas.SetOrigin(0,0);
}

function DrawWeaponFireType()
{
	local TPWeapon Weap;
	local int TexID;
	local float screenRatioX, screenRatioY;

	if (bRenderWeaponFireTypes)
	{
		screenRatioX = Canvas.SizeX / 1024.0;
		screenRatioY = Canvas.SizeY / 768.0;

		Weap = TPWeapon(TPPlayerController(PlayerOwner).Pawn.Weapon);
		TexID = Weap.SubFireTypes[Weap.CurrentSubFireType];

		Canvas.SetDrawColor(255,255,255,WeaponFireTypeAlpha);
		Canvas.SetPos( (0.78 * Canvas.SizeX), (0.75 * Canvas.SizeY) );
	    Canvas.DrawTile(WeaponFireTypeTexures[TexID], WeaponFireTypeTexures[TexID].SizeX*screenRatioX, WeaponFireTypeTexures[TexID].SizeY*screenRatioY, 0, 0, 128, 64);
		
		WeaponFireTypeAlpha -= PlayerOwner.WorldInfo.DeltaSeconds * 100;

		if (WeaponFireTypeAlpha <= 0)
		{
			WeaponFireTypeAlpha = 0;
			bRenderWeaponFireTypes = false;
		}
	}

	Canvas.SetDrawColor(255,255,255,255);
}

// Return Values
// 0 <T_Partisan> - Both players on Partisan Team
// 1 <T_Nazi>     - Both Teams on Nazi Team
// -1			  - Players are on different teams
function int IsOnSameTeam( int playerTeamID1, int playerTeamID2 )
{
	// If both players are on the same team, return the first player's Team ID
	if ( playerTeamID1 == playerTeamID2 )
		return playerTeamID1;

	// Not on same team
	return -1;

}

function DrawPlayerNames()
{
	local PlayerPawn P;
	local vector screenLoc, X, Y, Z, cameraLoc;
	local float colHeight;
	local rotator cameraRot;
	local float XL, YL, NL;
	local TPPlayerController TPC;
	local int sameTeamID;
	//local float camDistance;
	TPC = TPPlayerController(PlayerOwner);
	Canvas.SetDrawColor(255,255,255,255);
	Canvas.StrLen("X", XL, YL);

	
	ForEach DynamicActors(class'PlayerPawn', P)
	{
		
		if (P.PlayerReplicationInfo != none && TPC != none && TPC.Pawn != none && !P.IsInState('Dying') && TPC.CanSee(P))	// Check death, not health
		{
			screenLoc = Canvas.Project(P.Location);
			if (screenLoc.X >= 0 &&
				screenLoc.X < Canvas.ClipX &&
				screenLoc.Y >= 0 &&
				screenLoc.Y < Canvas.ClipY)
			{
				if (TPC.WorldInfo.GRI.GameClass.Default.bTeamGame)
				{
					// Are these player's on the same team?
					sameTeamID = IsOnSameTeam( P.PlayerReplicationInfo.Team.TeamIndex, TPC.Pawn.PlayerReplicationInfo.Team.TeamIndex);
				}

				TPC.GetPlayerViewPoint(cameraLoc, cameraRot);

				// If this net player and the local player are on the SAME team
				if ( TPC.WorldInfo.GRI.GameClass.Default.bTeamGame && ( sameTeamID != -1 )  )
				{
					// If this net player and the local player are BOTH on the Partisan team
					if ( sameTeamID == 0 )
					{
						// Show the Partisan logo
						if (P.teamIdentifierIconComponentPartisan != none)
						{
							P.teamIdentifierIconComponentPartisan.SetHidden(false);
							P.teamIdentifierIconComponentPartisan.SetTranslation(vect(0,0,200) );
						}
						// Hide the Nazi logo
						if (P.teamIdentifierIconComponentNazi != none)
							P.teamIdentifierIconComponentNazi.SetHidden(true);
					}
					// Since they ARE on the same team, but NOT on the partisan team, they must be on the NAZI team
					else
					{
						// Hide the Partisan logo
						if (P.teamIdentifierIconComponentPartisan != none)
							P.teamIdentifierIconComponentPartisan.SetHidden(true);

						// Show the Nazi logo
						if (P.teamIdentifierIconComponentNazi != none)
						{
							P.teamIdentifierIconComponentNazi.SetHidden(false);	
							P.teamIdentifierIconComponentNazi.SetTranslation(vect(0,0,200) );
						}
					}
					
				}
				else
				{
					// The net player and the local player are on DIFFERENT teams

					// Hide the "On Same Team" logo
					if (P.teamIdentifierIconComponentNazi != none)
						P.teamIdentifierIconComponentNazi.SetHidden(true);
					if (P.teamIdentifierIconComponentPartisan != none)
						P.teamIdentifierIconComponentPartisan.SetHidden(true);
				}
				

				if (vector(cameraRot) dot Normal(TPC.Pawn.Location - P.Location) < 0)
				{
					colHeight = P.CylinderComponent.CollisionHeight;
					Canvas.StrLen(P.PlayerReplicationInfo.PlayerName, NL, YL);
					GetAxes(cameraRot,X,Y,Z);
					screenLoc = Canvas.Project(P.Location + colHeight * Z);
					Canvas.SetPos(screenLoc.X-(NL*0.5),screenLoc.Y-(YL*2));

					// If we are targetting them, draw their name
					if ( TPC.LastAimTarget == p )
					{
						if ( TPC.WorldInfo.GRI.GameClass.Default.bTeamGame && ( sameTeamID != -1 ) )
						{
							// Green if on same team, red if not
							Canvas.SetDrawColor(0,255,0,255);
						}
						else
						{
							Canvas.SetDrawColor(255,0,0,255);
						}	
						Canvas.DrawTextClipped( P.PlayerReplicationInfo.PlayerName, false );
					}
	
					return;
				}
			}
		}
		else
		{
			// The net player and the local player are on DIFFERENT teams
			// Hide the "On Same Team" logo
			if (P.teamIdentifierIconComponentNazi != none)
				P.teamIdentifierIconComponentNazi.SetHidden(true);
			if (P.teamIdentifierIconComponentPartisan != none)
				P.teamIdentifierIconComponentPartisan.SetHidden(true);
		}
	}
}

function DrawMPElements()
{
	//local int seconds;
	//local string s;

	Canvas.SetPos(100, Canvas.ClipY - 75);
	Canvas.SetDrawColor(255,0,0,255);

	if (TPMPGameReplicationInfo(WorldInfo.GRI) != none && TPMPGameReplicationInfo(WorldInfo.GRI).GameStatus > GS_Lobby)
	{
		if ( WorldInfo.GRI.TimeLimit > 0 )
		{
			//seconds = TPPlayerController(PlayerOwner).timeRemaining;
			//seconds = WorldInfo.GRI.RemainingTime;
			//s = "Remaining:" @ seconds;
		}
		else
		{
			//seconds = TPPlayerController(PlayerOwner).timeElapsed;
			//seconds = WorldInfo.GRI.ElapsedTime;
			//s = "Elapsed:" @ seconds;
		}

		//Canvas.DrawText("In:" @ TPMPGameReplicationInfo(WorldInfo.GRI).GameStatus @s $ ", TimeLimit =" @ WorldInfo.GRI.TimeLimit $ ", ScoreLimit =" @ WorldInfo.GRI.GoalScore);
	}
}

function DrawHUDElements()
{
    //Testing the material rotation
    Canvas.SetDrawColor(255,255,255,255);
    Canvas.SetOrigin( 0, 0 );

    RenderDamageIndication();
	RenderFallDamageIndication();
    RenderGrenadeIndication();
      
	//RenderCompass();
    
	DrawWeaponFireType();

    // Draw Inventory Boxes
    //RenderInventoryBoxes();
    
    // Draw AmmoCount Text
    //DrawAmmoCounter();
    
	// Draw Grenades
	//DrawGrenades();

    //ReticleIndicationTick();

	// Draw Activatable Icons

    DrawCrossHair();

    DrawSniperView();

	RenderPawnDebugInfo();

	if (WorldInfo.NetMode != NM_Standalone)
		DrawPlayerNames();

	/*if (TPPlayerController(PlayerOwner).ObjInt != none)
		TPPlayerController(PlayerOwner).ObjInt.DrawNavPoints(Canvas);*/

	if (WorldInfo.NetMode != NM_Standalone)
		DrawMPElements();

    Canvas.SetOrigin(0,0);
}

function RenderPawnDebugInfo()
{
	//local TPPawn P;
	//local vector screenLoc, screenLocTL, screenLocBR, X, Y, Z, cameraLoc;
	//local float colHeight, colRadius;
	//local rotator cameraRot;
	//local float XL, YL;

	//Canvas.StrLen("X", XL, YL);

	//ForEach DynamicActors(class'TPPawn', P)
	//{
	//	screenLoc = Canvas.Project(P.Location);
	//	if (screenLoc.X >= 0 &&
	//		screenLoc.X < Canvas.ClipX &&
	//		screenLoc.Y >= 0 &&
	//		screenLoc.Y < Canvas.ClipY)
	//	{
	//		PlayerOwner.GetPlayerViewPoint(cameraLoc, cameraRot);

	//		if (vector(cameraRot) dot Normal(PlayerOwner.Pawn.Location - P.Location) < 0)
	//		{
	//			colHeight = P.CylinderComponent.CollisionHeight;
	//			colRadius = P.CylinderComponent.COllisionRadius;
	//			// figure out the actor size so that we can get a useful scale
	//			//GetAxes(rotator(trig.Location - cameraLoc),X,Y,Z);
	//			GetAxes(cameraRot,X,Y,Z);
	//			screenLocTL = Canvas.Project(P.Location + colHeight * Z - colRadius * Y);
	//			screenLocBR = Canvas.Project(P.Location - colHeight * Z + colRadius * Y);

	//			Canvas.SetPos(screenLocTL.X,screenLocTL.Y);
	//			Canvas.DrawText("Name: "@P.PlayerReplicationInfo.PlayerName);
	//			Canvas.SetPos(screenLocTL.X,screenLocTL.Y+YL);
	//			Canvas.DrawText("Physics: "@P.Physics);
	//			Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*2));
	//			if (P.CurrentWeaponAttachmentClass != none)
	//				Canvas.DrawText("Weapon: "@P.CurrentWeaponAttachmentClass.default.WeapID);
	//			else
	//				Canvas.DrawText("Weapon: None");
	//			Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*3));
	//			Canvas.DrawText("State: "@P.GetStateName());
	//			Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*4));
	//			Canvas.DrawText("AimOffset: "@P.AimOffset.Y);
	//			Canvas.SetPos(screenLocTL.X,screenLocTL.Y+(YL*5));
	//			Canvas.DrawText("Role: "@P.Role);
	//		}
	//	}
	//}
}

function GetPlayerYawRotation(out float NewRotation)
{
    NewRotation = (TPPlayerController(PlayerOwner).Rotation.Yaw) * 3.141592653/32768;  
}

function PlayerPawn GetPlayerOwnerPawn()
{
	local PlayerPawn lPlayerPawn;
	local Vehicle    lVehicle;
		
	lPlayerPawn = PlayerPawn(PlayerOwner.Pawn);
	if (lPlayerPawn == None)
	{
		lVehicle = Vehicle(PlayerOwner.Pawn);
		if (lVehicle != None)
		{
			lPlayerPawn = PlayerPawn(lVehicle.Driver);
		}
	}
	
	return lPlayerPawn;
}

function RenderCompass()
{
    local float HealthPct;
    local float StaminaPct;
    local float PlayerRotation;                               
	local float screenRatioX, screenRatioY;
	local PlayerPawn lPlayerPawn;
	local Turret lTurret;


	if( DrawFlags.bDrawCompass == false )
		return;

	lPlayerPawn = GetPlayerOwnerPawn();
	
	screenratioX = Canvas.SizeX / 1024.0;
	screenratioY = Canvas.SizeY / 768.0;

    // Draw Health Ring
    if (lPlayerPawn != None)
    {
	    HealthPct = lPlayerPawn.Health / lPlayerPawn.MaxPlayerHealth;
		HealthPct = (HealthPct * (-3.141592653) + 3.141592653);
	}
	else
	{
		HealthPct = 0; // 100% = -PI + PI
	}
    
    //Canvas.SetPos((0.04*Canvas.SizeX) - Canvas.SizeX/16, (0.80 * Canvas.SizeY) - Canvas.SizeX/16);
	Canvas.SetPos( 20* screenratioX, 570* screenratioY );
				  
	if ( HealthDialMaterialInstance != none )
	 HealthDialMaterialInstance.SetScalarParameterValue('HealthRotator',HealthPct);
    //Canvas.DrawMaterialTile(HealthDialMaterialInstance, Canvas.SizeX/4, Canvas.SizeX/4);
    Canvas.DrawMaterialTile(HealthDialMaterialInstance, 200* screenRatioY, 200* screenRatioY);

    
    
    // Draw Stamina Ring

    // For now, use the stamina ring to indicate the barrel's temperature for turrets.
    if (lPlayerPawn != none && PlayerOwner.Pawn.IsA('Turret'))
	{
		lTurret = Turret(PlayerOwner.Pawn);
		StaminaPct = lTurret.GetTemperature();
	}
	else
	    StaminaPct = (TPPlayerController(PlayerOwner).PlayerStaminaTime) / TPPlayerController(PlayerOwner).MaxPlayerStamina;
    StaminaPct = (StaminaPct * (3.141592653)) + 3.141592653;

    //Canvas.SetPos((0.04*Canvas.SizeX) - Canvas.SizeX/16, (0.80 * Canvas.SizeY) - Canvas.SizeX/16);
	Canvas.SetPos( 20* screenratioX, 570* screenratioY );

	if ( StaminaDialMaterialInstance != none )
		StaminaDialMaterialInstance.SetScalarParameterValue('StaminaRotator',StaminaPct);
    //Canvas.DrawMaterialTile(StaminaDialMaterialInstance, Canvas.SizeX/4, Canvas.SizeX/4);
    Canvas.DrawMaterialTile(StaminaDialMaterialInstance, 200* screenRatioY, 200* screenRatioY);


    
    // Draw Rotating Dial
    GetPlayerYawRotation(PlayerRotation);
    
    //Canvas.SetPos((0.04*Canvas.SizeX) - Canvas.SizeX/16, (0.80 * Canvas.SizeY) - Canvas.SizeX/16);
	Canvas.SetPos( 20* screenratioX, 570* screenratioY );
    
	if ( CompassDialMaterialInstance != none )
		CompassDialMaterialInstance.SetScalarParameterValue('CompassRotator', PlayerRotation);

    //Canvas.DrawMaterialTile(CompassDialMaterialInstance, Canvas.SizeX/4, Canvas.SizeX/4);
    Canvas.DrawMaterialTile(CompassDialMaterialInstance, 200* screenRatioY, 200* screenRatioY);



    
    // Draw Outer Ring
    //Canvas.SetPos((0.04*Canvas.SizeX), (0.80 * Canvas.SizeY));
	Canvas.SetPos( 20* screenratioX, 570* screenratioY );
    //Canvas.DrawMaterialTile(CompassRing, Canvas.SizeX/4, Canvas.SizeX/4);
    Canvas.DrawMaterialTile(CompassRing, 200* screenRatioY, 200* screenRatioY);

}

/**
 * Checks the owning player controller to see if assess mode is active,
 * and if so renders all objects in the interactable list.
 */
simulated function DrawCrossHair()
{
	local TPPlayerController pc;
	local Trigger trig;
	local Texture2D tex;
	local SeqEvent_Used evt;
	local SeqEvent_UsedTP TPevt;
	//local PlayerPawn Player;
	local float ScaledSize;
	
	if (PlayerOwner.Pawn == none)
		return;

	pc = TPPlayerController(PlayerOwner);

	//
	// When we are in aim down sight, we still need to do the checks to see whether or not
	// we can fire at an enemy.  Otherwise, if we aim at a friendly and move away, we cannot
	// fire.  Ideally, this check would not be done in a function that is supposed to just
	// draw a crosshair, and it should also be moved out of EvaluateCrosshairOptions, but this
	// is the safest spot for this time of the project.
	//
	if (PlayerOwner.Pawn.Weapon != None && TPWeapon(PlayerOwner.Pawn.Weapon).IsAimDownSight())
	{
		// Draw Temporary Crosshair
		LastIFF = ECrosshairIFF(GetCrosshairIFF(PlayerOwner));

		switch(LastIFF)
		{
			case IFF_Friendly:
                pc.SetAimPose(true);
				break;
			case IFF_Foe:
                pc.SetAimPose(false);
				break;
			case IFF_Neutral:
                pc.SetAimPose(false);
				break;
		}

		return; // don't draw anything when in ADS
	}

	Canvas.SetOrigin(0,0);
    Canvas.SetDrawColor(255,255,255,InteractablesAlpha);

	if (pc != None)
	{
		// If we have anything to interact with then draw the correct Icon
        if (bGrapplePrompt)
            tex = GrapplePromptIcon;
        else if (bLadderPrompt)
            tex = class'SeqEvent_UsedTP'.Default.InteractTextures[IT_Ladder];
        else if (bPipePrompt)
            tex = class'SeqEvent_UsedTP'.Default.InteractTextures[IT_Pipe];
        else if (bUseButton)
			tex = class'SeqEvent_UsedTP'.Default.InteractTextures[IT_Hand];
		else if (pc.InteractableList.Length > 0)
		{
			if (pc.HighlightedInteractable.InteractTrigger != none)
			{
				trig = pc.HighlightedInteractable.InteractTrigger;
				evt = pc.HighlightedInteractable.Event;
				if (trig != None &&
					evt != None)
				{
					TPevt = SeqEvent_UsedTP(evt);
					if (TPevt != none)
					{
						tex = TPevt.InteractTextures[TPevt.InteractType];
					}
					else
						tex = evt.InteractIcon;

					// If we are a door actor and we are locked, then we show the cool crosshair and not the hand icon.
					if (DoorActor(trig) != none && DoorActor(trig).bLocked)
					{
						if (EvaluateCrosshairOptions(pc))
						{
							pc.HighlightedInteractable.InteractTrigger = trig;
							DrawCoolCrossHair();
							return;
						}
					}
				}
			}
		}
        // Draw the Cross hair
		else if (EvaluateCrosshairOptions(pc))
		{
		    DrawCoolCrossHair();
            return;
		}

        // Didn't draw a cross, need to draw an interactable icon
        if (Tex != None)
        {
            ScaledSize = Tex.SizeX * InteractablesScale;  // SizeX == SizeY is a valid assumption here
            Canvas.SetPos(CenterX - ScaledSize/2, CenterY - ScaledSize/2);
            Canvas.DrawTexture(Tex, InteractablesScale);
        }
	}
}

simulated function bool EvaluateCrosshairOptions(TPPlayerController pc)
{
	local bool IsTurret;

	if (PlayerOwner.Pawn != None)
		IsTurret = PlayerOwner.Pawn.IsA('Turret');
	else
		IsTurret = FALSE;

	if (IsTurret || (PlayerOwner.Pawn.Weapon != None && !TPWeapon(PlayerOwner.Pawn.Weapon).IsAimDownSight()))
	{
		if(Pawn(PlayerOwner.ViewTarget) != none && (!pc.bIsThirdPerson || pc.IsInState('PlayerShielding') || IsTurret))
		{
			pc.HighlightedInteractable.InteractTrigger = None;

			// Draw Temporary Crosshair
			LastIFF = ECrosshairIFF(GetCrosshairIFF(PlayerOwner));

            /*if (WorldInfo.NetMode == NM_Standalone && TPPlayerController(PlayerOwner).LastAimTarget != None)
                LastIFF=IFF_Foe;*/

			switch(LastIFF)
			{
				case IFF_Friendly:
					Canvas.SetDrawColor(0,255,0,255);
                    pc.SetAimPose(true);
					break;
				case IFF_Foe:
					Canvas.SetDrawColor(255,0,0,255);
                    pc.SetAimPose(false);
					break;
				case IFF_Neutral:
					Canvas.SetDrawColor(255,255,255,255);
                    pc.SetAimPose(false);
					break;
			}
            //Canvas.SetDrawColor(255,ReticleBGColor,ReticleBGColor,255);

            //DrawCoolCrossHair();

            return true;
		}
	}
	return false;
}

simulated function DrawCoolCrossHair()
{
	local bool IsTurret;
    local float Spread, TexSize, AddedSpread, DeltaTime;
    local int   LeftX, RightX, TopY, BottomY, Offset, DeadOffset;
    local Turret Turret;
	local TPWeapon myTPWeapon;
	local float WeapCrosshairScale;

	if (!DrawFlags.bDrawCrosshair)
		return;

	IsTurret = PlayerOwner.Pawn.IsA('Turret');
	myTPWeapon = TPWeapon(PlayerOwner.Pawn.Weapon);
	
    if (PlayerOwner.Pawn != None && (myTPWeapon != None || IsTurret))
    {
        if (!IsTurret)
        {
		    Spread = myTPWeapon.GetSpread();
		}
		else
		{
			Turret = Turret(PlayerOwner.Pawn);
			Spread = Turret.GetTemperature() / 10.0f + 0.05f;
		}

        DeltaTime = WorldInfo.TimeSeconds - LastHUDRenderTime;

        if (Spread - LerpSpread > 0)
        {
            AddedSpread=(Spread-LerpSpread)/CrosshairDistanceSpeed;
            LerpSpread += AddedSpread * DeltaTime;
            LerpSpread += CrosshairLinearSpeed * DeltaTime;
            if (LerpSpread > Spread)
                LerpSpread = Spread;
        }
        else
        {
            AddedSpread=(LerpSpread-Spread)/CrosshairDistanceSpeed;
            LerpSpread -= AddedSpread * DeltaTime;
            LerpSpread -= CrosshairLinearSpeed * DeltaTime;
            if (LerpSpread < Spread)
                LerpSpread = Spread;
        }

        Offset     = Canvas.SizeX*LerpSpread*CrosshairDistance;
        DeadOffset = Canvas.SizeX*(CrosshairBaseSpread)*CrosshairDistance;

        Offset -= DeadOffset;
        if (Offset < 0)
            Offset = 0;

        PrevSpread = LerpSpread;
		if (myTPWeapon == None || !myTPWeapon.bUsingCustomCrosshair)
		{
			TexSize = Reticule[0].GetSurfaceWidth() * CrosshairScale;

			LeftX   = CenterX - TexSize - Offset;
			RightX  = CenterX                 + Offset;
			TopY    = CenterY - TexSize - Offset;
			BottomY = CenterY                 + Offset;

			Canvas.SetPos(LeftX, CenterY - TexSize/2);
			Canvas.DrawTexture(Reticule[0], CrosshairScale);

			Canvas.SetPos(RightX, CenterY - TexSize/2);
			Canvas.DrawTexture(Reticule[1], CrosshairScale);

			Canvas.SetPos(CenterX - TexSize/2, TopY);
			Canvas.DrawTexture(Reticule[2], CrosshairScale);

			Canvas.SetPos(CenterX - TexSize/2, BottomY);
			Canvas.DrawTexture(Reticule[3], CrosshairScale);

    		Canvas.SetPos(CenterX - (CrosshairSize*2), CenterY-(CrosshairSize*2));
			Canvas.DrawTile(CrosshairDotTex,CrosshairSize*4,CrosshairSize*4,0,0,GrapplePromptIcon.SizeX,GrapplePromptIcon.SizeY);
		}
		else
		{
			WeapCrosshairScale = myTPWeapon.CrosshairScale;

			if (myTPWeapon.CrosshairTextures[0] != None)
			{
				LeftX = CenterX - myTPWeapon.CrosshairTextures[0].GetSurfaceWidth() * WeapCrosshairScale - Offset;
				Canvas.SetPos(LeftX, CenterY - ((myTPWeapon.CrosshairTextures[0].GetSurfaceHeight() / 2))*WeapCrosshairScale);
				Canvas.DrawTexture(myTPWeapon.CrosshairTextures[0], WeapCrosshairScale);
			}

			if (myTPWeapon.CrosshairTextures[1] != None)
			{
				RightX = CenterX /*+ myTPWeapon.CrosshairTextures[1].GetSurfaceWidth() * WeapCrosshairScale*/ + Offset;
				Canvas.SetPos(RightX, CenterY - ((myTPWeapon.CrosshairTextures[1].GetSurfaceHeight() / 2))*WeapCrosshairScale);
				Canvas.DrawTexture(myTPWeapon.CrosshairTextures[1], WeapCrosshairScale);
			}

			if (myTPWeapon.CrosshairTextures[2] != None)
			{
				TopY = CenterY - myTPWeapon.CrosshairTextures[2].GetSurfaceHeight() * WeapCrosshairScale - Offset;
				Canvas.SetPos(CenterX - ((myTPWeapon.CrosshairTextures[2].GetSurfaceWidth() / 2))*WeapCrosshairScale, TopY);
				Canvas.DrawTexture(myTPWeapon.CrosshairTextures[2], WeapCrosshairScale);
			}

			if (myTPWeapon.CrosshairTextures[3] != None)
			{
				BottomY = CenterY /*+ myTPWeapon.CrosshairTextures[3].GetSurfaceHeight() * WeapCrosshairScale*/ + Offset;
				Canvas.SetPos(CenterX - ((myTPWeapon.CrosshairTextures[3].GetSurfaceWidth() / 2))*WeapCrosshairScale, BottomY);
				Canvas.DrawTexture(myTPWeapon.CrosshairTextures[3], WeapCrosshairScale);
			}

			if (myTPWeapon.CrosshairDotTexture != None)
			{
				Canvas.SetPos(CenterX - ((myTPWeapon.CrosshairDotTexture.GetSurfaceWidth() / 2))*WeapCrosshairScale, CenterY - ((myTPWeapon.CrosshairDotTexture.GetSurfaceHeight() / 2))*WeapCrosshairScale);
				Canvas.DrawTexture(myTPWeapon.CrosshairDotTexture, WeapCrosshairScale);
			}
		}
    }

}

function DrawSniperView()
{
    local float    ar;
    local TPWeapon weap;

    if (bDrawSniperView)
    {
		// We've gotten in here without a weapon
		if (PlayerOwner == None || PlayerOwner.Pawn == None || PlayerOwner.Pawn.Weapon == None)
		{
			bDrawSniperView = FALSE;
			PlayerPawn(PlayerOwner.Pawn).EnableDistortionEffect(FALSE);
			return;
		}
	
		Weap = TPWeapon(TPPlayerController(PlayerOwner).Pawn.Weapon);

        ar = float(Canvas.SizeX)/float(Canvas.SizeY);

		//`log(self @ ">>>>>>> x=" @ Canvas.SizeX @ "y=" @ Canvas.SizeY @ "ar=" @ ar);

		Canvas.SetOrigin(0,0);
        Canvas.SetPos( 0, 0 ) ;
        if (ar < 1.6) // test for aspect ratio
            Canvas.DrawMaterialTile( Weap.GetScopeView(), Canvas.ClipX, Canvas.ClipY );
        else
            Canvas.DrawMaterialTile( Weap.GetScopeViewWide(), Canvas.ClipX, Canvas.ClipY );
    }
}


//function RenderInventoryBoxes()
//{
//    local Inventory InventoryChain, Item;
//	local Weapon CurrentWeapon;
//    local float InvTexSize; 
//	local float XScreenPos, YScreenPos;
//	local string s;
//
//	XScreenPos = 0.78;
//	YScreenPos = 0.8;
//    
//// SLIN - Temporarily removing the hands option because its really really annoying
////This has become the "hands" weapon    
//    if(TPWeapon(PlayerOwner.Pawn.Weapon) == none)
//    {
//        //Draw no Weapon Icon
//	    //Canvas.SetPos( (0.78 * Canvas.SizeX), (0.825 * Canvas.SizeY) );
//       // Canvas.DrawTile(InvNoWeapon, Canvas.SizeX/8, Canvas.SizeX/8, 0, 0, 256, 256);
//        return;
//    }
//    
//    InventoryChain = PlayerOwner.Pawn.InvManager.InventoryChain;
//                                    
//    if(InventoryChain!=None)
//    {	    
//		CurrentWeapon = PlayerOwner.Pawn.Weapon;
//		if (CurrentWeapon.IsA('Grenade_Persistent'))
//			CurrentWeapon = TPPlayerController(PlayerOwner).PrevWeaponOnGrenade;	
//		
//		for (Item = InventoryChain; Item != None; Item = Item.Inventory)
//	    {
//			switch(TPWeapon(Item).WeapID)
//			{
//   /*             case 'Hands':      
//	                    if( (TPWeapon(PlayerOwner.Pawn.Weapon).WeapID) == (TPWeapon(Item).WeapID))
//	                    {
//	                        Canvas.SetPos( (0.78 * Canvas.SizeX), (0.825 * Canvas.SizeY) );
//                            InvTexSize = Canvas.SizeX/8;
//	                    }
//	                    else
//	                    {  
//	                        Canvas.SetOrigin( (0.78 * Canvas.SizeX), (0.825 * Canvas.SizeY));
//	                        Canvas.SetPos(Canvas.SizeX / 8,Canvas.SizeX / 32);
//                            InvTexSize = Canvas.SizeX/16;
//	                    }                                                                                   
//	                    Canvas.DrawTile(InvNoWeapon, InvTexSize, InvTexSize, 0, 0, 256, 256);
//	                    break;  */
//
//                case 'MP50':      
//	                    if( (TPWeapon(CurrentWeapon).WeapID) == (TPWeapon(Item).WeapID))
//	                    {
//	                        Canvas.SetPos( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY) );
//                            InvTexSize = Canvas.SizeX/8;
//	                    }
//	                    else
//	                    {  
//	                        Canvas.SetOrigin( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY));
//	                        Canvas.SetPos(Canvas.SizeX / 8,Canvas.SizeX / 32);
//                            InvTexSize = Canvas.SizeX/16;
//	                    }                                                                                   
//	                    Canvas.DrawTile(InvMP50, InvTexSize, InvTexSize, 0, 0, 256, 256);
//	                    break;
//	            case 'Pistol':
//	                    if( (TPWeapon(CurrentWeapon).WeapID) == (TPWeapon(Item).WeapID))
//	                    {
//	                        Canvas.SetPos( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY) );
//                            InvTexSize = Canvas.SizeX/8;
//	                    }
//	                    else
//	                    {  
//	                        Canvas.SetOrigin( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY));
//	                        Canvas.SetPos(Canvas.SizeX / 8,Canvas.SizeX / 32);
//                            InvTexSize = Canvas.SizeX/16;
//	                    }
//	                    Canvas.DrawTile(InvPistol, InvTexSize, InvTexSize, 0, 0, 256, 256);
//	                    break;
//				case 'LongRifle':
//	                    if( (TPWeapon(CurrentWeapon).WeapID) == (TPWeapon(Item).WeapID))
//	                    {
//	                        Canvas.SetPos( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY) );
//                            InvTexSize = Canvas.SizeX/8;
//	                    }
//	                    else
//	                    {  
//	                        Canvas.SetOrigin( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY));
//	                        Canvas.SetPos(Canvas.SizeX / 8,Canvas.SizeX / 32);
//                            InvTexSize = Canvas.SizeX/16;
//	                    }
//	                    Canvas.DrawTile(InvLongRifle, InvTexSize, InvTexSize, 0, 0, 256, 256);
//	                    break;
//				case 'LittleJoe':
//	                    if( (TPWeapon(CurrentWeapon).WeapID) == (TPWeapon(Item).WeapID))
//	                    {
//	                        Canvas.SetPos( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY) );
//                            InvTexSize = Canvas.SizeX/8;
//	                    }
//	                    else
//	                    {  
//	                        Canvas.SetOrigin( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY));
//	                        Canvas.SetPos(Canvas.SizeX / 8,Canvas.SizeX / 32);
//                            InvTexSize = Canvas.SizeX/16;
//	                    }
//	                    Canvas.DrawTile(InvLittleJoe, InvTexSize, InvTexSize, 0, 0, 256, 256);
//	                    break;
//				         
//               // log("You have a "@TPWeapon(Item).WeapID); 
//            }
//            Canvas.SetOrigin(0,0); 
//	    }
//		
//		
//		// Draw Ammo Counter
//		// Moved it here to make changing screen positions easier
//		// Ryan Baker - 09/21/06
//		// Note: CurrentWeapon is none when we have only a grenade in our inventory
//		if (CurrentWeapon != none)
//		{
//			Canvas.Font = class'Engine'.Default.SmallFont;
//
//			s = (TPWeapon(CurrentWeapon).AmmoInMagazine[CurrentWeapon.CurrentFireMode] @ "/"@ TPWeapon(CurrentWeapon).AmmoCount[CurrentWeapon.CurrentFireMode]);
//			
//			Canvas.SetPos(((XScreenPos - 0.01) * Canvas.SizeX) + Canvas.SizeX / 8 + 2, (YScreenPos * Canvas.SizeY) + Canvas.SizeX / 13.7 + 2);
//			Canvas.SetDrawColor(0, 0, 0, 255);
//			Canvas.DrawTextRA(s);
//			Canvas.SetPos(((XScreenPos - 0.01) * Canvas.SizeX) + Canvas.SizeX / 8, (YScreenPos * Canvas.SizeY) + Canvas.SizeX / 13.7);
//			Canvas.SetDrawColor(255, 255, 255, 255);
//			Canvas.DrawTextRA(s);
//		}
//	}
//}

function RenderInventoryBoxes()
{
    local Inventory InventoryChain, Item;
	local Weapon CurrentWeapon;
    local float InvTexSize; 
	local float XScreenPos, YScreenPos;


	if( DrawFlags.bDrawInventory == false )
		return;

	XScreenPos = 0.78;
	YScreenPos = 0.8;
    
	// SLIN - Temporarily removing the hands option because its really really annoying
	//This has become the "hands" weapon    
    if(PlayerOwner.Pawn == none)		
    {
		//Draw no Weapon Icon
	    //Canvas.SetPos( (0.78 * Canvas.SizeX), (0.825 * Canvas.SizeY) );
        //Canvas.DrawTile(InvNoWeapon, Canvas.SizeX/8, Canvas.SizeX/8, 0, 0, 256, 256);
        return;
    }
	else if (TPWeapon(PlayerOwner.Pawn.Weapon) == none)
	{
		return;
	}
    
    InventoryChain = PlayerOwner.Pawn.InvManager.InventoryChain;
                                    
    if(InventoryChain!=None)
    {	    
		CurrentWeapon = PlayerOwner.Pawn.Weapon;
		if (CurrentWeapon.IsA('Grenade_Persistent') && TPPlayerController(PlayerOwner).PrevWeaponOnGrenade != None)
		{
			CurrentWeapon = TPPlayerController(PlayerOwner).PrevWeaponOnGrenade;
		}
		
		for (Item = InventoryChain; Item != None; Item = Item.Inventory)
	    {	
			if (Item.IsA('Grenade_Persistent'))
				continue;

			if( CurrentWeapon == None || TPWeapon(CurrentWeapon).WeapID == TPWeapon(Item).WeapID)
	        {
	            Canvas.SetPos( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY) );
                InvTexSize = Canvas.SizeX/8;
	        }
	        else
	        {  
	            Canvas.SetOrigin( (XScreenPos * Canvas.SizeX), (YScreenPos * Canvas.SizeY));
	            Canvas.SetPos(Canvas.SizeX / 8,Canvas.SizeX / 32);
                InvTexSize = Canvas.SizeX/16;
			}
	        Canvas.DrawTile(TPWeapon(Item).HUDIcon, InvTexSize, InvTexSize, 0, 0, TPWeapon(Item).HUDIcon.SizeX, TPWeapon(Item).HUDIcon.SizeY);
	        Canvas.SetOrigin(0,0); 
	    }
	}
}

function DrawGrenades()
{
	local float XScreenPos, YScreenPos;
	local float StartOffsetX;
	local int i, Count, TileSize;
	local Grenade_Persistent Item;
	local PlayerPawn lPlayerPawn;

	if( DrawFlags.bDrawGrenades == false )
		return;

	XScreenPos = 0.78;
	YScreenPos = 0.885;

	if (PlayerOwner.Pawn == none)
		return;
	else if (PlayerOwner.Pawn.InvManager == none)
		return;

	
	lPlayerPawn = GetPlayerOwnerPawn();
	if (lPlayerPawn != None)
	{
		Item = TPInventoryManager(lPlayerPawn.InvManager).CurrentGrenade;
	}

	if( Item == None )
		return;

	
	TileSize = Canvas.SizeX/32;

	// Get the amount of grenades we have
	Count = Item.GetTotalAmmo();

	StartOffsetX = (Count * TileSize) / 2;

	Canvas.SetOrigin((XScreenPos * Canvas.SizeX) + (StartOffsetX - (TileSize*3)), YScreenPos * Canvas.SizeY);
		
	for (i = 0; i < Count; i++)
	{
		//Canvas.SetOrigin( (XScreenPos * Canvas.SizeX) - (i * (TileSize)), (YScreenPos * Canvas.SizeY));
		Canvas.SetPos((Canvas.SizeX / 8) - (i * TileSize),TileSize);
		if (SelectedGrenade == i)
		{
			Canvas.SetDrawColor(255, 255, 255, 100);
			Canvas.DrawTile(GrenadeBracket, TileSize, TileSize, 0, 0, 256, 256);
		}
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.SetPos((Canvas.SizeX / 8) - (i * TileSize),TileSize);
		Canvas.DrawTile(Item.HUDIcon, TileSize, TileSize, 0, 0, 256, 256);
	}
}

function DrawAmmoCounter()
{
    local TPWeapon CurrentWeapon;
    local string s;
    
    if( DrawFlags.bDrawAmmoCount == false )
		return;
    
	if (PlayerOwner.Pawn == none)
		return;

    CurrentWeapon = TPWeapon(PlayerOwner.Pawn.Weapon);
    
    if(CurrentWeapon == none)
		return;
	
	if (CurrentWeapon.IsA('Grenade_Persistent'))
		CurrentWeapon = TPWeapon(TPPlayerController(PlayerOwner).PrevWeaponOnGrenade);
	
	//if(Canvas.SizeX >= 1024)
        //Canvas.Font = class'Engine'.Static.GetMediumFont();
    //else
        Canvas.Font = class'Engine'.Static.GetSmallFont();

	if (CurrentWeapon != none)
	{
		s = (CurrentWeapon.AmmoInMagazine @ "/"@ CurrentWeapon.AmmoCount);
		
		Canvas.SetPos((0.77 * Canvas.SizeX) + Canvas.SizeX / 8 + 2, (0.8 * Canvas.SizeY) + Canvas.SizeX / 13.7 + 2);
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.DrawTextRA(s);
		Canvas.SetPos((0.77 * Canvas.SizeX) + Canvas.SizeX / 8, (0.8 * Canvas.SizeY) + Canvas.SizeX / 13.7);
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.DrawTextRA(s);
	}
}

function ReticleIndicationAllowUpdate()
{
    bAllowReticleColorUpdate=true;
}

function ReticleIndicationTick()
{
    local int Increment;

    if (bAllowReticleColorUpdate)
    {
        Increment       = 510 * RenderDelta;
        ReticleBGColor += Increment;

        if (ReticleBGColor > 255)
        {
            ReticleBGColor           = 255;
            bAllowReticleColorUpdate = false;
        }
    }
}

function ReticleIndicationUpdate()
{
    ReticleBGColor = 0;
    bAllowReticleColorUpdate=false;
    SetTimer(0.3,,'ReticleIndicationAllowUpdate');

}

// Clears the fade in/out of the damage indicator
function ClearDamageDataIndex()
{
   local int i;

    for (i = 0; i < 15; i++)
    {
        DamageData[i].Fade = 1.0;
    }

}


function int FindDamageDataIndex()
{
    local int i;

    for (i = 0; i < 15; i++)
    {
        if (DamageData[i].Fade >= 1)
            return i;
    }

    return -1;
}

function DamageIndicationTick()
{
    local int i;

    for (i = 0; i < 15; i++)
    {
        DamageData[i].Fade += RenderDelta;
        if (DamageData[i].Fade > 1)
            DamageData[i].Fade = 1;
    }
}

function DamageIndicationUpdate(vector HitVec)
{
    local int index;
    
    index = FindDamageDataIndex();

    // If no room in DamageData array, won't draw the hit indication
    if (index != -1)
    {
        DamageData[index].DamageDir = -HitVec;
        DamageData[index].Fade      = 0;
    }
}

function RenderDamageIndication()
{
    local int      i;
    local vector   Ortho;
    local float    Angle1, Angle2, Dummy, DamWidth, DamHeight;
    local vector   Offset;
    local rotator  rotat;

	if (PlayerOwner.Pawn == None)
		return;

    Ortho   = vector(PlayerOwner.Pawn.Rotation);
    Dummy   = Ortho.X;
    Ortho.X = -Ortho.Y;
    Ortho.Y = Dummy;


    DamageIndicationTick();

	if (!DrawFlags.bDrawDamageIndicator)
		return;

    for (i = 0; i < 15; i++)
    {
        if (DamageData[i].Fade < 1)
        {
			DamWidth  = DamageData[i].MIC.GetSurfaceWidth();
			DamHeight = DamageData[i].MIC.GetSurfaceHeight();
			
            Offset = vect(0,-100, 0);

            Angle1 = vector(PlayerOwner.Pawn.Rotation) dot DamageData[i].DamageDir;
            Angle2 = Ortho dot DamageData[i].DamageDir;

            // hope there's a lookup table for this...if not create one for optimization
            Angle1 = ACos(Angle1) * RadToDeg * 182.041667;

            rotat.yaw = int(Angle1);

            if (Angle2 < 0)
            {
                // 3.14 gives 180 rotation
                //DamageMaterialIC.SetScalarParameterValue('DamageRotation', (Angle1/32768.0f) * Pi);
                DamageData[i].MIC.SetScalarParameterValue('DamageRotation', (Angle1/32768.0f) * Pi);
                Offset = Offset << rotat;
            }
            else
            {
                //DamageMaterialIC.SetScalarParameterValue('DamageRotation', (Angle1/32768.0f) * -Pi);
                DamageData[i].MIC.SetScalarParameterValue('DamageRotation', (Angle1/32768.0f) * -Pi);
                Offset = Offset >> rotat;
            }

            Canvas.SetDrawColor(255,255,255);
            //DamageMaterialIC.SetScalarParameterValue('DamageFade', DamageData[i].Fade);
            DamageData[i].MIC.SetScalarParameterValue('DamageFade', DamageData[i].Fade);

            Canvas.SetPos(Canvas.SizeX/2 + Offset.x - DamWidth/2, Canvas.SizeY/2 + Offset.y - DamHeight/2);
            //Canvas.DrawMaterialTile(DamageMaterialIC, DamWidth, DamHeight);
            Canvas.DrawMaterialTile(DamageData[i].MIC, DamWidth, DamHeight);
        }
    }
}

function GrenadeIndicationTick()
{
    local int i;

    for (i = 0; i < 5; i++)
    {
        if (GrenadeData[i].LiveGrenade != None)
            GrenadeData[i].Fade -= RenderDelta;

        if (GrenadeData[i].Fade <= 0.3)
            GrenadeData[i].Fade = 0.3;
    }
}

function GrenadeIndicationUpdate(Actor Grenade)
{
    local int i;

    for (i = 0; i < 5; i++)
    {
        if (GrenadeData[i].LiveGrenade == Grenade)
        {
            return;
        }
        else if (GrenadeData[i].LiveGrenade == None ||
            (GrenadeData[i].LiveGrenade != None && GrenadeData[i].LiveGrenade.bPendingDelete))
        {
            GrenadeData[i].LiveGrenade = Grenade;
            GrenadeData[i].Fade        = 1;
            return;
        }
    }
}

function RenderGrenadeIndication()
{
    local int     i;
    local vector  PlayerToGrenade, Ortho, Offset, delta;
    local float   Dummy, Angle1, Angle2, GrenWidth, GrenHeight, GrenDist;
    local rotator rotat;
    local GameViewportClient VPClient;

	if (PlayerOwner.Pawn == None)
		return;

    Ortho   = vector(PlayerOwner.Pawn.Rotation);
    Dummy   = Ortho.X;
    Ortho.X = -Ortho.Y;
    Ortho.Y = Dummy;


    GrenadeIndicationTick();

	//Kelly - Moved this block from the bottom of this function.  Needs to always happen even if we aren't drawing the damage indicator.
	VPClient = LocalPlayer(PlayerOwner.Player).ViewportClient;
	SafeZoneLeft =		VPClient.CalculateDeadZone( LocalPlayer(PlayerOwner.Player), eSZ_LEFT, Canvas, false );
	SafeZoneRight =		VPClient.CalculateDeadZone( LocalPlayer(PlayerOwner.Player), eSZ_RIGHT, Canvas, false );
	SafeZoneTop	=		VPClient.CalculateDeadZone( LocalPlayer(PlayerOwner.Player), eSZ_TOP, Canvas, false );
	SafeZoneBottom =	VPClient.CalculateDeadZone( LocalPlayer(PlayerOwner.Player), eSZ_BOTTOM, Canvas, false );
	//VPClient.CalculatePixelCenter( SafeZoneFriendlyCenterX, SafeZoneFriendlyCenterY, LocalPlayer(PlayerOwner.Player), Canvas );
	SafeZoneFriendlyCenterX = Canvas.ClipX/2;
	SafeZoneFriendlyCenterY = Canvas.ClipY/2;


	if (!DrawFlags.bDrawDamageIndicator)
		return;

    for (i = 0; i < 5; i++)
    {
        if (GrenadeData[i].LiveGrenade != None && !GrenadeData[i].LiveGrenade.bPendingDelete)
        {
			GrenWidth  = GrenadeData[i].MIC.GetSurfaceWidth();
			GrenHeight = GrenadeData[i].MIC.GetSurfaceHeight();
        
            Offset = vect(0,-100, 0);

			delta = GrenadeData[i].LiveGrenade.Location - PlayerOwner.Pawn.Location;
			GrenDist = VSize(delta);
			
			if (GrenDist < class'Grenade_Persistent'.static.GetDefaultAffectedRadius()/*PhysicsGrenade(GrenadeData[i].LiveGrenade).AffectedRadius*/)
			{
				PlayerToGrenade = delta / GrenDist;//Normal(GrenadeData[i].LiveGrenade.Location - PlayerOwner.Pawn.Location);

				Angle1 = vector(PlayerOwner.Pawn.Rotation) dot PlayerToGrenade;
				Angle2 = Ortho dot PlayerToGrenade;

				// hope there's a lookup table for this...if not create one for optimization
				Angle1 = ACos(Angle1) * RadToDeg * 182.041667;

				rotat.yaw = int(Angle1);

				if (Angle2 < 0)
				{
					// 3.14 * 4 gives 180 rotation
					GrenadeData[i].MIC.SetScalarParameterValue('GrenadeRotation', (Angle1/32768.0f) * Pi * 4);
					Offset = Offset << rotat;
				}
				else
				{
					GrenadeData[i].MIC.SetScalarParameterValue('GrenadeRotation', (Angle1/32768.0f) * -Pi * 4);
					Offset = Offset >> rotat;
				}

				Canvas.SetDrawColor(255,255,255);
				GrenadeData[i].MIC.SetScalarParameterValue('GrenadeFade', GrenadeData[i].Fade);

				Canvas.SetPos(Canvas.SizeX/2 + Offset.x - GrenWidth/2, Canvas.SizeY/2 + Offset.y - GrenHeight/2);
				Canvas.DrawMaterialTile(GrenadeData[i].MIC, GrenWidth, GrenHeight);
            }
        }
    }


	// calculate the safezones and viewport centers
//Kelly - moved to top of function
// 	VPClient = LocalPlayer(PlayerOwner.Player).ViewportClient;
// 	SafeZoneLeft =		VPClient.CalculateDeadZone( LocalPlayer(PlayerOwner.Player), eSZ_LEFT, Canvas, false );
// 	SafeZoneRight =		VPClient.CalculateDeadZone( LocalPlayer(PlayerOwner.Player), eSZ_RIGHT, Canvas, false );
// 	SafeZoneTop	=		VPClient.CalculateDeadZone( LocalPlayer(PlayerOwner.Player), eSZ_TOP, Canvas, false );
// 	SafeZoneBottom =	VPClient.CalculateDeadZone( LocalPlayer(PlayerOwner.Player), eSZ_BOTTOM, Canvas, false );
// 	//VPClient.CalculatePixelCenter( SafeZoneFriendlyCenterX, SafeZoneFriendlyCenterY, LocalPlayer(PlayerOwner.Player), Canvas );
// 	SafeZoneFriendlyCenterX = Canvas.ClipX/2;
// 	SafeZoneFriendlyCenterY = Canvas.ClipY/2;
}

//Mirrored from Hud.uc - now passing in offsets to DrawAnimDebug
event PostRender()
{
	local float		XL, YL, YPos;
	local bool		bDrawingLoadingText;
   
	// Set up delta time
	RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;

	// Pre calculate most common variables
	if ( SizeX != Canvas.SizeX || SizeY != Canvas.SizeY )
	{
		PreCalcValues();
	}

	// Set PRI of view target
	if ( PlayerOwner != None )
	{
		if ( PlayerOwner.ViewTarget != None )
		{
			if ( Pawn(PlayerOwner.ViewTarget) != None )
			{
				ViewedInfo = Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo;
			}
			else
			{
				ViewedInfo = PlayerOwner.PlayerReplicationInfo;
			}
		}
		else if ( PlayerOwner.Pawn != None )
		{
			ViewedInfo = PlayerOwner.Pawn.PlayerReplicationInfo;
		}
		else
		{
			ViewedInfo = PlayerOwner.PlayerReplicationInfo;
		}
	}

	if (WorldInfo.bRequestedBlockOnAsyncLoading || TPPlayerController(PlayerOwner).bCommitMapChangePending)
	{
		DrawLoadingText();
		bDrawingLoadingText = TRUE;
	}

	if ( bShowDebugInfo )
	{
		Canvas.Font = class'Engine'.Static.GetTinyFont();
		Canvas.DrawColor = ConsoleColor;
		Canvas.StrLen("X", XL, YL);
		YPos = 0;
		PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);

		if (ShouldDisplayDebug('AI') && (Pawn(PlayerOwner.ViewTarget) != None))
		{
			DrawRoute(Pawn(PlayerOwner.ViewTarget));
		}
	}
	else if ( bShowHud )
	{
		if ( WorldInfo.NetMode != NM_Standalone)
		{
			if (TPGameReplicationInfo(WorldInfo.GRI).GameStatus >= GS_PreGame && TPGameReplicationInfo(WorldInfo.GRI).GameStatus != GS_PostGame && TPPlayerController(PlayerOwner).ScoreboardScene != none)
			{
				if (bShowScores)
					UIScene_BaseScoreboard(TPPlayerController(PlayerOwner).ScoreboardScene).SetVisibility(true);	// Turn on/off scoreboard based on bShowScores toggle.
				else
				{
					UIScene_BaseScoreboard(TPPlayerController(PlayerOwner).ScoreboardScene).SetVisibility(false);	// Turn on/off scoreboard based on bShowScores toggle.
				}
			}

			PlayerOwner.DrawHud( Self );

			DrawHud();

			if ( PlayerOwner.ProgressTimeOut > WorldInfo.TimeSeconds )
			{
				DisplayProgressMessage();
			}

			DisplayOnlineMessages();
			//DisplayConsoleMessages();
			//DisplayLocalMessages();
			if (!bDrawingLoadingText)
				DrawCheckpointText();

			/*if ( ScoreBoard != None )
			{
				ScoreBoard.Canvas = Canvas;
				ScoreBoard.DrawHud();
				if ( Scoreboard.bDisplayMessages )
				{
					DisplayConsoleMessages();
				}
			}*/
		}
		else
		{
			PlayerOwner.DrawHud( Self );

			DrawHud();

			if ( PlayerOwner.ProgressTimeOut > WorldInfo.TimeSeconds )
			{
				DisplayProgressMessage();
			}

			DisplayConsoleMessages();
			DisplayLocalMessages();
			if (!bDrawingLoadingText)
				DrawCheckpointText();
		}
	}
	else if(bFadeInScreen)
	{
		//Allow the fading even if hud is disabled
	    FadeInScreen();
	}
	else if (bDrawSniperView && WorldInfo.Pauser != None)
    {
        DrawSniperView();
    }
    else
    {
		DrawDemoHUD();
	}

	if ( bShowBadConnectionAlert )
	{
		DisplayBadConnectionAlert();
	}



















	LastHUDRenderTime = WorldInfo.TimeSeconds;
}

function DrawLoadingText()
{
	local float FontCalcX, FontCalcY, DrawX, DrawY;

	Canvas.Font = class'Engine'.Static.GetMediumFont();
	Canvas.TextSize( LoadingString, FontCalcX, FontCalcY );
	DrawX = Canvas.ClipX - SafeZoneRight - FontCalcX - 10;
	DrawY = Canvas.ClipY - SafeZoneBottom - FontCalcY - 10;

	SetHUDDrawColor( eTPHUDCOLOR_WHITE, byte(255.f) );
	Canvas.SetPos( DrawX, DrawY );
	Canvas.DrawText( LoadingString );
}

exec function BlackScreen(bool set)
{
	SetFade(set, "", 255);
}

function AddConsoleMessage(string M, class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float LifeTime)
{
	if( LifeTime == 0.0f )
	{
		LifeTime = MessageLifetime; //Override the default lifetime.
	}
	Super.AddConsoleMessage(M, InMessageClass, PRI, LifeTime);
}

//Make sure there isn't another message in the queue with this string
function AddUniqueConsoleMessage(string M, class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float LifeTime)
{
	local int Idx;

	for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
	{
		if( ConsoleMessages[Idx].Text == M )
		{
			//There is already a message with this string - reset the lifetime and return
			ConsoleMessages[Idx].MessageLife = WorldInfo.TimeSeconds + LifeTime;
			return;
		}
	}

	//Add the message as usual
	AddConsoleMessage(M, InMessageClass, PRI, LifeTime);
}

function DisplayOnlineMessages()
{
	local int Idx, i;
	local UIScene_TPNonWeaponHUD NonWeaponUIHUD;

	NonWeaponUIHUD = UIScene_TPNonWeaponHUD(TPPlayerController(PlayerOwner).myNonWeaponUIScene);

	for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
    {
		if ( ConsoleMessages[Idx].Text == "" || ConsoleMessages[Idx].MessageLife < WorldInfo.TimeSeconds )
		{
			ConsoleMessages.Remove(Idx--,1);
		}
    }

	//NonWeaponUIHUD.ClearOnlineMessages();

	for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
    {
		if (ConsoleMessages[Idx].Text == "")
		{
			continue;
		}
		NonWeaponUIHUD.AddOnlineMessageText(i++, ConsoleMessages[Idx].Text);
		//Canvas.DrawText( ConsoleMessages[Idx].Text, false );
    }
	NonWeaponUIHUD.ClearOnlineMessages(i);

	//UIScene_TPNonWeaponHUD(TPPlayerController(PlayerOwner).myNonWeaponUIScene).AddOnlineMessageText(OnlineMessage);
}

function DisplayConsoleMessages()
{
    local int Idx, XPos, YPos;
    local float XL, YL;

    local int numMsgs;
    local float tempXL, tempYL;
    local float XMargin, YMargin;

    for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
    {
		if ( ConsoleMessages[Idx].Text == "" || ConsoleMessages[Idx].MessageLife < WorldInfo.TimeSeconds )
		{
			ConsoleMessages.Remove(Idx--,1);
		}
    }


    XPos = (ConsoleMessagePosX * HudCanvasScale * Canvas.SizeX) + (((1.0 - HudCanvasScale) / 2.0) * Canvas.SizeX);
    YPos = (ConsoleMessagePosY * HudCanvasScale * Canvas.SizeY) + (((1.0 - HudCanvasScale) / 2.0) * Canvas.SizeY);




    Canvas.Font = class'Engine'.Static.GetSmallFont();
    Canvas.TextSize ("A", XL, YL);

    YPos -= YL * ConsoleMessages.Length; // DP_LowerLeft
    YPos -= YL; // Room for typing prompt


	numMsgs=0;
	tempXL=0;
	tempYL=0;
	XL=0;
    for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
    {
		if (ConsoleMessages[Idx].Text != "")
		{
			//find the max string length;
			Canvas.StrLen( ConsoleMessages[Idx].Text, tempXL, tempYL );
			if(tempXL > XL)
				XL = tempXL;

			//count the msgs
			numMsgs++;
		}
	}

	XMargin = 3;
	YMargin = 3;
	if(numMsgs > 0)
	{
		//draw message background
		Canvas.SetPos( XPos-XMargin, YPos-YMargin );
		Canvas.SetDrawColor(128, 128, 128, 128);
		Canvas.DrawRect( XL+(XMargin*2), (YL*numMsgs)+(YMargin*2));
		Canvas.SetPos( XPos, YPos );

		//draw borders
		Canvas.SetDrawColor(0, 0, 0, 255);

		Canvas.SetPos( XPos-XMargin, YPos-YMargin );
		Canvas.DrawRect( XL+(XMargin*2), 1 );

		Canvas.SetPos( XPos-XMargin, YPos-YMargin );
		Canvas.DrawRect( 1, (YL*numMsgs)+(YMargin*2) );

		Canvas.SetPos( XPos-XMargin, YPos+(YL*numMsgs)+YMargin );
		Canvas.DrawRect( XL+(XMargin*2), 1 );

		Canvas.SetPos( XPos+XL+XMargin, YPos-YMargin );
		Canvas.DrawRect( 1, (YL*numMsgs)+(YMargin*2) );
	}


    Canvas.DrawColor = ConsoleColor;

    for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
    {
		if (ConsoleMessages[Idx].Text == "")
		{
			continue;
		}
		Canvas.StrLen( ConsoleMessages[Idx].Text, XL, YL );

		//draw drop shadow in black
		Canvas.SetPos( XPos+1, YPos+1 );
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.DrawText( ConsoleMessages[Idx].Text, false );


		Canvas.SetPos( XPos, YPos );
		Canvas.DrawColor = ConsoleMessages[Idx].TextColor;
		Canvas.DrawText( ConsoleMessages[Idx].Text, false );
		YPos += YL;
    }
}

event Destroyed()
{
	Super.Destroyed();


	;
}



exec function AnimDebugUp()
{
	AnimDebugOffsetY += 60;
}
exec function AnimDebugDown()
{
	AnimDebugOffsetY -= 60;
}
exec function AnimDebugLeft()
{
	AnimDebugOffsetX += 60;
}
exec function AnimDebugRight()
{
	AnimDebugOffsetX -= 60;
}           



event PreScreenShot()
{
	;
	bOldShowHud = bShowHud;
	bShowHud = false;
}
event PostScreenShot()
{
	;
	bShowHud = bOldShowHud;
}


function SetFade(bool bEnable, optional string S, optional float alpha)
{
	bFadeInScreen = bEnable;
	
	if( bEnable )
	{
		FadeInScreenText = S;
		FadeScreenAlpha = alpha;
	}

}

exec function ToggleCopyright()
{
	DrawFlags.bDrawCopyright = !DrawFlags.bDrawCopyright;
}
exec function ToggleBuild()
{
	ToggleCopyright();
}

function RenderFallDamageIndication()
{
	local float DeltaTime, TexWidth, TexHeight;

	if (FallDamageCurrTime != 0.0f)
	{
		DeltaTime = WorldInfo.TimeSeconds - LastHUDRenderTime;
		FallDamageCurrTime -= DeltaTime;
		if (FallDamageCurrTime <= 0.0f)
		{
			FallDamageCurrTime = 0.0f;
		}
		else
		{
			TexWidth = FallDamageIndicator.GetSurfaceWidth();
			TexHeight = FallDamageIndicator.GetSurfaceHeight();

			Canvas.SetDrawColor(255, 255, 255, 255);
            Canvas.SetPos(Canvas.SizeX/2 - TexWidth/2, Canvas.SizeY/2 - TexHeight/2);
			Canvas.DrawTile(FallDamageIndicator, TexWidth, TexHeight, 0, 0, TexWidth, TexHeight);
		}
	}
}

exec function ShowFallDamageIndication()
{
	FallDamageCurrTime = FallDamageTotalTime;
}

