$cipherText = (<ciphertext>)
#The plaintext is hardcoded in.  This could be adjusted take user input

$result = @()
$offset = 3
#Start with an offset of 1

foreach($letter in $cipherText){
#consider each letter in the plaintext message
$letter = $letter.ToUpper()

$sub = [int[]][char]$letter
#get the ascii value of the letter, so that we can shift it

foreach($item in $sub)
#Consider each letter value
{

$item = $item - $offSet
#Make the ASCII value of the letter it's value minus the offset

if($item -lt 65){
#If the ASCII value of the offset letter is less than 65, we've strayed beyond the values assigned to letters, and need to loop back around

$item = $item + 26 }
#We loop back around by adding 26 to the ASCII Value of the letter. 
#Therefor, instead of taking the value of A and taking three from it, we turn it into a Z and take three from it 

$result += [char]$item
#Add the results to an array
}}
write-host "Offset by $offset"
write-host $result
#Display the results

$result = @()
#Wipe the array, otherwise it would contain all the values for all the offset attempts
