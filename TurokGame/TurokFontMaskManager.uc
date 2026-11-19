class TurokFontMaskManager extends Object
    native;

struct native FontMaskItem
{
    var native @NULL mTextNode;
    var native float mScaleX;
    var native float mScaleY;
    var native int mBlurLevel;
};

var array mTextNodes;
var int mNextMaskID;
