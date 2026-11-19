class AdvBlessing_Speed extends AdvBlessing_Base
    notplaceable
    hidecategories(Navigation);

var float BonusSpeedModifier;

function Activate()
{
    super.Activate();
    AdvPlayerPawn(OwningPlayer.Pawn).GroundSpeed *= BonusSpeedModifier;
    //return;    
}

function Deactivate()
{
    AdvPlayerPawn(OwningPlayer.Pawn).GroundSpeed /= BonusSpeedModifier;
    super.Deactivate();
    //return;    
}

defaultproperties
{
    BonusSpeedModifier=2.0000000
    BlessingActivationIconPath="UI_AdvCommon.Textures.Blank"
}