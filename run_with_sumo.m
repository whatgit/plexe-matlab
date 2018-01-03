%MATLAB script for running with sumo-gui
%Define a role, either 'server' or 'client'
%If you are connecting to SUMO, choose 'client'
%If you are waiting for a connection, e.g. from Veins, choose 'server'
role = 'client';   
isSubscribed = false;
time = 0;
%Initilize traci connection
t = traci(8813, '0.0.0.0', role);
carOne = zeros(1,3);
%connect
fopen(t.connection);
fwrite(t.connection,t.step_packet)

while 1
   if t.connection.BytesAvailable ~= 0
       t.received_packet = fread(t.connection, t.connection.BytesAvailable);
       command = t.extract_command();
       if command == t.constants.cmd_step_simulation && length(t.received_packet) > 15
           t.current_index = 16;
           subscribed = typecast(uint8(fliplr(t.received_packet(12:15)')),'uint32');
           for i=1:subscribed
               [c1posX, c1posY, c1posLane, c1road_id, c1speed] = t.extract_sumo_subscription(t.current_index);
           end
       end
       if isSubscribed == false && time == 10
            t.subscribeToVehicleVariable('carOne')
            t.subscribeToVehicleVariable('carTwo')
            t.subscribeToVehicleVariable('carThree')
            isSubscribed = true;
       end
       fwrite(t.connection,t.step_packet)
       t.current_index = 0;
       time = time + 1;
   end
end
