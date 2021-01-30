$ciphertext = Read-Host "Please enter some text to be decoded"

$ciphertext = $ciphertext -replace " ", ""
$ciphertext = $ciphertext.ToUpper()

$ciphertext = $ciphertext -replace "[^a-zA-Z]", ""


$ciphertext = $ciphertext.tochararray()



$result = @()
$offset = read-host "Please enter the number by which you'd like to offset the text"
#Start with an offset of 1


if($offset -match "^([1-9]|[1][0-9]|[2][0-6])$"){
#validate that the user-inputted offset is actually a number between 1 and 25

foreach($letter in $cipherText){
#consider each letter in the plaintext message

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

}
}
write-host "Offset by $offset"
write-host $result
#Display the results

$result = @()
#Wipe the array, otherwise it would contain all the values for all the offset attempts



#Future improvements: take user input, remove all characters that aren't A-Z, and set the case of all letters to uppercase




}else{
write-host "please enter a number between 1 and 26"


}
