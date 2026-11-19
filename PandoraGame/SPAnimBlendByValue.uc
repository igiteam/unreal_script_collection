class SPAnimBlendByValue extends SPAnimBaseNode
    native;

var float ValueToBlendOffOf;
var int LastChannel;
/** How fast to blend when going up */
var() float BlendUpTime;
/** How fast to blend when going down */
var() float BlendDownTime;
/** When should we start blending back down */
var() float BlendDownPerc;
/** Weights/ constraints used for transition between child nodes */
var() array<float> Constraints;
var() export editinline name m_canChangeChildFunc;
