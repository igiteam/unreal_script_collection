class AdvBlessing_HealthRegeneration extends AdvBlessing_Base
    notplaceable
    hidecategories(Navigation);

var int HealthRegenerationModifier;

function Activate()
{
    super.Activate();
    AdvPlayerPawn(OwningPlayer.Pawn).AutoRecoveryHealthDivider /= float(HealthRegenerationModifier);
    //return;    
}

function Deactivate()
{
    AdvPlayerPawn(OwningPlayer.Pawn).AutoRecoveryHealthDivider *= float(HealthRegenerationModifier);
    super.Deactivate();
    //return;    
}

defaultproperties
{
    HealthRegenerationModifier=4
    OnActivateMessageKey="HealthRegenerationActivate"
    BlessingActivationIconPath="ui_advmultiplayer.Textures.t_regenerationcolor_02"
    BlessingHUDIconPath="ui_advmultiplayer.Textures.t_regenerationcolor"
}