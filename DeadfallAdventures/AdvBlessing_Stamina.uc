class AdvBlessing_Stamina extends AdvBlessing_Base
    notplaceable
    hidecategories(Navigation);

var float BonusStaminaModifier;

function Activate()
{
    local AdvPlayerPawn PPawn;

    super.Activate();
    PPawn = AdvPlayerPawn(OwningPlayer.Pawn);
    // End:0x86
    if(PPawn.bUseStamina)
    {
        PPawn.StaminaDecreaseAmount /= BonusStaminaModifier;
    }
    // End:0xD1
    if(PPawn.bUseJumpStamina)
    {
        PPawn.JumpStaminaCost /= BonusStaminaModifier;
    }
    //return;    
}

function Deactivate()
{
    local AdvPlayerPawn PPawn;

    PPawn = AdvPlayerPawn(OwningPlayer.Pawn);
    // End:0x7C
    if(PPawn.bUseStamina)
    {
        PPawn.StaminaDecreaseAmount *= BonusStaminaModifier;
    }
    // End:0xC7
    if(PPawn.bUseJumpStamina)
    {
        PPawn.JumpStaminaCost *= BonusStaminaModifier;
    }
    super.Deactivate();
    //return;    
}

defaultproperties
{
    BonusStaminaModifier=8.0000000
    OnActivateMessageKey="StaminaActivate"
    BlessingActivationIconPath="ui_advmultiplayer.Textures.t_staminacolor_02"
    BlessingHUDIconPath="ui_advmultiplayer.Textures.t_staminacolor"
}