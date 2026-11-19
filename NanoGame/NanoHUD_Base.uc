/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoHUD_Base extends HUD
	dependson(NanoTypes,NanoMissionManager,NanoMCP)
	config(Game); // this should be UI

struct native PlayerLocationInfo
{
	var vector		Location;
	var vector		Velocity;
	var EPhysics	Physics;
	var ENanoState	NanoState;
};
var transient array<PlayerLocationInfo>	PlayerTrail;
var bool bEnablePlayerTrail, bFreezePlayerTrail;

var const FontRenderInfo Text_NoClipShadowed;
var const FontRenderInfo Text_ClipShadowed;

var config bool bShowResponseSystem;

var config bool bDrawVelocityHistory;
var transient array<float> AccelHistory;
var transient array<float> VelocityHistory;
var transient array<float> MaxSpeedHistory;
var transient array<float> GroundSpeedHistory;
var transient float LastVelocitySampleTime;

var MaterialInstanceConstant DmgIndicator;

var float	NanoPowerBarMaxWidth, NanoPowerForgeCoreBarMaxWidth, HealthBarMaxWidth;
var float	NanoPowerBarMaxLength, NanoPowerForgeCoreBarMaxLength, HealthBarMaxLength;

/** Time that we last changed a utility plan - used to display the d-pad options temporarily */
var transient float     LastChangeUtilityPlanTime;
/** How long to show your quick-bind options for when you change */
var float               QuickBindShowDuration;

var float   NanoFreeForgeIconSize;

var float	NanoSpeedBarScale;

var	Material BeaconLocatorMaterial;
var transient array<MaterialInstanceConstant> BeaconMIC;

var vector2d	BeaconLocatorCenter;

var	color		BeaconAboveColor;
var	color		BeaconBelowColor;
var	color		BeaconLevelColor;
var float		BeaconColorBlendDist;

/** Array of UI pages, in order */
var array<NanoUIPage_Base> UIPages;
/** Index of currently visible UI page (-1 if no menu up) */
var int CurrentUIPageIndex;
/** Keep a ref to feed page */
var NanoUIPage_Feed FeedPage;

var transient int	CurrentSelection;
/** Debug - don't draw menu when paused */
var(Debug) config bool bDebugNoMenu;

/** FOR DEMO:  Do not draw temp HUD elements if this is set */
var config bool bMinimalHud;

var transient bool bPausedByHUD;

/** Enum for HUD colors in Gears */
enum ENanoHUDColor
{
	eNANOHUDCOLOR_WHITE,
	eNANOHUDCOLOR_RED,
	eNANOHUDCOLOR_BLACK,
	eNANOHUDCOLOR_WHITE_DK,
	eNANOHUDCOLOR_TEAMRED,
	eNANOHUDCOLOR_TEAMBLUE,
	eNANOHUDCOLOR_CHATICONRED,
	eNANOHUDCOLOR_CHATICONBLUE,
	eNANOHUDCOLOR_GRAY,
	eNANOHUDCOLOR_GREEN,
	eNANOHUDCOLOR_BLUE,
	eNANOHUDCOLOR_YELLOW,
};

struct native XPMessage
{
	var transient float LastDrawY;
	var int XPAmt;
	var float LastXPAmt;
	var string Label;
	var float MessageTime;
};
var array<XPMessage> XPMessages;

struct native MissionBriefingDialog
{
	var string SpeakerName;
	var string DialogText;
	var float TimeToDisplay;
};
var array<MissionBriefingDialog> DialogMessages;

/** Current action possible, prioritized by EActionType */
var ActionInfo ActiveAction;
/** Previously active, kept around for blending */
var ActionInfo PreviousAction;

/** Fade in/out time for actions */
var config float ActionFadeTime;

struct native ActionIconAnimData
{
	/** Time of the last time we made an icon switch for animating action icons */
	var float LastActionAnimationSwitch;
	/** Current index of the animating action icon */
	var int CurrentIconIndex;
};
var ActionIconAnimData	ActionIconAnimInfo;

var transient protected MaterialInstanceConstant MIC_ReticleTop;
var transient protected MaterialInstanceConstant MIC_ReticleBottom;
var protected MaterialInterface MI_ReticleSource;

/** Top string to display in nice box */
var transient string			MessageString1;
/** Bottom string to display in nice box */
var transient string			MessageString2;
/** When message box should end */
var transient float			MessageEndTime;
/** Location to draw box */
var() vector2D		MessageBoxSize;
/** Offset from center of the screen to draw the message */
var() transient vector2D		MessageBoxOffset;

/** Enum indicating different types of tutorial message */
enum ETutorialMessageType
{
	ETMT_Ok,
	ETMT_AcceptDecline
};

/** Struct containing information about a tutorial screen to display */
struct TutorialDatum
{
	/** Top string to display in nice box */
	var transient string TutorialScreen_Title;
	/** Bottom string to display in nice box */
	var transient array<string> TutorialScreen_Body;
	/** When to show this tutorial **/
	var transient float TimeToShow;

	var transient float MinTimeForTutorialMessageToStayUp;

	/** If this tutorial came from an action, pointer back to it, so we can end the action based on user input */
	var SeqAct_ShowTutorialScreen TutorialAction;

	/** If the game should pause when this tutorial is displayed */
	var transient bool bShouldPauseGame;

	/** What type of message is this */
	var ETutorialMessageType MessageType;
};

var transient array<TutorialDatum> Tutorials;

/** Location to draw box */
var() vector2D TutorialScreen_MessageBoxSize;
/** Offset from center of the screen to draw the message */
var() transient transient vector2D TutorialScreen_MessageBoxOffset;

var() transient bool bTutorialIsUp;

/** You can spaz hit the B button.  So we want the tutorial to stay up for some min time.**/
var transient float TimeOfTutorial;

// MELEE BAR
struct MeleeBarItem
{
	var float NotifyTime;
	var bool  bAllow;
};

var() config bool bDrawMeleeBar;
var() Name		MeleeAttackName;
var() float		MeleeAttackLength;
var() float		MeleeAttackSpeedScale; 
var() float		MeleeAttackPos;
var() float		MeleeComboWindowStart;
var() float		MeleeComboWindowEnd;
var() float		MeleeComboSuccessTransition;
var() float		MeleeComboFailTransition;
var() array<MeleeBarItem> MeleeComboJumpInterrupt;
var() array<MeleeBarItem> MeleeComboMoveInterrupt;
var() array<float> MeleeComboDeadZonePairs;
// END MELEE BAR



// CHAOS
var()	vector2D	ChaosUIOrigin;
var()	Texture2D	ChaosUITexture;
var()	float		ChaosHistoryYOffset;
// END CHAOS

// COMBO
var()	vector2D	ComboUIOrigin;
var()	Texture2D	ComboUITexture;
// END COMBO

// WEAPON
var()   Color       WeaponActiveColor;
var()   Color       WeaponHolsteredColor;
var()   Color       WeaponMissingColor;
// END WEAPON

// IRIS
var()           MaterialInstance            IRISMovieMat;
var transient   MaterialInstanceConstant    IRISMovieInst;
var()           TextureMovie                IRISTextureMovie;

var()           float                       IRISOpacityBlendRate;
var transient   float                       IRISOpacity;

// END IRIS

// FEED 
var()   NanoIconData    NewPostIcon;
var()   vector2D        NewPostOrigin;
var()   vector2D        NewPostIconSize;
var()   float           NewPostPulseSpeed;
// END FEED 

var FontRenderInfo TextRenderInfo;

//DEBUG
/** List of debug draw functions */
var array<delegate<DebugDraw> > DebugDrawList;

var protected transient NanoHUDElement_Forge ForgeHUDElement;
var protected transient NanoHUDElement_WeaponSelect WeaponSelectHUDElement;
var transient NanoHUDElement_Minimap MinimapHUDElement;

/** Info used to draw the minimap */
var MinimapDrawInfo MapDrawInfo;
var() config float HUDMinimapToWorldScale;

/** How transparent the green chaos squares are. **/
var transient float ChaosGreenSquareTransparency;
var transient int PrevChaosTier;

// SlideOn Texture!  We are using this for Chaos Tier notifications
var transient vector    SO_CurrentPosition;
var transient vector    SO_CurrentVel;
var transient vector    SO_TargetPos;
var() float             SO_Stiffness;
var() float             SO_Damping;
var transient float     SO_Lifetime;
var transient Texture2D SO_Tex;



var() float             SOT_Stiffness;
var() float             SOT_Damping;

struct SlideOnTextDatum
{
	// SlideOnText!  We are using this for arbitrary text on the middle of the screen (e.g. Mission Notifications)
	var transient vector    SOT_CurrentPosition;
	var transient vector    SOT_CurrentVel;
	var transient vector    SOT_TargetPos;
	var transient float     SOT_Lifetime;
	var transient string    SOT_Text;
	var transient Font      SOT_Font;        

	var transient SoundCue  SOT_SoundToPlay;
	/** Whether we ahve played the sound for this SOT **/
	var transient bool      bSOT_PlayedSound;
};

/** 
 * we always draw the 0th SOT  
 * TODO: maybe have a priority scheme?  Seems bettter to have different SOT locations
 **/
var transient array<SlideOnTextDatum> SOTs;

var() Texture2D HUDButtonsTex;


simulated event PostBeginPlay()
{
	local int i;
	
	Super.PostBeginPlay();

 	MIC_ReticleTop = new(self) class'MaterialInstanceConstant';
 	MIC_ReticleTop.SetParent( MI_ReticleSource );

	MIC_ReticleBottom = new(self) class'MaterialInstanceConstant';
	MIC_ReticleBottom.SetParent( MI_ReticleSource );



	// Create UI pages
	FeedPage = new(self) class'NanoUIPage_Feed';

	UIPages[0] = new(self) class'NanoUIPage_Map';
	UIPages[1] = new(self) class'NanoUIPage_Inventory';
	UIPages[2] = FeedPage;
	UIPages[3] = new(self) class'NanoUIPage_Skills';
	UIPages[4] = new(self) class'NanoUIPage_WeaponMods';
	UIPages[5] = new(self) class'NanoUIPage_CharData';
	UIPages[6] = new(self) class'NanoUIPage_Leaderboard';
	UIPages[7] = new(self) class'NanoUIPage_Challenges';


	// set pointer on each page to this owning HUD
	for(i=0; i<UIPages.length; i++)
	{
		UIPages[i].NanoHUD = self;
	}

	FeedPage.RebuildPostFeed(FALSE);

	ForgeHUDElement = Spawn(class'NanoHUDElement_Forge', self );
	ForgeHUDElement.HUDOwner = self;
	WeaponSelectHUDElement = Spawn(class'NanoHUDElement_WeaponSelect', self );
	WeaponSelectHUDElement.HUDOwner = self;

	MinimapHUDElement = new(self) class'NanoHUDElement_Minimap';
	MinimapHUDElement.Init(self);
}

/** Util to return the currently open UI page */
function NanoUIPage_Base GetCurrentUIPage()
{
	if(CurrentUIPageIndex == -1)
	{
		return None;
	}
	else
	{
		return UIPages[CurrentUIPageIndex];
	}
}

event Tick(float Delta)
{
	local vector Error, Force;

	Super.Tick(Delta);

	// If still sliding, update position using simple spring
	if(SO_Lifetime > 0.0)
	{
		Error = SO_CurrentPosition - SO_TargetPos;
		Force = (-Error * SO_Stiffness) + (-SO_CurrentVel * SO_Damping);

		SO_CurrentVel += Force * Delta;
		SO_CurrentPosition += SO_CurrentVel * Delta;

		// Update lifetime
		SO_Lifetime -= Delta;
		if(SO_Lifetime <= 0.0)
		{
			SO_Tex = none;
			SO_Lifetime = 0.0;
		}
	}


	// if we are not drawing any OMG AWESOME IMAGE then we can draw text messages
	if(SO_Lifetime <= 0.0)
	{
		// If still sliding, update position using simple spring
		if( SOTs.Length > 0 )
		{
			if( SOTs[0].SOT_Lifetime >= 0.0)
			{
				if( ( SOTs[0].SOT_SoundToPlay != None ) && ( SOTs[0].bSOT_PlayedSound == FALSE ) )
				{
					NanoGRI(WorldInfo.GRI).GetNanoPC().PlaySound( SOTs[0].SOT_SoundToPlay );
					SOTs[0].bSOT_PlayedSound = TRUE; // don't play it more than once
				}

				Error = SOTs[0].SOT_CurrentPosition - SOTs[0].SOT_TargetPos;
				Force = (-Error * SOT_Stiffness) + (-SOTs[0].SOT_CurrentVel * SOT_Damping);

				SOTs[0].SOT_CurrentVel += Force * Delta;
				SOTs[0].SOT_CurrentPosition += SOTs[0].SOT_CurrentVel * Delta;

				//`log( `showvar(SOTs[0].SOT_CurrentPosition) @ `showvar(SOTs[0].SOT_TargetPos) @ `showvar(SOTs[0].SOT_CurrentVel) @ `showvar(Error) @ `showvar(Force) );

				// Update lifetime
				SOTs[0].SOT_Lifetime -= Delta;
				if(SOTs[0].SOT_Lifetime <= 0.0)
				{
					//`log ( GetFuncName() @ `showvar(SOTs[0].SOT_Text) );
					SOTs[0].SOT_Text = "";
					SOTs[0].SOT_Lifetime = 0.0;
					SOts.Remove( 0, 1 );
				}
			}
		}
	}

}

final function DrawTextCentered(coerce string Text, optional bool CR = true, optional float XScale = 1.0, optional float YScale = 1.0, optional const FontRenderInfo RenderInfo = Canvas.CreateFontRenderInfo(true, true))
{
	local float XL, YL;

	Canvas.TextSize(Text, XL, YL);
	Canvas.SetPos(Canvas.CurX - XL / 2, Canvas.CurY);
	Canvas.DrawText(Text, CR, XScale, YScale, RenderInfo);
}

// DrawHUD should be located below the "BeginPlay" type functions as it is doing all the work and calling
// all our worker functions.  Makes it much easier to find the hook in function when it is here.

// this is our "tick" function
function DrawHUD()
{
	local NanoPawn NP;
	local NanoPC NPC;
	local int YPos;
	local float TextSizeX, TextSizeY;
	//local String ResourcesAvailString;
	local vector ViewPoint;
	local rotator ViewRotation;
	//local float AnimRate;
	local bool bFullScreenMenuIsUp;


	if ( bShowOverlays && (PlayerOwner != None) )
	{
		Canvas.Font = GetFontSizeIndex(0);
		PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
		DrawActorOverlays(Viewpoint, ViewRotation);
	}

	// handle any debug draws
	foreach DebugDrawList(DebugDraw)
	{
		DebugDraw(self);
	}

	DrawNanoTargetPointInGameInfo();

	// Draw power/speed
	if( PlayerOwner != None )
	{
		PlayerOwner.DrawHud( Self ); // debug drawing from the NanoPC

		NP = NanoPawn(PlayerOwner.Pawn);
		if(NP != None)
		{
			// checks to see if there is a full screen menu up
			bFullScreenMenuIsUp = (GetCurrentUIPage() != None) || (NP.InvManager != None && NanoInventoryManager(NP.InvManager).bShowUpgradesScreen);

			NPC = NanoPC(NP.Controller);

			if( ( NPC.GetViewTarget() == NP )
				&& ( bFullScreenMenuIsUp == FALSE )
				)
			{
				if (bDrawVelocityHistory)
				{
					DrawVelocityHistory(NP);
				}

				if( !bMinimalHud )
				{
					DrawCrossHair( NP );

					DrawDamageIndicator(NP);
					DrawHealthBar(NP);

					DrawAmmoInfo(NP);
					DrawMeleeComboInfo(NP);

					DrawCrowdInfo(NP);

					DrawXPMessages();
					DrawMissionBriefingDialog(NP);
					DrawActions(RenderDelta);

					if((LastChangeUtilityPlanTime > 0) && (`TimeSince(LastChangeUtilityPlanTime) < QuickBindShowDuration))
					{
						DrawQuickBindOptions(NP);
					}

					PossiblyShowDBNOOptions();
					PossiblyShowDBNOInterrogateOptions();
					PossiblyShowDBNODragOptions();
					PossiblyShowDBNOHoldingOverLedgeOptions();
					PossiblyDrawDBNOTimers();

					PossiblyShowHostageOptions();

					if( bDrawMeleeBar )
					{
						DrawMeleeInfo(NP);
					}

					// Draw dash level dots
					DrawDashMeter(NP);

					// Draw any new messages in the feed you should read
					DrawFeedInfo();

					//// MiniMap HUD elements
					if( NPC.DebugAIController == None )
					{
						if (MinimapHUDElement != None)
						{
							MapDrawInfo.MinimapLocation = NP.Location;
							MapDrawInfo.MinimapRotation = UnrRotToDeg * NP.GetViewRotation().Yaw;
							MapDrawInfo.MinimapToWorldScale = HUDMinimapToWorldScale;

							MinimapHUDElement.DrawHUDElements(Canvas, MapDrawInfo);
						}

						DrawOnHUDMissionText(NP);
						DrawChaosMeter(NP);
						DrawSlideOnTexture();
						DrawSlideOnText();
						DrawChaosCoolDownBar(NP);
						DrawRebelMindShareBar(NP);
						DrawImportantCharacterData(NP);
						DrawInteractionBar(NP);
					}
				}
			}
			
			// Draw this even when menu is up, so you can see the cost
			DrawUtilityForgeInfo(NP);
			DrawNanoBar(NP);
			DrawNanoBarForgeCore(NP);

			SetHUDDrawColor(eNANOHUDCOLOR_WHITE_DK);


			YPos = Canvas.SizeY - 42;
			Canvas.SetPos(34, YPos);


			if( ( bShowResponseSystem == TRUE ) && ( bFullScreenMenuIsUp == FALSE ) )
			{
				Canvas.Font = class'Engine'.static.GetTinyFont();
				YPos = DrawNPES( YPos );

				YPos = DrawAudioState( YPos );

				YPos = DrawMusicManager( YPos );

				YPos = DrawEncounterDirector( YPos );

				YPos = DrawCombatState( YPos );
			}


/*
			Canvas.DrawText( "SlomoGoal:"@NanoGRI(WorldInfo.GRI).OverriddenTimeDilation@"Curr:"@WorldInfo.TimeDilation, TRUE, 1.f, 1.f, TextRenderInfo);

			YPos -= 18;
			Canvas.SetPos(34, YPos);
			Canvas.DrawText( "FOVGoal:"@NanoGRI(WorldInfo.GRI).GetDesiredFOV()@"Curr:"@NanoGRI(WorldInfo.GRI).GetNanoPC().GetFOVAngle(), TRUE, 1.f, 1.f, TextRenderInfo);

			if( NanoWeap_Sword(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Weapon) != none )
			{
				AnimRate = NanoWeap_Sword(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Weapon).GetAnimationRate();
			}

			YPos -= 18;
			Canvas.SetPos(34, YPos);
			Canvas.DrawText( "AnimRateGoal:"@AnimRate@"AnimRate:"@AnimRate, TRUE, 1.f, 1.f, TextRenderInfo);

*/

			/*
			// Current Nano State
			YPos = Canvas.SizeY - 42;
			Canvas.SetPos(34, YPos);
			Canvas.DrawText(NP.CurrNanoState@"Ticks Absorbed:" @ NP.GetPRI().TicksAbsorbed, TRUE, 1.f, 1.f, TextRenderInfo);

			// if we have a mp7 then add on the ammo avail
			if( NanoWeap_MP7(NP.MyNanoWeapon) != none )
			{
				// Ammo owned
				YPos -= 18;
				Canvas.SetPos(34, YPos);
				ResourcesAvailString = "Ammo:" @ int(NP.MyNanoWeapon.WeaponMagSize - NP.MyNanoWeapon.AmmoUsedCount);
				Canvas.DrawText(ResourcesAvailString, TRUE, 1.f, 1.f, TextRenderInfo);
			}


			DrawLandingBar(NP);
			*/



			// Control background blur
			if( bFullScreenMenuIsUp == TRUE )
			{
				if( ( !bDebugNoMenu ) && ( NP.MenuBlurEffect != none ) )
				{
					NP.MenuBlurEffect.bShowInGame = TRUE;
				}

				// Pause game
				if(!NPC.IsPaused())
				{
					NPC.SetPause(TRUE);
					bPausedByHUD = TRUE;
				}
			}
			else
			{
				if( NP.MenuBlurEffect != none )
				{
					NP.MenuBlurEffect.bShowInGame = FALSE;
				}

				// Unpause game
 				if(NPC.IsPaused() && bPausedByHUD)
 				{
 					NPC.SetPause(FALSE);
					bPausedByHUD = FALSE;
 				}
			}

			// Draw the IRIS movies, if needed
			DrawIRIS(NP);

			if (ForgeHUDElement != None)
			{
				ForgeHUDElement.DrawHUDElements();
			}
			if (WeaponSelectHUDElement != None)
			{
				WeaponSelectHUDElement.DrawHUDElements();
			}

			// Draw current in-game menu
			if( !bDebugNoMenu )
			{
				DrawInGameMenu(NP);
			}
			else if( NPC.IsPaused() )
			{
				Canvas.SetPos(0, 0);
				Canvas.SetDrawColor(255,255,255,64);
				Canvas.DrawTile(Texture2D'EngineResources.WhiteSquareTexture',Canvas.SizeX,Canvas.SizeY, 0,0, 1,1);

				Canvas.TextSize("PAUSED", TextSizeX, TextSizeY);
				Canvas.SetPos((0.5 * Canvas.SizeX) - (0.5 * TextSizeX), (0.5 * Canvas.SizeY) - (0.5 * TextSizeY));
				Canvas.SetDrawColor(255,255,255,255);
				Canvas.DrawText("PAUSED", TRUE, 1.f, 1.f, TextRenderInfo);
			}

			// If moon is out - draw list, otherwise, draw just the one target
			
			// don't draw the targeting rectangles for the time being
// 			if(NanoPC(PlayerOwner).IsRicochetMoonActive())
// 			{
// 				AttemptToDrawTargetSelectionList( NanoPC(PlayerOwner).RicochetMoonTargets );
// 			}
// 			else
// 			{
// 				AttemptToDrawTargetSelection();
// 			}
			

			// Draw beacon directions
			//DrawBeaconDirections(NP, BeaconLocatorCenter, 1.0);

			if( !bMinimalHud )
			{
				// Let inventory manager draw stuff if desired
				if( NP.InvManager != None )
				{
					NanoInventoryManager(NP.InvManager).DrawNanoHUD( self );
				}


				/*
				DrawComboMeter(NP);
				*/		

				CheckDrawToolTip(NP);


				// Draw a message box
				if(WorldInfo.TimeSeconds < MessageEndTime)
				{
					DrawMessageBox(MessageString1, MessageString2);
				}

				// only show these if there is no chaos
				//if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() == 0 )
				//{
					if( Tutorials.Length > 0 )
					{
						if( Tutorials[0].TimeToShow < WorldInfo.TimeSeconds )
						{
							// if not up put it up
							if( bTutorialIsUp == FALSE )
							{
								TimeOfTutorial = WorldInfo.RealTimeSeconds;
								bTutorialIsUp = TRUE;
								if( Tutorials[0].bShouldPauseGame == TRUE )
								{
									NPC.SetPause( TRUE );
								}

								// If we want to play a sound, do so
								if((Tutorials[0].TutorialAction != None) && (Tutorials[0].TutorialAction.TutorialSound != None))
								{
									NPC.PlaySound(Tutorials[0].TutorialAction.TutorialSound);
								}
							}

							// we are up so draw it
							if( bTutorialIsUp == TRUE )
							{
								DrawTutorialMessageBox( Tutorials[0].TutorialScreen_Title, Tutorials[0].TutorialScreen_Body, Tutorials[0].MessageType, Tutorials[0].MinTimeForTutorialMessageToStayUp );
							}
						}
					}
				//}
			}
		}
	}
}



/** Start a message sliding on */
private final function SlideOnTextureMessage(Texture2D InTex, float InLife)
{
	SO_TargetPos.X = 0.5;
	SO_TargetPos.Y = 0.1;
	//SO_CurrentPosition.X = 0.0;
	//SO_CurrentPosition.Y = 0.5;
	SO_CurrentPosition.X = 0.85;
	SO_CurrentPosition.Y = 0.60;	
	SO_Lifetime = InLife;
	SO_Tex = InTex;
}

/** Called each frame, draws the sliding message if its still running  */
private final function DrawSlideOnTexture()
{
	local float TexRadX, TexRadY;

	if(SO_Lifetime > 0.0)
	{
		TexRadX = SO_Tex.SizeX * 0.5;
		TexRadY = SO_Tex.SizeY * 0.5;

		Canvas.SetDrawColor(255,255,255);
		Canvas.SetPos((SO_CurrentPosition.X * Canvas.SizeX) - TexRadX, (SO_CurrentPosition.Y * Canvas.SizeY) - TexRadY);
		Canvas.DrawTile(SO_Tex, SO_Tex.SizeX, SO_Tex.SizeY, 0.0, 0.0, SO_Tex.SizeX, SO_Tex.SizeY);
	}
}

/** Slide on a message for a particular chaos level */
exec function SlideChaosLevelMessage(int Level, float InLife)
{
	if(Level == 0)
	{
		SlideOnTextureMessage( Texture2D'ChaosLevTex.Peace', InLife );
	}
	else if(Level == 1)
	{
		SlideOnTextureMessage( Texture2D'ChaosLevTex.Level1', InLife );
	}
	else if(Level == 2)
	{
		SlideOnTextureMessage( Texture2D'ChaosLevTex.Level2', InLife );
	}
	else if(Level == 3)
	{
		SlideOnTextureMessage( Texture2D'ChaosLevTex.Level3', InLife );
	}
	else if(Level == 4)
	{
		SlideOnTextureMessage( Texture2D'ChaosLevTex.Level4', InLife );
	}
	else if(Level == 5)
	{
		SlideOnTextureMessage( Texture2D'ChaosLevTex.Level5', InLife );
	}
}







/** Start a message sliding on */
private final function SlideOnTextMessage(string InText, float InLife, Font InFont, SoundCue InSoundToPlay )
{
	local SlideOnTextDatum SOT;

	SOT.SOT_TargetPos.X = 0.5;
	SOT.SOT_TargetPos.Y = 0.1;
	//SOT_CurrentPosition.X = 0.0;
	//SOT_CurrentPosition.Y = 0.5;
	SOT.SOT_CurrentPosition.X = 0.85;
	SOT.SOT_CurrentPosition.Y = 0.60;	
	SOT.SOT_Lifetime = InLife;
	SOT.SOT_Text = InText;
	SOT.SOT_Font = InFont;
	SOT.SOT_SoundToPlay = InSoundToPlay;

	//`log ( GetFuncName() @ `showvar(SOT.SOT_Text) @ `showvar(SOT.SOT_Lifetime) );

	SOTs.AddItem( SOT );
}

/** Called each frame, draws the sliding message if its still running  */
private final function DrawSlideOnText()
{
	local FontRenderInfo FontInfo;
	local float TexRadX, TexRadY;
	local int Height, Width;
	local string TmpString;

	FontInfo.bClipText = TRUE;
	FontInfo.bEnableShadow = FALSE;

	// if nothing to draw
	if( SOTs.Length == 0 )
	{
		return;
	}

	if( SOTs[0].SOT_Lifetime > 0.0)
	{
		Canvas.Font = SOTs[0].SOT_Font;
		TmpString = SOTs[0].SOT_Text;
		Canvas.Font.GetStringHeightAndWidth( TmpString, Height, Width );

		//`log( `showvar(Height) @ `showvar(Width) @ `showvar(Canvas.Font) );

		TexRadX = Width * 0.5;
		TexRadY = Height * 0.5;

		Canvas.SetDrawColor(255,255,255); 
		Canvas.SetPos((SOTs[0].SOT_CurrentPosition.X * Canvas.SizeX) - TexRadX, (SOTs[0].SOT_CurrentPosition.Y * Canvas.SizeY) - TexRadY);
		//Canvas.DrawTile(SO_Tex, SO_Tex.SizeX, SO_Tex.SizeY, 0.0, 0.0, SO_Tex.SizeX, SO_Tex.SizeY);

		Canvas.DrawText(SOTs[0].SOT_Text, FALSE, 1.0f, 1.0f, FontInfo);
	}
}

/** Slide on a message for a particular chaos level */

// @TODO:  need to pass in scale, and start and target locations 
// @TODO:  pass in an array of start, target, times   so we can have things "fly around on a path"
exec function SlideTextMessage( coerce string InMessage, float InLife, Font InFont, SoundCue InSoundToPlay )
{
	if( InFont == None )
	{
		InFont = class'Engine'.static.GetLargeFont();
	}

	SlideOnTextMessage( InMessage, InLife, InFont, InSoundToPlay );
}


function DrawVelocityHistory(NanoPawn NP)
{
	local int Idx;
	local float DrawX, DrawY, Amt, VelAvg;
	local vector LastLoc;
	local color LineColor;
	local NanoVehicleAgent NVA;
	local int PawnVel;

	NVA = NanoVehicleAgent(NP.Base);

	if( `TimeSince(LastVelocitySampleTime) > 0.1f && NP.ActiveSpecialMove == None )
	{
		LastVelocitySampleTime = WorldInfo.TimeSeconds;
		
		if( NVA != none )
		{
			AccelHistory.AddItem(VSize2D(NP.Base.Acceleration));
			VelocityHistory.AddItem(VSize2D(NP.Base.Velocity));
			MaxSpeedHistory.AddItem(VSize2D(NP.Base.Velocity));
			GroundSpeedHistory.AddItem(VSize2D(NP.Base.Velocity));
		}
		else
		{
			AccelHistory.AddItem(VSize2D(NP.Acceleration));
			VelocityHistory.AddItem(VSize2D(NP.Velocity));
			MaxSpeedHistory.AddItem(NP.GetMaxSpeed());
			GroundSpeedHistory.AddItem(NP.GroundSpeed);
		}

		if (VelocityHistory.Length > 75)
		{
			AccelHistory.Remove(0,1);
			VelocityHistory.Remove(0,1);
			MaxSpeedHistory.Remove(0,1);
			GroundSpeedHistory.Remove(0,1);
		}
		if (bEnablePlayerTrail && !bFreezePlayerTrail && VSize(NP.Velocity) > 10)
		{
			Idx = PlayerTrail.Add(1);
			PlayerTrail[Idx].Location = NP.Location;
			PlayerTrail[Idx].Velocity = NP.Velocity;
			PlayerTrail[Idx].Physics = NP.Physics;
			PlayerTrail[Idx].NanoState = NP.CurrNanoState;
			if (Idx > 500)
			{
				PlayerTrail.Remove(0,50);
			}
		}
	}
	// draw the trail
	if (bEnablePlayerTrail)
	{
		LastLoc = NP.Location;
		for (Idx = PlayerTrail.Length - 1; Idx > 0; Idx--)
		{
			if (PlayerTrail[Idx].NanoState == ENS_Dust)
			{
				LineColor.R = 0;
				LineColor.G = 128;
				LineColor.B = 128;
			}
			else if (PlayerTrail[Idx].Physics == PHYS_Falling)
			{
				LineColor.R = 0;
				LineColor.G = 0;
				LineColor.B = 255;
			}
			else
			{
				LineColor.R = 0;
				LineColor.G = 255;
				LineColor.B = 0;
			}
			DrawDebugLine(LastLoc,PlayerTrail[Idx].Location,LineColor.R,LineColor.G,LineColor.B,FALSE);
			LastLoc = PlayerTrail[Idx].Location;
			DrawDebugLine(LastLoc,LastLoc + (vect(0,0,1) * VSize(PlayerTrail[Idx].Velocity)/5),LineColor.R,LineColor.G,LineColor.B,FALSE);
		}
	}
	// draw vel/accel graph
	DrawX = Canvas.ClipX - (VelocityHistory.Length * 6);
	DrawY = Canvas.ClipY;
	VelAvg = 0.f;
	for (Idx = 0; Idx < VelocityHistory.Length; Idx++)
	{
		Canvas.SetDrawColor(0,0,128,128);
		Amt = VelocityHistory[Idx]/20;
		VelAvg += VelocityHistory[Idx];
		Canvas.SetPos(DrawX,DrawY-Amt);
		Canvas.DrawBox(2,Amt);
		
		Canvas.SetDrawColor(255,255,255,128);
		Amt = GroundSpeedHistory[Idx]/20;
		Canvas.SetPos(DrawX,DrawY-Amt);
		Canvas.DrawBox(2,2);

		Canvas.SetDrawColor(255,0,0,128);
		Amt = MaxSpeedHistory[Idx]/20;
		Canvas.SetPos(DrawX,DrawY-Amt);
		Canvas.DrawBox(2,2);

		Canvas.SetDrawColor(0,128,0,128);
		Amt = AccelHistory[Idx]/20;
		Canvas.SetPos(DrawX+2,DrawY-Amt);
		Canvas.DrawBox(2,Amt);
		DrawX += 6;
	}
	// with some extra props
	if (VelocityHistory.Length > 0)
	{
		Canvas.SetPos(Canvas.ClipX - (VelocityHistory.Length * 6),DrawY-16);
		Canvas.Font = GetFontSizeIndex(0);
		Canvas.SetDrawColor(255,255,255,255);

		if( NVA != none )
		{
			PawnVel = int(VSize2D(NP.Base.Velocity));
		}
		else
		{
			PawnVel = int(VSize2D(NP.Velocity));
		}

		Canvas.DrawText("2D Vel (cur/avg):"@PawnVel$"/"$int(VelAvg/VelocityHistory.Length),,,,Text_ClipShadowed);
	}
	Canvas.SetPos(Canvas.ClipX - (VelocityHistory.Length * 6),DrawY-32);
	Canvas.DrawText("Air Cntrl:"@NP.AirControl,,,,Text_ClipShadowed);
	Canvas.SetPos(Canvas.ClipX - (VelocityHistory.Length * 6),DrawY-64);
	Canvas.DrawText("Vel Dot Rot:"@(NP.Velocity dot vector(NP.Rotation)),,,,Text_ClipShadowed);
}

final function DrawLandingBar(NanoPawn NP)
{
	local float Closeness;
	local NanoSkill_Jump JumpSkill;
	JumpSkill = NP.GetSkill(class'NanoSkill_Jump');
	if( JumpSkill != None && JumpSkill.bActive )
	{
		// Draw white background first
		Canvas.SetDrawColor( 255, 255, 255, 255 );
		Canvas.SetPos(Canvas.ClipX/2 - 60, Canvas.ClipY - 20);
		Canvas.DrawRect(120,4);
		// Draw blue bar showing max jump hold time
		Closeness = JumpSkill.JumpHoldToMaxBoostCounter / JumpSkill.JumpLevels[JumpSkill.SkillLevel].JumpHoldToMaxBoostTime;
		if( Closeness >= 1.f )
		{
			Canvas.SetDrawColor(10,10,255,255);
		}
		else
		{
			Canvas.SetDrawColor(50,50,180,255);
		}
		Canvas.SetPos(Canvas.ClipX/2 - (60 * Closeness), Canvas.ClipY - 20);
		Canvas.DrawRect(Closeness * 120,4);
	}
}

function ShowForgeUI(bool bShow)
{
	// draw forge UI
	ForgeHUDElement.SetForgeMenuHidden(!bShow);
}

function ShowWeaponSelectUI(bool bShow)
{
	// draw forge UI
	WeaponSelectHUDElement.SetForgeMenuHidden(!bShow);
}

function class<NanoPlan> GetSelectedForgeUIItem()
{
	if (!ForgeHUDElement.bHidden)
	{
		return ForgeHUDElement.GetSelectedPlan();
	}
	else if (!WeaponSelectHUDElement.bHidden)
	{
		return WeaponSelectHUDElement.GetSelectedPlan();
	}

	return None;
}




function DrawXPMessages()
{
	local int Idx;
	local float XL, YL, MsgAge, MaxMsgAge, FadeInTime, FadeOutTime, DrawY, DrawX, XPInterpTime;
	local string Msg;
	local FontRenderInfo RenderInfo;

	FadeInTime = 0.5f;
	MaxMsgAge = 8.f;
	FadeOutTime = 2.f;
	Canvas.Font = class'Engine'.static.GetTinyFont();
	RenderInfo.bEnableShadow = true;
	RenderInfo.bClipText = true;
	YL = 0.f;
	for (Idx = 0; Idx < XPMessages.Length; Idx++)
	{
		// grab the last draw height
		DrawY = XPMessages[Idx].LastDrawY;
		if (DrawY == 0)
		{
			if (Idx == 0)
			{
				DrawY = Canvas.ClipY - 20;
			}
			else
			{
				DrawY = XPMessages[Idx-1].LastDrawY - YL - 3;
			}
		}
		MsgAge = WorldInfo.TimeSeconds - XPMessages[Idx].MessageTime;
		if (MsgAge > MaxMsgAge)
		{
			XPMessages.Remove(Idx,1);
			continue;
		}
		XPInterpTime = FClamp((XPMessages[Idx].XPAmt - int(XPMessages[Idx].LastXPAmt))/5.f * 0.5f,1.f,3.f);
		XPMessages[Idx].LastXPAmt = Lerp(0.f,XPMessages[Idx].XPAmt,FMin(1.f,MsgAge/XPInterpTime));
		if (MsgAge > MaxMsgAge - FadeOutTime)
		{
			Canvas.SetDrawColor(200,200,200,255.f * (MaxMsgAge - MsgAge)/FadeOutTime);
		}
		else
		{
			Canvas.SetDrawColor(200,200,200,255);
		}
		Msg = XPMessages[Idx].Label@int(XPMessages[Idx].LastXPAmt)$"";
		Canvas.TextSize(Msg,XL,YL);
		DrawX = Canvas.ClipX - 20;
		if (MsgAge < FadeInTime)
		{
			DrawX -= XL * sin(Pi/2.f * MsgAge/FadeInTime);
		}
		else if (MsgAge > MaxMsgAge - FadeOutTime)
		{
			DrawX -= XL * (MaxMsgAge - MsgAge)/FadeOutTime;
		}
		else
		{
			DrawX -= XL;
		}
		Canvas.SetPos(DrawX,DrawY - YL);
		Canvas.DrawText(Msg,,,, RenderInfo);
		// mark this slot's last draw height
		XPMessages[Idx].LastDrawY = DrawY;
	}
}

final function DrawMissionBriefingDialog(NanoPawn NP)
{
	local float DrawX, DrawY, StrX, StrY;
	local MissionBriefingDialog MBD;

	// Handle updating the current dialog, if any, and remove old messages
	if( DialogMessages.Length > 0 )
	{
		DialogMessages[0].TimeToDisplay -= RenderDelta;

		// If this message has lived too long, destroy it
		if( DialogMessages[0].TimeToDisplay <= 0.f )
		{
			DialogMessages.Remove(0, 1);
		}
	}

	// If there's still something to display, render it here
	if( DialogMessages.Length > 0 )
	{
		// Cache this to avoid nasty dynamic array accesses
		MBD = DialogMessages[0];

		Canvas.Font = class'Engine'.static.GetLargeFont();
		SetHUDDrawColor(eNANOHUDCOLOR_WHITE_DK);
		
		DrawX = Canvas.ClipX / 2.f;
		DrawY = 3.f * Canvas.ClipY / 4.f;
		if( MBD.SpeakerName != "" )
		{
			Canvas.TextSize(MBD.SpeakerName, StrX, StrY);
			Canvas.SetPos(DrawX - StrX / 2.f, DrawY - StrY / 2.f);
			Canvas.DrawText(MBD.SpeakerName);

			DrawY += 2.f * StrY;
		}

		if( MBD.DialogText != "" )
		{
			Canvas.TextSize(MBD.DialogText, StrX, StrY);
			Canvas.SetPos(DrawX - StrX / 2.f, DrawY);
			Canvas.DrawText(MBD.DialogText);

			DrawY += 2.5f * StrY;
		}

		if( (NP != None) && NP.IsInState('MissionBriefing') )
		{
			SetHUDDrawColor(eNANOHUDCOLOR_CHATICONRED);
			Canvas.TextSize("(Hold B to skip)", StrX, StrY);
			Canvas.SetPos(DrawX - StrX / 2.f, DrawY);
			Canvas.DrawText("(Hold B to skip)");
		}
	}	
}

simulated function SetMissionBriefingDialog(string Speaker, string DialogText, float TimeToDisplay)
{
	local MissionBriefingDialog MBD;
	local int idx;

	MBD.SpeakerName = Speaker;
	MBD.DialogText = DialogText;
	MBD.TimeToDisplay = TimeToDisplay;

	idx = DialogMessages.Length + 1;
	DialogMessages.Length = idx;
	
	DialogMessages[idx] = MBD;
}

simulated function ClearMissionBriefingDialog()
{
	if( DialogMessages.Length > 0 )
	{
		DialogMessages.Remove(0, DialogMessages.Length);
	}
}

final function DrawMeleeInfo( NanoPawn NP )
{
	local int DrawX, DrawY, AttackBarWidth, AttackBarHeight, AttackPosWidth, AttackBarBonus;
	local AnimNodeSequence AnimSeqNode;
	local NanoWeap_Melee Weap;
	local float ComboWindowStartPct, ComboWindowEndPct, DeadZoneTime, DeadZoneStartPct, DeadZoneEndPct;
	local int DeadZoneIdx;
	local float InterruptTime, NotifyDuration;
	local AnimNotify Notify;
	local int Idx;
	local bool bAllowComboDuringRecovery;

	Weap = NanoWeap_Melee(NP.Weapon);
	if( Weap == None )
	{
		return;
	}

	AttackBarWidth  = 256.f;
	AttackBarHeight = 10.f;
	AttackPosWidth  = 2.f;
	AttackBarBonus  = 6.f;

	DrawX = (Canvas.ClipX * 0.5f) - (AttackBarWidth * 0.5f);
	DrawY = (Canvas.ClipY - 80.f) - (AttackBarHeight * 0.5f);

	// Draw base attack bar
	SetHUDDrawColor(eNANOHUDCOLOR_BLACK);
	Canvas.SetPos( DrawX, DrawY );
	Canvas.DrawRect( AttackBarWidth, AttackBarHeight );

	if( Weap.IsFiring() && (GetCurrentUIPage() == None) )
	{
		AnimSeqNode = NP.FullBodySlot.GetCustomAnimNodeSeq();
		if( AnimSeqNode.AnimSeq != None )
		{
			MeleeAttackName				= Weap.LastAttackName;
			MeleeAttackSpeedScale		= Weap.AttackSpeedScale;
			MeleeAttackLength			= Weap.WeaponSheet.GetAttackLength() / MeleeAttackSpeedScale;
			MeleeComboWindowStart		= Weap.WeaponSheet.GetNotifyTime( class'NanoAnimNotify_ComboStart', MeleeAttackSpeedScale,,, NotifyDuration );
			MeleeComboWindowEnd         = MeleeComboWindowStart + NotifyDuration;
			MeleeComboSuccessTransition = Weap.WeaponSheet.GetNotifyTime( class'NanoAnimNotify_ComboSuccessTransition', MeleeAttackSpeedScale );
			MeleeComboFailTransition	= Weap.WeaponSheet.GetNotifyTime( class'NanoAnimNotify_ComboFailTransition', MeleeAttackSpeedScale,, Notify );
			bAllowComboDuringRecovery   = NanoAnimNotify_ComboFailTransition(Notify).bAllowComboTransDuringRecovery;

			MeleeComboJumpInterrupt.Length = 0;
			MeleeComboMoveInterrupt.Length = 0;

			InterruptTime = -1.f;
			do 
			{
				InterruptTime = Weap.WeaponSheet.GetNotifyTime( class'NanoAnimNotify_ComboJumpInterrupt', MeleeAttackSpeedScale, InterruptTime, Notify );
				if( InterruptTime > 0 )
				{
					Idx = MeleeComboJumpInterrupt.Length;
					MeleeComboJumpInterrupt.Length = Idx + 1;
					MeleeComboJumpInterrupt[Idx].NotifyTime = InterruptTime;
					MeleeComboJumpInterrupt[Idx].bAllow = NanoAnimNotify_ComboJumpInterrupt(Notify).bAllowJumpInterupt;
				}
			} until( InterruptTime < 0.f );			

			InterruptTime = -1.f;
			do
			{
				InterruptTime = Weap.WeaponSheet.GetNotifyTime( class'NanoAnimNotify_ComboMoveInterrupt', MeleeAttackSpeedScale, InterruptTime, Notify );
				if( InterruptTime > 0 )
				{
					Idx = MeleeComboMoveInterrupt.Length;
					MeleeComboMoveInterrupt.Length = Idx + 1;
					MeleeComboMoveInterrupt[Idx].NotifyTime = InterruptTime;
					MeleeComboMoveInterrupt[Idx].bAllow = NanoAnimNotify_ComboMoveInterrupt(Notify).bAllowMoveInterupt;
				}
			} until( InterruptTime < 0.f );

			if( !AnimSeqNode.bLooping )
			{
				MeleeAttackPos = Weap.WeaponSheet.GetAttackPosition( AnimSeqNode ) / MeleeAttackLength;
			}

			MeleeComboDeadZonePairs.Length = 0;
			DeadZoneTime = -1.f;
			do 
			{
				DeadZoneTime = Weap.WeaponSheet.GetNotifyTime( class'NanoAnimNotify_ComboDeadzoneBegin', MeleeAttackSpeedScale, DeadZoneTime,, NotifyDuration );
				if( DeadZoneTime >= 0 )
				{
					MeleeComboDeadZonePairs[MeleeComboDeadZonePairs.Length] = DeadZoneTime;
					MeleeComboDeadZonePairs[MeleeComboDeadZonePairs.Length] = (NotifyDuration <= 0.f) ? MeleeAttackLength : (DeadZoneTime + NotifyDuration);
				}
			} until( DeadZoneTime < 0.f );
		}
	}
	
	if( !Weap.bDebugIgnoreSweetSpot )
	{
		if(  MeleeComboWindowStart >= 0.f && MeleeComboWindowEnd >= 0.f )
		{
			ComboWindowStartPct = MeleeComboWindowStart / MeleeAttackLength;
			ComboWindowEndPct = MeleeComboWindowEnd / MeleeAttackLength;

			SetHUDDrawColor(eNANOHUDCOLOR_GRAY);
			Canvas.SetPos( DrawX + (AttackBarWidth * ComboWindowStartPct), DrawY );
			Canvas.DrawRect( (ComboWindowEndPct - ComboWindowStartPct) * AttackBarWidth, AttackBarHeight );
		}

		if( MeleeComboSuccessTransition >= 0.f )
		{
			SetHUDDrawColor(eNANOHUDCOLOR_GREEN);
			Canvas.SetPos( DrawX + (AttackBarWidth * MeleeComboSuccessTransition / MeleeAttackLength) - (AttackPosWidth * 0.5f), DrawY - (AttackBarBonus * 0.5f) );
			Canvas.DrawRect( AttackPosWidth, AttackBarHeight + AttackBarBonus );
		}
	}

	for( Idx = 0; Idx < MeleeComboJumpInterrupt.Length; Idx++ )
	{
		Canvas.SetPos( DrawX + (AttackBarWidth * MeleeComboJumpInterrupt[Idx].NotifyTime / MeleeAttackLength) - (AttackPosWidth * 0.5f) - 2, DrawY - (AttackBarBonus * 0.5f) - 14 );
		if( MeleeComboJumpInterrupt[Idx].bAllow )
		{
			SetHUDDrawColor(eNANOHUDCOLOR_GREEN);
		}
		else
		{
			SetHUDDrawColor(eNANOHUDCOLOR_RED);
		}		
		Canvas.DrawText( "J" );
		Canvas.SetPos( DrawX + (AttackBarWidth * MeleeComboJumpInterrupt[Idx].NotifyTime / MeleeAttackLength) - (AttackPosWidth * 0.5f), DrawY - (AttackBarBonus * 0.5f) );
		Canvas.DrawRect( AttackPosWidth, AttackBarHeight + AttackBarBonus );
	}
	
	for( Idx = 0; Idx < MeleeComboMoveInterrupt.Length; Idx++ )
	{
		Canvas.SetPos( DrawX + (AttackBarWidth * MeleeComboMoveInterrupt[Idx].NotifyTime / MeleeAttackLength) - (AttackPosWidth * 0.5f) - 2, DrawY - (AttackBarBonus * 0.5f) - 14 );
		if( MeleeComboMoveInterrupt[Idx].bAllow )
		{
			SetHUDDrawColor(eNANOHUDCOLOR_GREEN);
		}
		else
		{
			SetHUDDrawColor(eNANOHUDCOLOR_RED);
		}		
		Canvas.DrawText( "M" );
		Canvas.SetPos( DrawX + (AttackBarWidth * MeleeComboMoveInterrupt[Idx].NotifyTime / MeleeAttackLength) - (AttackPosWidth * 0.5f), DrawY - (AttackBarBonus * 0.5f) );
		Canvas.DrawRect( AttackPosWidth, AttackBarHeight + AttackBarBonus );
	}

	if( MeleeComboFailTransition >= 0.f )
	{
		SetHUDDrawColor(eNANOHUDCOLOR_RED);
		Canvas.SetPos( DrawX + (AttackBarWidth * MeleeComboFailTransition / MeleeAttackLength) - (AttackPosWidth * 0.5f), DrawY - (AttackBarBonus * 0.5f) );
		Canvas.DrawRect( AttackPosWidth, AttackBarHeight + AttackBarBonus );

		DeadZoneStartPct = MeleeComboFailTransition / MeleeAttackLength;
		DeadZoneEndPct = 1.f;

		if( bAllowComboDuringRecovery )
		{
			SetHUDDrawColor(eNANOHUDCOLOR_GREEN);
		}
		else
		{
			SetHUDDrawColor(eNANOHUDCOLOR_RED);
		}
		Canvas.SetPos( DrawX + (AttackBarWidth * DeadZoneStartPct), DrawY );
		Canvas.DrawRect( (DeadZoneEndPct - DeadZoneStartPct) * AttackBarWidth, AttackBarHeight );
	}

	if( MeleeComboDeadZonePairs.Length > 0 )
	{
		for( DeadZoneIdx = 0; DeadZoneIdx < MeleeComboDeadZonePairs.Length; DeadZoneIdx++ )
		{
			DeadZoneStartPct = MeleeComboDeadZonePairs[DeadZoneIdx] / MeleeAttackLength;
			DeadZoneIdx++;
			DeadZoneEndPct = MeleeComboDeadZonePairs[DeadZoneIdx] / MeleeAttackLength;

			SetHUDDrawColor(eNANOHUDCOLOR_RED);
			Canvas.SetPos( DrawX + (AttackBarWidth * DeadZoneStartPct), DrawY );
			Canvas.DrawRect( (DeadZoneEndPct - DeadZoneStartPct) * AttackBarWidth, AttackBarHeight );
		}
	}

	SetHUDDrawColor(eNANOHUDCOLOR_WHITE);
	if( Weap.DesiredComboIdx >= 0 )
	{
/*		if( Weap.bComboWindowActivateNextCombo )
		{
			SetHUDDrawColor(eNANOHUDCOLOR_GREEN);
		}
		else
		{
			SetHUDDrawColor(eNANOHUDCOLOR_RED);
		}
*/
		if( Weap.ComboInput.ButtonPressed == Weap.AttackButtonOne )
		{
			SetHUDDrawColor( eNANOHUDCOLOR_BLUE );
		}
		else
		{
			SetHUDDrawColor( eNANOHUDCOLOR_Yellow );
		}
	}
	Canvas.SetPos( DrawX + (AttackBarWidth * MeleeAttackPos) - (AttackPosWidth * 0.5f), DrawY - (AttackBarHeight * 0.25f) );
	Canvas.DrawRect( AttackPosWidth, AttackBarHeight * 1.5f );
}


final function DrawInteractionBar( NanoPawn NP )
{
	local float DrawX, DrawY;
	local float RatioOfRebelMindShare;
	local float RatioOfFull;
	local NanoInterface_Interact Interact;
	local InteractableComponent Comp;


	if( NanoPC(NP.Controller).CurrentlyAbsorbingObjects.Length == 0 )
	{
		return;
	}

	DrawX = 0.50f * Canvas.ClipX;
	DrawX -= 100.0f;
	DrawY = 0.75f * Canvas.ClipY;
	DrawY += 50.0f;

	Interact = NanoPC(NP.Controller).CurrentlyAbsorbingObjects[0];

	if( Interact == None )
	{
		`warn( "Badness! A Interact is none in the CurrentlyAbsorbingObjects" @ `showvar(NanoPC(NP.Controller).CurrentlyAbsorbingObjects.Length) );
		return;
	}

	Comp = Interact.GetInteractableComponent();

	if( Comp != none )
	{
		RatioOfRebelMindShare = 1.0f;

		RatioOfFull = RatioOfRebelMindShare * 200;

		// draw light blue background
		SetHUDDrawColor(eNANOHUDCOLOR_CHATICONBLUE);
		Canvas.SetPos( DrawX, DrawY );
		Canvas.DrawRect( RatioOfFull, 10 );


		// now draw a blue color for the actual amount of rebel mindshare we have

		RatioOfRebelMindShare = FClamp( ((Comp.TimeSpentAbsorbing / Comp.AbsorbTime) * 200.0f) / 200.0f, 0.0f, 1.0f );

		RatioOfFull = RatioOfRebelMindShare * 200;

		// draw light blue background
		SetHUDDrawColor(eNANOHUDCOLOR_BLUE);
		Canvas.SetPos( DrawX, DrawY );
		Canvas.DrawRect( RatioOfFull, 10 );

		//`log( `showvar(RatioOfRebelMindShare) @ `showvar(RatioOfFull) );

	}
}




final function DrawImportantCharacterData( NanoPawn NP )
{
	local float DrawX, DrawY;

	// we are going to draw right under the mindshare bar
	DrawX = MapDrawInfo.Minimap_UL.X*Canvas.SizeX;
	DrawY = MapDrawInfo.Minimap_UL.Y*Canvas.SizeX + MapDrawInfo.MinimapSize.X*Canvas.SizeX + 10; // SizeX is what the minimap uses 
	DrawY += 18;


	Canvas.Font = class'Engine'.static.GetTinyFont();
	SetHUDDrawColor(eNANOHUDCOLOR_WHITE);
	Canvas.SetPos( DrawX, DrawY );
	Canvas.DrawText( "Currency:" @ NanoGRI(WorldInfo.GRI).GetNanoPC().GetPRI().AmountOfCurrencyOwned );
}


final function DrawRebelMindShareBar( NanoPawn NP )
{
	local float DrawX, DrawY;
	local float RatioOfRebelMindShare;
	local float RatioOfFull;

	local RebelMindShareManager RMSM;

	local float SizeOfMindShareBar;

	DrawX = MapDrawInfo.Minimap_UL.X*Canvas.SizeX;
	DrawY = MapDrawInfo.Minimap_UL.Y*Canvas.SizeX + MapDrawInfo.MinimapSize.X*Canvas.SizeX + 10; // SizeX is what the minimap uses 


	RMSM = NanoGRI(WorldInfo.GRI).GetCurrentRebelMindShareManager();

	if( RMSM != none )
	{
		RatioOfRebelMindShare = 1.0f;
		SizeOfMindShareBar = 115.0f;

		RatioOfFull = RatioOfRebelMindShare * SizeOfMindShareBar;

		//// Draw Label
		Canvas.Font = class'Engine'.static.GetTinyFont();
		SetHUDDrawColor(eNANOHUDCOLOR_WHITE);
		Canvas.SetPos( DrawX, DrawY );
		Canvas.DrawText( "RebelMindShare:" );

		DrawX += 200 - SizeOfMindShareBar;

		DrawY += 5;

		//// Draw Bar
		// draw light blue background
		SetHUDDrawColor(eNANOHUDCOLOR_CHATICONBLUE);
		Canvas.SetPos( DrawX, DrawY );
		Canvas.DrawRect( RatioOfFull, 4 );


		// now draw a blue color for the actual amount of rebel mindshare we have

		RatioOfRebelMindShare = FClamp( (RMSM.GetRebelMindShareLevel()) / class'RebelMindShareManager'.default.MaxAmountOfRebelMindShare, 0.0f, 1.0f );

		RatioOfFull = RatioOfRebelMindShare * SizeOfMindShareBar;

		// draw light blue background
		SetHUDDrawColor(eNANOHUDCOLOR_BLUE);
		Canvas.SetPos( DrawX, DrawY );
		Canvas.DrawRect( RatioOfFull, 4 );

		//`log( `showvar(RatioOfChaosDecay) @ `showvar(RatioOfFull) @ `TimeSince(CM.TimeOfInsideAIThreatQueryView) @ `showvar(NanoGRI(WorldInfo.GRI).NPES.DurationOutsideOfHotZoneToResetChaos) );
		
	}
}

final function DrawQuickBindOptions(NanoPawn NP)
{
	local NanoPRI NPRI;
	local vector2d ScreenCenter;
	local float DPadSize, IconSize, IconDPadSpace, IconTextSpace;
	local float XL, YL;
	local color PlanColor, SelectedColor, UnselectedColor;

	NPRI = NanoPRI(NP.PlayerReplicationInfo);
	ScreenCenter.X = 0.5*Canvas.SizeX;
	ScreenCenter.Y = 0.5*Canvas.SizeY;

	DPadSize = 64;

	Canvas.SetPos( ScreenCenter.X - (0.5*DPadSize), ScreenCenter.Y - (0.5*DPadSize) );
	Canvas.SetDrawColor(255,255,255,255);
	Canvas.DrawTile(Texture2D'UI_HUD.Menu.DPad', DPadSize,DPadSize, 0,0, 256,256);

	IconSize = 48;
	IconDPadSpace = 12;
	IconTextSpace = 12;

	SelectedColor = MakeColor(255, 225, 0, 255);
	UnselectedColor = MakeColor(255, 225, 255, 255);

	if(NPRI.QuickBindPlans[0] != None)
	{
		PlanColor = (NPRI.QuickBindPlans[0] == NPRI.UtilityPlan) ? SelectedColor : UnselectedColor;

		Canvas.SetPos( ScreenCenter.X - (0.5*IconSize), ScreenCenter.Y - (0.5*DPadSize) - IconDPadSpace - IconSize );
		Canvas.SetDrawColorStruct(PlanColor);
		DrawTileCoords(NPRI.QuickBindPlans[0].default.PlanIcon.IconTex, IconSize, IconSize, NPRI.QuickBindPlans[0].default.PlanIcon.Coords);

		Canvas.StrLen(NPRI.QuickBindPlans[0].default.ForgeUIData.PlanName, XL, YL);
		Canvas.SetPos( ScreenCenter.X - (0.5*XL), ScreenCenter.Y - (0.5*DPadSize) - IconDPadSpace - IconSize - IconTextSpace - YL );
		Canvas.DrawText(NPRI.QuickBindPlans[0].default.ForgeUIData.PlanName);
	}

	if(NPRI.QuickBindPlans[1] != None)
	{
		PlanColor = (NPRI.QuickBindPlans[1] == NPRI.UtilityPlan) ? SelectedColor : UnselectedColor;

		Canvas.SetPos( ScreenCenter.X - (0.5*IconSize), ScreenCenter.Y + (0.5*DPadSize) + IconDPadSpace );
		Canvas.SetDrawColorStruct(PlanColor);
		DrawTileCoords(NPRI.QuickBindPlans[1].default.PlanIcon.IconTex, IconSize, IconSize, NPRI.QuickBindPlans[1].default.PlanIcon.Coords);

		Canvas.StrLen(NPRI.QuickBindPlans[1].default.ForgeUIData.PlanName, XL, YL);
		Canvas.SetPos( ScreenCenter.X - (0.5*XL), ScreenCenter.Y + (0.5*DPadSize) + IconDPadSpace + IconSize + IconTextSpace );
		Canvas.DrawText(NPRI.QuickBindPlans[1].default.ForgeUIData.PlanName);
	}

	if(NPRI.QuickBindPlans[2] != None)
	{
		PlanColor = (NPRI.QuickBindPlans[2] == NPRI.UtilityPlan) ? SelectedColor : UnselectedColor;

		Canvas.SetPos( ScreenCenter.X - (0.5*DPadSize) - IconDPadSpace - IconSize, ScreenCenter.Y - (0.5*IconSize) );
		Canvas.SetDrawColorStruct(PlanColor);
		DrawTileCoords(NPRI.QuickBindPlans[2].default.PlanIcon.IconTex, IconSize, IconSize, NPRI.QuickBindPlans[2].default.PlanIcon.Coords);	

		Canvas.StrLen(NPRI.QuickBindPlans[2].default.ForgeUIData.PlanName, XL, YL);
		Canvas.SetPos( ScreenCenter.X - (0.5*DPadSize) - IconDPadSpace - IconSize - IconTextSpace - XL, ScreenCenter.Y - (0.5*YL) );
		Canvas.DrawText(NPRI.QuickBindPlans[2].default.ForgeUIData.PlanName);
	}

	if(NPRI.QuickBindPlans[3] != None)
	{
		PlanColor = (NPRI.QuickBindPlans[3] == NPRI.UtilityPlan) ? SelectedColor : UnselectedColor;

		Canvas.SetPos( ScreenCenter.X + (0.5*DPadSize) + IconDPadSpace, ScreenCenter.Y - (0.5*IconSize) );
		Canvas.SetDrawColorStruct(PlanColor);
		DrawTileCoords(NPRI.QuickBindPlans[3].default.PlanIcon.IconTex, IconSize, IconSize, NPRI.QuickBindPlans[3].default.PlanIcon.Coords);	

		Canvas.StrLen(NPRI.QuickBindPlans[3].default.ForgeUIData.PlanName, XL, YL);
		Canvas.SetPos( ScreenCenter.X + (0.5*DPadSize) + IconDPadSpace + IconSize + IconTextSpace, ScreenCenter.Y - (0.5*YL) );
		Canvas.DrawText(NPRI.QuickBindPlans[3].default.ForgeUIData.PlanName);
	}

}

final function DrawUtilityForgeInfo(NanoPawn NP)
{
	local NanoPRI NPRI;
	local int DrawY, StartNanoUseX, EndNanoUseX, BucketsNeeded, BucketLength, UseBarExpand;
	local color NanoUseColor;
	local bool bCanAffordForge;
	local bool bCanAffordForgeNanoPower;
	local bool bCanAffordForgeNanoPowerForgeCores;

	UseBarExpand = 2; // how much around the blips to draw
  
	// Draw icon for selected free forge
	NPRI = NanoPRI(NP.PlayerReplicationInfo);
	if(NPRI.UtilityPlan != None)
	{
		// draw the Plan Icon
		bCanAffordForgeNanoPower = NP.HasEnoughNanoBuckets(NPRI.UtilityPlan.default.NumNanoPowerBucketsToUse, FALSE);
		bCanAffordForgeNanoPowerForgeCores = NP.HasEnoughNanoForgeCoreBuckets(NPRI.UtilityPlan.default.NumNanoPowerForgeCoreBucketsToUse, FALSE);

		bCanAffordForge = bCanAffordForgeNanoPower && bCanAffordForgeNanoPowerForgeCores;
		NanoUseColor = bCanAffordForge ? MakeColor(255, 255, 255, 128) : MakeColor(255, 128, 128, 128);

		DrawY = 50;
		Canvas.SetPos( Canvas.SizeX - 20 - NanoFreeForgeIconSize, DrawY );
		Canvas.SetDrawColor(NanoUseColor.R, NanoUseColor.G, NanoUseColor.B, NanoUseColor.A);
		DrawTileCoords(NPRI.UtilityPlan.default.PlanIcon.IconTex, NanoFreeForgeIconSize, NanoFreeForgeIconSize, NPRI.UtilityPlan.default.PlanIcon.Coords);	


		// Draw a nice over lapping translucent box to show how many bucket this would use
		BucketsNeeded = NPRI.UtilityPlan.default.NumNanoPowerBucketsToUse;
		BucketLength = NanoPowerBarMaxLength/NP.NumOfNanoPowerBuckets;

		bCanAffordForge = bCanAffordForgeNanoPower;
		NanoUseColor = bCanAffordForge ? MakeColor(255, 255, 255, 128) : MakeColor(255, 128, 128, 128);

		bCanAffordForge = NP.HasEnoughNanoBuckets(BucketsNeeded, FALSE);
		NanoUseColor = bCanAffordForge ? MakeColor(255, 255, 255, 128) : MakeColor(255, 128, 128, 128);

		EndNanoUseX = Canvas.SizeX - 20 + UseBarExpand;
		StartNanoUseX = EndNanoUseX - ((BucketsNeeded * BucketLength) + ((BucketsNeeded-1) * 4)) - UseBarExpand;

		DrawY = 20;
		Canvas.SetPos(StartNanoUseX - UseBarExpand, DrawY - UseBarExpand);
		Canvas.SetDrawColor(NanoUseColor.R, NanoUseColor.G, NanoUseColor.B, NanoUseColor.A);
		Canvas.DrawRect(EndNanoUseX - StartNanoUseX, NanoPowerBarMaxWidth + (2*UseBarExpand));


		// Draw a nice over lapping translucent box to show how many bucket this would use
		BucketsNeeded = NPRI.UtilityPlan.default.NumNanoPowerForgeCoreBucketsToUse;
		BucketLength = NanoPowerForgeCoreBarMaxLength/NP.NumOfNanoPowerForgeCoreBuckets;

		bCanAffordForge = bCanAffordForgeNanoPowerForgeCores;
		NanoUseColor = bCanAffordForge ? MakeColor(255, 255, 255, 128) : MakeColor(255, 128, 128, 128);

		EndNanoUseX = Canvas.SizeX - 20 + UseBarExpand;
		StartNanoUseX = EndNanoUseX - ((BucketsNeeded * BucketLength) + ((BucketsNeeded-1) * 4)) - UseBarExpand;

		DrawY = 35;
		Canvas.SetPos(StartNanoUseX - UseBarExpand, DrawY - UseBarExpand);
		Canvas.SetDrawColor(NanoUseColor.R, NanoUseColor.G, NanoUseColor.B, NanoUseColor.A);
		Canvas.DrawRect(EndNanoUseX - StartNanoUseX, NanoPowerBarMaxWidth + (2*UseBarExpand));
	}
}

final function DrawNanoBar(NanoPawn NP)
{
    local int DrawX, DrawY, RemainingPower, Idx, BucketLength;
    local float BucketSize;

    DrawX = 20 + NanoPowerBarMaxWidth + 1;
    DrawY = Canvas.SizeY - 10;
	
	// what does this do?
	if( NP.NanoPowerExpiration != 0.f && NP.NanoPowerDuration != 0.f )
	{
		BucketSize = (NP.NanoPowerExpiration - WorldInfo.TimeSeconds)/NP.NanoPowerDuration * NanoPowerBarMaxLength;
		Canvas.SetDrawColor(0,128,255,255);
		Canvas.SetPos(DrawX,DrawY - BucketSize);
		Canvas.DrawRect(NanoPowerBarMaxWidth,BucketSize);
	}

	// upper right hand corner
    DrawX = Canvas.SizeX - 20 - (NP.NanoPowerBucketSize/NP.NanoPowerBucketSize);
    DrawY = 20; // (  Canvas.SizeY - 20 );

	RemainingPower = NP.GetNanoPower();
    if (RemainingPower < NP.NanoPowerBucketSize)
    {
		Canvas.SetPos(Canvas.ClipX * 0.5f, Canvas.ClipY - 80);
		if (RemainingPower == 0.f)
		{
			Canvas.SetDrawColor(200,0,0,255);
			DrawTextCentered("!! warning: out of nano power !!");
		}
		else
		{
			Canvas.SetDrawColor(200,200,0,200*(WorldInfo.TimeSeconds%0.5));
			DrawTextCentered("warning: low nano power");
		}
    }

	// draw the grey smaller rectangles to show empty ones
    BucketLength = NanoPowerBarMaxLength/NP.NumOfNanoPowerBuckets;
	BucketSize = NP.NanoPowerBucketSize/NP.NanoPowerBucketSize;
	for (Idx = 0; Idx < NP.NumOfNanoPowerBuckets; Idx++)
	{
		Canvas.SetDrawColor( 200, 200, 200, 255 );
		Canvas.SetPos( DrawX - (BucketSize * BucketLength), DrawY + (NanoPowerBarMaxWidth * 0.5) );
		Canvas.DrawRect( BucketSize * BucketLength, NanoPowerBarMaxWidth * 0.5 );

		DrawX -= BucketLength + 4;
	}


	// draw over with Blue for the full nano juice rectangles
	DrawX = Canvas.SizeX - 20 - (NP.NanoPowerBucketSize/NP.NanoPowerBucketSize);

    for (Idx = 0; Idx < NP.NumOfNanoPowerBuckets; Idx++)
    {
		BucketSize = Min(RemainingPower,NP.NanoPowerBucketSize)/NP.NanoPowerBucketSize;
		if (WorldInfo.TimeSeconds < NP.NanoPowerCooldownExpiration)
		{
			Canvas.SetDrawColor( 100, 100, 200, 255 * BucketSize);
		}
		else
		{
			Canvas.SetDrawColor(0,128,255,255 * BucketSize);
		}
		
		Canvas.SetPos( DrawX - (BucketSize * BucketLength), DrawY );
		Canvas.DrawRect( BucketSize * BucketLength, NanoPowerBarMaxWidth );
		
		if (BucketSize < 1.f)
		{
			break;
		}
		DrawX -= BucketLength + 4;
		RemainingPower -= NP.NanoPowerBucketSize;
    }
}


final function DrawNanoBarForgeCore(NanoPawn NP)
{
	local int DrawX, DrawY, RemainingPower, Idx, BucketLength;
	local float BucketSize;

	DrawX = 20 + NanoPowerForgeCoreBarMaxWidth + 1;
	DrawY = Canvas.SizeY - 10;

	// what does this do?
	if( NP.NanoPowerExpiration != 0.f && NP.NanoPowerDuration != 0.f )
	{
		BucketSize = (NP.NanoPowerExpiration - WorldInfo.TimeSeconds)/NP.NanoPowerDuration * NanoPowerForgeCoreBarMaxLength;
		Canvas.SetDrawColor(0,128,255,255);
		Canvas.SetPos(DrawX,DrawY - BucketSize);
		Canvas.DrawRect(NanoPowerForgeCoreBarMaxWidth,BucketSize);
	}

	// upper right hand corner
	DrawX = Canvas.SizeX - 20 - (NP.NanoPowerForgeCoreBucketSize/NP.NanoPowerForgeCoreBucketSize);
	DrawY = 35; // (  Canvas.SizeY - 20 );

	RemainingPower = NP.GetNanoPowerForgeCore();

	// don't draw this as you will basically always be out of this resource probably
// 	if (RemainingPower < NP.NanoPowerForgeCoreBucketSize)
// 	{
// 		Canvas.SetPos(Canvas.ClipX * 0.5f, Canvas.ClipY - 80);
// 		if (RemainingPower == 0.f)
// 		{
// 			Canvas.SetDrawColor(200,0,0,255);
// 			DrawTextCentered("!! warning: out of nano power !!");
// 		}
// 		else
// 		{
// 			Canvas.SetDrawColor(200,200,0,200*(WorldInfo.TimeSeconds%0.5));
// 			DrawTextCentered("warning: low nano power");
// 		}
// 	}

	// draw the grey smaller rectangles to show empty ones
	BucketLength = NanoPowerForgeCoreBarMaxLength/NP.NumOfNanoPowerForgeCoreBuckets;
	BucketSize = NP.NanoPowerForgeCoreBucketSize/NP.NanoPowerForgeCoreBucketSize;
	for (Idx = 0; Idx < NP.NumOfNanoPowerForgeCoreBuckets; Idx++)
	{
		Canvas.SetDrawColor( 200, 200, 200, 255 );
		Canvas.SetPos( DrawX - (BucketSize * BucketLength), DrawY + (NanoPowerForgeCoreBarMaxWidth * 0.5) );
		Canvas.DrawRect( BucketSize * BucketLength, NanoPowerForgeCoreBarMaxWidth * 0.5 );

		DrawX -= BucketLength + 4;
	}


	// draw over with Blue for the full nano juice rectangles
	DrawX = Canvas.SizeX - 20 - (NP.NanoPowerForgeCoreBucketSize/NP.NanoPowerForgeCoreBucketSize);

	for (Idx = 0; Idx < NP.NumOfNanoPowerForgeCoreBuckets; Idx++)
	{
		BucketSize = Min(RemainingPower,NP.NanoPowerForgeCoreBucketSize)/NP.NanoPowerForgeCoreBucketSize;
		if (WorldInfo.TimeSeconds < NP.NanoPowerCooldownExpiration)
		{
			Canvas.SetDrawColor( 100, 100, 200, 255 * BucketSize);
		}
		else
		{
			Canvas.SetDrawColor(148,0,211,255 * BucketSize);
		}

		Canvas.SetPos( DrawX - (BucketSize * BucketLength), DrawY );
		Canvas.DrawRect( BucketSize * BucketLength, NanoPowerForgeCoreBarMaxWidth );

		if (BucketSize < 1.f)
		{
			break;
		}
		DrawX -= BucketLength + 4;
		RemainingPower -= NP.NanoPowerForgeCoreBucketSize;
	}
}


final function DrawHealthBar(NanoPawn NP)
{
	local float DrawX, DrawY, BarLength, BarWidth, TimeSinceHit, Alpha, BarGrowth, HealthPct;
	local int Idx;
	
	// draw the background
	DrawY = 12 + (HealthBarMaxWidth * 0.5);
	BarLength = HealthBarMaxLength;
	DrawX = 0 + 15 ;//+ BarLength;
	SetHUDDrawColor(eNANOHUDCOLOR_WHITE_DK);
	Canvas.SetPos(DrawX,DrawY);
	Canvas.DrawRect(BarLength,HealthBarMaxWidth * 0.5,);
	
	// draw the current health
	DrawY = 12;
	HealthPct = FMin(NP.Health/float(NP.DefaultHealth), 1.f);
	BarLength = HealthPct * HealthBarMaxLength;
	DrawX = 0 + 15 ;//+ BarLength;
	Canvas.SetDrawColor(220,50,50,255);
	Canvas.SetPos(DrawX,DrawY);
	Canvas.DrawRect(BarLength , HealthBarMaxWidth);
	BarGrowth = HealthBarMaxWidth * 0.75;
	
	// draw recent hits
	for (Idx = NP.RecentHits.Length - 1; Idx >= 0; Idx--)
	{
		TimeSinceHit = `TimeSince(NP.RecentHits[Idx].TimeOfHit);
		if (TimeSinceHit < 1.f)
		{
			BarWidth = NP.RecentHits[Idx].Damage/float(NP.DefaultHealth) * HealthBarMaxLength;
			DrawX += BarLength;
			if (TimeSinceHit < 0.5f)
			{
				Alpha = TimeSinceHit/0.5f;
				Canvas.SetDrawColor(220 + (35 * Alpha),50 * (1.f - Alpha),50 * (1.f - Alpha),255);
				BarLength = HealthBarMaxWidth + (BarGrowth * Alpha);
				DrawY = 12 - (BarGrowth * Alpha);
			}
			else
			{
				Alpha = (TimeSinceHit - 0.5f)/0.5f;
				Canvas.SetDrawColor(255 * (1.f - Alpha),0,0,255 * (1.f - Alpha));
				BarLength = (HealthBarMaxWidth + BarGrowth) * (1.f - Alpha);
				DrawY = 12 - BarGrowth;
			}
			Canvas.SetPos(DrawX,DrawY);
			Canvas.DrawRect(BarWidth,BarLength);
		}
	}

	// health overlay
	if( NP.HealthOverlayMIC != None )
	{
		NP.HealthOverlayMIC.SetScalarParameterValue('DamageAmount', 1.f - HealthPct);
	}
	
	if( NP.HealthPPEffect != None )
	{
		NP.HealthPPEffect.bShowInGame = (HealthPct < 1.f) ? TRUE : FALSE;
	}
}

/** Draw ammo for currently held gun */
final function DrawAmmoInfo(NanoPawn NP)
{
	local NanoPRI NPRI;
	local class<NanoWeapon> GunClass;
	local int InGunCount, SpareCount;

	// Find out our currently chosen gun
	NPRI = NanoPRI(NP.PlayerReplicationInfo);
	GunClass = NPRI.GunPlan.default.WeaponClass;

	// Get ammo for that gun
	NP.GetAmmoForWeapon(GunClass, InGunCount, SpareCount);

	// Draw info on screen
	Canvas.SetPos(Canvas.SizeX - 90, 90);
	Canvas.SetDrawColor(255,255,255);
	Canvas.Font = class'Engine'.static.GetSmallFont();
	Canvas.DrawText(InGunCount$"/"$SpareCount);
}



/** Draw ammo for currently held gun */
final function DrawCrowdInfo(NanoPawn NP)
{
	// Draw info on screen
	Canvas.SetDrawColor(255,255,255);
	Canvas.Font = class'Engine'.static.GetSmallFont();

	Canvas.SetPos(Canvas.SizeX - 120, 120);
	Canvas.DrawText( "HiddenInCrowd:" @ NP.bIsHiddenByCrowd );

	Canvas.SetPos(Canvas.SizeX - 120, 150);
	Canvas.DrawText( "NonPanic:" @ NP.NumNonPanickedCrowdAround $ "/" $ NP.NumNonPanickedCrowdToHideUs );

	Canvas.SetPos(Canvas.SizeX - 120, 180);
	Canvas.DrawText( "Panic:" @ NP.NumPanickedCrowdAround $ "/" $ NP.NumPanickedCrowdToHideUs );
}




/** Draw DrawMeleeComboInfo */
final function DrawMeleeComboInfo(NanoPawn NP)
{
	local NanoWeap_Melee Melee;
	local float DeltaY;
	local name CurrAttackName;

	local int NextAttackIdx;
	local name NextAttackName;

	// see if we have a melee weapon
	Melee = NanoWeap_Melee(NP.Weapon);

	if( Melee == None )
	{
		return;
	}



	// Draw info on screen
	DeltaY = 120;
	Canvas.SetPos( Canvas.SizeX - 400, DeltaY );
	Canvas.SetDrawColor(255,255,255);
	Canvas.Font = class'Engine'.static.GetSmallFont();



	Canvas.DrawText( "AttackAnimState" @ Melee.WeaponSheet.AttackAnimState );


	if( Melee.AttackIdx != -1 )
	{
		CurrAttackName = Melee.WeaponSheet.MeleeAttacks[Melee.AttackIdx].AttackName;
	}
	else
	{
		CurrAttackName = 'None';
	}

	DeltaY += 20;
	Canvas.DrawText( "CurrAttack" @ CurrAttackName );


	NextAttackIdx = -1;
	if( Melee.AttackIdx != -1 )
	{
		NextAttackIdx = Melee.ResolveComboAttackIndex( Melee.AttackIdx );
	}

	if( NextAttackIdx != -1 )
	{
		NextAttackName = Melee.WeaponSheet.MeleeAttacks[NextAttackIdx].AttackName;
	}
	else
	{
		NextAttackName = 'None';
	}

	DeltaY += 20;
	Canvas.DrawText( "NextAttack" @ NextAttackName );

	DeltaY += 20;
	Canvas.DrawText( "ButtonPressed" @ Melee.ComboInput.ButtonPressed );

	DeltaY += 20;
	Canvas.DrawText( "BufferedButton" @ Melee.BufferedComboInput.ButtonPressed );

	DeltaY += 20;
	Canvas.DrawText( "AllowTransToNextCombo" @ Melee.bAttackRecover_AllowTransitionToNextCombo );

	DeltaY += 20;
	Canvas.DrawText( "AllowTransBaseAttack" @ Melee.bAttackRecover_AllowTransitionToBaseAttack );

	DeltaY += 20;
	Canvas.DrawText( "bPreventMoveInMeleeAttack" @ NP.bPreventMoveInMeleeAttack );
}



final function DrawChaosCoolDownBar(NanoPawn NP)
{
	local float DrawX, DrawY;
	local float RatioOfChaosDecay;
	local float RatioOfFull;

	local ChaosPacifismManager CM;


	DrawX = MapDrawInfo.Minimap_UL.X*Canvas.SizeX + 2;
	DrawY = MapDrawInfo.Minimap_UL.Y*Canvas.SizeX - 8; // SizeX is what the minimap uses 

	SetHUDDrawColor(eNANOHUDCOLOR_RED);


	CM = NanoGRI(WorldInfo.GRI).GetCurrentChaosManager();

	if( CM != none )
	{
		if( CM.GetChaosTier() > 0 )
		{
			RatioOfChaosDecay = 1.0f - Min( `TimeSince(CM.TimeOfInsideAIThreatQueryView), NanoGRI(WorldInfo.GRI).NPES.DurationOutsideOfHotZoneToResetChaos ) / NanoGRI(WorldInfo.GRI).NPES.DurationOutsideOfHotZoneToResetChaos;

			RatioOfFull = RatioOfChaosDecay * 200;

			Canvas.SetPos( DrawX, DrawY );
			Canvas.DrawRect( RatioOfFull, 4 );

			//`log( `showvar(RatioOfChaosDecay) @ `showvar(RatioOfFull) @ `TimeSince(CM.TimeOfInsideAIThreatQueryView) @ `showvar(NanoGRI(WorldInfo.GRI).NPES.DurationOutsideOfHotZoneToResetChaos) );
		}
	}

}

function DrawFeedInfo()
{
	local int IconOpacity;
	local string InfoString;
	local float XL, YL;

	if(FeedPage.NumUnreadPosts > 0)
	{
		IconOpacity = 255.0 * Abs( Sin(WorldInfo.RealTimeSeconds * PI * NewPostPulseSpeed) );

		Canvas.SetDrawColor(255,255,255,IconOpacity);
		Canvas.SetPos(NewPostOrigin.X, NewPostOrigin.Y);
		DrawTileCoords(NewPostIcon.IconTex, NewPostIconSize.X, NewPostIconSize.Y, NewPostIcon.Coords);

		Canvas.SetDrawColor(255,255,255,255);
		Canvas.Font = class'Engine'.static.GetSmallFont();
		InfoString = "You have"@FeedPage.NumUnreadPosts@"unread post(s)!";
		Canvas.TextSize(InfoString, XL, YL);
		Canvas.SetPos( NewPostOrigin.X + NewPostIconSize.X + 5, NewPostOrigin.Y + (0.5*NewPostIconSize.Y) - (0.5*YL) );
		Canvas.DrawText(InfoString);
	}
}


/** Util for changing draw color to active/inactive dash state */
simulated function SetDashPipDrawColor(bool bActive)
{
	if(bActive)
	{
		Canvas.SetDrawColor(50,50,255,255);
	}
	else
	{
		Canvas.SetDrawColor(10,10,128,255);
	}
}

/** Draw meter showing current dash pip */
simulated function DrawDashMeter(NanoPawn NP)
{
	local NanoSkill_Dash DashSkill;
	local float Scale, PipSize, Offset, ScaleTime;
	local int Idx;
	ScaleTime = 0.5f;
	DashSkill = NP.GetSkill(class'NanoSkill_Dash');
	if(DashSkill != None)
	{
		for (Idx = 0; Idx < DashSkill.DashLevels[DashSkill.SkillLevel].MaxDashPips; Idx++)
		{
			SetDashPipDrawColor(DashSkill.bActive && DashSkill.CurrentDashPip >= Idx);
			PipSize = 10;
			Offset = 0;
			if (DashSkill.bActive && DashSkill.CurrentDashPip == Idx)
			{
				Scale = `TimeSince(DashSkill.LastPipChangeTime);
				if (Scale < ScaleTime)
				{
					if (Scale < ScaleTime * 0.5f)
					{
						PipSize = 10 + (10 * Scale/(ScaleTime * 0.5f));
					}
					else
					{
						PipSize = 20 - (10 * (Scale-(ScaleTime * 0.5f))/(ScaleTime * 0.5f));
					}
					Offset = (PipSize - 10)/2.f;
				}
			}
			Canvas.SetPos(20 + (Idx * 12) - Offset, Canvas.SizeY - 23 - Offset);
			Canvas.DrawRect(PipSize, PipSize);
		}
	}
}

function DrawCrossHair( NanoPawn NP )
{
	local float	CrosshairSize;
	local float DrawX, DrawY, Scale;
	local Texture2D WeaponTexture;
	local CanvasIcon CrosshairIcon;
	local NanoPRI NPRI;
	local float AdditionalOffsetY;
	local int i;
	//local float TotalTimeToMaxInaccuracy;
	local float ScaleMod;

	// Do not draw the crosshair if we're not viewing from the pawn
	if( NanoPC(NP.Controller).GetViewTarget() != NP )
	{
		return;
	}

    // Draw Temporary Crosshair
    SetHUDDrawColor(eNANOHUDCOLOR_WHITE_DK);
    Canvas.DrawColor.A = FMax(0.2f,1.f - VSize(NP.Velocity)/(NP.GroundSpeed*2.f)) * 255;
	if (!NP.bIsTargeting)
	{
		Canvas.DrawColor.A *= 0.1;
	}

	NPRI = NanoPRI(NP.PlayerReplicationInfo);

	if( ( NP.IsDoingSpecialMove( 'NSM_ForgeCycle' ) == TRUE ) || ( NP.IsDoingSpecialMove( 'NSM_ForgeCycleFast' ) == TRUE ) )
	{
		WeaponTexture = NPRI.UtilityPlan.default.AimingCrossHair;
		
		Canvas.DrawColor.A = 255;
		AdditionalOffsetY =	150;	
	}
	else if( NP.MyNanoWeapon != none )
	{
	    WeaponTexture = NP.MyNanoWeapon.CrosshairIcon;
	}
	
	//`log( `showvar(WeaponTexture) );

	if( WeaponTexture != None )
	{
		CrosshairIcon = Canvas.MakeIcon( WeaponTexture );
		Scale = NP.bIsTargeting ? 0.5f : 1.f;

		// calc total time to get to max inaccuracy

		 for( i = 0; i < NP.MyNanoWeapon.AimSpreadBuckets.Length; i++ )
		 {
			// TotalTimeToMaxInaccuracy = NP.MyNanoWeapon.AimSpreadBuckets[i].TimeTilNextBucket;
		 }

		ScaleMod = 0.0f; // 2.0f * FClamp( `TimeSince(NP.LastWeaponEndFireTime) / TotalTimeToMaxInaccuracy, 0.0f, 1.0f );

		Scale += ScaleMod;

		//`log( `showvar(NP.MyNanoWeapon.LastAimSpreadPct) @ `showvar(Scale) @ `showvar(AimBucket) @ `showvar(ScaleMod) @ `showvar(NP.MyNanoWeapon.AimSpreadBuckets[AimBucket].TimeTilNextBucket) );

		// place in the center of the screen
		DrawX = 0.5*Canvas.ClipX - (CrosshairIcon.UL * 0.5f * Scale);
		DrawY = 0.5*Canvas.ClipY - (CrosshairIcon.VL * 0.5f * Scale) - AdditionalOffsetY;

		Canvas.DrawIcon(CrosshairIcon,DrawX,DrawY,Scale);
	}
	else
	{
		CrosshairSize = 4;
		Canvas.SetPos(CenterX - CrosshairSize, CenterY);
		Canvas.DrawRect(2*CrosshairSize + 1, 1);

		Canvas.SetPos(CenterX, CenterY - CrosshairSize);
		Canvas.DrawRect(1, 2*CrosshairSize + 1);
	}
}




function DrawDamageIndicator(NanoPawn NP)
{
	local int IndicatorSizeX, IndicatorSizeY, HitIdx;
	local RecentHitInfo Hit;
	local rotator IndicatorRot;
	local vector HitLoc, HitDir, CamLoc, CamX, CamY, CamZ;
	local rotator CamRot;
	local float IndicatorPosX, IndicatorPosY, IndicatorRadius, Angle, TimeSinceHit, Alpha;
	local LinearColor LinColor;

	IndicatorSizeX = 256;
	IndicatorSizeY = 512;
	IndicatorRadius = FMin(Canvas.ClipX,Canvas.ClipY) * 0.4f;
	PlayerOwner.GetPlayerViewpoint(CamLoc,CamRot);
	GetAxes(CamRot,CamX,CamY,CamZ);
	for (HitIdx = 0; HitIdx < NP.RecentHits.Length; HitIdx++)
	{
		TimeSinceHit = `TimeSince(NP.RecentHits[HitIdx].TimeOfHit);
		if (TimeSinceHit < 1.f)
		{
			if (NP.RecentHits[HitIdx].MatInst == None)
			{
				NP.RecentHits[HitIdx].MatInst = new(NP) class'MaterialInstanceConstant';
				NP.RecentHits[HitIdx].MatInst.SetParent(DmgIndicator);
			}
			Hit = NP.RecentHits[HitIdx];
			// grab the most recent hit location
			HitLoc = Hit.HitInstigator != None ? Hit.HitInstigator.Location : Hit.OriginOfHit;
			// calc the direction, ignoring z since we're translating to 2d
			HitDir = HitLoc - CamLoc;
			HitDir.Z = 0;
			HitDir = Normal(HitDir);
			// calc the angle so that we can re-project on the canvas
			Angle = ACos(HitDir dot CamX);
			if ((HitDir dot CamY) < 0)
			{
				Angle = -Angle;
			}
			// need to adjust the angle to account for the texture being oriented to the side
			Angle -= Pi/2.f;
			// project the coords
			IndicatorPosX = IndicatorRadius * Cos(Angle);
			IndicatorPosY = IndicatorRadius * Sin(Angle);
			// set the tile pos
			Canvas.SetPos(IndicatorPosX + Canvas.ClipX * 0.5 - IndicatorSizeX * 0.5,IndicatorPosY + Canvas.ClipY * 0.5 - IndicatorSizeY * 0.5);
			// calc the color based on time of hit
			Alpha = (1.f - TimeSinceHit);
			LinColor.R = 2.0;
			LinColor.A = Alpha;
			Hit.MatInst.SetVectorParameterValue('ArrowColor',LinColor);
			// calc the rotation of the tile
			IndicatorRot = rot(0,0,0);
			IndicatorRot.Yaw = RadToUnrRot * Angle;
			// and draw!
			Canvas.DrawRotatedMaterialTile(Hit.MatInst,IndicatorRot,IndicatorSizeX,IndicatorSizeY,0,0,1,1);
		}
		else
		{
			NP.RecentHits.Remove(HitIdx--,1);
		}
	}
}

/**
 * Does the actual work of drawing an ActionInfo.
 */
final function DrawActionInfo(float DeltaTime, const out ActionInfo ActionToDraw)
{
	local int Alpha, Idx;
	local float DrawX, DrawY, TextW, TextH, StartY, SubTitleH, SubTitleW;
	local int IconIndex;
	local ActionInfo Action;

	Action = ActionToDraw;

	GetSubtitleSize( SubTitleW, SubTitleH );
	StartY = SubTitleH;

	Alpha = Action.BlendPct * 255.f;

	if (Alpha > 0)
	{
		// If there's a tooltip to draw, do it (this assumes that icons and tooltips won't mix)
		if (Len(Action.TooltipText) > 0)
		{
			//todo - re-enable this when we have support for additional fonts
			//Canvas.Font = class'Engine'.static.GetAdditionalFont(Action.FontIndex);
			Canvas.Font = class'Engine'.static.GetTinyFont();
			Canvas.StrLen( Action.TooltipText, TextW, TextH );
			DrawX = Canvas.ClipX / 2.f - TextW/2.f;
			DrawY = 3.f * Canvas.ClipY / 4.f - StartY - TextH;

			// draw a background
			//todo - get something fancier
			Canvas.SetDrawColor(64, 64, 64, 0.5f*Alpha);
			Canvas.SetPos(DrawX-20, DrawY-20);
			Canvas.DrawRect(TextW+40, TextH+40);

			// draw the black shadow text
			Canvas.SetPos( DrawX+3, DrawY );
			SetHUDDrawColor( eNANOHUDCOLOR_BLACK, Alpha );
			Canvas.DrawText( Action.TooltipText );
			// draw the text white
			Canvas.SetPos( DrawX, DrawY-3 );
			SetHUDDrawColor( eNANOHUDCOLOR_WHITE, Alpha );
			Canvas.DrawText( Action.TooltipText );
		}
		// else try to draw any icons
		else
		{
			SetHUDDrawColor( eNANOHUDCOLOR_WHITE, Alpha );

			if ( (Action.IconAnimationSpeed > 0.f) && (ActionIconAnimInfo.LastActionAnimationSwitch + Action.IconAnimationSpeed < WorldInfo.TimeSeconds) )
			{
				ActionIconAnimInfo.LastActionAnimationSwitch = WorldInfo.TimeSeconds;
				ActionIconAnimInfo.CurrentIconIndex = (ActionIconAnimInfo.CurrentIconIndex + 1) % Action.ActionIconDatas[0].ActionIcons.length;
			}

			if ( (NanoPRI(PlayerOwner.PlayerReplicationInfo) == None) || NanoPRI(PlayerOwner.PlayerReplicationInfo).bShowPictograms )
			{
				DrawX = Canvas.ClipX - Action.SizeX/2.f;
				// draw each icon
				for (Idx = 0; Idx < Action.ActionIconDatas.Length; Idx++)
				{
					IconIndex = ActionIconAnimInfo.CurrentIconIndex;
					if ( IconIndex >= Action.ActionIconDatas[Idx].ActionIcons.length )
					{
						IconIndex = 0;
					}

					DrawY = Canvas.ClipY - StartY - Action.SizeY;
					DrawY += Action.SizeY/2.f - Action.ActionIconDatas[Idx].ActionIcons[IconIndex].VL/2.f;

					// check to see if we need to mirror the last icon (ex. cover leans)
					if (Action.bMirror && Idx == Action.ActionIconDatas.Length - 1)
					{
						Canvas.SetPos( DrawX, DrawY );
						Canvas.DrawTile(Action.ActionIconDatas[Idx].ActionIcons[IconIndex].Texture,
							Action.ActionIconDatas[Idx].ActionIcons[IconIndex].UL,
							Action.ActionIconDatas[Idx].ActionIcons[IconIndex].VL,
							Action.ActionIconDatas[Idx].ActionIcons[IconIndex].U+Action.ActionIconDatas[Idx].ActionIcons[0].UL,
							Action.ActionIconDatas[Idx].ActionIcons[IconIndex].V,
							-Action.ActionIconDatas[Idx].ActionIcons[IconIndex].UL,
							Action.ActionIconDatas[Idx].ActionIcons[IconIndex].VL);
					}
					else
					{
						Canvas.DrawIcon(Action.ActionIconDatas[Idx].ActionIcons[IconIndex],DrawX,DrawY);
					}
					DrawX += Action.ActionIconDatas[Idx].ActionIcons[IconIndex].UL + Action.IconSpacing;
				}
			}
		}
	}
}

/**
 * Draw the current action.
 */
function DrawActions(float DeltaTime)
{
	// FIXME: Not sure if this is the best avenue to go.
	if ( !PlayerOwner.IsSpectating() )
	{
		// if we have an active action
		if (ActiveAction.bActive)
		{
			// check for any auto deactivates
			if (FALSE && ActiveAction.AutoDeActivateTimer > 0.f && WorldInfo.TimeSeconds - ActiveAction.ActivateTime > ActiveAction.AutoDeActivateTimer)
			{
				// disable this action
				ActiveAction.bActive = FALSE;
				PreviousAction = ActiveAction;
			}
			// otherwise let's draw the sucker
			else
			{
				// figure out the blend pct
				ActiveAction.BlendPct = FClamp(ActiveAction.BlendPct + (1.f/ActionFadeTime * DeltaTime),0.f,1.f);
				// and draw
				DrawActionInfo(DeltaTime,ActiveAction);
			}
		}
		// check the previous action to see if it's still blending out
		if (PreviousAction.BlendPct > 0.f)
		{
			PreviousAction.BlendPct = FClamp(PreviousAction.BlendPct - (1.f/ActionFadeTime * DeltaTime),0.f,1.f);
			DrawActionInfo(DeltaTime,PreviousAction);
		}
	}
}

/**
 * Sets the active action for displaying on the HUD.
 */
final event bool SetActionInfo(EActionType NewActionType, ActionInfo NewAction, optional bool bMirrorImage)
{
	local int Idx;

	// if there currently is an active action
	if (ActiveAction.bActive)
	{
		// if the new priority is higher than the previously higher one (0 is highest) or it is a different action
		if ( NewActionType < ActiveAction.ActionType ||
			 NewAction.ActionName != ActiveAction.ActionName ||
			 NewAction.ToolTipText != ActiveAction.ToolTipText ||
			 bMirrorImage != ActiveAction.bMirror ||
			 ( ((NewAction.ActionIconDatas.length > 0) && (ActiveAction.ActionIconDatas.length > 0)) &&
			   (NewAction.ActionIconDatas[0].ActionIcons[0] != ActiveAction.ActionIconDatas[0].ActionIcons[0]) )
		   )
		{
			// then de-activate this one
			PreviousAction = ActiveAction;
			PreviousAction.bActive = FALSE;
		}
		else
		{
			// otherwise ignore
			return FALSE;
		}
	}
	// set the new active action
	ActiveAction = NewAction;
	ActiveAction.ActionType = NewActionType;
	ActiveAction.bActive = TRUE;
	ActiveAction.BlendPct = 0.f;
	ActiveAction.ActivateTime = WorldInfo.TimeSeconds;
	ActiveAction.bMirror = bMirrorImage;
	// cache some draw info for the icons
	for (Idx = 0; Idx < ActiveAction.ActionIconDatas.Length; Idx++)
	{
		// total the icon sizes
		ActiveAction.SizeX += ActiveAction.ActionIconDatas[Idx].ActionIcons[0].UL;
		// if not the last element
		if (Idx < ActiveAction.ActionIconDatas.Length - 1)
		{
			// add any spacing
			ActiveAction.SizeX += ActiveAction.IconSpacing;
		}
		// pick the max height
		ActiveAction.SizeY = FMax(ActiveAction.SizeY,ActiveAction.ActionIconDatas[Idx].ActionIcons[0].VL);
	}
	ActiveAction.bCached = TRUE;

	ActionIconAnimInfo.CurrentIconIndex = 0;
	ActionIconAnimInfo.LastActionAnimationSwitch = WorldInfo.TimeSeconds;

	return TRUE;
}

/**
 * Clears the active action if it matches the specified type.
 */
final function bool ClearActionInfoByType(EActionType ActionType)
{
	if (ActiveAction.bActive && ActionType == ActiveAction.ActionType)
	{
		// disable the active action
		ActiveAction.bActive = FALSE;
		ActiveAction.ActionType = AT_None;
		// move to previous so it can be blended
		PreviousAction = ActiveAction;
		return TRUE;
	}
	return FALSE;
}

/** Clear the active action regardless of its type */
final function ClearActiveActionInfo()
{
	ActiveAction.bActive = FALSE;
	ActiveAction.ActionType = AT_None;
}

function SetHUDDrawColor( ENanoHUDColor eColor, byte Alpha = 255 )
{
	switch ( eColor )
	{
	case eNANOHUDCOLOR_WHITE:
		Canvas.SetDrawColor( 240, 240, 240, Alpha );
		break;

	case eNANOHUDCOLOR_RED:
		Canvas.SetDrawColor( 200, 0, 0, Alpha );
		break;

	case eNANOHUDCOLOR_BLACK:
		Canvas.SetDrawColor( 0, 0, 0, Alpha );
		break;

	case eNANOHUDCOLOR_WHITE_DK:
		Canvas.SetDrawColor( 200, 200, 200, Alpha );
		break;

	case eNANOHUDCOLOR_TEAMRED:
		Canvas.SetDrawColor( 205, 22, 22, Alpha );
		break;

	case eNANOHUDCOLOR_TEAMBLUE:
		Canvas.SetDrawColor( 139, 255, 255, Alpha );
		break;

	case eNANOHUDCOLOR_CHATICONRED:
		Canvas.SetDrawColor( 164, 63, 63, Alpha );
		break;

	case eNANOHUDCOLOR_CHATICONBLUE:
		Canvas.SetDrawColor( 170, 192, 205, Alpha );
		break;

	case eNANOHUDCOLOR_GRAY:
		Canvas.SetDrawColor( 128, 128, 128, Alpha );
		break;

	case eNANOHUDCOLOR_GREEN:
		Canvas.SetDrawColor( 0, 200, 0, Alpha );
		break;

	case eNANOHUDCOLOR_BLUE:
		Canvas.SetDrawColor( 0, 0, 200, Alpha );
		break;
		
	case eNANOHUDCOLOR_YELLOW:
		Canvas.SetDrawColor( 255, 255, 0, Alpha );
		break;
	}
}

/** As DrawTile, but taking a TextureCoordinates struct */
final function DrawTileCoords( Texture Tex, float XL, float YL, TextureCoordinates Coords )
{
	Canvas.DrawTile(Tex, XL, YL, Coords.U, Coords.V, Coords.UL, Coords.VL);
}

/** Takes an int and returns a string in the form HH:MM:SS */
final function string FormatTime( float TimeToFormat )
{
	local int Minutes, Hours, Seconds;
	local string Result;

	// Figure out how many seconds we are dealing with first, we'll format it later
	Seconds = TimeToFormat;

	// Calculate hours and start building the string if there are hours
	if( Seconds > 3600 )
	{
		Hours = Seconds / 3600;
		Seconds -= Hours * 3600;
		Result = string(Hours)$":";
	}

	// Calculate minutes
	Minutes = Seconds / 60;

	// Calculate seconds
	Seconds -= Minutes * 60;

	// Build the string for minutes
	if ( Minutes < 10 )
	{
		if ( Hours == 0 )
			Result = Result$"0";
		else
			Result = Result$"0";
	}
	Result = Result$Minutes$":";

	// Build the string for seconds
	if ( Seconds < 10 )
	{
		Result = Result$"0";
	}
	Result = Result$Seconds;

	// append first two decimal places
	Result = Result $ ":" $ int(100 * (TimeToFormat - int(TimeToFormat)));

	return Result;
}

simulated function SetCurrentUIPageIndex(int NewIndex)
{
	local NanoUIPage_Base CurrentUIPage;

	// Call PageHidden if a current page is shown
	CurrentUIPage = GetCurrentUIPage();
	if(CurrentUIPage != None)
	{
		CurrentUIPage.PageHidden();
	}

	// Change current index
	CurrentUIPageIndex = NewIndex;

	// Call PageShown 
	CurrentUIPage = GetCurrentUIPage();
	if(CurrentUIPage != None)
	{
		CurrentUIPage.PageShown();
	}
}

/** Bring */
simulated function ActivateMissionsMenu()
{
	SetCurrentUIPageIndex(0);
}

/** Cycle between pages of in-game menu */
simulated function CycleInGameMenuPage(bool bForward)
{
	local int NewPageIndex;

	if(bForward)
	{
		if(CurrentUIPageIndex == UIPages.Length-1)
		{
			NewPageIndex = 0;
		}
		else
		{
			NewPageIndex = CurrentUIPageIndex + 1;
		}
	}
	else
	{
		if(CurrentUIPageIndex == 0)
		{
			NewPageIndex = UIPages.Length - 1;
		}
		else
		{
			NewPageIndex = CurrentUIPageIndex - 1;
		}
	}

	SetCurrentUIPageIndex(NewPageIndex);
}

function TutorialHandleButton(Name ButtonName)
{
	local bool bClearTutorial, bFireOutput0, bFireOutput1;

	if( (WorldInfo.RealTimeSeconds-TimeOfTutorial) > Tutorials[0].MinTimeForTutorialMessageToStayUp )
	{
		if(ButtonName == 'A')
		{
			bClearTutorial = TRUE;
			bFireOutput0 = TRUE;
			bFireOutput1 = (Tutorials[0].MessageType == ETMT_Ok); // if an OK message, fire both outputs
		}
		else if(ButtonName == 'B')
		{
			bClearTutorial = TRUE;
			bFireOutput1 = TRUE;
			bFireOutput0 = (Tutorials[0].MessageType == ETMT_Ok);
		}

		if(bClearTutorial)
		{
			// handle latent tutorial action if there is one present
			if(Tutorials[0].TutorialAction != None)
			{
				// Fire whichever output(s) required
				if(bFireOutput0)
				{
					Tutorials[0].TutorialAction.ActivateOutputLink(0);
				}

				if(bFireOutput1)
				{
					Tutorials[0].TutorialAction.ActivateOutputLink(1);
				}

				// Stop kismet event from being acive 
				Tutorials[0].TutorialAction.bTutorialActive = FALSE;
			}

			// clean up tutorial vars
			bTutorialIsUp = FALSE;
			Tutorials.Remove(0, 1 );

			// unpause
			PlayerOwner.SetPause( FALSE );
		}
	}
}

/** Allows HUD to eat input, e.g. if in-game menu is up */
function bool HUDFilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{
	local NanoUIPage_Base CurrentUIPage;

	CurrentUIPage = GetCurrentUIPage();

	if( bTutorialIsUp == TRUE )
	{
		if(bPressed)
		{
			TutorialHandleButton(ButtonName);
		}

		return TRUE; // always eat input when tutorial is up
	}
	else if(CurrentUIPage != None)
	{
		if(bPressed)
		{
			switch( ButtonName )
			{
			case 'Start':
			case 'B':
				SetCurrentUIPageIndex(-1);
				return TRUE;
				break;

			case 'L1':
			case 'R1':
				CycleInGameMenuPage(ButtonName == 'R1');
				return TRUE;
				break;
			}

			CurrentUIPage.HandlePageInput(ButtonName);
			return TRUE;
		}
	}

	return FALSE;
}

function DrawInGameMenu(NanoPawn NP)
{
	local NanoUIPage_Base CurrentUIPage;

	CurrentUIPage = GetCurrentUIPage();
	if(CurrentUIPage != None)
	{
		CurrentUIPage.DrawPage();
	}
}


/** Util to show the color for an icon, white translucent for not summoned or active, white for summoned, blue for active. */
simulated function Color GetIconColorForWeapon(NanoPawn NP, class<Inventory> WeaponClass)
{
	// First see if if this is the weapon we are actually using
	if( ( NP.Weapon != none ) && (NP.Weapon.IsA(WeaponClass.Name)) )
	{
		return WeaponActiveColor;
	}
	// Next see if we have it in our inventory
	else if( Weapon(NP.InvManager.FindInventoryType(WeaponClass, FALSE)) != None )
	{
		return WeaponHolsteredColor;
	}
	// Ok, its not ready either
	else
	{
		return WeaponMissingColor;
	}
}

final function DrawIRIS(NanoPawn NP)
{
	local bool bIRISActive;
	local Texture CurrTextureMovie;

	if( IRISMovieMat != None )
	{
		if( IRISMovieInst == None )
		{
			IRISMovieInst = new(self) class'MaterialInstanceConstant';
			IRISMovieInst.SetParent(IRISMovieMat);
		}

		IRISMovieInst.GetTextureParameterValue( 'Movie', CurrTextureMovie );
		if( CurrTextureMovie == None )
		{
			return;
		}

		bIRISActive = NanoPC(NP.Controller).bIRISActive;

		// Blend the IRIS opacity (if already at goal, no work will be done)
		IRISOpacity = FInterpTo(IRISOpacity, (bIRISActive ? 1.f : 0.f), RenderDelta, IRISOpacityBlendRate);

		if( IRISTextureMovie != None )
		{
			if( bIRISActive )
			{
				// Check to see if we need to start playing the movie
				if( IRISTextureMovie.Stopped || IRISTextureMovie.Paused )
				{
					IRISMovieInst.SetTextureParameterValue('Movie', IRISTextureMovie);

					// Play the movie if this is the first time we're rendering it
					IRISTextureMovie.Stop();
					IRISTextureMovie.Play();

					//DEMO: Delay the fading to hide the frame garbage at the beginning of bink playback
					IRISOpacity = -0.5f;
				}
			}
			else
			{
				// Check to see if we need to stop the movie
				if( (IRISOpacity == 0.f) && !IRISTextureMovie.Stopped && !IRISTextureMovie.Paused )
				{
					IRISTextureMovie.Stop();
				}
			}
		}

		if( IRISOpacity >= 0.f )
		{
			IRISMovieInst.SetScalarParameterValue('UI_Opac', IRISOpacity);

			Canvas.SetPos(0.f, 0.f);
			Canvas.DrawMaterialTile(IRISMovieInst, Canvas.ClipX, Canvas.ClipY, 0.f, 0.f, 1.f, 1.f);
		}
	}
}

/** This will look at the current missions the player is on and then draw them above the minimap **/
final function DrawOnHUDMissionText( NanoPawn NP )
{
	local float DrawX, DrawY;
	local int Height, Width;
	local NanoGRI NGRI;
	local MissionInfo AMisisonInfo;
	local SeqAct_NanoMission TheMission;
	local string TempString;

	NGRI = NP.GetGRI();

	// here we are going to grab the location of the mini map and put the chaos meter above it
	DrawX = MapDrawInfo.Minimap_UL.X*Canvas.SizeX;
	DrawY = MapDrawInfo.Minimap_UL.Y*Canvas.SizeX - 50.0f; // - (MapDrawInfo.MinimapSize.Y*Canvas.SizeX / 2); // SizeX is what the minimap uses 

	// so depending on how many missions we have, we will just keep "Scrolling" up
	foreach NGRI.TheMissionManager.Missions( AMisisonInfo )
	{
		DrawY -= 25.0f;
	}


	
	Canvas.Font = class'Engine'.static.GetSmallFont();
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos( DrawX, DrawY );
	

	foreach NGRI.TheMissionManager.Missions( AMisisonInfo )
	{	
		TheMission = AMisisonInfo.MissionAction;
		TempString = "TempString";
		Canvas.Font.GetStringHeightAndWidth( TempString, Height, Width );

		Canvas.DrawText( "*" $ TheMission.MissionName, TRUE,,, TextRenderInfo);

		// draw the mission summary
		if( TheMission.MissionSummary != "" )
		{
			DrawY += Height;
			// indent
			Canvas.SetPos( DrawX+15, DrawY );
			Canvas.DrawText( TheMission.MissionSummary, TRUE,,, TextRenderInfo);
		}

		// draw time if there is a time limit
		if( TheMission.DurationAllowed > 0 )
		{
			DrawY += Height;

			// indent
			Canvas.SetPos( DrawX+15, DrawY );
			Canvas.DrawText( TheMission.TimerLabel$": " $ TheMission.TimerCount, TRUE,,, TextRenderInfo);
		}


		DrawY += Height;
		Canvas.SetPos( DrawX, DrawY ); // reset X but increment Y
	}

}


/** Draw meter showing chaos level */
final function DrawChaosMeter(NanoPawn NP)
{
	local int ChaosLevel, i;
	local NanoGRI NGRI;
	//local float BarSize;
	local float DrawY, Alpha;
	local ChaosChangeHistoryInfo Info;
	local ChaosPacifismManager CPM;
	local int XPos, YPos;

	NGRI = NP.GetGRI();

	// if the player is not in a zone they will not have a ChaosManager
	if( NGRI.GetCurrentChaosManager() != none )
	{
		ChaosLevel = NGRI.GetCurrentChaosManager().GetChaosTier();
		//BarSize = float(ChaosLevel+1)/5.0;

		Canvas.SetDrawColor(255, 255, 255, 255);

		// here we are going to grab the location of the mini map and put the chaos meter above it
		ChaosUIOrigin.X = MapDrawInfo.Minimap_UL.X*Canvas.SizeX;
		ChaosUIOrigin.Y = MapDrawInfo.Minimap_UL.Y*Canvas.SizeX - 30; // SizeX is what the minimap uses 

		if( ( ChaosLevel < PrevChaosTier ) && ( ChaosLevel == 0 ) )
		{
			ChaosGreenSquareTransparency = 255;
		}

		PrevChaosTier = ChaosLevel;

		// draw green boxes
		if( ChaosLevel == 0 )
		{
			ChaosGreenSquareTransparency = FInterpConstantTo( ChaosGreenSquareTransparency, 0.0f, RenderDelta, 125 );

			//`log( `showvar(ChaosGreenSquareTransparency) );
			XPos = ChaosUIOrigin.X;
			YPos = ChaosUIOrigin.Y;

			for( i = 0; i < 5; i++ )
			{
				Canvas.SetPos( XPos, YPos );		

				Canvas.DrawTile( Texture2D'UI_HUD.Minimap.ChaosMeterNone', 16,16, 0,0, 256,256, MakeLinearColor(0,255,0,ChaosGreenSquareTransparency) );

				XPos += 18;
			}
		}
		// draw red boxes
		else
		{
			// outlines
			XPos = ChaosUIOrigin.X;
			YPos = ChaosUIOrigin.Y;

			for( i = 0; i < 5; i++ )
			{
				Canvas.SetPos( XPos, YPos );			
				Canvas.DrawTile( Texture2D'UI_HUD.Minimap.ChaosMeterEmpty', 16,16, 0,0, 256,256);

				XPos += 18;
			}


			// filled in red
			XPos = ChaosUIOrigin.X;
			YPos = ChaosUIOrigin.Y;

			for( i = 0; i < ChaosLevel; i++ )
			{
				Canvas.SetPos( XPos, YPos );			
				Canvas.DrawTile( Texture2D'UI_HUD.Minimap.ChaosMeterFilled', 16,16, 0,0, 256,256);

				XPos += 18;
			}

		}


// 			Texture2D'UI_HUD.Minimap.ChaosMeterEmpty'
// 			Texture2D'UI_HUD.Minimap.ChaosMeterFilled'

// 			Phil's stuff----
// 			New materials:
// 		    Texture2D'UI_HUD.Minimap.ChaosMeterNone'
// 			Texture2D'UI_HUD.Minimap.ChaosMeterEmpty'
// 			Texture2D'UI_HUD.Minimap.ChaosMeterFilled'

// 			None = Green [_] with 100% opacity that we pop into being when chaos reaches 0 and we are doing the white mini map background fade from 100% opacity to 0. Basically mimic that flash/fade with these green [_] shapes.
// 			Empty = Red [_] with 50% opacity to show available Chaos levels that have not been reached yet.
// 			Filled = Red [#] with 100% opacity to show a Chaos level is reached.
// 			Put a bit of horizontal spacing between these so they don't exactly butt up against one another.
// 			So with Chaos level 1, with our 3 available levels of actual Chaos, you'll get [#] [_] [_].
// 			Level 2 [#] [#] [_]
// 		    Level 3 [#] [#] [#]
//   		Reset (green boxes fading down and disappearing) [_] [_] [_]
	}


	// reset
	ChaosUIOrigin = default.ChaosUIOrigin;

	// Draw history - drawing most recent entry (end of array) first at the bottom, and then working up
	DrawY = 0.0;

	CPM = NGRI.CPM;

	if( CPM != none )
	{
		for(i = CPM.ChaosHistory.length-1; i >= 0; i--)
		{
			Info = CPM.ChaosHistory[i];
			Alpha = 1.0 - FClamp(`TimeSince(Info.ChaosChangeTime)/CPM.ChaosHistoryDecayTime, 0.0, 1.0);

			Canvas.SetDrawColor(255, 128, 128, FFloor(Alpha*255.0));
			Canvas.SetPos(ChaosUIOrigin.X, ChaosUIOrigin.Y + ChaosHistoryYOffset + DrawY);
			Canvas.DrawText(Info.ChaosZoneName$":"@Info.ChaosChange@Info.ChaosChangeCause);
			DrawY -= 20;
		}
	}
}

/** Draw meter showing combo level */
final function DrawComboMeter(NanoPawn NP)
{
	local float BarSize, UseComboPoints;
	local NanoPC PC;

	PC = NanoPC(PlayerOwner);
	UseComboPoints = PC.bInfiniteComboPoints ? 100.0 : NP.ComboPoints;
	BarSize = UseComboPoints/100.0;

	Canvas.SetDrawColor(255, 255, 255, 255);

    if (ComboUIOrigin.X < 0)
    {
	ComboUIOrigin.X = Canvas.ClipX + default.ComboUIOrigin.X;
    }

	// Draw border
	Canvas.SetPos(ComboUIOrigin.X, ComboUIOrigin.Y);
	Canvas.DrawTile(ComboUITexture, 93,40, 93,0, -93,40);

	// Draw background
	Canvas.SetPos(ComboUIOrigin.X+0, ComboUIOrigin.Y+5);
	Canvas.DrawTile(ComboUITexture, 78,16, 15,78, 78,16);

	// Draw foreground
	if(UseComboPoints < 99.9 || (WorldInfo.TimeSeconds % 0.5) > 0.25)
	{
		Canvas.SetPos(ComboUIOrigin.X+0, ComboUIOrigin.Y+5);
		Canvas.DrawTile(ComboUITexture, BarSize*78.0,16, 15,96, BarSize*78.0,16);
	}
}

/** Do checks for tooltips and draw one if relevant */
final function CheckDrawToolTip(NanoPawn NP)
{
	local array<NanoInterface_Interact> InteractObjects;
	local NanoInterface_Interact InteractInt;
	local float XL, YL;
	local vector2D Middle;
	local string TipString;
	local Texture2D ButtonTexture;

	InteractObjects = NP.GetBestInteractObject(ENIT_Default, TRUE);
	if( InteractObjects.Length > 0 )
	{
		InteractInt = InteractObjects[0];
	}

	if(InteractInt == none)
	{
		InteractObjects = NP.GetBestInteractObject(ENIT_AbsorbBegin, TRUE);
		if( InteractObjects.Length > 0 )
		{
			InteractInt = InteractObjects[0];
		}
	}

	// Found someone - display that object's GetInteractToolTip
	if(InteractInt != None)
	{
		// Get tool tip string
		TipString = InteractInt.GetInteractToolTip( NP, ButtonTexture);

		// if thee is no string and no button texture just no nothing
		if( ( TipString == "" ) && ( ButtonTexture == None ) )
		{
			return;
		}

		Middle.X = 0.5*Canvas.ClipX;
		Middle.Y = 0.75*Canvas.ClipY;

		// Background box
		//Canvas.SetPos(Middle.X - 150, Middle.Y - 20);
		//Canvas.SetDrawColor(0,0,64,128);
		//Canvas.DrawRect(300, 40);

		// Text
		Canvas.Font = class'Engine'.static.GetLargeFont();
		Canvas.TextSize(TipString, XL, YL);
		Canvas.SetPos(Middle.X - (0.5*XL), Middle.Y - (0.5*YL));
		if( ButtonTexture != None )
		{
			Canvas.DrawTexture( ButtonTexture, 2.0f );
			TipString = " " $ TipString; // add a space after the button icon
		}
		Canvas.SetDrawColor(255,255,255);
		Canvas.DrawText(TipString);
	}
}

final function DrawMessageBox(string Message1, string Message2)
{
	local float XL, YL;
	local vector2D Middle;

	Middle.X = (0.5*Canvas.ClipX) + MessageBoxOffset.X;
	Middle.Y = (0.5*Canvas.ClipY) + MessageBoxOffset.Y;

	// set the size of the box to be slightly larger than the text to display
	Canvas.TextSize(Len(Message1) > Len(Message2) ? Message1 : Message2, MessageBoxSize.X, YL);
	MessageBoxSize.X += 40;
	MessageBoxSize.Y = (YL * (Len(Message2) == 0 ? 1 : 2)) + 40;

	// draw the box
	Canvas.SetPos(Middle.X - (0.5*MessageBoxSize.X), Middle.Y - (0.5*MessageBoxSize.Y));
	Canvas.SetDrawColor(0,0,64,128);
	Canvas.DrawRect(MessageBoxSize.X, MessageBoxSize.Y);
	Canvas.SetPos(Middle.X - (0.5*MessageBoxSize.X), Middle.Y - (0.5*MessageBoxSize.Y));
	Canvas.SetDrawColor(0,0,64,255);
	Canvas.DrawBox(MessageBoxSize.X,MessageBoxSize.Y);

	// draw the title
	Canvas.TextSize(Message1, XL, YL);
	Canvas.SetPos(Middle.X - (0.5*XL), Len(Message2) > 0 ? Middle.Y - (YL + 10) : Middle.Y - YL * 0.5);
	Canvas.SetDrawColor(255,255,255);
	Canvas.DrawText(Message1);

	// draw the body
	Canvas.TextSize(Message2, XL, YL);
	Canvas.SetPos(Middle.X - (0.5*XL), Middle.Y + 10);
	Canvas.SetDrawColor(255,255,255);
	Canvas.DrawText(Message2);
}


final function DrawTutorialMessageBox( string Message1, array<string> BodyText, ETutorialMessageType MessageType, float InMinTimeForTutorialMessageToStayUp )
{
	local float XL, YL;
	local vector2D Middle;
	local float DrawX, DrawY;
	local string LineOfText;

	Middle.X = (0.5*Canvas.ClipX);// + TutorialScreen_MessageBoxSize.X;
	Middle.Y = (0.5*Canvas.ClipY);// + TutorialScreen_MessageBoxSize.Y;

	// set the size of the box to be slightly larger than the text to display
	//Canvas.TextSize(Len(Message1) > Len(Message2) ? Message1 : Message2, TutorialScreen_MessageBoxSize.X, YL);
	//TutorialScreen_MessageBoxSize.X += 40;
	//TutorialScreen_MessageBoxSize.Y = (YL * (Len(Message2) == 0 ? 1 : 2)) + 40;

	// draw the box
	Canvas.SetPos(Middle.X - (0.5*TutorialScreen_MessageBoxSize.X), Middle.Y - (0.5*TutorialScreen_MessageBoxSize.Y));
	Canvas.SetDrawColor(0,0,64,200);
	Canvas.DrawRect(TutorialScreen_MessageBoxSize.X, TutorialScreen_MessageBoxSize.Y);
	Canvas.SetPos(Middle.X - (0.5*TutorialScreen_MessageBoxSize.X), Middle.Y - (0.5*TutorialScreen_MessageBoxSize.Y));
	Canvas.SetDrawColor(0,0,64,255);
	Canvas.DrawBox(TutorialScreen_MessageBoxSize.X,TutorialScreen_MessageBoxSize.Y);

	// draw the title
	Canvas.Font = class'Engine'.static.GetLargeFont();
	Canvas.TextSize(Message1, XL, YL);
	Canvas.SetPos(Middle.X - (0.5*XL), Middle.Y - TutorialScreen_MessageBoxSize.Y * 0.5 + 20 );
	Canvas.SetDrawColor(255,255,255);
	Canvas.DrawText(Message1);

	// draw the body
	Canvas.Font = class'Engine'.static.GetMediumFont();
	Canvas.SetDrawColor(255,255,255);

	DrawX = Middle.X - (0.5 * TutorialScreen_MessageBoxSize.X - 20 ); // over to the left with 20 of border
	DrawY = Middle.Y - TutorialScreen_MessageBoxSize.Y * 0.5 + 25 + 60; // down 20 from the title

	Canvas.SetPos( DrawX, DrawY );

	foreach BodyText( LineOfText )
	{
		Canvas.DrawText( LineOfText );

		DrawY += 25;
	}

	// Don't show buttons until you can press them
	if( (WorldInfo.RealTimeSeconds-TimeOfTutorial) > InMinTimeForTutorialMessageToStayUp )
	{
		if(MessageType == ETMT_AcceptDecline)
		{
			// Accept
			DrawX = Middle.X + (TutorialScreen_MessageBoxSize.X * 0.5) - 350; 
			DrawY = Middle.Y + (TutorialScreen_MessageBoxSize.Y * 0.5) - 45; 
			Canvas.SetPos( DrawX, DrawY );
			Canvas.DrawTexture( Texture2D'UI_Common.button_A', 1.0f );

			DrawX += 40;
			Canvas.SetPos( DrawX, DrawY );
			Canvas.DrawText( "Accept" );

			// Decline
			DrawX = Middle.X + (TutorialScreen_MessageBoxSize.X * 0.5) - 150; 
			Canvas.SetPos( DrawX, DrawY );
			Canvas.DrawTexture( Texture2D'UI_Common.button_B', 1.0f );

			DrawX += 40;
			Canvas.SetPos( DrawX, DrawY );
			Canvas.DrawText( "Decline" );
		}
		else
		{
			// Ok (a or b button)
			DrawX = Middle.X + (TutorialScreen_MessageBoxSize.X * 0.5) - 190; // over to the left with 20 of border
			DrawY = Middle.Y + (TutorialScreen_MessageBoxSize.Y * 0.5) - 45; // 25 from bottom
			Canvas.SetPos( DrawX, DrawY );
			Canvas.DrawTexture( Texture2D'UI_Common.button_A', 1.0f );

			DrawX += 40; 
			Canvas.SetPos( DrawX, DrawY );
			Canvas.DrawTexture( Texture2D'UI_Common.button_B', 1.0f );

			DrawX += 40;
			Canvas.SetPos( DrawX, DrawY );
			Canvas.DrawText( "Ok" );
		}
	}
}



final function AttemptToDrawTargetSelection()
{
	local vector CameraLoc;
	local rotator CameraRot;
	local Actor Target;
	PlayerOwner.GetPlayerViewPoint(CameraLoc,CameraRot);

	if (NanoPC(PlayerOwner).TargetedActor != None)
	{
		Target = NanoPC(PlayerOwner).TargetedActor;
	}
	
	if (Target != None)
	{
		DrawSelectorAroundActor(Target,CameraLoc,CameraRot,1.25f - (VSize(Target.Location - CameraLoc)/10000.f));
	}
}



final function AttemptToDrawTargetSelectionList( const out array<Actor> TheTargetList )
{
	local vector CameraLoc;
	local rotator CameraRot;
	local Actor ATarget;

	PlayerOwner.GetPlayerViewPoint(CameraLoc,CameraRot);

	//`log( "AttemptToDrawTargetSelectionList" );

	foreach TheTargetList( ATarget )
	{
		//`log( "   " @ ATarget );

		DrawSelectorAroundActor( ATarget, CameraLoc, CameraRot, 1.25f - (VSize(ATarget.Location - CameraLoc)/10000.f) );
	}
}


final function DrawSelectorAroundActor(Actor TheActor, vector CameraLoc, rotator CameraRot, float Scale)
{
	local box TheBoundingBox;
	local box ScreenBox;
	local vector CamLoc;
	local rotator CamRot;

	local vector BoxExtent;

	local vector ScreenLoc;
	local float Radius, Height;
	local NanoInterface_Targetable TargetedInterface;
	local bool bGoodBox;
	local LinearColor ReticleColor;
	local NanoPC PC;

	Canvas.DrawColor = MakeColor(80,180,255,90);

	TargetedInterface = NanoInterface_Targetable(TheActor);

	if (TargetedInterface != None)
	{
		ScreenLoc = Canvas.Project(TargetedInterface.GetTargetedLocation());
	}
	else
	{
		ScreenLoc = Canvas.Project(TheActor.Location);
	}
	/*
	Canvas.SetPos(ScreenLoc.X,ScreenLoc.Y);
	Canvas.DrawText("[***]");
	*/

 	TheActor.GetBoundingCylinder(Radius,Height);
 	Radius = Radius * 0.5 * Scale;
 	Height = Height * Scale;
// 	DrawaancyBox(ScreenLoc.X,ScreenLoc.Y,Radius,Height);

	TheActor.GetComponentsBoundingBox( TheBoundingBox );
	//GetFancyBoxValues( TheBoundingBox, ScreenLoc.X, ScreenLoc.Y, Radius, Height );

	PlayerOwner.GetPlayerViewpoint(CamLoc,CamRot);

	// Project box into screen space
	bGoodBox = WorldBoxToScreenBox( Canvas, CamLoc, CamRot, TheBoundingBox, ScreenBox );

	// If that worked, draw it
	if(bGoodBox)
	{
		BoxExtent = (ScreenBox.Max - ScreenBox.Min);
		BoxExtent.X = FMax(BoxExtent.X,64.f);
		BoxExtent.Y = FMax(BoxExtent.Y,64.f);

		//DrawFancyBox( ScreenLoc.X, ScreenLoc.Y, BoxExtent.X, BoxExtent.Y);

		PC = NanoPC(PlayerOwner);
		if( PC.TargetedActor != None && PC.IsLockedOnWithSword() || PC.IsLockedOnWithGun() )
		{
			ReticleColor = MakeLinearColor(1.0, 0.0, 0.0, 1.0); // red
		}
		else if( PC.IsValidLockOnTarget(NanoPC(PlayerOwner).TargetedActor, TRUE) || PC.CheckForStabMantle(PC.TargetedActor) )
		{
			ReticleColor = MakeLinearColor(1.0, 0.5, 0.0, 1.0); // orange
		}
		else
		{
			ReticleColor = MakeLinearColor(80.0/255.0, 180.0/255.0, 255.0/255.0, 128.0/255.0); // blue
		}

		DrawFancyBox2( ScreenLoc.X, ScreenLoc.Y, BoxExtent.X, BoxExtent.Y, ReticleColor);

		//`log( ScreenLoc.X @ ScreenLoc.Y @ ScreenBox.Min.X @ ScreenBox.Min.Y @ ScreenBox.Max.X @ ScreenBox.Max.Y @ Radius @ Height );
	}
}

simulated function GetSubtitleSize( out float Width, out float Height )
{
	if ( NanoPCBase(PlayerOwner).IsShowingSubtitles() )
	{
		//todo:  re-enable when we get real fonts in
		//Canvas.Font = class'Engine'.static.GetAdditionalFont(FONT_Euro24);
		Canvas.Font = class'Engine'.static.GetTinyFont();
		Canvas.TextSize( "W", Width, Height );
	}
}

/** Gets an array of corners for a bounding box. */
final function GetBoxCorners(box BBox, out array<vector> Corners)
{
	Corners.length = 8;
	Corners[0].X = BBox.Min.X; Corners[0].Y = BBox.Min.Y; Corners[0].Z = BBox.Min.Z;
	Corners[1].X = BBox.Max.X; Corners[1].Y = BBox.Min.Y; Corners[1].Z = BBox.Min.Z;
	Corners[2].X = BBox.Min.X; Corners[2].Y = BBox.Max.Y; Corners[2].Z = BBox.Min.Z;
	Corners[3].X = BBox.Min.X; Corners[3].Y = BBox.Min.Y; Corners[3].Z = BBox.Max.Z;
	Corners[4].X = BBox.Max.X; Corners[4].Y = BBox.Max.Y; Corners[4].Z = BBox.Min.Z;
	Corners[5].X = BBox.Min.X; Corners[5].Y = BBox.Max.Y; Corners[5].Z = BBox.Max.Z;
	Corners[6].X = BBox.Max.X; Corners[6].Y = BBox.Min.Y; Corners[6].Z = BBox.Max.Z;
	Corners[7].X = BBox.Max.X; Corners[7].Y = BBox.Max.Y; Corners[7].Z = BBox.Max.Z;
}

/** Projects a bounding box from world-space coordinates to screen-space coordinates. */
final function bool WorldBoxToScreenBox(Canvas TheCanvas, vector CamLoc, rotator CamRot, box WorldBox, out box ScreenBox)
{
	local array<vector> WorldCorners;
	local array<vector> Corners;
	local int Index;

	GetBoxCorners(WorldBox, WorldCorners);
	for(Index = 0 ; Index < WorldCorners.length ; Index++)
	{
		// make sure this corner is in front of the camera
		if(vector(CamRot) dot Normal(WorldCorners[Index] - CamLoc) > 0.f)
		{
			Corners.length = Corners.length + 1;
			Corners[Corners.length - 1] = TheCanvas.Project(WorldCorners[Index]);
		}
	}

	if(Corners.length == 0)
	{
		// all corners were behind the camera
		return false;
	}

	//`log("WorldBoxToScreenBox:" @ Corners.length @ "corners in front of the camera");
	ScreenBox.Min = Corners[0];
	ScreenBox.Max = Corners[0];
	for(Index = 1 ; Index < Corners.length ; Index++)
	{
		ScreenBox.Min.X = FMin(ScreenBox.Min.X, Corners[Index].X);
		ScreenBox.Max.X = FMax(ScreenBox.Max.X, Corners[Index].X);
		ScreenBox.Min.Y = FMin(ScreenBox.Min.Y, Corners[Index].Y);
		ScreenBox.Max.Y = FMax(ScreenBox.Max.Y, Corners[Index].Y);
	}

	ScreenBox.Min.Z = 0;
	ScreenBox.Max.Z = 0;

	return true;
}


final simulated function DrawFancyBox2(float X, float Y, float Width, float Height, LinearColor ReticleColor)
{
	local float StartX, StartY;

	local int XSize;
	local int YSize;
	local float SizeRatio;

	//local float NormU, NormV, NormUL, NormVL;

	local float RotationTop;
	local float RotationBottom;

	local float BottomX, BottomY;

	local LinearColor LinColor;

	// so we have issues with content which has their origin under the world
	if( Width == 0 )
	{
		Width = 50;
	}

	if( Height == 0 )
	{
		Height = 100;
	}


	SizeRatio = Height / 365;  // 365 is 1
	XSize = 84 * SizeRatio;
	YSize = 123 * SizeRatio;

	//@todo -- Someone should make these actually const defaultproperties since doing this is slow and unnecessary
	LinColor = MakeLinearColor(0.004f,0.0f,0.0f,0.0f);
	MIC_ReticleTop.SetVectorParameterValue( 'Offset', LinColor );
	//@todo -- Someone should make these actually const defaultproperties since doing this is slow and unnecessary
	LinColor = MakeLinearColor(0.16f,0.24f,0.0f,0.0f);
	MIC_ReticleTop.SetVectorParameterValue( 'Size', LinColor );

	//@todo -- Someone should make these actually const defaultproperties since doing this is slow and unnecessary
	LinColor = MakeLinearColor(0.339f,0.0f,0.0f,0.0f);
	MIC_ReticleBottom.SetVectorParameterValue( 'Offset', LinColor );
	//@todo -- Someone should make these actually const defaultproperties since doing this is slow and unnecessary
	LinColor = MakeLinearColor(0.16f,0.24f,0.0f,0.0f);
	MIC_ReticleBottom.SetVectorParameterValue( 'Size', LinColor );

	RotationTop = 1.0f;
	RotationBottom = 0.5f;

	StartX = X - Width/1.7;
	StartY = Y - Height/1.7;

	BottomX = StartX + (Width * 1.0) - XSize/2;
	BottomY = StartY + (Height * 1.1) + 15.0f - YSize;


	//@todo -- Someone should make these actually const defaultproperties since doing this is slow and unnecessary
	LinColor = MakeLinearColor(0.5f,0.5f,0.5f,1.0f);
	MIC_ReticleTop.SetVectorParameterValue( 'ReticleOpacity', LinColor );
	MIC_ReticleBottom.SetVectorParameterValue( 'ReticleOpacity', LinColor );

	MIC_ReticleTop.SetVectorParameterValue( 'ReticleColor', ReticleColor );
	MIC_ReticleBottom.SetVectorParameterValue( 'ReticleColor', ReticleColor );

	// draw the top left side
	Canvas.SetPos( StartX, StartY );
	Canvas.DrawMaterialTile( MIC_ReticleTop, XSize, YSize, 0, 0, 1, 1 );
	MIC_ReticleTop.SetScalarParameterValue( 'ReticleDirection', RotationTop );
	//MIC_ReticleTop.SetVectorParameterValue( 'ReticleOpacity', MakeLinearColor(0.2f,0.2f,0.2f,1.0f) );
	//MIC_ReticleTop.SetVectorParameterValue( 'ReticleColor', MakeLinearColor(0.2f,0.2f,0.2f,1.0f) );


	// draw the bottom right
	Canvas.SetPos( BottomX, BottomY );
	MIC_ReticleBottom.SetScalarParameterValue( 'ReticleDirection', RotationBottom );
	//MIC_ReticleBottom.SetVectorParameterValue( 'ReticleOpacity', MakeLinearColor(0.2f,0.2f,0.2f,1.0f) );
	//MIC_ReticleBottom.SetVectorParameterValue( 'ReticleColor', MakeLinearColor(0.2f,0.2f,0.2f,1.0f) );

	Canvas.DrawMaterialTile( MIC_ReticleBottom, XSize, YSize, 0, 0, 1, 1 );
}


final simulated function DrawFancyBox(float X, float Y, float Width, float Height)
{
	X = X - Width/2;
	Y = Y - Height/2;
	Canvas.SetPos(X, Y);
	// draw the top left side
	Canvas.DrawRect(2, Height * 0.3);
	Canvas.DrawRect(Width * 0.3, 2);

	// draw the bottom right
	Canvas.SetPos(X + (Width * 0.7), Y + Height - 2);
	Canvas.DrawRect(Width * 0.3, 2);
	Canvas.SetPos(X + Width - 2, Y + (Height * 0.7));
	Canvas.DrawRect(2, Height * 0.3);
}

final simulated function DrawBeaconDirections(NanoPawn NP, vector2d CenterPos, float Scale)
{
	local int MICIndex, Idx;
	local NanoGRI NGRI;
	local array<NanoInterface_Objective> RadarObjs;

	MICIndex = 0;

	// Get set of active radar objectives from mission manager in GRI
	NGRI = NP.GetGRI();
	if( NGRI != None && NGRI.TheMissionManager != None )
	{
		RadarObjs = NGRI.TheMissionManager.GetActiveMissionObjectives();
	}

	// Then draw each one
	for(Idx=0; Idx < RadarObjs.length; Idx++)
	{
		DrawBeaconDirections_Worker( RadarObjs[Idx], NP, CenterPos, Scale, MICIndex );
	}
}

final simulated function DrawBeaconDirections_Worker(NanoInterface_Objective Objective, NanoPawn NP, vector2d CenterPos, float Scale, out int MICIndex)
{
	local float DrawX, DrawY;
	local float BeaconDir, ErrorZ;
	local color IndicatorColor;
	local vector ObjLocation;
	local LinearColor LinColor;

	if( Objective != none )
	{
		// get the location of the objective
		ObjLocation = Objective.GetObjectiveLocation();

		if(BeaconMIC.length <= MICIndex || BeaconMIC[MICIndex] == None)
		{
			BeaconMIC[MICIndex] = new(self) class'MaterialInstanceConstant';
			BeaconMIC[MICIndex].SetParent( BeaconLocatorMaterial );
		}

		// Update direction param
		BeaconDir = CalculateLocationMaterialEffect(NP, ObjLocation);
		LinColor.R = BeaconDir;
		LinColor.A = 1.0;
		BeaconMIC[MICIndex].SetVectorParameterValue( 'HUD_Location_Rotator', LinColor );

		// Update Z distance color param
		ErrorZ = (ObjLocation.Z - NP.Location.Z);
		if(ErrorZ > BeaconColorBlendDist)
		{
			IndicatorColor = BeaconAboveColor;
		}
		else if(ErrorZ < -BeaconColorBlendDist)
		{
			IndicatorColor = BeaconBelowColor;
		}
		else if(ErrorZ > 0)
		{
			IndicatorColor = LerpColor(BeaconLevelColor, BeaconAboveColor, ErrorZ/BeaconColorBlendDist);
		}
		else
		{
			IndicatorColor = LerpColor(BeaconLevelColor, BeaconBelowColor, -ErrorZ/BeaconColorBlendDist);
		}
		LinColor = ColorToLinearColor(IndicatorColor);
		BeaconMIC[MICIndex].SetVectorParameterValue( 'Color', LinColor );

		// Draw tile with material
		DrawX = CenterPos.X - 128*Scale;
		DrawY = CenterPos.Y - 128*Scale;
		Canvas.SetPos( DrawX, DrawY ) ;
		Canvas.DrawMaterialTile( BeaconMIC[MICIndex], 256*Scale, 256*Scale, 0, 0, 1.f, 1.f );

		MICIndex++;
	}

}


final function float CalculateLocationMaterialEffect( NanoPawn NP, vector LocationToTest )
{
	local float DirOfHit, DotForward;
	local vector AxisX, AxisY, AxisZ, LocationDirection;

	GetAxes(NP.GetCamera().LastCameraRot, AxisX, AxisY, AxisZ);

	LocationDirection = LocationToTest - NP.Location;
	LocationDirection.Z = 0.0;
	LocationDirection = Normal(LocationDirection);

	DotForward = LocationDirection Dot AxisX;
	DirOfHit = ACos(DotForward) * (0.5/PI);
	if((LocationDirection Dot AxisY) < 0.0)
	{
		DirOfHit *= -1.0;
	}
	DirOfHit *= -1.0;

	return DirOfHit;
}

/**
 * Delegate hook for anything that wants a debug draw.
 *
 * @see: DebugDraws, DrawHUD()
 */
delegate DebugDraw(NanoHUD_Base H)
{
}

/**
 * Handy function to add/remove debug draw functions.
 */
function SetDebugDraw(delegate<DebugDraw> DebugDrawFunc, bool bAdd)
{
	local int Idx;
	Idx = DebugDrawList.Find(DebugDrawFunc);
	if (bAdd && Idx == -1)
	{
		DebugDrawList[DebugDrawList.Length] = DebugDrawFunc;
	}
	else
	if (!bAdd && Idx != -1)
	{
		DebugDrawList.Remove(Idx,1);
	}
}



/** This will draw some debug text from the NPES **/
function int DrawNPES( int YPos )
{
	local int NumCopCars;
	local NanoAI AI;


	local string Desc;

	if( NanoGRI(WorldInfo.GRI).NPES.bActive == TRUE )
	{
		foreach WorldInfo.AllControllers( class'NanoAI', AI )
		{
			if( NanoAI_PoliceCar(AI) != None )
			{
				NumCopCars++;
			}
		}
		
		YPos -= 18;
		Canvas.SetPos(34, YPos);
		Desc = "NumCopCars: " @ NumCopCars @ " MaxRooftop:" @ int(NanoGRI(WorldInfo.GRI).NPES.MaxPointsAvail * NanoGRI(WorldInfo.GRI).NPES.ChaosTierSpawnData[NanoGRI(WorldInfo.GRI).NPES.CurrChaosTier].PercentOfMaxEnemiesAllowedToSpawnFromRooftops) @ "CurrRooftops:" @ NanoGRI(WorldInfo.GRI).AIBlackboard.NumSpawnedFromRooftops;
		Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);


		YPos -= 18;
		Canvas.SetPos(34, YPos);
		Desc = "CloudBurstPoints: " @ NanoGRI(WorldInfo.GRI).NPES.CloudBurstPoints @ " CloudBurstEnemies: " @ NanoGRI(WorldInfo.GRI).NPES.CloudBurstEnemies @ " TimeTilSpawn: " @ (NanoGRI(WorldInfo.GRI).NPES.TimeToDoCloudManagement - WorldInfo.TimeSeconds);
		Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);

		YPos -= 18;
		Canvas.SetPos(34, YPos);
		Desc = "CurrPointsSpent:" @ NanoGRI(WorldInfo.GRI).NPES.CurrPointsSpent @ " CurrNumEnemies:" @ NanoGRI(WorldInfo.GRI).NPES.CurrNumEnemies;
		Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);

		YPos -= 18;
		Canvas.SetPos(34, YPos);
		Desc = "MaxPoints: " @ NanoGRI(WorldInfo.GRI).NPES.MaxPointsAvail @ " MaxNumEnemies: " @ NanoGRI(WorldInfo.GRI).NPES.MaxNumEnemies;
		Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);


		YPos -= 18;
		Canvas.SetPos(34, YPos);
		Desc = "Tier:" @ NanoGRI(WorldInfo.GRI).NPES.CurrChaosTier @ "CurrNumEnemiesAtDefensivePoints:" @ NanoGRI(WorldInfo.GRI).NPES.CurrNumEnemiesAtDefensivePoints;
		Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);
	}

	return YPos;
}



/** This will draw some debug text from the Encounter director **/
function int DrawEncounterDirector( int YPos )
{
	local string Desc;

	YPos -= 18;
	Canvas.SetPos(34, YPos);
	Desc = "Director60:" @ NanoGRI(WorldInfo.GRI).NED.GetDirectorStateLong();
	Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);

	YPos -= 18;
	Canvas.SetPos(34, YPos);
	Desc = "Director10:" @ NanoGRI(WorldInfo.GRI).NED.GetDirectorStateShort();
	Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);

	YPos -= 18;
	Canvas.SetPos(34, YPos);
	Desc = "DirectorCurr:" @ NanoGRI(WorldInfo.GRI).NED.GetDirectorStateCurr();
	Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);

	return YPos;
}

/** This will draw some debug text from the MusicManager **/
function int DrawMusicManager( int YPos )
{
	local NanoMusicManager MusicManager;
	local string Desc;

	MusicManager = NanoGRI(WorldInfo.GRI).GetNanoPC().MusicManager;

	YPos -= 18;
	Canvas.SetPos(34, YPos);
	Desc = "EME_ID:" @ MusicManager.CurrMusicEventID @ "MusicTrack:" @ MusicManager.CurrPlayingTrack @ "MusicHit:" @ MusicManager.LastPlayedHit;
	Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);


	return YPos;
}


/** This will draw some debug text to help detail current combat state**/
function int DrawCombatState( int YPos )
{
	local string Desc;
	local NanoAIBlackboard Blackboard;
	local vector2d Pacing;
	local TargetableOctreeComponent Targetable;

	Targetable = NanoInterface_Targetable(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn).GetTargetableOctreeComponent();

	Blackboard = NanoGRI(WorldInfo.GRI).AIBlackboard;

	Pacing = Blackboard.GlobalCombatPacingPerChaosTier[NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel()].CombatPacingRange;

	YPos -= 18;
	Canvas.SetPos(34, YPos);
	Desc = "Engaged:" @ Targetable.MeleeEngageList.Length @ " Standby:" @ Targetable.MeleeStandByList.Length @ " Spectator:" @ Targetable.MeleeSpectatorList.Length  @ " Ranged:" @ Targetable.RangedShooterList.Length;
	Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);

	YPos -= 18;
	Canvas.SetPos(34, YPos);
	Desc = "GlobalPacing_NextAttack:" @ FMin(Blackboard.GlobalPacing_NextAttack-WorldInfo.TimeSeconds,(FMax(Pacing.X,Pacing.Y))) @ "NumCurrentlyShooting:" @ Targetable.NumCurrentlyShooting @ "NumCurrentlyMeleeing:" @ Targetable.NumCurrentlyMeleeing;;
	Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);

	YPos -= 18;
	Canvas.SetPos(34, YPos);
	Desc = "ERT_Attack:" @ Blackboard.GlobalCombatResponse[ERT_Attack] @ "CombatPacingAttackImmediatelyThreshold:" @ class'NanoAI_Trooper'.default.CombatPacingAttackImmediatelyThreshold @ "ERT_Idle:" @ Blackboard.GlobalCombatResponse[ERT_Idle];
	Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);


	return YPos;
}




/** This will draw some debug text to help detail current audio state**/
function int DrawAudioState( int YPos )
{
	local NanoAudioSceneManager NASM;
	local string Desc;

	local AudioDevice Audio;
	local string CurrSoundMode;

	Audio = class'Engine'.static.GetAudioDevice();

	if( ( Audio != None ) && ( Audio.CurrentMode != None ) )
	{
		CurrSoundMode = String(Audio.CurrentMode.Name);
	}


	NASM = NanoGRI(WorldInfo.GRI).NASM;


	YPos -= 18;
	Canvas.SetPos(34, YPos);
	Desc = "AudioScene:" @ NASM.CurrPhase @ " SoundMode:" @ CurrSoundMode @ " ActiveBank:" @ NASM.ActiveBank;
	Canvas.DrawText(Desc, TRUE, 1.f, 1.f, TextRenderInfo);


	return YPos;
}


function ShowDebugInfo(out float out_YL, out float out_YPos)
{
	local NanoGRI NGRI;

	Super.ShowDebugInfo(out_YL, out_YPos);

	if ( ShouldDisplayDebug('Peds') && (WorldInfo.PopulationManager != None) )
	{
		WorldInfo.PopulationManager.DisplayDebug(self, out_YL, out_YPos);
		MinimapHUDElement.DrawDebugPeds(Canvas, MapDrawInfo);
	}

	if (ShouldDisplayDebug('Traffic'))
	{
		NGRI = NanoGRI(WorldInfo.GRI);
		if (NGRI != None)
		{
			if( NGRI.AirVehiclePopMgr != None )
			{
				Canvas.SetDrawColor(255,0,0);
				out_YPos += out_YL;
				Canvas.SetPos(4,out_YPos);
				Canvas.DrawText("--- Air Vehicle Population Manager ---");

				NGRI.AirVehiclePopMgr.DisplayDebug(self, out_YL, out_YPos);
			}

			if( NGRI.GroundVehiclePopMgr != None )
			{
				Canvas.SetDrawColor(0,255,0);
				out_YPos += out_YL;
				Canvas.SetPos(4,out_YPos);
				Canvas.DrawText("--- Ground Vehicle Population Manager ---");

				NGRI.GroundVehiclePopMgr.DisplayDebug(self, out_YL, out_YPos);
			}
		}
	}
}


function DrawNanoTargetPointInGameInfo()
{
	local vector CamLoc;
	local rotator CamRot;

	local NanoTargetPoint NTP;

	PlayerOwner.GetPlayerViewPoint( CamLoc, CamRot );

	foreach WorldInfo.AllActors(class'NanoTargetPoint', NTP)
	{
		if( (NTP.Location - CamLoc) dot vector(CamRot) > 0.f )
		{
			NTP.DrawInGameInfo( self );
		}
	}
}

/** */
function ShowTutorial( const string Title, const array<string> BodyText, float InDelayTime, bool bShouldPauseGame )
{
	local TutorialDatum Tutorial;

	Tutorial.TutorialScreen_Title = Title;
	Tutorial.TutorialScreen_Body = BodyText;

	Tutorial.TimeToShow = WorldInfo.TimeSeconds + InDelayTime;
	Tutorial.MinTimeForTutorialMessageToStayUp = 2.0f; // need to add this to the params

	Tutorial.bShouldPauseGame = bShouldPauseGame;

	Tutorial.MessageType = ETMT_Ok;

	Tutorials.AddItem( Tutorial );
}

/** */
function ShowTutorialAction( SeqAct_ShowTutorialScreen TutorialAction)
{
	local TutorialDatum Tutorial;

	Tutorial.TutorialScreen_Title = TutorialAction.Title;
	Tutorial.TutorialScreen_Body = TutorialAction.BodyText;

	Tutorial.TimeToShow = WorldInfo.TimeSeconds + TutorialAction.DelayTime;
	Tutorial.MinTimeForTutorialMessageToStayUp = TutorialAction.MinTimeForTutorialMessageToStayUp;

	Tutorial.bShouldPauseGame = TutorialAction.bShouldPauseGame;

	Tutorial.TutorialAction = TutorialAction;
	Tutorial.MessageType = TutorialAction.MessageType;

	Tutorials.AddItem( Tutorial );
}


/** Will look around the player's pawn and see if there are any DBNO guys around.  If there are then show some help info **/
function PossiblyShowDBNOOptions()
{
	local NanoPawn DBNOPawn;

	local vector2d ScreenCenter;
	local float DeltaY;


	// don't show if we are already doing a DBNO special move
	if( NSM_DBNO_InteractionEnemyBase(NanoPawn(PlayerOwner.Pawn).ActiveSpecialMove) != None )
	{
		return;
	}



	//we need to find all the pawns around us and find dbno ones
	foreach WorldInfo.AllPawns( class'NanoPawn', DBNOPawn, PlayerOwner.Pawn.Location, class'NanoPlayerInput'.default.DBNO_InteractionDistance )
	{
		if( DBNOPawn.IsInState( 'DBNO' ) == TRUE )
		{
			break;
		}
	}

	if( DBNOPawn != None )
	{
		ScreenCenter.X = 0.93 * Canvas.SizeX;
		ScreenCenter.Y = 0.60 * Canvas.SizeY;

		Canvas.Font = class'Engine'.static.GetTinyFont();


		// button X
		DeltaY = ScreenCenter.Y + 30;
		Canvas.SetPos( ScreenCenter.X , DeltaY );
		Canvas.DrawTile( HUDButtonsTex, 26,26, 452,33, 26,26 );

		Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
		Canvas.DrawText( "Harvest" );

		// button Y
		DeltaY = ScreenCenter.Y + 60;
		Canvas.SetPos( ScreenCenter.X , DeltaY );
		Canvas.DrawTile( HUDButtonsTex, 26,26, 484,7, 26,26 );

		Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
		Canvas.DrawText( "PatDown" );


		// button B
		DeltaY = ScreenCenter.Y + 90;
		Canvas.SetPos( ScreenCenter.X , DeltaY );
		Canvas.DrawTile( HUDButtonsTex, 26,26, 452,7, 26,26 );

		Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
		Canvas.DrawText( "Interrogate" );


		// button A
		DeltaY = ScreenCenter.Y + 120;
		Canvas.SetPos( ScreenCenter.X , DeltaY );
		Canvas.DrawTile( HUDButtonsTex, 26,26, 484,33, 26,26 );

		Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
		Canvas.DrawText( "Drag" );

	}
}



/** Will look around the player's pawn and see if the player is actively interrogating anyone **/
function PossiblyShowDBNOInterrogateOptions()
{
	local vector2d ScreenCenter;
	local float DeltaY;


	// don't show if we are not doing a NSM_DBNO_InterrogateEnemy special move
	if( NSM_DBNO_InterrogateEnemy(NanoPawn(PlayerOwner.Pawn).ActiveSpecialMove) == None )
	{
		return;
	}


	ScreenCenter.X = 0.93 * Canvas.SizeX;
	ScreenCenter.Y = 0.60 * Canvas.SizeY;

	Canvas.Font = class'Engine'.static.GetTinyFont();


	// button X
	DeltaY = ScreenCenter.Y + 30;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 452,33, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Threaten" );

	// button Y
	DeltaY = ScreenCenter.Y + 60;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 484,7, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Hit" );


	// button B
	DeltaY = ScreenCenter.Y + 90;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 452,7, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Be Nice" );


	// button A
	DeltaY = ScreenCenter.Y + 120;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 484,33, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Drop" );


	// right trigger
	DeltaY = ScreenCenter.Y + 150;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 31,25, 416,7, 31,25 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Execute" );

}



/** Will look around the player's pawn and see if the player is actively interrogating anyone **/
function PossiblyShowDBNODragOptions()
{
	local vector2d ScreenCenter;
	local float DeltaY;


	// don't show if we are not doing a NSM_DBNO_DragEnemy special move
	if( NSM_DBNO_DragEnemy(NanoPawn(PlayerOwner.Pawn).ActiveSpecialMove) == None )
	{
		return;
	}


	ScreenCenter.X = 0.93 * Canvas.SizeX;
	ScreenCenter.Y = 0.60 * Canvas.SizeY;

	Canvas.Font = class'Engine'.static.GetTinyFont();


	// button Y
	DeltaY = ScreenCenter.Y + 30;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 484,7, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Hold Over Ledge" );


	// button A
	DeltaY = ScreenCenter.Y + 60;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 484,33, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Release" );

}



/** Will look around the player's pawn and see if the player is actively interrogating anyone **/
function PossiblyShowDBNOHoldingOverLedgeOptions()
{
	local vector2d ScreenCenter;
	local float DeltaY;


	// don't show if we are not doing a NSM_DBNO_DragEnemy special move
	if( NSM_DBNO_Drag_ThrowFromLedge_Enemy(NanoPawn(PlayerOwner.Pawn).ActiveSpecialMove) == None )
	{
		return;
	}


	ScreenCenter.X = 0.93 * Canvas.SizeX;
	ScreenCenter.Y = 0.60 * Canvas.SizeY;

	Canvas.Font = class'Engine'.static.GetTinyFont();



	// button A
	DeltaY = ScreenCenter.Y + 30;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 484,33, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Throw From Ledge" );


}





/** Will look around the player's pawn and see if there are any DBNO guys around.  If there are then show some help info **/
function PossiblyDrawDBNOTimers()
{
	local NanoPawn DBNOPawn;


	//we need to find all the pawns around us and find dbno ones
	foreach WorldInfo.AllPawns( class'NanoPawn', DBNOPawn, PlayerOwner.Pawn.Location, 2048.f )
	{
		if( DBNOPawn.IsInState( 'DBNO' ) == TRUE )
		{
			DBNOPawn.DrawDBNOCountdownTimer( self );
		}
	}

}


function PossiblyShowHostageOptions()
{
	local vector2d ScreenCenter;
	local float DeltaY;


	// don't show if we are not doing a NSM_DBNO_InterrogateEnemy special move
	if( NSM_Melee_GrabAHostageEnemy(NanoPawn(PlayerOwner.Pawn).ActiveSpecialMove) == None )
	{
		return;
	}


	ScreenCenter.X = 0.93 * Canvas.SizeX;
	ScreenCenter.Y = 0.60 * Canvas.SizeY;

	Canvas.Font = class'Engine'.static.GetTinyFont();


	// button X
	DeltaY = ScreenCenter.Y + 30;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 452,33, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Stab" );

	// button Y
	DeltaY = ScreenCenter.Y + 60;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 484,7, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "KickForwad" );


	// button B
	DeltaY = ScreenCenter.Y + 90;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 452,7, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "BLAH" );


	// button A
	DeltaY = ScreenCenter.Y + 120;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 26,26, 484,33, 26,26 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Drop" );


	// right trigger
	DeltaY = ScreenCenter.Y + 150;
	Canvas.SetPos( ScreenCenter.X , DeltaY );
	Canvas.DrawTile( HUDButtonsTex, 31,25, 416,7, 31,25 );

	Canvas.SetPos( ScreenCenter.X + 30 , DeltaY );
	Canvas.DrawText( "Execute" );
}







defaultproperties
{
	TickGroup=TG_DuringAsyncWork

	HUDButtonsTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_IngameMenu_Inventory'


	MapDrawInfo=(Minimap_UL=(X=0.77,Y=0.35),MinimapSize=(X=0.16,Y=0.16),MinimapToWorldScale=75.0,bDrawBorder=TRUE,bEnableAboveBelowIcons=TRUE)

	HealthBarMaxLength=300.0
	HealthBarMaxWidth=10

	NanoPowerBarMaxLength=150.0
	NanoPowerBarMaxWidth=10

	QuickBindShowDuration=1.5

	NanoPowerForgeCoreBarMaxLength=150	
	NanoPowerForgeCoreBarMaxWidth=10

	NanoSpeedBarScale=0.2

	NanoFreeForgeIconSize=32

	BeaconLocatorMaterial=Material'UI_HUD.HUD_LocationDir_Mat'
	BeaconLocatorCenter=(X=1150,Y=100)

	BeaconAboveColor=(B=255)
	BeaconBelowColor=(R=255)
	BeaconLevelColor=(R=255,G=255,B=255)
	BeaconColorBlendDist=1000.0

	WeaponMissingColor=(R=255,G=255,B=255,A=128)
	WeaponHolsteredColor=(R=255,G=255,B=255,A=255)
	WeaponActiveColor=(R=88,G=134,B=209,A=255)

	IRISMovieMat=MaterialInstanceConstant'Nano_Iris_Proto.Iris_Overlay_INST'
	//IRISTextureMovie=TextureMovie'Nano_Iris_Proto.nano_Iris'  // should always need to pass this in (this is 20megs atm)
	IRISOpacityBlendRate=10.f

	CurrentUIPageIndex=-1

	MI_ReticleSource=MaterialInterface'Nano_ProtoHUD_Ingame.M_UI_HUD_Ingame_Reticle01'


	ChaosUITexture=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_ChaosMeter'
	ChaosUIOrigin=(X=16,Y=16)
	ChaosHistoryYOffset=130.0

	ComboUITexture=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_ChaosMeter'
	ComboUIOrigin=(X=-100,Y=16)


	MessageBoxSize=(X=250,Y=120)
	TutorialScreen_MessageBoxSize=(X=850,Y=650)

	DmgIndicator=MaterialInstanceConstant'Nano_WeaponFX.GEN.Materials.M_DamageArrow_INST'

	NewPostIcon=(IconTex=Texture2D'UI_HUD.MiniMap.MissionProc',Coords=(U=0,V=0,UL=256,VL=256))
	NewPostOrigin=(X=15,Y=50)
	NewPostIconSize=(X=24,Y=24)
	NewPostPulseSpeed=1.0


	TextRenderInfo=(bEnableShadow=true)

	Text_ClipShadowed=(bClipText=TRUE,bEnableShadow=TRUE)
	Text_NoClipShadowed=(bClipText=FALSE,bEnableShadow=TRUE)

	MeleeComboWindowStart=-1.f
	MeleeComboWindowEnd=-1.f
	MeleeComboSuccessTransition=-1.f
	MeleeComboFailTransition=-1.f
	MeleeAttackSpeedScale=1.f

	SO_Damping=15.0
	SO_Stiffness=200.0

	SOT_Damping=15.0
	SOT_Stiffness=200.0

}

/**
 *  okie so we are going to do this:
 *
 *  make some nano plans for the weapon modifiers
 *  make a base weapon modifier class
 *      -chasis
 *      -bullets
 *   -has whether it is unique or not (so you can combine shizzle)
 *
 *  make explosive
 *  make suck towards
 *  make reload faster
 *  make less recoil
 *
 *
 *
 *  */

