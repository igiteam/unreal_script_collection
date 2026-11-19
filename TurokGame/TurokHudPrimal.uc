class TurokHudPrimal extends TurokHudElement
    transient
    native;

var @NULL mArmorTexture;
var @NULL mVitalsTexture;
var float mPreviousArmor;
var float mArmorAnimTimeLeft;
var float mArmorAnimTotalTime;
var float mPreviousHealth;
var float mHealthAnimTimeLeft;
var float mHealthAnimTotalTime;

function Draw()
{
    DrawPrimal();
    DrawVitals();
    //return;    
}

function Reset()
{
    mPreviousHealth = 0.0000000;
    mHealthAnimTimeLeft = 0.0000000;
    mPreviousArmor = 0.0000000;
    mArmorAnimTimeLeft = 0.0000000;
    //return;    
}

function DrawPrimal()
{
    //return;    
}

function DrawVitals()
{
    //return;    
}
