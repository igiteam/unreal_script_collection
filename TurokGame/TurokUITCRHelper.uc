class TurokUITCRHelper extends Object
    native;

// Export UTurokUITCRHelper::execButtonPressed(FFrame&, void* const)
native static function ButtonPressed(int btnPressed);

static event OpenTCRMessage(int numButtons, int titleHash, int msgHash, int btn0Hash, int btn1Hash, int btn2Hash, int defaultButton)
{
    local @NULL dlg;

    // DebugMode: 0
    assert(numButtons <= 3);
    dlg = TurokUIDialog(Class'TurokUI'.static.GetEngine().GameViewport.UIController.SceneClient.SceneControllerMgr.FindSceneController("Dialog"));
    dlg.OpenTCRPopup(Class'TurokUI'.static.GetEngine().GameViewport.UIController.SceneClient, numButtons, titleHash, msgHash, btn0Hash, btn1Hash, btn2Hash, Class'TurokUITCRHelper'.ButtonDelegate0, Class'TurokUITCRHelper'.ButtonDelegate1, Class'TurokUITCRHelper'.ButtonDelegate2, defaultButton);
    //return;    
}

static function ButtonDelegate0()
{
    Class'TurokUITCRHelper'.static.ButtonPressed(0);
    //return;    
}

static function ButtonDelegate1()
{
    Class'TurokUITCRHelper'.static.ButtonPressed(1);
    //return;    
}

static function ButtonDelegate2()
{
    Class'TurokUITCRHelper'.static.ButtonPressed(2);
    //return;    
}
