
port = "COM3";  
baud = 115200;
s = serialport(port, baud);  
configureTerminator(s,"LF");  
flush(s);

Fs  = 1e6/5000;                  % ≈200 Hz
nyq = Fs/2;

% Butterworth band‑pass
[bBP,aBP] = butter(2,[7 12]/nyq,'bandpass');
ordBP     = max(numel(aBP),numel(bBP))-1;
ziBP      = zeros(ordBP,3);      


[s1,F1] = audioread("crash.wav");    % instrument 1
[s2,F2] = audioread("assets_acoustic_ride.wav");   % instrument 2
[s3,F3] = audioread("assets_acoustic_tom.wav");                  % instrument 3
pool = 8;
p1 = arrayfun(@(~)audioplayer(s1,F1),1:pool,"uni",0);
p2 = arrayfun(@(~)audioplayer(s2,F2),1:pool,"uni",0);
p3 = arrayfun(@(~)audioplayer(s3,F3),1:pool,"uni",0);
[i1,i2,i3] = deal(1);


thr_high = 25;   
thr_low = 0;   
armedZ = true;
gyroThr  = 5;    
gyroDead = 2;     
instrument = 2;                    
armedGX   = true;                  


bufLen  = round(2*Fs);
dataBuf = zeros(bufLen,6);        
tBuf    = (0:bufLen-1)'/Fs;
cols    = [1 3 4];
h = plot(tBuf,dataBuf(:,cols));
ylim([-20 30]); 
grid on;
xlabel('Time (s)'); 
ylabel('Value');
legend({'ax\_f','az\_f','|gx|'},'Location','northeast');
title('Bandpass Z, X and raw gx');
yline(thr_high,'r--','Z Thr');


idx = 1;
while ishandle(h(1))
    v = sscanf(readline(s),"%f,")';        
    ax=v(1); ay=v(2); az=v(3);
    gx=v(6); gy=v(5); gz=v(4);


    if armedGX
        if gx >  gyroThr                      % snap right
            instrument = min(instrument+1,3);
            armedGX   = false;
        elseif gx < -gyroThr                 % snap left
            instrument = max(instrument-1,1);
            armedGX   = false;
        end
    elseif abs(gx) < gyroDead                % centred
        armedGX = true;
    end

    % bandpass
    [dataBuf(idx,1), ziBP(:,1)] = filter(bBP,aBP,ax,ziBP(:,1));
    [dataBuf(idx,2), ziBP(:,2)] = filter(bBP,aBP,ay,ziBP(:,2));
    [dataBuf(idx,3), ziBP(:,3)] = filter(bBP,aBP,az,ziBP(:,3));

    zFilt = dataBuf(idx,3);
    if  armedZ && zFilt > thr_high
        switch instrument
            case 1, play(p1{i1}); i1 = mod(i1,pool)+1;
            case 2, play(p2{i2}); i2 = mod(i2,pool)+1;
            case 3, play(p3{i3}); i3 = mod(i3,pool)+1;
        end
        armedZ = false;
    elseif ~armedZ && zFilt < thr_low
        armedZ = true;
    end

    % store only 
    dataBuf(idx,4:6) = [abs(gx) gy gz];   
    for k = 1:numel(cols)
        h(k).YData = dataBuf(:,cols(k));
    end

    idx = idx + 1;  if idx > bufLen, idx = 1; end
end

disp("Figure closed — loop ended.");
