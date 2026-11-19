/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_BaseHudScene extends UIScene
	native;

var(HudScene) float PriorityLevel;
var(HudScene) float FadeInTime;
var(HudScene) float FadeOutTime;
var(HudScene) float InactiveFadeValue;

// If true, this scene will be ticked when hidden
var	bool bTickWhenHidden;

var transient float FadeDestination;
var transient float FadeTime;

var transient UIScene AdminMenuScene;
var transient UIScene ConfirmationScene;
var transient UIScene StatsScene;

var transient bool bSceneReady;

/** References to instanced scenes that this scene may have opened */
var transient UIScene OpenedStatScene;
var transient UIScene OpenedHostOptionsScene;

var() bool bAttractModeEnabled;
var float CurrentAttractTime;
var bool bInAttractMode;
var() float TimeUntilAttractMode;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native function SetViewportRequiresKeyboardInput(bool bRequiresKeyboard);


function ELoginStatus GetLoginStatus(int ControllerId)
{
	local ELoginStatus Result;
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	Result = LS_NotLoggedIn;

	// Figure out if we have an online subsystem registered
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			Result = PlayerInterface.GetLoginStatus(ControllerId);
		}
	}

	return Result;
}

// Helper funcitons for Systems
final function bool IsPCBuild()
{
	return !GetWorldInfo().IsConsoleBuild();
}
final function bool IsPS3Build()
{
	return GetWorldInfo().IsPS3Build();
}
final function bool IsXboxBuild()
{
	return GetWorldInfo().IsConsoleBuild() && !IsPS3Build();
}

function TPHUD GetHudOwner(optional int Index)
{
	local LocalPlayer LP;
	LP = GetPlayerOwner(Index);
	if (LP != none && LP.Actor != none && LP.Actor.MyHud != none)
	{
		return TPHud( LP.Actor.MyHud );
	}

	return none;

}

/** Called each Tick */
event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	if (bInAttractMode)
	{
		;
		//`log("We just finished attract mode, so reset everything");
		bInAttractMode = false;
		ResetAttractModeTimer();
		//`log("CurrentAttractTime="@CurrentAttractTime);
	}
	else if (bAttractModeEnabled && !bInAttractMode && GetWorldInfo().IsConsoleBuild() && !GetPC().bIsDemoMode)
	{
		CurrentAttractTime += DeltaTime;
		//`log("CurrentAttractTime="@CurrentAttractTime);
		if (CurrentAttractTime > TimeUntilAttractMode)
		{
			BeginAttractMode();
		}
	}
}


/** Called before the first tick if bSceneReady = false */

event InitScene()
{
	bSceneReady = true;
	// no attract mode on PC
	if (!GetWorldInfo().IsConsoleBuild() || GetPC().bIsDemoMode)
		bAttractModeEnabled = false;
}

function TPHUD GetWarfareHud(optional int PlayerIndex)
{
	local LocalPlayer LP;
	Local PlayerController PC;

	LP = GetPlayerOwner(PlayerIndex);
	if (LP!=None)
	{
		PC = LP.Actor;
		if ( PC != none )
		{
			return TPHUD(PC.MyHud);
		}
	}
	return none;
}

/**
 * All of the MP scenes are hidden right away.
 */
event SceneActivated( bool bInitialActivation )
{
	if ( bInitialActivation )
	{
		//bHidden = true; //SPARK MAY CODEDROP
		SetVisibility(false);
	}
	Super.SceneActivated(bInitialActivation);
}

/**
 * Redirect SetVisibility to adjust the opacity with fades
 */
event SetVisibility( bool bIsVisible )
{
	if ( bIsVisible )
	{
		//if ( bHidden ) //SPARK MAY CODEDROP
		if( !IsVisible() )
		{
			FadeIn(true);
			//bHidden = false; //SPARK MAY CODEDROP
			super.SetVisibility(true);
		}
		else
		{
			FadeIn(false);
		}
	}
	else
	{
		//if ( !bHidden  ) //SPARK MAY CODEDROP
		if( IsVisible() )
		{
			FadeOut();
		}
	}
}

function FadeIn(bool bResetOpacity)
{
	if (bResetOpacity)
	{
		Opacity = 0.0f;
	}

	//if (bHidden) //SPARK MAY CODEDROP
	if( !IsVisible() )
	{
		//bHidden = false; //SPARK MAY CODEDROP
		super.SetVisibility(true);
	}

	FadeScene(1.0, (1.0 - Opacity) * FadeInTime );
	PlayUISound('MenuPopup');
}

function FadeOut()
{
	PlayUISound('MenuPopDown');
	FadeScene(0.0, Opacity * FadeOutTime);
}

function FadeInactive()
{
	FadeScene(InactiveFadeValue, abs(Opacity - InactiveFadeValue) * FadeOutTime);
}

/**
 * This event is called natively when a fade has been completed.
 */
event FadeCompleted()
{
	if (Opacity <= 0.0)
	{
		//bHidden = true; //SPARK MAY CODEDROP
		SetVisibility(false);
	}
	else
	{
		//bHidden = false; // SPARK MAY CODEDROP
		SetVisibility(true);
	}
}

/**
 * Fade this Scene in or out
 *
 * @param	bFadeIn		If true, we want to fade the scene in
 */
event FadeScene(float TargetOpacity, float TargetTime)
{
	FadeDestination = TargetOpacity;
	FadeTime = TargetTime;
}

function DisplayGamerCard(int ControllerId,PlayerReplicationInfo PRI)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx LivePI;

	if ( PRI != none )
    {
		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
		if ( OnlineSub != none )
		{
			LivePI = OnlineSub.PlayerInterfaceEx;
			if ( LivePI != none )
			{
				LivePI.ShowGamerCardUI(ControllerId,PRI.UniqueId);
			}
		}
	}
}

function ResetAttractModeTimer()
{
	CurrentAttractTime=0.0f;
	bAttractModeEnabled=true;
}

function StopAttractModeTimer()
{
	bAttractModeEnabled=false;
}

function BeginAttractMode()
{
	local LocalPlayer LP;
	local TPGameViewportClient viewport;
	local string ErrorDisplay;

	LP = GetPlayerOwner();
    viewport = TPGameViewportClient(LP.ViewportClient);

	GetDataStoreStringValue("<Registry:FrontEndError_Display>", ErrorDisplay);
	if (ErrorDisplay == "" || ErrorDisplay == "0")
	{
		bInAttractMode=true;

		;

		// Game thread will block here
		viewport.FullScreenPlayMovie('AttractMode', PLAYMOVIE_StreamBlock);
	}

	//`log("Attract mode over!!!");
	ResetAttractModeTimer();
}

// default does nothing
//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	return false;
}

function TPPlayerController GetPC()
{
	local TPPlayerController TPC;
	local LocalPlayer LP;

	LP = GetPlayerOwner();

	if (LP != none && LP.Actor != none)
	{
		TPC = TPPlayerController(LP.Actor);
	}
	return TPC;
}

/*
function AdminMenuDeactivated( UIScene DeactivatedScene )
{
	OpenedHostOptionsScene = None;
}

function ShowAdminMenu()
{
	local UIScene_AdminMenu Scene;

	if ( AdminMenuScene != none )
	{
		// Nothing, `just create a new instance
		SceneClient.OpenScene(AdminMenuScene, none, OpenedHostOptionsScene);
		Scene = UIScene_AdminMenu(OpenedHostOptionsScene);
		if ( Scene != none )
		{
			OpenedHostOptionsScene.OnSceneDeactivated = AdminMenuDeactivated;
			Scene.SetVisibility(true);
			Scene.OnSceneClose = Restore;
			PlayUISound('Click');
			FadeInactive();
		}
	}
	PlayUISound('Error');
}

function StatsMenuDeactivated( UIScene DeactivatedScene )
{
	OpenedStatScene = None;
}

function ShowStatsMenu(WarPRI PRIToView)
{
	local UIScene_IngameStats Scene;

	if ( PRIToView != none && StatsScene != none )
	{
		// Nothing, `just create a new instance
		SceneClient.OpenScene(StatsScene, none, OpenedStatScene);
		Scene = UIScene_IngameStats(OpenedStatScene);
		if ( Scene != none )
		{
			OpenedStatScene.OnSceneDeactivated = StatsMenuDeactivated;
			Scene.SetUNId(PRIToView.UniqueId);
			Scene.SetVisibility(true);
			Scene.OnSceneClose = Restore;
			PlayUISound('Click');
			FadeInactive();
		}
	}
	PlayUISound('Error');
}

function ShowGamerTag(int ControllerId,WarPRI PRIToView)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx LivePI;
	local UIScene TempScene;
	local UIScene_Confirmation ConScene;

    if ( PRIToView != none )
    {
		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
		if ( OnlineSub != none )
		{
			LivePI = OnlineSub.PlayerInterfaceEx;
			if ( LivePI != none )
			{
				if ( !LivePI.ShowGamerCardUI(ControllerId,PRIToView.UniqueId) )
				{
					SceneClient.OpenScene(ConfirmationScene,,TempScene);
					ConScene = UIScene_Confirmation(TempScene);
					if ( ConScene != none )
					{
						FadeInactive();
						ConScene.SetMessage( "<Strings:TPGame.TPHUD_DM.CantViewGameCard>" );
						ConScene.SimpleMode();
						PlayUISound('Click');
						ConScene.SetVisibility(true);
						ConScene.OnSceneClose = Restore;
					}
				}
			}
		}
	}
	PlayUISound('Error');
	return;
}
*/
function Restore()
{
	fadeIn(false);
}


