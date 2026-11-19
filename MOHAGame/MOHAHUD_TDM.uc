class MOHAHUD_TDM extends MOHAHUD_MP
    transient
    config(Game)
    hidecategories(Navigation);

function DrawHUD()
{
    super.DrawHUD();
    UpdateHudVoip();
    //return;    
}
