class SkySeqAct_SetXPack extends SequenceAction;

event Activated()
{
    local SkyGame SG;

    SG = SkyGame(GetWorldInfo().Game);
    SG.bXPackInstalled = true;
    //return;    
}
