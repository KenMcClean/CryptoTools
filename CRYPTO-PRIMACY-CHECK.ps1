$x = 0

$plainText = read-host "Please enter a message to be hashed"
$publicKey = read-host "Please enter a public key"
#Get the message and the public key of the sender

$isPrime = $true
$plainTextLength = $plainText.length
#Get the length of the message

$modulusInt = [int]$publicKey + [int]$plainTextLength
#Get the result of the public key + the length of the plaintext message

$range = 2..($modulusInt-1)
#Get the range of numbers to be tested



while($x -lt ($modulusInt-1)){
#Loop until the number of loops equals the $modulusInt, minus one

foreach($rangeInt in $range){
$primeTestVar = $modulusInt / $rangeInt 

#write-host "foreach test is" $primeTestVar

if($primeTestVar.GetType().Name -eq 'Int32'){
#write-host "if test is" $primeTestVar

write-host "found a whole number" $primeTestVar
$isPrime = $false

}
$x++

}

}



if($isPrime -eq $true){

write-host "Prime is true"
}



