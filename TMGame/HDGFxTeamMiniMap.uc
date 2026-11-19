//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGFxTeamMiniMap extends HDGFxTweenableMoviePlayer;

var GFxObject RootMC;
var GFxObject MiniMapAllMC;
//var GFxObject MapInfoTopMC;
//var GFxObject MITTextMC;
var GFxObject MapInfoDownMC;
var GFxObject MIDPlayerMC;
var GFxObject MiniMapsMC;
var GFxObject MinimapImageLoader;
var GFxObject TeamRMC;
var GFxObject TeamBMC;
var GFxObject TeamTimeMC;
var GFxObject TeamIconMC;
var GFxObject OtherMC;
var array<GFxObject> RedIcon;
var array<GFxObject> BlueIcon;

var PlayerController PC;
var GameReplicationInfo GRI;
var PlayerReplicationInfo PRI;

var float MiniMapsX;
var float MiniMapsY;
var float MiniMapsRange;

function bool Start(optional bool StartPaused = false)
{
	super.Start();
	Advance(0);

	RootMC   = GetVariableObject("_root");
	MiniMapAllMC = RootMC.GetObject("MiniMap");
//    MapInfoTopMC = MiniMapAllMC.GetObject("MITMC");
//    MITTextMC    = MapInfoTopMC.GetObject("MapInfoTopMC");
	MapInfoDownMC= MiniMapAllMC.GetObject("MIDMC");
	MIDPlayerMC  = MapInfoDownMC.GetObject("IconPlayerMC");
	OtherMC      = MapInfoDownMC.GetObject("IconOtherMC");
	MiniMapsMC   = GetVariableObject("_root.MiniMap.MapBG.Mapmc");
	MinimapImageLoader = MiniMapsMC.GetObject("MapImageLoader");
	TeamRMC      = GetVariableObject("_root.TeamS.Reds");
	TeamBMC      = GetVariableObject("_root.TeamS.Blues");
	TeamIconMC   = GetVariableObject("_root.TeamS.Icon");
	TeamTimeMC   = GetVariableObject("_root.TeamS.Times");
	return TRUE;
}

function UpdataInfo()
{
	local float PYaw;
	local HDMapInfo MI;
	local string MiniMapName;

	PC  = GetPC();
	GRI = PC.WorldInfo.GRI;
	MI  = HDMapInfo(PC.WorldInfo.GetMapInfo());
	PYaw = AngleClamp180(PC.Rotation.Yaw/182.04444)+90;   //+90?
	MIDPlayerMC.SetFloat("_rotation",PYaw);
	PYaw = AngleClamp180((PYaw-90)/180)*1000;
	MiniMapName=MinimapImageLoader.GetString("source");
	if(MiniMapName == "undefined")
		{
			MiniMapName = string(MI.MapTexture);
			MiniMapName = "img://TM_Fonts."$MiniMapName;
			MinimapImageLoader.SetString("source","img://" $ PathName(MI.MapTexture));
		}

	if(MI.MapCenter.Z != 0)
		{
		MiniMapsRange = MI.MapCenter.Z;
		}
	MiniMapsX = (MI.MapCenter.X-PC.Pawn.Location.X)*MiniMapsRange;
	MiniMapsY = (MI.MapCenter.Y-PC.Pawn.Location.Y)*MiniMapsRange;
	MiniMapsMC.SetFloat("_x",MiniMapsX);
	MiniMapsMC.SetFloat("_y",MiniMapsY);
	MiniMapsMC.SetFloat("_rotation",MI.MapYaw);
//  MITTextMC.SetPosition(PYaw,0);

	UpdataTeamIcon();
}

function UpdataTeamIcon()
{
	local int RedIdx;
	local int BlueIdx;
	local Vector dv;
	local Rotator dr;
	local float d;
	local Pawn P;
	local GFxObject TempIcon;
	local float TimeSeconds;
	local int TimeH,TimeM,TimeS;
	local string TimeStr;

	local TeamInfo MyTeam,TeamRed, TeamBlue;

	TeamRed  = PC.WorldInfo.GRI.Teams[ 0 ];
	TeamBlue = PC.WorldInfo.GRI.Teams[ 1 ];

	if( TeamRed == none || TeamBlue == none )
	{
		return;
	}

	TeamRMC.SetText(TeamRed.Score);
	TeamBMC.SetText(TeamBlue.Score);
	if(PC.WorldInfo.GRI.TimeLimit>200)
		TeamTimeMC.SetText("??");
	else
	{
	  TimeSeconds =PC.WorldInfo.GRI.RemainingTime;
	  TimeH = int(TimeSeconds/3600);
	  TimeSeconds = TimeSeconds % 3600;
	  TimeM = int(TimeSeconds/60);
	  TimeS = TimeSeconds % 60;
	  TimeStr = TimeH$":"$TimeM$":"$TimeS;
	  TeamTimeMC.SetText(TimeStr);
	}

	RedIdx =0;
	BlueIdx=0;

	if( GetPC().PlayerReplicationInfo == none )
	{
		return;
	}

	MyTeam = GetPC().PlayerReplicationInfo.Team;

	if(GRI != None)
	{
		foreach GRI.WorldInfo.AllPawns(class'Pawn', P)
		{
		 if(P!=None && PC.Pawn!=None)
		 {
			P.GetActorEyesViewPoint(dv,dr);
			PRI   = P.PlayerReplicationInfo;
			dv    = (dv-PC.Pawn.Location)*MiniMapsRange;
			d     =  AngleClamp180(dr.Yaw/182.04444);



			if( ( PRI == none ) ||
				( P == PC.Pawn )||
				( !PRI.bIsFocus &&
					(
					( PRI.Team.TeamIndex != MyTeam.TeamIndex && !( HDpawn(P).bIsFiring ) ) ||
					( P.bHidden ) ||
					( P.IsInvisible() ) ||
					( P.DrivenVehicle != None ) ||
					( PRI.bIsSpectator )
					)
				)
			  )
			{
				continue;
			}

			switch (PRI.Team.TeamIndex)
			{
			case 0:
				TeamIconMC.GotoAndStopI(MyTeam.TeamIndex+1);
				if(RedIcon[RedIdx] == none)
					OtherMC.AttachMovie("IconRed","Red"$RedIdx);

				RedIcon[RedIdx] = OtherMC.GetObject("Red"$RedIdx);
				TempIcon = RedIcon[RedIdx].GetObject("Iconmc");

				if(VSize(dv)>134)
				{
					TempIcon.GotoAndStopI(2);
					dv = ClampLength(dv,134);
				}
				else
				{
					TempIcon.GotoAndStopI(1);
				}

				if( HDpawn(P).bIsFiring ||
					P.PlayerReplicationInfo.Team.TeamIndex == MyTeam.TeamIndex||
					PRI.bIsFocus)
					{
					RedIcon[RedIdx].GotoAndPlayI(1);
					if(PRI.bIsFocus)
					  TempIcon.GotoAndStopI(3);
					}
				RedIcon[RedIdx].SetPosition(144+dv.X,113+dv.Y);
				RedIcon[RedIdx].SetFloat("_rotation",d);

				RedIdx++;
				break;

			case 1:
				TeamIconMC.GotoAndStopI(MyTeam.TeamIndex+1);
				if( BlueIcon[BlueIdx] == None )
				   OtherMC.AttachMovie("IconBlue","Blue"$BlueIdx);

				BlueIcon[BlueIdx] = OtherMC.GetObject("Blue"$BlueIdx);
				TempIcon = BlueIcon[BlueIdx].GetObject("Iconmc");

				if(VSize(dv)>134)
				{
					TempIcon.GotoAndStopI(2);
					dv = ClampLength(dv,134);
				}
				else
				{
					TempIcon.GotoAndStopI(1);
				}

				if( HDpawn(P).bIsFiring ||
					P.PlayerReplicationInfo.Team.TeamIndex == MyTeam.TeamIndex ||
					PRI.bIsFocus)
					{
					BlueIcon[BlueIdx].GotoAndPlayI(1);
					if(PRI.bIsFocus)
					  TempIcon.GotoAndStopI(3);
					}
				BlueIcon[BlueIdx].SetPosition(144+dv.X,113+dv.Y);
				BlueIcon[BlueIdx].SetFloat("_rotation",d);

				BlueIdx++;
				break;
			}
		}
	   }
	}
}

// Gives the result as an angle between - 180 and 180
function float AngleClamp180(float angle)
{
	local float angleFrac;

	angleFrac = angle / 360.0;
	angle = (angleFrac - ffloor(angleFrac)) * 360.0;
	if (angle > 180.0)
		return angle - 360.0;
	return angle;
}

