class SkyUIWidget_Spinner extends SkyUI_Widget
    native
    config(UI);

var(Spinner) export editinline UIComp_DrawImage HubImage;
var(Spinner) Material ItemMaterial;
var(Spinner) float SelectionSize;
var(Spinner) int ShowAboveNum;
var(Spinner) int ShowBelowNum;
var(Spinner) bool AnimateSpin;
var(Spinner) float SpinTime;
var(Spinner) float TurnRadius;
var(Spinner) float HubOffset;
var(Spinner) float DistanceBetween;
var(Spinner) name DataStoreName;
var transient array<MaterialInstanceConstant> Instances;
var transient array<Vector2D> Positions;
var transient UIDataStore Store;
var int CurrentSelection;
var transient int TransitionFrom;
var transient float Transition;
var transient float LastUpdateTime;
