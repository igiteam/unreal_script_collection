class UIScene_DMOnlineMatchSetup extends UIScene_NetworkScene;

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    // End:0x0D
    if(myGameInfo == none)
    {
        return;
    }
    // End:0x4A
    if(MenuIndex == (MenuIndexByName("btnCreateMatch")))
    {
        myGameInfo.CreateOnlineSession();        
    }
    else
    {
        // End:0x81
        if(MenuIndex == (MenuIndexByName("btnQuickMatch")))
        {
            myGameInfo.JoinFirstOnlineSession();
        }
    }
    //return;    
}
