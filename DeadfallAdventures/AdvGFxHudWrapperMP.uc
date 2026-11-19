class AdvGFxHudWrapperMP extends AdvGFxHudWrapper
    transient
    config(Game)
    hidecategories(Navigation);

event PostRender()
{
    super.PostRender();
    // End:0x41
    if(AdvPauseMenuMovie != none)
    {
        AdvPauseMenuMovie.Tick(RenderDelta);
    }
    //return;    
}

defaultproperties
{
    AdvPauseMenuClass=Class'AdvGFxUI_Menu_MultiPause'
    HUDClass=Class'AdvGFxHudMP'
}