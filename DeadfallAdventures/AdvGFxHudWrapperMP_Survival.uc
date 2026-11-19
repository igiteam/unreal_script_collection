class AdvGFxHudWrapperMP_Survival extends AdvGFxHudWrapperMP
    transient
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    AdvPauseMenuClass=Class'AdvGFxUI_PauseMenuSurvival'
    HUDClass=Class'AdvGFxHudMP_Survival'
}