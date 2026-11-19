class UIScene_PandoraLobbyMP extends UIScene_MPMenu
    config(Game);

function AssignOptionButtons()
{
    btnOption[0] = UILabelButton(FindChild('btnOption01', true));
    btnOption[1] = UILabelButton(FindChild('btnOption02', true));
    btnOption[2] = UILabelButton(FindChild('btnOption03', true));
    btnOption[3] = UILabelButton(FindChild('btnOption04', true));
    btnOption[4] = UILabelButton(FindChild('btnOption05', true));
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    myPC.PlayAmBxScript("menu_mpmap_whole", 0);
    super(UIScene_BaseFrontEnd).SceneActivated(bInitialActivation);
    //return;    
}

event SceneDeactivated()
{
    myPC.StopAmBxScript("menu_mpmap_whole");
    super.SceneDeactivated();
    //return;    
}
