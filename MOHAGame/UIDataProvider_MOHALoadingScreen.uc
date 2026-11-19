class UIDataProvider_MOHALoadingScreen extends UIResourceDataProvider
    transient
    native
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

struct native DPLoadingImageEntry
{
    var() Vector2D pos;
    var() Vector2D Size;
    var() string Image;
    var() int anchorPoint;

    structdefaultproperties
    {
        pos=(X=0.0000000,Y=0.0000000)
        Size=(X=0.0000000,Y=0.0000000)
        Image=""
        anchorPoint=0
    }
};

struct native DPLoadingTextEntry
{
    var() Vector2D pos;
    var() string Text;
    var() string textFont;
    var() int anchorPoint;
    var() int justification;

    structdefaultproperties
    {
        pos=(X=0.0000000,Y=0.0000000)
        Text=""
        textFont=""
        anchorPoint=0
        justification=0
    }
};

var config array<config DPLoadingImageEntry> ImageListSD;
var config array<config DPLoadingImageEntry> ImageListHD;
var config array<config DPLoadingTextEntry> TextListHD;
var config array<config DPLoadingTextEntry> TextListSD;
var config array<config string> levelHideOverrides;
var config float LayoutWidthSD;
var config float LayoutWidthHD;
var config float LayoutHeightSD;
var config float LayoutHeightHD;
var config bool showTips;
var config string TipFont;
var config string levelFont;
