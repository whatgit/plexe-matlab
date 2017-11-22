%Session 1: MATLAB Server

%Accept a connection from any machine on port 30000.
t = tcpip('0.0.0.0', 8855  , 'NetworkRole', 'server');

%Open a connection. This will not return until a connection is received.
display('waiting for connection')

fopen(t);

display('connected')
while 1
    if t.BytesAvailable > 0
        input = fread(t, t.BytesAvailable);
        display('creating a TraCI message to reply')
        packet = createSetSpeed(25,1,0);
        display('sending')
        fwrite(t,packet)
    else
    end
end


function copy_packet = createSetSpeed(speed, lane, intention)
    %Data format
    size = 0;
    cmd_size = 0;
    CMD_SET_VEHICLE_VAR = hex2dec('C4');
    VAR_SPEED = hex2dec('40');
    TYPE_DOUBLE = hex2dec('0B');
    
    copy_packet = [0;
                   0;
                   0;
                   25;
                   21;
                   hex2dec('C4');
                   hex2dec('40');
                   0;
                   hex2dec('0B');
                   hex2dec('40');
                   0;
                   0;
                   0;
                   0;
                   0;
                   0;
                   speed;
                   0;
                   0;
                   0;
                   lane;
                   0;
                   0;
                   0;
                   intention]
end

%copy_packet =
%[0;0;0;25;21;hex2dec('C4');hex2dec('40');0;hex2dec('0B');hex2dec('40');0;0;0;0;0;0;25;0;0;0;1;0;0;0;0]¨

