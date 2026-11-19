class MOHAScoreboard extends ScoreBoard
    transient
    config(Game)
    hidecategories(Navigation);

var UIScene ScoreboardScene;
var UIScene OpenedScene;

function DrawHUD()
{
    //return;    
}

function OpenScoreboard()
{
    local UIInteraction UIController;

    // End:0x45
    if(PlayerOwner != none)
    {
        UIController = PlayerOwner.GetUIController();
        // End:0x45
        if(UIController != none)
        {
            UIController.OpenScene(ScoreboardScene, none, OpenedScene);
        }
    }
    //return;    
}

function CloseScoreboard()
{
    local UIInteraction UIController;

    // End:0x3F
    if(PlayerOwner != none)
    {
        UIController = PlayerOwner.GetUIController();
        // End:0x3F
        if(UIController != none)
        {
            UIController.CloseScene(OpenedScene);
        }
    }
    //return;    
}

function FindAndCloseScoreboard()
{
    local UIInteraction UIController;
    local UIScene SceneToClose;

    // End:0x63
    if(PlayerOwner != none)
    {
        UIController = PlayerOwner.GetUIController();
        // End:0x63
        if(UIController != none)
        {
            SceneToClose = UIController.FindSceneByTag(ScoreboardScene.SceneTag);
            UIController.CloseScene(SceneToClose);
        }
    }
    //return;    
}

function ChangeState(bool bIsVisible)
{
    // End:0x16
    if(bIsVisible)
    {
        OpenScoreboard();        
    }
    else
    {
        // End:0x2E
        if(OpenedScene != none)
        {
            CloseScoreboard();            
        }
        else
        {
            FindAndCloseScoreboard();
        }
    }
    super.ChangeState(bIsVisible);
    //return;    
}
