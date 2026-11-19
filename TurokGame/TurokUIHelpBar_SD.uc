class TurokUIHelpBar_SD extends TurokUIHelpBar
    native;

function Initialize(@NULL pScene, @NULL pSceneClient)
{
    super.Initialize(pScene, pSceneClient);
    //return;    
}

defaultproperties
{
    mStaticReferenceScene=UIScene'TurokFEHelpBar_SD.HelpBar'
    mXBox360ButtonArt[0]=Texture2D'TurokFEHelpBar_SD.Help_360_StickR_push'
    mXBox360ButtonArt[1]=Texture2D'TurokFEHelpBar_SD.help_360_A'
    mXBox360ButtonArt[2]=Texture2D'TurokFEHelpBar_SD.help_360_B'
    mXBox360ButtonArt[3]=Texture2D'TurokFEHelpBar_SD.help_360_X'
    mXBox360ButtonArt[4]=Texture2D'TurokFEHelpBar_SD.help_360_Y'
    mXBox360ButtonArt[5]=Texture2D'TurokFEHelpBar_SD.Help_360_LTRT'
    mXBox360ButtonArt[6]=Texture2D'TurokFEHelpBar_SD.Help_360_LB'
    mXBox360ButtonArt[7]=Texture2D'TurokFEHelpBar_SD.Help_360_RB'
    mXBox360ButtonArt[8]=Texture2D'TurokFEHelpBar_SD.Help_360_Start'
    mPS3ButtonArt[0]=Texture2D'TurokFEHelpBar_SD.Help_PS3_R3'
    mPS3ButtonArt[1]=Texture2D'TurokFEHelpBar_SD.Help_PS3_X'
    mPS3ButtonArt[2]=Texture2D'TurokFEHelpBar_SD.Help_PS3_Circle'
    mPS3ButtonArt[3]=Texture2D'TurokFEHelpBar_SD.Help_PS3_Square'
    mPS3ButtonArt[4]=Texture2D'TurokFEHelpBar_SD.Help_PS3_Triangle'
    mPS3ButtonArt[5]=Texture2D'TurokFEHelpBar_SD.Help_PS3_L2R2'
    mPS3ButtonArt[6]=Texture2D'TurokFEHelpBar_SD.Help_PS3_L1'
    mPS3ButtonArt[7]=Texture2D'TurokFEHelpBar_SD.Help_PS3_R1'
    mPS3ButtonArt[8]=Texture2D'TurokFEHelpBar_SD.Help_PS3_Start'
    SceneName="TurokFEHelpBar_SD.HelpBar"
}