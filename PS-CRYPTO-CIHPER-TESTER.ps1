$cipherText = @('R','Y','K','R','J','R','W','F','R','Z','X','Q','E','A','O','W','Q','Y','U','C','Q','E','A','W','U','S','Z','F','S','X','Y','O','S','V','S','E','A','O','U','S','Z','O','V','Q','I','A','Y','K','R','X','N','W','Y','S','I','V','A','M','Q','J','Q','V','Q','Y','U','R','X','D','S','H','A','X','X','A','W','W')
$alphabet = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
$newArray = @{}
$temp = ""
$hash = @{"C" = "g"; "A" = "e"; "F" = "c"; "J" ="b"; "K" ="h"; "R" ="a"; "W" ="s"; "Y" ="t" ; "S" ="o";"h" = "p";"X" = "n";"N" = "k";"D" = "d"; "Z" = "u"; "U" = "y";"Q" = "i"; "M" = "x";"V" = "l"; "E"="v"; "O"="r"; "I" = "f"}

foreach($letter in $cipherText){
if($hash.Contains($letter)){
$temp = $temp + $hash.Get_Item($letter)
}else{
$temp = $temp + $letter
}




}
$temp
