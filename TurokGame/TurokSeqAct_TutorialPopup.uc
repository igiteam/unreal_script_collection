class TurokSeqAct_TutorialPopup extends SequenceAction
    native
    hidecategories(Object);

enum eTutorialPopup
{
    ETP_WeaponZoom,                 // 0
    ETP_AltFire,                    // 1
    ETP_KnifeKills,                 // 2
    ETP_ObjectiveIndicator,         // 3
    ETP_Dodge,                      // 4
    ETP_SniperRifle,                // 5
    ETP_None,                       // 6
    ETP_MAX                         // 7
};

var() byte mPopupType;
var @NULL mPC;
var bool mStopLatent;

event Activated()
{
    local array Objects;
    local @NULL HUD;

    GetObjectVars(Objects);
    // End:0x133
    if((Objects.Length > 0) && Objects[0] != none)
    {
        mPC = TurokPlayerController(Objects[0]);
        // End:0x133
        if(mPC != none)
        {
            HUD = TurokHud(mPC.myHUD);
            switch(mPopupType)
            {
                // End:0x86
                case 0:
                    HUD.ShowTutorialHud(-1981777189, 4);
                    // End:0x133
                    break;
                // End:0xA8
                case 1:
                    HUD.ShowTutorialHud(1931729024, 7);
                    // End:0x133
                    break;
                // End:0xCA
                case 2:
                    HUD.ShowTutorialHud(-2147188334, 6);
                    // End:0x133
                    break;
                // End:0xEC
                case 3:
                    HUD.ShowTutorialHud(-321289227, 8);
                    // End:0x133
                    break;
                // End:0x10E
                case 4:
                    HUD.ShowTutorialHud(1378355384, 0);
                    // End:0x133
                    break;
                // End:0x130
                case 5:
                    HUD.ShowTutorialHud(-1368610781, 4);
                    // End:0x133
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x133! */
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x00C! */
}

defaultproperties
{
    mPopupType=6
    bLatentExecution=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="Tutorial Pop-up"
    ObjCategory="Turok Gameplay"
}