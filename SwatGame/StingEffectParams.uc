class StingEffectParams extends Core.Object
   notplaceable
   hidecategories(Object)
   abstract;

var() byte		  BlurAlpha                  "Motion blur blending alpha (1-255) - smaller means more blurring" ;
var() float       FadeInTime                 "Time to fade in the effect in seconds";
var() float       FadeOutTime                "Time to fade out the effect in seconds";
var() float       DoubleVisionTime "Time to show double vision in seconds (can be very large if you want double vision all the time)";
var() float       DoubleVisionFadeOutTime    "Time to fade out double vision";

var() Bool        bBlurTime                  "True if you want the motion blur effect (or only double vision)";
var() int         PassOneDivide              "how much to divide the off-screen rendering resolution by (i.e., 2 means half res)";
var() int         PassTwoDivide              "how much to divide the blur resolution by (i.e., 2 means half res)";   
var() float       MaxBlurFrameTime           "Scaling time for blur effect - larger means less blurring, start with .1 and increase This is combined with BlurAlpha for the final blur amount"; // max time in seconds for the blur to last (should be around .1 or .2)
var() float       ZoomInFraction             "Amount to zoom in on the off-screen rendered frame for perlin nopise motion (0-1)";
var() float       NoiseAmplitude             "Amplitude for Perlin noise motion on frame (0-1)";
var() float       NoiseRate                  "Rate of Perlin noise motion on frame (in cycles per second, so larger means faster";
var() float       DoubleVisionNoiseAmplitude "Perlin noise Amplitude of the double vision"; 
var() float       DoubleVisionNoiseRate      "Perlin noise rate for double vision"; 

var() Plane       TintColor                  "Color used to tint the view at the beginning of the effect";
var() float       TintTime                   "Time to show tinting (must be greater than TintFadeTime)";
var() float       TintFadeOutTime            "Time to fade out the tint effect";





















// Decompiled with UE Explorer.
defaultproperties
{
    BlurAlpha=20
    FadeInTime=0.2000000
    FadeOutTime=2.5000000
    DoubleVisionTime=2.5000000
    DoubleVisionFadeOutTime=0.5000000
    bBlurTime=true
    PassOneDivide=2
    PassTwoDivide=2
    MaxBlurFrameTime=2.0000000
    ZoomInFraction=0.1500000
    NoiseAmplitude=0.1400000
    NoiseRate=1.5000000
    DoubleVisionNoiseAmplitude=0.2500000
    DoubleVisionNoiseRate=2.2000000
    TintColor=(W=1.0000000,X=1.0000000,Y=0.8000000,Z=0.5000000)
    TintTime=0.5000000
    TintFadeOutTime=0.2500000
}