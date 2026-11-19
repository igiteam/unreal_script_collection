class AdvBlessing_SecondChance extends AdvBlessing_Base
    notplaceable
    hidecategories(Navigation);

function Activate()
{
    super.Activate();
    OwningPlayer.bSecondChanceEnabled = true;
    //return;    
}

function Deactivate()
{
    super.Deactivate();
    OwningPlayer.bSecondChanceEnabled = false;
    //return;    
}

defaultproperties
{
    OnActivateMessageKey="SecondchanceActivate"
    BlessingActivationIconPath="ui_advmultiplayer.Textures.t_secondcolor_02"
    BlessingHUDIconPath="ui_advmultiplayer.Textures.t_secondcolor"
}