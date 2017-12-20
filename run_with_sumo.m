%Define a role, either 'server' or 'client'
%If you are connecting to SUMO, choose 'client'
%If you are waiting for a connection, e.g. from Veins, choose 'server'
role = 'client';   

%Initilize traci connection
t = traci(8888, '0.0.0.0', role);

%connect
fopen(t.connection)

fwrite(t.connection,t.step_packet)
while 1
   if t.connection.BytesAvailable ~= 0
       receive = fread(t.connection, t.connection.BytesAvailable)
   end
   %send a message for stepping a simulation, use this if connects to SUMO
   fwrite(t.connection,t.step_packet)
end

