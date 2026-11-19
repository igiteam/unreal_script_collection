class R6TreeComment extends Object
    native
    hidecategories(Object);

var() string m_strText;
var() bool m_bDrawBox;
var() Color m_BorderColor;
var() Color m_FillColor;
var() Color m_TextColor;
var transient string m_strFormattedText;
var int m_iPosX;
var int m_iPosY;
var int m_iSizeX;
var int m_iSizeY;

defaultproperties
{
    m_strText="Description"
    m_bDrawBox=true
    m_BorderColor=(R=0,G=0,B=0,A=255)
    m_FillColor=(R=235,G=235,B=235,A=255)
    m_TextColor=(R=12,G=12,B=192,A=255)
    m_iSizeX=128
    m_iSizeY=64
}