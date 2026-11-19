class SceneCapture2DComponent extends SceneCaptureComponent
    native
    hidecategories(Object);

var(Capture) TextureRenderTarget TextureTarget;
var(Capture) float FieldOfView;
var(Capture) float NearPlane;
var(Capture) float FarPlane;
var bool bUpdateMatrices;
var transient Matrix ViewMatrix;
var transient Matrix ProjMatrix;
