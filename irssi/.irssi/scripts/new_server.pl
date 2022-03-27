# Usage: /new servername
sub new_server {
   ## data -- server name.
   my ($data, $server, $witem) = @_;

   Irssi::command("win new hide");
   Irssi::command("win name ($data: status)");
   Irssi::command("win level all -msgs");
   Irssi::command("win server -sticky $data");
   Irssi::command("connect $data");
   }

Irssi::command_bind('new_server', 'new_server');
