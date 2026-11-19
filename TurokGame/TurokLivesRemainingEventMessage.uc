class TurokLivesRemainingEventMessage extends TurokGameEventMessage
    transient;

const LIVES_REMAINING_MARKER = "%d";

function bool GetIsValid()
{
    // End:0x5B
    if(((mController.WorldInfo.GRI != none) && mController.WorldInfo.GRI.MaxLives > 0) && IsClientForPlayer(mPRI1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function string GetText()
{
    local string livesRemainingText, Text;
    local @NULL turokPRI;

    turokPRI = TurokMPPlayerReplicationInfo(mPRI1);
    // End:0x69
    if(turokPRI == none)
    {
        Text = "Error -  TurokLivesRemainingEventMessage::GetText() - mPRI1 == none";        
    }
    else
    {
        // End:0xEC
        if(turokPRI.NumLives > 0)
        {
            // End:0xB2
            if(turokPRI.NumLives > 1)
            {
                livesRemainingText = Class'TurokEngine.TurokUI'.static.GetLocalizedString(386626198);                
            }
            else
            {
                livesRemainingText = Class'TurokEngine.TurokUI'.static.GetLocalizedString(240466175);
            }
            Text = Repl(livesRemainingText, "%d", string(mSwitch));            
        }
        else
        {
            Text = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-96345959);
        }
    }
    return Text;
    //return ReturnValue;    
}
