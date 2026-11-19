class SkyUISkeletalMeshWidget extends SkyUI_Widget
    native
    config(UI);

var(SkeletalMesh) export editinline SkySkelMeshComponent_Stated SkelMeshComponent;
var(SkeletalMesh) float BaseScaleFactor;
var(SkeletalMesh) bool bScalesWithWidget;
var bool bIsHidden;
var Vector SkelMeshLocationTemp;

// Export USkyUISkeletalMeshWidget::execCenterMesh(FFrame&, void* const)
native function CenterMesh();

// Export USkyUISkeletalMeshWidget::execSetMeshScaleByWidgetScale(FFrame&, void* const)
native function SetMeshScaleByWidgetScale();
