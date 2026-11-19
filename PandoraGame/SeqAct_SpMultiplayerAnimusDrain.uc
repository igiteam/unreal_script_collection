class SeqAct_SpMultiplayerAnimusDrain extends SeqAct_Latent
    native;

var int Amount;
var float Rate;
var int Maximum;
var float DeltaAccum;
var float scaleValue;
var bool bReleaseActivated;
var bool bPreviouslyDraining;
var() bool bInitDrainedValuesToZero;
var Actor AnimusDrainTarget;
var MaterialInstanceConstant TargetMaterialInstance;
var array<Object> TargetVarsMP;

event AccumulatePoints(PlayerPawn Player, int Points)
{
    local SPPointEventAnimusBanked bankedEvent;
    local PandoraGameInfo theGameInfo;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x41
    if((PGRI != none) && PGRI.IsInPostGame())
    {
        return;
    }
    bankedEvent = Class'SPPointEventAnimusBanked'.static.CreateSPPointEventAnimusBanked(Player.Controller, Points);
    // End:0xB9
    if(bankedEvent != none)
    {
        theGameInfo = PandoraGameInfo(GetWorldInfo().Game);
        // End:0xB9
        if(theGameInfo != none)
        {
            theGameInfo.RegisterPointEvent(bankedEvent);
        }
    }
    //return;    
}
