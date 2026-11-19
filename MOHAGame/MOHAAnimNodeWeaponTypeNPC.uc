class MOHAAnimNodeWeaponTypeNPC extends MOHAAnimNodeBlendList
    native
    hidecategories(Object,Object,Object);

const WTI_SEMIAUTORIFLE = 0;
const WTI_SMG = 1;
const WTI_RIFLE = 2;
const WTI_OTHER = 3;

var() float BlendTime;

defaultproperties
{
    bPlayActiveChild=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}