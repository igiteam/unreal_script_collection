class UIScene_PDALoading extends UIScene_BaseFrontEnd
    native;

event InitScene()
{
    super.InitScene();
    // End:0x37
    if((myGameInfo != none) && myGameInfo.IsInShellLevel(CurrLevelName))
    {
        bPauseGameWhileActive = false;
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    return true;
    //return ReturnValue;    
}

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    //return;    
}
