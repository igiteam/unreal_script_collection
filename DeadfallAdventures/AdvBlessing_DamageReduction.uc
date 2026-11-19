class AdvBlessing_DamageReduction extends AdvBlessing_Base
    notplaceable
    hidecategories(Navigation);

var float DamageReductionFactor;

function Activate()
{
    super.Activate();
    AdvPlayerPawn(OwningPlayer.Pawn).AbsoluteDamageReductionFactor = DamageReductionFactor;
    //return;    
}

function Deactivate()
{
    AdvPlayerPawn(OwningPlayer.Pawn).AbsoluteDamageReductionFactor = 1.0000000;
    super.Deactivate();
    //return;    
}

defaultproperties
{
    DamageReductionFactor=0.4000000
    OnActivateMessageKey="DamageReductionActivate"
    BlessingActivationIconPath="ui_advmultiplayer.Textures.t_shieldcolor_02"
    BlessingHUDIconPath="ui_advmultiplayer.Textures.t_shieldcolor"
}