class ScoreBoard extends HUD
    transient
    config(Game)
    notplaceable
    hidecategories(lighting);

var bool bDisplayMessages;

function DrawHUD()
{
    UpdateGRI();
    UpdateScoreBoard();
    return;
}

function bool UpdateGRI()
{
    // End:0x16
    if(WorldInfo.GRI == none)
    {
        return false;
    }
    WorldInfo.GRI.SortPRIArray();
    return true;
    return;
}

simulated function string FormatTime(int Seconds)
{
    local int Minutes, Hours;
    local string Time;

    // End:0x46
    if(Seconds > 3600)
    {
        Hours = Seconds / 3600;
        Seconds -= (Hours * 3600);
        Time = string(Hours) $ ":";
    }
    Minutes = Seconds / 60;
    Seconds -= (Minutes * 60);
    // End:0x8D
    if(Minutes >= 10)
    {
        Time = (Time $ string(Minutes)) $ ":";        
    }
    else
    {
        Time = ((Time $ "0") $ string(Minutes)) $ ":";
    }
    // End:0xCE
    if(Seconds >= 10)
    {
        Time = Time $ string(Seconds);        
    }
    else
    {
        Time = (Time $ "0") $ string(Seconds);
    }
    return Time;
    return;
}

simulated function UpdateScoreBoard()
{
    return;
}

simulated function ChangeState(bool bIsVisible)
{
    return;
}
