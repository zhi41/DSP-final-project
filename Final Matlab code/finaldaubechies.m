
port = "COM3";  
baud = 115200;
s = serialport(port, baud);
configureTerminator(s,"LF");  
flush(s);

Fs = 1e6/5000;                     


[~,Hi] = wfilters("db2","d");       
len = numel(Hi) - 1;
ziAx = zeros(len,1);                
ziAz = zeros(len,1);                
ziHit= zeros(len,1);                


%same as before for settings 
zHigh = 10;    
zLow = 0.5;          
armedZ = true;
gyroThr  =  5;   
gyroDead =  2;   
instrument = 2;  
armedGX   = true;


[s1,F1] = audioread("crash.wav");    % instrument 1
[s2,F2] = audioread("assets_acoustic_ride.wav");   % instrument 2
[s3,F3] = audioread("assets_acoustic_tom.wav");                  % instrument 3
pool = 8;
p1 = arrayfun(@(~)audioplayer(s1,F1),1:pool,"uni",0);
p2 = arrayfun(@(~)audioplayer(s2,F2),1:pool,"uni",0);
p3 = arrayfun(@(~)audioplayer(s3,F3),1:pool,"uni",0);
[i1,i2,i3] = deal(1);              


bufN = round(2*Fs);
data = zeros(bufN,3);               
tBuf = (0:bufN-1)'/Fs;
h = plot(tBuf,data);
ylim([0 15]); 
grid on;
xlabel('Time (s)'); 
ylabel('|value|');
legend({'ax\_f','az\_f','|gx|'},'Location','northeast');
title('hit detection and gyrochange');
yline(zHigh,'r--','Z Thr','LabelHorizontalAlignment','left');
yline(gyroThr,'r--','gx Thr','LabelHorizontalAlignment','left');


idx = 1;
while ishandle(h(1))
    v = sscanf(readline(s),"%f,")';          
    ax = v(1);   az = v(3);   gx = v(6);     


    [dAx,ziAx] = filter(Hi,1,ax,ziAx); envAx = abs(dAx);
    [dAz,ziAz] = filter(Hi,1,az,ziAz); envAz = abs(dAz);
    envGx = abs(gx);                          

    
    if armedGX
        if gx >  gyroThr                     
            instrument = min(instrument+1,3);
            armedGX   = false;
        elseif gx < -gyroThr                
            instrument = max(instrument-1,1);
            armedGX   = false;
        end
    else                                     
        if abs(gx) < gyroDead               
            armedGX = true;
        end
    end

    %hit detection 
    [dZ,ziHit] = filter(Hi,1,az,ziHit);  zEnv = abs(dZ);
    if  armedZ && zEnv > zHigh
        switch instrument
            case 1, play(p1{i1}); i1 = mod(i1,pool)+1;
            case 2, play(p2{i2}); i2 = mod(i2,pool)+1;
            case 3, play(p3{i3}); i3 = mod(i3,pool)+1;
        end
        armedZ = false;
    elseif ~armedZ && zEnv < zLow
        armedZ = true;
    end


    data(idx,:) = [envAx envAz envGx];
    h(1).YData = data(:,1);
    h(2).YData = data(:,2);
    h(3).YData = data(:,3);

    idx = idx + 1;   if idx > bufN, idx = 1; end
end


