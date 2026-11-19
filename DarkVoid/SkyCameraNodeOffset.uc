class SkyCameraNodeOffset extends SkyCameraNodeBlendListBase
    native;

var(Flags) SkyCameraTreeObject.EAlignControllerModeOffset AlignControllerMode;
var(Flags) SkyCameraTreeObject.EFlagOffset DisableCollision;
var(Flags) SkyCameraTreeObject.EFlagOffset DisableCollisionPrediction;
var(Flags) SkyCameraTreeObject.EFlagOffset RespectFootDisplacement;
var(Offset) Vector MovementOffset;
var(Offset) Vector FocusOffset;
var(Offset) Vector PivotOffset;
var(Offset) Vector SafeLocOffset;
var(Offset) float FOVOffset;
var(Offset) float PitchAngleOffset;
var array<SkyCameraNodeView> ViewNodes;
