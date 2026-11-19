class SkyTeamScoreboard extends SkyScoreboard
    config(Game);

var Color PlayerColor;
var Color LastKillerColor;

function DrawHUD()
{
    local int I, ItemsPerPage, Count;
    local GameReplicationInfo GRI;
    local float LeftPos, TopPos, CenterXPos, Width, Height, XL,
	    YL, W, H, Scale;

    local string Str, scrollmsg;
    local array<int> RedList, BlueList;

    GRI = WorldInfo.GRI;
    // End:0x22
    if(GRI == none)
    {
        return;
    }
    WorldInfo.GRI.SortPRIArray();
    Scale = Canvas.ClipX / float(1024);
    I = 0;
    J0x65:

    // End:0x10F [Loop If]
    if(I < GRI.PRIArray.Length)
    {
        // End:0x105
        if(!GRI.PRIArray[I].bIsSpectator)
        {
            switch(GRI.PRIArray[I].Team.TeamIndex)
            {
                // End:0xE9
                case 0:
                    RedList[RedList.Length] = I;
                    // End:0x105
                    break;
                // End:0x102
                case 1:
                    BlueList[BlueList.Length] = I;
                    // End:0x105
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
            I++;
            // [Loop Continue]
            goto J0x65;
        }/* !MISMATCHING REMOVE, tried Loop got Type:Else Position:0x105! */
        LeftPos = Canvas.ClipX * 0.0500000;
        TopPos = Canvas.ClipY * 0.1500000;
        Width = Canvas.ClipX * 0.9000000;
        Height = Canvas.ClipY * 0.8200000;
        Canvas.Font = Class'Engine.Engine'.static.GetLargeFont();
        Str = GRI.GameClass.default.GameName;
        Canvas.StrLen(Str, XL, YL);
        Canvas.SetPos((Canvas.ClipX * 0.5000000) - (XL * 0.5000000), 5.0000000);
        Canvas.DrawText(Str);
        Canvas.SetDrawColor(0, 0, 0, 128);
        Canvas.SetPos(LeftPos, TopPos);
        Canvas.DrawTile(Canvas.DefaultTexture, Width, Height, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
        Canvas.SetPos(LeftPos + float(2), TopPos + float(2));
        Canvas.SetDrawColor(255, 255, 0, 255);
        Canvas.DrawBox(Width - float(4), Height - float(4));
        // End:0x431
        if(PlayerOwner.IsInState('Dead'))
        {
            Canvas.SetDrawColor(255, 255, 255, 255);
            Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
            scrollmsg = "Respawn expected in " $ string(int(PlayerOwner.GetTimerRate('ServerRestartPlayer') - PlayerOwner.GetTimerCount('ServerRestartPlayer')));
            Canvas.StrLen(scrollmsg, W, H);
            Canvas.SetPos((Canvas.ClipX * 0.5000000) - (W * 0.5000000), ((TopPos + Height) - H) - float(3));
            Canvas.DrawText(scrollmsg);
        }
        Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
        LeftPos += (float(64) * Scale);
        TopPos += (float(32) * Scale);
        Width -= (float(128) * Scale);
        Height -= (float(48) * Scale);
        CenterXPos = LeftPos + (Width * 0.5000000);
        Canvas.StrLen(string('99'), XL, YL);
        Canvas.DrawColor = GRI.Teams[0].GetTextColor();
        Canvas.SetPos(LeftPos, TopPos);
        Canvas.DrawText(GRI.Teams[0].GetHumanReadableName());
        Canvas.DrawColor = GRI.Teams[1].GetTextColor();
        Canvas.SetPos(CenterXPos + (float(32) * Scale), TopPos);
        Canvas.DrawText(GRI.Teams[1].GetHumanReadableName());
        Canvas.SetDrawColor(0, 192, 0);
        Canvas.SetPos(((CenterXPos - (float(32) * Scale)) - XL) - XL, TopPos);
        Canvas.DrawText("" $ string(int(GRI.Teams[0].Score)));
        Canvas.SetPos(((LeftPos + Width) - XL) - XL, TopPos);
        Canvas.DrawText("" $ string(int(GRI.Teams[1].Score)));
        TopPos += (XL * 1.1000000);
        Height -= (XL * 1.1000000);
        ItemsPerPage = int(Height / (YL * 1.1000000));
        Count = RedList.Length;
        // End:0x732
        if(Count < BlueList.Length)
        {
            Count = BlueList.Length;
        }
        // End:0x758
        if((ScrollTop < 0) || Count <= ItemsPerPage)
        {
            ScrollTop = 0;            
        }
        else
        {
            // End:0x780
            if((ScrollTop + ItemsPerPage) > Count)
            {
                ScrollTop = Count - ItemsPerPage;
            }
        }
        I = 0;
        J0x787:

        // End:0x873 [Loop If]
        if(I < ItemsPerPage)
        {
            // End:0x7FC
            if((ScrollTop + I) < RedList.Length)
            {
                DrawCol(LeftPos, CenterXPos - (float(32) * Scale), TopPos + ((float(I) * YL) * 1.1000000), RedList[ScrollTop + I]);
            }
            // End:0x869
            if((ScrollTop + I) < BlueList.Length)
            {
                DrawCol(CenterXPos + (float(32) * Scale), LeftPos + Width, TopPos + ((float(I) * YL) * 1.1000000), BlueList[ScrollTop + I]);
            }
            I++;
            // [Loop Continue]
            goto J0x787;
        }
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:Loop Position:0x065! */
}

simulated function DrawCol(float X1, float X2, float Y, int Index)
{
    local float XL, YL;
    local string S;
    local SkyPlayerReplicationInfo PRI;

    PRI = SkyPlayerReplicationInfo(WorldInfo.GRI.PRIArray[Index]);
    // End:0x37
    if(PRI == none)
    {
        return;
    }
    Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
    Canvas.DrawColor = PRI.Team.GetTextColor();
    Canvas.SetPos(X1, Y);
    Canvas.DrawText(PRI.PlayerName);
    S = "" $ string(int(PRI.Score));
    Canvas.SetDrawColor(0, 192, 0);
    Canvas.StrLen(S, XL, YL);
    Canvas.SetPos(X2 - XL, Y);
    Canvas.DrawText(S);
    X2 = X2 - XL;
    Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
    // End:0x233
    if(PRI == PlayerOwner.PlayerReplicationInfo)
    {
        Canvas.StrLen("ME", XL, YL);
        Canvas.DrawColor = PlayerColor;
        Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
        Canvas.SetPos(X2 - XL, Y + (YL / float(2)));
        Canvas.DrawText("ME");
    }
    // End:0x315
    if((SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo) != none) && PRI == SkyPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).LastKillerPRI)
    {
        Canvas.StrLen("LAST KILLER", XL, YL);
        Canvas.DrawColor = LastKillerColor;
        Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
        Canvas.SetPos(X2 - XL, Y);
        Canvas.DrawText("LAST KILLER");
    }
    // End:0x3BD
    if(PRI.LastKillerPRI == PlayerOwner.PlayerReplicationInfo)
    {
        Canvas.StrLen("LAST TARGET", XL, YL);
        Canvas.DrawColor = LastKillerColor;
        Canvas.SetPos(X2 - XL, Y + YL);
        Canvas.DrawText("LAST TARGET");
    }
    //return;    
}
