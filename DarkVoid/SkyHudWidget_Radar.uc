class SkyHudWidget_Radar extends SkyUI_HudWidget
    native
    config(UI);

struct native BlipStyle
{
    var() SkyRadar.RadarBlipClass TargetClass;
    var() MaterialInterface BlipImage;

    structdefaultproperties
    {
        TargetClass=RBC_InAir
        BlipImage=none
    }
};

var transient MaterialInstanceConstant BackgroundMaterialInstance;
var transient array<MaterialInstanceConstant> BlipMats;
var() editinline array<editinline BlipStyle> BlipStyles;
var(Widget) Material BackgroundMaterial;
var(Widget) deprecated Material BlipMaterial;
var(Widget) float Padding;
var name RadarTargetTypeName;
var name RadarZHeightName;
var name FadeOutName;

event Initialized()
{
    super(UIScreenObject).Initialized();
    BackgroundMaterialInstance = new (Outer) Class'Engine.MaterialInstanceConstant';
    BackgroundMaterialInstance.SetParent(BackgroundMaterial);
    //return;    
}

event WidgetTick(float DeltaTime)
{
    super.WidgetTick(DeltaTime);
    //return;    
}
