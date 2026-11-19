//-----------------------------------------------------------
// Use HUD By GFx
//-----------------------------------------------------------
class HDHUDGFx extends TMHUD;

var   HDGFxExitMenu   ExitMenuMoive;

exec function ShowExitMenu()
{
    // Toggle ExitMmenu
    ToggleExitMenu();
}

function ToggleExitMenu()
{
    if ( ExitMenuMoive != none && ExitMenuMoive.bMovieIsOpen && !PlayerOwner.IsDead())
    {
        PlayerOwner.SetPause(false);
        ExitMenuMoive.Close(false);
    }
    else
    {
        //CloseOtherMenus();

        PlayerOwner.SetPause(True);

        if (ExitMenuMoive == None)
        {
            ExitMenuMoive = new class'HDGFxExitMenu';   //EM class
            ExitMenuMoive.MovieInfo = SwfMovie'HD_FrontEnd.HD_GFx_ExitMenu';
            ExitMenuMoive.bEnableGammaCorrection = FALSE;
            ExitMenuMoive.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
            ExitMenuMoive.SetTimingMode(TM_Real);
        }

        //SetVisible(false);
        ExitMenuMoive.Start();
        //ExitMenuMoive.PlayOpenAnimation();
        //ExitMenuMoive.AddFocusIgnoreKey('Escape');
    }
}

event PostRender()
{
    Super.PostRender();
}
