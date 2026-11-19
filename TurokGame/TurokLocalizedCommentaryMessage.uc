class TurokLocalizedCommentaryMessage extends TurokCommentaryMessage
    transient;

function string GetText()
{
    return Class'TurokEngine.TurokUI'.static.GetLocalizedString(mSwitch);
    //return ReturnValue;    
}
