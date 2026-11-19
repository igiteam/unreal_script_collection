class MOHAUIConfigButton extends UILabelButton
    native
    hidecategories(Object,UIRoot,Object);

enum EButtonActionBinding
{
    BAB_MOVE_FORWARD,               // 0
    BAB_MOVE_BACKWARD,              // 1
    BAB_STRAFE_LEFT,                // 2
    BAB_STRAFE_RIGHT,               // 3
    BAB_USE_ACTION,                 // 4
    BAB_CUT_CHUTE,                  // 5
    BAB_CROUCH,                     // 6
    BAB_SPRINT_IRONSIGHTS_MOVE,     // 7
    BAB_JUMP_FLARE_CHUTE,           // 8
    BAB_IRONSIGHTS,                 // 9
    BAB_ZOOM_IN,                    // 10
    BAB_ZOOM_OUT,                   // 11
    BAB_RELOAD,                     // 12
    BAB_MELEE,                      // 13
    BAB_FIRE_WEAPON,                // 14
    BAB_ALT_FIRE,                   // 15
    BAB_GRENADE_CYCLE,              // 16
    BAB_WEAPON_CYCLE,               // 17
    BAB_PISTOL,                     // 18
    BAB_PRIMARY_WEAPON,             // 19
    BAB_SECONDARY_WEAPON,           // 20
    BAB_FRAG_GRENADE,               // 21
    BAB_STICK_GRENADE,              // 22
    BAB_GAMMON_GRENADE,             // 23
    BAB_SCOREBOARD,                 // 24
    BAB_SAY_TEAM,                   // 25
    BAB_SAY_ALL,                    // 26
    BAB_VOICE_CHAT,                 // 27
    BAB_MAX                         // 28
};

var() MOHAUIConfigButton.EButtonActionBinding ButtonBindedAction;
var() int BindPos;
var name CurrentKey;

// Export UMOHAUIConfigButton::execRefreshSubscriberValue(FFrame&, void* const)
native function bool RefreshSubscriberValue(optional int BindingIndex);

defaultproperties
{
    BindPos=1
    CurrentKey="NAME_None"
    // Reference: UIComp_DrawString'Default__MOHAUIConfigButton.LabelStringRenderer'
    begin object name=LabelStringRenderer
    end object
    StringRenderComponent=LabelStringRenderer
    // Reference: UIComp_DrawImage'Default__MOHAUIConfigButton.BackgroundImageTemplate'
    begin object name=BackgroundImageTemplate
    end object
    BackgroundImageComponent=BackgroundImageTemplate
    // Reference: UIComp_Event'Default__MOHAUIConfigButton.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}