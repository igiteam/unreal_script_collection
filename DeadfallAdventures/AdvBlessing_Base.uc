class AdvBlessing_Base extends Actor
    notplaceable
    hidecategories(Navigation);

var int Lifetime;
var float ActivateDelay;
var AdvPlayerControllerMP OwningPlayer;
var string OnActivateMessageKey;
var string BlessingActivationIconPath;
var string BlessingHUDIconPath;
var Texture2D BlessingIcon;

function PreActivate()
{
    ((ActivateDelay > 0.0000000) ? SetTimer(ActivateDelay, false, 'Activate') : Activate());
    //return;    
}

function Activate()
{
    // End:0x11
    if(OwningPlayer == none)
    {
        return;
    }
    OwningPlayer.SetBlessingMessage(Class'ADVGame'.static.ConvertToLocalizedString("AdvBlessings", OnActivateMessageKey, "ADVGame"), self.Class);
    // End:0xE8
    if(AdvGRI(WorldInfo.GRI).CanWriteStats())
    {
        OwningPlayer.IncrementGlobalIntStat(124);
    }
    // End:0x110
    if(Lifetime != 0)
    {
        SetTimer(float(Lifetime), false, 'Deactivate');
    }
    //return;    
}

function Deactivate()
{
    // End:0x2B
    if(IsTimerActive('Deactivate'))
    {
        ClearTimer('Deactivate');
    }
    OwningPlayer.RemoveBlessing(self);
    Destroy();
    //return;    
}

function SetOwningPlayer(AdvPlayerControllerMP Player)
{
    OwningPlayer = Player;
    //return;    
}
