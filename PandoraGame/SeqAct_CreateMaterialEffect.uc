class SeqAct_CreateMaterialEffect extends SeqAct_Latent
    native;

/** Material to apply to target when action is activated. */
var() MaterialInterface Material;
/** Material scaler parameter. */
var() name MaterialScalerParamName;
/** Index in the Materials array to replace with NewMaterial when this action is activated. */
var() int MaterialIndex;
/** Fade out delay time. */
var() float FadeOutDelayTime;
/** Fade out speed. */
var() float FadeOutSpeed;
/** Fade in value. 0-1 */
var() float FadeInValue;
/** Fade in speed. */
var() float FadeInSpeed;
