class FlashbangEffectParams  extends Core.Object
   notplaceable
   hidecategories(Object)
   abstract;

var () float RetinaImageDuration "The freeze frame will last this many seconds";
var () float FlashWhiteDuration  "Sets how long the white flash lasts in seconds";
var () float FlashFadeDuration   "How long it takes for the white to fade out (this has to be less than the FlashWhiteDuration)";
var () float FlashInsetAmount    "The white flash texture is zoomed in by this fraction (0-1) at the beginning of the effect and then zooms out to 100% as it fades out";
var () float RetinaEaseIn        "The Ease In paramter for the retina image (rage: .2 - 10) - (1 means linear, more than 1 means a slow ease in, less than 1 means a sharp accelleration)";
var () float RetinaEaseOut       "The Ease Out paramter for the retina image (rage: .2 - 10) - (1 means linear, more than 1 means a slow ease ease out, less than 1 means a sharp accelleration)";
var () float FlashEaseIn         "The Ease In parameter for the white flash (the equation is (1 - Time^EaseIn)^EaseOut, for Time going between 0 and 1";
var () float FlashEaseOut        "The Ease Out parameter for the white flash" ;
var () float FlashInsetEaseIn    "The Ease In parameter for the white flash inset motion";
var () float FlashInsetEaseOut   "The Ease Out parameter for the white flash inset motion";

var () Shader RetinaImage        "The Shader material for rendering the Retina Image";
var () Texture Flash             "The Texture for the white flash";























// Decompiled with UE Explorer.
defaultproperties
{
    RetinaImageDuration=6.0000000
    FlashWhiteDuration=0.2000000
    FlashFadeDuration=4.0000000
    FlashInsetAmount=0.2000000
    RetinaEaseIn=3.0000000
    RetinaEaseOut=1.0000000
    FlashEaseIn=1.8000000
    FlashEaseOut=1.0000000
    FlashInsetEaseIn=1.7000000
    FlashInsetEaseOut=1.5000000
    RetinaImage=Shader'CameraEffectsTex.FlashbangCameraEffects.RetinaImage'
    Flash=Texture'CameraEffectsTex.FlashbangCameraEffects.Flash'
}