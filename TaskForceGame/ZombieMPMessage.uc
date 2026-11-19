//
//	This is the message that alerts you to various MP events
//
class ZombieMPMessage extends ZombieMessage
	native;

static function string GetFlagTeamName(Object oflag)
{
	local GTCTFFlag flag;
	flag = GTCTFFlag (oflag);
	//log("FLAG TEAMNAME"@flag@flag.TeamIndex@flag.Level@flag.Level.GRI@flag.Level.GRI.Teams[flag.TeamIndex]@flag.Level.GRI.Teams[flag.TeamIndex].TeamName);
	//log("(Fallback)"@flag.GRI);
	if (flag == None)
	{
		log ("FLAG IS NONE!"@flag);
		return "";
	}
	return flag.Level.GRI.Teams[flag.TeamIndex].TeamName;
}

static function bool isTeamGame()
{
	return true;
}

static event string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local bool bTeamGame;
	local array<string> args;

	bTeamGame = isTeamGame();

	/*
	0 MPM_PlayerDied,	//pri 1 is dead guy, pri 2 is killer optionalObject is damageType
	
	1 MPM_Bomb_Dropped, //nothing needed
	2 MPM_Bomb_Planted, //nothing needed

	//for all flag messages, the optional object is the flag in question	
	3 MPM_CTF_FlagDropped,	//nothing needed
	4 MPM_CTF_FlagTaken,		//pri 1 is used to tell team
	5 MPM_CTF_FlagReturned,	//pri 1 is used to tell team
	6 MPM_CTF_FlagCapped,		//pri 1 is used to tell team
	
	7 MPM_PlayerKilledBy		//optional obj == damagetype
	8 MPM_YouKilledPlayer
	9 MPM_YouCommittedSuicide
	10 MPM_PlayerEntered,		//pri 1 is used to tell name
	11 MPM_PlayerLeft			//pri 1 is used to tell name
	12 MPM_PlayerBurnedToDeath
	13 MPM_VIPAllTerroristsDead
	14 MPM_PlayerChangedTeam
	15 MPM_PlayerChangedName
	16 MPM_PlayerTeamKilledBy
	17 MPM_PlayerTeamKilled
	*/
	
	log("ZombieMPMessage GetString"@Switch);
	
	switch (Switch)
	{
		case 0: //if it gets here, then the reader is not the dead or the dying
			if (RelatedPRI_2 == RelatedPRI_1 || RelatedPRI_2 == none) //if killer is same as dead
			{
				args[0] = RelatedPRI_1.PlayerName;
				return Format( class'Strings'.default.PlayerSuicide, args );
			}
			else if (RelatedPRI_2!=None && RelatedPRI_1!=None)  //if they're different
			{
				if (bTeamGame && RelatedPRI_2.Team.TeamIndex == RelatedPRI_1.Team.TeamIndex )
				{
					args[0] = RelatedPRI_2.PlayerName;
					args[1] = RelatedPRI_1.PlayerName;
					return Format( class'Strings'.default.PlayerTeamKilled, args );
				}
				else
				{
					args[0] = RelatedPRI_2.PlayerName;
					args[1] = RelatedPRI_1.PlayerName;
					return Format( class'Strings'.default.PlayerKilled, args );
				}
			}
			else if( RelatedPRI_2 == None )
			{
				log( RelatedPRI_1.PlayerName @ "MYSTERIOUSLY DIED! SHOULD NEVER HAPPEN! (0)" );
				return "";
			}
			else 
				return "";

		case 3:
			args[0] = RelatedPRI_1.PlayerName;
			args[1] = GetFlagTeamName(OptionalObject);
			// because localized versions have differences in grammar based on word 'gender'
			if ( GTCTFFlag ( OptionalObject ) != None && GTCTFFlag ( OptionalObject ).TeamIndex == 0 )
			{
				return Format( class'Strings'.default.FlagDroppedSF, args );
			}
			else
			{
				return Format( class'Strings'.default.FlagDroppedTR, args );
			}
			
		case 4:
			args[0] = RelatedPRI_1.PlayerName;
			args[1] = GetFlagTeamName(OptionalObject);
			// because localized versions have differences in grammar based on word 'gender'
			if ( GTCTFFlag ( OptionalObject ) != None && GTCTFFlag ( OptionalObject ).TeamIndex == 0 )
			{
				return Format( class'Strings'.default.FlagTakenSF, args );
			}
			else
			{
				return Format( class'Strings'.default.FlagTakenTR, args );
			}
			
		case 5:
			if(RelatedPRI_1 == None || RelatedPRI_1.Team == None || RelatedPRI_1.Team.TeamName == "")
			{
				args[0] = GetFlagTeamName(OptionalObject);
				// because localized versions have differences in grammar based on word 'gender'
				if ( GTCTFFlag ( OptionalObject ) != None && GTCTFFlag ( OptionalObject ).TeamIndex == 0 )
				{
					return Format( class'Strings'.default.TeamFlagReturnedSF, args );
				}
				else
				{
					return Format( class'Strings'.default.TeamFlagReturnedTR, args );
				}
			}
			else
			{
				args[0] = RelatedPRI_1.PlayerName;
				args[1] = GetFlagTeamName(OptionalObject);
				// because localized versions have differences in grammar based on word 'gender'
				if ( GTCTFFlag ( OptionalObject ) != None && GTCTFFlag ( OptionalObject ).TeamIndex == 0 )
				{
					return Format( class'Strings'.default.FlagReturnedSF, args );
				}
				else
				{
					return Format( class'Strings'.default.FlagReturnedTR, args );
				}
			}
			
		case 6:
			args[0] = RelatedPRI_1.PlayerName;
			args[1] = GetFlagTeamName(OptionalObject);
			// because localized versions have differences in grammar based on word 'gender'
			if ( GTCTFFlag ( OptionalObject ) != None && GTCTFFlag ( OptionalObject ).TeamIndex == 0 )
			{
				return Format( class'Strings'.default.FlagCappedSF, args );
			}
			else
			{
				return Format( class'Strings'.default.FlagCappedTR, args );
			}
			
		case 7:
			if (RelatedPRI_2 != None && RelatedPRI_2.PlayerName!="")
			{
				args[0] = RelatedPRI_2.PlayerName;
				return Format( class'Strings'.default.PlayerKilledBy, args );
			}
			else
			{
				log( "SOMEBODY MYSTERIOUSLY DIED! SHOULD NEVER HAPPEN! (7)" );
				return "";
			}
		case 8:
			args[0] = RelatedPRI_1.PlayerName;
			return Format( class'Strings'.default.YouKilledPlayer, args );
		case 9:
			return class'Strings'.default.YouCommittedSuicide;
		case 10:
			if( RelatedPRI_1 != none )
			{
				args[0] = RelatedPRI_1.PlayerName;
				return Format( class'Strings'.default.PlayerEntered, args );
			}
			else
			{
				return "";
			}
		case 11:
			if( RelatedPRI_1 != none )
			{
				args[0] = RelatedPRI_1.PlayerName;
				return Format( class'Strings'.default.PlayerLeft, args );
			}
			else
			{
				return "";
			}
		case 13:
			return class'Strings'.default.VIPAllTerroristsDead;
		case 14:
			if (RelatedPRI_1 == None)
				return "";
			if (OptionalObject == None)
				return "";
			args[0] = RelatedPRI_1.PlayerName;
			args[1] = TeamInfo(OptionalObject).GetHumanReadableName();
			return Format( class'Strings'.default.NewTeamMessage, args );
		case 15:
			if (RelatedPRI_1 == None || RelatedPRI_1.OldName ~= RelatedPRI_1.PlayerName || RelatedPRI_1.OldName == "")
				return "";
			args[0] = RelatedPRI_1.OldName;
			args[1] = RelatedPRI_1.PlayerName;
			return Format( class'Strings'.default.GlobalNameChange, args );
		case 16:
			if (RelatedPRI_2 != None && RelatedPRI_2.PlayerName!="")
			{
				args[0] = RelatedPRI_2.PlayerName;
				return Format( class'Strings'.default.PlayerTeamKilledBy, args );
			}
			else
			{
				log( "SOMEBODY MYSTERIOUSLY DIED! SHOULD NEVER HAPPEN! (16)" );
				return "";
			}
		case 17:
			args[0] = RelatedPRI_1.PlayerName;
			return Format( class'Strings'.default.YouTeamKilledPlayer, args );
	}
	
	return "Invalid MP Message";
}

static event string GetStringPC(
	PlayerController pc,
	optional int SwitchVal,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local bool bTeamGame;
	bTeamGame = isTeamGame();

	if(SwitchVal == 0)
	{
		// check the player controller, and then adjust the message conditionally
		if( pc.PlayerReplicationInfo == RelatedPRI_1 && (pc.PlayerReplicationInfo == RelatedPRI_2 || RelatedPRI_2 == none) ) //if killer is the same as killed AND it's the person who's reading the message
		{
			SwitchVal = 9;
		}
		else if(pc.PlayerReplicationInfo == RelatedPRI_1) // otherwise if the person who's reading the message is the killed
		{
			if (RelatedPRI_2==None && ClassIsChildOf(class<Actor>(OptionalObject),class'DamageTypeBurned'))	//if he burned to death
				SwitchVal = 12;
			else if (bTeamGame && RelatedPRI_2.Team.TeamIndex == RelatedPRI_1.Team.TeamIndex)
				SwitchVal = 16;
			else
				SwitchVal = 7;
		}
		else if(pc.PlayerReplicationInfo == RelatedPRI_2) // otherwise if the person who's reading the message is the killer
		{
			if (bTeamGame && RelatedPRI_2.Team.TeamIndex == RelatedPRI_1.Team.TeamIndex)
				SwitchVal = 17;
			else
				SwitchVal = 8;
		}
			
		//otherwise, it's a 3rd party message, so let the 0 handle it
	}
	
	//don't display just " entered" or " left". it looks bad.
	if ((SwitchVal == 10 || SwitchVal == 11) && (RelatedPRI_1 == None || RelatedPRI_1.PlayerName == "")) return "";
	
	return GetString(SwitchVal, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}


// Decompiled with UE Explorer.
defaultproperties
{
    TextSize=13.0000000
    xWrap=456
    bFadeMessage=true
    bCenter=true
    Lifetime=5
    XPos=48.0000000
    YPos=36.0000000
}