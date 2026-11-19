class SeqAct_spSetTeamMonsterMachineLevel extends SequenceAction
    native;

event SetTeamHudPercent(SPPawn TargetPawn, byte Percent)
{
    local PandoraGRI GRI;
    local int TeamID;

    // End:0x42
    if(InStr(string(GetWorldInfo().Game.Name), "PandoraMonsterMachine") == -1)
    {
        return;
    }
    GRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x6A
    if(GRI == none)
    {
        return;
    }
    TeamID = int(TargetPawn.Controller.GetTeamNum());
    GRI.SetMonsterMachineValue(TeamID, Percent);
    //return;    
}
