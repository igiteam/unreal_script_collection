class AdvBlessing_SilentWalk extends AdvBlessing_Base
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
    OnActivateMessageKey="SilentWalkActivate"
    BlessingActivationIconPath="UI_AdvCommon.Textures.Blank"
}