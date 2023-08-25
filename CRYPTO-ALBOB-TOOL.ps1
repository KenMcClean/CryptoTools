clear
$plaintext = ""
$ciphertext = ""
$multiple = 230683 * $day
#multiply the secret by the date
function Get-Site
{
$site=Read-Host "Enter E to encode, D to decode, or X to exit"
#By using a switch, we only give the user three choices.  That way, we don't need to do error handling
Switch ($site)ffffffffffffffffffffffffffffffffffffffffffffff
E {$input = read-host "Please enter a message to be encoded"
$charArray = $input.tochararray()
#Add the characters to an array
$day = get-date -format "dd"
#Get today's date
$multiple = 230683 * $day
$ciphertext = ""
foreach($char in $chararray)
{
$charvalue = [int[]][char]$char
#get the ASCII value of the character
foreach($letter in $charvalue){
$value = $letter * $multiple
#multiply the ascii value of the letter by (secret * date)
write-host "value is $Value"
write-host "$value is type" $value.gettype()
$value = $value.ToString() + " "
#Turn the value into a string so we can add a space to it
$ciphertext += $value
}}
$date = Get-Date
write-host $ciphertext
write-host "Message encoded on $date"
#spit out C, the ciphertext
}
D {$input = read-host "Please enter an encrypted value to be decoded"
$input = $input.split(" ")
#Split the string of values when a space is encountered
foreach($value in $input){
if($value.Length -ne 8){
#If the value isn't 8 characters long, something's gone wrong with the entry
write-host "$value is not a valid entry"
}Else{
$value = $value / $multiple
#Divide the value by the multiple
$plaintext += ([Char][int]$value)
#Turn the ASCII value back into a character
}
}
write-host $plaintext
}
X {Read-Host -Prompt "Press Enter to exit"}
}}
run-choice






















