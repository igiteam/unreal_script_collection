class AdvGFxHudMP_Last extends AdvGFxHudMP_Team
    config(UI);

function SetHUDElementsVisible(bool Visible)
{
    super.SetHUDElementsVisible(Visible);
    DeathTimerMC.SetVisible(bDeathTimerVisible);
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
