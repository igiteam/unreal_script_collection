class SeqAct_ClearAllSquadCommands extends SequenceAction
    native;

/** VARIABLE DECLARATIONS */
var() bool bDisbandAllSquads;

function bool ScriptActivated()
{
    Class'SPSquad'.static.ClearSquadCommandsForAllSquads(bDisbandAllSquads);
    return true;
    //return ReturnValue;    
}
