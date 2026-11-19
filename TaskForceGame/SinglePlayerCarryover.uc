class SinglePlayerCarryover extends Actor
	config(user)
	notplaceable
	native;

//Truncated the names since SaveConfig\LoadConfig relies on a 1024 byte buffer which I'm not willingly going to change.
//Do not use config class<SomeClass> ever, it will not work with linear level loading.

var() config string				W[4];		//Weapon
var() config int				WAA[4];		//Weapon Ammo Amount (Amount in weapon)
var() config string				A[8];		//Ammo Class
var() config int				AA[8];		//Ammo Amount
var() config int				CWS;		//CurrentWeaponSlot
var() config float				PH;			//PlayerHealth
var() config int				CI;			//CampaignIndex
var() config string				DURL;		//DestinationURL
var() config int				CPI;		//CheckPoint Index; if this is -1, this means the data is not valid


// Decompiled with UE Explorer.
defaultproperties
{
    cpi=-1
    DrawType=0
    bHidden=true
}