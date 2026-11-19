class UIScene_ObjectiveMessage extends UIScene_BasePDA;

event InitScene()
{
    super.InitScene();
    __OnSceneActivated__Delegate = PostSceneActived;
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    // End:0x10
    if(super.CustomInputKey(EventParms))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}
