%% BBC Generate
% Nolan Pearce
% 7 July 2022
% This code attempts to follow Mike Collins's advice to generate, transmit,
% and decode a BBC code.

% 1. Get a random channel vector

N = 1024; %maximum BBC code word size
% mark density. ratio of number of marks to total packet size
% avoiding fragmenting messages for now

message = "hello";
bit_vector = zeros(N,1);

% 2. 32 -> 2048 frequency "blocks" depending on hardware limitations

% 3. Implement physical mechanism from REBUF
% 3a. "Encode messages into vectors of 1024 bits with mark density of 11
% percent"

% just ascii for now
message_bit = zeros(8*length(message),1);
char_vector = zeros(8,1);
message_vec = double(char(message));

for k=1:length(message_vec)
    bin_char = dec2bin(message_vec(k));
    for m = 1:7
        char_vector(m+1) = str2double(bin_char(m));
    end
    
    % Add leading zero to ascii
    location = (k-1)*8 + 1;
    message_bit((location:location+7),1) = char_vector; 
    % This part will determine our density
end

% Now, map this vector onto a 1024 vector

d = length(message_bit)/N; % mark density. ratio of number of
% marks to total packet size
factor = round(1/d);
% Stretch it out?

for k=1:length(message_bit)
    location = (k-1)*factor + 1;
    if message_bit(k) == 1
        bit_vector((location:location+(factor-1)),1) = ones(factor,1);
    elseif message_bit(k) == 0
        bit_vector((location:location+(factor-1)),1) = zeros(factor,1);
    end
end

% 3b. "This bit vector is used to generate the frequency tones transmitted
% by taking the IFFT of the bit vector." 

tone_vec = ifft(bit_vector); % returns time-based sequence?
hold on
plot(abs(real(tone_vec)))
plot(abs(imag(tone_vec)))
title("IFFT Tone Vector")
xlabel("Frequency")
ylabel("Amplitude")
hold off

% 3bi. Avoid DC tone in the baseband


% 3c. Generate transmission sequence for the tones:
% 3ci. Duplicate original vector


% 3cii. Flip the order of the bits

% 3ciii. prefix it to the original vector

transmit_vector = [tone_vec.' flip(tone_vec.')];

% 4. Shift to center transmission frequency and transmit


% 4. Choose 1/3 of frequencies blocks as marks - tones with random phase
% shifts

% 5. REBUF - set frame from BBC Encoder

% 6. Assign portion of BBC to frequency channel. No modulation, no carrier,
% and no synchronization.