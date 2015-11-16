#!/usr/bin/perl -w

# An open source text normalizer and tokenizer for Persian
# Version 1.0
# Written by M. Amin Farajian at HLT group in FBK.
# The text normalization rules are mostly borrowed from the "Persian Pre-processor" script written by Mojgan Seraji.

use encoding "utf8";
open STDIN, "<:encoding(UTF-8)" ;
open STDOUT, "<:encoding(UTF-8)" ;

use FindBin qw($RealBin);
use strict;

my $language = "fa";
my $NORMALIZE = 0;
my $HELP = 0;

while (@ARGV) 
{
	$_ = shift;
	/^-h$/ && ($HELP = 1, next);
	/^-normalize$/ && ($NORMALIZE = 1, next);
}

if ($HELP) 
{
	print "Usage ./tokenizer-fa.perl < input-file > output-file\n";
        print "Options:\n";
        print "  -normalize  ... enable the text normalization procedure before tokenizing the text.\n";
	exit;
}



while(<STDIN>) 
{
    print &tokenize($_);
}

#####################################################################################
# tokenize a batch of texts saved in an array
# input: an array containing a batch of texts
# return: another array containing a batch of tokenized texts for the input array

# the actual tokenize function which tokenizes one input string
# input: one string
# return: the tokenized string for the input string
sub tokenize{
    my($text) = @_;
    if( $NORMALIZE ){
        $text=&normalize($text);
    }
    $text =~ s/([^\p{IsN}])([,|.])([^\p{IsN}])/$1 $2 $3/g;
    # separate , pre and post number
    $text =~ s/([\p{IsN}])([,|.])([^\p{IsN}])/$1 $2 $3/g;
    $text =~ s/([^\p{IsN}])([,|.])([\p{IsN}])/$1 $2 $3/g;
    $text =~ s/([^A-Za-z\s]?)([A-Za-z]+)([^A-Za-z\s]?)/$1 $2 $3/g;
    $text =~ s/([ا-ی\x{200C}]+)([0-9]+)/$1 $2/g;
    $text =~ s/([0-9]+)([ا-ی\x{200C}]+)/$1 $2/g;
    $text =~ s/(\p{L})(^\p{L}\S)/$1 $2/g;

    # Assume sentence tokenization has been done first, so split FINAL periods only.
    $text =~ s=([^.])([.])([\]\)}>"']*) ?$=$1 $2$3 =g;
    # however, we may as well split ALL question marks and exclamation points,
    # since they shouldn't have the abbrev.-marker ambiguity problem
    $text =~ s=([?!])= $1 =g;
    # parentheses, brackets, etc.
    $text =~ s=([\]\[\(\){}<>])= $1 =g;
    $text =~ s=--= -- =g;
    # First off, add a space to the beginning and end of each line, to reduce necessary number of regexps.
    $text =~ s=$= =;
    $text =~ s=^= =;
    #$text =~ s="= '' =g;
                                                                            


    $text =~ s=([…"'«»;:,\\\/@#\$%&\p{IsSc}\p{IsSo}])= $1 =g; #"
    # clean out extra spaces
    $text =~ s=  *= =g;
    $text =~ s=^ *==g;
    $text =~ s= *$==g;
    $text =~ s/\x{200C}\x{200C}+/\x{200C}/g;
    $text =~ s/\s+\x{200C}+/ /g;
    $text =~ s/\x{200C}+\s+/ /g;
    $text =~ s/\s\s+/ /g;

    return $text;
}
sub normalize
{
    my($text) = @_;
    
    $text =~ s/\s+/ /g;
    $text =~ s/[\x{200E}|\x{200F}]+/ /g;
    $text =~ s/[\000-\037]//g;
    $text =~ tr/٠١٢٣٤٥٦٧٨٩/0123456789/;
    $text =~ tr/۰۱۲۳۴۵۶۷۸۹/0123456789/;
    $text =~ s/[أإٱﭐﭑﴼﴽﺂﺃﺄﺇﺈﺍﺎ]/ا/g;
    $text =~ s/[آﺁ]/آ/g;
    $text =~ s/[بﺏﺐﺑﺒ]/ب/g;
    $text =~ s/[ﭖﭗﭘﭙ]/پ/g;
    $text =~ s/[تﺕﺖﺗﺘ]/ت/g;
    $text =~ s/[ثﺙﺚﺛﺜ]/ث/g;
    $text =~ s/[جﺝﺞﺟﺠ]/ج/g;
    $text =~ s/[چﭺﭻﭼﭽ]/چ/g;
    $text =~ s/[حﺡﺢﺣﺤ]/ح/g;
    $text =~ s/[خﺥﺦﺧﺨ]/خ/g;
    $text =~ s/[دﺩﺪ]/د/g;
    $text =~ s/[ذﺫﺬ]/ذ/g;
    $text =~ s/[رﺭﺮ]/ر/g;
    $text =~ s/[زﺯﺰ]/ز/g;
    $text =~ s/[ژﮊﮋ]/ژ/g;
    $text =~ s/[سﺱﺲﺳﺴ]/س/g;
    $text =~ s/[شﺵﺶﺷﺸ]/ش/g;
    $text =~ s/[صﺹﺺﺻﺼ]/ص/g;
    $text =~ s/[ضﺽﺾﺿﻀ]/ض/g;
    $text =~ s/[طﻁﻂﻃﻄ]/ط/g;
    $text =~ s/[ظﻅﻆﻇﻈ]/ظ/g;
    $text =~ s/[عﻉﻊﻋﻌ]/ع/g;
    $text =~ s/[غﻍﻎﻏﻐ]/غ/g;
    $text =~ s/[فﻑﻒﻓﻔ]/ف/g;
    $text =~ s/[قﻕﻖﻗﻘ]/ق/g;
    $text =~ s/[كکﮎﮏﮐﮑﻙﻚﻛﻜ]/ک/g;
    $text =~ s/[گﮒﮓﮔﮕ]/گ/g;
    $text =~ s/[لﻝﻞﻟﻠ]/ل/g;
    $text =~ s/[مﻡﻢﻣﻤ]/م/g;
    $text =~ s/[نﻥﻦﻧﻨ]/ن/g;
    $text =~ s/[وﻭﻮ]/و/g;
    $text =~ s/[ؤﺅﺆ]/ؤ/g;
    $text =~ s/[ۀةهﮤﮥﺓﺔﻩﻪﻫﻬ]/ه/g;
    $text =~ s/[ىيیﯨﯼﯩﯽﯾﯿﻯﻰﻱﻲﻳﻴ]/ی/g;
    $text =~ s/[ئﺉﺊﺋﺌ]/ئ/g;
    # seperate out all "other" special characters
    $text =~ s/[ﻵﻶﻷﻸﻹﻺﻻﻼ]/لا/g;
    $text =~ s/﷼/ریال/g;
    $text =~ s/([بعدا|فعلا|قطعا|احتمالا|قویا|یقینا|عملا|علنا|اساسا|نسبتا|مجددا|دایما|کاملا|تقریبا|قویا|اصلا])"/$1/g;
    $text =~ tr/،؛؟٫٪\x{066C}\x{0670}/,;?\/%'/; # \x{066C} and \x{0670} sometimes are used as apostrof(')
    #The following line is for removing all kinds of Hamze, Tanvin, Kasreh, Zameh, Fathe, Tashdid
    $text =~ s/\x{0618}|\x{0619}|\x{0621}|\x{064B}|\x{064C}|\x{064D}|\x{064E}|\x{064F}|\x{0650}|\x{0651}|\x{0652}|\x{0653}|\x{0654}|\x{0655}|\x{0656}|\x{0657}|\x{0658}|\x{0659}|\x{065A}|\x{065B}|\x{065C}|\x{065D}|\x{065E}|\x{FC5E}|\x{FC5F}|\x{FC60}|\x{FC60}|\x{FC61}|\x{FC62}|\x{FE80}//g;
    #Remove Keshide character
    $text =~ s/ـ//g; 
    $text =~ s/\.{3}/…/g;
    $text =~ s/\'\'/\"/g;
    #Remove non-necessary zwnj characters
    $text =~ s/(\s+\x{200C}+|\x{200C}+\s+)/ /g;

    #Correct the spaces between the tokens:
    #می نمی
    $text =~ s/\b(ن?می)\s+/$1\x{200C}/g;
    
    $text =~ s/\s+(تر((ی)?ن)?)\b/\x{200C}$1/g;
    $text =~ s/\s+((ها)ی?(ی|م|ت|ش|مان|مون|تان|تون|شان|شون)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(مان|مون|تان|تون|شان|شون)\b/\x{200C}$1/g;
    # for suffix ZA/ZAy/ZAee like DarAmad Za
    $text =~ s/\s+(((زا)ی?)ی?)\b/\x{200C}$1/g;
    $text =~ s/\s+(ام|ات|اش|ای(د)?|ایم|ان(د)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(ایی)\b/\x{200C}$1/g;
    $text =~ s/\s+(ایی)\b/\x{200C}$1/g;
    $text =~ s/\s+(جات)\b/\x{200C}$1/g;
    $text =~ s/\s+(آور)\b/\x{200C}$1/g;
    $text =~ s/\s+(نشین)\b/\x{200C}$1/g;
    #sam pAshi
    $text =~ s/\s+(پاش(ی)?)\b/\x{200C}$1/g;
    #
    $text =~ s/\s+(پوش(ان|انی|ی)?)\b/\x{200C}$1/g;
    #hame porsi / ahvAl porsi
    $text =~ s/\s+(پرسی)\b/\x{200C}$1/g;
    $text =~ s/\s+(پرور(ی)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(پریش(ی)?)\b/\x{200C}$1/g;
    #ahd shekan / ahd shekani
    $text =~ s/\s+(شکن(ی)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(پذیر(ی)?)\b/\x{200C}$1/g;
    #gel andood
    $text =~ s/\s+(اندود)\b/\x{200C}$1/g;
    #gham angiz
    $text =~ s/\s+(انگیز(ی)?)\b/\x{200C}$1/g;
    #rooh/cheshm/del navaz
    $text =~ s/\s+(نواز(ی)?)\b/\x{200C}$1/g;
    
    $text =~ s/\s+(فشان(ی)?)\b/\x{200C}$1/g;
    $text =~ s/\s+((ساز)ی?)\b/\x{200C}$1/g;
    $text =~ s/\s+(زدایی)\b/\x{200C}$1/g;
    $text =~ s/\s+(آلود(ی)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(آمیز(ی)?)\b/\x{200C}$1/g;
    #pand/ebrat/dars/dAnesh Amuz
    $text =~ s/\s+(آموز(ی)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(زدا((ی)?ی?))\b/\x{200C}$1/g;
    $text =~ s/\s+(خیز(ی)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(راه)\s+((حل)ی?|آهن|(انداز)ی?|(ساز)ی?|(گشا)ی?ی?)/$1\x{200C}$2/g;

    $text =~ s/\s+(سوز(ی)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(پراکنی)\b/\x{200C}$1/g;
    $text =~ s/\s+(خور(ی)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(افکن(ی)?)\b/\x{200C}$1/g;
    $text =~ s/\s+(گویان)\b/\x{200C}$1/g;
    $text =~ s/\s+(کاران(ی?|ه?))\b/\x{200C}$1/g;
    #Aele/dard mand-  Adam kosh - ravAn nevis -
    $text =~ s/\s+((مند|نویس|دان|کش|پرداز|ور)(ی?|ان?ی?|ها?|های?|هایی?))\b/\x{200C}$1/g;
    $text =~ s/\b(آهنگ|قطعه|فیلم)\s+((ساز)(ی?|ان?ی?|ها?|های?|هایی?))\b/$1\x{200C}$2/g;
    $text =~ s/\s+(ساله|ساعتع)\b/\x{200C}$1/g;
    $text =~ s/\s+(پاشیدگی)\b/\x{200C}$1/g;
    $text =~ s/\s+((شناس)ی?ان?)\b/\x{200C}$1/g;
    $text =~ s/\s+(پژوه(ی)?)\b/\x{200C}$1/g;
    #aragh rizAn
    $text =~ s/\s+(ریزان)\b/\x{200C}$1/g;
    $text =~ s/\s+((سنج)ی?)\b/\x{200C}$1/g;
    $text =~ s/\s+((رسان)ی?)\b/\x{200C}$1/g;
    $text =~ s/\s+((وار)ه?)\b/\x{200C}$1/g;
    $text =~ s/\s+((یاب)ی?)\b/\x{200C}$1/g;
    $text =~ s/\s+((گان)ه?)\b/\x{200C}$1/g;
    $text =~ s/\s+((پیما)(ها)?ی?ی?)\b/\x{200C}$1/g;
    $text =~ s/\s+(گی)\b/\x{200C}$1/g;
    $text =~ s/\s+((گر)ی?)\b/\x{200C}$1/g;
    $text =~ s/\s+(سار)\b/\x{200C}$1/g;
    $text =~ s/\s+(پیاده|سواره)\s((رو)(ها)?ی?ی?)/$1\x{200C}$2/g;
    $text =~ s/\b(بین)\s+((الملل)ی?)\b/$1\x{200C}$2/g;

    $text =~ s/\b(جمع|تقسیم|بودجه|طبقه|قفسه|یخ|صف|آینه|آیینه|خالی)\s+((بند)ی?)\b/$1\x{200C}$2/g;
    $text =~ s/\b(یخ)\s+((بند)ان?)\b/$1\x{200C}$2/g;

    $text =~ s/\b(فوق)\s+((العاده)(ای)?)\b/$1\x{200C}$2/g;
    $text =~ s/\b(این|آن)(ها|که|رو|گونه|جا|(جور|طور)ی?)\b/$1\x{200C}$2/g;
    $text =~ s/\b(این|آن)(را|ور)\b/$1 $2/g;
    #Remove the Ya which is used as EZAFE (khAne ye man | khAne ye ghadimi)
    $text =~ s/\b(ی)\b//g;
    #a word can not end with آ
    $text =~ s/\Bآ\b/ا/g;

####### Prefixes
#NOTE: Prefixes should attach to the next word, and no \x{200C} is required (except the ones that end in Ya or Ha)

    $text =~ s/\b(نا|غیر|فرا)\s+/$1/g;
    $text =~ s/\b(بی)\s+/$1/g;
    $text .= "\n" unless $text =~ /\n$/;
    return $text;
}

