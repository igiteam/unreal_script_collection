class AdvGFxHudMP_Team extends AdvGFxHudMP
    config(UI);

var int LastRedScore;
var int LastBlueScore;
var float LastScoreDiff;
var byte RedTeamIndex;
var byte BlueTeamIndex;

function SetHUDElementsVisible(bool Visible)
{
    super.SetHUDElementsVisible(Visible);
    RedTeamMC.SetVisible(Visible);
    BlueTeamMC.SetVisible(Visible);
    //return;    
}

function TickHud(float DeltaTime)
{
    local AdvPlayerController PC;
    local float ScoreDiff;

    PC = AdvPlayerController(GetPC());
    // End:0x2E
    if(PC == none)
    {
        return;
    }
    // End:0x9C4
    if(GRI != none)
    {
        RedTeamMC.SetVisible(true);
        BlueTeamMC.SetVisible(true);
        // End:0x28D
        if(float(LastRedScore) != GRI.Teams[int(RedTeamIndex)].Score)
        {
            // End:0x1DF
            if(class<AdvGameCTFBase>(GRI.GameClass) != none)
            {
                LastRedScore = AdvTeamInfo(GRI.Teams[int(RedTeamIndex)]).CapturedFlags;
                RedTeamNameTF.SetText((string(AdvTeamInfo(GRI.Teams[int(RedTeamIndex)]).CapturedFlags) $ "/") $ string(GRI.GoalScore));                
            }
            else
            {
                LastRedScore = int(GRI.Teams[int(RedTeamIndex)].Score);
                RedTeamNameTF.SetText(string(int(GRI.Teams[int(RedTeamIndex)].Score)));
            }
        }
        // End:0x49D
        if(float(LastBlueScore) != GRI.Teams[int(BlueTeamIndex)].Score)
        {
            // End:0x3EF
            if(class<AdvGameCTFBase>(GRI.GameClass) != none)
            {
                LastBlueScore = AdvTeamInfo(GRI.Teams[int(BlueTeamIndex)]).CapturedFlags;
                BlueTeamNameTF.SetText((string(AdvTeamInfo(GRI.Teams[int(BlueTeamIndex)]).CapturedFlags) $ "/") $ string(GRI.GoalScore));                
            }
            else
            {
                LastBlueScore = int(GRI.Teams[int(BlueTeamIndex)].Score);
                BlueTeamNameTF.SetText(string(int(GRI.Teams[int(BlueTeamIndex)].Score)));
            }
        }
        // End:0x95F
        if(AdvPRI(PC.PlayerReplicationInfo) != none)
        {
            // End:0x6B4
            if(int(AdvPRI(PC.PlayerReplicationInfo).GetTeamNum()) == int(RedTeamIndex))
            {
                RedTeamIndicatorMC.SetVisible(true);
                BlueTeamIndicatorMC.SetVisible(false);
                // End:0x627
                if(class<AdvGameCTFBase>(GRI.GameClass) != none)
                {
                    ScoreDiff = float(AdvTeamInfo(GRI.Teams[int(RedTeamIndex)]).CapturedFlags - AdvTeamInfo(GRI.Teams[int(BlueTeamIndex)]).CapturedFlags);                    
                }
                else
                {
                    ScoreDiff = GRI.Teams[int(RedTeamIndex)].Score - GRI.Teams[int(BlueTeamIndex)].Score;
                }                
            }
            else
            {
                RedTeamIndicatorMC.SetVisible(false);
                BlueTeamIndicatorMC.SetVisible(true);
                // End:0x7C2
                if(class<AdvGameCTFBase>(GRI.GameClass) != none)
                {
                    ScoreDiff = float(AdvTeamInfo(GRI.Teams[int(BlueTeamIndex)]).CapturedFlags - AdvTeamInfo(GRI.Teams[int(RedTeamIndex)]).CapturedFlags);                    
                }
                else
                {
                    ScoreDiff = GRI.Teams[int(BlueTeamIndex)].Score - GRI.Teams[int(RedTeamIndex)].Score;
                }
            }
            // End:0x95C
            if(ScoreDiff != LastScoreDiff)
            {
                LastScoreDiff = ScoreDiff;
                // End:0x8CA
                if(ScoreDiff > 0.0000000)
                {
                    WinningTF.SetText(Class'AdvGFxUI_Scoreboard'.default.WinningText);                    
                }
                else
                {
                    // End:0x91E
                    if(ScoreDiff == 0.0000000)
                    {
                        WinningTF.SetText(Class'AdvGFxUI_Scoreboard'.default.DrawText);                        
                    }
                    else
                    {
                        WinningTF.SetText(Class'AdvGFxUI_Scoreboard'.default.LosingText);
                    }
                }
            }            
        }
        else
        {
            WinningTF.SetText("");
            RedTeamIndicatorMC.SetVisible(false);
            BlueTeamIndicatorMC.SetVisible(false);
        }        
    }
    else
    {
        RedTeamMC.SetVisible(false);
        BlueTeamMC.SetVisible(false);
    }
    super.TickHud(DeltaTime);
    //return;    
}

defaultproperties
{
    LastRedScore=-1000
    LastBlueScore=-1000
    LastScoreDiff=-1000.0000000
    BlueTeamIndex=1
}