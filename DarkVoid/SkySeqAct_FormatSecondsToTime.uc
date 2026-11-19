class SkySeqAct_FormatSecondsToTime extends SequenceAction;

var() bool bForceHours;
var() bool bForceMinutes;
var() bool bUseFractionalSeconds;
var() string separator;

event Activated()
{
    local float secondsIn;
    local int hours, minutes, Seconds;
    local float fseconds;
    local string szOut;
    local SeqVar_Float svf;
    local SeqVar_String svs;

    super(SequenceOp).Activated();
    svf = SeqVar_Float(VariableLinks[0].LinkedVariables[0]);
    // End:0x32
    if(svf == none)
    {
        return;
    }
    secondsIn = svf.FloatValue;
    hours = int(secondsIn / float(3600));
    secondsIn -= float(hours * 3600);
    minutes = int(secondsIn / float(60));
    secondsIn -= float(minutes * 60);
    Seconds = int(secondsIn);
    fseconds = secondsIn;
    // End:0x100
    if((hours > 1) || bForceHours)
    {
        // End:0xDA
        if(hours < 10)
        {
            szOut = "0";
        }
        szOut = szOut $ string(hours);
        szOut = szOut $ separator;
    }
    // End:0x15A
    if(((hours > 1) || minutes > 1) || bForceMinutes)
    {
        // End:0x13F
        if(minutes < 10)
        {
            szOut = szOut $ "0";
        }
        szOut = (szOut $ string(minutes)) $ separator;
    }
    // End:0x176
    if(Seconds < 10)
    {
        szOut = szOut $ "0";
    }
    // End:0x196
    if(bUseFractionalSeconds)
    {
        szOut = szOut $ string(fseconds);        
    }
    else
    {
        szOut = szOut $ string(Seconds);
    }
    svs = SeqVar_String(VariableLinks[1].LinkedVariables[0]);
    // End:0x1D6
    if(svs == none)
    {
        return;
    }
    svs.StrValue = szOut;
    //return;    
}
