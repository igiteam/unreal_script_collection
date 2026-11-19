class TPTeamDMScoreboard extends TPTeamScoreboard;

// Move this to TPScoreboard when we start flushing out the non team scoreboard.
struct ScoreboardAsset
{
	var Texture2D	texture;					// What is this image's texture name
	var string		str;						// What is the string data this asset holds if it does not hold a texture
	var font		strFont;					// What (if applicable) font should our str render at
	var Color		strColor;					// What (if applicable) font color should our str render in
	var Vector2D	screenLoc;					// What is this image's (x,y) location?
	var Vector2D	imageSize;					// What is this image's absolute size?
	var Vector2D	canvasSize;					// What is this image's actual texture size ( powers of 2 )
	var bool		scaleImage;					// Should we scale this image?

	structdefaultproperties
	{
		strColor=(R=0,G=255,B=0,A=0);
		Texture=none;
		str="";
	}
};


enum PlayerScoreboardAssetID
{
	MP_BG,
	MP_username,
	MP_mapLocation,
	MP_score,
	MP_achivementHolder,
	MP_killedInAction,
	MP_talking,
	MP_NumAssets
};

enum TeamScoreboardAssetID
{
	TPartisan_BG,
	TPartisan_Name,
	TPartisan_Logo,
	TPartisan_Score,
	TNazi_BG,
	TNazi_Name,
	TNazi_Logo,
	TNazi_Score,
	Team_NumAssets
};

struct PlayerScoreboardContainer
{
	var ScoreboardAsset			playerDetails[7];
	var PlayerReplicationInfo	PRI;
};

// Team Scoreboard Assets
var ScoreboardAsset teamDetails[8];

var bool								allignmentSet;

var Color								naziColor,partisanColor;

var array<PlayerScoreboardContainer>	playerScorecards;



function ReallignAssets()
{

return; // remove this and finish implementation if we ever do per object scaling for the UI scoreboard upon screen resize
	/*baseCanvasSize.X = 640;
	baseCanvasSize.Y = 480;

	actualCanvasSize.X = Canvas.SizeX;
	actualCanvasSize.Y = Canvas.SizeY;

	if ( baseCanvasSize.X == actualCanvasSize.X )
		return;

	

	// FIX

	changedAspect.X = actualCanvasSize.X / baseCanvasSize.X;
	changedAspect.Y = actualCanvasSize.Y / baseCanvasSize.Y;

//	`log("Old Coords were:" @ BG_Main.screenLoc.X @ BG_Main.screenLoc.Y);

	// Calculate aspect ratio and canvas size in order to place scoreboard assets
	BG_Main.screenLoc.x			= changedAspect.x * BG_Main.screenLoc.x;
	BG_Main.screenLoc.y			= changedAspect.y * BG_Main.screenLoc.y;*/

}

function DrawScoreboardAsset(ScoreboardAsset asset)
{
	local Vector2D textSize;

	Canvas.SetPos(asset.screenLoc.x, asset.screenLoc.y);

	if ( asset.texture != none )
	{
		Canvas.DrawTexture( asset.texture, 1.0 );
	}
	else
	{
		Canvas.StrLen( asset.str, textSize.X, textSize.Y );	// Needed if we ever support more than left justification
		Canvas.DrawText( asset.str );
	}
}

function DrawPlayerScoreboardContainer( PlayerScoreboardContainer player, int locX, int locY, int extX )
{
	local int nAsset, drawLocX, drawLocY;
	local float xl,yl;

	for ( nAsset = 0 ; nAsset < MP_NumAssets; nAsset++)
	{
		if ( nAsset == MP_score )
		{
			drawLocX = player.playerDetails[nAsset].screenLoc.x + extX;
			drawLocY = player.playerDetails[nAsset].screenLoc.y + locY;

			Canvas.StrLen(player.playerDetails[nAsset].str,xl,yl);
			Canvas.SetPos( drawLocX - xl, drawLocY );
			Canvas.Font			=  player.playerDetails[nAsset].strFont;
			Canvas.DrawColor	= player.playerDetails[nAsset].strColor;
			Canvas.DrawText( player.playerDetails[nAsset].str );
			continue;
		}

		drawLocX = player.playerDetails[nAsset].screenLoc.x + locX;
		drawLocY = player.playerDetails[nAsset].screenLoc.y + locY;
		Canvas.SetPos( drawLocX, drawLocY );

		if ( player.playerDetails[nAsset].texture != none )
		{
			Canvas.DrawTexture( player.playerDetails[nAsset].texture, 1.0 );
		}
		if ( Len( player.playerDetails[nAsset].str ) != 0 )
		{
			Canvas.Font			= player.playerDetails[nAsset].strFont;
			Canvas.DrawColor	= player.playerDetails[nAsset].strColor;
			Canvas.DrawText( player.playerDetails[nAsset].str );
		}

	}

	return;
}

function DrawTeamScoreboardContainers(int teamID, int origX, int origY, int extX)
{
	local int teamOffsetID;

	teamOffsetID = TNazi_BG * teamID;

	Canvas.SetPos( origX + teamDetails[TPartisan_BG + teamOffsetID].screenLoc.x, origY + teamDetails[TPartisan_BG + teamOffsetID].screenLoc.Y );
	Canvas.DrawTexture(teamDetails[TPartisan_BG + teamOffsetID].texture, 1.0 );

	Canvas.SetPos( origX + teamDetails[TPartisan_Logo + teamOffsetID].screenLoc.x, origY + teamDetails[TPartisan_Logo + teamOffsetID].screenLoc.Y );
	Canvas.DrawTexture(teamDetails[TPartisan_Logo + teamOffsetID].texture, 1.0 );


	Canvas.SetPos( origX + teamDetails[TPartisan_Name + teamOffsetID].screenLoc.x, origY + teamDetails[TPartisan_Name + teamOffsetID].screenLoc.Y );
	Canvas.Font	= teamDetails[TPartisan_Name + teamOffsetID].strFont;
	Canvas.DrawColor = teamDetails[TPartisan_Name + teamOffsetID].strColor;
	Canvas.DrawText( teamDetails[TPartisan_Name + teamOffsetID].str );

	Canvas.SetPos( origX + teamDetails[TPartisan_Score + teamOffsetID].screenLoc.x, origY + teamDetails[TPartisan_Score + teamOffsetID].screenLoc.Y );
	Canvas.Font			= teamDetails[TPartisan_Score + teamOffsetID].strFont;
	Canvas.DrawColor	= teamDetails[TPartisan_Score + teamOffsetID].strColor;
	Canvas.DrawText( teamDetails[TPartisan_Score + teamOffsetID].str );
}

function InitTeamScoreboardContainers()
{

	teamDetails[TPartisan_BG].texture			= Texture2D'EngineMaterials.OrientParticle';
	teamDetails[TNazi_BG].texture				= Texture2D'EngineMaterials.OrientParticle';
	
	teamDetails[TPartisan_Logo].texture			= Texture2D'EngineMaterials.OrientParticle';
	teamDetails[TNazi_Logo].texture				= Texture2D'EngineMaterials.OrientParticle';
	
	teamDetails[TPartisan_Name].str				= "Partisan";
	teamDetails[TPartisan_Name].strFont			= class'Engine'.Static.GetMediumFont();
	teamDetails[TPartisan_Name].strColor		= PartisanColor;
	teamDetails[TPartisan_Name].screenLoc.X		= 50;
	teamDetails[TPartisan_Name].screenLoc.Y		= 0;

	teamDetails[TNazi_Name].str					= "Nazi";
	teamDetails[TNazi_Name].strFont				= class'Engine'.Static.GetMediumFont();
	teamDetails[TNazi_Name].strColor			= NaziColor;
	teamDetails[TNazi_Name].screenLoc.X			= 50;
	teamDetails[TNazi_Name].screenLoc.Y			= 0;

	teamDetails[TPartisan_Score].strFont		= class'Engine'.Static.GetMediumFont();
	teamDetails[TPartisan_Score].strColor		= PartisanColor;
	teamDetails[TPartisan_Score].screenLoc.X	= 200;
	teamDetails[TPartisan_Score].screenLoc.Y	= 0;

	teamDetails[TNazi_Score].strFont			= class'Engine'.Static.GetMediumFont();
	teamDetails[TNazi_Score].strColor			= NaziColor;
	teamDetails[TNazi_Score].screenLoc.X		= 200;
	teamDetails[TNazi_Score].screenLoc.Y		= 0;
	


}

function InitScoreboardContainers()
{
	local	int								playerID;
	local	GameReplicationInfo				GRI;
	local	Color							strColor;

	GRI = WorldInfo.GRI;
	if (GRI==none)
	{
		return;
	}

	playerScorecards.Remove(0, playerScorecards.Length);

	for ( playerID=0; playerID<GRI.PRIArray.Length; playerID++ )
	{
		if ( GRI.PRIArray[playerID].bIsSpectator == false )
		{
			playerScorecards[playerID].PRI											= GRI.PRIArray[playerID];

			if ( playerScorecards[playerID].PRI == PlayerOwner.PlayerReplicationInfo )
				strColor = PlayerColor;
			else if ( playerScorecards[playerID].PRI.Team.TeamIndex == 0 )
				strColor = PartisanColor;
			else
				strColor = NaziColor;

			playerScorecards[playerID].playerDetails[MP_username].strFont			= class'Engine'.Static.GetSmallFont();
			playerScorecards[playerID].playerDetails[MP_username].strColor			= strColor;
			playerScorecards[playerID].playerDetails[MP_username].str				= GRI.PRIArray[playerID].PlayerName;
			playerScorecards[playerID].playerDetails[MP_username].texture			= none;
			playerScorecards[playerID].playerDetails[MP_username].screenLoc.X   	= 25;
			playerScorecards[playerID].playerDetails[MP_username].screenLoc.Y   	= 20;

			playerScorecards[playerID].playerDetails[MP_mapLocation].strFont		= class'Engine'.Static.GetSmallFont();
			playerScorecards[playerID].playerDetails[MP_mapLocation].strColor		= strColor;
			playerScorecards[playerID].playerDetails[MP_mapLocation].str			= "Location:" @ GRI.PRIArray[playerID].GetLocationName();
			playerScorecards[playerID].playerDetails[MP_mapLocation].texture		= none;
			playerScorecards[playerID].playerDetails[MP_mapLocation].screenLoc.X	= 25;
			playerScorecards[playerID].playerDetails[MP_mapLocation].screenLoc.Y	= 50;

			playerScorecards[playerID].playerDetails[MP_score].strFont				= class'Engine'.Static.GetSmallFont();
			playerScorecards[playerID].playerDetails[MP_score].strColor				= strColor;
			playerScorecards[playerID].playerDetails[MP_score].str					= "" $ int(GRI.PRIArray[playerID].Score);
			playerScorecards[playerID].playerDetails[MP_score].texture				= none;
			playerScorecards[playerID].playerDetails[MP_score].screenLoc.X			= 0;  // Right Justified
			playerScorecards[playerID].playerDetails[MP_score].screenLoc.Y			= 20;

		}
	}

}

function DrawHUD()
{
	local int i, ItemsPerPage, Count, teamScore;
	local GameReplicationInfo GRI;
	local float LeftPos,TopPos,CenterXPos,Width, Height, xl, yl, w, h, Scale;
	local string Title,HintMsg;
	local TPTeamInfo tInfo;

	local int numPlayer;

	local int naziOrigX, naziOrigY, naziExtX, partisanOrigX, partisanOrigY, partisanExtX, teamDeltaY, scaleX32;

	local array<int> RedList;
	local array<int> BlueList;

	if ( !allignmentSet )
	{
		allignmentSet = true;
		InitTeamScoreboardContainers();
		ReallignAssets();
	}
	
	GRI = WorldInfo.GRI;
	if (GRI==none)
	{
		return;
	}

	WorldInfo.GRI.SortPRIArray();
	Scale = Canvas.ClipX / 1024;


	for (i=0;i<GRI.PRIArray.Length;i++)
	{
		if ( !GRI.PRIArray[i].bIsSpectator )
		{
			switch (GRI.PRIArray[i].Team.TeamIndex)
			{
				case 0: RedList[RedList.Length] = i; break;
				case 1: BlueList[BlueList.Length] = i; break;
			}
		}
	}
	
	LeftPos = Canvas.ClipX * 0.05;
	TopPos  = Canvas.ClipY * 0.15;
	Width = Canvas.ClipX * 0.9;
	Height = Canvas.ClipY * 0.82;
	
	Canvas.Font = class'Engine'.Static.GetMediumFont();

	//// Draw the Game Name
	//
	Title = "Team Deathmatch on " $ WorldInfo.Title @ "Score:" @ WorldInfo.GRI.GoalScore $ ", Time:" @ WorldInfo.GRI.TimeLimit @ "Elapsed=" @ WorldInfo.GRI.RemainingTime;

	Canvas.StrLen(Title,xl,yl);
	Canvas.SetPos(Canvas.ClipX*0.5 - xl * 0.5, Canvas.ClipY * 0.05);
	Canvas.DrawText(Title);

	i = 0;
	foreach AllActors(class'TPTeamInfo', tInfo)
	{
		teamScore = int(tInfo.Score);
		teamDetails[TPartisan_Score + (i * 4)].str = "(" $ teamScore $ ")";
		i++;
	}

	// Draw the background
	Canvas.SetDrawColor(0,0,0,128);
	Canvas.SetPos(LeftPos, TopPos);
	Canvas.DrawTile(Canvas.DefaultTexture, Width, Height, 0,0,32,32);
	Canvas.SetPos(LeftPos+2, TopPos+2);
	Canvas.SetDrawColor(255,255,0,255);	
	Canvas.DrawBox(Width-4,Height-4);

	// Draw the Scroll MEssage

	Canvas.Font = class'Engine'.Static.GetTinyFont();
	HintMsg = "Press D-Pad to change teams";
	Canvas.StrLen(HintMsg,w,h);
	Canvas.SetPos(Canvas.ClipX * 0.5-w*0.5, TopPos+Height-h-3);
	Canvas.DrawText(HintMsg);

	Canvas.Font = class'Engine'.Static.GetMediumFont();
	
	LeftPos += 64  * Scale;
	TopPos  += (64 + 32)  * Scale;
	Width   -= 128 * Scale;
	Height  -= 48 * Scale;

	CenterXPos = LeftPos + Width * 0.5;
	Canvas.StrLen('99',xl,yl);	

	Canvas.Font = class'Engine'.Static.GetTinyFont();
	Canvas.StrLen('99',w,h);	
	
	YL += H;
	ItemsPerPage = 	int ( Height / ( yl * 1.2) );

	Count = RedList.Length;
	if (Count < BlueList.Length)
		Count = BlueList.Length;

	if (ScrollTop < 0 || Count <= ItemsPerPage)
	{
		ScrollTop = 0;
	}
	else
	{
		if (ScrollTop + ItemsPerPage > Count)	
		{
			ScrollTop = Count - ItemsPerPage;
		}
	}
 
	// No sort rules for now.  Eventually Alive > Score > Local > Index  WorldInfo.GRI.SortPRIArray() current rules

	scaleX32	  = (32 * Scale);
	partisanOrigX = LeftPos;
	partisanOrigY = TopPos;
	partisanExtX  = CenterXPos - scaleX32;

	naziOrigX = CenterXPos + scaleX32;
	naziOrigY = TopPos;
	naziExtX  = partisanOrigX + Width;

	teamDeltaY = YL * 1.5;

	// Draw the team scores
	// Draw the team names
	// Draw the team icons
	DrawTeamScoreboardContainers(0, partisanOrigX, partisanOrigY - (64* Scale), partisanExtX);
	DrawTeamScoreboardContainers(1, naziOrigX, naziOrigY - (64* Scale), naziExtX);
	
	InitScoreboardContainers();

	for ( numPlayer = 0 ; numPlayer < playerScorecards.length ; numPlayer++ )
	{
		if ( playerScorecards[numPlayer].PRI.Team.TeamIndex == 0 )
		{
			DrawPlayerScoreboardContainer( playerScorecards[numPlayer], partisanOrigX, partisanOrigY, partisanExtX );
			partisanOrigY += teamDeltaY;
		}
		else
		{
			DrawPlayerScoreboardContainer( playerScorecards[numPlayer], naziOrigX, naziOrigY, naziExtX );
			naziOrigY += teamDeltaY;
		}
	}
	
	return;

}


simulated function DrawCol(float x1,float x2,float y, int Index)
{
	local float xl,yl;
	local string s;
	local PlayerReplicationInfo PRI;

	PRI = WorldInfo.GRI.PRIArray[Index];
	if (PRI==none)
	{
		return;
	}

	Canvas.Font = class'Engine'.Static.GetMediumFont();

	if (PRI == PlayerOwner.PlayerReplicationInfo)
	{
		Canvas.DrawColor = PlayerColor;
	}
	else
	{
		Canvas.DrawColor = PRI.Team.GetTextColor();
	}
	Canvas.DrawColor.R=255;
	Canvas.DrawColor.G=255;
	Canvas.DrawColor.B=255;
	Canvas.SetPos(x1,y);
	Canvas.DrawText(PRI.PlayerName);

	s = ""$Int(PRI.Score);
	
	Canvas.Strlen(s,xl,yl);
	Canvas.SetPos(x2-xl,y);
	Canvas.DrawText(s);

	Canvas.Font = class'Engine'.Static.GetTinyFont();
	
	if ( PRI.Team.TeamIndex == PlayerOwner.Pawn.PlayerReplicationInfo.Team.TeamIndex )
	{
		Canvas.SetPos(x1,y+yl);
		Canvas.SetDrawColor(180,180,180,255);		
		Canvas.DrawText("Location:"@PRI.GetLocationName());	
	}
}

