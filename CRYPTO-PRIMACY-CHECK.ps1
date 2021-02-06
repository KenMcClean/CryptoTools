clear
$x = 0


#---------Take the message as an input, and check to see if it's divisible by two. If it's divisible by two, it's not a prime number, and it's length should be offset by 1 unit
#This has the bonus effect of checking to see if the public key input was a number
$message = read-host "Please enter a message to be hashed"
$mlen  = $message.length
if(([int]$mlen / 2 ).GetType().Name -eq 'Int32'){
$message = $message + "0"
}
#---------


#---------Assume both the message and public key are prime, and test to confirm that
$mLenPrime = $true
$pubPrime = $true
#---------


#---------Get the public key, and check to see if it's prime
$publicKey = read-host "Please enter a public key"

$publicKeyRange = 2..($publicKey-1)
#The range starts at 2, because all prime numbers are divisible by 1
#The range ends at the user-supplied value less one, so we're not trying to divide the value by itself

foreach($publicKeyInt in $publicKeyRange){
if(([int]$publicKey / $publicKeyInt ).GetType().Name -eq 'Int32'){
#If any of the numbers between 2 and the public key divide by the public key into a whole number, then the public key is not prime, and we can set $pubPrime to false
$pubPrime = $false
}
}
if($pubPrime -eq $false){
write-host "The public key was not a prime number. Public keys must be prime numbers"
break
}
#---------The public key has now been confirmed to be prime, or the user has been prompted to try again with a prime number


#---------Set the same style of range, using the message length minus 1 as the maximum
$messageRange = 2..($mlen-1)
foreach($mLenInt in $messageRange){

if(([int]$mlen / $mLenInt).GetType().Name -eq 'Int32'){
$mLenPrime = $false
#Again, if the length of the message divided by any of the numbers in the range is a whole number, then the message length is not a prime number
}}
#---------


#---------So long as the message length is not prime, run this function
while($mLenPrime -eq $false){

$messageRange = 2..($message.length-1)

foreach($int in $messageRange){

if(([int]$message.length / $Int).GetType().Name -eq 'Int32'){
#For each integer in the message length range, if the message length divided by the integer is whole, the length of the message is still not prime
$mLenPrime = $false
$message = $message +"0"
#Therefor, we should pad the message with another character, and test it again to see if it's prime
}else{
#Otherwise the length must be prime. This only works because we're testing each integer in the range, and setting it to true or false
$mLenPrime = $true
}
}
}
#---------


write-host "Mlen is" $message.Length
write-host "Public key is" $publicKey
write-host "Ahash is" ([int]$publicKey*[int]$message.Length)
write-host "Message is "$message

