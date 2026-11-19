class MPHUD extends BasicHUD
native;

const NUM_MP_MESSAGES = 10;

var ZHUDLocalizedMessage MPMessage[NUM_MP_MESSAGES];
var int NextMPMessage;

const HEALTH_AMMO_SCALE=1.3;


enum ESplitStyle
{
	SS_1,	//one player
	SS_2,	//two players
	SS_3	//3 or more players
};

var ESplitStyle SplitStyle;
var string KilledByString;

simulated function SetHUDColor(canvas c)
{
	SetTeamColor(c, PlayerOwner.PlayerReplicationInfo);
}

simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType)
{
	local class<ZombieMessage> ZMessage;
	local int i;

	if( !(MsgType == 'Say' || MsgType == 'TeamSay') || msg == "" )
	{
		log("Rejected ZombieMPMessage: " $ msg);
		return;
	}

	PlayerOwner.PlayBeepSound();
	Msg = PRI.PlayerName$": "$Msg;

	// force early removal?
	if( NextMPMessage == NUM_MP_MESSAGES )
	{
		for( i = 1; i < NUM_MP_MESSAGES; ++i )
			MPMessage[i-1] = MPMessage[i];
		--NextMPMessage;
	}

	ZMessage = class'ZombieMPMessage';
	MPMessage[NextMPMessage].Message = ZMessage;
	MPMessage[NextMPMessage].Switch = 0;
	MPMessage[NextMPMessage].RelatedPRI = PRI;
	MPMessage[NextMPMessage].OptionalObject = none;
	MPMessage[NextMPMessage].EndOfLife = ZMessage.default.LifeTime + Level.TimeSeconds;
	MPMessage[NextMPMessage].StringMessage = msg;
	MPMessage[NextMPMessage].LifeTime = ZMessage.Default.Lifetime;
	MPMessage[NextMPMessage].StringFont = ZMessage.Default.Font;
	MPMessage[NextMPMessage].TextSize = ZMessage.Default.TextSize;
	MPMessage[NextMPMessage].Kern = ZMessage.Default.Kern;

	if( PRI.Team != none )
	{
		MPMessage[NextMPMessage].DrawColor = PRI.Team.TeamColor;
	}
	else
	{
		MPMessage[NextMPMessage].DrawColor = class'TeamSF'.default.TeamColor;
	}

	log("Received ZombieMPMessage: " $ MPMessage[NextMPMessage].StringMessage);
	++NextMPMessage;
}

simulated function DrawMPMessages( canvas c, optional bool bkg )
{
	local int i;
	local float baseX;
	local float baseY;
	local float nextY;
	local float msgBoxWidth;
	local float msgBoxHeight;
	local float scaleMod;
	local float msgHeight;
	local float FadeValue;
	local Color msgColor;
	
	if( NextMPMessage == 0 )
	{
		return;
	}

	scaleMod = 1;//c.Scale + ((1-c.Scale)*0.25);
	
	//msgBoxWidth = 150/scaleMod;
	msgBoxWidth = 456;
	msgBoxHeight = 408 * 2 / 3.0;
	baseX = c.SafeFrame.Left;
	baseY = c.SafeFrame.Top + 36;
	nextY = baseY;

	c.SetDropShadow(true);

	class'ZombieFontDescriptor'.static.SetHUDFont(c, 18/scaleMod);
	
	for (i=0; i<NextMPMessage; ++i)
	{
		msgHeight = c.CalcTextHeight(MPMessage[i].StringMessage, msgBoxWidth);
	
		if ((nextY + msgHeight) > (baseY+msgBoxHeight))
		{
			break;
		}

		msgColor = MPMessage[i].DrawColor;

		if( MPMessage[i].Message.default.bFadeMessage )
		{
			FadeValue = (MPMessage[i].EndOfLife - Level.TimeSeconds);
			if( FadeValue > 0 )
			{
				FadeValue = ( FadeValue / MPMessage[i].LifeTime ) * 255;
				msgColor.A = FadeValue;
			}
			else
			{
				continue;
			}
		}
		else
		{
			msgColor.A = 255;
		}

		if( bkg )
		{
			c.DrawColor.R = 0;
			c.DrawColor.G = 0;
			c.DrawColor.B = 0;
			c.DrawColor.A = 192;
			c.DrawTile2( c.WhiteSquare, baseX, nextY, msgBoxWidth, msgHeight, 0, 0, 1, 1 ); 
		}

        c.DrawColor = msgColor;
		c.DrawText2(MPMessage[i].StringMessage,
			baseX,
			nextY,
			msgBoxWidth,
			0,
			JH_Left);

		nextY += msgHeight;
	}
	
	c.SetDropShadow(false);
}

simulated function DrawHUD( canvas Canvas )
{
	super.DrawHUD(Canvas);

//	if( NextMPMessage != 0 )
//	{
//		Canvas.SetDrawColor( 255,255,255 );
//		DrawZMessage( Canvas, MPMessage[0] );
//	}
}

function DrawSpectatingHud (Canvas C)
{
	super.DrawSpectatingHud(c);

	DrawMPMessages(c);
//	if( NextMPMessage != 0 )
//	{
//		c.SetDrawColor( 255,255,255 );
//		DrawZMessage( c, MPMessage[0] );
//	}
}

function Timer()
{
	local int i;

	super.Timer();

	if ( NextMPMessage != 0 && MPMessage[0].EndOfLife > 0 && Level.TimeSeconds >= MPMessage[0].EndOfLife )
	{
		for( i = 1; i < NextMPMessage; ++i )
		{
			MPMessage[i-1] = MPMessage[i];
		}
		
		--NextMPMessage;
		ClearZMessage( MPMessage[NextMPMessage] );
	}
}

function ClearMessages()
{
	local int i;

	super.ClearMessages();

	for( i = 0; i < NextMPMessage; ++i )
		ClearZMessage( MPMessage[i] );

	NextMPMessage = 0;
}

function ClearLocalMessages(optional class<LocalMessage> MsgClass)
{
	local int i;

	super.ClearLocalMessages( MsgClass );
	
	if( ClassIsChildOf( class'ZombieGame.ZombieMPMessage', MsgClass ) )
	{
		for( i = 0; i < NextMPMessage; ++i )
			ClearZMessage( MPMessage[i] );

		NextMPMessage = 0;
	}
}

simulated function bool HandleLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional String CriticalString )
{
	local class<ZombieMessage> ZMessage;
	local int i;
	local string msg;

	if( ClassIsChildOf(Message, class'ZombieMPMessage') )
	{
		msg = class<ZombieMPMessage>(Message).Static.GetStringPC(PlayerOwner, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	
		if (msg == "")
		{
			log("Rejected ZombieMPMessage: " $ msg);
			return true;
		}
	
		// force early removal?
		if( NextMPMessage == NUM_MP_MESSAGES )
		{
			for( i = 1; i < NUM_MP_MESSAGES; ++i )
				MPMessage[i-1] = MPMessage[i];
			--NextMPMessage;
		}

		ZMessage = class<ZombieMessage>(Message);
		MPMessage[NextMPMessage].Message = ZMessage;
		MPMessage[NextMPMessage].Switch = Switch;
		MPMessage[NextMPMessage].RelatedPRI = RelatedPRI_1;
		MPMessage[NextMPMessage].OptionalObject = OptionalObject;

		if( ZMessage.static.GetZLifetime(switch, optionalObject) != 0 )
		{
			MPMessage[NextMPMessage].EndOfLife = ZMessage.static.GetZLifetime(switch, optionalObject);
			MPMessage[NextMPMessage].EndOfLife += Level.TimeSeconds;
		}
		else
		{
			MPMessage[NextMPMessage].EndOfLife = 0;
		}

		MPMessage[NextMPMessage].StringMessage = msg;
		
		//only set this if we're the client that's dying
		if (RelatedPRI_1 == PlayerOwner.PlayerReplicationInfo)
			KilledByString = MPMessage[NextMPMessage].StringMessage;
			
		MPMessage[NextMPMessage].LifeTime = ZMessage.Default.Lifetime;
		MPMessage[NextMPMessage].StringFont = ZMessage.Default.Font;
		MPMessage[NextMPMessage].TextSize = ZMessage.Default.TextSize;
		MPMessage[NextMPMessage].Kern = ZMessage.Default.Kern;
		MPMessage[NextMPMessage].DrawColor = ZMessage.Default.DrawColor;

		log("Received ZombieMPMessage: " $ MPMessage[NextMPMessage].StringMessage);
		++NextMPMessage;

		return true;
	}
	
	return false;
}

simulated function HUDSetup(canvas canvas)
{
	super.HUDSetup(canvas);
	
	if (canvas.ClipY < 480)
	{
		if (canvas.ClipX < 640)
		{
			SplitStyle = SS_3;
		}
		else
		{
			SplitStyle = SS_2;
		}
		
		if (canvas.offY == 0)
		{
			BasePos = 480 + BasePosAdjust;
		}
		else
		{
			BasePos = 480 - ((480-RealBasePos)/canvas.ScaleY) + BasePosAdjust;
		}
	}
	else
	{
		SplitStyle = SS_1;
		BasePos = RealBasePos + BasePosAdjust;
	}
}

function DrawLoadScreen(canvas C)
{
	if (!LoadDone)
	{
		super.DrawLoadScreen(C);
	}
	else
	{
		C.Style = ERenderStyle.STY_Normal;
		C.SetPos(0, 0);

		//draw black bkg
		C.SetDrawColor(0,0,0);
		C.DrawTile(WhiteSquareMat, C.ClipX, C.ClipY, 0, 0, 1, 1);		
	}
}

simulated function DrawBackground(Canvas c)
{
}

simulated function DrawMPIcons(Canvas c)
{
	local byte IconIdx;
	local byte FlagSubIconIdx;
	local int Score;
	local name flagState;
	local int myTeam;
	local int oppTeam;
	local int curTeam;
	local int i;
	local float baseX, baseY;

	if ((PlayerOwner == none) || (PlayerOwner.GameReplicationInfo == none))
	{
		return;
	}
	
	if ((PlayerOwner.GameReplicationInfo.GameTypeID == GT_KingOfTheHill) || (PlayerOwner.GameReplicationInfo.GameTypeID == GT_TeamKingOfTheHill))
	{
		IconIdx = HIM_MP_KOH;
		
		c.SetDrawColor(255, 255, 255, 128);
		
		if (PlayerOwner.PlayerReplicationInfo.ScoringKOH)
		{
			c.DrawColor.A = 255;
		}

		class'ZombieFontDescriptor'.static.SetHUDFont(c, 24);
		
		class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, IconIdx, c.SafeFrame.Left+10, c.SafeFrame.Bottom-155);
		
		if (PlayerOwner.GameReplicationInfo.GameTypeID == GT_KingOfTheHill)
		{
			Score = int(PlayerOwner.PlayerReplicationInfo.Score);
		}
		else
		{
			Score = int(PlayerOwner.PlayerReplicationInfo.Team.Score);
		}
		
		c.DrawText2( FormatTime(Score), c.SafeFrame.Left+50, c.SafeFrame.Bottom-148);
		
		class'ZombieFontDescriptor'.static.ResetFont(c);
	}
	else if (PlayerOwner.GameReplicationInfo.GameTypeID == GT_CTF)
	{
		IconIdx = HIM_MP_FLAG;
		
		if (PawnOwner.PlayerReplicationInfo.Team != none)
		{
			myTeam = PawnOwner.PlayerReplicationInfo.Team.TeamIndex;
	
			if (myTeam == 0)
			{
				oppTeam = 1;
			}
			else 
			{
				oppTeam = 0;
			}
		}
		
		//baseX = c.SafeFrame.Left+10;
		baseX = c.SafeFrame.Left;
		baseY = c.SafeFrame.Bottom-160;
		curTeam = myTeam;
		
		class'ZombieFontDescriptor'.static.SetHUDFont(c, 24);
		
		for (i=0; i<2; ++i)
		{
			if (curTeam == myTeam)
			{
				SetTeamColor(c, PlayerOwner.PlayerReplicationInfo);
			}
			else 
			{
				SetOppTeamColor(c, PlayerOwner.PlayerReplicationInfo);
			}
			
			class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, IconIdx, baseX, baseY);
			
			c.SetDrawColor(255, 255, 255);
			
			//draw flag icon...
			flagState = PlayerOwner.GameReplicationInfo.GetCarriedObjectState(curTeam);

			FlagSubIconIdx = 255;
			
			if (flagState == 'Home')
			{
				FlagSubIconIdx = 255;
			}
			else if (flagState == 'HeldEnemy')
			{
				FlagSubIconIdx = HIM_MP_FLAG_MISSING;
				if ((curTeam == oppTeam) && PawnOwner.PlayerReplicationInfo.bHasFlag)
				{
					FlagSubIconIdx = HIM_MP_FLAG_HAVE;
				}
			}
			else if (flagState == 'Down')
			{
				FlagSubIconIdx = HIM_MP_FLAG_DOWN;
			}
			
			if (FlagSubIconIdx != 255)
			{
				class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, FlagSubIconIdx, baseX+15, baseY+15, 32, 32);
			}
			
			Score = int(PlayerOwner.GameReplicationInfo.Teams[curTeam].score);
			
			c.DrawText2(Score, baseX+50, baseY+15);
			
			curTeam = oppTeam;
			baseX += 60;
		}
	}
	else if (PlayerOwner.GameReplicationInfo.GameTypeID == GT_VIP)
	{
		if( PawnOwner.IsA('GTVipPawn') && GTVipPawn(PawnOwner).IsVIP() )
		{
			IconIdx = HIM_MP_VIP;
			
			c.SetDrawColor(255, 255, 255, 255);
			
			class'ZombieFontDescriptor'.static.SetHUDFont(c, 24);
			
			class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, IconIdx, c.SafeFrame.Left+10, c.SafeFrame.Bottom-160, 48, 48);
			
			c.DrawText2(class'Strings'.default.VIP, c.SafeFrame.Left+65, c.SafeFrame.Bottom-148);
			
			class'ZombieFontDescriptor'.static.ResetFont(c);
		}
	}
}

simulated function DrawMPRadar(Canvas c)
{
	local int i;
	local PlayerReplicationInfo PRI;
	local int baseX, baseY, radius, range;
	local vector MeToHim;
	local float dist;
	local int dotSize;
	local float bkgRadius;
	
	radius = 50;
	bkgRadius = radius*1.1;
	baseX = c.SafeFrame.Left+radius+10;
	baseY = c.SafeFrame.Bottom-radius-10;
	range = 5000;
	dotSize = 4/1/*c.Scale*/;	//scale up for small viewports
	
	if ((PlayerOwner == none) || (PlayerOwner.GameReplicationInfo == none))
	{
		return;
	}
	
	class'ZombieFontDescriptor'.static.SetHUDFont(c, 24);

	SetTeamColor(c, PlayerOwner.PlayerReplicationInfo);
	c.DrawColor.A = 255*(OpacityAdjust*0.3);
	
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, HIM_RADAR_BKG, baseX-bkgRadius, baseY-bkgRadius, bkgRadius*2, bkgRadius*2);

	DrawBox(c, baseX-(dotSize/2), baseY-(dotSize/2), dotSize, dotSize);
	
	for (i=0; i<PlayerOwner.GameReplicationInfo.PRIArray.length; ++i)
	{
		PRI = PlayerOwner.GameReplicationInfo.PRIArray[i];
		
		if ( PRI.IsDead || PRI.bIsSpectator || PRI.bOnlySpectator || (PRI == PlayerOwner.PlayerReplicationInfo) )
		{
			//log("Radar got spectator: " $ PRI.PlayerName @ PRI.Team);
			continue;
		}
		
		if (!PlayerOwner.GameReplicationInfo.bEnemiesOnRadar && ((PRI.Team == None) || (PRI.Team != PlayerOwner.PlayerReplicationInfo.Team)))
		{
			continue;
		}
		
		MeToHim = (PRI.RadarPos - PlayerOwner.Pawn.Location) << PlayerOwner.Pawn.Rotation;
		dist = VSize(MeToHim)/range;
		if (dist > 1)
		{
			continue;
		}
		dist *= radius;
		
		MeToHim = Normal(MeToHim)*dist;
		
		SetTeamColor(c, PRI);
		
		//c.DrawText2("E", MeToHim.y+baseX, -MeToHim.x+baseY);
		DrawBox(c, MeToHim.y+baseX-((dotSize)/2), -MeToHim.x+baseY-((dotSize)/2), dotSize, dotSize);
	}
	
	if (PlayerOwner.GameReplicationInfo.NumFlags > 0)
	{
		dotSize *= 2;
		MeToHim = (PlayerOwner.GameReplicationInfo.FlagPos1 - PlayerOwner.Pawn.Location) << PlayerOwner.Pawn.Rotation;
		dist = VSize(MeToHim)/range;
		if (dist > 1)
		{
			dist = 1.1;
		}
		dist *= radius;
		
		MeToHim = Normal(MeToHim)*dist;
		
		if (PlayerOwner.GameReplicationInfo.GameTypeID == GT_CTF)
		{
			SetSFColor(c);
		}
		else
		{
			c.SetDrawColor(255, 255, 255);
		}
		
		DrawOpenBox(c, MeToHim.y+baseX-((dotSize)/2), -MeToHim.x+baseY-((dotSize)/2), dotSize, dotSize, 1.0f/c.Scale);
		//class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, 62, MeToHim.y+baseX-((dotSize)/2), -MeToHim.x+baseY-((dotSize)/2), dotSize, dotSize);
		
		if (PlayerOwner.GameReplicationInfo.NumFlags > 1)
		{
			MeToHim = (PlayerOwner.GameReplicationInfo.FlagPos2 - PlayerOwner.Pawn.Location) << PlayerOwner.Pawn.Rotation;
			dist = VSize(MeToHim)/range;
			if (dist > 1)
			{
				dist = 1.1;
			}
			dist *= radius;
			
			MeToHim = Normal(MeToHim)*dist;
			
			if (PlayerOwner.GameReplicationInfo.GameTypeID == GT_CTF)
			{
				SetTerrColor(c);
			}
			else
			{
				c.SetDrawColor(255, 255, 255);
			}
			
			DrawOpenBox(c, MeToHim.y+baseX-((dotSize)/2), -MeToHim.x+baseY-((dotSize)/2), dotSize, dotSize, 1.0f/c.Scale);
		}
	}
	
	class'ZombieFontDescriptor'.static.ResetFont(c);
}

simulated function DrawCompass(Canvas c)
{
}

function DrawComponents(Canvas c)
{
	local Color origDrawColor;
	origDrawColor = c.DrawColor;
	
//	DrawBackground(c);
	DrawCrosshair(c);
	c.DrawColor=origDrawColor;

	DrawAmmo(c);
	c.DrawColor=origDrawColor;
	DrawHealth(c);
	
	c.DrawColor=origDrawColor;
	DrawNotify(c);
	
	c.DrawColor=origDrawColor;

	DrawMPIcons(c);
	c.DrawColor=origDrawColor;

	//for team games
//	DrawTeam(c); //no team icons for now...
	DrawMPRadar(c);
	c.DrawColor=origDrawColor;
	
	DrawMPMessages(c);
	c.DrawColor=origDrawColor;
}

native simulated event DrawCrosshair(Canvas Canvas);

simulated function DisplayMessages( Canvas c )
{
	DrawMPMessages( c, true );
}

simulated function DrawTeam(Canvas c)
{
	local float x;
	local float y;
	local byte idx;

	if( PawnOwner.PlayerReplicationInfo.Team == none )
		return;

	GetSafeFrame( c, false, false, x, y );
	x += 46; // width of the icon
	x += WidthAdjust;

	if( PawnOwner.PlayerReplicationInfo.Team.TeamName ~= class'TeamSF'.default.TeamName )
        idx = HIM_TEAM_SF;
	else if( PawnOwner.PlayerReplicationInfo.Team.TeamName ~= class'TeamTerrorist'.default.TeamName )
		idx = HIM_TEAM_TERR;
	else
	{
		log("BADTEAMNAME)(*#QU$)");
		idx=HIM_TEAM_TERR;
	}

	SetTeamColor(c, PlayerOwner.PlayerReplicationInfo);

	class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c,idx,x,y);
}

simulated event bool ShouldDrawNoShoot(ZombiePawn zAimPawn)
{
//	if(zAimPawn != None )
//		Log("MPH.SDNS teams:"$ PawnOwner.PlayerReplicationInfo.Team $" "$ zAimPawn.PlayerReplicationInfo.Team
//		$"   factions:"$ zAimPawn.GetFaction() $" "$ ZombiePawn(PawnOwner).GetFaction() );
	if( zAimPawn != None )
	{
		if( (PawnOwner.PlayerReplicationInfo.Team != None && PawnOwner.PlayerReplicationInfo.Team == zAimPawn.PlayerReplicationInfo.Team) 
			|| zAimPawn.GetFaction() == FACTION_Civilian )
			return true;
		else
			return false;
	}
	else
	{
		return false;
	}
}

simulated event DrawNoShoot(Canvas Canvas, ZombiePawn zAimPawn)
{
//	Log("MPH.DrawNoShoot ");
	Canvas.DrawColor = AmberColor;

	// Draw no-shoot symbol
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, HIM_CH_NO_SHOOT, (offset/2), 240);

	// Display targeted pawn's name, if any
	if( zAimPawn.PlayerReplicationInfo.PlayerName != "" )
	{
	//	Log("MPH.DrawNoShoot  NOT COOP!!  factions: "$ ZombiePawn(PawnOwner).GetFaction() $" "$ zAimPawn.GetFaction() );
		if( PawnOwner.PlayerReplicationInfo.Team != None 
		&& PawnOwner.PlayerReplicationInfo.Team == zAimPawn.PlayerReplicationInfo.Team )
			Canvas.SetDrawColor(255,255,255,200);  // ally: white text
		else
			Canvas.SetDrawColor(255,0,0,200);      // enemy: red text

		//class'ZombieFontDescriptor'.static.SetHUDFont(Canvas, 24);
		// TODO - bIsNPC
		//if ( zAimPawn.bIsSpecForceEnemyPawn )
		//{
		//	DrawTextJustify(Canvas, SpecForceEnemyPawn ( zAimPawn ).TargetedName, offset/2, 240 + 30, JUST_Center, true);
		//}
		//else
		//{
		//	DrawTextJustify(Canvas, zAimPawn.PlayerReplicationInfo.PlayerName, offset/2, 240 + 30, JUST_Center, true);
		//}
		//class'ZombieFontDescriptor'.static.ResetFont(Canvas);
	}
}

// Sucky hack.
// Multiplayer: if non-ally targeted while in sniper scope mode, draw name
simulated event DrawSniperShoot(Canvas Canvas, ZombiePawn zAimPawn)
{
	local int oldCHIndex;
	
	oldCHIndex = CurCHIndex;
	CurCHIndex = 6;

	DrawCrosshair(Canvas);
	DrawMPMessages(Canvas);

	CurCHIndex = oldCHIndex;

	if( zAimPawn == None )
		return;

//	Log("MPH.DSS  zAimPawn PRI PlayerName:"$ zAimPawn.PlayerReplicationInfo.PlayerName );
	// Display targeted pawn's name, if any
	if( zAimPawn.PlayerReplicationInfo.PlayerName != "" )
	{
		Canvas.SetDrawColor(255,0,0,200);    // enemy: red text
	//	Log("MPH.DSS   setting red for in-scope name in NON-coop ");

		class'ZombieFontDescriptor'.static.SetHUDFont(Canvas, 24);
		DrawTextJustify(Canvas, zAimPawn.PlayerReplicationInfo.PlayerName, offset/2, 240 + 30, JUST_Center, true);
		class'ZombieFontDescriptor'.static.ResetFont(Canvas);
	}	
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
