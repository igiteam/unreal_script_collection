class MOHAKeyboardManager extends Object
    native;

struct native KeyBindingAction
{
    var init string ActionCommand;
    var name ActionName;
    var MOHAUIConfigButton.EButtonActionBinding ActionEnum;

    structdefaultproperties
    {
        ActionCommand=""
        ActionName="None"
        ActionEnum=0
    }
};

var array<KeyBindingAction> ActionArray;
var native const Pointer ActionMap;
var MOHAUIConfigButton m_CurrentConfigButton;
var name m_CurrentKey;
var string m_CurrentOtherBoundCommandStr;

// Export UMOHAKeyboardManager::execInit(FFrame&, void* const)
native function Init();

// Export UMOHAKeyboardManager::execGetCurrentKeyBinding(FFrame&, void* const)
native function string GetCurrentKeyBinding(string Command, int BindPos);

defaultproperties
{
    ActionArray[0]=(ActionCommand="MoveForward",ActionName="MoveForward",ActionEnum=0)
    ActionArray[1]=(ActionCommand="MoveBackward",ActionName="MoveBackward",ActionEnum=1)
    ActionArray[2]=(ActionCommand="StrafeLeft",ActionName="StrafeLeft",ActionEnum=2)
    ActionArray[3]=(ActionCommand="StrafeRight",ActionName="StrafeRight",ActionEnum=3)
    ActionArray[4]=(ActionCommand="UseAction",ActionName="UseAction",ActionEnum=4)
    ActionArray[5]=(ActionCommand="CutChute",ActionName="CutChute",ActionEnum=5)
    ActionArray[6]=(ActionCommand="Crouch",ActionName="Crouch",ActionEnum=6)
    ActionArray[7]=(ActionCommand="SprintIronsightsMove",ActionName="SprintIronsightsMove",ActionEnum=7)
    ActionArray[8]=(ActionCommand="FlareChuteJumpMultiCmd",ActionName="JumpFlareChute",ActionEnum=8)
    ActionArray[9]=(ActionCommand="Ironsights",ActionName="Ironsights",ActionEnum=9)
    ActionArray[10]=(ActionCommand="ZoomIn",ActionName="ZoomIn",ActionEnum=10)
    ActionArray[11]=(ActionCommand="ZoomOut",ActionName="ZoomOut",ActionEnum=11)
    ActionArray[12]=(ActionCommand="Reload",ActionName="Reload",ActionEnum=12)
    ActionArray[13]=(ActionCommand="Melee",ActionName="Melee",ActionEnum=13)
    ActionArray[14]=(ActionCommand="FireWeapon",ActionName="FireWeapon",ActionEnum=14)
    ActionArray[15]=(ActionCommand="AltWeaponFireToggle",ActionName="AltFire",ActionEnum=15)
    ActionArray[16]=(ActionCommand="SwitchGrenade",ActionName="SwitchGrenade",ActionEnum=16)
    ActionArray[17]=(ActionCommand="SwitchWeapon",ActionName="SwitchWeapon",ActionEnum=17)
    ActionArray[18]=(ActionCommand="SwitchPistol",ActionName="SwitchPistol",ActionEnum=18)
    ActionArray[19]=(ActionCommand="SwitchPrimary",ActionName="SwitchPrimary",ActionEnum=19)
    ActionArray[20]=(ActionCommand="SwitchSecondary",ActionName="SwitchSecondary",ActionEnum=20)
    ActionArray[21]=(ActionCommand="SwitchFragGrenade",ActionName="SwitchFragGrenade",ActionEnum=21)
    ActionArray[22]=(ActionCommand="SwitchStick",ActionName="SwitchStick",ActionEnum=22)
    ActionArray[23]=(ActionCommand="SwitchGammon",ActionName="SwitchGammon",ActionEnum=23)
    ActionArray[24]=(ActionCommand="ShowScores",ActionName="ShowScores",ActionEnum=24)
    ActionArray[25]=(ActionCommand="SayTeam",ActionName="SayTeam",ActionEnum=25)
    ActionArray[26]=(ActionCommand="SayAll",ActionName="SayAll",ActionEnum=26)
    ActionArray[27]=(ActionCommand="VoiceChat",ActionName="VoiceChat",ActionEnum=27)
}