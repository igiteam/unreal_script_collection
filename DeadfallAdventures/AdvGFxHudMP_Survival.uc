class AdvGFxHudMP_Survival extends AdvGFxHudMP
    config(UI);

function Init(optional LocalPlayer Player)
{
    super.Init(Player);
    // End:0x8B
    if(AdvPRI(GetPC().PlayerReplicationInfo) != none)
    {
        SetKillStreakKillCount(AdvPRI(GetPC().PlayerReplicationInfo).KillStrikePoints[1]);
    }
    //return;    
}

function SetHUDElementsVisible(bool Visible)
{
    super.SetHUDElementsVisible(Visible);
    TimeLeftTF.SetVisible(true);
    TimeLeftTitleTF.SetVisible(true);
    DeathTimerMC.SetVisible(bDeathTimerVisible);
    //return;    
}

function TickHud(float DeltaTime)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
    // End:0x2E
    if(PC == none)
    {
        return;
    }
    super.TickHud(DeltaTime);
    // End:0x212
    if((AdvGRI(GRI) != none) && AdvGRI(GRI).CustomTimer > 0)
    {
        // End:0x20F
        if(LastRemainingTime != AdvGRI(GRI).CustomTimer)
        {
            LastRemainingTime = AdvGRI(GRI).CustomTimer;
            TimeLeftTF.SetText(Class'AdvGFxUI_Scoreboard'.static.FormatTime(AdvGRI(GRI).CustomTimer));
            // End:0x1ED
            if(AdvGRI(GRI).CustomTimerTitleLocKey != "")
            {
                TimeLeftTitleTF.SetText(Localize("CustomTimers", AdvGRI(GRI).CustomTimerTitleLocKey, "ADVGame"));                
            }
            else
            {
                TimeLeftTitleTF.SetText("");
            }
        }        
    }
    else
    {
        TimeLeftTF.SetText("");
        TimeLeftTitleTF.SetText("");
    }
    // End:0x542
    if(PC.Pawn == none)
    {
        // End:0x44B
        if((AdvGRI(GRI) != none) && AdvGRI(GRI).TimerToLastMummy > 0)
        {
            // End:0x448
            if(LastRemainingTime != AdvGRI(GRI).TimerToLastMummy)
            {
                LastRemainingTime = AdvGRI(GRI).TimerToLastMummy;
                TimeLeftTF.SetText(Class'AdvGFxUI_Scoreboard'.static.FormatTime(AdvGRI(GRI).TimerToLastMummy));
                // End:0x426
                if(AdvGRI(GRI).TimerToLastMummyTitleLocKey != "")
                {
                    TimeLeftTitleTF.SetText(Localize("CustomTimers", AdvGRI(GRI).TimerToLastMummyTitleLocKey, "ADVGame"));                    
                }
                else
                {
                    TimeLeftTitleTF.SetText("");
                }
            }            
        }
        else
        {
            TimeLeftTF.SetText("");
            // End:0x520
            if((AdvGRI(GRI) != none) && AdvGRI(GRI).TimerToLastMummyExpiredLocKey != "")
            {
                TimeLeftTitleTF.SetText(Localize("CustomTimers", AdvGRI(GRI).TimerToLastMummyExpiredLocKey, "ADVGame"));                
            }
            else
            {
                TimeLeftTitleTF.SetText("");
            }
        }
    }
    //return;    
}

function ShowDeathTimer()
{
    bDeathTimerVisible = true;
    DeathTimerMC.SetVisible(true);
    DeathTimerTF.SetBool("html", true);
    DeathTimerTF.SetString("htmlText", ParseString("{A}", GetPC()));
    //return;    
}

function HideDeathTimer()
{
    bDeathTimerVisible = false;
    DeathTimerMC.SetVisible(false);
    //return;    
}
