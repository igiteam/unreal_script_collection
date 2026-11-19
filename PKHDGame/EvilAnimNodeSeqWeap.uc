class EvilAnimNodeSeqWeap extends UDKAnimNodeSeqWeap
    hidecategories(Object,Object,Object,UDKAnimNodeSeqWeap);

var() name DefaultWeaponAnim;
var() name PistolAnim;
var() name AK47Anim;
var() name BlunderbussAnim;
var() name CannonAnim;
var() name CrossbowAnim;
var() name Gew98Anim;
var() name LAW72Anim;
var() name M200Anim;
var() name MGL140Anim;
var() name MinigunAnim;
var() name MP18Anim;
var() name RemingtonAnim;
var() name ScarAnim;
var() name SM500Anim;
var() name VectorAnim;

function EvilWeapTypeChanged(name NewAimProfileName)
{
    local name NewSeqName;

    NewSeqName = SinglePistolAnim;
    switch(NewAimProfileName)
    {
        // End:0x48
        case 'SinglePistol':
            NewSeqName = PistolAnim;
            // End:0x227
            break;
        // End:0x6A
        case 'AK47':
            NewSeqName = AK47Anim;
            // End:0x227
            break;
        // End:0x8C
        case 'Blunderbuss':
            NewSeqName = BlunderbussAnim;
            // End:0x227
            break;
        // End:0xAE
        case 'Cannon':
            NewSeqName = CannonAnim;
            // End:0x227
            break;
        // End:0xD0
        case 'Crossbow':
            NewSeqName = CrossbowAnim;
            // End:0x227
            break;
        // End:0xF2
        case 'Gew98':
            NewSeqName = Gew98Anim;
            // End:0x227
            break;
        // End:0x114
        case 'LAW72':
            NewSeqName = LAW72Anim;
            // End:0x227
            break;
        // End:0x136
        case 'M200':
            NewSeqName = M200Anim;
            // End:0x227
            break;
        // End:0x158
        case 'MGL140':
            NewSeqName = MGL140Anim;
            // End:0x227
            break;
        // End:0x17A
        case 'Minigun':
            NewSeqName = MinigunAnim;
            // End:0x227
            break;
        // End:0x19C
        case 'MP18':
            NewSeqName = MP18Anim;
            // End:0x227
            break;
        // End:0x1BE
        case 'Remington':
            NewSeqName = RemingtonAnim;
            // End:0x227
            break;
        // End:0x1E0
        case 'Scar':
            NewSeqName = ScarAnim;
            // End:0x227
            break;
        // End:0x202
        case 'SM500':
            NewSeqName = SM500Anim;
            // End:0x227
            break;
        // End:0x224
        case 'Vector':
            NewSeqName = VectorAnim;
            // End:0x227
            break;
        // End:0xFFFF
        default:
            break;
    }
    SinglePistolAnim = NewSeqName;
    SetAnim(NewSeqName);
    //return;    
}
