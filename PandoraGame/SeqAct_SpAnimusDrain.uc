class SeqAct_SpAnimusDrain extends SeqAct_Latent
    native;

enum AnimusDrainObjectList
{
    DEVICENONE,                     // 0
    EMPDEVICE,                      // 1
    LEFEYDEVICE,                    // 2
    AnimusDrainObjectList_MAX       // 3
};

var int Amount;
var float Rate;
var int Maximum;
var float DeltaAccum;
var float scaleValue;
var bool bReleaseActivated;
var() bool bInitDrainedValuesToZero;
var() SeqAct_SpAnimusDrain.AnimusDrainObjectList AnimusDrainObject;
var Actor AnimusDrainTarget;
var MaterialInstanceConstant TargetMaterialInstance;

event AccumulatePoints(PlayerPawn Player, int Points)
{
    local SPPointEventAnimusBanked bankedEvent;
    local PandoraGameInfo theGameInfo;
    local PandoraGRI PGRI;

    // End:0x12
    if(int(AnimusDrainObject) != int(0))
    {
        return;
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x53
    if((PGRI != none) && PGRI.IsInPostGame())
    {
        return;
    }
    bankedEvent = Class'SPPointEventAnimusBanked'.static.CreateSPPointEventAnimusBanked(Player.Controller, Points);
    // End:0xCB
    if(bankedEvent != none)
    {
        theGameInfo = PandoraGameInfo(GetWorldInfo().Game);
        // End:0xCB
        if(theGameInfo != none)
        {
            theGameInfo.RegisterPointEvent(bankedEvent);
        }
    }
    //return;    
}
