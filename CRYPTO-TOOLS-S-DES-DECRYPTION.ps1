clear
$input = @(0,1,1,0,0, 1,1,1,0,1)
#Round key generation takes the 10-bit master key as input

write-host "Round key generation takes the 10-bit master key as input.  Our key is $input `n"
write-host "#######Round Key 1 Generation Begins#######`n" -ForegroundColor DarkGreen -BackgroundColor White
$keyhalfright = $input[6..9]
#We then divide the key in half...

$keyhalfright +=$input[5]
#...and left-shift it one bit

$keyhalfleft =  $input[1..4]
$keyhalfleft += $input[0]
#We do the same for the left half

write-host "The master key is then divided in half:" $input[0..4]"," $input[5..9] "`n"
write-host "The two halves are then each bit-shifted 1 to the left: " $keyhalfleft "," $keyhalfleft "`n"

$lshiftKey1 = $keyhalfleft+$keyhalfright
write-host "We then combine the two shifted halves back into one 10-bit key, so we can use it for input to the Permutation-8 function: " $lshiftKey1 "`n"

$permutation8 = @(0,0,0,0,0,0,0,0)
#All permutation arrays in the script need default vaules, or we get an out of bounds error

$permutation8[0] = $lshiftKey1[5]
$permutation8[1] = $lshiftKey1[2]
$permutation8[2] = $lshiftKey1[6]
$permutation8[3] = $lshiftKey1[3]
$permutation8[4] = $lshiftKey1[7]
$permutation8[5] = $lshiftKey1[4]
$permutation8[6] = $lshiftKey1[9]
$permutation8[7] = $lshiftKey1[8]
#We apply the Permutation-8 schedule, dropping the first two bits

$key1 = $permutation8 
write-host "After applying Permutation-8, the Round Key 1 is: " $key1 "`n"
write-host "#######Round Key 1 Generation Ends#######`n" -ForegroundColor DarkGreen -BackgroundColor White
write-host "#######Round Key 2 Generation Begins#######`n" -ForegroundColor DarkBlue -BackgroundColor White

write-host "Now we left-shift the same master key, but by two bits`n"

$keyhalfright = $input[7..9]

$keyhalfright +=$input[5..6]

$keyhalfleft =  $input[2..4]

$keyhalfleft += $input[0..1]

write-host "We end up with a shifted left-half of the key that is" $keyhalfleft ", and a shifted right-half of the key that is " $keyhalfright "`n"

$lshiftKey2 = $keyhalfleft+$keyhalfright
Write-host "Again we combine back into a 10-bit key, and feed into Permutation-8`n"

$permutation8 = @(0,0,0,0,0,0,0,0)

$permutation8[0] = $lshiftKey2[5]
$permutation8[1] = $lshiftKey2[2]
$permutation8[2] = $lshiftKey2[6]
$permutation8[3] = $lshiftKey2[3]
$permutation8[4] = $lshiftKey2[7]
$permutation8[5] = $lshiftKey2[4]
$permutation8[6] = $lshiftKey2[9]
$permutation8[7] = $lshiftKey2[8]

$key2 = $permutation8

write-host "After applying Permutation-8, the Round Key 2 is: " $key2 "`n"
write-host "This is the end of the key generation. We may now proceed with decryption`n"

write-host "#######Round Key 2 Generation Ends#######`n" -ForegroundColor DarkBlue -BackgroundColor White
write-host "#######Decryption Round 1 Begins#######" -ForegroundColor DarkRed -BackgroundColor White
Write-host "Encryption and Decryption in S-DES use the same functions. The only difference is that in decryption, we start with Initial Permutation-1 (inverse)`n"

write-host "We must first apply Initial Permutation Inverse to the ciphertext.`n"

$ciphertext = @(1,0,1,0,0,0,1,0)
$permutedtext = @(0,0,0,0,0,0,0,0)

$permutedtext[0] = $ciphertext[3]
$permutedtext[1] = $ciphertext[0]
$permutedtext[2] = $ciphertext[2]
$permutedtext[3] = $ciphertext[4]
$permutedtext[4] = $ciphertext[6]
$permutedtext[5] = $ciphertext[1]
$permutedtext[6] = $ciphertext[7]
$permutedtext[7] = $ciphertext[5]

write-host "The Initial Permuted value (inverse) is: " $permutedtext "`n"

$expandedPermutedInput = $permutedtext[4..7]
write-host "The Expanded Permutation function takes as input the right half of the Initual Permutation-1, which is: " $expandedPermutedInput "`n"

$expanded = @(0,0,0,0,0,0,0,0)
#All permutation arrays in the script need default vaules, or we get an out of bounds error

#Let's Expand and Permutate the four input bits
$expanded[0] = $expandedPermutedInput[3]
$expanded[1] = $expandedPermutedInput[0]
$expanded[2] = $expandedPermutedInput[1]
$expanded[3] = $expandedPermutedInput[2]
$expanded[4] = $expandedPermutedInput[1]
$expanded[5] = $expandedPermutedInput[2]
$expanded[6] = $expandedPermutedInput[3]
$expanded[7] = $expandedPermutedInput[0]

write-host "The Expanded and Permuted output is: " $expanded "`n"

Write-host "Now we need to XOR Round Key 1 against the 8-bit output of Expand and Permutate`n" 
$xorEPKey1 = @()
#This array doesn't need to be filled with default values because we're not replacing values, we're simply adding them

$x = 0
while($x -lt 8){

if(($key1[$x] -xor $expanded[$x]) -EQ $TRUE){
#XOR the bit at Key index position X against the bit at Expanded and Permuted Output position X
#If the result is true, add a 1 to the array. Otherwise add a zero.
$xorEPKey1 += "1"
write-host "Added a 1 because we're XORing" $key1[$x] "and" $expanded[$x]

}else
{$xorEPKey1 += "0"
write-host "Added a 0 because we're XORing" $key1[$x] "and" $expanded[$x]

}
$x++
}
write-host "The XORed value of Key 1 against the Expanded and Permuted value is: " $xorEPKey1 "`n"

#We now take the output of XORing Key1 against the EP value, and feed them into the S-Boxes
$xorEPKey1 = [System.Int32[]]$xorEPKey1
#We need to cast the array containing the XORed output as integers

$s1Input = $xorEPKey1[4..7]
#The S0 S-Box takes the right half of the XORed output as input

$s0Input = $xorEPKey1[0..3]
#The S1 S-Box takes the left half of the XORed output as input

$s0rowcoord = ([int]$s0Input[0]*2) + ($s0Input[3]*1)
#The row coordinates for S0 are the first and last bit
write-host "The row coordinate for S0 is" $s0rowcoord
$s0columncoord = ($s0Input[1]*2) + ($s0Input[2]*1)
write-host "The row coordinate for S0 is" $s0columncoord
#The column coordinates for S0 are the second and third bit

$s1rowcoord = ($s1Input[0]*2) + ($s1Input[3]*1)
#The row coordinates for S1 are the first and last bit
write-host "The row coordinate for S1 is" $s1rowcoord
$s1columncoord = ($s1Input[1]*2) + ($s1Input[2]*1)
write-host "The row coordinate for S1 is" $s1columncoord

#The column coordinates for S1 are the second and third bit


$s0 = @(("01","00",	"11", "10"),("11","10","01", "00"),("00","10","01", "11"),("11", "01","11", "10"))
$s1 = @(("00","01","10","11"),("10","00","01","11"),("11","00","01","00"),("10","01","00","11"))
#The S-boxes are broken out into multidimensional arrays. Essentially to search for the row we find the correct subarray, and then to find the column value we search within that array

write-host "The S-Box value for S0 is: "  $s0[$s0rowcoord][$s0columncoord]
write-host "The S-Box value for S1 is: "  $s1[$s1rowcoord][$s1columncoord]

[System.Int32[]]$sBoxOutput = $s0[$s0rowcoord][$s0columncoord]+$s1[$s1rowcoord][$s1columncoord]

write-host "Therefor the output of the S-Box function is " 



$sBoxOutput = [int[]](($sBoxOutput -split '') -ne '')


#we then apply the permutation-4 function to the output of S-Box

$p4 = @()
#All permutation arrays in the script need default vaules, or we get an out of bounds error

$p4 +=  $sBoxOutput[1]
$p4 +=  $sBoxOutput[3]
$p4 +=  $sBoxOutput[2]
$p4 +=  $sBoxOutput[0]



#We must now XOR P4 with the left half of the output of Initial Permutation-1, from way back at the start
#This XOR function is the same as that we applied against P8, except that it's four bits instead of eight



#We need to be able to reference these values as a single variable, rather than calling the range within the XOR function
$xorP4 = @()




$x = 0
while($x -lt 4){
if(($ipLeftHalf[$x] -xor $p4[$x]) -EQ $TRUE){
$xorP4 += "1"
write-host "Add a 1 because the values we're XORING are" $ipLeftHalf[$x]  "and" $p4[$x]
}else
{$xorP4 += "0"
write-host "Add a 0 because the values we're XORING are" $ipLeftHalf[$x] "and" $p4[$x]

}


$x++
}





write-host "We XORed $iplefthalf with $p4, and the result is $xorP4 " 


#Now combine the XORed P4 with the right half of the ouput of Initual Permutation-1

$round1FinalValue = $xorP4 + $permutedtext[4..7]

$iprighthalf = $permutedtext[4..7]

Write-host "We now combine the XORed P4 ($xorP4) with the right half of the ouput of Initual Permutation-1($ipRightHalf)" 

write-host "The final output of round 1 is: " $round1FinalValue 

#This is the end of Decryption Round 1.  We take the resulting value and do the same thing again, except that we feed in Key 2 instead of Key 1

write-host "#######Decryption Round 1 Ends#######`n" -ForegroundColor DarkRed -BackgroundColor White


write-host "#######Decryption Round 2 Begins#######`n" -ForegroundColor DarkMagenta -BackgroundColor White


$round2Input = $round1FinalValue
#The input for Decryption Round 2 is the output of Decryption Round 1. However, the halves must first be swapped.

Write-host "Before we begin decrypting, we must swap the two halves of the input coming from Round 1"

write-host "The input from Round 1 is $round2input"

$round2InputSwapped = $round2input[4..7]+$round2input[0..3]

write-host "The swapped input is $round2InputSwapped"



$expandedPermutedInput = $round2InputSwapped[4..7]
write-host "The input to the Expanded Permutation function is the right half of the input, which is: " $expandedPermutedInput

$expanded = @(0,0,0,0,0,0,0,0)
#All permutation arrays in the script need default vaules, or we get an out of bounds error
$expanded[0] = $expandedPermutedInput[3]
$expanded[1] = $expandedPermutedInput[0]
$expanded[2] = $expandedPermutedInput[1]
$expanded[3] = $expandedPermutedInput[2]
$expanded[4] = $expandedPermutedInput[1]
$expanded[5] = $expandedPermutedInput[2]
$expanded[6] = $expandedPermutedInput[3]
$expanded[7] = $expandedPermutedInput[0]

write-host "The Expanded and Permuted output is: " $expanded

#XOR Key1 against the EP output
#This is the same XOR function as Round 1, but we feed in Key 2 instead of Key 1
$xorEPKey2 = @()
$x = 0
while($x -lt 8){
if(($key2[$x] -xor $expanded[$x]) -EQ $TRUE){
$xorEPKey2 += "1"
write-host "Add a 1 because the values we're XORING are" $key2[$x] "and " $expanded[$x]
}else
{$xorEPKey2 += "0"}
write-host "Add a 0 because the values we're XORING are" $key2[$x] "and " $expanded[$x]
$x++
}
write-host "The XORed value of Key 2 against the Expanded and Permuted value is: " $xorEPKey2

#We now take the output of XORing Key 2 against the EP value, and use this as input for the S-Box functions

$xorEPKey2 = [System.Int32[]]$xorEPKey2

$s0Input = $xorEPKey2[4..7]
$s1Input = $xorEPKey2[0..3]




$s0rowcoord = ([int]$s0Input[0]*2) + ($s0Input[3]*1)
#The row coordinates for S0 are the first and last bit
write-host "The row coordinate for S0 is" $s0rowcoord
$s0columncoord = ($s0Input[1]*2) + ($s0Input[2]*1)
write-host "The row coordinate for S0 is" $s0columncoord
#The column coordinates for S0 are the second and third bit

$s1rowcoord = ($s1Input[0]*2) + ($s1Input[3]*1)
#The row coordinates for S1 are the first and last bit
write-host "The row coordinate for S1 is" $s1rowcoord
$s1columncoord = ($s1Input[1]*2) + ($s1Input[2]*1)
write-host "The row coordinate for S1 is" $s1columncoord

#The column coordinates for S1 are the second and third bit


$s0 = @(("01","00",	"11", "10"),("11","10","01", "00"),("00","10","01", "11"),("11", "01","11", "10"))
$s1 = @(("00","01","10","11"),("10","00","01","11"),("11","00","01","00"),("10","01","00","11"))
#The S-boxes are broken out into multidimensional arrays. Essentially to search for the row we find the correct subarray, and then to find the column value we search within that array

write-host "The S-Box value for S0 is: "  $s0[$s0rowcoord][$s0columncoord]
write-host "The S-Box value for S1 is: "  $s1[$s1rowcoord][$s1columncoord]

[System.Int32[]]$sBoxOutput = $s0[$s0rowcoord][$s0columncoord]+$s1[$s1rowcoord][$s1columncoord]

write-host "Therefor the output of the S-Box function is " 



$sBoxOutput = [int[]](($sBoxOutput -split '') -ne '')


#we then apply the permutation-4 function to the output of S-Box

$p4 = @()
#All permutation arrays in the script need default vaules, or we get an out of bounds error

$p4 +=  $sBoxOutput[1]
$p4 +=  $sBoxOutput[3]
$p4 +=  $sBoxOutput[2]
$p4 +=  $sBoxOutput[0]





#We must now XOR P4 with the left half of the output of Initial Permutation-1, from way back at the start
#This XOR function is the same as that we applied against P8, except that it's four bits instead of eight





#We need to be able to reference these values as a single variable, rather than calling the range within the XOR function
$xorP4 = @()






$x = 0
while($x -lt 4){
if(($ipLeftHalf[$x] -xor $p4[$x]) -EQ $TRUE){
$xorP4 += "1"
write-host "Add a 1 because the values we're XORING are" $ipLeftHalf[$x]  "and" $p4[$x]
}else
{$xorP4 += "0"
write-host "Add a 0 because the values we're XORING are" $ipLeftHalf[$x] "and" $p4[$x]

}


$x++
}
write-host "We XORed $iplefthalf with $p4, and the result is $xorP4 " 

#Now combine the XORed P4 with the right half of the ouput of Initual Permutation-1
$round2FinalValue = $xorP4 + $permutedtext[4..7]
$iprighthalf = $permutedtext[4..7]

Write-host "We now combine the XORed P4 ($xorP4) with the right half of the ouput of Initual Permutation-1($ipRightHalf)" 

#Now apply the Initial Permutation (non-inverse) to the output

$permutedtext = @(0,0,0,0,0,0,0,0)

$permutedtext[0] = $round2FinalValue[1]
$permutedtext[1] = $round2FinalValue[5]
$permutedtext[2] = $round2FinalValue[2]
$permutedtext[3] = $round2FinalValue[0]
$permutedtext[4] = $round2FinalValue[3]
$permutedtext[5] = $round2FinalValue[7]
$permutedtext[6] = $round2FinalValue[4]
$permutedtext[7] = $round2FinalValue[6]


write-host "#######Decryption Round 2 Ends#######`n" -ForegroundColor DarkMagenta -BackgroundColor White

write-host "The plaintext bits are: " $permutedtext

#>
