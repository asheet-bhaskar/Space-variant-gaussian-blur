I = imread('Globe.pgm');
S = size(I);
sigma = zeros(S(1),S(2));

% Value of A and B
N = S(1);
sigma(1,1) = 0.01;
sigma(N/2,N/2) = 2.0;
A = 6.0;
B = (N^2/(2*log(A/sigma(1,1))));

% Sigma values for all pixels.

for i = 1:S(1)
    for j = 1:(S(2))
        sigma(i,j) = A*exp((-1)*(((i-1-(N/2))^2+(j-1-(N/2))^2)/B));
    end
end

% gaussian Matrix for Each Pixels

gauss = cell(S(1));
for i = 1:S(1)
    for j = 1:S(2)
      NN = 6*sigma(i,j)+1;
      NN = round(NN);
      if rem(NN,2)== 0
         NN = NN+1;
      end
      [x,y] = meshgrid(ceil(-NN/2):floor(NN/2), ceil(-NN/2):floor(NN/2));
      f=exp(-x.^2/(2*sigma(i,j)^2)-y.^2/(2*sigma(i,j)^2));
      f=f./sum(f(:));
      gauss{i,j} = f;
    end
end

% pixels By Pixels Convolution 

GB = zeros(S(1),S(2));
I1 = zeros(S(1)+10,S(2)+10);
I1(6:5+S(1),6:5+S(2)) = I;

for i = 1:S(1)
    for j = 1:S(2)
        temp1 = gauss{i,j};
        S1 = size(temp1);
        C = (S1+1)/2;
        p = i+5; q = j+5;
        temp2 = I1(p-(C(1)-1):p+(C(1)-1),q-(C(2)-1):q+(C(2)-1));
%         temp2,i,j,C
        Con = convolve(temp2,temp1);
        GB(i,j) = Con(C(1),C(2));
    
    end
end

GB = uint8(GB);

%subplot(1,2,1);
figure;
imshow(I);
%title('Original Image')

%subplot(1,2,2);
figure;
imshow(GB);
%title('Gaussian Space Variant Blurred Image')

