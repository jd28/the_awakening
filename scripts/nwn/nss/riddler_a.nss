//::///////////////////////////////////////////////
//:: RIDDLER ANSWERS
//::                     riddler_a
//:://////////////////////////////////////////////
/*
    this is the database of the riddle answers.
    add your riddle answers at the end of the case list.
    remember to use the same case numbers as your riddles!

    use uppercase.  separate keywords with commas.
    DO NOT USE SPACES after commas
    "SKY,AIR" is correct.  "SKY, AIR" is incorrect.

    you may use spaces within keywords:
    "FIREFLY,FIRE FLY" is acceptable.

    you may use all your answer words in one keyword,
    but the player MUST match your phrase exactly.
    or, use multiple keywords.
    "CAT AND MOUSE"  the player must type 'cat and mouse', not 'mouse and cat'
    or
    K1= "CAT" and K2="MOUSE"  the player's answer can have the words 'cat' and 'mouse' anywhere in it
    or
    K1="CAT,KITTEN,FELINE" and K2="MOUSE,RODENT"  the player can answer with any combination of words from K1 and K2

    you can have up to 5 keyword sets for your answer


    NOTE: you don't need to enter all 5 Keys, if your riddle
only has a single word answer.  only enter the ones you use.
(the standard ones have all the keys, because they were built using a spreadsheet)
*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:://////////////////////////////////////////////



void main()
{
    object oR = OBJECT_SELF;
    int nRand = GetLocalInt(oR,"RIDDLE");
    SetLocalString(oR,"K2","");
    SetLocalString(oR,"K3","");
    SetLocalString(oR,"K4","");
    SetLocalString(oR,"K5","");

//-- fetch answer from this database case

    switch (nRand)
    {
    //---Riddles 0-200 from the NetBook Riddles online------------------
case     0:  { SetLocalString(oR,"K1","SALT,ICE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     1:  { SetLocalString(oR,"K1", "SILVER"); SetLocalString(oR,"K2","DISH,PLATE"); SetLocalString(oR,"K3","OIL LAMP,OILLAMP,LAMP"); SetLocalString(oR,"K4","FLAME,FIRE"); SetLocalString(oR,"K5","");  break; }
case     2:  { SetLocalString(oR,"K1", "BUTTERFLY"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     3:  { SetLocalString(oR,"K1", "LIGHTNING"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     4:  { SetLocalString(oR,"K1", "BOOK,TOME"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     5:  { SetLocalString(oR,"K1", "DOG,FOX,WOLF,MUTT,MONGREL,HOUND"); SetLocalString(oR,"K2","BAYING,BARKING,HOWLING"); SetLocalString(oR,"K3","CRESCENT MOON"); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     6:  { SetLocalString(oR,"K1", "MEMORIES,MEMORY"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     7:  { SetLocalString(oR,"K1", "CHANGE,CHANGES"); SetLocalString(oR,"K2","COLOR,COLOUR,COLORS,COLOURS"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     8:  { SetLocalString(oR,"K1", "M,LETTER M,EM"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     9:  { SetLocalString(oR,"K1", "CHILDHOOD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     10:  { SetLocalString(oR,"K1", "EYES,SUN AND MOON,MOON AND SUN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     11:  { SetLocalString(oR,"K1", "HEART"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     12:  { SetLocalString(oR,"K1", "MOON"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     13:  { SetLocalString(oR,"K1", "TWELVE,SEVEN,12,7"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     14:  { SetLocalString(oR,"K1", "GOLD COIN,GOLD PIECE,GOLDPIECE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     15:  { SetLocalString(oR,"K1", "WHIP"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     16:  { SetLocalString(oR,"K1", "CLOUD,THUNDERHEAD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     17:  { SetLocalString(oR,"K1", "MOON"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     18:  { SetLocalString(oR,"K1", "MOUNTAIN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     19:  { SetLocalString(oR,"K1", "TEETH"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     20:  { SetLocalString(oR,"K1", "WIND"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     21:  { SetLocalString(oR,"K1", "DAISY"); SetLocalString(oR,"K2","FIELD"); SetLocalString(oR,"K3","GRASS"); SetLocalString(oR,"K4","SUN"); SetLocalString(oR,"K5","");  break; }
case     22:  { SetLocalString(oR,"K1", "DARKNESS,THE DARK"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     23:  { SetLocalString(oR,"K1", "EGG,EGGS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     24:  { SetLocalString(oR,"K1", "FISH"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     25:  { SetLocalString(oR,"K1", "TIME"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     26:  { SetLocalString(oR,"K1", "HEART,HEARTBEAT,WIND,AIR,BREEZE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     27:  { SetLocalString(oR,"K1", "YOUR WORD,PROMISE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     28:  { SetLocalString(oR,"K1", "BREATH"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     29:  { SetLocalString(oR,"K1", "RIVER"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     30:  { SetLocalString(oR,"K1", "WATER"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     31:  { SetLocalString(oR,"K1", "SILENCE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     32:  { SetLocalString(oR,"K1", "AIR"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     33:  { SetLocalString(oR,"K1", "FIRE,FLAME"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     34:  { SetLocalString(oR,"K1", "HEART"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     35:  { SetLocalString(oR,"K1", "WAR"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     36:  { SetLocalString(oR,"K1", "HEART"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     37:  { SetLocalString(oR,"K1", "SOUND,SOUNDS,NOISE,NOISES"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     38:  { SetLocalString(oR,"K1", "WHEEL"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     39:  { SetLocalString(oR,"K1", "ICEBERG,PIECE OF ICE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     40:  { SetLocalString(oR,"K1", "SNAIL"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     41:  { SetLocalString(oR,"K1", "CANDLE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     42:  { SetLocalString(oR,"K1", "BOAT,SHIP"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     43:  { SetLocalString(oR,"K1", "MIRROR"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     44:  { SetLocalString(oR,"K1", "FIRE,FLAME"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     45:  { SetLocalString(oR,"K1", "WATER"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     46:  { SetLocalString(oR,"K1", "ICICLE,ICICLES,TOOTH,TEETH,STALACTITE,STALACTITES"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     47:  { SetLocalString(oR,"K1", "SHADOW"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     48:  { SetLocalString(oR,"K1", "PIANO,HARPSICHORD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     49:  { SetLocalString(oR,"K1", "IN THE MIND,IN YOUR MIND"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     50:  { SetLocalString(oR,"K1", "COMPASS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     51:  { SetLocalString(oR,"K1", "SISTER,MONK,CLERIC,PRIEST"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     52:  { SetLocalString(oR,"K1", "BEES"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     53:  { SetLocalString(oR,"K1", "FOUR HORSEMEN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     54:  { SetLocalString(oR,"K1", "UNICORN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     55:  { SetLocalString(oR,"K1", "COUNTERFEIT MONEY,FAKE MONEY,FUNNY MONEY"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     56:  { SetLocalString(oR,"K1", "AXE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     57:  { SetLocalString(oR,"K1", "WOODEN LEG"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     58:  { SetLocalString(oR,"K1", "SHADOW"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     59:  { SetLocalString(oR,"K1", "GUITAR,MANDOLIN,LUTE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     60:  { SetLocalString(oR,"K1", "ICICLE,ICICLES"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     61:  { SetLocalString(oR,"K1", "WEDDING RING,WEDDING BAND"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     62:  { SetLocalString(oR,"K1", "COFFIN,CASKET"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     63:  { SetLocalString(oR,"K1", "NOTHING"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     64:  { SetLocalString(oR,"K1", "PARADOX,PAIR OF DOCKS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     65:  { SetLocalString(oR,"K1", "BRIDE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     66:  { SetLocalString(oR,"K1", "ONION"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     67:  { SetLocalString(oR,"K1", "ONE,1"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     68:  { SetLocalString(oR,"K1", "SHADOW,SHADOWS,SUN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     69:  { SetLocalString(oR,"K1", "DIAMOND,GEM,GEMSTONE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     70:  { SetLocalString(oR,"K1", "TONGS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     71:  { SetLocalString(oR,"K1", "THREE,3"); SetLocalString(oR,"K2","MEN,PEOPLE,KNIGHTS,PEASANTS"); SetLocalString(oR,"K3","EATEN,DEVOURED,KILLED"); SetLocalString(oR,"K4","DRAGON"); SetLocalString(oR,"K5","");  break; }
case     72:  { SetLocalString(oR,"K1", "GAS,FART"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     73:  { SetLocalString(oR,"K1", "YEAST"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     74:  { SetLocalString(oR,"K1", "OPINION,OPINIONS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     75:  { SetLocalString(oR,"K1", "MUTTON,CHICKEN,TURKEY,DRUMSTICK"); SetLocalString(oR,"K2","MAN,PERSON"); SetLocalString(oR,"K3","STOOL"); SetLocalString(oR,"K4","DOG,CAT"); SetLocalString(oR,"K5","");  break; }
case     76:  { SetLocalString(oR,"K1", "HAND,HANDS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     77:  { SetLocalString(oR,"K1", "HORSES"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     78:  { SetLocalString(oR,"K1", "CANDY,SWEETS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     79:  { SetLocalString(oR,"K1", "FOG,MIST"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     80:  { SetLocalString(oR,"K1", "EMOTIONS,FEELINGS,EXPRESSION,EXPRESSIONS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     81:  { SetLocalString(oR,"K1", "RIDDLE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     82:  { SetLocalString(oR,"K1", "STAR"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     83:  { SetLocalString(oR,"K1", "MUD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     84:  { SetLocalString(oR,"K1", "WRITING,TEXT,READING"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     85:  { SetLocalString(oR,"K1", "HOME"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     86:  { SetLocalString(oR,"K1", "MUSIC,SONG"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     87:  { SetLocalString(oR,"K1", "ROOTS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     88:  { SetLocalString(oR,"K1", "WEEPING WILLOW"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     89:  { SetLocalString(oR,"K1", "DESERT"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     90:  { SetLocalString(oR,"K1", "FOUNTAIN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     91:  { SetLocalString(oR,"K1", "STAGE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     92:  { SetLocalString(oR,"K1", "AGING,GROWING OLD,GETTING OLD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     93:  { SetLocalString(oR,"K1", "BOAR,RAZORBACK"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     94:  { SetLocalString(oR,"K1", "HEART"); SetLocalString(oR,"K2","FOREST,WOODS,WOODLAND"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     95:  { SetLocalString(oR,"K1", "SHARING"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     96:  { SetLocalString(oR,"K1", "HUMMINGBIRD,HUMMING BIRD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     97:  { SetLocalString(oR,"K1", "MORNING GLORY,MORNINGGLORY"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     98:  { SetLocalString(oR,"K1", "MIRAGE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     99:  { SetLocalString(oR,"K1", "AIR,SKY"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     100:  { SetLocalString(oR,"K1", "PLAINS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     101:  { SetLocalString(oR,"K1", "RIVER,RAPIDS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     102:  { SetLocalString(oR,"K1", "DOLL"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     103:  { SetLocalString(oR,"K1", "OLD,AGED"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     104:  { SetLocalString(oR,"K1", "PARADOX,OPPOSITE,OPPOSITES"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     105:  { SetLocalString(oR,"K1", "SUNLIGHT,SHADOW,COLOR,COLOUR"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     106:  { SetLocalString(oR,"K1", "BELL"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     107:  { SetLocalString(oR,"K1", "TREE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     108:  { SetLocalString(oR,"K1", "EYES"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     109:  { SetLocalString(oR,"K1", "CENTIPEDE,MILLIPEDE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     110:  { SetLocalString(oR,"K1", "LADY SLIPPERS,LADYSLIPPERS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     111:  { SetLocalString(oR,"K1", "DAFFODIL"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     112:  { SetLocalString(oR,"K1", "PANDORAS BOX"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     113:  { SetLocalString(oR,"K1", "PRICKLY PEAR,PRICKLYPEAR"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     114:  { SetLocalString(oR,"K1", "BULL"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     115:  { SetLocalString(oR,"K1", "ECLIPSE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     116:  { SetLocalString(oR,"K1", "GIRL,CHILD"); SetLocalString(oR,"K2","DOLL,DOLLS,DOLLHOUSE"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     117:  { SetLocalString(oR,"K1", "CAT"); SetLocalString(oR,"K2","MOUSE,RAT"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     118:  { SetLocalString(oR,"K1", "LIGHTHOUSE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     119:  { SetLocalString(oR,"K1", "TREE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     120:  { SetLocalString(oR,"K1", "MOUSE,SPIDER,BUG"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     121:  { SetLocalString(oR,"K1", "WATER,RIVER,STREAM"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     122:  { SetLocalString(oR,"K1", "LEAF"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     123:  { SetLocalString(oR,"K1", "ROBIN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     124:  { SetLocalString(oR,"K1", "FINGERS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     125:  { SetLocalString(oR,"K1", "JEWELRY BOX,JEWELERY BOX"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     126:  { SetLocalString(oR,"K1", "LIGHTNING BUGS,FIREFLIES"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     127:  { SetLocalString(oR,"K1", "ECLIPSE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     128:  { SetLocalString(oR,"K1", "BREAK,BROKE,BROKEN"); SetLocalString(oR,"K2","WORD,OATH,PROMISE"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     129:  { SetLocalString(oR,"K1", "BEAR"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     130:  { SetLocalString(oR,"K1", "HAY"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     131:  { SetLocalString(oR,"K1", "SEEDS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     132:  { SetLocalString(oR,"K1", "VOWELS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     133:  { SetLocalString(oR,"K1", "BOOK,TOME"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     134:  { SetLocalString(oR,"K1", "CHERRY"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     135:  { SetLocalString(oR,"K1", "WINDSTORM,WIND STORM,STORM OF WIND"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     136:  { SetLocalString(oR,"K1", "CANDLE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     137:  { SetLocalString(oR,"K1", "STAR"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     138:  { SetLocalString(oR,"K1", "CLOUD,CLOUDS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     139:  { SetLocalString(oR,"K1", "WIND"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     140:  { SetLocalString(oR,"K1", "BALL"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     141:  { SetLocalString(oR,"K1", "PECAN TREE,WALNUT TREE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     142:  { SetLocalString(oR,"K1", "STAIRS,STAIRCASE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     143:  { SetLocalString(oR,"K1", "TIME"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     144:  { SetLocalString(oR,"K1", "BIRD,SONGBIRD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     145:  { SetLocalString(oR,"K1", "THUNDER"); SetLocalString(oR,"K2","LIGHTNING"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     146:  { SetLocalString(oR,"K1", "HANDS,FINGERS"); SetLocalString(oR,"K2","PIANO,HARPSICHORD,ORGAN,KEYBOARD"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     147:  { SetLocalString(oR,"K1", "EUNUCH"); SetLocalString(oR,"K2","BAT,DRAGON,PSEUDODRAGON,BUG,INSECT,FEATHERED SERPENT"); SetLocalString(oR,"K3","REED,BAMBOO"); SetLocalString(oR,"K4","PUMICE"); SetLocalString(oR,"K5","");  break; }
case     148:  { SetLocalString(oR,"K1", "GRUDGE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     149:  { SetLocalString(oR,"K1", "SIEVE,COLLANDER,SPHERE OF ANNIHILATION"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     150:  { SetLocalString(oR,"K1", "CAT,FELINE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     151:  { SetLocalString(oR,"K1", "RAINS,RAIN STORM,THUNDERSTORM,STORM,RAIN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     152:  { SetLocalString(oR,"K1", "YOUTH,CHILDHOOD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     153:  { SetLocalString(oR,"K1", "WELL"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     154:  { SetLocalString(oR,"K1", "DARKNESS,THE DARK"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     155:  { SetLocalString(oR,"K1", "SECRET"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     156:  { SetLocalString(oR,"K1", "TOWEL"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     157:  { SetLocalString(oR,"K1", "WATER,H2O"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     158:  { SetLocalString(oR,"K1", "WHIP"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     159:  { SetLocalString(oR,"K1", "OIL,JEWELS,GEMS"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     160:  { SetLocalString(oR,"K1", "BEE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     161:  { SetLocalString(oR,"K1", "SMACK,THWAP,HIT,PUNCH"); SetLocalString(oR,"K2","HEAD"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     162:  { SetLocalString(oR,"K1", "HORSE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     163:  { SetLocalString(oR,"K1", "SAND"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     164:  { SetLocalString(oR,"K1", "SEA,OCEAN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     165:  { SetLocalString(oR,"K1", "BOW"); SetLocalString(oR,"K2","ARROW"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     166:  { SetLocalString(oR,"K1", "RIDDLE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     167:  { SetLocalString(oR,"K1", "BOTTLE"); SetLocalString(oR,"K2","GIN"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     168:  { SetLocalString(oR,"K1", "SUN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     169:  { SetLocalString(oR,"K1", "ROASTING,COOKING"); SetLocalString(oR,"K2","MEAT,BEEF"); SetLocalString(oR,"K3","SPIT"); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     170:  { SetLocalString(oR,"K1", "SHIP,VESSEL,WAGON,MAGIC CARPET,CART,BOAT,RAFT"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     171:  { SetLocalString(oR,"K1", "FEW"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     172:  { SetLocalString(oR,"K1", "STOVE,OVEN"); SetLocalString(oR,"K2","FIRE,FLAME"); SetLocalString(oR,"K3","SMOKE"); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     173:  { SetLocalString(oR,"K1", "COUNTERFEIT,COUNTERFEITED,FAKE"); SetLocalString(oR,"K2","MONEY,COIN,COINS,GOLD PIECES"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     174:  { SetLocalString(oR,"K1", "SNOW"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     175:  { SetLocalString(oR,"K1", "MAN,HUMAN,WOMAN,HUMANOID"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     176:  { SetLocalString(oR,"K1", "MIRROR"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     177:  { SetLocalString(oR,"K1", "FUTURE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     178:  { SetLocalString(oR,"K1", "NOTHING"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     179:  { SetLocalString(oR,"K1", "TREE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     180:  { SetLocalString(oR,"K1", "SMOKE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     181:  { SetLocalString(oR,"K1", "TRUTH"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     182:  { SetLocalString(oR,"K1", "RIDDLES"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     183:  { SetLocalString(oR,"K1", "TREE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     184:  { SetLocalString(oR,"K1", "SHADOW"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     185:  { SetLocalString(oR,"K1", "TONGUE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     186:  { SetLocalString(oR,"K1", "TONGUE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     187:  { SetLocalString(oR,"K1", "CANDLE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     188:  { SetLocalString(oR,"K1", "CHAIN"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     189:  { SetLocalString(oR,"K1", "KEY"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     190:  { SetLocalString(oR,"K1", "SAILOR"); SetLocalString(oR,"K2","SHIP,BOAT"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     191:  { SetLocalString(oR,"K1", "RIDDLE,DISEASE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     192:  { SetLocalString(oR,"K1", "DARKNESS,THE DARK"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     193:  { SetLocalString(oR,"K1", "DARKNESS,THE DARK"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     194:  { SetLocalString(oR,"K1", "REIGN,REIGNS"); SetLocalString(oR,"K2","REIN,REINS"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     195:  { SetLocalString(oR,"K1", "GOLD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     196:  { SetLocalString(oR,"K1", "BREATH"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     197:  { SetLocalString(oR,"K1", "TREE"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     198:  { SetLocalString(oR,"K1", "MUSIC,SONG"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     199:  { SetLocalString(oR,"K1", "SHIELD"); SetLocalString(oR,"K2",""); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
case     200:  { SetLocalString(oR,"K1", "SHIP,BOAT"); SetLocalString(oR,"K2","ANCHOR"); SetLocalString(oR,"K3",""); SetLocalString(oR,"K4",""); SetLocalString(oR,"K5","");  break; }
//--------------------------------------------------------------------
   //--add your riddles here
case     201:  { SetLocalString(oR,"K1", "HORSESHOE,HORSESHOES,HORSE SHOE,HORSE SHOES"); break; }

    }



}
