class FlashbangCameraEffect extends SwatCameraEffect
    config(SwatEquipment)
    native
    noexport
    dependson(FlashbangEffectParams);

var protected float RetinaImageDuration;
var protected float FlashWhiteDuration;
var protected float FlashFadeDuration;
var protected float FlashInsetAmount;
var protected float RetinaEaseIn;
var protected float RetinaEaseOut;
var protected float FlashEaseIn;
var protected float FlashEaseOut;
var protected float FlashInsetEaseIn;
var protected float FlashInsetEaseOut;

var protected Shader RetinaImage;
var ScriptedTexture Frame;

var protected Texture Flash;

var SwatGamePlayerController PlayerController;

var string ParamsClassName;                // Class name for the default parameters class
var private class<FlashbangEffectParams> ParamsClass;

function Initialize(SwatGamePlayerController inPlayerController)
{
	// load the defaults class
    local object pclass;
    pclass = DynamicLoadObject(ParamsClassName,class'Class');
    assert(pclass != None);
    ParamsClass = class<FlashbangEffectParams>(pclass);

    PlayerController = inPlayerController;
}

function OnAdded()
{
    assertWithDescription(ParamsClass != None,
        "[henry] FlashbangCameraEffect::OnAdded ParamsClass is None.");

	if (ParamsClass != None)
	{
		RetinaImageDuration = ParamsClass.Default.RetinaImageDuration;
		FlashWhiteDuration  = ParamsClass.Default.FlashWhiteDuration;
		FlashFadeDuration   = ParamsClass.Default.FlashFadeDuration;
		FlashInsetAmount    = ParamsClass.Default.FlashInsetAmount;
		RetinaEaseIn        = ParamsClass.Default.RetinaEaseIn;
		RetinaEaseOut       = ParamsClass.Default.RetinaEaseOut;
		FlashEaseIn         = ParamsClass.Default.FlashEaseIn;
		FlashEaseOut        = ParamsClass.Default.FlashEaseOut;
		FlashInsetEaseIn    = ParamsClass.Default.FlashInsetEaseIn;
		FlashInsetEaseOut   = ParamsClass.Default.FlashInsetEaseOut;

		RetinaImage = ParamsClass.Default.RetinaImage;
		Flash       = ParamsClass.Default.Flash;
	}

    assertWithDescription(Flash != None,
        "[henry] FlashbangCameraEffect::OnAdded() Flash is None.");

    assertWithDescription(RetinaImage != None,
        "[henry] FlashbangCameraEffect::OnAdded() RetinaImage is None.");

    Frame = ScriptedTexture(Combiner(RetinaImage.Diffuse).Material1);

    assertWithDescription(Frame != None,
        "[henry] FlashbangCameraEffect::OnAdded() RetinaImage.Diffuse.Material1 is not a ScriptedTexture.");

	if (Frame.USize != PlayerController.FlashbangRetinaImageTextureWidth ||
		Frame.VSize != PlayerController.FlashbangRetinaImageTextureHeight)
	{
		Frame.SetSize(
			PlayerController.FlashbangRetinaImageTextureWidth, 
			PlayerController.FlashbangRetinaImageTextureHeight);
	}

    Frame.Client = PlayerController;

    Frame.Revision++;
}

















// Decompiled with UE Explorer.
defaultproperties
{
    RetinaImageDuration=6.0000000
    FlashWhiteDuration=0.5000000
    FlashFadeDuration=3.0000000
    FlashInsetAmount=0.2000000
    RetinaEaseIn=3.0000000
    RetinaEaseOut=1.0000000
    FlashEaseIn=2.0000000
    FlashEaseOut=1.0000000
    FlashInsetEaseIn=1.7000000
    FlashInsetEaseOut=2.0000000
    RetinaImage=Shader'CameraEffectsTex.FlashbangCameraEffects.RetinaImage'
    Flash=Texture'CameraEffectsTex.FlashbangCameraEffects.Flash'
    ParamsClassName="SwatCameraEffects.DesignerFlashbangParams"
}