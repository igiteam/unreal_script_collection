class AdvBlessing_Mummy extends AdvBlessing_Base
    notplaceable
    hidecategories(Navigation);

function Activate()
{
    local AdvPerk_Base PB;

    super.Activate();
    PB = Spawn(AdvGameMP_Base(WorldInfo.Game).PerkManager.Perks[3]);
    PB.ActivatePerk(OwningPlayer);
    PB.Destroy();
    //return;    
}

function Deactivate()
{
    super.Deactivate();
    //return;    
}

defaultproperties
{
    OnActivateMessageKey="MummyModeActivate"
    BlessingActivationIconPath="ui_advmultiplayer.Textures.t_mummycolor_02"
}