class TheHill extends Volume;

var bool Enabled;

var int gtFlags;

var float LastScoreTime;
//var float ScoreSoundTimeBase;
var int LastScore;
var bool IsTeam;

var array<PathNode> NodesOnTheHill;

var sound ScoringSound;
//var StaticMesh ringMesh;

event PostBeginPlay()
{
	local int gtInt;
	local PathNode Node;
	local Box volBox;
//	local AmbientActor sma;
//	local vector ringPos;
//	local vector ringScale;
//	local float dim;
	
	Enabled = false;
	
	if (Level.Game != none)
	{
		gtInt = Level.Game.GameTypeID;
		
		if ((gtFlags & (1<<gtInt)) != 0)
		{
			Enabled = true;

			volBox = GetVolumeBoundingBox(1);
			Level.Game.GameReplicationInfo.SetFlagPos( volBox.Min + (volBox.Max-volBox.Min)/2 );
			SetTimer(0.25, true);

//			
//			ringPos.x = (volBox.Min.x + volBox.Max.x)/2;
//			ringPos.y = (volBox.Min.y + volBox.Max.y)/2;
//			ringPos.z = volBox.Min.z;
//			
//			dim = volBox.Max.x - volBox.Min.x;
//			
//			if ((volBox.Max.y - volBox.Min.y) > dim)
//			{
//				dim = volBox.Max.y - volBox.Min.y;
//			}
//			
//			dim /= 200;
//			
//			ringScale.x = dim;
//			ringScale.y = dim;
//			ringScale.z = 1;
//			
//			sma = Spawn(class'AmbientActor');
//			sma.SetStaticMesh(ringMesh);
//			sma.SetDrawType(DT_StaticMesh);
//			sma.SetCollision(false, false, false);
//			sma.SetDrawScale3D(ringScale);
//			sma.SetLocation(ringPos);
//			
//			
//			log("KOHRing: " $ sma @ ringPos.x @ ringPos.y @ ringPos.z @ volBox.Min.x @ volBox.Min.y @ volBox.Min.z @ volBox.Max.x @ volBox.Max.y @ volBox.Max.z);
		}
	}

	IsTeam = Level.Game.bTeamGame;
	foreach AllActors ( class'PathNode', Node )
	{
		if ( Encompasses ( Node ) )
		{
			NodesOnTheHill [ NodesOnTheHill.Length ] = Node;
		}
	}
}

event UnTouch( Actor Other )
{
	local Pawn p;
	if (Enabled)
	{
		p = Pawn(Other);
		if (p != none)
		{
			p.PlayerReplicationInfo.ScoringKOH = false;
		}
	}
}

function bool CanScore()
{
	local int numTouchers;
	local int firstTeam;
	local ZombieBipedPawn zbp;
	
	numTouchers = 0;
	
	firstTeam = 255;
	
	//if teamKOH
	//	ensure all players touching are on the same team
	//else
	//	ensure only one player touching

	ForEach TouchingActors(class'ZombieBipedPawn', zbp)
	{
		if (zbp.Health > 0)
		{
			if (!isTeam)
			{
				++numTouchers;
				
				if (numTouchers >= 2)
				{
					log("No scoring: Multiple players on hill");
					return false;
				}
			}
			else
			{
				if (zbp.PlayerReplicationInfo.Team == none)
				{
					log("Got Player with no team: " $ zbp);
					continue;
				}
				
				if (firstTeam == 255)
				{
					firstTeam = zbp.PlayerReplicationInfo.Team.TeamIndex;
				}
				else if (firstTeam != zbp.PlayerReplicationInfo.Team.TeamIndex)
				{
					log("No scoring: Different teams on hill");
					return false;
				}
			}
		}
	}
	
	
	return true;
}

function Score()
{
	local float curTime;
	local float deltaTime;
	//local float SoundDelta;
	local int NewScore;
	local float scoreMult;
	local ZombieBipedPawn zbp;
	
	curTime = Level.TimeSeconds;
	
	deltaTime = curTime - LastScoreTime;
	//soundDelta = curTime - ScoreSoundTimeBase;
	scoreMult = 1.0f;
	
	ForEach TouchingActors(class'ZombieBipedPawn', zbp)
	{
		zbp.PlayerReplicationInfo.ScoringKOH = false;
	}
	
	if (CanScore())
	{
		ForEach TouchingActors(class'ZombieBipedPawn', zbp)
		{
			if (zbp.Health > 0)
			{
				//log("Pawn Scoring"@zbp);
				zbp.PlayerReplicationInfo.ScoringKOH = true;
									
				LastScore = int (zbp.PlayerReplicationInfo.Score);
				Level.Game.ScoreObjective(zbp.PlayerReplicationInfo, deltaTime*scoreMult);
				NewScore = int (zbp.PlayerReplicationInfo.Score);
				//log("LastScore"@LastScore);
				//log("NewScore"@NewScore);
				if(NewScore > LastScore)
					{
						PlayerController (zbp.Controller).ClientPlaysound(ScoringSound);

					}
				//log("Scoring now: " $ zbp @ zbp.PlayerReplicationInfo.Score @ deltaTime*scoreMult);
				
				scoreMult /= 2;
			}
		}
	}
	
	LastScoreTime = curTime;
}

event Timer( )
{
	if (Enabled && !Level.Game.bGameEnded && !Level.Game.bWaitingToStartMatch)
	{
		Score();
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    gtFlags=48
    ScoringSound=Sound'CBW_DYN_interface.mp.mp_timer_positive'
    bStatic=false
}