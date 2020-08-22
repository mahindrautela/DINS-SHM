clc
clear
%% Define the parameters
nfft = 4096*2;
T = 0.5e-6*nfft;
q = 120e3;
deltaT = T/nfft;
t = [0:nfft-1]/nfft;
time = t*T;

%% Define the signal
for j = 1:200
    z1(j) = 0;
end
for j = 201:300
    z1(j) = cos(2*pi*q*j*deltaT);
end
for j = 301:nfft
    z1(j) = 0;
end
z2 = z1(201:300);
H = hann(100);
z2 = z2.*H';
z = [z1(1:200) z2 z1(301:nfft)];

%% Plot of Time domain signal
figure(1);
plot(time,z,'-');
xlabel('Time(s)')
ylabel('F(t)');
grid on
% IP = [time' z'];
% xlim([0 3e-4])

%% FFT of forcing signal
P = fft(z,nfft);
P_real = real(P);
P_imag = imag(P);
P_mag = abs(P);
PP = P_mag(1:nfft/2);

%% FFT plot
freq = [0:nfft/2-1]/T;
figure(2)
plot(freq,PP,'o');
xlabel('Frequency (Hz)');
ylabel('F(w)');
grid on

%% FFT data for frequency domain processing as .mat file
freq1= (0:nfft-1)/(nfft*deltaT);
save ('Phforce.mat','freq1','P_real','P_imag');
checkfft = [freq1' P_real' P_imag'];

%% Inverse FFT plot (neccessary step to check ifft = signal)
xtime = (0:nfft-1)*deltaT;
Inv = ifft(P);
figure(3)
plot(time,z,'--o')
hold on
plot(xtime,Inv,'--*')
xlabel('Time(s)');
ylabel('|F(t)|');
legend('main signal','ifft')
xlim([0 3e-4])

data1 = freq1';
data2 = P_real';
data3 = P_imag';

%% Frequency Domain Data in File
fylname = strcat('f120');
f1 = fopen(fylname,'w');
for n = 1:length(data1)
    output = [data1(n),data2(n),data3(n)];
    fprintf(f1,'%13.4g  %13.4g  %13.4g\n', output);
end
fclose(f1);
