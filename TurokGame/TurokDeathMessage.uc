class TurokDeathMessage extends TurokCommentaryMessage
    transient;

function string GetText()
{
    local string Text;

    return "";
    // End:0x16
    if(class<DamageType>(mObject) == none)
    {
        return "";
    }
    // End:0x87
    if((mPRI1 == none) || mPRI1 == mPRI2)
    {
        Text = Class'Engine.GameInfo'.static.ParseKillMessage(mPRI2.PlayerName, mPRI2.PlayerName, class<DamageType>(mObject).static.SuicideMessage(mPRI2));        
    }
    else
    {
        Text = Class'Engine.GameInfo'.static.ParseKillMessage(mPRI1.PlayerName, mPRI2.PlayerName, class<DamageType>(mObject).static.DeathMessage(mPRI1, mPRI2));
    }
    // End:0x17B
    if(mSwitch != 0)
    {        
        Text $= "[ ";
        // End:0x120
        if((mSwitch & 1) != 0)
        {            
            Text $= "Headshot ";
        }
        // End:0x146
        if((mSwitch & 2) != 0)
        {            
            Text $= "Stealth ";
        }
        // End:0x16B
        if((mSwitch & 4) != 0)
        {            
            Text $= "Primal ";
        }        
        Text $= "]";
    }
    return Text;
    //return ReturnValue;    
}
