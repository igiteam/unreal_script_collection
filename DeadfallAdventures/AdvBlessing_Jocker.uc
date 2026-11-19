class AdvBlessing_Jocker extends AdvBlessing_Base
    notplaceable
    hidecategories(Navigation);

function Activate()
{
    super.Activate();
    //return;    
}

function Deactivate()
{
    super.Deactivate();
    //return;    
}

defaultproperties
{
    OnActivateMessageKey="JockerActivate"
    BlessingActivationIconPath="ui_advmultiplayer.Textures.t_failcolor_02"
}