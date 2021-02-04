clear
function Get-Site
{
	$site=Read-Host "Enter E to encode, D to decode, or X to exit"
	Switch ($site)
	{
		E {$input = read-host "Please enter a message to be encoded"

$input = $input.ToString()
$input = $input.toupper()
#Take all of the characters and make them uppercase

$charArray = $input.tochararray()
#Add the characters to an array

$day = get-date -format "dd"
#Get today's date

$factor =  230683 * $day
#multiply the secret by the date

$ciphertext = ""

foreach($char in $chararray)
{
$charvalue = [int[]][char]$char
#get the ASCII value of the character

foreach($letter in $charvalue){

$value = $letter * $factor
#multiply the ascii value of the letter by (secret * date)

$value = $value.ToString() + " "
#Turn the value into a string so we can add a space to it

$ciphertext += $value
}
}
write-host $ciphertext
}
		D {$input = read-host "Please enter an encrypted value to be decoded"

$input = $input.split(" ")

foreach($value in $input){

$value = $value / $factor

[Char][int]$value
$x = 1
}}
X {Read-Host -Prompt "Press Enter to exit"}
}}

get-site


