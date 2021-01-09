$cipherText = @('R','Y','K','R','J','R','W','F','R','Z','X','Q','E','A','O','W','Q','Y','U','C','Q','E','A','W','U','S','Z','F','S','X','Y','O','S','V','S','E','A','O','U','S','Z','O','V','Q','I','A','Y','K','R','X','N','W','Y','S','I','V','A','M','Q','J','Q','V','Q','Y','U','R','X','D','S','H','A','X','X','A','W','W')
$alphabet = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
$newArray = @{}
$finalArray = @()
$index = 1

$shuffledAlphabet = $alphabet | Sort-Object {get-random}


foreach($cipherLetter in $cipherText){

if( $newArray.Contains($cipherLetter))
{
#if the array already contains the cipher letter, do nothing
}else{
$newArray.Add($cipherLetter, $shuffledAlphabet[$index])
$index++
#Otherwise, add it to the array
}

}

foreach($cipherLetter in $cipherText)
{
if( $newArray.Contains($cipherLetter))
{
$finalarray += $newarray.$cipherletter

}

}

write-host $finalArray
