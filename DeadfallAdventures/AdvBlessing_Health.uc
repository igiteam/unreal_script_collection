class AdvBlessing_Health extends AdvBlessing_Base
    notplaceable
    hidecategories(Navigation);

var int HealthBonus;

function Activate()
{
    super.Activate();
    OwningPlayer.Pawn.Health += HealthBonus;
    //return;    
}

function Deactivate()
{
    OwningPlayer.Pawn.Health = int(FClamp(float(OwningPlayer.Pawn.Health), 1.0000000, float(OwningPlayer.Pawn.HealthMax)));
    super.Deactivate();
    //return;    
}

defaultproperties
{
    HealthBonus=200
    OnActivateMessageKey="AdditionalHealthActivate"
    BlessingActivationIconPath="ui_advmultiplayer.Textures.t_healthcolor_02"
    BlessingHUDIconPath="ui_advmultiplayer.Textures.t_healthcolor"
}