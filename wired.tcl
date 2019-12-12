#create a simulator object
set ns [new Simulator]

#Setting colours
$ns color 0 red 
$ns color 1 blue

#create a trace file
set tracefile [open wired.tr w]
$ns trace-all $tracefile

#create a animation info or nam file
set namfile [open wired.nam w]
$ns namtrace-all $namfile

#create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]





#create link
#droptail means dropping the tail
$ns duplex-link $n0 $n1 5Mb 2ms DropTail
$ns duplex-link $n1 $n2 10Mb 6ms DropTail
$ns duplex-link $n1 $n4 3Mb 2ms DropTail
$ns duplex-link $n4 $n3 100Mb 2ms DropTail
$ns duplex-link $n4 $n5 4Mb 10ms DropTail

#setting Queue limit
$ns queue-limit $n1 $n4 2

#creation of agents
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n0 $udp
$ns attach-agent $n3 $null
$ns connect $udp $null

#creation of TCP agent
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]

$ns attach-agent $n2 $tcp
$ns attach-agent $n5 $sink
$ns connect $tcp $sink

#Creation of Application CBR, FTP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
set ftp [new Application/FTP]
$ftp attach-agent $tcp

#Start Traffic
$ns at 1.0 "$cbr start"
$ns at 2.0 "$ftp start"

$ns at 10.0 "finish"   
proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
        #exec xgraph out0.tr out1.tr out2.tr -geometry 800x400 &
	close $tracefile
	close $namfile
	exit 0
}

puts "Simulation is starting"
$ns run

