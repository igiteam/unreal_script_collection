//=============================================================================
// SASMPPlayerController.uc
//
//=============================================================================
// POSSIBLE SCREWUP....lots of changes by sud....just merged them!
class SASMPPlayerController extends SASPlayerController;

var bool				bRising;
var bool				bDisplayLoser;
var bool				bDisplayWinner;
//var class<WillowWhisp>	PathWhisps[2];
var int					LastTaunt;
//var float				LastWhispTime;

var() int				MultiKillLevel;
var() float				LastKillTime;

//var float				LastTauntAnimTime;

//auronafix what are all these things? are they needed?
//Net Community stats
//var ServerResponseLine ServerState;
struct LevelTime
{
	var int			    Hrs;
	var int				Mins;
	var int				Secs;	
};
var int                 mRoundsPlayedCount;
var int                 mSabreSquadCount;
var int                 mKills;
var int					mKills_InSabreSquad;   
var bool				mbAlive;
var bool				mbGameMode; //0-sabre squad,1=co-op mode
var LevelTime           mLevelTime;
var int                 mHeadShots;
var int					mHeadShotsAccuracy;
var int                 mHeadShots_InSabreSquad;
var int                 mHeadShots_InSabreSquadAccuracy;

replication
{
	// Things the server should send to the client.
	unreliable if ( Role == ROLE_Authority )
//		ClientPlayTakeHit,
		ClientDelayedAnnouncement;

	reliable if ( Role == ROLE_Authority )
		LocalShowScores,
		PlayWinMessage,
		PlayStartupMessage,
		ClientSendStats,
		ClientSendSprees,
		ClientSendMultiKills,
		ClientSendCombos,
		ClientSendWeapon;

	reliable if ( Role < ROLE_Authority )
//		ServerSetTeamName,
//		ServerTaunt,
		ServerChangeLoadout,
//		ServerShowPathToBase,
		ServerUpdateStats,
		ServerUpdateStatArrays,
		ServerGetNextWeaponStats;

	// JS shared between SAS[Coop|DM]PlayerController
	reliable if ( Role < ROLE_Authority )
		ServerAdjustSpeed,
		ServerSetWalkingPerc;

	reliable if ( Role < ROLE_Authority )
		ServerUnStick;

}

/*
exec function SetTeamName ( int aTeamIndex, String aTeamName )
{
	ServerSetTeamName ( aTeamIndex, aTeamName );
}
function ServerSetTeamName ( int aTeamIndex, String aTeamName )
{
	GameReplicationInfo.Teams[aTeamIndex].TeamName = aTeamName;
}
*/

execrelease function ServerChangeSSMap()
{
	// Check we are server and playing a sabre squasd game.
	if ( Level.Game != None && SASSSquadGameInfo( Level.Game ) != None )
	{
		ClientOpenMenu ( "SASGUI.SASServerChangeMapSS", false );
	}
}

// Local stats related functions

function ServerUpdateStats(TeamPlayerReplicationInfo PRI)
{
	ClientSendStats(PRI,PRI.GoalsScored,PRI.bFirstBlood, PRI.scorekills,PRI.suicides,PRI.FlagTouches,PRI.FlagReturns,PRI.FlakCount,PRI.ComboCount,PRI.HeadCount);
}

function ServerUpdateStatArrays(TeamPlayerReplicationInfo PRI)
{
	ClientSendSprees(PRI,PRI.Spree[0],PRI.Spree[1],PRI.Spree[2],PRI.Spree[3],PRI.Spree[4],PRI.Spree[5]);
	ClientSendMultiKills(PRI,PRI.MultiKills[0],PRI.MultiKills[1],PRI.MultiKills[2],PRI.MultiKills[3],PRI.MultiKills[4],PRI.MultiKills[5],PRI.MultiKills[6]);
	ClientSendCombos(PRI,PRI.Combos[0],PRI.Combos[1],PRI.Combos[2],PRI.Combos[3],PRI.Combos[4]);
}

function ServerGetNextWeaponStats(TeamPlayerReplicationInfo PRI, int i)
{
	if ( i >= PRI.WeaponStatsArray.Length )
	{
		return;
	}

	ClientSendWeapon(PRI, PRI.WeaponStatsArray[i].WeaponClass, PRI.WeaponStatsArray[i].kills, PRI.WeaponStatsArray[i].deaths,PRI.WeaponStatsArray[i].deathsholding,i);
}

function ClientSendWeapon(TeamPlayerReplicationInfo PRI, class<Weapon> W, int kills, int deaths, int deathsholding, int i)
{
	PRI.UpdateWeaponStats(PRI,W,Kills,Deaths,DeathsHolding);
	ServerGetNextWeaponStats(PRI,i+1);
}

simulated function ClientSendSprees(TeamPlayerReplicationInfo PRI,byte Spree0,byte Spree1,byte Spree2,byte Spree3,byte Spree4,byte Spree5)
{
	PRI.Spree[0] = Spree0;
	PRI.Spree[1] = Spree1;
	PRI.Spree[2] = Spree2;
	PRI.Spree[3] = Spree3;
	PRI.Spree[4] = Spree4;
	PRI.Spree[5] = Spree5;
}

simulated function ClientSendMultiKills(TeamPlayerReplicationInfo PRI,
								byte MultiKills0, byte MultiKills1, byte MultiKills2, byte MultiKills3, byte MultiKills4, byte MultiKills5, byte MultiKills6)
{
	PRI.MultiKills[0] = MultiKills0;
	PRI.MultiKills[1] = MultiKills1;
	PRI.MultiKills[2] = MultiKills2;
	PRI.MultiKills[3] = MultiKills3;
	PRI.MultiKills[4] = MultiKills4;
	PRI.MultiKills[5] = MultiKills5;
	PRI.MultiKills[6] = MultiKills6;
}

simulated function ClientSendCombos(TeamPlayerReplicationInfo PRI,byte Combos0, byte Combos1, byte Combos2, byte Combos3, byte Combos4)
{
	PRI.Combos[0] = Combos0;
	PRI.Combos[1] = Combos1;
	PRI.Combos[2] = Combos2;
	PRI.Combos[3] = Combos3;
	PRI.Combos[4] = Combos4;

	ServerGetNextWeaponStats(PRI,0);
}

simulated function ClientSendStats(TeamPlayerReplicationInfo PRI, int newgoals, bool bNewFirstBlood, int newkills, int newsuicides, int newFlagTouches, int newFlagReturns, int newFlakCount, int newComboCount, int newHeadCount)
{
	PRI.GoalsScored = newGoals;
	PRI.bFirstBlood = bNewFirstBlood;
	PRI.ScoreKills = NewKills;
	PRI.Suicides = NewSuicides;
	PRI.FlagTouches = NewFlagTouches;
	PRI.FlagReturns = NewFlagReturns;
	PRI.FlakCount = NewFlakCount;
	PRI.ComboCount = NewComboCount;
	PRI.HeadCount = NewHeadCount;

	ServerUpdateStatArrays(PRI);
}

function ClientDelayedAnnouncement(sound AnnouncementSound, byte Delay)
{
/*
	local AnnounceAdrenaline A;

	A = spawn(class'AnnounceAdrenaline', self);
	A.AnnounceSound = AnnouncementSound;
	A.settimer(0.1*delay,false);
*/
}

function LogMultiKills(float Reward, bool bEnemyKill)
{
	if ( bEnemyKill && (Level.TimeSeconds - LastKillTime < 4) )
	{
		MultiKillLevel++;
		if (Level.Game.GameStats!=None)
		{
			Level.Game.GameStats.SpecialEvent(PlayerReplicationInfo,"multikill_"$MultiKillLevel);
		}
	}
	else
	{
		MultiKillLevel=0;
	}

	if ( bEnemyKill )
	{
		LastKillTime = Level.TimeSeconds;
	}
}

exec function ShowAI()
{
	myHUD.ShowDebug();
//	if ( SASPawn(ViewTarget) != None )
//	{
//		SASPawn(ViewTarget).bSoakDebug = myHUD.bShowDebugInfo;
//	}
}

/*
function Possess ( Pawn aPawn )
{
	Log ( @self$ " taken possesion of " @aPawn );

	if ( SASPawn ( aPawn ) != None )
	{
		if ( SASPawn ( aPawn ).Default.VoiceType != "" )
		{
			VoiceType = SASPawn ( aPawn ).Default.VoiceType;
		}
		if ( VoiceType != "" )
        {
			PlayerReplicationInfo.VoiceType = class<VoicePack>( DynamicLoadObject ( VoiceType, class'Class' ) );
        }
	}
	aPawn.Health = 200;
	Super.Possess ( aPawn );
}
*/

function bool AutoTaunt()
{
	return bAutoTaunt;
}

function bool DontReuseTaunt(int T)
{
	if ( T == LastTaunt )
	{
		return true;
	}

	LastTaunt = T;

	return false;
}

/*exec function SoakBots()
{
	local Bot B;

	log("Start Soaking");
	SASMPGameInfo(Level.Game).bSoaking = true;
	ForEach DynamicActors(class'Bot',B)
	{
		B.bSoaking = true;
	}
}
*/

/*function SoakPause(Pawn P)
{
	log("Soak pause by "$P);
	SetViewTarget(P);
	SetPause(true);
	bBehindView = true;
	myHud.bShowDebugInfo = true;
	if ( SASPawn(P) != None )
	{
		SASPawn(P).bSoakDebug = true;
	}
}
*/

/*
exec function BasePath(byte num)
{
	if (PlayerReplicationInfo.Team == None )
	{
		return;
	}
	ServerShowPathToBase(num);
}

function ServerShowPathToBase(int TeamNum)
{
	local GameObjective G, Best;

	if ( (Level.NetMode != NM_Standalone) && (Level.TimeSeconds - LastWhispTime < 0.5) )
	{
		return;
	}
	LastWhispTime = Level.TimeSeconds;

	if ( (Pawn == None) || (TeamGame(Level.Game) == None) || !TeamGame(Level.Game).CanShowPathTo(self,TeamNum) )
	{
		return;
	}

	for ( G=TeamGame(Level.Game).Teams[0].AI.Objectives; G!=None; G=G.NextObjective )
	{
		if ( G.BetterObjectiveThan(Best,TeamNum,PlayerReplicationInfo.Team.TeamIndex) )
		{
			Best = G;
		}
	}
	if ( (Best != None) && (FindPathToward(Best,false) != None) )
	{
		spawn(PathWhisps[TeamNum],self,,Pawn.Location);
	}
}
*/

function byte GetMessageIndex(name PhraseName)
{
	if ( PlayerReplicationInfo.VoiceType == None )
	{
		return 0;
	}
	return PlayerReplicationInfo.Voicetype.Static.GetMessageIndex(PhraseName);
}

/*exec function Taunt( name Sequence )
{
	if ( (SASPawn(Pawn) != None) && (Pawn.Health > 0) && (Level.TimeSeconds - LastTauntAnimTime > 0.3) && SASPawn(Pawn).CheckTauntValid(Sequence) )
	{
		ServerTaunt(Sequence);
        LastTauntAnimTime = Level.TimeSeconds;
	}
}

function ServerTaunt(name AnimName )
{
	if ( (SASPawn(Pawn) != None) && (Pawn.Health > 0) && (Level.TimeSeconds - LastTauntAnimTime > 0.3) && SASPawn(Pawn).CheckTauntValid(AnimName) )
	{
		Pawn.SetAnimAction(AnimName);
        LastTauntAnimTime = Level.TimeSeconds;
	}
}
*/

function PlayStartupMessage(byte StartupStage)
{
	ReceiveLocalizedMessage( class'StartupMessage', StartupStage, PlayerReplicationInfo );
}

exec function CycleLoadout()
{
	if ( SASTeamInfo(PlayerReplicationInfo.Team) != None )
	{
		ServerChangeLoadout(string(SASTeamInfo(PlayerReplicationInfo.Team).NextLoadOut(PawnClass)));
	}
}

exec function ChangeLoadout(string LoadoutName)
{
	ServerChangeLoadout(LoadoutName);
}

function ServerChangeLoadout(string LoadoutName)
{
	SASMPGameInfo(Level.Game).ChangeLoadout(self, LoadoutName);
}
/*
function NotifyTakeHit(pawn InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType)
{
	local int iDam;

	Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,DamageType);

	// FIXME_MERGE if ( (Pawn != None) && (Pawn.ShieldStrength > 0) )
	// FIXME_MERGE 	ClientFlash(0.5,vect(700,700,0));
	// FIXME_MERGE else
	if ( Damage > 1 )
	{
		ClientFlash(DamageType.Default.FlashScale,DamageType.Default.FlashFog);
	}

	ShakeView(0.15 + 0.005 * Damage, Damage * 30, Damage * vect(0,0,0.03), 120000, vect(1,1,1), 0.2);
	iDam = Clamp(Damage,0,250);
	if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
	{
		ClientPlayTakeHit(hitLocation - Pawn.Location, iDam, damageType);
	}
}
function ClientPlayTakeHit(vector HitLoc, byte Damage, class<DamageType> damageType)
{
	HitLoc += Pawn.Location;
	Pawn.PlayTakeHit(HitLoc, Damage, damageType);
}
*/

// TODO: sort out Pawn sometimes == None
function ChangedWeapon ()
{
    if ( Pawn != None )
    {
        Super.ChangedWeapon ();
    }
}

// don't processs death fade in MP
//::function InitDeathFade () {}

simulated function LocalShowScores ()
{
	myHUD.bShowScores = true;
}

function ClientRestart()
{
	local string mapname;
    local SASGameInfo gi;	
		
	if ( myHUD != None )
	{
		myHUD.bHideHUD = false;
		myHUD.bShowScores = false;
	}
	GotoState ( '' );
	
	Super.ClientRestart();		
		
	//Net Community Stats	
	if ( Level.Game != None && Level.Game.Gamestats != None )
	{	
		gi = SASMPGameInfo(Level.Game);
		mapname = Level.Game.Gamestats.Mapname();
		NetCommunityLog("map name :"$mapname,'Net Community Stats');
		gi.StatStringOp("mapname", statOp_set, mapname, statLvl_server, 0);
	}
	mroundsplayedcount++;
		
	NetCommunityLog("no of rounds played :"$mroundsplayedcount,'Net Community Stats');
		
	if ( PlayerReplicationInfo.Team.Teamindex==1)
	{
		msabresquadcount++;
		NetCommunityLog("no of times in sabresquad :"$msabresquadcount,'Net Community Stats');
	}	
	
}

 /*Send a packet to the server every 20secs
   saying the player is playing "$"level..
   Player.Tick()..
 */  
 //Net Community Stats	
 
function SASMPPlayerBroadcastOnlineStatus(float DeltaTime)
{	
    local string mapname;
    local int kills;
    local SASGameInfo		gi;	
	
	mfElapsedTime += DeltaTime;
	
	if( mfElapsedTime >= 20.0 )
	{	
		mfElapsedTime = 0.0;	
		
		if ( Level.Game != None && Level.Game.GameStats!=None)
		{
	
			gi = SASMPGameInfo(Level.Game);
			
			NetCommunityLog("Logging to Server @20secs interval : Player  Online:"$PlayerReplicationInfo.PlayerName,'Net Community Stats');

			if (Level.Game.GameStats != None)
			{
				mapname=Level.Game.GameStats.MapName();
				NetCommunityLog("Logging to Server @20secs interval : Playing Map   :"$mapname,'Net Community Stats');
			}
			
			//kills called for debug, take it off,, while
			//sending it to server..
			kills=GetScoreKills();			
			NetCommunityLog("Logging to Server @20secs interval : Kills         :"$kills,'Net Community Stats');
			
			kills=GetHeadShots();
			NetCommunityLog("Logging to Server @20secs interval : HeadShots     :"$kills,'Net Community Stats');
			
			kills=GetTotalHeadshotsAccuracy();
			NetCommunityLog("Logging to Server @20secs interval : HeadShotsAccuracy :"$kills,'Net Community Stats');
			
			//call SendLogPacket() to server
			//SASMP_GetLevelTime();
			
			gi.StatSnapshot();
			
		}
	}
	
}
//Function with a return type of LevelTime
//which is called when a level is ended
//therefore,used to calulate the
//time spent online.
//Net Community Stats	
//::function LevelTime SASMP_GetLevelTimeElapsed()
//::{	
//::	local int LevelSecs,leftover;
//::	
//::	LevelSecs = Level.Game.GameReplicationInfo.ElapsedTime ; 
//::	
//::	if (LevelSecs < 60.00)
//::	{
//::		mLevelTime.Secs = LevelSecs;
//::		mLevelTime.Mins = 0;
//::		mLevelTime.Hrs  = 0;
//::	}	
//::	else
//::	if (LevelSecs > 60.00)
//::	{
//::		mLevelTime.Hrs  = LevelSecs / 3600;
//::		leftover        = LevelSecs % 3600;
//::		mLevelTime.Mins = leftover / 60;
//::		mLevelTime.Secs = leftover % 60;			
//::	}
//::	NetCommunityLog("LevelEnd ",'Net Community Stats');
//::	NetCommunityLog("Hrs  : "$mLevelTime.Hrs,'Net Community Stats');
//::	NetCommunityLog("Mins : "$mLevelTime.Mins,'Net Community Stats');
//::	NetCommunityLog("Secs : "$mLevelTime.Secs,'Net Community Stats');
//::				
//::	return(mLevelTime);
//::	
//::	//EndTime   = Level.TimeSeconds;
//::	//take this 
//::	//At Client.Restart().
//::	//summation of all levels = TotalTimeOnline...
//::	//Level.Game.GameReplicationInfo.ElapsedTime;
//::}
//get no. of kills for the player
//Net Community Stats	
function int GetScoreKills()
{		
	
	//check if co-op mode
	if(PlayerReplicationInfo.Team.TeamIndex==1)
	{
		mKills = PlayerReplicationInfo.mPlayerKills;
		return(mKills);
	}
	//sabre mode
	else
	{		
		mKills_InSabreSquad = PlayerReplicationInfo.mPlayerKills;   
		return(mKills_InSabreSquad);					
	}	
	
}
//the stupid player dead state 
//in the sasplayercontroller.uc is 
//being called twice -before and
//after a level starts , use 
//GetDeaths() - 1 per level..
//Net Community Stats	
function int GetDeaths()
{
	local int deaths;
	
	mDeaths++;
	deaths = mDeaths;
	NetCommunityLog("Player Died :"$deaths,'Net Community Stats');		
	return(deaths);	
}
//Net Community Stats	
function int GetHeadShots()
{
	local int headshot,headshotinsabre;
		
	//check if co-op mode
	if(PlayerReplicationInfo.Team.TeamIndex==1)
	{
	
		headshot = PlayerReplicationInfo.mPlayerHeadShotKills;
		mHeadShots++;					
		return(headshot);
		
	}
	//sabre mode
	else
	{		
		headshotinsabre = PlayerReplicationInfo.mPlayerHeadShotKills;   
		mHeadShots_InSabreSquad++;     
		return(headshotinsabre);
							
	}	
				
}
//Net Community Stats	
function float GetTotalHeadshotsAccuracy()
{	
	local float accuracy;
	local float kills,headshots;
			
	//check if co-op mode
	if( PlayerReplicationInfo.Team.TeamIndex==1 )
	{		
		kills = GetScoreKills();
		headshots = GetHeadShots();
		accuracy = headshots / kills * 100;
		mHeadShotsAccuracy = accuracy;          
		return(accuracy);		
	}
	
	//sabre mode
	else
	{		
		kills = GetScoreKills();
		headshots = GetHeadShots();
		accuracy = headshots / kills * 100;
		mHeadShots_InSabreSquadAccuracy = accuracy;
		return(accuracy);								
	}	
	
}
//get kills per weapon
//Net Community Stats	
//::function int GetKills_PerWeapon()
//::{
//:://player died callstack shit..
//::	return 0;
//::}
//get Team kills
//Net Community Stats	
//::function int GetTeamKills()
//::{
//::/* 
//:: Get Human player kills
//::*/
//::	return 0;
//::}
//Net Community Stats	
//::function int GetTotalAccuracy()
//::{
//::/*//
//::	Check if (PlayerController! = self AND pawn!=none)
//::	then
//::	check
//::	BulletsFired / BulletsHitEnemy	
//::*/
//::	return 0;
//::}
/////////////////////////////////////////////////////////////////////////
// to avoid overriding playerwaiting and therefore having to duplicate the ignores line...
simulated function PlayerWaitingBeginStateExtra()
{
	// to show who's joining
	if ( myHUD != None )
	{
		myHUD.bHideHUD = false;
		myHUD.bShowScores = true;
	}
}




////////////////////////////////////////////////////
////////////////////////////////////////////////////

////////////////////////////////////////////////////
// JS functions common to DM and Coop PlayerControllers


exec function UnStick()
{
	ServerUnStick();
}

function ServerUnStick()
{
	local PlayerStart P;

	foreach AllActors(class'PlayerStart',P)
	{
		if (P.TeamNumber == PlayerReplicationInfo.Team.TeamIndex)
		{
			Pawn.Setlocation(P.Location);
			Pawn.SetRotation(P.Rotation);
		}
	}
}


function PlayWinMessage(bool bWinner)
{
	local sound Announcement;

	if ( bWinner )
	{
		bDisplayWinner = true;
		//Announcement = Sound(DynamicLoadObject("Announcer.Winner", class'Sound'));
	}
	else
	{
		bDisplayLoser = true;
		//Announcement = Sound(DynamicLoadObject("Announcer.LostMatch", class'Sound'));
	}

	ClientPlaySound(Announcement, true);
}

exec function lognote(string x)
{
	log(x);
}

exec function SetWalkingPerc(float newperc)
{
	ServerSetWalkingPerc(newPerc);
}

exec function AdjustSpeed(float Adjustment)
{
	ServerAdjustSpeed(Adjustment);
}

/*exec function EditSpeed(class <SASPawn> WP, float NewSpeed)
{
	ServerEditSpeed(WP,NewSpeed);
}
*/

exec function ShowSpeeds()
{
	log("#### GroundSpeed: "$Pawn.GroundSpeed);
	log("#### WalkingPct : "$Pawn.WalkingPCT);
}

exec function ListPlayer()
{
	local SASPawn p;

	foreach DynamicActors(class 'SASPawn',p)
	{
		log("#### Found "$P);
	}
}

function ServerSetWalkingPerc(float newPerc)
{
	local SASPawn P;
	foreach DynamicActors(class 'SASPawn',P)
	{
		Log("#### Setting Walking % for "$P$" ("$P.PlayerReplicationInfo.PlayerName$") from: "$P.WalkingPct$" to "$NewPerc);
		P.WalkingPCT = newPerc;
	}
}

function ServerAdjustSpeed(float Adjustment)
{
	local SASPawn P;
	foreach DynamicActors(class 'SASPawn',P)
	{
		Log("#### Adjusting "$P$" ("$P.PlayerReplicationInfo.PlayerName$") speed from: "$P.GroundSpeed$" to "$P.GroundSpeed+Adjustment);
		P.GroundSpeed += Adjustment;
		P.AirSPeed += Adjustment;

	}
}


exec function AdjustLoadOut(int newloadout)
{
	ServerAdjustLoadOut(newLoadOut);
}

function ServerAdjustLoadOut(int newLoadOut)
{
	if (SASPawn(Pawn)!=None)
	{
		SASPawn(Pawn).LoadOut = newLoadOut;
		if (Pawn.Weapon!=None)
		{
			Pawn.Weapon.OwnerEvent('LoadOut');
		}
	}
}

function UpdateMPStats()
{
	local SASMPGameInfo gi;
	local SASPRI pri;
	
	pri = SASPRI( PlayerReplicationInfo );
	gi = SASMPGameInfo(Level.Game);

	gi.StatIntOp("gametype", StatOp_set, gi.mGameTypeId, StatLvl_server, 0);

	if (gi.mGameTypeId == 2) // Coop
	{
		gi.StatIntOp("kills", StatOp_set, pri.mPlayerKills, StatLvl_player, pri.PlayerID);
		gi.StatIntOp("headshots", StatOp_set, pri.mPlayerHeadShotKills, StatLvl_player, pri.PlayerID);
		gi.StatIntOp("deaths", StatOp_set, mDeaths, StatLvl_player, pri.PlayerID);
		gi.StatIntOp("timeincoop", StatOp_add, 1, StatLvl_player, pri.playerID);
	}
	else	// Sabre
	{
		gi.StatIntOp("daggers", StatOp_set, pri.ScoreDaggers, StatLvl_player, pri.PlayerID);
		gi.StatIntOp("kills", StatOp_set, pri.ScoreKills, StatLvl_player, pri.PlayerID);
		gi.StatIntOp("sabresquadcount", statOp_set, msabresquadcount, statLvl_player, pri.PlayerID);
		gi.statIntOp("timeinesabresquad", statOp_add, 1, statLvl_player, pri.PlayerID);
	}
	
	gi.StatIntOp("shots", StatOp_set, pri.mPlayerBulletsFired, StatLvl_player, pri.playerID);
	gi.StatIntOp("shotshit", StatOp_set, pri.mPlayerBulletsHitEnemy, StatLvl_player, pri.playerID);
	gi.StatIntOp("team", StatOp_set, pri.Team.TeamIndex, StatLvl_player, pri.playerID);
	
}


simulated function InitPlayerDeathFade ();
simulated function NavigationPoint FindAbuserSpawnPoint ( Actor aTarget );
simulated function SpawnFadeTerrorist ( NavigationPoint sp );
function Shout ();


state Dead
{
	ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon;

	// don't processs death fade in MP
	simulated function InitPlayerDeathFade () {}
	simulated function FindGoodView () {}
	simulated function NavigationPoint FindAbuserSpawnPoint ( Actor aTarget ) { return None; }
	simulated function SpawnFadeTerrorist ( NavigationPoint sp ) {}
	simulated function PerformDelayedDeathAction () {}
	function Shout () {}

	execrelease function Fire( optional float F )
	{
		/*if ( bFrozen )
		{
			if ( ( TimerRate <= 0.0 ) || ( TimerRate > 1.0 ) )
			{
				bFrozen = false;
			}
			return;
		}*/
		
		ServerSpectate ();
	}


Begin:
    Sleep ( 3.0 );

	if ( (ViewTarget == None) || (ViewTarget == self) || (VSize(ViewTarget.Velocity) < 1.0) )
	{
		Sleep ( 1.0 );

		myHUD.bShowScores = true;
		LocalShowScores ();
	}
	else
	{
		Goto ( 'Begin' );
	}
}












//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    PlayerReplicationInfoClass=Class'TeamPlayerReplicationInfo'
}