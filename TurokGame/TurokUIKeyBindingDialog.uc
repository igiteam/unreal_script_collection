class TurokUIKeyBindingDialog extends TurokUIDialog
    native;

var name bindingKey;
//var delegate<@NULL> __ButtonKeyAction__Delegate;

// Export UTurokUIKeyBindingDialog::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event OpenKeyBindingTCRPopup(@NULL scene_client, int titleHash, int messageHash, delegate<@NULL> delFunc)
{
    local @NULL myDlgInstance;

    // End:0x29
    if(Class'TurokUI'.static.IsSD())
    {
        myDlgInstance = new (self) Class'TurokUIKeyBindingDialog_TCR';        
    }
    else
    {
        myDlgInstance = new (self) Class'TurokUIKeyBindingDialog_TCR';
    }
    myDlgInstance.PlaySound(true);
    myDlgInstance.__ButtonKeyAction__Delegate = delFunc;
    myDlgInstance.ShowZeroButton(scene_client, titleHash, messageHash, 6, myDlgInstance);
    //return;    
}

event OpenKeyBindingPopup(@NULL scene_client, int titleHash, int messageHash, delegate<@NULL> delFunc, optional bool alwaysAllowInput = false)
{
    local @NULL myDlgInstance;

    // End:0x2E
    if(Class'TurokUI'.static.IsSD())
    {
        myDlgInstance = new (self) Class'TurokUIKeyBindingDialog';        
    }
    else
    {
        myDlgInstance = new (self) Class'TurokUIKeyBindingDialog';
    }
    myDlgInstance.PlaySound(true);
    myDlgInstance.__ButtonKeyAction__Delegate = delFunc;
    myDlgInstance.ShowZeroButton(scene_client, titleHash, messageHash, 2, myDlgInstance, alwaysAllowInput);
    //return;    
}

event OpenKeyBindingPopupStr(@NULL scene_client, string Title, string Message, delegate<@NULL> delFunc)
{
    local @NULL myDlgInstance;

    // End:0x29
    if(Class'TurokUI'.static.IsSD())
    {
        myDlgInstance = new (self) Class'TurokUIKeyBindingDialog';        
    }
    else
    {
        myDlgInstance = new (self) Class'TurokUIKeyBindingDialog';
    }
    myDlgInstance.PlaySound(true);
    myDlgInstance.__ButtonKeyAction__Delegate = delFunc;
    myDlgInstance.ShowZeroButtonStr(scene_client, Title, Message, 2, myDlgInstance);
    //return;    
}

delegate ButtonKeyAction(name buttonName)
{
    //return;    
}

function InitComplete()
{
    SceneClient.Outer.Outer.ViewportConsole.EnableConsole(false);
    super.InitComplete();
    bBlockInput = false;
    //return;    
}

function ExitComplete()
{
    SceneClient.Outer.Outer.ViewportConsole.EnableConsole(true);
    super.ExitComplete();
    ButtonKeyAction(bindingKey);
    __ButtonKeyAction__Delegate = None;
    //return;    
}
