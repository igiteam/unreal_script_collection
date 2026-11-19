//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGFxTeamHUD extends HDGFxTweenableMoviePlayer;

var GFxObject RootMC;
var GFxObject PRIAllMC;
var array<GFxObject> PRIMC;
var GameReplicationInfo GRI;
var PlayerReplicationInfo PRI;
var array<GFxObject.ASColorTransform> Cxform;
var GFxObject ServerNameMC;

var PlayerController PC;
var localized array<string> JobName;
var localized array<string> RankName;

var HDTEAMHUD myHUD;

var bool    bShowing;

    function bool Start(optional bool StartPaused = false)
    {
        if( !bShowing )
        {
            super.Start();
            Advance(0);

            RootMC   = GetVariableObject("_root");
            PRIAllMC = RootMC.GetObject("PlayerInfoAll");
            ServerNameMC = RootMC.GetObject("ServerName");

            bShowing = true;
        }

        return TRUE;
    }

    function Stop()
    {
        if( bShowing )
        {
            Close( False );
            bShowing = false;
        }
    }

    function UpdateInfo()
    {
        local int Idx;
        local int RedIdx;
        local int BlueIdx;
        local GFxObject TempO;
        local int JobIndex;

        TempO  = PRIAllMC.GetObject("RedScore");
        RedIdx = GRI.Teams[0].Score;
        TempO.SetText(string(RedIdx));
        TempO  = PRIAllMC.GetObject("BlueScore");
        BlueIdx= GRI.Teams[1].Score;
        TempO.SetText(string(BlueIdx));

        RedIdx =0;
        BlueIdx=0;

        PC =  GetPC();
        GRI = myHUD.WorldInfo.GRI;
        ServerNameMC.SetText("???:" $ GRI.ServerName);
        for(Idx = 0;Idx < PRIMC.Length;Idx++)
        {
          PRIMC[Idx].SetVisible(False);
        }

        for(Idx = 0;Idx < GRI.PRIArray.Length;Idx++ )
        {
            PRI   = GRI.PRIArray[Idx];

            if(PRI.bOnlySpectator || PRI.Team == None)
                Continue;

            if(PRIMC[Idx] == None)
            {
                PRIAllMC.AttachMovie("PIMC","PIMC"$Idx);
            }

            PRIMC[Idx] = PRIAllMC.GetObject("PIMC"$Idx);
            PRIMC[Idx].SetVisible(True);
            TempO = PRIMC[Idx].GetObject("PlayerIdx");
            TempO.SetText(Idx);
            TempO = PRIMC[Idx].GetObject("PlayerName");
            TempO.SetText(PRI.PlayerName);
                if(TGPRI(PRI).bIsDead)
                {
                    TempO.SetColorTransform(Cxform[1]);
                }
                else if(PRI == GetPC().PlayerReplicationInfo)
                {
                    TempO.SetColorTransform(Cxform[2]);
                }
                else
                {
                    TempO.SetColorTransform(Cxform[0]);
                }
            TempO = PRIMC[Idx].GetObject("PlayerJob");
            JobIndex = TMPlayerReplicationInfo(PRI).Character;
            if(JobIndex == 9)
				JobIndex += PRI.Team.TeamIndex;
            TempO.SetText(JobName[JobIndex]);
            TempO = PRIMC[Idx].GetObject("LevelIcon");
            TempO.GotoAndStopI(TMPlayerReplicationInfo(PRI).Rank);
            TempO = PRIMC[Idx].GetObject("PlayerScore");
            TempO.SetText(string(int(PRI.Score)));
            TempO = PRIMC[Idx].GetObject("PlayerKills");
            TempO.SetText(string(PRI.Kills));
            TempO = PRIMC[Idx].GetObject("PlayerDeath");
            TempO.SetText(string(PRI.Deaths));
            TempO = PRIMC[Idx].GetObject("TeamIcon");
            TempO.GotoAndStopI(PRI.Team.TeamIndex+1);

            switch(PRI.Team.TeamIndex)
            {
            case 0:
                PRIMC[Idx].SetPosition(199.5,200+43*RedIdx);
                RedIdx++;
                break;

            case 1:
                PRIMC[Idx].SetPosition(1076.45,200+43*BlueIdx);
                BlueIdx++;
                break;
            }
        }
    }

