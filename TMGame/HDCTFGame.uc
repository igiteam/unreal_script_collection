//-----------------------------------------------------------
// HD?????
//-----------------------------------------------------------
class HDCTFGame extends HDTeamGame;

var array<HDFlag> HDFlags;

function PostBeginPlay()
{
	local HDFlag FlagActor;

	Super.PostBeginPlay();

	//register
	foreach DynamicActors(class'HDFlag', FlagActor)
	{
		HDFlags.AddItem(FlagActor);
	}

	;
}

final function HDScoreFlag(int TeamIndex, HDFlag theFlag)
{
	local int i;
	local TMPlayerReplicationInfo ScorerPRI;

	//Player score
    for(i = 0; i < theFlag.Touchers.Length; i++)
	{
		ScorerPRI = TMPlayerReplicationInfo(theFlag.Touchers[i].PlayerReplicationInfo);

		if(ScorerPRI.Team.TeamIndex == TeamIndex)
		{
			ScorerPRI.Score += 2;
			ScorerPRI.bForceNetUpdate = TRUE;
		}
	}
	// Apply the team score
	ScorerPRI.Team.Score += 5;
	ScorerPRI.Team.bForceNetUpdate = TRUE;

	CheckScore(ScorerPRI);

    if ( bOverTime )
    {
		EndGame(ScorerPRI,"timelimit");
    }

	AnnounceScore(ScorerPRI.Team.TeamIndex);
}

//fixme: Controller?????Flag??????
final function DropFlagsBy(Controller C)
{
	local int i;

	for(i = 0; i < HDFlags.Length; i++)
	{
     	if( HDFlags[i].Drop(C) )
     		break;
	}
}

function DiscardInventory( Pawn Other, optional controller Killer )
{
	;

	if(Killer != none)
		DropFlagsBy(Other.Controller);

	Super.DiscardInventory(Other);
}

/*
function Logout(Controller Exiting)
{
	`log("#HDCTFGame::Logout");
    DropFlagsBy(Exiting);

	Super.Logout(Exiting);
}*/

function SetTeam(Controller Other, TMTeamInfo NewTeam, bool bNewTeam)
{
	;
   	DropFlagsBy(Other);

	Super.SetTeam(Other, NewTeam, bNewTeam);
}

