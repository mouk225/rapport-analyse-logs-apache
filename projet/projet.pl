

use strict;
use warnings;


my $log_file = 'C:\\xampp\\apache\\logs\\access.log';


open(my $fh, '<', $log_file) or die "Impossible d'ouvrir le fichier de logs : $!";


my %event_counts = (
    'Success' => 0,
    'Error' => 0,
    'ConnectionFailure' => 0,
);


my %unique_ips;


while (my $line = <$fh>) {
    chomp($line);
    
    
    if ($line =~ /^(\S+) - - \[(.*?)\] "(.*?)" (\d+) (\d+) "(.*?)" "(.*?)"/) {
        my $ip = $1;
        my $timestamp = $2;
        my $request = $3;
        my $status_code = $4;
        my $bytes_sent = $5;
        
        
        $unique_ips{$ip}++;
        
        
        if ($status_code == 200) {
            $event_counts{'Success'}++;
        } elsif ($status_code >= 400 && $status_code < 500) {
            $event_counts{'Error'}++;
        } elsif ($status_code == 503) {
            $event_counts{'ConnectionFailure'}++;
        }
    }
}


close($fh);


print "Résultats de l'analyse des logs d'Apache :\n";
print "--------------------------------------------\n";
print "Nombre total d'adresses IP uniques : " . scalar(keys %unique_ips) . "\n";
print "Nombre de requêtes réussies : $event_counts{'Success'}\n";
print "Nombre d'erreurs : $event_counts{'Error'}\n";
print "Nombre d'échecs de connexion : $event_counts{'ConnectionFailure'}\n";
