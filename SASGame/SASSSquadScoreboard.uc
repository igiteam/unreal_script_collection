//=============================================================================
// SASSSquadScoreBoard.uc
// 
// Scoreboard for sqabre squad game! Uses revolutionary new concept of 
// polymorphism.
//=============================================================================

class SASSSquadScoreboard extends SASMPScoreboard;

struct DemotePromoteDisplayItem
{
	var PlayerReplicationInfo	PRI;
	var int						DisplayTeam;
};
var Array<DemotePromoteDisplayItem>	DP_PRIList;
var bool							mbPRIListSortDone;
var int								OwnerOffset;

// List of reasons for a promote/demote to occur.
enum EPromoteDemoteReason
{
	PDREASON_SwapTeams,
	PDREASON_TeamKill,
	PDREASON_PromotedBalance,
	PDREASON_DemotedBalance,
};

// Struct to store info on player promotion/demotion.
struct SDemotePromote
{
	var EPromoteDemoteReason	Reason;
	var PlayerReplicationInfo	Winner;				// PRI of player to be promoted.
	var PlayerReplicationInfo	Loser;				// PRI of player ot be demoted.
	var int						iPlaceInListWinner;	// Index of promoting player in PRI list.
	var int						iPlaceInListLoser;	// Index of demoting player in PRI list.
	var bool					bStarted;
	var bool					bHasOccured;		// Flag to indicate if the pair swap has occured on the scoreboard yet.
};
var SDemotePromote DemotePromote[MAX_PLAYERS];		// List of promotion/demotions in current round.
var int mNumDemotePromotes;							// Size of DemotePromote list.


var int		mTeamSwapPairCurrent;		// Current DemotePromote pair being swapped on scoreboard.
var float	mTeamSwapBaseTime;			// Time that team swapping start.
var float	mTeamSwapPairStartTime;		// Time that current individual pair start swapping.
var float	mTeamSwapPairTimer;			// Current individual pair swap time.
var bool	mbTeamSwapPairStartTimeSet;	// True if mTeamSwapPairStartTime has been initialized.
var bool	mbTeamSwapBaseTimeSet;		// True if mTeamSwapBaseTime has been initialized.

// State machine which controls how the score board is displayed.
enum eDisplayScoreBoardMode
{
	DS_Normal,			// Nothing happening
	DS_Flash,			// Flashing the players that are changing teams
	DS_Slide,			// Sliding the players that are changing teams
	DS_SlideComplete	// Switching from slide back to normal.
};
var eDisplayScoreBoardMode mDisplayScoreBoardMode;		// Current scoreboard team swapping display mode.

var localized string TeamSwapMessage;
var localized string PromotedMessage;
var localized string DemotedMessage;
var localized string TeamBalancePromotedMessage;
var localized string TeamBalanceDemotedMessage;
var localized string TeamKillDemotedMessage;


simulated function Reset()
{
	Super.Reset();

	mbPRIListSortDone			= false;
	mDisplayScoreBoardMode		= DS_Normal;
	mNumDemotePromotes			= 0;
	mTeamSwapPairCurrent		= 0;
	mbTeamSwapPairStartTimeSet	= false;
	mbTeamSwapBaseTimeSet		= false;
}


simulated event UpdateScoreBoard(
	Canvas	aCanvas )
{
	local bool				bSlideBox;
	local int				i,
							IncludingJoiningPlayerCount, // a list of players in the joining process shown too
							displayTeam;
	local float				EntryYPos,
							TextWidth, 
							TextHeight,
							DemotePromoteSlideAlpha,
							displayAlpha;
	local string			DemotePromoteMessage;
	local SDemotePromote	DemotePromoteCurrent;

	// When game is in progress we don't want to show team swapping - show the 
	// general MP scoreboard instead.
	if ( !PlayerController( Owner ).IsInState( 'GameEnded' ) )
	{
		Super.UpdateScoreBoard( aCanvas );
		return;
	}

	// We sort the PRI list the first time we come into the demote/promote scoreboard each round.
	if ( !mbPRIListSortDone )
	{
		SortPRIList();
		mbPRIListSortDone = true;
	}

	// Update the list of promotions and demotions - they will get added to the list as 
	// the data is received from the server.
	UpdateDemotePromoteList();

	// Update which promote/demote pair to animate and stage of animation.
	UpdateDemotePromoteAnimationPair();

	DemotePromoteCurrent = DemotePromote[mTeamSwapPairCurrent];
	DemotePromoteSlideAlpha = mTeamSwapPairTimer - mTeamSwapPairStartTime;
	
	IncludingJoiningPlayerCount = DP_PRIList.Length;
	if ( Level.Game != None )
	{	
		IncludingJoiningPlayerCount += Level.Game.JoiningPlayers.Length;
	}

	// Init scoreboard layout (font scaling/text offset positions etc). Depends on size of PRI list.
	SetupScoreBoardLayoutData(
		aCanvas,
		IncludingJoiningPlayerCount,
		OwnerOffset );

	// Draw background vignette.
	//DrawBackground( aCanvas );
	
	// draw background boxes
	
	aCanvas.Style = ERenderStyle.STY_Alpha;

	for ( i = 0; i< mDisplayedPlayerCount; i++ )
	{
		bSlideBox = false;

		if ( mDisplayScoreBoardMode == DS_Slide && !DemotePromoteCurrent.bHasOccured )
		{
			// Is this the moving demoted player?
			if (	(DemotePromoteCurrent.iPlaceInListWinner == i) && 
					(DemotePromoteCurrent.iPlaceInListLoser >= 0) )
			{
				bSlideBox = true;
				aCanvas.SetPos(
					mPlayerBoxXPos, 
					(	mPlayerBoxOffsetY + 
						(mPlayerBoxHeight + mPlayerBoxSpacing) * i - 
						(i - DemotePromoteCurrent.iPlaceInListLoser) * (mPlayerBoxHeight + mPlayerBoxSpacing) * ((DemotePromoteSlideAlpha - 2)/2) ) );
			}
			// Is this the moving promoted player?
			else if (	(DemotePromoteCurrent.iPlaceInListLoser == i) &&
						(DemotePromoteCurrent.iPlaceInListWinner >= 0) )
			{
				bSlideBox = true;
				aCanvas.SetPos( 
						mPlayerBoxXPos, 
						(	mPlayerBoxOffsetY +
							(mPlayerBoxHeight + mPlayerBoxSpacing) * i - 
							(i - DemotePromoteCurrent.iPlaceInListWinner)* (mPlayerBoxHeight + mPlayerBoxSpacing) * ((DemotePromoteSlideAlpha - 2)/2) ) );
			}
		}
		
		// Normal (non moving) entry.
		if ( !bSlideBox )
		{
			aCanvas.SetPos( mPlayerBoxXPos, mPlayerBoxOffsetY + ((mPlayerBoxHeight + mPlayerBoxSpacing) * i) );
		}

		aCanvas.DrawTileStretched( BoxMaterial, mPlayerBoxWidth, mPlayerBoxHeight );
	}
				
	// Draw title
	DrawTitle( aCanvas );
	
	// Set default font size.
	aCanvas.Font = mEntryFont;

	// Draw headers
	DrawHeaders( aCanvas );
	
	// Get the current promotion/demotion message type if any.
	if ( mDisplayScoreBoardMode == DS_Flash || mDisplayScoreBoardMode == DS_Slide )
	{
		switch( DemotePromoteCurrent.Reason )
		{
		case PDREASON_SwapTeams:
			if ( DemotePromoteCurrent.Winner != None )
			{
				if ( DemotePromoteCurrent.Loser != None )
				{
					DemotePromoteMessage = DemotePromoteCurrent.Winner.PlayerName@TeamSwapMessage@DemotePromoteCurrent.Loser.PlayerName;
				}
				else
				{
					DemotePromoteMessage = DemotePromoteCurrent.Winner.PlayerName@PromotedMessage;
				}
			}
			else if ( DemotePromoteCurrent.Loser != None )
			{
				DemotePromoteMessage = DemotePromoteCurrent.Loser.PlayerName@DemotedMessage;
			}
			break;

		case PDREASON_TeamKill:	
			if ( DemotePromoteCurrent.Loser != None )
			{
				DemotePromoteMessage = DemotePromoteCurrent.Loser.PlayerName@TeamKillDemotedMessage;
			}
			break;

		case PDREASON_PromotedBalance:
			if ( DemotePromoteCurrent.Winner != None )
			{
				DemotePromoteMessage = DemotePromoteCurrent.Winner.PlayerName@TeamBalancePromotedMessage;
			}
			break;

		case PDREASON_DemotedBalance:
			if ( DemotePromoteCurrent.Loser != None )
			{
				DemotePromoteMessage = DemotePromoteCurrent.Loser.PlayerName@TeamBalanceDemotedMessage;
			}
			break;

		default:
			DemotePromoteMessage = "";
		}

		// Draw Promote/Demote message if set.
		if ( DemotePromoteMessage != "" )
		{
			if ( aCanvas.ClipX <= 800 )
			{
				aCanvas.Font = aCanvas.TinyFont;
			}
			else
			{
				aCanvas.Font = aCanvas.SmallFont;
			}

			aCanvas.StrLen( DemotePromoteMessage, TextWidth, TextHeight );
			//aCanvas.SetPos( 0.75 * aCanvas.ClipX - TextWidth - 4, aCanvas.ClipY - (TextHeight*0.5) );
			aCanvas.DrawColor = PlayerController(Owner).myHUD.OrangeColour;
			aCanvas.DrawColor.A = DemotePromoteSlideAlpha*180;
			aCanvas.CentreText( DemotePromoteMessage, 0.5 * aCanvas.ClipX, aCanvas.ClipY - TextHeight );
		}
	}

	// Draw the box text for each joined player.
	aCanvas.Style = ERenderStyle.STY_Normal;
	for ( i = 0; i < DP_PRIList.Length; i++ )
	{
		// Find the entry's Y position.

		bSlideBox = false;

		if ( mDisplayScoreBoardMode == DS_Slide && !DemotePromoteCurrent.bHasOccured )
		{
			// Is this the moving demoted player?
			if (	(DemotePromoteCurrent.iPlaceInListWinner == i) && 
					(DemotePromoteCurrent.iPlaceInListLoser >= 0) )
			{
				bSlideBox = true;
				EntryYPos = ((mPlayerBoxHeight + mPlayerBoxSpacing) * i) - 
						(i - DemotePromoteCurrent.iPlaceInListLoser) * (mPlayerBoxHeight + mPlayerBoxSpacing) * ((DemotePromoteSlideAlpha - 2) / 2) + mPlayerBoxTextOffsetY;
			}
			// Is it a promoted player?
			else if (	(DemotePromoteCurrent.iPlaceInListLoser == i) &&
						(DemotePromoteCurrent.iPlaceInListWinner >= 0) )
			{
				bSlideBox = true;
				EntryYPos = ((mPlayerBoxHeight + mPlayerBoxSpacing) * i) - 
							(i - DemotePromoteCurrent.iPlaceInListWinner) * (mPlayerBoxHeight + mPlayerBoxSpacing) * ((DemotePromoteSlideAlpha - 2) / 2) + mPlayerBoxTextOffsetY;
			}
		}
		
		// A normal entry.
		if ( !bSlideBox )
		{
			EntryYPos = mPlayerBoxTextOffsetY + (mPlayerBoxHeight + mPlayerBoxSpacing) * i;
		}

		// Set the entry draw colour.

		displayTeam = DP_PRIList[i].DisplayTeam;
		displayAlpha = 255.0f;
	
		// If the entry is part of a demote/promote but has not yet flashed/moved then use team colour.
		if(		(DemotePromoteCurrent.iPlaceInListWinner == i || DemotePromoteCurrent.iPlaceInListLoser == i) && 
				mDisplayScoreBoardMode == DS_Flash )
		{
			// Only change the colour if this is a real promote/demote i.e. we are not just an item 
			// that is moving to make room for a single PRI promote/demote.
			if (	DP_PRIList[i].PRI != None &&
					(DP_PRIList[i].PRI == DemotePromoteCurrent.Winner || DP_PRIList[i].PRI == DemotePromoteCurrent.Loser) )
			{
				if ( DemotePromoteSlideAlpha < 1 )
				{
					displayAlpha = 255.0 * (1.0 - DemotePromoteSlideAlpha);
				}
				else
				{
					displayTeam = 1-DP_PRIList[i].DisplayTeam;
					displayAlpha = 255.0 * (DemotePromoteSlideAlpha - 1.0);
				}
				displayAlpha = FMax( displayAlpha, 0.01 );
			}
		}

		// Draw it.
		DrawPlayerEntry( 
			aCanvas, 
			EntryYPos,
			DP_PRIList[i].PRI,
			displayTeam,
			displayAlpha );	
	}
	
	// Draw the box text for each joining player.
	for ( i = DP_PRIList.Length; i < mDisplayedPlayerCount; i++ )
	{
		// Set the text Y pos for this line.
		EntryYPos = ((mPlayerBoxHeight + mPlayerBoxSpacing) * i) + mPlayerBoxTextOffsetY;

		// Draw it.
		DrawJoiningPlayerEntry(
			aCanvas,
			EntryYPos,
			(i - mDisplayedPlayerCount) );
	}	
}



// Sort the game's PRI list - SAS first, terrorists second.
// And in daggers score list within these 2 categories.
function SortPRIList()
{
	local int					k,
								i,
								thisTeam;
	local PlayerReplicationInfo	PRI,
								OwnerPRI;
	local DemotePromoteDisplayItem	item;

	OwnerPRI = PlayerController(Owner).PlayerReplicationInfo;
	k = 0;
	DP_PRIList.Length = 0;

	for ( thisTeam = 0; thisTeam < 2; thisTeam++ )
	{
		for ( i = 0; i < GRI.PRIArray.Length; i++ )
		{
			PRI = GRI.PRIArray[i];
			
			if (PRI == None)
				continue;
				
			if ( PRI.Team.TeamIndex == thisTeam )
			{
				if ( !PRI.bBot )
				{
					if ( PRI == OwnerPRI )
					{
						OwnerOffset = k;
					}
					item.PRI = PRI;
					item.DisplayTeam = PRI.Team.TeamIndex;
					DP_PRIList[k] = item;
					k++;
				}
			}
		}
	}
}	

simulated function UpdateDemotePromoteList()
{
	local bool				bAdded;
	local int				i,
							k;
	local SASPRI			PRI;

	// Go thru the PRI list.
	for ( i = 0; i < DP_PRIList.Length; i++ )
	{
		PRI = SASPRI( DP_PRIList[i].PRI );
		if( PRI == None || PRI.mSSquadPromoteDemoteStatus == PDSTATUS_None )
		{
			continue;
		}

		// Ok, we have a PRI with a team swap status - check if it has already been added to the list.
		// GP: Problem here is that it's possible to have more than 1 demote/rpomte for a single PRI
		// e.g. if one gets promoted for killing SAS then demoted for team balancing. Will only get one 
		// of each type per round so only stop them getting through if types are same.
		bAdded = false;
		for ( k = 0; k < mNumDemotePromotes; ++k )
		{
			if ( PRI == DemotePromote[k].Winner || PRI == DemotePromote[k].Loser )
			{
				switch( DemotePromote[k].Reason )
				{
				case PDREASON_SwapTeams:
					if (	PRI.mSSquadPromoteDemoteStatus == PDSTATUS_PromotedKiller ||
							PRI.mSSquadPromoteDemoteStatus == PDSTATUS_DemotedKilled )
					{
						bAdded = true;
					}
					break;

				case PDREASON_TeamKill:
					if ( PRI.mSSquadPromoteDemoteStatus == PDSTATUS_DemotedTeamKiller )
					{
						bAdded = true;
					}
					break;

				case PDREASON_PromotedBalance:
					if ( PRI.mSSquadPromoteDemoteStatus == PDSTATUS_PromotedBalance )
					{
						bAdded = true;
					}
					break;

				case PDREASON_DemotedBalance:
					if ( PRI.mSSquadPromoteDemoteStatus == PDSTATUS_DemotedBalance )
					{
						bAdded = true;
					}
					break;
				}
			}
		}
		if ( bAdded )
		{
			continue;
		}

		// It's a new item to add...

		switch( PRI.mSSquadPromoteDemoteStatus )
		{
		case PDSTATUS_None:
			break;

		// This is an SAS PRI that is part of a normal demote/promote pair?
		case PDSTATUS_PromotedKiller:
			
			DemotePromote[mNumDemotePromotes].Reason = PDREASON_SwapTeams;
			DemotePromote[mNumDemotePromotes].Winner = PRI;
			DemotePromote[mNumDemotePromotes].Loser = PRI.mSSquadPromoteDemoteOtherPRI;
			DemotePromote[mNumDemotePromotes].bHasOccured = false;
			mNumDemotePromotes++;
			break;

		case PDSTATUS_DemotedKilled:
			
			DemotePromote[mNumDemotePromotes].Reason = PDREASON_SwapTeams;
			DemotePromote[mNumDemotePromotes].Loser = PRI;
			DemotePromote[mNumDemotePromotes].Winner = PRI.mSSquadPromoteDemoteOtherPRI;
			DemotePromote[mNumDemotePromotes].bHasOccured = false;
			mNumDemotePromotes++;
			break;

		case PDSTATUS_DemotedTeamKiller:
			
			DemotePromote[mNumDemotePromotes].Reason = PDREASON_TeamKill;
			DemotePromote[mNumDemotePromotes].Loser = PRI;
			DemotePromote[mNumDemotePromotes].Winner = None;
			DemotePromote[mNumDemotePromotes].bHasOccured = false;
			mNumDemotePromotes++;
			break;

		// A PRI that is promoted to balance teams.
		case PDSTATUS_PromotedBalance:
			
			DemotePromote[mNumDemotePromotes].Reason = PDREASON_PromotedBalance;
			DemotePromote[mNumDemotePromotes].Winner = PRI;
			DemotePromote[mNumDemotePromotes].Loser = None;
			DemotePromote[mNumDemotePromotes].bHasOccured = false;
			mNumDemotePromotes++;
			break;

		// A PRI that is demoted to balance teams.
		case PDSTATUS_DemotedBalance:

			DemotePromote[mNumDemotePromotes].Reason = PDREASON_DemotedBalance;
			DemotePromote[mNumDemotePromotes].Loser = PRI;
			DemotePromote[mNumDemotePromotes].Winner = None;
			DemotePromote[mNumDemotePromotes].bHasOccured = false;
			mNumDemotePromotes++;
			break;
		}
	}
}


function UpdateDemotePromoteAnimationPair()
{
	local int					i;
	local DemotePromoteDisplayItem Temp;
	
	if ( mTeamSwapPairCurrent < mNumDemotePromotes  && !DemotePromote[mTeamSwapPairCurrent].bHasOccured )
	{
		if ( !DemotePromote[mTeamSwapPairCurrent].bStarted )
		{
			mDisplayScoreBoardMode = DS_Flash;

			DemotePromote[mTeamSwapPairCurrent].iPlaceInListWinner = -1;
			DemotePromote[mTeamSwapPairCurrent].iPlaceInListLoser = -1;

			// Find indices of 2 entries to swap.
			for ( i = 0; i < DP_PRIList.Length; i++ )
			{
				if ( DP_PRIList[i].PRI == None )
				{
					continue;
				}

				if ( DemotePromote[mTeamSwapPairCurrent].Winner == DP_PRIList[i].PRI )
				{
					DemotePromote[mTeamSwapPairCurrent].iPlaceInListWinner = i;						
				}
				if ( DemotePromote[mTeamSwapPairCurrent].Loser == DP_PRIList[i].PRI )
				{
					DemotePromote[mTeamSwapPairCurrent].iPlaceInListLoser = i;
				}

				if (	DemotePromote[mTeamSwapPairCurrent].iPlaceInListWinner >= 0 &&
						DemotePromote[mTeamSwapPairCurrent].iPlaceInListLoser >= 0 )
				{
					break;
				}
			}

			// If it's a promoted terrorist without a SAS to swap with, swap with the highest listed terrorist.
			if (	DemotePromote[mTeamSwapPairCurrent].iPlaceInListWinner >= 0 &&
					DemotePromote[mTeamSwapPairCurrent].iPlaceInListLoser == -1 )
			{
				// Find the highest listed terrorist (could be self).
				for ( i = 0; i < DP_PRIList.Length; ++i)
				{
					if ( DP_PRIList[i].DisplayTeam == 1 )
					{
						DemotePromote[mTeamSwapPairCurrent].iPlaceInListLoser = i;
						break;
					}
				}
			}
			// If it's a demoted SAS without a terorist to swap with, swap with the lowest listed SAS.
			else if (	DemotePromote[mTeamSwapPairCurrent].iPlaceInListLoser >= 0 &&
						DemotePromote[mTeamSwapPairCurrent].iPlaceInListWinner == -1 )
			{
				// Find the lowest listed SAS (could be self).
				for ( i = DP_PRIList.Length-1; i >= 0; --i)
				{
					if ( DP_PRIList[i].DisplayTeam == 0 )
					{
						DemotePromote[mTeamSwapPairCurrent].iPlaceInListWinner = i;
						break;
					}
				}
			}
		}

		// Set initial time for this pair swap. 
		if( !mbTeamSwapPairStartTimeSet )
		{
			mTeamSwapPairStartTime = Level.TimeSeconds;
			mbTeamSwapPairStartTimeSet = true;
		}

		// If not set, set the time that swapping all pairs started.
		if( !mbTeamSwapBaseTimeSet )
		{
			mTeamSwapBaseTime = Level.TimeSeconds;
			mbTeamSwapBaseTimeSet = true;
		}
		
		mTeamSwapPairTimer = Level.TimeSeconds;

		// If swap time > 2, then finished flash - move to slide.
		if ( (mTeamSwapPairTimer - mTeamSwapPairStartTime) > 2.0)
		{
			if ( mDisplayScoreBoardMode == DS_Flash )
			{
				// When moving from flash to slide phase we swap the displayed team of the entries.
				for ( i = 0; i < DP_PRIList.Length; i++ )
				{
					if ( DP_PRIList[i].PRI == None )
					{
						continue;
					}

					if ( DemotePromote[mTeamSwapPairCurrent].Winner == DP_PRIList[i].PRI )
					{
						DP_PRIList[i].DisplayTeam = 0;						
					}
					else if ( DemotePromote[mTeamSwapPairCurrent].Loser == DP_PRIList[i].PRI )
					{
						DP_PRIList[i].DisplayTeam = 1;
					}
				}
			}

			mDisplayScoreBoardMode = DS_Slide;
		}
		// If swap time > 4, then finished swap.
		if ( (mTeamSwapPairTimer - mTeamSwapPairStartTime) > 4.0)
		{
			mDisplayScoreBoardMode = DS_SlideComplete;
		}

		// Has swap completed?			
		if ( mDisplayScoreBoardMode == DS_SlideComplete )
		{
			// Set back to normal display (not swapping).
			mDisplayScoreBoardMode		= DS_Normal;
			mbTeamSwapPairStartTimeSet	= false;
			mTeamSwapPairTimer			= 0.0;

			// Swap the 2 entries in the list.
			if (	DemotePromote[mTeamSwapPairCurrent].iPlaceInListWinner >= 0 && 
					DemotePromote[mTeamSwapPairCurrent].iPlaceInListLoser >= 0 )
			{			
				Temp = DP_PRIList[DemotePromote[mTeamSwapPairCurrent].iPlaceInListWinner];
				DP_PRIList[DemotePromote[mTeamSwapPairCurrent].iPlaceInListWinner] = 
					DP_PRIList[DemotePromote[mTeamSwapPairCurrent].iPlaceInListLoser];	
				DP_PRIList[DemotePromote[mTeamSwapPairCurrent].iPlaceInListLoser] = Temp;		
			}

			// Flag that swap has been done.
			DemotePromote[mTeamSwapPairCurrent].bHasOccured = true;	

			// Update the pair to be swapped.
			mTeamSwapPairCurrent++;
		}
	}
}


simulated function SetupScoreboardLayoutXDimensions( Canvas aCanvas )
{
	mPlayerBoxWidth		= 0.9375 * aCanvas.ClipX;
	mPlayerBoxXPos		= 0.5 * (aCanvas.ClipX - mPlayerBoxWidth);
	mPlayerBoxWidth		= aCanvas.ClipX - 2 * mPlayerBoxXPos;
	
	// Column X positions.
	mPlayerNameXPos		= mPlayerBoxXPos + 0.0625 * mPlayerBoxWidth;
	mTeamNameXPos		= mPlayerBoxXPos + 0.28 * mPlayerBoxWidth;
	mDaggersScoreXPos	= mPlayerBoxXPos + 0.5 * mPlayerBoxWidth;
	mKillsScoreXPos		= mPlayerBoxXPos + 0.6875 * mPlayerBoxWidth;
	mNetInfoXPos		= mPlayerBoxXPos + 0.8125 * mPlayerBoxWidth;
}


simulated function DrawHeaders(
	Canvas	aCanvas )
{
	local float	TextWidth,
				TextHeight;


	aCanvas.DrawColor = LightGreyColour;
	
	// Player name header.
	aCanvas.SetPos( mPlayerNameXPos, mHeaderOffsetY );
	aCanvas.DrawText( PlayerHeaderText, true );

	// Team name header.
	aCanvas.SetPos( mTeamNameXPos, mHeaderOffsetY );
	aCanvas.DrawText( TeamHeaderText, true );

	// Daggers score header.
	aCanvas.SetPos( mDaggersScoreXPos, mHeaderOffsetY );
	aCanvas.DrawText( DaggersHeaderText, true);

	// Kills score header.
	aCanvas.SetPos( mKillsScoreXPos, mHeaderOffsetY );
	aCanvas.DrawText( KillsHeaderText, true );

	// Draw net info header if is really an MP game.
	if ( Level.NetMode != NM_Standalone )
	{
		aCanvas.StrLen( StatusText, TextWidth, TextHeight );
		aCanvas.SetPos( mNetInfoXPos, mHeaderOffsetY );
		aCanvas.DrawText( StatusText, true );
	}
}


simulated function DrawPlayerEntry(
	Canvas					aCanvas,
	float					aTextYPos,
	PlayerReplicationInfo	aEntryPRI,
	int						aTeam,
	optional float			aTeamDisplayAlpha )
{
	local String	columnText;
	local float		TextWidth,
					TextHeight;

	if ( aEntryPRI == None )
	{
		return;
	}

	if ( aTeamDisplayAlpha == 0.0 )
	{
		aTeamDisplayAlpha = 255.0;
	}

	if ( aEntryPRI == None )
	{
		return;
	}

	// Clamp player name if it overruns.
	columnText = aEntryPRI.PlayerName;
	aCanvas.StrLen( columnText, TextWidth, TextHeight );
	if ( TextWidth > 0.9 * (mTeamNameXPos - mPlayerNameXPos) )
	{
		columnText = left(columnText, 0.9 * (mTeamNameXPos - mPlayerNameXPos) / TextWidth * len(columnText));
	}
	
	// Player name.
	aCanvas.DrawColor = PlayerController(Owner).myHUD.OrangeColour;
	aCanvas.SetPos( mPlayerNameXPos, aTextYPos );
	aCanvas.DrawText( columnText, true );

	if ( !aEntryPRI.bLatecomer )
	{
		// Team uses team colour.
		aCanvas.DrawColor = GRI.Teams[aTeam].TeamColor;
		// Alpha out if required.
		aCanvas.DrawColor.A = aTeamDisplayAlpha;

		columnText = GRI.Teams[aTeam].TeamName;
	}
	else
	{
		columnText = "-";
	}
	aCanvas.SetPos( mTeamNameXPos, aTextYPos );
	aCanvas.DrawText( columnText, true );

	// Everything else on the line uses orange colour.
	aCanvas.DrawColor = PlayerController(Owner).myHUD.OrangeColour;

	// Draw daggers score.
	if ( aEntryPRI.bLatecomer )
	{
		columnText = "-";
	}	
	else
	{
		columnText = string(aEntryPRI.ScoreDaggers);
	}
	aCanvas.SetPos( mDaggersScoreXPos, aTextYPos );
	aCanvas.DrawText( columnText,true );

	// Draw kills score.
	if ( aEntryPRI.bLatecomer )
	{
		columnText = "-";
	}	
	else
	{
		columnText = CalcKillsScoreData( aEntryPRI );
	}
	aCanvas.SetPos( mKillsScoreXPos, aTextYPos );
	aCanvas.DrawText( columnText, true );

	DrawStatus( aCanvas, aTextYPos, aEntryPRI );
}


function DrawJoiningPlayerEntry(
	Canvas	aCanvas,
	float	aTextYPos,
	int		aJoiningPlayerIdx )
{
	local String	columnText;
	local float		TextWidth,
					TextHeight;

	aCanvas.DrawColor = LightGreyColour;

	// Clamp player name if it overruns.
	columnText = Level.Game.JoiningPlayers[aJoiningPlayerIdx].Name;
	aCanvas.StrLen( columnText, TextWidth, TextHeight );
	if ( TextWidth > 0.9 * (mTeamNameXPos - mPlayerNameXPos) )
	{
		columnText = left(columnText, 0.9 * (mTeamNameXPos - mPlayerNameXPos) / TextWidth * len(columnText));
	}

	aCanvas.SetPos( mPlayerNameXPos, aTextYPos );
	aCanvas.DrawText( columnText, true );

	// Draw team
	aCanvas.SetPos( mTeamNameXPos, aTextYPos );
	aCanvas.DrawText( "-", true );

	// Draw daggers score.
	aCanvas.SetPos( mDaggersScoreXPos, aTextYPos );
	aCanvas.DrawText( "-",true );

	// Draw kills score.
	aCanvas.SetPos( mKillsScoreXPos, aTextYPos );
	aCanvas.DrawText( "-", true );

	// Draw status
	aCanvas.SetPos( mNetInfoXPos, aTextYPos );
	aCanvas.DrawText( PlayerJoiningText, true );
}



// Decompiled with UE Explorer.
defaultproperties
{
    TeamSwapMessage="swapped teams with"
    PromotedMessage="was promoted"
    DemotedMessage="was demoted"
    TeamBalancePromotedMessage="was promoted to balance teams"
    TeamBalanceDemotedMessage="was demoted to balance teams"
    TeamKillDemotedMessage="was demoted for team kill"
}