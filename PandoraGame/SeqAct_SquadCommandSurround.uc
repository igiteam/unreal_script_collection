class SeqAct_SquadCommandSurround extends SequenceAction
    native;

/** Type of squad to select name from */
var() export editinline SPSquadSelector SquadType;
var() SPSquad.ESPSquadCommandPriority commandPriority;

function bool ScriptActivated()
{
    return true;
    //return ReturnValue;    
}
