
class TPPlayerReplicationInfo extends PlayerReplicationInfo
	config(Game)
	dependsOn(TPPlayerController)
	native;

//***********************************************************************
// Struct Declarations
//***********************************************************************

//***********************************************************************
// Variable Declarations
//***********************************************************************
/** Squad name to assign this player to **/
var Name SquadNameAssignment;

var databinding int		MultiKillLevel;
var float				LastKillTime;
var const float			MultiKillTimeout;

var bool bHostChangingGameSettings;
var bool bHostIsReady;
var bool bMapSwitchInEffect;
var string HostURL;
var TCharacterInfo		CharacterInfo;
var Texture				AlliedImage;
var Texture				AxisImage;

// These three variables aren't replicated.
// Rather, the server tracks this, and at the end of the round notifies
// the client what their stats are.
var int					KillsThisRound;
var int					BulletsFiredThisRound;
var int					BulletsHitThisRound;

var bool				GameWinner;

replication
{
	// Things the server should send to the client.
	if ( bNetDirty && (Role == Role_Authority) )
		bHostChangingGameSettings, bMapSwitchInEffect;
}
//***********************************************************************
// CPP Text
//***********************************************************************

//***********************************************************************
// Native Function Declarations
//***********************************************************************

//***********************************************************************
// Functions/States
//***********************************************************************
simulated event ReplicatedEvent(name VarName)
{
	local PlayerController PC;

	if ( VarName == 'PlayerName' )
	{
		// If the new name doesn't match what the local player thinks it should be,
		// then reupdate the name forcing it to be the unique profile name
		if (IsInvalidName())
		{
			return;
		}

		if ( WorldInfo.TimeSeconds < 2 )
		{
			bHasBeenWelcomed = true;
			OldName = PlayerName;
			return;
		}

		// new player or name change
		if ( bHasBeenWelcomed )
		{
			if( ShouldBroadCastWelcomeMessage() && PlayerName != "@$%*Player")
			{
				ForEach LocalPlayerControllers(class'PlayerController', PC)
				{
					PC.ReceiveLocalizedMessage( GameMessageClass, 1, self );
				}
			}
		}
		else
		{
			bHasBeenWelcomed = true;
		}
		OldName = PlayerName;
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

function CopyProperties(PlayerReplicationInfo PRI)
{
	local TPPlayerReplicationInfo TPPRI;

	super.CopyProperties(PRI);

	TPPRI = TPPlayerReplicationInfo(PRI);

	if (TPPRI != none)
	{
		TPPRI.CharacterInfo = CharacterInfo;
		TPPRI.HostURL = HostURL;
	}
}
reliable server function MenuTeamChange(int NewTeam)
{
	WorldInfo.Game.ChangeTeam( PlayerController(Owner), NewTeam, false);
	//SPARK OCT CODEDROP
	//NetUpdateTime = WorldInfo.TimeSeconds - 1.0;
}

reliable server function MenuChangeClass(int Modification)
{
	//WarGame( WorldInfo.Game ).MenuChangePawnClass( self, Modification);
	//SPARK OCT CODEDROP
	//NetUpdateTime = WorldInfo.TimeSeconds - 1.0;
}

reliable server function MenuSetReady(bool bIsReadyToPlay)
{
	bReadyToPlay = bIsReadyToPlay;
	//SPARK OCT CODEDROP
	//NetUpdateTime = WorldInfo.TimeSeconds - 1.0;
}

reliable server function HostIsReady()
{
	bHostIsReady = true;
	//SPARK OCT CODEDROP
	//NetUpdateTime = WorldInfo.TimeSeconds - 1.0f;
}

reliable server function SetHostChangingGameSettings(bool bIsChanging)
{
	bHostChangingGameSettings = bIsChanging;
	//SPARK OCT CODEDROP
	//NetUpdateTime = WorldInfo.TimeSeconds - 1.0f;
}

reliable server function SetHostMapSwitchInEffect(bool bIsChanging)
{
	bMapSwitchInEffect = bIsChanging;
}

reliable server function SetHostURL(string URL)
{
	HostURL = URL;
}
/* Reset()
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();
	GameWinner = false;
	bHostIsReady = false;
}

function LogMultiKills(bool bEnemyKill)
{
	if ( bEnemyKill && (WorldInfo.TimeSeconds - LastKillTime < MultiKillTimeout) )
	{
		MultiKillLevel++;
	}
	else
		MultiKillLevel=0;

	if ( bEnemyKill )
		LastKillTime = WorldInfo.TimeSeconds;
}

function IncrementKillsThisRound()
{
	KillsThisRound++;
	//`log("KillsThisRound is"@KillsThisRound);
}

function IncrementBulletsFiredThisRound()
{
	BulletsFiredThisRound++;
	//`log("BulletsFiredThisRound is"@BulletsFiredThisRound);
}

function IncrementBulletsHitThisRound()
{
	BulletsHitThisRound++;
	//`log("BulletsHitThisRound is"@BulletsHitThisRound);
}

function SetGameWinner()
{
	GameWinner = true;
}

function ResetThisRoundStats()
{
	KillsThisRound = 0;
	BulletsFiredThisRound = 0;
	BulletsHitThisRound = 0;
}

/**
 * Validates that the new name matches the profile if the player is logged in
 *
 * @return TRUE if the name doesn't match, FALSE otherwise
 */
simulated function bool IsInvalidName()
{
	local LocalPlayer LocPlayer;
	local PlayerController PC;
	local TPPlayerController TPC;
	local string ProfileName;
	local OnlineSubsystem OnlineSub;
	local OnlineGameSettings GameSettings;
	local bool bLanMatch;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PC = PlayerController(Owner);
		if (PC != None)
		{
			LocPlayer = LocalPlayer(PC.Player);
			if (LocPlayer != None &&
				OnlineSub.GameInterface != None &&
				OnlineSub.PlayerInterface != None)
			{
				// Check to see if they are logged in locally or not
				if (OnlineSub.PlayerInterface.GetLoginStatus(LocPlayer.ControllerId) == LS_LoggedIn)
				{
					GameSettings = OnlineSub.GameInterface.GetGameSettings();
					if (GameSettings != none)
						bLanMatch = GameSettings.bIsLanMatch;

					if (WorldInfo.IsConsoleBuild(CONSOLE_Xbox360))
					{
						// Ignore what ever was specified and use the profile's nick
						ProfileName = OnlineSub.PlayerInterface.GetPlayerNickname(LocPlayer.ControllerId);
						if (ProfileName != PlayerName)
						{
							// Force an update to the proper name
							PC.SetName(ProfileName);
							return true;
						}
					}
					else
					{
						TPC = TPPlayerController(PC);
						if (bLanMatch)
						{
							ProfileName = TPC.ProfileSettings.GetLocalAccountName();
							if (ProfileName != PlayerName)
							{
								// Force an update to the proper name
								PC.SetName(ProfileName);
								return true;
							}
						}
						else
						{
							// Ignore what ever was specified and use the profile's nick
							ProfileName = OnlineSub.PlayerInterface.GetPlayerNickname(LocPlayer.ControllerId);
							if (ProfileName != PlayerName)
							{
								// Force an update to the proper name
								PC.SetName(ProfileName);
								return true;
							}
						}
					}
				}
			}
		}
	}
	return false;
}

//-----------------------------------------------------------------------
// Function:	 
// Description:	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
// State:	 
// Description:	
//-----------------------------------------------------------------------



//***********************************************************************
// Default Properties
//***********************************************************************
