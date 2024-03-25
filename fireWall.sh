# Par défaut, tout trafic est interdit
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Politique 1 : Tous les hôtes du réseau privé peuvent réaliser des commandes ping sur toutes les machines du réseau public, mais pas l'inverse.
iptables -A FORWARD -s 10.0.0.0/24 -d 200.0.0.0/24 -p icmp --icmp-type 8 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Politique 2 : Tous les hôtes du réseau privé peuvent ouvrir une connexion HTTP sur les serveurs web du réseau public.
iptables -A FORWARD -s 10.0.0.0/24 -d 200.0.0.0/24 -p tcp --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Politique 3 : Tous les hôtes du réseau public peuvent ouvrir une connexion HTTP sur le serveur web du pc5.
iptables -A FORWARD -s 200.0.0.0/24 -d 10.0.0.5 -p tcp --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Politique 4 : Tous les hôtes du réseau privé peuvent réaliser des commandes ping sur l’interface eth0 du routeur mais pas l’inverse.
iptables -A INPUT -i eth0 -p icmp --icmp-type 8 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o eth0 -p icmp --icmp-type 0 -m state --state ESTABLISHED,RELATED -j ACCEPT
