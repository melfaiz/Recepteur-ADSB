function [X, f] = Mon_Welch(x, Nfft, Fe)

f = linspace(-Fe/2,Fe/2,Nfft);

y = [];
nb_fft = 100;
for i=1:nb_fft
    x1 = x((i-1)*Nfft+1:i*Nfft);    % segmentation
    y =[ y; fftshift(fft(x1))]; % somme des fft
end

X = mean(abs(y).^2)/(Nfft*Fe);    % moy fft (DSP experimentale)

end

