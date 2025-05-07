
port = "COM3"; 
baud = 115200;
s = serialport(port, baud); 
configureTerminator(s,"LF"); 
flush(s);

Fs  = 1e6/5000;           
nyq = Fs/2;


%db2 filter
[~,Hi] = wfilters("db2","d");          
len    = numel(Hi)-1;                
zi     = zeros(len,3);                  

highThr = 10;    
lowThr  =  0.1;   
armed   = true;


[snd,Fs_snd] = audioread("assets_acoustic_tom.wav");
pool = 8;  
p = cell(pool,1);
for k = 1:pool 
    p{k} = audioplayer(snd,Fs_snd); 
end
ix = 1;


bufN   = round(2*Fs);
detBuf = zeros(bufN,3);                
tBuf   = (0:bufN-1).'/Fs;

h = plot(tBuf, detBuf);
ylim([0 15]);
xlabel('Time (s)'); 
ylabel('|db2 detail|');
legend({'ax_f','ay_f','az_f'},'Location','northeast');
yline(highThr,'r--','High');
yline(lowThr, 'g--','Low');


idx = 1;
while ishandle(h(1))
    v = sscanf(readline(s),"%f,")';         

    for k = 1:3
        [d, zi(:,k)]   = filter(Hi,1, v(k), zi(:,k));
        detBuf(idx,k)  = abs(d);
    end


    zEnv = detBuf(idx,3);
    if  armed && (zEnv > highThr)
        play(p{ix});  
        ix = mod(ix,pool)+1;
        armed = false;
    elseif ~armed && (zEnv < lowThr)
        armed = true;
    end


    for k = 1:3
        h(k).YData = detBuf(:,k);
    end

    idx = idx + 1;
    if idx > bufN 
        idx = 1; end
    end

disp("Figure closed — loop ended.");
