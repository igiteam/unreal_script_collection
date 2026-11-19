class SkyUI_Widget extends UIObject
    abstract
    native
    config(UI);

var bool bRequiresTick;
var(Widget) transient bool bShowBounds;
var SkyUIScene SkySceneOwner;
